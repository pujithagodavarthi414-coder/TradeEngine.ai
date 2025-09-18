CREATE PROCEDURE [dbo].[USP_GetActionsBasedOnAuditConductQuestion]
(
    @UserStoryId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @AuditConductQuestionId UNIQUEIDENTIFIER = NULL,
    @AuditConductId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            IF(@HavePermission = '1')
            BEGIN
            
               DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
               IF(@UserStoryId = '00000000-0000-0000-0000-000000000000') SET  @UserStoryId = NULL

			    SELECT US.Id AS UserStoryId,
                       US.UserStoryName,
                       U.FirstName + ' ' + ISNULL(U.SurName,'') AS OwnerName,
                       US.DeadLineDate,
                       US.GoalId,
					   US.SprintId,
					   US.UserStoryStatusId,
					   ACQ.Id,
					   US.UserStoryUniqueName,
					   USSS.[Status],
					   USSS.StatusHexValue,
                       US.CreatedByUserId,
                       US.CreatedDateTime,
                       US.[TimeStamp],
                       US.ParentUserStoryId,
                       BP.PriorityName BugPriorityName,
                       BP.Color BugPriorityColor,
                       BP.[Description] BugPriorityDescription,
                       BP.Icon BugPriorityIcon,
                       TotalCount = COUNT(1) OVER()
                  FROM [UserStory]US WITH (NOLOCK)
                       INNER JOIN [AuditConductQuestions] ACQ ON ACQ.Id IN (SELECT [value] FROM [dbo].[Ufn_StringSplit](US.AuditConductQuestionId,',')) AND (@AuditConductQuestionId IS NULL OR (ACQ.Id = @AuditConductQuestionId)) 
                                                             AND (@AuditConductId IS NULL OR ACQ.AuditConductId = @AuditConductId) AND ACQ.InActiveDateTime IS NULL
				       INNER JOIN UserStoryType UST  WITH(NOLOCK) ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL 
                                                                 AND US.ParkedDateTime IS NULL AND US.ArchivedDateTime IS NULL 
                                                                 AND UST.IsAction = 1 AND US.InActiveDateTime IS NULL
					   INNER JOIN [UserStoryStatus]USSS ON USSS.Id = US.UserStoryStatusId AND USSS.InactiveDateTime IS NULL
				       INNER JOIN [TaskStatus] TS ON TS.Id = USSS.TaskStatusId
                       INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL
                       LEFT JOIN [BugPriority]BP WITH(NOLOCK) ON BP.Id = US.BugPriorityId AND BP.InactiveDateTime IS NULL
                       LEFT JOIN [User] U WITH(NOLOCK) ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
                  WHERE UST.CompanyId = @CompanyId   
                         AND US.ProjectId IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                                      WHERE 
					                  UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
                        GROUP BY US.Id,US.UserStoryName,U.FirstName,U.SurName,US.DeadLineDate,US.GoalId,US.SprintId,US.CreatedByUserId,US.CreatedDateTime,US.[TimeStamp],US.ParentUserStoryId,US.UserStoryTypeId,BP.PriorityName,BP.Color,
			          	BP.[Description],BP.Icon,US.UserStoryStatusId,ACQ.Id,US.UserStoryUniqueName,USSS.[Status],USSS.StatusHexValue
				ORDER BY US.CreatedDateTime

				END
      ELSE
      BEGIN
      
           RAISERROR (@HavePermission,10, 1)
      
      END
    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO