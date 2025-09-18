-- EXEC [dbo].[USP_UpsertAuditImpact] @OperationsPerformedBy = '9d7e7f73-227c-411d-aaed-41568d59894e' , @ImpactName = 'dummy',@Description='dummy'
--,@TimeStamp = 0x0000000003D90C2B , @ImpactId = '5E857B7A-5649-4559-B5FB-C2645D769540',@IsArchived = 0
CREATE PROCEDURE [dbo].[USP_UpsertAuditImpact]
(
	@ImpactName NVARCHAR(50) ,
	@ImpactId UNIQUEIDENTIFIER = NULL,
	@Description NVARCHAR(800) =NULL,
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

			DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @ImpactCount INT = (SELECT COUNT(1) FROM AuditImpact WHERE ImpactName = @ImpactName AND (Id <> @ImpactId OR @ImpactId  IS NULL) AND CompanyId = @CompanyId)
			
			DECLARE @RCount INT = (SELECT COUNT(1) FROM AuditQuestions A WHERE A.ImpactId = @ImpactId AND @ImpactId IS NOT NULL AND @IsArchived =  1)


			IF(@ImpactCount > 0)
			BEGIN
					RAISERROR(50001,16,2,'ImpactName')
			END
			ELSE IF(@RCount > 0 AND @IsArchived = 1)
			BEGIN

			RAISERROR ('ThisAuditImpactISUsedInAuditQUestionsCanNotArchived',11, 1)

			END
			ELSE
			BEGIN
				IF (@HavePermission = '1')
				BEGIN


						DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@ImpactId IS NULL)
						BEGIN
								SET @ImpactId = NEWID()

								INSERT INTO [dbo].[AuditImpact](
																Id,
																ImpactName,
																[Description],
																[CreatedByUserId],
																[CreatedDateTime],
																[CompanyId]
																)
											SELECT @ImpactId,
												   @ImpactName,
												   @Description,
												   @OperationsPerformedBy,
												   @CurrentDate,
												   @CompanyId

					    END
						ELSE
						BEGIN

							UPDATE [dbo].[AuditImpact]
									SET ImpactName = @ImpactName,
										[Description] = @Description,
										[UpdatedByUserId] = @OperationsPerformedBy,
										[UpdatedDateTime]=@CurrentDate,
										[InActiveDateTime] = CASE WHEN @IsArchived= 1 THEN @CurrentDate ELSE NULL END
										WHERE Id = @ImpactId

						END	
						SELECT @ImpactId
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