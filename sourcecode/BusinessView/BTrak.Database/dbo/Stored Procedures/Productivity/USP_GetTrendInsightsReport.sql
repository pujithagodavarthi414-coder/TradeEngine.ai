--EXEC [dbo].[USP_GetTrendInsightsReport] @OperationsPerformedBy = 'a9b7a906-906c-4b9f-abf6-32ecd3f9c69b',@DateFrom = '2021-04-01',@DateTo = '2021-04-20',@FilterType = 'Team'
CREATE PROCEDURE [dbo].[USP_GetTrendInsightsReport]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @DateFrom DATETIME = NULL,
  @DateTo DATETIME = NULL,
  @date DATETIME = NULL,
  @FilterType NVARCHAR(MAX) = NULL,
  @UserId UNIQUEIDENTIFIER = NULL,
  @LinemanagerId UNIQUEIDENTIFIER = NULL,
  @BranchId UNIQUEIDENTIFIER = NULL,
  @RankbasedOn NVARCHAR(max) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    DECLARE @Company UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   SET @DateFrom = FORMAT((ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE()))))),'yyyy/MMM/dd', 'en-us')
		   SET @DateTo = FORMAT((ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE()))),'yyyy/MMM/dd', 'en-us')
		   SET @UserId = ISNULL(@UserId,@OperationsPerformedBy)
		   SET @FilterType = iif(@FilterType is null,'Individual',@FilterType)
		   SET @RankbasedOn = iif(@RankbasedOn is null,'Task',@RankbasedOn)
   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		
		DECLARE @Branchmembers table(UserId UNIQUEIDENTIFIER)
		INSERT INTO @Branchmembers
		 SELECT U.Id AS UserId
        	   FROM [User] U
        JOIN Employee E ON E.UserId = U.Id 
        JOIN [EmployeeBranch] EB ON EB.EmployeeId = E.Id AND EB.BranchId = iif(@BranchId IS NULL,(SELECT BranchId FROM [dbo].[EmployeeBranch] WHERE EmployeeId = (SELECT Id FROM Employee WHERE UserId= @UserId)),@BranchId)
        JOIN Branch B ON B.Id = EB.BranchId AND B.CompanyId = U.CompanyId
        where U.InActiveDateTime IS NULL 
			  AND U.IsActive = 1
        	  AND B.InActiveDateTime IS NULL
		DECLARE @TeamMembers TABLE(TeamMemberId UNIQUEIDENTIFIER)
		INSERT INTO @TeamMembers
		SELECT Id FROM [User] U
		JOIN Ufn_GetEmployeeReportedMembers(IIF(@LineManagerId IS NULL,@UserId,@LineManagerId),@Company) ERM ON ERM.ChildId = U.Id AND U.InActiveDateTime IS NULL AND U.IsActive = 1 group by Id


        DECLARE @dates TABLE([Date] datetime)  
			DECLARE @dateFrom1 datetime = DATEADD(day, -1,@DateFrom)
			WHILE(@dateFrom1 < @DateTo)
			BEGIN
			   SELECT @dateFrom1 = DATEADD(day, 1,@dateFrom1)
			   INSERT INTO @dates 
			   values (@dateFrom1)
			END

			DECLARE @UsersIds table(Id UNIQUEIDENTIFIER) 
			IF(@FilterType = 'Individual')
				BEGIN
					INSERT INTO @UsersIds
					VALUES (@UserId)
				END
			ELSE IF(@FilterType = 'Team')
				BEGIN
				   
					INSERT INTO @UsersIds
					SELECT TeamMemberId FROM @TeamMembers
				END
			ELSE IF(@FilterType = 'Branch')
				BEGIN
					
					INSERT INTO @UsersIds
					SELECT UserId FROM @Branchmembers
				END
			ELSE IF(@FilterType = 'Company')
				BEGIN
					
					INSERT INTO @UsersIds
						SELECT E.UserId from Employee E
						JOIN [User] U On U.Id = E.UserId 
						where U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id= @UserId) AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL AND U.IsActive = 1
				END

				DECLARE @ProductivityStatsTable table(UserId UNIQUEIDENTIFIER,Productivity FLOAT,Efficiency FLOAT,Utilization FLOAT,Predictabulity FLOAT,[no.ofBugs] INT,CreatedDateTime DATETIME) 
				INSERT INTO @ProductivityStatsTable
				SELECT UserId,
					   AVG(Productivity)Productivity,
					   AVG(Efficiency)Efficiency,
					   AVG(Utilization)Utilization,
					   AVG(Predictabulity)Predictabulity,
					   AVG([no.ofBugs])[no.ofBugs],
					   MAX(CreatedDateTime)CreatedDateTime
					   FROM ProductivityDashboardStats WHERE UserId IN(SELECT * FROM @UsersIds) AND CreatedDateTime  BETWEEN @DateFrom AND @DateTo group by userId,CreatedDateTime

			IF(@FilterType <> 'Individual')
				BEGIN
					SELECT [Date], ROUND(AVG(ISNULL(PDS.Productivity,0)),2) [Productivity],
								   ROUND(AVG(ISNULL(PDS.Efficiency,0)),2) [Efficiency],
								   ROUND(AVG(ISNULL(PDS.Utilization,0)),2) [Utilization],
								   ROUND(AVG(ISNULL(PDS.Predictabulity,0)),2) [Predictabulity]
					FROM @dates D
					LEFT JOIN(SELECT Productivity,Efficiency,Utilization,Predictabulity,CreatedDateTime FROM @ProductivityStatsTable WHERE userId IN (SELECT * FROM @UsersIds)) PDS ON PDS.CreatedDateTime = D.[Date]
					GROUP BY [Date] order by [Date]

				END
			ELSE
				BEGIN
					SELECT [Date], ROUND(AVG(ISNULL(PDS.Productivity,0)),2) [Productivity],
								   ROUND(AVG(ISNULL(PDS.Efficiency,0)),2) [Efficiency],
								   ROUND(AVG(ISNULL(PDS.Utilization,0)),2) [Utilization],
								   ROUND(AVG(ISNULL(PDS.Predictabulity,0)),2) [Predictabulity],
								   ISNULL(TR.[Row],0) [TeamRank],
								   ISNULL(OFR.[Row],0) AS [OfficeRank]
					FROM @dates D
					LEFT JOIN(SELECT Productivity,
									 Efficiency,
									 Utilization,
									 Predictabulity,
									 CreatedDateTime,
									 userId,[no.ofBugs] FROM @ProductivityStatsTable WHERE userId IN (@UserId)) PDS ON PDS.CreatedDateTime = D.[Date]		
					LEFT JOIN( SELECT TRT.[Row],TRT.Id FROM(
							   SELECT ROW_NUMBER() OVER(order by (CASE WHEN @RankbasedOn='Task' THEN PDS.Efficiency
							   										   WHEN @RankbasedOn='Time' THEN PDS.Productivity
							   									  END) DESC) AS [Row],
							   		  Id,PDS.Efficiency,PDS.Productivity 
							   FROM [User] U INNER JOIN @TeamMembers T ON T.TeamMemberId = U.Id  AND U.InActiveDateTime IS NULL
							   				 LEFT JOIN ( SELECT AVG(Productivity) Productivity,AVG(Efficiency) Efficiency,userId
							   							 FROM @ProductivityStatsTable WHERE CreatedDateTime  BETWEEN @DateFrom AND @DateTo
							   							 GROUP BY userId) AS PDS ON PDS.userId = U.Id
							   WHERE U.CompanyId = @Company)TRT 
							   WHERE TRT.Id=@UserId)TR ON TR.Id =PDS.userId
					LEFT JOIN( SELECT ORT.[Row],ORT.Id FROM(
							   SELECT ROW_NUMBER() OVER(order by (CASE WHEN @RankbasedOn='Task' THEN PDS.Efficiency
					 												   WHEN @RankbasedOn='Time' THEN PDS.Productivity
					 											  END) DESC) AS [Row],
					 				  U.Id,PDS.Efficiency,PDS.Productivity 
					 		   FROM [User] U INNER JOIN @Branchmembers T ON T.UserId = U.Id  AND U.InActiveDateTime IS NULL
					 						 LEFT JOIN (SELECT AVG(Productivity) Productivity,AVG(Efficiency) Efficiency,userId 
					 									FROM @ProductivityStatsTable WHERE CreatedDateTime  BETWEEN @DateFrom AND @DateTo
					 									GROUP BY userId
					 									) AS PDS ON PDS.userId = U.Id
					 		WHERE U.CompanyId = @Company)ORT 
					 WHERE ORT.Id=@UserId )OFR ON OFR.Id = PDS.userId
							   GROUP BY [Date],TR.[Row],OFR.[Row] order by [Date]
				END
		  END
		  ELSE 
          BEGIN
             RAISERROR (@HavePermission,11, 1)
          END
		END TRY  
	    BEGIN CATCH 
		    THROW
	   END CATCH
END
GO
