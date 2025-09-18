-- EXEC [dbo].[USP_UpsertAuditRisk] @OperationsPerformedBy = '9d7e7f73-227c-411d-aaed-41568d59894e' , @RiskName = 'dummy',@Description='dummy'
--,@TimeStamp = 0x0000000000D3E231 , @RiskId = 'FE3F0BE9-EE0B-4207-80DD-E8DF751D2FA2',@IsArchived = 0
CREATE PROCEDURE [dbo].[USP_UpsertAuditRisk]
(
	@RiskName NVARCHAR(50) ,
	@RiskId UNIQUEIDENTIFIER = NULL,
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
			
			DECLARE @RiskCount INT = (SELECT COUNT(1) FROM AuditRisk WHERE RiskName = @RiskName AND (Id <> @RiskId OR @RiskId  IS NULL) AND CompanyId = @CompanyId ) 

			DECLARE @RCount INT = (SELECT COUNT(1) FROM AuditQuestions A WHERE A.RiskId = @RiskId AND @RiskId IS NOT NULL AND @IsArchived =  1)

			IF(@RiskCount > 0)
			BEGIN
					RAISERROR(50001,16,2,'RiskName')
			END
			ELSE IF(@RCount > 0 AND @IsArchived = 1)
			BEGIN

			RAISERROR ('ThisAuditRiskISUsedInAuditQUestionsCanNotArchived',11, 1)

			END
			ELSE
			BEGIN
				IF (@HavePermission = '1')
				BEGIN

						DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@RiskId IS NULL)
						BEGIN
								SET @RiskId = NEWID()

								INSERT INTO [dbo].[AuditRisk](
																Id,
																RiskName,
																[Description],
																[CreatedByUserId],
																[CreatedDateTime],
																[CompanyId]
																)
											SELECT @RiskId,
												   @RiskName,
												   @Description,
												   @OperationsPerformedBy,
												   @CurrentDate,
												   @CompanyId

					    END
						ELSE
						BEGIN

							UPDATE [dbo].[AuditRisk]
									SET RiskName = @RiskName,
										[Description] = @Description,
										[UpdatedByUserId] = @OperationsPerformedBy,
										[UpdatedDateTime]=@CurrentDate,
										[InActiveDateTime] = CASE WHEN @IsArchived= 1 THEN @CurrentDate ELSE NULL END
										WHERE Id = @RiskId

						END	
						SELECT @RiskId
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