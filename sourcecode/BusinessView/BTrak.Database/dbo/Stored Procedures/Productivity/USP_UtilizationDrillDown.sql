 --EXEC [dbo].[USP_UtilizationDrillDown] @OperationsPerformedBy = 'ac5a0bf0-ec78-4b6f-916d-b7d8dc1d9c56', @DateFrom = '3/1/2021',@DateTo = '3/22/2021',@FilterType = 'Company'
CREATE PROCEDURE [dbo].[USP_UtilizationDrillDown]
( 
 @OperationsPerformedBy UNIQUEIDENTIFIER,   
 @DateFrom datetime = null,
 @DateTo datetime = null,
 @Date datetime = null,
 @FilterType NVARCHAR(Max) = null,
 @UserId UNIQUEIDENTIFIER = null,
 @BranchId UNIQUEIDENTIFIER  = null,
 @LineManagerId UNIQUEIDENTIFIER = null
 ) as
 BEGIN
 SET NOCOUNT ON
 SET  TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 BEGIN TRY
   DECLARE @DateFrom1 DATETIME =NULL
   SET @UserId = iif(@UserId IS NULL,@OperationsPerformedBy,@UserId)
   SET @FilterType = iif(@FilterType is null,'Individual',@FilterType)
   SET @DateFrom = ISNULL(ISNULL(Convert(Date,@DateFrom),@Date),DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE()))))
   SET @DateFrom1 = CONVERT(Date,DATEADD(day, -1,@DateFrom))
   SET @DateTo = ISNULL(ISNULL(Convert(Date,@DateTo),@Date),EOMONTH(GETDATE()))
   DECLARE @dates TABLE([Date] datetime)
   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
   DECLARE @UsersIds TABLE (Id UNIQUEIDENTIFIER)
   WHILE(@DateFrom1 < @DateTo)
    BEGIN
     SELECT @DateFrom1 = CONVERT(Date,DATEADD(day, 1,@DateFrom1))
     INSERT INTO @dates 
     values (@DateFrom1)
    END
IF(@HavePermission = '1')
BEGIN
   IF(@FilterType = 'Individual')
   BEGIN

   INSERT INTO @UsersIds VALUES (@UserId)

   END
   ELSE IF(@FilterType = 'Team')
   BEGIN

   INSERT INTO @UsersIds  
SELECT Id FROM [User] U
 JOIN Ufn_GetEmployeeReportedMembers(IIF(@LineManagerId IS NULL,@UserId,@LineManagerId),@CompanyId) ERM ON ERM.ChildId = U.Id AND U.InActiveDateTime IS NULL AND U.IsActive = 1 group by Id

   END
   ELSE IF(@FilterType = 'Branch')
   BEGIN

	INSERT INTO @UsersIds  
  SELECT U.Id AS UserId
        	   FROM [User] U
        JOIN Employee E ON E.UserId = U.Id 
        JOIN [EmployeeBranch] EB ON EB.EmployeeId = E.Id AND EB.BranchId = iif(@BranchId IS NULL,(SELECT BranchId FROM [dbo].[EmployeeBranch] WHERE EmployeeId = (SELECT Id FROM Employee WHERE UserId= @UserId)),@BranchId)
        JOIN Branch B ON B.Id = EB.BranchId AND B.CompanyId = U.CompanyId
        where U.InActiveDateTime IS NULL 
			  AND U.IsActive = 1
        	  AND B.InActiveDateTime IS NULL
   END
   ELSE IF(@FilterType = 'Company')
   BEGIN

   INSERT INTO @UsersIds  
   	 SELECT E.UserId from Employee E
	JOIN [User] U On U.Id = E.UserId 
	where U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id= @UserId) AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL AND U.IsActive = 1


   END

   IF(@FilterType = 'Individual')
   BEGIN
          SELECT CONVERT(Date,Dates.[Date])[Date],
				 ISNULL(Round(UP.UtilizationPercentage,2),0) UtilizationPercentage,
				 ISNULL(UP.[Name],'-') AS [Name] FROM @dates AS Dates
		  LEFT JOIN( SELECT CONVERT(Date,CreatedDateTime) AS [Date],
                            AVG(ISNULL(Utilization,0)) AS UtilizationPercentage,
		                    (SELECT FirstName +' '+ SurName as [Name] FROM [USER] AS U WHERE U.Id = PDS.userId)as [Name] 
		  FROM ProductivityDashboardStats PDS 
          WHERE userId IN (SELECT * FROM @UsersIds) AND CreatedDateTime BETWEEN @DateFrom AND @DateTo GROUP BY CreatedDateTime,userId) UP ON UP.[Date] = Dates.[Date]  ORDER BY Dates.[Date]
   END
   ELSE
   BEGIN
          SELECT CONVERT(Date,Dates.[Date])[Date],
		         ISNULL(Round(UP.UtilizationPercentage,2),0) UtilizationPercentage FROM @dates AS Dates
		  LEFT JOIN (SELECT CONVERT(Date,AU.[Date]) AS [Date],
		         ISNULL(AVG(AU.UtilizationPercentage),0) AS UtilizationPercentage 
		  FROM ProductivityDashboardStats pds1 
			   INNER JOIN  (SELECT CreatedDateTime AS [Date],
                                   AVG(ISNULL(Utilization,0)) AS UtilizationPercentage,
								   userId FROM ProductivityDashboardStats PDS 
          WHERE userId IN (SELECT * FROM @UsersIds) AND Convert(Date,CreatedDateTime) BETWEEN @DateFrom AND @DateTo GROUP BY CreatedDateTime,Utilization,PDS.userId) AU on AU.[Date] = pds1.CreatedDateTime 
		        AND pds1.userId IN (SELECT * FROM @UsersIds)  GROUP BY AU.[Date]) UP ON UP.[Date] = Dates.[Date] ORDER BY Dates.[Date]
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