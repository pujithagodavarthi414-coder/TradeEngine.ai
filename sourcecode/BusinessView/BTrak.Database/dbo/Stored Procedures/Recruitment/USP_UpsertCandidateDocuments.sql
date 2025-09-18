
CREATE PROCEDURE [dbo].[USP_UpsertCandidateDocuments]
(
   @CandidateDocumentsId UNIQUEIDENTIFIER = NULL,
   @CandidateId UNIQUEIDENTIFIER = NULL,
   @DocumentTypeId UNIQUEIDENTIFIER = NULL,
   @Document NVARCHAR(MAX),
   @Description NVARCHAR(MAX) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @IsResume BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@CandidateId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'CandidateId')

		END
		--IF(@DocumentTypeId IS NULL)
		--BEGIN

		--   RAISERROR(50011,16, 2, 'DocumentTypeId')

		--END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @CandidateDocumentsIdCount INT = (SELECT COUNT(1) FROM CandidateDocuments  WHERE Id = @CandidateDocumentsId)

			DECLARE @CandidateDocumentsCount INT = (SELECT COUNT(1) FROM CandidateDocuments
			WHERE CandidateId = @CandidateId AND Document = @Document AND InActiveDateTime IS NULL
			AND (@CandidateDocumentsId IS NULL OR @CandidateDocumentsId <> Id))
       
			IF(@CandidateDocumentsIdCount = 0 AND @CandidateDocumentsId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'CandidateDocuments')

			END
			IF (@CandidateDocumentsCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'CandidateDocuments')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @CandidateDocumentsId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [CandidateDocuments] WHERE Id = @CandidateDocumentsId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@CandidateDocumentsId IS NULL)
					  BEGIN

						 SET @CandidateDocumentsId = NEWID()

						 INSERT INTO [dbo].[CandidateDocuments]([Id],
														  CandidateId,
														  DocumentTypeId,
														  Document,
														  IsResume,
														  [Description],
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @CandidateDocumentsId,
								                          @CandidateId,
														  @DocumentTypeId,
														  @Document,
														  @IsResume,
														  @Description,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy		
							         
					END
					ELSE
					BEGIN

						UPDATE [CandidateDocuments] SET CandidateId = @CandidateId,
														DocumentTypeId = @DocumentTypeId,
														Document = @Document,
														IsResume = @IsResume,
														[Description] = @Description,
									                    InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									                    UpdatedDateTime = @Currentdate,
									                    UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @CandidateDocumentsId

					END
				            
				    SELECT Id FROM [dbo].[CandidateDocuments] WHERE Id = @CandidateDocumentsId
				                   
				  END
				  ELSE
				     
				      RAISERROR (50008,11, 1)
				     
				END
				ELSE
				BEGIN
				     
					RAISERROR (@HavePermission,11, 1)
				     		
			    END

			END
	END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO
