CREATE PROCEDURE [dbo].[USP_UpsertDocumentType]
(
   @DocumentTypeId UNIQUEIDENTIFIER = NULL,
   @DocumentTypeName NVARCHAR(50) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@DocumentTypeName IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'DocumentType')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @DocumentTypeIdCount INT = (SELECT COUNT(1) FROM DocumentType  WHERE Id = @DocumentTypeId)

			DECLARE @DocumentTypeCount INT = (SELECT COUNT(1) FROM DocumentType WHERE DocumentTypeName = @DocumentTypeName AND CompanyId = @CompanyId AND (@DocumentTypeId IS NULL OR @DocumentTypeId <> Id))
       
			DECLARE @IsInUse INT = (select COUNT(1) from CandidateDocuments CD
									INNER JOIN DocumentType DT ON DT.Id = CD.DocumentTypeId
											WHERE DT.CompanyId=@CompanyId AND CD.DocumentTypeId = @DocumentTypeId
											)
       
			IF(@IsInUse > 0  AND @IsArchived IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'DocumentTypeUse')

			END
			IF(@DocumentTypeIdCount = 0 AND @DocumentTypeId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'DocumentType')

			END
			IF (@DocumentTypeCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'DocumentType')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @DocumentTypeId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [DocumentType] WHERE Id = @DocumentTypeId  AND CompanyId = @CompanyId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@DocumentTypeId IS NULL)
					  BEGIN

						 SET @DocumentTypeId = NEWID()

						 INSERT INTO [dbo].[DocumentType]([Id],
														  [CompanyId],
								                          DocumentTypeName,
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @DocumentTypeId,
								                          @CompanyId,
								                          @DocumentTypeName,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy		
							         
					END
					ELSE
					BEGIN

						UPDATE [DocumentType] SET CompanyId = @CompanyId,
								                  DocumentTypeName = @DocumentTypeName,
									              InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @DocumentTypeId

					END
				            
				    SELECT Id FROM [dbo].[DocumentType] WHERE Id = @DocumentTypeId
				                   
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