-------------------------------------------------------------------------------
-- Author       RanadheerRanaVelaga
-- Created      '2019-07-09 00:00:00.000'
-- Purpose      To Save or Update User Story Tag
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------
--EXEC [USP_UpsertUserStoryTag] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryId = 'DC09D6A8-7D4A-4A03-9E17-BCA1595A1DF5',@TimeStamp = 0x00000000000016EB,@tags = 'Tier'
-----------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertUserStoryTag
(
 @UserStoryId UNIQUEIDENTIFIER = NULL,
 @Tags NVARCHAR(MAX) = NULL,
 @TimeZone NVARCHAR(250) = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@UserStoryId = '00000000-0000-0000-0000-000000000000') SET @UserStoryId = NULL

			IF (@Tags = '') SET @Tags = NULL

			IF (@UserStoryId IS NULL)
			BEGIN

				RAISERROR(50011,11,1,'UserStory')

			END
	        ELSE
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp] FROM UserStory WHERE Id = @UserStoryId) = @TimeStamp THEN 1 ELSE 0 END)

				IF (@IsLatest = 1)
				BEGIN

					DECLARE @OldTagValue NVARCHAR(MAX),@OldValue NVARCHAR(MAX),@NewValue NVARCHAR(MAX)

					SELECT @OldTagValue = Tag 
					FROM UserStory US WHERE Id = @UserStoryId

					 DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
					  
					   SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			
                       DECLARE @Currentdate DATETIMEOFFSET =   dbo.Ufn_GetCurrentTime(@Offset)    

					DECLARE @OldTag NVARCHAR(250) = (SELECT Tag FROM UserStory WHERE Id = @UserStoryId)
					
                              UPDATE [UserStory]
							     SET [Tag] = @Tags,
								     [UpdatedDateTime] = @CurrentDate,
									 [UpdatedByUserId] = @OperationsPerformedBy,
									 UpdatedDateTimeZoneId = @TimeZoneId,
									 ArchivedDateTime = CASE WHEN [ArchivedDateTime] IS NULL THEN NULL ELSE @CurrentDate END,
									 InActiveDateTimeZoneId = CASE WHEN [ArchivedDateTime] IS NULL THEN NULL ELSE @TimeZoneId END,
									 InActiveDateTime = CASE WHEN [InActiveDateTime] IS NULL THEN NULL ELSE @CurrentDate END
									 FROM UserStory
									 WHERE Id = @UserStoryId

					
					IF(@OldTagValue <> @Tags OR (@OldTagValue IS NULL AND @Tags IS NOT NULL) OR (@OldTagValue IS NOT NULL AND @Tags IS NULL))
                     BEGIN
                             SET @OldValue = CASE WHEN @OldTagValue IS NULL THEN 'null' ELSE CONVERT(NVARCHAR(MAX), @OldTagValue) END
							 SET @NewValue = CASE WHEN @Tags IS NULL THEN 'null' ELSE CONVERT(NVARCHAR(MAX), @Tags) END
							 
							 EXEC USP_InsertUserStoryHistory @UserStoryId = @UserStoryId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = 'Tag',
							 @Description = 'UserStoryTagChanged',@OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId
					END

					SELECT Id FROM UserStory WHERE Id = @UserStoryId
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
GO

