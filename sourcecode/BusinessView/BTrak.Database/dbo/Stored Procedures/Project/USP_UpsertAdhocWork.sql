  
-------------------------------------------------------------------------------  
-- Author       Ranadheer Rana Velaga  
-- Created      '2019-06-15 00:00:00.000'  
-- Purpose      To Save or Update the AdocWork  
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved  
-------------------------------------------------------------------------------  
--EXEC USP_UpsertAdhocWork @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryName='Test'  
-------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE [dbo].[USP_UpsertAdhocWork]  
(  
  @UserStoryId UNIQUEIDENTIFIER = NULL,  
  @UserStoryName NVARCHAR(800) = NULL,  
  @UserStoryStatusId UNIQUEIDENTIFIER = NULL,   
  @EstimatedTime DECIMAL(18,2) = NULL,  
  @DeadLineDate DATETIMEOFFSET = NULL,  
  @OwnerUserId UNIQUEIDENTIFIER = NULL ,  
  @DependencyUserId UNIQUEIDENTIFIER = NULL,  
  @Order INT = NULL,  
  @IsArchived BIT = NULL,  
  @ArchivedDateTime DATETIME = NULL,  
  @UserStoryTypeId UNIQUEIDENTIFIER = NULL,  
  @ParkedDateTime DATETIME = NULL,  
  @ProjectFeatureId UNIQUEIDENTIFIER = NULL,  
  @UserStoryPriorityId UNIQUEIDENTIFIER = NULL,  
  @ReviewerUserId UNIQUEIDENTIFIER = NULL,  
  @ParentUserStoryId UNIQUEIDENTIFIER = NULL,  
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,  
  @Description NVARCHAR(MAX) = NULL,  
  @CustomApplicationId UNIQUEIDENTIFIER = NULL,  
  @FormId UNIQUEIDENTIFIER = NULL,  
  @GenericFormSubmittedId UNIQUEIDENTIFIER = NULL,  
  @WorkspaceDashboardId UNIQUEIDENTIFIER = NULL,  
  @IsForQa BIT = NULL,  
  @TimeStamp TIMESTAMP = NULL,  
  @CompanyName NVARCHAR(250) = NULL,  
  @VersionName NVARCHAR(250) = NULL,  
  @TimeZone NVARCHAR(250) = NULL,  
  @IsInductionGoal BIT = NULL,  
  @IsExitGoal BIT = NULL,  
  @ReferenceId UNIQUEIDENTIFIER = NULL,  
  @ReferenceTypeId UNIQUEIDENTIFIER = NULL,  
  @IsWorkflowStatus BIT = NULL,  
  @FileIds NVARCHAR(MAX) = NULL  
)  
AS  
BEGIN  
       SET NOCOUNT ON  
       BEGIN TRY  
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
       DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))  
    SET @HavePermission = '1'  
       IF(@CompanyName = '')SET @CompanyName = NULL  
       IF(@HavePermission = '1' OR @CompanyName IS NOT NULL)  
       BEGIN  
       IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL  
       IF (@UserStoryId = '00000000-0000-0000-0000-000000000000') SET @UserStoryId = NULL  
       IF (@OwnerUserId = '00000000-0000-0000-0000-000000000000') SET @OwnerUserId = NULL  
       IF (@DependencyUserId = '00000000-0000-0000-0000-000000000000') SET @DependencyUserId = NULL  
       IF (@UserStoryTypeId = '00000000-0000-0000-0000-000000000000') SET @UserStoryTypeId = NULL  
       IF (@ProjectFeatureId = '00000000-0000-0000-0000-000000000000') SET @ProjectFeatureId = NULL  
       IF (@ReviewerUserId = '00000000-0000-0000-0000-000000000000') SET @ReviewerUserId = NULL  
       IF (@UserStoryPriorityId = '00000000-0000-0000-0000-000000000000') SET @UserStoryPriorityId = NULL  
       IF (@ParentUserStoryId = '00000000-0000-0000-0000-000000000000') SET @ParentUserStoryId = NULL  
       IF (@CustomApplicationId = '00000000-0000-0000-0000-000000000000') SET @CustomApplicationId = NULL  
    IF (@FormId = '00000000-0000-0000-0000-000000000000') SET @FormId = NULL  
       IF (@GenericFormSubmittedId = '00000000-0000-0000-0000-000000000000') SET @GenericFormSubmittedId = NULL  
       IF (@WorkspaceDashboardId = '00000000-0000-0000-0000-000000000000') SET @WorkspaceDashboardId = NULL  
       IF (@Description = '') SET @Description = NULL  
       IF (@UserStoryName = '') SET @UserStoryName = NULL  
    IF(@IsInductionGoal IS NULL) SET @IsInductionGoal = 0  
    DECLARE @RtId UNIQUEIDENTIFIER  
       IF(@UserStoryName IS NULL)  
       BEGIN  
           
         RAISERROR(50011,16,1)  
       END  
       ELSE  
       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))  
     IF(@ReferenceTypeId = 'BFB5614F-34DE-45C2-AEDA-A2B387FA35C6')   
    BEGIN  
   IF EXISTS(SELECT Id FROM AuditCompliance WHERE Id = @ReferenceId)  
    BEGIN  
    SET @RtId = '98A3A24D-BE04-4A12-8E48-73648A0507FB'  
    SET @UserStoryName = 'Audit :' + (SELECT AuditName FROM AuditCompliance WHERE Id = @ReferenceId)  + '. ' + @UserStoryName  
    END  
   ELSE IF EXISTS(SELECT Id FROM AuditConduct WHERE Id = @ReferenceId)  
   BEGIN  
    SET @RtId = '6A752767-347B-4E6C-8F73-4E3FA9BF0ACC'  
    SET @UserStoryName = 'Conduct :' + (SELECT AuditConductName FROM AuditConduct WHERE Id = @ReferenceId) + '. '  + @UserStoryName  
    END  
   ELSE IF EXISTS(SELECT Id FROM AuditQuestions WHERE Id = @ReferenceId)  
   BEGIN  
    SET @RtId = 'D8C4322A-7041-473A-A4B1-3608B260A5B7'  
    SET @UserStoryName = 'AuditQuestion :' + (SELECT QuestionName FROM AuditQuestions WHERE Id = @ReferenceId)+ '. '  + @UserStoryName  
    END  
   ELSE IF EXISTS(SELECT Id FROM AuditConductQuestions WHERE Id = @ReferenceId)  
   BEGIN  
    SET @RtId = 'C6BA92FE-B4A5-4082-B513-9FDCA29610B8'  
    SET @UserStoryName = 'AuditConductQuestion :' + (SELECT QuestionName FROM AuditConductQuestions WHERE Id = @ReferenceId)+ '. '  + @UserStoryName  
    END  
    END  
    ELSE   
    BEGIN  
    SET @RtId = @ReferenceTypeId  
    END  
       IF(@CompanyName IS NOT NULL)  
       BEGIN  
       SET @CompanyId = (SELECT Id FROM Company WHERE CompanyName = @CompanyName AND InActiveDateTime IS NULL)  
       END  
       DECLARE @UserStoryIdCount INT = (SELECT COUNT(1) FROM UserStory WHERE Id = @UserStoryId)  
       IF(@UserStoryIdCount = 0 AND @UserStoryId IS NOT NULL)  
       BEGIN  
         RAISERROR(50002,16,1,'UserStory')  
       END  
       ELSE IF (@EstimatedTime < 0)  
       BEGIN  
         
            RAISERROR('EstimateCanNotBeNegativeOrZero',11,1)  
         
       END  
         
       ELSE  
       BEGIN  
       DECLARE @IsLatest BIT = (CASE WHEN @UserStoryId IS NULL THEN 1 ELSE CASE WHEN (SELECT Id FROM UserStory WHERE Id = @UserStoryId) =@UserStoryId  THEN 1 ELSE 0 END END)  
         
       IF(@IsLatest = 1)  
       BEGIN  
       DECLARE @IsValidOwner BIT = (CASE WHEN (@OwnerUserId IS  NULL OR (SELECT COUNT(1) FROM [User] WHERE Id = @OwnerUserId) > 0) THEN 1 ELSE 0 END)  
       IF(@IsValidOwner = '1')  
       BEGIN  
       DECLARE @ProjectId UNIQUEIDENTIFIER = NULL,@GoalId UNIQUEIDENTIFIER  
  
    DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL  
         
  SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone  
    
         DECLARE @Currentdate DATETIMEOFFSET =   dbo.Ufn_GetCurrentTime(@Offset)      
  
    IF(@IsInductionGoal = 1)  
     BEGIN  
  
  SET @ProjectId = (SELECT Id FROM [dbo].[Project] WHERE ProjectName = 'Induction project' AND CompanyId = @CompanyId)  
      
  SET @GoalId = (SELECT G.Id  
                                     FROM Goal G  
                                         INNER JOIN Project P On P.Id = G.ProjectId   
                                                    AND P.Id = @ProjectId AND P.CompanyId = @CompanyId  
                                     WHERE GoalName = 'Induction Goal')  
  
  END
  
   ELSE IF(@IsExitGoal = 1)  
     BEGIN  
  
  SET @ProjectId = (SELECT Id FROM [dbo].[Project] WHERE ProjectName = 'Exit project' AND CompanyId = @CompanyId)  
      
  SET @GoalId = (SELECT G.Id  
                                     FROM Goal G  
                                         INNER JOIN Project P On P.Id = G.ProjectId   
                                                    AND P.Id = @ProjectId AND P.CompanyId = @CompanyId  
                                     WHERE GoalName = 'Exit Goal')  
  
  END
  ELSE  
  BEGIN  
  
  SET @ProjectId = (SELECT Id FROM [dbo].[Project] WHERE ProjectName = 'Adhoc project' AND CompanyId = @CompanyId)  
      
  SET @GoalId = (SELECT G.Id  
                                     FROM Goal G  
                                         INNER JOIN Project P On P.Id = G.ProjectId   
                                                    AND P.Id = @ProjectId AND P.CompanyId = @CompanyId  
                                     WHERE GoalName = 'Adhoc Goal')  
  
  
  END  
  DECLARE @WorkFlowId UNIQUEIDENTIFIER  
  DECLARE @UserStoryStatusIdToDo UNIQUEIDENTIFIER  
  IF(@IsWorkflowStatus = 1)  
  BEGIN  
  SET @WorkFlowId  = (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Workflow status' AND CompanyId = @CompanyId)   
         
  SET @UserStoryStatusIdToDo  = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Todo' AND CompanyId = @CompanyId)  
  END  
  ELSE   
  BEGIN  
        SET @WorkFlowId  = (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Adhoc Workflow' AND CompanyId = @CompanyId)   
         
     SET @UserStoryStatusIdToDo  = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Todo' AND CompanyId = @CompanyId)  
    END  
  
        IF(@UserStoryTypeId IS NULL) SET @UserStoryTypeId = (SELECT Id FROM UserStoryType   
                                                             WHERE IsUserStory = 1   
                                                                  AND CompanyId = @CompanyId)  
          
        DECLARE @ActualDeadLineDate DATETIMEOFFSET = NULL,@ActualDeadLineDateTimeZoneId UNIQUEIDENTIFIER= NULL  
    
  SELECT @ActualDeadLineDate = ActualDeadLineDate,@ActualDeadLineDateTimeZoneId = ActualDeadLineDateTimeZone FROM UserStory WHERE Id = @UserStoryId  
          
         
          
       DECLARE @UserStoryNameCount INT = (SELECT COUNT(1) FROM UserStory WHERE UserStoryName = @UserStoryName   
                                           AND GoalId = @GoalId AND ArchivedDateTime IS NULL AND (Id <> @UserStoryId OR @UserStoryId IS NULL))  
        DECLARE @MaxOrderId INT = (SELECT ISNULL(Max([Order]),0) FROM UserStory WHERE GoalId = @GoalId)  
        DECLARE @OldUserStoryStatusId UNIQUEIDENTIFIER = (SELECT UserStoryStatusId FROM UserStory WHERE Id = @UserStoryId)  
              
        DECLARE @TaskStatusOrder INT = (SELECT [Order] FROM TaskStatus TS JOIN UserStoryStatus USS ON USS.TaskStatusId = TS.Id   
                                            AND USS.Id = @UserStoryStatusId AND USS.CompanyId = @CompanyId)  
        DECLARE @NewUserStoryStatusId UNIQUEIDENTIFIER = @UserStoryStatusId  
                              
        DECLARE @WorkflowEligibleStatusTransitionId UNIQUEIDENTIFIER = NULL  
        IF(@OldUserStoryStatusId <> @NewUserStoryStatusId)  
                              
                    SET @WorkflowEligibleStatusTransitionId = (SELECT Id FROM WorkflowEligibleStatusTransition   
                                                                              WHERE FromWorkflowUserStoryStatusId = @OldUserStoryStatusId   
                                                                                   AND ToWorkflowUserStoryStatusId = @NewUserStoryStatusId   
                                                                                   AND WorkflowId = @WorkFlowId AND CompanyId = @CompanyId  
                                                                                   AND InActiveDateTime IS NULL)  
        IF((@WorkflowEligibleStatusTransitionId IS NULL) AND (@NewUserStoryStatusId IS NOT NULL) AND (@OldUserStoryStatusId <> @NewUserStoryStatusId) AND @UserStoryId IS NOT NULL)  
                                  BEGIN  
                                    
                                       RAISERROR ('NotAnEligibleTransition',11, 1)  
                                    
                                  END  
                                  ELSE  
                                  
                                  BEGIN  
                                        IF(@UserStoryStatusId IS NULL)   
                                        BEGIN  
                                            SET @UserStoryStatusId = (SELECT WS.UserStoryStatusId   
                                                                      FROM WorkflowStatus WS   
                                                                      WHERE WS.WorkflowId = @WorkFlowId AND WS.OrderId = 1 AND WS.CompanyId = @CompanyId AND WS.InActiveDateTime IS NULL)  
                                          
                                        END     
          END  
          IF(@UserStoryId IS NOT NULL)  
          BEGIN  
                                      
                EXEC [USP_InsertUserStoryAuditHistory] @UserStoryId = @UserStoryId,@UserStoryName = @UserStoryName,@EstimatedTime = @EstimatedTime,  
                @DeadLineDate = @DeadLineDate,@OwnerUserId = @OwnerUserId,@DependencyUserId = @DependencyUserId,@UserStoryPriorityId = @UserStoryPriorityId  
                ,@UserStoryStatusId = @UserStoryStatusId, @ParentUserStoryId = @ParentUserStoryId,@Description = @Description,@Order = @Order,@IsForQa = @IsForQa,  
                @ReviewerUserId = @ReviewerUserId ,@ProjectFeatureId = @ProjectFeatureId,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId  = @TimeZoneId  
  
    IF(@WorkspaceDashboardId IS NULL)  
     BEGIN  
      SET @WorkspaceDashboardId = (SELECT WorkspaceDashboardId FROM [UserStory] WHERE Id = @UserStoryId AND InactiveDateTime IS NULL)  
     END  
  
    DECLARE @OldUserStoryTypeId UNIQUEIDENTIFIER = (SELECT UserStoryTypeId FROM UserStory WHERE Id = @UserStoryId)  
    DECLARE @UserStoryUnique NVARCHAR(100) = (SELECT UserStoryUniqueName FROM UserStory WHERE Id= @UserStoryId)  
                UPDATE UserStory  
                SET [UserStoryName] = @UserStoryName,           
                [Description] = @Description,  
                [EstimatedTime] = @EstimatedTime,  
                [DeadLineDate] = @DeadLineDate,    
                [DeadLineDateTimeZone] = CASE WHEN @DeadLineDate IS NOT NULL THEN @TimeZoneId ELSE NULL END,    
                [OwnerUserId] = @OwnerUserId,  
                [DependencyUserId] = @DependencyUserId,  
                [Order] = @Order,  
                [UserStoryStatusId] = CASE WHEN @UserStoryStatusId IS NULL THEN @UserStoryStatusIdToDo ELSE @UserStoryStatusId END,  
                [UpdatedDateTime] = @CurrentDate,  
                [UpdatedByUserId] = @OperationsPerformedBy,  
    [UpdatedDateTimeZoneId] = @TimeZoneId,  
                [ActualDeadLineDate] = ISNULL(ActualDeadLineDate,@DeadLineDate),  
    [ActualDeadLineDateTimeZone] = CASE WHEN ActualDeadLineDate IS NOT NULL  THEN [ActualDeadLineDateTimeZone]  
                                          WHEN @DeadLineDate IS NOT NULL THEN @TimeZoneId END,  
                [ArchivedDateTime]= CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,  
                [UserStoryTypeId]= @UserStoryTypeId,  
                [ParkedDateTime] = @ParkedDateTime,  
                [ParkedDateTimeZoneId] = CASE WHEN  @ParkedDateTime IS NOT NULL THEN @TimeZoneId ELSE NULL END,  
                [UserStoryPriorityId] = @UserStoryPriorityId,  
                [ReviewerUserId] = @ReviewerUserId,  
                [ParentUserStoryId] = @ParentUserStoryId,  
                [WorkFlowId] = @WorkFlowId,  
                [IsforQa] = @IsForQa,  
                [VersionName] = @VersionName,  
                [CustomApplicationId] = @CustomApplicationId,   
    [FormId] = @FormId,  
                [GenericFormSubmittedId] = @GenericFormSubmittedId,  
    [WorkspaceDashboardId] = @WorkspaceDashboardId,  
    [ReferenceId] = @ReferenceId,  
    [ReferenceTypeId] = @RtId,  
    [UserStoryUniqueName] = CASE WHEN @OldUserStoryTypeId = @UserStoryTypeId THEN @UserStoryUnique ELSE ([dbo].[Ufn_GetUserStoryUniqueName](@UserStoryTypeId,@CompanyId)) END,  
                [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,  
                [InActiveDateTimeZoneId] = CASE WHEN @IsArchived = 1 THEN @TimeZoneId ELSE NULL END  
                WHERE Id = @UserStoryId  
  
    IF(@OldUserStoryTypeId <> @UserStoryTypeId)  
    BEGIN  
  
     IF(EXISTS(SELECT Id FROM Folder WHERE Id = @UserStoryId  AND InActiveDateTime IS NULL))  
     BEGIN  
  
      UPDATE [dbo].[Folder]  
        SET  [FolderName] =  [dbo].[Ufn_GetUserStoryUniqueName](@UserStoryTypeId,@CompanyId),  
          [UpdatedDateTime] = @Currentdate,  
          [UpdatedByUserId] = @OperationsPerformedBy  
      WHERE Id = @UserStoryId  
      
     END  
  
    END  
          END  
          ELSE   
          BEGIN  
            SET @UserStoryId = NEWID()  
              INSERT INTO UserStory([Id],  
                                    [GoalId],  
  [UserStoryName],  
                                    [Description],  
                                    [EstimatedTime],  
                                    [DeadLineDate],  
         [DeadLineDateTimeZone],  
                                    [OwnerUserId],  
                                    [DependencyUserId],  
                                    [Order],  
                                    [UserStoryStatusId],  
         [CreatedDateTimeZone],  
                                    [CreatedDateTime],  
                                    [CreatedByUserId],  
                                    [ActualDeadLineDate],  
         [ActualDeadLineDateTimeZone],  
                                    [ArchivedDateTime],  
                                    [UserStoryTypeId],  
                                    [ParkedDateTime],  
         [ParkedDateTimeZoneId],  
                                    [UserStoryPriorityId],    
                                    [ReviewerUserId],   
                                    [ParentUserStoryId],   
                                    [WorkFlowId],  
                                    [InActiveDateTime],  
         [InActiveDateTimeZoneId],  
                                    [UserStoryUniqueName],  
                                    [IsForQa],  
                                    [CustomApplicationId],  
         [FormId],  
                                    [GenericFormSubmittedId],  
                                    [VersionName],  
                                    [WorkspaceDashboardId],  
         [ProjectId],  
         [ReferenceId],  
         [ReferenceTypeId]    
                                  )  
                             SELECT @UserStoryId,  
                                    @GoalId,  
                                    @UserStoryName,  
                                    @Description,  
                                    @EstimatedTime,  
                                    @DeadLineDate,   
         CASE WHEN @DeadLineDate IS NOT NULL THEN @TimeZoneId ELSE NULL END,  
                                    @OwnerUserId,  
                                    @DependencyUserId,  
                                    @MaxOrderId + 1,  
                                    CASE WHEN @UserStoryStatusId IS NULL THEN @UserStoryStatusIdToDo ELSE @UserStoryStatusId END,  
         @TimeZoneId,  
                                    @CurrentDate,  
                                    @OperationsPerformedBy,  
                                    @DeadLineDate,  
         CASE WHEN @DeadLineDate IS NOT NULL THEN @TimeZoneId ELSE NULL END,  
                                    CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,  
                                    @UserStoryTypeId,  
                                    @ParkedDateTime,  
         CASE WHEN @ParkedDateTime IS NOT NULL THEN @TimeZoneId ELSE NULL END,  
                                    @UserStoryPriorityId,  
                                    @ReviewerUserId,  
                                    @ParentUserStoryId,  
                                    @WorkFlowId,  
                                    CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,  
                                    CASE WHEN @IsArchived = 1 THEN @TimeZoneId ELSE NULL END,  
                                    [dbo].[Ufn_GetUserStoryUniqueName](@UserStoryTypeId,@CompanyId),  
                                    @IsForQa,  
                                    @CustomApplicationId,  
                                    @FormId,  
         @GenericFormSubmittedId,  
                                    @VersionName,  
                                    @WorkspaceDashboardId,  
         @ProjectId,  
         @ReferenceId,  
         @RtId  
  
 IF(@ReferenceTypeId = 'BFB5614F-34DE-45C2-AEDA-A2B387FA35C6')   
    BEGIN  
   IF EXISTS(SELECT Id FROM AuditCompliance WHERE Id = @ReferenceId)  
    BEGIN  
    UPDATE UserStory SET ReferenceTypeId = '98A3A24D-BE04-4A12-8E48-73648A0507FB'  WHERE Id = @UserStoryId  
    END  
   ELSE IF EXISTS(SELECT Id FROM AuditConduct WHERE Id = @ReferenceId)  
   BEGIN  
    UPDATE UserStory SET ReferenceTypeId = '6A752767-347B-4E6C-8F73-4E3FA9BF0ACC'  WHERE Id = @UserStoryId  
    END  
   ELSE IF EXISTS(SELECT Id FROM AuditQuestions WHERE Id = @ReferenceId)  
   BEGIN  
    UPDATE UserStory SET ReferenceTypeId = 'D8C4322A-7041-473A-A4B1-3608B260A5B7' WHERE Id = @UserStoryId  
    END  
   ELSE IF EXISTS(SELECT Id FROM AuditConductQuestions WHERE Id = @ReferenceId)  
   BEGIN  
    UPDATE UserStory SET ReferenceTypeId = 'C6BA92FE-B4A5-4082-B513-9FDCA29610B8'  WHERE Id = @UserStoryId  
    END  
    END  
                                          
          IF(@FileIds IS NOT NULL AND @UserStoryId  IS NOT NULL)   
          BEGIN  
          INSERT INTO LinkedFilesForUserStory (  
                   Id,  
                   UserStoryId,  
                   FileIds,  
                   CreatedByUserId,  
                   CreatedDateTime  
                   )  
                  SELECT NEWID(),  
                  @UserStoryId,  
                  @FileIds,  
                  @OperationsPerformedBy,  
                  @Currentdate  
          END  
          INSERT INTO UserStoryHistory(  
                                                       Id,  
                                                      UserStoryId,  
                                                      FieldName,  
                                                      [Description],  
                                                      CreatedByUserId,  
               CreatedDateTimeZoneId,  
                                                      CreatedDateTime  
                                                     )  
                                              SELECT  NEWID(),  
                                                      @UserStoryId,  
                                                      'UserStoryAdded',  
                                                      'UserStoryAdded',  
                                                      @OperationsPerformedBy,  
               @TimeZoneId,  
                                                      @Currentdate  
                                     
              
          END  
          IF(@UserstoryNameCount > 0)  
          BEGIN  
              
                UPDATE UserStory SET UserStoryName = UserStoryName + '-' + UserStoryUniqueName  
                WHERE Id = @UserStoryId  
            
          END  
                  
             SELECT Id FROM UserStory WHERE Id = @UserStoryId  
        END  
        ELSE  
              
            RAISERROR(50002,16,1,'Owner')  
        END  
        ELSE  
            RAISERROR(50008,11,1)  
          
        END  
     END  
     ELSE  
        
         RAISERROR(@HavePermission,11,1)  
     END TRY  
     BEGIN CATCH  
        THROW  
    END CATCH  
END