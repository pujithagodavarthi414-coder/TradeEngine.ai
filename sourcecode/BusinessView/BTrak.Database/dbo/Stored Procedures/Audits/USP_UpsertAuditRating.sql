CREATE PROCEDURE [dbo].[USP_UpsertAuditRating]
(
	@AuditRatingName NVARCHAR(50) ,
	@AuditRatingId UNIQUEIDENTIFIER = NULL,
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

			DECLARE @AuditRatingCount INT = (SELECT COUNT(1) FROM AuditRating WHERE AuditRatingName = @AuditRatingName AND CompanyId = @CompanyId AND (Id <> @AuditRatingId OR @AuditRatingId  IS NULL) ) 

			DECLARE @CounductsCount INT = (SELECT COUNT(1) FROM AuditConduct WHERE AuditRatingId = @AuditRatingId AND @IsArchived = 1)

			IF(@AuditRatingCount > 0)
			BEGIN
					
					RAISERROR(50001,16,2,'AuditRating')
			
			END
			ELSE IF(@IsArchived = 1 AND @CounductsCount > 0)
			BEGIN

			RAISERROR ('ThisAuditRatingUsedAuditConductCanNotArchived',11, 1)

			END
			BEGIN
			
			IF (@HavePermission = '1')
				BEGIN
				 
				 	DECLARE @IsLatest BIT = (CASE WHEN @AuditRatingId IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [AuditRating] WHERE Id = @AuditRatingId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			            IF(@IsLatest = 1)
			         	BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@AuditRatingId IS NULL)
						BEGIN
								SET @AuditRatingId = NEWID()

								INSERT INTO [dbo].[AuditRating]
								                  (
												  Id,
												  AuditRatingName,
												  [CreatedByUserId],
												  [CreatedDateTime],
												  [CompanyId]
												  )
											SELECT @AuditRatingId,
												   @AuditRatingName,
												   @OperationsPerformedBy,
												   @CurrentDate,
												   @CompanyId

					    END
						ELSE
						BEGIN

							UPDATE [dbo].[AuditRating]
									SET [AuditRatingName] = @AuditRatingName,
										[UpdatedByUserId] = @OperationsPerformedBy,
										[UpdatedDateTime]=@CurrentDate,
										[InActiveDateTime] = CASE WHEN @IsArchived= 1 THEN @CurrentDate ELSE NULL END
										WHERE Id = @AuditRatingId

						END	

						END
						ELSE
						BEGIN

						 	RAISERROR (50008,11, 1)

						END

						SELECT Id FROM [AuditRating] WHERE Id = @AuditRatingId

				END
				ELSE
					RAISERROR (@HavePermission,11, 1)
				
			END


		  END TRY
    BEGIN CATCH
        
        THROW
 
    END CATCH 
 END
