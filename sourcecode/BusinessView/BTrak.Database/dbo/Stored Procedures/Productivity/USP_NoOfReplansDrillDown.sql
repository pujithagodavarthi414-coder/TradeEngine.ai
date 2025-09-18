 --EXEC [dbo].[USP_NoOfReplansDrillDown] @OperationsPerformedBy = 'a9b7a906-906c-4b9f-abf6-32ecd3f9c69b', @DateFrom = '3/18/2021',@DateTo = '3/24/2021',@FilterType = 'Company'
CREATE PROCEDURE [dbo].[USP_NoOfReplansDrillDown]
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

  SELECT RC.TaskId,
	       RC.TaskName,
		   RC.EstimatedTime,
		   RC.SpentTimeInMin,
		   RC.OthersSpentTimeInMin,
		   RC.Approvedby,
		   RC.DeadLineDate,
		   RC.DoneDate,
		   RC.CurrentStatus,
		   COUNT(RC.NoOfReplans) AS NoOfReplans,
		   RC.UserName 
   FROM (SELECT US.UserStoryUniqueName as TaskId,
          US.UserStoryName as TaskName,  
          ISNULL(US.EstimatedTime,0) AS EstimatedTime,
          ISNULL(UST.SpentTimeInMin,0) AS SpentTimeInMin,
		  ISNULL(UST1.SpentTimeInMin,0) AS OthersSpentTimeInMin,
          IIF(USS1.Id IN( SELECT Id FROM UserStoryStatus WHERE TaskStatusId IN (SELECT Id FROM TaskStatus where [Order] IN(4,6))),AUN.ApprovedUserName,'-') AS [Approvedby],
          CONVERT(Date,US.DeadLineDate) AS DeadLineDate,
          IIF(USS1.Id IN( SELECT Id FROM UserStoryStatus WHERE TaskStatusId IN (SELECT Id FROM TaskStatus where [Order] IN(4,6))),CONVERT(Date,AUN.QaApprovedDate),NULL) as DoneDate,
          ISNULL(USS1.[Status],'-') AS CurrentStatus,
          COUNT(USR.UserStoryId) AS NoOfReplans,
          ISNULL((SELECT FirstName + ' '+ SurName AS [Name] FROM [User] AS U where U.Id = US.OwnerUserId),'-') AS [UserName] FROM UserStoryReplan USR 
		  INNER JOIN UserStory US ON US.Id = USR.UserStoryId and US.OwnerUserId IN (SELECT * FROM @UsersIds)
		  LEFT JOIN (SELECT Sum(SpentTimeInMin) AS SpentTimeInMin,
		                    InActiveDateTime,
						    UserId,
                            UserStoryId FROM UserStorySpentTime GROUP BY UserStoryId,InActiveDateTime,UserId) AS UST ON UST.UserStoryId = US.Id AND UST.UserId = US.OwnerUserId AND UST.InActiveDateTime IS NULL
          LEFT JOIN (SELECT Sum(SpentTimeInMin) AS SpentTimeInMin,
		                    InActiveDateTime,
						    UserId,
                            UserStoryId FROM UserStorySpentTime GROUP BY UserStoryId,InActiveDateTime,UserId) AS UST1 ON UST1.UserStoryId = US.Id AND UST1.UserId <> US.OwnerUserId AND UST1.InActiveDateTime IS NULL
         LEFT JOIN (SELECT USWST.UserStoryId,USN.FirstName +' '+ ISNULL(USN.SurName,'') ApprovedUserName,USN.ProfileImage,USN.Id ApprovedUserId,USWSTInner.QaApprovedDate FROM UserStoryWorkflowStatusTransition USWST 
			  INNER JOIN (SELECT US1.Id,MAX(USWST.CreatedDateTime) AS QaApprovedDate
		                    FROM Project P
		                      JOIN UserStory US1 ON US1.ProjectId = P.Id 
		                          AND  (US1.OwnerUserId IN (SELECT * FROM @UsersIds))
							       AND CONVERT(DATE,US1.UpdatedDateTime) BETWEEN CONVERT(DATE,@DateFrom) and CONVERT(DATE,@DateTo)
							  JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US1.Id AND USWST.InActiveDateTime IS NULL
							  JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId AND WEST.InActiveDateTime IS NULL 
							  JOIN UserStoryStatus USS ON USS.Id = WEST.ToWorkflowUserStoryStatusId AND USS.CompanyId = @CompanyId  
							  JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
							  JOIN [User] USN ON USN.Id = USWST.CreatedByUserId                                                                   
							  GROUP BY US1.Id) USWSTInner ON USWST.CreatedDateTime = USWSTInner.QaApprovedDate AND USWSTInner.Id = USWST.UserStoryId
				JOIN [User] USN ON USN.Id = USWST.CreatedByUserId
                GROUP BY USWST.UserStoryId,USN.FirstName +' '+ ISNULL(USN.SurName,''),USN.ProfileImage,USN.Id,USWSTInner.QaApprovedDate ) AUN ON AUN.UserStoryId = US.Id
         LEFT JOIN (SELECT Id,[Status] FROM UserStoryStatus) AS USS1 ON USS1.Id= US.UserStoryStatusId 
 	     LEFT JOIN Project P ON P.Id = US.ProjectId and P.InActiveDateTime is null
		 LEFT JOIN Goal G ON G.Id = US.GoalId and G.ParkedDateTime is null and G.InActiveDateTime is null
		 LEFT JOIN GoalStatus GS ON  GS.Id = G.GoalStatusId 
		 LEFT JOIN Sprints S On S.Id = Us.SprintId and S.InActiveDateTime is null
	WHERE CONVERT(DATE,USR.CreatedDateTime) BETWEEN CONVERT(DATE,@DateFrom) and CONVERT(DATE,@DateTo) AND ((us.SprintId IS NOT NULL AND S.Id IS NOT NULL) OR (us.GoalId IS NOT NULL)) 
	      GROUP BY USR.UserStoryId,USR.Id,US.UserStoryUniqueName,US.UserStoryName,US.EstimatedTime,UST.SpentTimeInMin,UST1.SpentTimeInMin,AUN.ApprovedUserName,US.DeadLineDate,AUN.QaApprovedDate,USS1.[Status],US.OwnerUserId,USS1.Id 
		  HAVING COUNT(USR.UserStoryId)>0 ) RC GROUP BY RC.Approvedby,RC.CurrentStatus,RC.DeadLineDate,RC.DoneDate,RC.EstimatedTime,RC.NoOfReplans,RC.SpentTimeInMin,RC.OthersSpentTimeInMin,RC.TaskId,RC.TaskName,RC.UserName ORDER BY RC.TaskId

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