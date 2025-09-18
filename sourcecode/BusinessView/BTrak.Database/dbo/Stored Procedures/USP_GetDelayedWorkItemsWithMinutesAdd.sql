-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-01-32 00:00:00.000'
-- Purpose      To Get the delayed workitems
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetDelayedWorkItemsWithMinutesAdd] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@CompanyName= 'Snovasys Software Solutions',@Minutes=65

CREATE PROCEDURE [dbo].[USP_GetDelayedWorkItemsWithMinutesAdd]
(
  @CompanyName NVARCHAR(250) = NULL,
  @Minutes INT,
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
     SET NOCOUNT ON
	 BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 DECLARE @HavePermission NVARCHAR(250)  = 1---(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF (@HavePermission = '1')
	    BEGIN
		   
         SELECT US.Id UserStoryId,
				US.OwnerUserId,
                US.UserStoryName,
         		CAST(US.DeadLineDate AS datetime) DeadLineDate,
         		U.FirstName+' '+U.SurName OwnerUserName,
         		U.UserName Email,
         		P.ProjectName,
         		G.GoalName,
				U1.FirstName+' '+U1.SurName ProjectResponsiblePersonName,
				U1.UserName ProjectResponsiblePersonEmail
          FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
         						 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
         						 LEFT JOIN Goal G ON G.Id = US.GoalId 
                                        AND G.InActiveDateTime IS NULL  AND G.ParkedDateTime IS NULL
								 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
         						 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL  AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintEndDate IS NOT NULL AND (S.IsComplete = 0 OR S.IsComplete IS NULL)
								 INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN ('166DC7C2-2935-4A97-B630-406D53EB14BC','F2B40370-D558-438A-8982-55C052226581','6BE79737-CE7C-4454-9DA1-C3ED3516C7F0','5C561B7F-80CB-4822-BE18-C65560C15F5B')
         						 
         						 INNER JOIN [User]U ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL
								 INNER JOIN [User]U1 ON U1.Id= P.ProjectResponsiblePersonId AND U1.InActiveDateTime IS NULL
         						 WHERE P.Id  IN (SELECT ReferenceId FROM AutomatedWorkFlow AW INNER JOIN WorkflowTrigger WT ON WT.WorkflowId = AW.Id 
								                                                              INNER JOIN [Trigger]T ON T.Id = WT.TriggerId AND T.InactiveDateTime IS NULL
         						         AND AW.CompanyId = (SELECT Id FROM Company WHERE CompanyName = @CompanyName and InactiveDateTime is null) 
         						           AND WT.InactiveDateTime IS NULL AND AW.InactiveDateTime IS NULL
												     AND AW.WorkflowName ='Task Delay Explanation Task Creation WorkFlow'
												   AND T.TriggerName = 'TaskDelayNotificationTrigger'
												   AND WT.RefereceTypeId ='26A91CCF-504A-479C-8E8F-92128FB03AF6'
												   )
												   AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND DATEADD(MINUTE,@Minutes,CAST(US.DeadLineDate AS datetime)) < GETDATE()) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL) AND DATEADD(MINUTE,@Minutes,CAST(S.SprintEndDate AS datetime)) < GETDATE())
												   

	END	
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO
