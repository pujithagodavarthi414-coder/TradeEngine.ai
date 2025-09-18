 --EXEC [dbo].[USP_NoOfBounceBacksDrillDown] @OperationsPerformedBy = 'A9B7A906-906C-4B9F-ABF6-32ECD3F9C69B', @DateFrom = '3//2021',@DateTo = '3/26/2021',@FilterType = 'Team'
CREATE PROCEDURE [dbo].[USP_NoOfBounceBacksDrillDown]
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
   declare @bouncebacksCount table(UserStoryId UNIQUEIDENTIFIER,countOfBouncBacks int)
   INSERT INTO @bouncebacksCount
     	     	SELECT US.Id,Count(US.id) FROM UserStory US 
									INNER JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id and CONVERT(DATE,USWST.CreatedDateTime) between CONVERT(DATE,@DateFrom) and CONVERT(DATE,@DateTo)
									INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId 
									INNER JOIN UserStoryStatus USS ON WEST.FROMWorkflowUserStoryStatusId = USS.Id AND USS.TaskStatusId IN ('5C561B7F-80CB-4822-BE18-C65560C15F5B','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')  
									INNER JOIN UserStoryStatus USS1 ON WEST.ToWorkflowUserStoryStatusId = USS1.Id AND USS1.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'
									WHERE US.OwnerUserId in (SELECT * FROM @UsersIds) AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL group by US.Id
	
  SELECT UserStoryUniqueName AS TaskId,
         UserStoryName AS TaskName,
		 ISNULL(SUM(EstimatedTime),0) AS EstimatedTime,
		 ISNULL(ST.SpentTimeInMin,0) SpentTimeInMin,
		 ISNULL(ST1.SpentTimeInMin,0) OthersSpentTimeInMin,
		 ISNULL(AUN.ApprovedUserName,'-') AS [ApprovedBy],
		 CONVERT(Date,DeadLineDate) AS DeadLineDate,
		 IIF(USS2.Id IN( SELECT Id FROM UserStoryStatus WHERE TaskStatusId IN (SELECT Id FROM TaskStatus where [Order] IN(3,6))),CONVERT(Date,AUN.QaApprovedDate),NULL) as DoneDate,
		 ISNULL(USS2.[Status],'-') AS CurrentStatus,
		 ISNULL(BBC.countOfBouncBacks,0) AS NoOfBounceBacks,
		 ISNULL((SELECT FirstName + ' '+SurName FROM [User] AS U WHERE U.Id = US.OwnerUserId),'-') AS UserName 
  FROM UserStory US 
                 LEFT JOIN UserStoryStatus AS USS2 ON USS2.Id= US.UserStoryStatusId
		   LEFT JOIN (SELECT USWST.UserStoryId,USN.FirstName +' '+ ISNULL(USN.SurName,'') ApprovedUserName,USN.Id ApprovedUserId,USWSTInner.QaApprovedDate FROM UserStoryWorkflowStatusTransition USWST 
			  INNER JOIN (SELECT PRO.Id,MAX(PRO.CreatedDateTime) AS QaApprovedDate
		                    FROM Project P 
		                      INNER JOIN (select ProjectId,OwnerUserId,MAX(USWST.CreatedDateTime) CreatedDateTime,USWST.CreatedByUserId,US1.Id from UserStory US1
							  JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US1.Id AND USWST.InActiveDateTime IS NULL
							  JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId AND WEST.InActiveDateTime IS NULL 
							  JOIN UserStoryStatus USS ON USS.Id = WEST.FromWorkflowUserStoryStatusId AND USS.CompanyId = @CompanyId   
							  JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (3,6)
							  JOIN UserStoryStatus USS1 ON USS1.Id = WEST.ToWorkflowUserStoryStatusId AND USS1.CompanyId = @CompanyId  
							  JOIN TaskStatus TS1 ON TS1.Id = USS1.TaskStatusId AND TS1.[Order] IN (2) GROUP BY ProjectId,OwnerUserId,USWST.CreatedByUserId,US1.Id)PRO ON PRO.ProjectId = P.Id AND  (PRO.OwnerUserId IN (SELECT * FROM @UsersIds))
							  AND CONVERT(DATE,PRO.CreatedDateTime) BETWEEN CONVERT(DATE,@DateFrom) and CONVERT(DATE,@DateTo)
							  JOIN [User] USN ON USN.Id = PRO.CreatedByUserId                                                                   
							  GROUP BY PRO.Id) USWSTInner ON USWST.CreatedDateTime = USWSTInner.QaApprovedDate AND USWSTInner.Id = USWST.UserStoryId
				JOIN [User] USN ON USN.Id = USWST.CreatedByUserId
                GROUP BY USWST.UserStoryId,USN.FirstName +' '+ ISNULL(USN.SurName,''),USN.Id,USWSTInner.QaApprovedDate ) AUN ON AUN.UserStoryId = US.Id
            LEFT JOIN(SELECT SUM(SpentTimeInMin) AS SpentTimeInMin,
				                  UserStoryId,
								  UserId FROM UserStorySpentTime Group By UserStoryId,UserId) AS ST ON ST.UserStoryId = US.Id AND ST.UserId = US.OwnerUserId 
            LEFT JOIN(SELECT SUM(SpentTimeInMin) AS SpentTimeInMin,
				                  UserStoryId,
								  UserId FROM UserStorySpentTime Group By UserStoryId,UserId) AS ST1 ON ST1.UserStoryId = US.Id AND ST1.UserId <> US.OwnerUserId 
		    INNER JOIN @bouncebacksCount BBC ON BBC.UserStoryId = US.Id
  WHERE US.OwnerUserId in (SELECT * FROM @UsersIds) and CONVERT(Date,AUN.QaApprovedDate) BETWEEN CONVERT(Date,@DateFrom) AND  CONVERT(Date,@DateTo) 
        GROUP BY US.Id,UserStoryUniqueName,UserStoryName,EstimatedTime,DeadLineDate,ST.SpentTimeInMin,ST1.SpentTimeInMin,AUN.QaApprovedDate,USS2.[Status],AUN.ApprovedUserName,US.OwnerUserId,USS2.Id,BBC.countOfBouncBacks


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