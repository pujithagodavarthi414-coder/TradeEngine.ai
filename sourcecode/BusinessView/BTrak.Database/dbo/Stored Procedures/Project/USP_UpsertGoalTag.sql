-------------------------------------------------------------------------------
-- Author       RanadheerRanaVelaga
-- Created      '2019-07-08 00:00:00.000'
-- Purpose      To Save or Update Goal Tag
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertGoalTag]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@GoalId = 'FF4047B8-39B1-42D2-8910-4E60ED38AAC7',@Tags = 'user,Tier'
---------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertGoalTag
(
 @GoalId UNIQUEIDENTIFIER = NULL,
 @Tags NVARCHAR(MAX) = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	
	SET NOCOUNT ON 
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = '1')
		BEGIN

			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@GoalId = '00000000-0000-0000-0000-000000000000') SET @GoalId = NULL

			IF (@Tags = '') SET @Tags = NULL

			IF (@GoalId IS NULL)
			BEGIN

				RAISERROR(50011,11,1,'Goal')

			END
			
			ELSE
			BEGIN

				DECLARE @IsLatest INT = (CASE WHEN (SELECT [TimeStamp] FROM Goal WHERE Id = @GoalId) = @TimeStamp THEN 1 ELSE 0 END)

				DECLARE @OldTags NVARCHAR(MAX) = (SELECT Tag FROM Goal WHERE Id = @GoalId)

				IF(@IsLatest = 1)
				BEGIN
				
					DECLARE @CurrentDate DATETIME = GETDATE()

					DECLARE @OldValue NVARCHAR(500)

					DECLARE @NewValue NVARCHAR(500)

					DECLARE @FieldName NVARCHAR(200)

					DECLARE @HistoryDescription NVARCHAR(800)

					IF(@OldTags IS NULL AND @Tags IS NOT NULL)
					BEGIN

						SET @NewValue = @Tags

						SET @FieldName = 'GoalTag'

						SET @HistoryDescription = 'GoalTagAdded'

						EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
						                           @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy

					END
					ELSE IF (@OldTags <> ISNULL(@Tags,''))
					BEGIN

						SET @OldValue = @OldTags
						SET @NewValue = @Tags

						SET @FieldName = 'GoalTag'

						SET @HistoryDescription = 'GoalTagChanged'

						EXEC USP_InsertGoalHistory @GoalId = @GoalId, @OldValue = @OldValue,@NewValue = @NewValue,@FieldName = @FieldName,
						                           @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy
			
					END

					UPDATE [Goal]
					   SET Tag = @Tags,
					       UpdatedDateTime = @CurrentDate,
						   UpdatedByUserId = @OperationsPerformedBy
						   WHERE Id = @GoalId

					SELECT Id FROM Goal WHERE ID = @GoalId

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