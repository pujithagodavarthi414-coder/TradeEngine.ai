 --EXEC [dbo].[USP_NoOfBugsDrillDown] @OperationsPerformedBy = 'a9b7a906-906c-4b9f-abf6-32ecd3f9c69b', @DateFrom = '3/1/2021',@DateTo = '3/18/2021',@FilterType = 'Company'
Create PROCEDURE [dbo].[USP_NoOfBugsDrillDown]
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
   SET @UserId = iif(@UserId IS NULL,@OperationsPerformedBy,@UserId)
   SET @FilterType = iif(@FilterType is null,'Individual',@FilterType)
   SET @DateFrom = ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH, -1, DATEADD(DAY, 1, EOMONTH(GETDATE()))))
   SET @DateTo = ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE()))
   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
   DECLARE @UsersIds TABLE (Id UNIQUEIDENTIFIER)
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

    SELECT UserStoryUniqueName AS [TaskId],
	       UserStoryName AS [TaskName], 
		   ISNULL(bp.[Description],'-') AS [Priority],
		   IIF(st.SpentTimeInMin < 60,CAST(st.SpentTimeInMin AS NVARCHAR(50)) + 'm', CAST(CAST(ISNULL(st.SpentTimeInMin,0)/60.0 AS INT) AS VARCHAR(100))+'h'+IIF(CAST(ISNULL(cast(st.SpentTimeInMin As INT),0)%60 AS INT) = 0 ,'',CAST(CAST(ISNULL(cast(st.SpentTimeInMin As INT),0)%60 AS INT) AS VARCHAR(100))+'m')) [SpentHours] ,
		   IIF(st1.SpentTimeInMin < 60,CAST(st1.SpentTimeInMin AS NVARCHAR(50)) + 'm', CAST(CAST(ISNULL(st1.SpentTimeInMin,0)/60.0 AS INT) AS VARCHAR(100))+'h'+IIF(CAST(ISNULL(cast(st1.SpentTimeInMin As INT),0)%60 AS INT) = 0 ,'',CAST(CAST(ISNULL(cast(st1.SpentTimeInMin As INT),0)%60 AS INT) AS VARCHAR(100))+'m')) [OthersSpentHours],
           ISNULL((SELECT FirstName +' '+ SurName as [Name] FROM [USER] U WHERE U.Id = US.OwnerUserId),'-') AS [Name],
		   IIF(BCU.UserId <> US.OwnerUserId,(SELECT FirstName +' '+ SurName as [Name] FROM [USER] U WHERE U.Id = BCU.UserId),'-') AS BugCausedByUser 
	FROM   UserStory US 
	       LEFT JOIN BugPriority AS bp ON bp.Id = Us.BugPriorityId AND CompanyId = @CompanyId
		   LEFT JOIN BugCausedUser AS BCU ON BCU.UserStoryId = US.Id AND CONVERT(Date,BCU.CreatedDateTime) BETWEEN CONVERT(Date,@DateFrom) AND CONVERT(Date,@DateTo)
	       LEFT JOIN(SELECT SUM(SpentTimeInMin) as SpentTimeInMin,
	                 UserStoryId,
					 UserId from UserStorySpentTime Group By UserStoryId,UserId) as st on st.UserStoryId = Us.Id AND st.UserId = US.OwnerUserId
		   LEFT JOIN(SELECT SUM(SpentTimeInMin) as SpentTimeInMin,
	                 UserStoryId,
					 UserId from UserStorySpentTime Group By UserStoryId,UserId) as st1 on st1.UserStoryId = Us.Id AND st1.UserId <> US.OwnerUserId
    where UserStoryTypeId in (select Id from UserStoryType where IsBug = 1 AND CompanyId =@CompanyId) AND OwnerUserId IN (SELECT * FROM @UsersIds) 
	       AND CONVERT(Date,US.CreatedDateTime)  BETWEEN CONVERT(Date,@DateFrom) AND CONVERT(Date,@DateTo) GROUP BY UserStoryUniqueName,UserStoryName,bp.[Description],st.SpentTimeInMin,st1.SpentTimeInMin,Us.OwnerUserId,US.Id,BCU.UserId ORDER BY UserStoryUniqueName
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
