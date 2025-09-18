CREATE PROCEDURE [dbo].[USP_UpsertLinkUserStory]
  @UserStoryLinkId UNIQUEIDENTIFIER = NULL,
  @LinkUserStoryId UNIQUEIDENTIFIER = NULL,
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @TimeZone NVARCHAR(250) = NULL,
  @LinkUserStoryTypeId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
	BEGIN
       SET NOCOUNT ON
       BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	        DECLARE @GoalId UNIQUEIDENTIFIER = (SELECT GoalId FROM [dbo].[UserStory] WHERE Id = @UserStoryId AND InActiveDateTime IS NULL)
	        DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByGoalId](@GoalId))
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            DECLARE @UserStoryLinkCount INT = (SELECT COUNT(1) FROM [LinkUserStory] WHERE LinkUserStoryTypeId = @LinkUserStoryTypeId AND LinkUserStoryId = @LinkUserStoryId AND UserStoryId = @UserStoryId AND InActiveDateTime IS NULL)
			DECLARE @UserStoryName NVARCHAR(250) = (SELECT UserStoryName FROM [dbo].[UserStory] WHERE Id = @LinkUserStoryId)
		   IF(@UserStoryLinkCount > 0)
            BEGIN
                
                RAISERROR(50001,16,1,'UserStoryLink')
            END                  
			                       DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
			                      SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
				                  
                                  DECLARE @Currentdate DATETIMEOFFSET =  ISNULL(dbo.Ufn_GetCurrentTime(@Offset),SYSDATETIMEOFFSET())
          
                                  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))    
                                       
                                  DECLARE @NewUserStoryId UNIQUEIDENTIFIER

								  SELECT @NewUserStoryId = NEWID()

								  INSERT INTO [dbo].[LinkUserStory](
                                           [Id],
                                           [UserStoryId],
										   [LinkUserStoryTypeId],
										   [LinkUserStoryId],
										   [CreatedDateTime],
										   [CreatedDateTimeZoneId],
										   [CreatedByUserId]
                                           )
                                    SELECT @NewUserStoryId,
                                           @UserStoryId,
										   @LinkUserStoryTypeId,
										   @LinkUserStoryId,
										   @Currentdate,
										   @TimeZoneId,
										   @OperationsPerformedBy
							SELECT @NewUserStoryId

							INSERT INTO UserStoryHistory(
													  Id,
													  UserStoryId,
													  FieldName,
													  NewValue,
													  [Description],
													  CreatedByUserId,
													  CreatedDateTimeZoneId,
													  CreatedDateTime
													 )
											  SELECT  NEWID(),
											          @UserStoryId,
											          'UserStoryLink',
													  @UserStoryName,
													  'UserStoryLinkAdded',
													  @OperationsPerformedBy,
													  @TimeZoneId,
													  @Currentdate

    END TRY 

    BEGIN CATCH

        THROW

    END CATCH 
       
END
GO
