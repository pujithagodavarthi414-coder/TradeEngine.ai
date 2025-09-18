CREATE PROCEDURE [dbo].[USP_ArchiveUserStoryLink]
	@UserStoryLinkId UNIQUEIDENTIFIER = NULL,
	@UserStoryId UNIQUEIDENTIFIER = NULL,
	@TimeZone NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

   DECLARE @GoalId UNIQUEIDENTIFIER = (SELECT GoalId FROM [dbo].[UserStory] WHERE Id = @UserStoryId)

    DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByGoalId](@GoalId))

	DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

	       DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp]
                                               FROM [LinkUserStory] WHERE Id = @UserStoryLinkId) = @TimeStamp
                                         THEN 1 ELSE 0 END)
                IF(@IsLatest = 1)
                  BEGIN
				      IF (@IsArchived IS NULL) SET @IsArchived = 0
			   
			          DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
					  
					  SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
					  
                      DECLARE @Currentdate DATETIMEOFFSET =   dbo.Ufn_GetCurrentTime(@Offset)    

			          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

                      UPDATE [LinkUserStory] SET InActiveDateTime = @CurrentDate,InActiveDateTimeZoneId = @TimeZoneId WHERE Id = @UserStoryLinkId  
			          
					  DECLARE @UserStoryName NVARCHAR(250) = (SELECT UserStoryName FROM [dbo].[UserStory] WHERE Id = @UserStoryId)

					  INSERT INTO UserStoryHistory(
													  Id,
													  UserStoryId,
													  FieldName,
													  NewValue,
													  [Description],
													  CreatedByUserId,
													  [CreatedDateTimeZoneId],
													  CreatedDateTime
													 )
											  SELECT  NEWID(),
											          (SELECT UserStoryId FROM LinkuserStory WHERE Id = @UserStoryLinkId),
											          'UserStoryUnLink',
													  @UserStoryName,
													  'UserStoryUnLinked',
													  @OperationsPerformedBy,
													  @TimeZoneId,
													  @Currentdate

					    SELECT Id FROM [dbo].[LinkUserStory] WHERE Id = @UserStoryLinkId
              
				  END
				ELSE
				 BEGIN
				     RAISERROR (50015,11, 1)
				 END

	 END TRY
   BEGIN CATCH

       THROW

   END CATCH
END
GO