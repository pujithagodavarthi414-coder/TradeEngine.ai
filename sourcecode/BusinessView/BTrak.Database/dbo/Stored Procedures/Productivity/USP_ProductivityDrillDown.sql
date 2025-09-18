--EXEC [dbo].[USP_ProductivityDrillDown] @OperationsPerformedBy = 'ac5a0bf0-ec78-4b6f-916d-b7d8dc1d9c56',@DateFrom = '2021-03-22T00:00:00.000Z',@DateTo = '2021-03-25T07:07:48.024Z',@FilterType = 'Company'
CREATE PROCEDURE [dbo].[USP_ProductivityDrillDown]
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
    SET @DateFrom = CONVERT(Date,ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE())))))
    SET @DateFrom1 = CONVERT(Date,DATEADD(day, -1,@DateFrom))
    SET @DateTo = CONVERT(Date,ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE())))
	SET @UserId = iif(@UserId IS NULL,@OperationsPerformedBy,@UserId)
	set @FilterType = iif(@FilterType is null,'Individual',@FilterType)
    DECLARE @dates TABLE([Date] datetime)
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
	DECLARE @UsersIds TABLE (Id UNIQUEIDENTIFIER)
    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
    WHILE(@DateFrom1 < @DateTo)
    BEGIN
     SELECT @DateFrom1 = CONVERT(Date,DATEADD(day, 1,@DateFrom1))
     INSERT INTO @dates 
     values (@DateFrom1)
    END
IF (@HavePermission = '1')
 BEGIN
   IF(@FilterType = 'Individual')
   BEGIN

   INSERT INTO @UsersIds VALUES (@UserId)

   END
   ELSE IF(@FilterType = 'Team')
   Begin

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

    select CONVERT(Date,[Date]) as [Date],   
           ISNULL(P.[ProductiveTime],0) AS ProductiveTime,
           ISNULL(UP.[UnproductiveTime],0) AS UnproductiveTime,
		   ISNULL(APP.ApplicationName,'-') AS MostUsedApplication,
           ISNULL((SELECT FirstName+' '+SurName AS [Name] FROM [User] AS u WHERE  u.Id IN (ISNULL(UP.UserId,P.UserId))),'-') AS [Name]
    FROM @dates AS Dates
        LEFT JOIN (select UnProductive/60000.0 as UnproductiveTime,
		                  UserId,
						  CreatedDateTime from UserActivityTimeSummary where UserId in (SELECT * FROM @UsersIds) )UP ON UP.CreatedDateTime = Dates.[Date]
        LEFT JOIN (SELECT Productive/60000.0 AS ProductiveTime,
		                  UserId,
						  CreatedDateTime from UserActivityTimeSummary where UserId in (SELECT * FROM @UsersIds) )P ON P.CreatedDateTime = Dates.[Date] and P.UserId=UP.UserId
        LEFT JOIN (select * from (SELECT CreatedDateTime,UserId,ISNULL(ApplicationName,'==Time Usage==') as ApplicationName,ROW_NUMBER() OVER(PARTITION BY CreatedDateTime,UserId  ORDER BY SpentTime DESC) AS RowNumberRank FROM UserActivityAppSummary 
		WHERE UserId in (select * FROM @UsersIds) and CONVERT(DATE,CreatedDateTime) between CONVERT(DATE,@DateFrom) 
		and CONVERT(DATE,@DateTo) and isapp=1)p where p.RowNumberRank =1 ) as APP on  App.CreatedDateTime = Dates.[Date] and APP.UserId = P.UserId

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