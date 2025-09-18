CREATE PROCEDURE [dbo].[USP_UpsertDocumentTemplate]
(
 @DocumentTemplateId UNIQUEIDENTIFIER = NULL,
 @DocumentTemplateName NVARCHAR(MAX) = NULL,
 @DocumentTemplatePath NVARCHAR(MAX) = NULL,
 @IsArchived BIT = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@DocumentTemplateId =  '00000000-0000-0000-0000-000000000000') SET @DocumentTemplateId = NULL

			IF (@DocumentTemplateName = '' ) SET @DocumentTemplateName = NULL

			BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @DocumentTemplateIdCount INT = (SELECT COUNT(1) FROM DocumentTemplates WHERE Id = @DocumentTemplateId AND CompanyId = @CompanyId )
				
				IF (@DocumentTemplateIdCount = 0 AND @DocumentTemplateId IS NOT NULL)
				BEGIN
				    
					RAISERROR(50002,16,1,'Document Template')

				END
				ELSE IF(@DocumentTemplateName IS NULL)
				BEGIN
				   
				    RAISERROR(50011,16, 2, 'Template name')

				END
				ELSE IF(@DocumentTemplatePath IS NULL)
				BEGIN
				   
				    RAISERROR(50011,16, 2, 'Template path')

				END
				ELSE
				BEGIN
					
					DECLARE @CurrentDate DATETIME = GETDATE()

					IF(@DocumentTemplateId IS NULL)
					BEGIN

					  SET @DocumentTemplateId = NEWID()

						  INSERT INTO DocumentTemplates(Id,
							    			TemplateName,
											TemplatePath,
							    			CompanyId,
							    			CreatedDateTime,
							    			CreatedByUserId,
							    			InactiveDateTime
							    		   )
							    	SELECT  @DocumentTemplateId,
											@DocumentTemplateName,
											@DocumentTemplatePath,
							    			@CompanyId,
							    			@CurrentDate,
							    			@OperationsPerformedBy,
										    CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
		              
					   END
					   ELSE
					   BEGIN

						 UPDATE DocumentTemplates
					     SET  [TemplateName] = @DocumentTemplateName,
							  TemplatePath = @DocumentTemplatePath,
							  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
							  UpdatedDateTime = @CurrentDate,
							  UpdatedByUserId = @OperationsPerformedBy
							 WHERE Id = @DocumentTemplateId

					   END

					SELECT Id FROM Announcement WHERE Id = @DocumentTemplateId
					
				END
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