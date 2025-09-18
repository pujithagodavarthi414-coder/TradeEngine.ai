--EXEC [dbo].[USP_UpsertApplicationCategory] @OperationsPerformedBy = '589BE7AE-E5FA-4BDB-B5C4-F44834151BA4',@ApplicationCategoryName = 'social media'
CREATE PROCEDURE [dbo].[USP_UpsertApplicationCategory]
(
	@ApplicationCategoryName NVARCHAR(250) = NULL,
	@ApplicationCategoryId UNIQUEIDENTIFIER = NULL,
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

			DECLARE @ApplicationCategoryCount INT = (SELECT COUNT(1) FROM ApplicationCategory WHERE ApplicationCategoryName = @ApplicationCategoryName 
			                                         AND CompanyId = @CompanyId AND (Id <> @ApplicationCategoryId OR @ApplicationCategoryId IS NULL) ) 

			IF(@ApplicationCategoryCount > 0)
			BEGIN
					
					RAISERROR(50001,16,2,'ApplicationCategory')
			
			END
			ELSE
			BEGIN
			
			IF (@HavePermission = '1')
				BEGIN
				 
				 	DECLARE @IsLatest BIT = (CASE WHEN @ApplicationCategoryId IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [ApplicationCategory] WHERE Id = @ApplicationCategoryId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			            IF(@IsLatest = 1)
			         	BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@ApplicationCategoryId IS NULL)
						BEGIN
								SET @ApplicationCategoryId = NEWID()

								INSERT INTO [dbo].[ApplicationCategory]
								                  (
												  Id,
												  ApplicationCategoryName,
												  [CreatedByUserId],
												  [CreatedDateTime],
												  [CompanyId]
												  )
											SELECT @ApplicationCategoryId,
												   @ApplicationCategoryName,
												   @OperationsPerformedBy,
												   @CurrentDate,
												   @CompanyId

					    END
						ELSE
						BEGIN

							UPDATE [dbo].[ApplicationCategory]
									SET [ApplicationCategoryName] = @ApplicationCategoryName,
										[UpdatedByUserId] = @OperationsPerformedBy,
										[UpdatedDateTime]=@CurrentDate,
										[InActiveDateTime] = CASE WHEN @IsArchived= 1 THEN @CurrentDate ELSE NULL END
										WHERE Id = @ApplicationCategoryId

							IF(@IsArchived IS NOT NULL AND @IsArchived= 1)
							BEGIN

								UPDATE ActivityTrackerApplicationUrl SET ApplicationCategoryId = NULL
								WHERE ApplicationCategoryId = @ApplicationCategoryId
							
							END

						END	

						END
						ELSE
						BEGIN

						 	RAISERROR (50008,11, 1)

						END

						SELECT Id FROM [ApplicationCategory] WHERE Id = @ApplicationCategoryId

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