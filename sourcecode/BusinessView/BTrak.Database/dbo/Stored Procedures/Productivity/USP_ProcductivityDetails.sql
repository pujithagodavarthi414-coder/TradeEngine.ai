--EXEC [dbo].[USP_ProcductivityDetails] @OperationsPerformedBy = 'A9B7A906-906C-4B9F-ABF6-32ECD3F9C69B', @DateFrom = '2021-04-20',@DateTo = '2021-04-20',@FilterType='Team'

CREATE PROCEDURE [dbo].[USP_ProcductivityDetails]
(
@OperationsPerformedBy UNIQUEIDENTIFIER,
@DateFrom DATETIME = NULL,
@DateTo DATETIME = NULL,
@Date DATETIME = NULL,
@FilterType NVARCHAR(MAX) = NULL,
@UserId UNIQUEIDENTIFIER = NULL,
@LineManagerId UNIQUEIDENTIFIER = NULL,
@BranchId UNIQUEIDENTIFIER = NULL,
@RankbasedOn nvarchar(max) = NULL
)AS
BEGIN
 SET NOCOUNT ON
 SET  TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 BEGIN TRY
 DECLARE @Company UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
 SET @FilterType = IIF(@FilterType IS NULL,'Individual',@FilterType)
 SET @RankbasedOn = IIF(@RankbasedOn IS NULL,'Task',@RankbasedOn)
 SET @UserId = IIF(@UserId IS NULL,@OperationsPerformedBy,@UserId)
 SET @DateFrom = CONVERT(DATE,(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE()))))))
 SET @DateTo = CONVERT(DATE,(ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE()))))

 
 DECLARE @TeamMembers table(TeamMemberId UNIQUEIDENTIFIER)
 INSERT INTO @TeamMembers
 SELECT Id FROM [User] U
 JOIN Ufn_GetEmployeeReportedMembers(IIF(@LineManagerId IS NULL,@UserId,@LineManagerId),@Company) ERM ON ERM.ChildId = U.Id AND U.InActiveDateTime IS NULL AND U.IsActive = 1 group by Id
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
 DECLARE @Companymembers table(UserId UNIQUEIDENTIFIER)
 INSERT INTO @Companymembers
	SELECT E.UserId from Employee E
	JOIN [User] U On U.Id = E.UserId 
	where U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id= @UserId) AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL AND U.IsActive = 1

 DECLARE @TeamSize int = (select count(*) FROM @TeamMembers)
 DECLARE @CompanySize int = (select count(*) FROM @Companymembers)
 DECLARE @OfficeSize int = (select count(*) FROM @Branchmembers)


 DECLARE @UsersIds table(Id UNIQUEIDENTIFIER) 
IF(@FilterType = 'Individual')
	BEGIN
		INSERT INTO @UsersIds
		VALUES (@UserId)
	END
ELSE IF(@FilterType = 'Team')
	BEGIN
		INSERT INTO @UsersIds
		SELECT * FROM @TeamMembers
	END
ELSE IF(@FilterType = 'Branch')
	BEGIN
		INSERT INTO @UsersIds
		SELECT * FROM @Branchmembers
	END
ELSE IF(@FilterType = 'Company')
	BEGIN
		INSERT INTO @UsersIds
		SELECT * FROM @Companymembers
	END
DECLARE @ProductivityStatsTable table(UserId UNIQUEIDENTIFIER,Productivity FLOAT,Efficiency FLOAT,Utilization FLOAT,Predictabulity FLOAT,[no.ofBugs] INT,TaskProductivity FLOAT,CreatedDateTime DATETIME) 
				INSERT INTO @ProductivityStatsTable
				SELECT UserId,
					   AVG(Productivity)Productivity,
					   AVG(Efficiency)Efficiency,
					   AVG(Utilization)Utilization,
					   AVG(Predictabulity)Predictabulity,
					   AVG([no.ofBugs])[no.ofBugs],
					   AVG(TaskProductivity)TaskProductivity,
					   MAX(CreatedDateTime)CreatedDateTime
					   FROM ProductivityDashboardStats WHERE UserId IN(SELECT * FROM @UsersIds) AND CreatedDateTime  BETWEEN @DateFrom AND @DateTo group by userId,CreatedDateTime

