CREATE PROCEDURE [dbo].[USP_UpsertActionCategory]
(
	@ActionCategoryName NVARCHAR(50) ,
	@ActionCategoryId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL
)
 AS
 BEGIN
 SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
				
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @ActionCategoryCount INT = (SELECT COUNT(1) FROM ActionCategory WHERE ActionCategoryName = @ActionCategoryName AND CompanyId = @CompanyId AND (Id <> @ActionCategoryId OR @ActionCategoryId  IS NULL) ) 

			DECLARE @UserStoryCount INT = (SELECT COUNT(1) FROM UserStory US WHERE US.ActionCategoryId = @ActionCategoryId AND @ActionCategoryId IS NOT NULL AND @IsArchived =  1)

			IF(@ActionCategoryCount > 0)
			BEGIN
					
					RAISERROR(50001,16,2,'ActionCategory')
			
			END
			ELSE IF(@UserStoryCount > 0 AND @IsArchived = 1)
			BEGIN

			RAISERROR ('ThisActionCategoryUsedInWorkItemsCanNotArchived',11, 1)

			END
			BEGIN
			
			IF (@HavePermission = '1')
				BEGIN
				 
				 	DECLARE @IsLatest BIT = (CASE WHEN @ActionCategoryId IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [ActionCategory] WHERE Id = @ActionCategoryId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			            IF(@IsLatest = 1)
			         	BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@ActionCategoryId IS NULL)
						BEGIN
								SET @ActionCategoryId = NEWID()

								INSERT INTO [dbo].[ActionCategory]
								                  (
												  Id,
												  ActionCategoryName,
												  [CreatedByUserId],
												  [CreatedDateTime],
												  [CompanyId]
												  )
											SELECT @ActionCategoryId,
												   @ActionCategoryName,
												   @OperationsPerformedBy,
												   @CurrentDate,
												   @CompanyId

					    END
						ELSE
						BEGIN

							UPDATE [dbo].[ActionCategory]
									SET [ActionCategoryName] = @ActionCategoryName,
										[UpdatedByUserId] = @OperationsPerformedBy,
										[UpdatedDateTime]=@CurrentDate,
										[InActiveDateTime] = CASE WHEN @IsArchived= 1 THEN @CurrentDate ELSE NULL END
										WHERE Id = @ActionCategoryId

						END	

						END
						ELSE
						BEGIN

						 	RAISERROR (50008,11, 1)

						END

						SELECT Id FROM [ActionCategory] WHERE Id = @ActionCategoryId

				END
				ELSE
					RAISERROR (@HavePermission,11, 1)
				
			END


		  END TRY
    BEGIN CATCH
        
        THROW
 
    END CATCH 
 END
 GO