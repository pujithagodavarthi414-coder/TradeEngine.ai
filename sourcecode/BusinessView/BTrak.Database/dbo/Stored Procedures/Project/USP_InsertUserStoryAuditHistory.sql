CREATE PROCEDURE [dbo].[USP_InsertUserStoryAuditHistory]
(
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @UserStoryName NVARCHAR(800) = NULL,
  @GoalId UNIQUEIDENTIFIER = NULL,
  @EstimatedTime DECIMAL(18,2) = NULL,
  @DeadLineDate DATETIME = NULL,
  @OwnerUserId UNIQUEIDENTIFIER = NULL ,
  @TestSuiteSectionId UNIQUEIDENTIFIER = NULL ,
  @DependencyUserId UNIQUEIDENTIFIER = NULL,
  @UserStoryStatusId UNIQUEIDENTIFIER = NULL,
  @IsArchived BIT = NULL,
  @ArchivedDateTime DATETIME = NULL,
  @BugPriorityId UNIQUEIDENTIFIER = NULL,
  @UserStoryTypeId UNIQUEIDENTIFIER = NULL,
  @BugCausedUserId UNIQUEIDENTIFIER = NULL,
  @UserStoryPriorityId UNIQUEIDENTIFIER = NULL,
  @ParentUserStoryId UNIQUEIDENTIFIER = NULL,
  @Description NVARCHAR(MAX) = NULL,
  @Order INT = NULL,
  @ReviewerUserId UNIQUEIDENTIFIER = NULL,
  @IsParked BIT = NULL,
  @IsForQa BIT = NULL,
  @ParkedDateTime DATETIME = NULL,
  @ProjectFeatureId UNIQUEIDENTIFIER = NULL,
  @ActionCategoryId UNIQUEIDENTIFIER = NULL,
  @TimeZoneId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @VersionName NVARCHAR(250) = NULL,
  @SprintEstimatedTime DECIMAL(18,2) = NULL,
  @RAGStatus NVARCHAR(250) = NULL,
  @StartDate DATETIME = NULL
) 
AS
BEGIN
 SET NOCOUNT ON
 BEGIN TRY
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         DECLARE @OldUserStoryName NVARCHAR(800) = NULL

         DECLARE @OldGoalId UNIQUEIDENTIFIER = NULL

         DECLARE @OldEstimatedTime DECIMAL(18,2) = NULL

            DECLARE @OldDeadLineDate DATETIME = NULL

            DECLARE @OldStartDate DATETIME = NULL

            DECLARE @OldOwnerUserId UNIQUEIDENTIFIER = NULL
   
            DECLARE @OldIsForQa BIT = NULL 

            DECLARE @OldDependencyUserId UNIQUEIDENTIFIER = NULL

      DECLARE @OldUserStoryStatusId UNIQUEIDENTIFIER = NULL

      DECLARE @OldBugPriorityId UNIQUEIDENTIFIER = NULL

      DECLARE @OldUserStoryTypeId UNIQUEIDENTIFIER = NULL

      DECLARE @OldBugCausedUserId UNIQUEIDENTIFIER = NULL

      DECLARE @OldUserStoryPriorityId UNIQUEIDENTIFIER = NULL

      DECLARE @OldParentUserStoryId UNIQUEIDENTIFIER = NULL

      DECLARE @OldTestSuiteSectionId UNIQUEIDENTIFIER = NULL

      DECLARE @OldActionCategoryId UNIQUEIDENTIFIER = NULL

      DECLARE @OldOrder INT = NULL

      DECLARE @OldReviewerUserId UNIQUEIDENTIFIER = NULL

   DECLARE @OldProjectFeatureId UNIQUEIDENTIFIER = NULL

   DECLARE @OldDescription NVARCHAR(MAX) = NULL

   DECLARE @OldVersionName NVARCHAR(800) = NULL

   DECLARE @OldRAGStatus NVARCHAR(800) = NULL

   DECLARE @OldSprintEstimatedTime DECIMAL = NULL

      SELECT @OldUserStoryName = UserStoryName,@OldGoalId = GoalId,@OldEstimatedTime = EstimatedTime, @OldDeadLineDate = DeadLineDate, 
      @OldOwnerUserId = OwnerUserId ,@OldDependencyUserId = DependencyUserId, @OldUserStoryStatusId = UserStoryStatusId,
      @OldBugPriorityId = BugPriorityId,@OldUserStoryTypeId = UserStoryTypeId,@OldUserStoryPriorityId = UserStoryPriorityId,
      @OldParentUserStoryId = ParentUserStoryId , @OldDescription = [Description] ,@ArchivedDateTime = ArchivedDateTime,@OldIsForQa = IsForQa,@OldTestSuiteSectionId = TestSuiteSectionId
   ,@OldOrder = [Order],@OldReviewerUserId = ReviewerUserId,@ParkedDateTime = ParkedDateTime,@OldProjectFeatureId = ProjectFeatureId
   ,@OldVersionName = VersionName, @OldSprintEstimatedTime = SprintEstimatedTime,@OldRAGStatus = RAGStatus, @OldActionCategoryId = ActionCategoryId, @OldStartDate = StartDate
   FROM UserStory US WHERE Id = @UserStoryId
      
      SET @OldBugCausedUserId = (SELECT UserId FROM BugCausedUser WHERE UserStoryId = @UserStoryId AND InActiveDateTime IS NULL)
      
      DECLARE @UserStoryHistoryId UNIQUEIDENTIFIER = NEWID()

      DECLARE @Currentdate DATETIME = GETDATE()

      DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
      
         DECLARE @OldValue NVARCHAR(MAX)

      DECLARE @NewValue NVARCHAR(MAX)

      DECLARE @FieldName NVARCHAR(200)

      DECLARE @HistoryDescription NVARCHAR(800)
      
   IF(@OldUserStoryName <> @UserStoryName)
      BEGIN
         
          SET @OldValue = @OldUserStoryName

          SET @NewValue = @UserStoryName

          SET @FieldName = 'UserStoryName' 

          SET @HistoryDescription = 'UserStoryNameChange'
          
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END

      IF(@OldGoalId <> @GoalId)
      BEGIN
         
          SET @OldValue = (SELECT GoalName FROM Goal WHERE Id = @OldGoalId)

          SET @NewValue = (SELECT GoalName FROM Goal WHERE Id = @GoalId)

          SET @FieldName = 'GoalId' 

          SET @HistoryDescription = 'GoalChanged'  
          
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END
      
      IF(
       (@OldEstimatedTime <> @EstimatedTime 
            OR (@OldEstimatedTime IS NULL AND @EstimatedTime IS NOT NULL)
            OR (@OldEstimatedTime IS NOT NULL AND @EstimatedTime IS NULL)
      ))
      BEGIN
          IF(@OldEstimatedTime IS NOT NULL)
      BEGIN
        SET @OldValue = CONVERT(NVARCHAR(50), @OldEstimatedTime) + 'h'
      END
      ELSE
      BEGIN
        SET @OldValue = CONVERT(NVARCHAR(50), @OldEstimatedTime)
      END

      IF(@EstimatedTime IS NOT NULL)
      BEGIN
         SET @NewValue = CONVERT(NVARCHAR(50), @EstimatedTime) + 'h'
      END
      ELSE
      BEGIN
         SET @NewValue = CONVERT(NVARCHAR(50), @EstimatedTime)
      END
          SET @FieldName = 'EstimatedTime' 
    IF(@OldValue IS NULL)
    BEGIN 
      SET @HistoryDescription = 'EstimatedTimeAdded'  
    END
    ELSE IF(@NewValue IS NULL)
    BEGIN
       SET @HistoryDescription = 'EstimatedTimeRemoved'
    END
    ELSE
    BEGIN
     SET @HistoryDescription = 'EstimatedTimeChanged'
    END
          
          
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END

   IF(@SprintEstimatedTime <> 0.00 AND (@OldSprintEstimatedTime <> @SprintEstimatedTime OR (@OldSprintEstimatedTime IS NULL AND @SprintEstimatedTime IS NOT NULL)))
      BEGIN
         IF(@OldSprintEstimatedTime IS NOT NULL)
      BEGIN
        SET @OldValue = CONVERT(NVARCHAR(50), @OldSprintEstimatedTime) + 'SP'
      END
      ELSE
      BEGIN
        SET @OldValue = CONVERT(NVARCHAR(50), @OldSprintEstimatedTime)
      END

      IF(@SprintEstimatedTime IS NOT NULL)
      BEGIN
         SET @NewValue = CONVERT(NVARCHAR(50), @SprintEstimatedTime) + 'SP'
      END
      ELSE
      BEGIN
         SET @NewValue = CONVERT(NVARCHAR(50), @SprintEstimatedTime)
      END
         
         
          SET @FieldName = 'SprintEstimatedTime' 
    IF(@OldValue IS NULL)
    BEGIN 
      SET @HistoryDescription = 'SprintEstimatedTimeAdded'  
    END
    ELSE IF(@NewValue IS NULL)
    BEGIN
       SET @HistoryDescription = 'SprintEstimatedTimeRemoved'
    END
    ELSE
    BEGIN
     SET @HistoryDescription = 'SprintEstimatedTimeChanged'
    END
        
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END
      
      IF(@OldDeadLineDate <> @DeadLineDate OR (@OldDeadLineDate IS NULL AND @DeadLineDate IS NOT NULL))
      BEGIN
         
          SET @OldValue = ISNULL(CONVERT(NVARCHAR(500), FORMAT(@OldDeadLineDate,'dd/MM/yyyy HH:mm:ss')),'null')
          SET @NewValue = CONVERT(NVARCHAR(500), FORMAT(@DeadLineDate,'dd/MM/yyyy HH:mm:ss'))
          SET @FieldName = 'DeadLineDate' 
    IF(@OldValue = 'null')
    BEGIN 
      SET @HistoryDescription = 'DeadLineDateAdded'  
    END
    ELSE IF(@NewValue IS NULL)
    BEGIN
       SET @HistoryDescription = 'DeadLineDateRemoved'
    END
    ELSE
    BEGIN
     SET @HistoryDescription = 'DeadLineDateChanged'
    END
        
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END
      
      IF(@OldStartDate <> @StartDate OR (@OldStartDate IS NULL AND @StartDate IS NOT NULL))
      BEGIN
         
          SET @OldValue = ISNULL(CONVERT(NVARCHAR(500), FORMAT(@OldStartDate,'dd/MM/yyyy HH:mm:ss')),'null')
          SET @NewValue = CONVERT(NVARCHAR(500), FORMAT(@StartDate,'dd/MM/yyyy HH:mm:ss'))
          SET @FieldName = 'UserStoryStartDate' 
    IF(@OldValue = 'null')
    BEGIN 
      SET @HistoryDescription = 'UserStoryStartDateAdded'  
    END
    ELSE IF(@NewValue IS NULL)
    BEGIN
       SET @HistoryDescription = 'UserStoryStartDateRemoved'
    END
    ELSE
    BEGIN
     SET @HistoryDescription = 'UserStoryStartDateChanged'
    END
        
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy
      
      END

      IF(@OldOwnerUserId <> @OwnerUserId OR (@OldOwnerUserId IS NULL AND @OwnerUserId IS NOT NULL) OR (@OldOwnerUserId IS NOT NULL AND @OwnerUserId IS NULL))
      BEGIN
         
          SET @OldValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @OldOwnerUserId AND IsActive = 1)
          SET @NewValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @OwnerUserId AND IsActive = 1)
    SET @FieldName = 'OwnerUserName' 
    IF(@OldValue IS NULL)
    BEGIN
      SET @HistoryDescription = 'OwnerUserAdded'
    END
    ELSE IF(@NewValue IS NULL)
    BEGIN
       SET @HistoryDescription = 'OwnerUserRemoved'
    END
    ELSE
    BEGIN
      SET @HistoryDescription = 'OwnerUserChanged'
    END
         
          
         EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
         @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END
      
      IF(@OldDependencyUserId <> @DependencyUserId OR (@OldDependencyUserId IS NULL AND @DependencyUserId IS NOT NULL) OR (@OldDependencyUserId IS NOT NULL AND @DependencyUserId IS NULL))
      BEGIN
         
           SET @OldValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @OldDependencyUserId AND IsActive = 1)
           SET @NewValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @DependencyUserId AND IsActive = 1) 
     SET @FieldName = 'DependencyUserName' 
     IF(@OldValue IS NULL)
    BEGIN
      SET @HistoryDescription = 'DependencyUserAdded'
    END
    ELSE IF(@NewValue IS NULL)
    BEGIN
       SET @HistoryDescription = 'DependencyUserRemoved'
    END
    ELSE
    BEGIN
      SET @HistoryDescription = 'DependencyUserChanged'
    END
           
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END

    
      IF(@OldVersionName <> @VersionName OR (@OldVersionName IS NULL AND @VersionName IS NOT NULL) OR (@OldVersionName IS NOT NULL AND @VersionName IS NULL))
      BEGIN
         
      IF(@OldVersionName = '') SET @OldVersionName = NULL

           SET @OldValue = ISNULL(@OldVersionName,'null')
           SET @NewValue = @VersionName
     SET @FieldName = 'VersionName' 
     IF(@OldValue = 'null')
    BEGIN 
      SET @HistoryDescription = 'VersionNameAdded'  
    END
    ELSE IF(@NewValue IS NULL)
    BEGIN
       SET @HistoryDescription = 'VersionNameRemoved'
    END
    ELSE
    BEGIN
     SET @HistoryDescription = 'VersionNameChanged'
    END
           
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END
    IF(@OldRAGStatus <> @RAGStatus OR (@OldRAGStatus IS NULL AND @RAGStatus IS NOT NULL))
      BEGIN
         
      IF(@OldRAGStatus = '') SET @OldRAGStatus = NULL

           SET @OldValue = CASE WHEN @OldRAGStatus IS NULL THEN 'null' 
                          WHEN @OldRAGStatus = '#FF0000' THEN 'RED' 
           WHEN @OldRAGStatus = '#FFBF00' THEN 'AMBER' 
           WHEN @OldRAGStatus = '#00FF00' THEN 'GREEN' 
                     END
           SET @NewValue = CASE WHEN @RAGStatus IS NULL THEN 'null' 
                          WHEN @RAGStatus = '#FF0000' THEN 'RED' 
           WHEN @RAGStatus = '#FFBF00' THEN 'AMBER' 
           WHEN @RAGStatus = '#00FF00' THEN 'GREEN' 
                     END
     SET @FieldName = 'RAGStatus' 
           SET @HistoryDescription = 'RAGStatusChanged'
           
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END
      
      IF(@OldUserStoryStatusId <> @UserStoryStatusId OR (@OldUserStoryStatusId IS NULL AND @UserStoryStatusId IS NOT NULL))
      BEGIN
         
          SET @OldValue = (SELECT [Status] FROM UserStoryStatus WHERE Id = @OldUserStoryStatusId)
          SET @NewValue = (SELECT [Status] FROM UserStoryStatus WHERE Id = @UserStoryStatusId) 
          SET @FieldName = 'UserStoryStatus' 
          SET @HistoryDescription = 'UserStoryStatusChanged'  
          
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END

	   IF(@OldActionCategoryId <> @ActionCategoryId OR (@OldActionCategoryId IS NULL AND @ActionCategoryId IS NOT NULL) OR (@OldActionCategoryId IS NOT NULL AND @ActionCategoryId IS  NULL))
	   BEGIN
	   
	   SET @OldValue = NULL
	   SET @NewValue = NULL

	       IF(@OldActionCategoryId IS NULL AND @ActionCategoryId IS NOT NULL)
           BEGIN 
             SET @HistoryDescription = 'ActionCategoryAdded'  
           END
           ELSE IF(@OldActionCategoryId IS NOT NULL AND @ActionCategoryId IS NULL)
           BEGIN
              SET @HistoryDescription = 'ActionCategoryRemoved'
           END
           ELSE
           BEGIN
            SET @HistoryDescription = 'ActionCategoryChanged'
           END

	      SET @OldValue = (SELECT ActionCategoryName FROM ActionCategory WHERE Id  = @OldActionCategoryId)
	      SET @NewValue = (SELECT ActionCategoryName FROM ActionCategory WHERE Id  = @ActionCategoryId)

	      SET @FieldName = 'ActionCategory' 
          
          
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId

	   END

   IF(@OldTestSuiteSectionId <> @TestSuiteSectionId OR (@OldTestSuiteSectionId IS NULL AND @TestSuiteSectionId IS NOT NULL))
      BEGIN
         
          SET @OldValue = (SELECT SectionName FROM TestSuiteSection WHERE Id = @OldTestSuiteSectionId )
          SET @NewValue = (SELECT SectionName FROM TestSuiteSection WHERE Id = @TestSuiteSectionId ) 
          SET @FieldName = 'TestSuiteSection' 
    IF(@OldValue IS NULL)
    BEGIN 
      SET @HistoryDescription = 'TestSuiteSectionAdded'  
    END
    ELSE IF(@NewValue IS NULL)
    BEGIN
       SET @HistoryDescription = 'TestSuiteSectionRemoved'
    END
    ELSE
    BEGIN
     SET @HistoryDescription = 'TestSuiteSectionChanged'
    END
          
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END
      
      IF(@OldBugPriorityId <> @BugPriorityId OR (@OldBugPriorityId IS NULL AND @BugPriorityId IS NOT NULL) OR (@OldBugPriorityId IS NOT NULL AND @BugPriorityId IS NULL))
      BEGIN

           SET @OldValue = (SELECT PriorityName FROM BugPriority WHERE Id = @OldBugPriorityId)
           SET @NewValue = (SELECT PriorityName FROM BugPriority WHERE Id = @BugPriorityId)
           SET @FieldName = 'BugPriority' 
     IF(@OldValue IS NULL)
    BEGIN 
      SET @HistoryDescription = 'BugPriorityAdded'  
    END
    ELSE IF(@NewValue IS NULL)
    BEGIN
       SET @HistoryDescription = 'BugPriorityRemoved'
    END
    ELSE
    BEGIN
     SET @HistoryDescription = 'BugPriorityChanged'
    END
          
           EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
           @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
       END
      
      IF(@OldUserStoryTypeId <> @UserStoryTypeId OR (@OldUserStoryTypeId IS NULL AND @UserStoryTypeId IS NOT NULL))
      BEGIN

           SET @OldValue = (SELECT UserStoryTypeName FROM UserStoryType WHERE Id = @OldUserStoryTypeId)
           SET @NewValue = (SELECT UserStoryTypeName FROM UserStoryType WHERE Id = @UserStoryTypeId)
           SET @FieldName = 'UserStoryType' 
           SET @HistoryDescription = 'UserStoryTypeChanged'
           
           EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
           @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
       END
      
      IF(@OldBugCausedUserId <> @BugCausedUserId OR (@OldBugCausedUserId IS NULL AND @BugCausedUserId IS NOT NULL) OR (@OldBugCausedUserId IS NOT NULL AND @BugCausedUserId IS NULL))
      BEGIN

           SET @OldValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @OldBugCausedUserId AND IsActive = 1)
           SET @NewValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @BugCausedUserId AND IsActive = 1) 
     SET @FieldName = 'BugCausedUserName' 
      IF(@OldValue IS NULL)
    BEGIN 
      SET @HistoryDescription = 'BugCausedUserAdded'  
    END
    ELSE IF(@NewValue IS NULL)
    BEGIN
       SET @HistoryDescription = 'BugCausedUserRemoved'
    END
    ELSE
    BEGIN
     SET @HistoryDescription = 'BugCausedUserChanged'
    END
           
           EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
           @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
       END

   IF(@OldUserStoryPriorityId <> @UserStoryPriorityId OR (@OldUserStoryPriorityId IS NULL AND @UserStoryPriorityId IS NOT NULL))
      BEGIN

           SET @OldValue = (SELECT PriorityName FROM UserStoryPriority WHERE Id = @OldUserStoryPriorityId)
           SET @NewValue = (SELECT PriorityName FROM UserStoryPriority WHERE Id = @UserStoryPriorityId)
           SET @FieldName = 'UserStoryPriority' 
           SET @HistoryDescription = 'UserStoryPriorityChanged'  
           
           EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
           @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
       END

   IF(@OldParentUserStoryId <> @ParentUserStoryId OR (@OldParentUserStoryId IS NULL AND @ParentUserStoryId IS NOT NULL))
      BEGIN

           SET @OldValue = (SELECT UserStoryName FROM UserStory WHERE Id =  @OldParentUserStoryId)
           SET @NewValue = (SELECT UserStoryName FROM UserStory WHERE Id =  @ParentUserStoryId)
           SET @FieldName = 'ParentUserStoryName' 
           SET @HistoryDescription = 'ParentUserStoryChanged'  
           
           EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
           @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
       END

   IF(@OldDescription <> @Description OR (@OldDescription IS NULL AND @Description IS NOT NULL))
      BEGIN

           SET @OldValue = CONVERT(NVARCHAR(MAX), @OldDescription)
           SET @NewValue = CONVERT(NVARCHAR(MAX), @Description)
           SET @FieldName = 'Description' 
      IF(@OldValue IS NULL OR @OldValue = '')
    BEGIN 
      SET @HistoryDescription = 'UserStoryDescriptionAdded'  
    END
    ELSE IF(@NewValue IS NULL OR @NewValue = '')
    BEGIN
       SET @HistoryDescription = 'UserStoryDescriptionRemoved'
    END
    ELSE
    BEGIN
     SET @HistoryDescription = 'UserStoryDescriptionChanged'
    END
         
           EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
           @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
       END

   IF((@IsArchived = 1 AND @ArchivedDateTime IS NULL) OR (@IsArchived = 0 AND @ArchivedDateTime IS NOT NULL))
      BEGIN

           SET @OldValue = CASE WHEN @IsArchived = 1 THEN 'Un archived' WHEN @IsArchived = 0 THEN 'Archived' END
           SET @NewValue = CASE WHEN @IsArchived = 1 THEN 'Archived' WHEN @IsArchived = 0 THEN 'Un archived' END

     DECLARE @OldValue1 NVARCHAR(250) = CASE WHEN @IsArchived = 1 THEN NULL WHEN @IsArchived = 0 THEN CONVERT(NVARCHAR,FORMAT(@ArchivedDateTime,'dd/MM/yyyy')) END
           DECLARE @NewValue1 NVARCHAR(250) = CASE WHEN @IsArchived = 1 THEN CONVERT(NVARCHAR,FORMAT(@CurrentDate,'dd/MM/yyyy')) WHEN @IsArchived = 0 THEN NULL END

           SET @FieldName = 'ArchivedDateTime' 
           SET @HistoryDescription = 'ArchivedUserStory' 
           
           EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue1,@NewValue = @NewValue1,@FieldName = @FieldName,
           @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
       END

    IF((@IsParked = 1 AND @ParkedDateTime IS NULL) OR (@IsParked = 0 AND @ParkedDateTime IS NOT NULL))
    BEGIN
    
         SET @OldValue = CASE WHEN @IsParked = 1 THEN 'Un parked' WHEN @IsParked = 0 THEN 'Parked' END
         SET @NewValue = CASE WHEN @IsParked = 1 THEN 'Parked' WHEN @IsParked = 0 THEN 'Un parked' END
    
       DECLARE @OldParkedDateTime NVARCHAR(250) = CASE WHEN @IsParked = 1 THEN NULL WHEN @IsParked = 0 THEN CONVERT(NVARCHAR,FORMAT(@ParkedDateTime,'dd/MM/yyyy')) END
         DECLARE @NewParkedDateTime NVARCHAR(250) = CASE WHEN @IsParked = 1 THEN CONVERT(NVARCHAR,FORMAT(@CurrentDate,'dd/MM/yyyy')) WHEN @IsParked = 0 THEN NULL END
    
         SET @FieldName = 'ParkedDateTime' 
         SET @HistoryDescription = 'ParkedUserStory' 
         
         EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldParkedDateTime,@NewValue = @NewParkedDateTime,@FieldName  =@FieldName,
         @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
    
    END

   IF(@OldReviewerUserId <> @ReviewerUserId OR (@OldReviewerUserId IS NULL AND @ReviewerUserId IS NOT NULL))
      BEGIN
         
          SET @OldValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @OldReviewerUserId AND IsActive = 1)
          SET @NewValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @ReviewerUserId AND IsActive = 1) 
          SET @FieldName = 'ReviewerUserName' 
          SET @HistoryDescription = 'ReviewerUserChanged'  
          
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END

   IF(@OldOrder <> @Order OR (@OldOrder IS NULL AND @Order IS NOT NULL))
      BEGIN
         
          SET @OldValue = CONVERT(NVARCHAR(500), @OldOrder)
          SET @NewValue = CONVERT(NVARCHAR(500), @Order) 
          SET @FieldName = 'Order' 
          SET @HistoryDescription = 'OrderChanged'  
           
          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END

   IF(@OldProjectFeatureId <> @ProjectFeatureId OR (@OldProjectFeatureId IS NULL AND @ProjectFeatureId IS NOT NULL) OR (@OldProjectFeatureId IS NOT NULL AND @ProjectFeatureId IS NULL))
      BEGIN
         
          SET @OldValue = (SELECT ProjectFeatureName FROM ProjectFeature WHERE Id = @OldProjectFeatureId)

          SET @NewValue = (SELECT ProjectFeatureName FROM ProjectFeature WHERE Id = @ProjectFeatureId)

          SET @FieldName = 'ProjectFeature'
      IF(@OldValue IS NULL)
    BEGIN 
      SET @HistoryDescription = 'ProjectFeatureAdded'  
    END
    ELSE IF(@NewValue IS NULL)
    BEGIN
       SET @HistoryDescription = 'ProjectFeatureRemoved'
    END
    ELSE
    BEGIN
     SET @HistoryDescription = 'ProjectFeatureChanged'
    END

          EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
          @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
      
      END

    IF(ISNULL(@OldIsForQa,0) <> @IsForQa)
    BEGIN
    
         SET @OldValue = CASE WHEN @OldIsForQa IS NULL THEN 'null' 
                           WHEN @OldIsForQa = 0 THEN 'unchecked' 
                           WHEN @OldIsForQa = 1 THEN 'checked' END
         SET @NewValue = CASE WHEN @IsForQa IS NULL THEN 'null' 
                           WHEN @IsForQa = 0 THEN 'unchecked' 
                           WHEN @IsForQa = 1 THEN 'checked' END
    
         SET @FieldName = 'IsForQa' 
         
      SET @HistoryDescription = 'IsForQaChange' 
         
         EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName  =@FieldName,
         @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
    
    END


 END TRY
 BEGIN CATCH

      THROW

 END CATCH

END
GO
