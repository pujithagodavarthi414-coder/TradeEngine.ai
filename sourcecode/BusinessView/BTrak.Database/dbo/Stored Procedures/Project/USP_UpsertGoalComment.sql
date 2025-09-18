--EXEC [UpsertGoalComment] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@GoalId = 'FF4047B8-39B1-42D2-8910-4E60ED38AAC7',@Comment = 'dcsbmscbmcdb'
CREATE PROCEDURE [dbo].[USP_UpsertGoalComment]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @GoalId UNIQUEIDENTIFIER = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @Comment NVARCHAR(MAX) = NULL,
 @IsArchived BIT = NULL,
 @GoalCommentId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()

		IF (@HavePermission = '1')
		BEGIN

			IF (@GoalId IS NULL)
			
				RAISERROR(50011,16,1,'Goal')

			IF (@Comment IS NULL)

				RAISERROR(50011,16,1,'Comment')

			ELSE
			BEGIN
		    
				DECLARE @IsLatest BIT = (CASE WHEN @GoalCommentId IS NULL THEN 1 
				                                          ELSE 
														  CASE WHEN (SELECT [TimeStamp] FROM GoalComments WHERE Id = @GoalCommentId ) = @TimeStamp 
														            THEN 1 ELSE 0 END END)

				IF (@IsLatest = 1)
				BEGIN

				IF(@GoalCommentId IS NOT NULL)
				BEGIN

				UPDATE GoalComments 
				SET GoalId = @GoalId,
				[Comments] = @Comment,
				[UpdatedDateTime] = @Currentdate,
				[UpdatedByUserId] = @OperationsPerformedBy,
				InactiveDateTime = CASE WHEN @IsArchived = 1 THEN GETDATE() ELSE NULL END
				WHERE Id = @GoalCommentId

				END
				ELSE
				BEGIN

				  SET  @GoalCommentId = NEWID()

					INSERT INTO GoalComments(Id,
											 GoalId,
											 Comments,
											 CreatedByUserId,
										     CreatedDateTime,
											 InactiveDateTime
									        )
								      SELECT @GoalCommentId,
										     @GoalId,
										     @Comment,
										     @OperationsPerformedBy,
										     GETDATE(),
										     CASE WHEN @IsArchived = 1 THEN GETDATE() ELSE NULL END

				END

			 	SELECT Id AS GoalCommentId FROM GoalComments WHERE Id = @GoalCommentId

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
