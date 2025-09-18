CREATE PROCEDURE [dbo].[USP_UpsertActivity]
(
	@ActivityName NVARCHAR(50) ,
	@Id UNIQUEIDENTIFIER = NULL,
	@Description NVARCHAR(800) =NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT = NULL,
	@Inputs NVARCHAR(MAX) = NULL
)
  AS
 BEGIN
 SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
				
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @ActivityCount INT = (SELECT COUNT(1) FROM WorkflowActivity WHERE ActivityName = @ActivityName AND (Id <> @Id OR @Id  IS NULL) AND CompanyId = @CompanyId)
			
			--DECLARE @RCount INT = (SELECT COUNT(1) FROM AuditQuestions A WHERE A.ImpactId = @ImpactId AND @ImpactId IS NOT NULL AND @IsArchived =  1)


			IF(@ActivityCount > 0)
			BEGIN
					RAISERROR(50001,16,2,'ActivityName')
			END
			ELSE
			BEGIN
				IF (@HavePermission = '1')
				BEGIN


						DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@Id IS NULL)
						BEGIN
								SET @Id = NEWID()

								INSERT INTO [dbo].[WorkflowActivity](
																Id,
																ActivityName,
																[Description],
																Inputs,
																[CreatedByUserId],
																[CreatedDateTime],
																[CompanyId]
																)
											SELECT @Id,
												   @ActivityName,
												   @Description,
												   @Inputs,
												   @OperationsPerformedBy,
												   @CurrentDate,
												   @CompanyId

					    END
						ELSE
						BEGIN

							UPDATE [dbo].[WorkflowActivity]
									SET ActivityName = @ActivityName,
										[Description] = @Description,
										Inputs = @Inputs,
										[UpdatedByUserId] = @OperationsPerformedBy,
										[UpdatedDateTime]=@CurrentDate,
										[InActiveDateTime] = CASE WHEN @IsArchived= 1 THEN @CurrentDate ELSE NULL END
										WHERE Id = @Id

						END	
						SELECT @Id
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