IF(@FilterType <> 'Individual')
	BEGIN
		SELECT ROUND(AVG(Productivity),2) [Productivity],
			   ROUND(AVG(Efficiency),2)[Efficiency],
			   ROUND(AVG(Utilization),2)[Utilization],
			   ROUND(AVG(Predictabulity),2)[Predictability],
			   ISNULL(CASE
				    WHEN SUM(TaskProductivity) = 0 AND SUM(NoOfbugs) > 0 THEN 'Improve'
				    WHEN SUM(TaskProductivity) > 0 AND SUM(NoOfbugs) > 0 THEN 
						 CASE 
							 WHEN (SUM(NoOfbugs)/SUM(TaskProductivity))*100 >= (SELECT TOP 1 [Value] FROM [dbo].[CompanySETtings] WHERE [Key] = 'NoOfBugs' AND CompanyId = @Company) THEN 'Improve'
							 ELSE 'Good'
						 END
					WHEN SUM(TaskProductivity) = 0 AND SUM(NoOfbugs) = 0 THEN '-'
			   END,'-') AS Quality,
			   ISNULL(@TeamSize,0) AS Teamsize,
			   ISNULL(@CompanySize,0) as Companysize,
			   ISNULL(@OfficeSize,0) as Officesize
		 FROM(
		  SELECT AVG(ISNULL(Productivity,0)) [Productivity],
		AVG(ISNULL(Efficiency,0)) [Efficiency],
		AVG(ISNULL(Utilization,0)) [Utilization],
        AVG(ISNULL(Predictabulity,0)) [Predictabulity],
		SUM(ROUND(TaskProductivity/60.0,2))TaskProductivity,SUM([no.ofBugs])NoOfbugs
		FROM @ProductivityStatsTable WHERE userId IN (SELECT * FROM @UsersIds) AND CreatedDateTime between @DateFrom AND @DateTo group by CreatedDateTime)p 
	END
ELSE
	BEGIN
				SELECT ROUND(AVG(ISNULL(Productivity,0)),2) [Productivity],
			   ROUND(AVG(ISNULL(Efficiency,0)),2) [Efficiency],
			   ROUND(AVG(ISNULL(Utilization,0)),2) [Utilization],
			   ROUND(AVG(ISNULL(Predictabulity,0)),2) [Predictability],
			   ISNULL(TR.[Row],0) [TeamRank],
			   ISNULL(CASE
				    WHEN SUM(ROUND(TaskProductivity/60.0,2)) = 0 AND SUM([no.ofBugs]) > 0 THEN 'Improve'
				    WHEN SUM(ROUND(TaskProductivity/60.0,2)) > 0 AND SUM([no.ofBugs]) > 0 THEN 
						 CASE 
							 WHEN (SUM([no.ofBugs])/SUM(ROUND(TaskProductivity/60.0,2)))*100 >= (SELECT TOP 1 [Value] FROM [dbo].[CompanySETtings] WHERE [Key] = 'NoOfBugs' AND CompanyId = @Company) THEN 'Improve'
							 ELSE 'Good'
						 END
					WHEN SUM(ROUND(TaskProductivity/60.0,2)) = 0 AND SUM([no.ofBugs]) = 0 THEN '-'
			   END,'-') AS Quality,
			   ISNULL(@TeamSize,0) AS Teamsize,
			   ISNULL(OFR.[Row],0) AS [OfficeRank],
			   ISNULL(@OfficeSize,0) AS OfficeSize,
			   ISNULL(@CompanySize,0) as Companysize
		 FROM @ProductivityStatsTable P
		 INNER JOIN( SELECT TRT.[Row],TRT.Id FROM(
				    SELECT ROW_NUMBER() OVER(order by (CASE WHEN @RankbasedOn='Task' THEN PDS.Efficiency
				   											 WHEN @RankbasedOn='Time' THEN PDS.Productivity
				   										END) DESC) AS [Row],
				   	   Id,PDS.Efficiency,PDS.Productivity 
				   	   FROM [User] U INNER JOIN  @TeamMembers T ON T.TeamMemberId = U.Id  AND U.InActiveDateTime IS NULL
				   					 LEFT JOIN (SELECT AVG(Productivity) Productivity,AVG(Efficiency) Efficiency,userId
				   								FROM @ProductivityStatsTable WHERE CreatedDateTime  BETWEEN @DateFrom AND @DateTo
				   								GROUP BY userId
				   								) AS PDS ON PDS.userId = U.Id
				   		WHERE U.CompanyId = @Company)TRT 
				   WHERE TRT.Id=@UserId)TR ON TR.Id = P.userId
		 INNER JOIN( SELECT ORT.[Row],ORT.Id FROM(
		 SELECT ROW_NUMBER() OVER(order by (CASE WHEN @RankbasedOn='Task' THEN PDS.Efficiency
		 											 WHEN @RankbasedOn='Time' THEN PDS.Productivity
		 										END) DESC) AS [Row],
		 	   U.Id,PDS.Efficiency,PDS.Productivity 
		 	   FROM [User] U INNER JOIN  @Branchmembers T ON T.UserId = U.Id  AND U.InActiveDateTime IS NULL
		 					 LEFT JOIN (SELECT AVG(Productivity) Productivity,AVG(Efficiency) Efficiency,userId 
		 								FROM @ProductivityStatsTable WHERE CreatedDateTime  BETWEEN @DateFrom AND @DateTo
		 								GROUP BY userId
		 								) AS PDS ON PDS.userId = U.Id
		 		WHERE U.CompanyId = @Company)ORT 
		  WHERE ORT.Id=@UserId )OFR ON OFR.Id = P.userId
		  WHERE userId = @UserId AND CreatedDateTime BETWEEN @DateFrom AND @DateTo GROUP BY TR.[Row],OFR.[Row]
	END
END TRY
BEGIN CATCH
THROW
END CATCH
END
GO