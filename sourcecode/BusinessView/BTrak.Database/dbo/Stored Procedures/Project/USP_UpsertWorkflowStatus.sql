-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-006-25 00:00:00.000'
-- Purpose      To Save or Update the WorkflowStatus
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertWorkflowStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WorkFlowId='29728349-6950-4CD8-822C-138C2ABDBF9A',@IsArchived=0,@IsBlocked=0
 --,@UserStoryStatusIds=N'<?xml version="1.0" encoding="utf-16"?>
 --<GenericListOfGuid xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
 --    <ListItems><guid>A199BC2B-FD31-45C7-BE83-1092C2A53AC5</guid></ListItems>
 --</GenericListOfGuid>'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertWorkflowStatus]
(
  @WorkflowStatusId UNIQUEIDENTIFIER = NULL,
  @WorkFlowId UNIQUEIDENTIFIER = NULL,
  @UserStoryStatusIds  XML = NULL,
  @OrderId INT = NULL,
  @IsCompleted BIT = NULL,
  @IsArchived BIT = NULL,
  @CanAdd UNIQUEIDENTIFIER = NULL,
  @CanDelete UNIQUEIDENTIFIER = NULL,
  @IsBlocked BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeZone NVARCHAR(250) = NULL,
  @TimeStamp TIMESTAMP = NULL
 
)
AS
BEGIN
   SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
          DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
          IF (@HavePermission = '1')
          BEGIN
              
              IF (@IsArchived IS NULL) SET @IsArchived = 0
              DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			  DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
	          SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			

              DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)
              
              DECLARE @WorkFlowStatusIdCount INT = (SELECT COUNT(1) FROM WorkflowStatus WHERE Id = @WorkflowStatusId)
              
              DECLARE @WorkFlowEligibleStatusIdCount INT = (SELECT COUNT(1) FROM WorkflowEligibleStatusTransition WHERE (FromWorkflowUserStoryStatusId IN (SELECT UserStoryStatusId FROM WorkFlowStatus WHERE Id = @WorkFlowStatusId) OR ToWorkflowUserStoryStatusId IN (SELECT UserStoryStatusId FROM WorkFlowStatus WHERE Id = @WorkFlowStatusId)) AND WorkflowId = @WorkFlowId AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)
              
              IF(@CanAdd = '00000000-0000-0000-0000-000000000000') SET @CanAdd = NULL

		      IF(@CanDelete = '00000000-0000-0000-0000-000000000000') SET @CanDelete = NULL

              IF (@IsArchived = 1)
              BEGIN           
              
              DECLARE @UserStoriesCount INT = (SELECT COUNT(1) FROM UserStory US
                                                               JOIN Goal G ON G.Id = US.GoalId 
                                                               JOIN GoalWorkFlow GW ON GW.GoalId = G.Id AND GW.WorkflowId = @WorkFlowId
                                                               JOIN WorkflowStatus WFS ON WFS.WorkflowId = @WorkFlowId AND WFS.UserStoryStatusId = US.UserStoryStatusId 
                                                               AND WFS.Id = @WorkflowStatusId AND @WorkflowStatusId IS NOT NULL)
              END
              IF(@WorkFlowId IS NULL)
              BEGIN
              
                RAISERROR(50011,16, 2, 'WorkFlow')
              
              END
              ELSE IF (@IsArchived = 1 AND @UserStoriesCount > 0)
              BEGIN
                
                RAISERROR('UserStoriesExist',16,1)
              
              END
              ELSE IF(@WorkFlowStatusIdCount = 0 AND @WorkflowStatusId IS NOT NULL)
              BEGIN
              
                RAISERROR(50002,16, 1,'WorkFlowStatus')
              
              END
              ELSE IF(@WorkFlowEligibleStatusIdCount > 0 AND @IsArchived = 1)
              BEGIN
                    
                RAISERROR('PleaseRemoveDependenciesInWorkFlowEligibleTransition',11,1)
              
              END
              ELSE
              BEGIN
                IF (@WorkflowStatusId IS NOT NULL)
                BEGIN
                    DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp] FROM WorkflowStatus WHERE Id = @WorkflowStatusId) = @TimeStamp THEN 1 ELSE 0 END) 
                    
                    
                    IF (@IsArchived = 1)
                    BEGIN
                        
                        IF(((SELECT CanAdd FROM WorkflowStatus WHERE Id = @WorkflowStatusId) = 1) 
                             OR ((SELECT CanDelete FROM WorkflowStatus WHERE Id = @WorkflowStatusId) = 1))
                        BEGIN

                            RAISERROR('PleaseAssignPermissiontoAnotherStatusAndTryAgain',11,1)

                        END
                        ELSE
                        BEGIN

                            UPDATE WorkflowStatus SET InActiveDateTime = GETDATE()
							                         ,InActiveDateTimeZoneId = @TimeZoneId
                                                     ,UpdatedDateTime = GETDATE()
													 ,UpdatedDateTimeZoneId = @TimeZoneId
                                                     ,UpdatedByUserId = @OperationsPerformedBy
                                                     ,OrderId = @OrderId
                                                     WHERE Id = @WorkflowStatusId AND OrderId = @OrderId
                            UPDATE WorkflowStatus SET OrderId = OrderId -1 WHERE WorkflowId = @WorkFlowId AND OrderId >= @OrderId
                        
                        END
                    END
                    --IF (@WorkflowStatusId IS NOT NULL AND @OrderId IS NOT NULL)
                    --BEGIN
                    --    UPDATE WorkflowStatus SET [OrderId] = [OrderId] + 1 
                    --                          WHERE WorkflowId = @WorkFlowId 
                    --                            AND [OrderId] <= @OrderId
                        
                    --    UPDATE WorkflowStatus SET [OrderId] = @OrderId WHERE Id = @WorkflowStatusId
                    --END
                END
                ELSE IF(@CanAdd IS NOT NULL OR @CanDelete IS NOT NULL)
                BEGIN

                    IF(@CanAdd IS NOT NULL)
                    BEGIN
                        
                        SET @WorkflowStatusId = (SELECT Id FROM WorkflowStatus 
                                                 WHERE UserStoryStatusId = @CanAdd 
                                                        AND WorkflowId = @WorkFlowId AND InActiveDateTime IS NULL
                                                        AND CompanyId = @CompanyId)

                        UPDATE WorkflowStatus SET CanAdd = 1
                                                    ,UpdatedDateTime = GETDATE()
													,UpdatedDateTimeZoneId = @TimeZoneId
                                                    ,UpdatedByUserId = @OperationsPerformedBy
                                        WHERE Id = @WorkflowStatusId

                        UPDATE WorkflowStatus SET CanAdd = 0 WHERE Id <> @WorkflowStatusId AND CompanyId = @CompanyId 
                               AND  InActiveDateTime IS NULL AND WorkflowId = @WorkFlowId

                    END

                    IF(@CanDelete IS NOT NULL)
                    BEGIN
                        
                        SET @WorkflowStatusId = (SELECT Id FROM WorkflowStatus 
                                                 WHERE UserStoryStatusId = @CanDelete 
                                                        AND WorkflowId = @WorkFlowId AND InActiveDateTime IS NULL
                                                        AND CompanyId = @CompanyId)

                        UPDATE WorkflowStatus SET CanDelete = 1
                                                     ,UpdatedDateTime = GETDATE()
													 ,UpdatedDateTimeZoneId = @TimeZoneId
                                                     ,UpdatedByUserId = @OperationsPerformedBy
                                        WHERE Id = @WorkflowStatusId

                        UPDATE WorkflowStatus SET CanDelete = 0 WHERE Id <> @WorkflowStatusId AND CompanyId = @CompanyId 
                               AND  InActiveDateTime IS NULL AND WorkflowId = @WorkFlowId

                    END

                END
                ELSE
                IF (@UserStoryStatusIds IS NOT NULL)
                BEGIN
                 
                 DECLARE @Temp TABLE
                                   (
                                    Id INT IDENTITY(1,1),
                                    --WorkflowStatusId UNIQUEIDENTIFIER,
                                    UserStoryStatusId UNIQUEIDENTIFIER
                                   )
                 
                 INSERT INTO @Temp(UserStoryStatusId)
                 SELECT USS.Id FROM UserStoryStatus USS
                           JOIN (SELECT x.y.value('(text())[1]', 'varchar(100)') AS UserStoryStatusId
                                        FROM @UserStoryStatusIds.nodes
                                        ('/GenericListOfGuid/ListItems/guid') AS x(y)) I ON I.UserStoryStatusId = USS.Id
                           JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId 
                           --ORDER BY TS.[Order]
                    
                    DECLARE @MaxOrder INT = (SELECT MAX([OrderId]) FROM WorkflowStatus 
                                             WHERE WorkflowId = @WorkFlowId AND [CompanyId] = @CompanyId
                                                   AND InActiveDateTime IS NULL
                                             )
                   
    --            UPDATE @Temp SET WorkflowStatusId = WFS.Id 
    --            FROM WorkflowStatus WFS 
    --                 JOIN @Temp T ON T.UserStoryStatusId = WFS.UserStoryStatusId 
    --                      AND WFS.WorkflowId = @WorkFlowId
                
				--UPDATE WorkflowStatus 
    --                   SET OrderId = T.Id,UpdatedDateTime = GETDATE()
    --                   ,UpdatedByUserId = @OperationsPerformedBy
    --                   ,InActiveDateTime = NULL 
    --            FROM @Temp T JOIN WorkflowStatus WFS ON WFS.Id = T.WorkflowStatusId

				INSERT INTO [dbo].[WorkflowStatus](
                                                   [Id],
                                                   [WorkflowId],
                                                   [UserStoryStatusId],
                                                   [OrderId],
                                                   [CreatedDateTime],
												   [CreatedDateTimeZoneId],
                                                   [CreatedByUserId],
                                                   [CompanyId]
                                                  )
                                            SELECT NEWID(),
                                                   @WorkFlowId,
                                                   T.UserStoryStatusId,
                                                   ISNULL(@MaxOrder,0) + T.Id,
                                                   GETDATE(),
												   @TimeZoneId,
                                                   @OperationsPerformedBy,
                                                   @CompanyId
                                                   FROM @Temp T 
                                                   --WHERE WorkFlowStatusId IS NULL
                    
                    IF(NOT EXISTS(SELECT Id FROM WorkflowStatus WHERE WorkflowId  = @WorkFlowId AND CompanyId = @CompanyId AND InActiveDateTime IS NULL AND (CanAdd IS NOT NULL AND CanAdd = 1)))
                    BEGIN
                        
                        UPDATE WorkflowStatus SET CanAdd = 1 
                        WHERE OrderId = (SELECT MIN(OrderId) FROM WorkflowStatus 
                                         WHERE WorkflowId = @WorkflowId 
                                         AND InActiveDateTime IS NULL
                                         AND CompanyId = @CompanyId)
                              AND WorkflowId = @WorkFlowId AND CompanyId = @CompanyId

                    END
                    
                    IF(NOT EXISTS(SELECT Id FROM WorkflowStatus WHERE WorkflowId  = @WorkFlowId AND CompanyId = @CompanyId AND InActiveDateTime IS NULL AND (CanDelete IS NOT NULL AND CanDelete = 1)))
                    BEGIN

                        UPDATE WorkflowStatus SET CanDelete = 1 
                        WHERE OrderId = (SELECT MAX(OrderId) FROM WorkflowStatus 
                                         WHERE WorkflowId = @WorkflowId 
                                         AND InActiveDateTime IS NULL
                                         AND CompanyId = @CompanyId)
                              AND WorkflowId = @WorkFlowId AND CompanyId = @CompanyId
                    
                    END

                END
                
              END
          END
          ELSE
            RAISERROR(@HavePermission,11,1)
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END