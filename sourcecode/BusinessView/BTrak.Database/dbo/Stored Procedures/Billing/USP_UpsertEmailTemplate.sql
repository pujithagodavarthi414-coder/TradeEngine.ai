-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertEmailTemplate] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @EmailTemplateName = 'Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmailTemplate]
(
   @EmailTemplateId UNIQUEIDENTIFIER = NULL,
   @EmailTemplateName NVARCHAR(800)  = NULL,
   @EmailSubject NVARCHAR(2000)  = NULL,
   @EmailTemplate NVARCHAR(MAX)  = NULL,
   @ClientId UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@EmailTemplateName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'EmailTemplateName')

		END
		ELSE
		BEGIN
		DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
		
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @EmailTemplateIdCount INT = (SELECT COUNT(1) FROM EmailTemplates WHERE Id = @EmailTemplateId AND CompanyId = @CompanyId )

		DECLARE @EmailTemplateNameCount INT = (SELECT COUNT(1) FROM EmailTemplates WHERE EmailTemplateName = @EmailTemplateName AND CompanyId = @CompanyId AND ClientId = @ClientId AND (Id <> @EmailTemplateId OR @EmailTemplateId IS NULL) )
		
		IF(@EmailTemplateIdCount = 0 AND @EmailTemplateId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 2,'EmailTemplate')
		END
		ELSE IF(@EmailTemplateNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'EmailTemplate')

		END		
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = '1'-- (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @EmailTemplateId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [EmailTemplates] WHERE Id = @EmailTemplateId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
			      IF(@EmailTemplateId IS NULL)
				  BEGIN

				  SET @EmailTemplateId = NEWID()

			        INSERT INTO [dbo].[EmailTemplates](
			                    [Id],
								[EmailTemplateName],
								[EmailTemplate],
								[EmailSubject],
								[ClientId],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @EmailTemplateId,
			                    @EmailTemplateName,
								@EmailTemplate,
								@EmailSubject,
			                    @ClientId,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [EmailTemplates]
					  SET  [EmailTemplateName] = @EmailTemplateName,
					       [EmailTemplate] = @EmailTemplate,
						   [EmailSubject] = @EmailSubject,
						   [ClientId] = @ClientId,
					       CompanyId  = @CompanyId,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @EmailTemplateId

				   END

			        SELECT Id FROM [dbo].[EmailTemplates] WHERE Id = @EmailTemplateId

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

