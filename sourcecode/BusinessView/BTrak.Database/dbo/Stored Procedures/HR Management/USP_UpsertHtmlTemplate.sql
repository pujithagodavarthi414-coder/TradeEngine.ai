-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2020-02-14 00:00:00.000'
-- Purpose      To Save or Update WebHook
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertHtmlTemplate] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@HtmlTemplateName = 'Test'								  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertHtmlTemplate]
(
   @HtmlTemplateId UNIQUEIDENTIFIER = NULL,
   @HtmlTemplateName NVARCHAR(50) = NULL,
   @IsConfigurable BIT NULL,
   @IsRoleBased BIT NULL,
   @IsMailBased BIT NULL,
   @Roles NVARCHAR(MAX) NULL,
   @Mails NVARCHAR(MAX) NULL,
   @HtmlTemplate NVARCHAR(MAX) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER ,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
		IF(@HtmlTemplateName = '') SET @HtmlTemplateName = NULL
	    IF(@HtmlTemplateName IS NULL)
		BEGIN
		    RAISERROR(50011,16, 2, 'HtmlTemplateName')
		END
		ELSE
		BEGIN
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @HtmlTemplateIdCount INT = (SELECT COUNT(1) FROM [HtmlTemplates]  WHERE Id = @HtmlTemplateId)
		DECLARE @HtmlTemplateNameCount INT = (SELECT COUNT(1) FROM [HtmlTemplates] WHERE TemplateName = @HtmlTemplateName AND CompanyId = @CompanyId AND (@HtmlTemplateId IS NULL OR Id <> @HtmlTemplateId))
	    IF(@HtmlTemplateIdCount = 0 AND @HtmlTemplateId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'HtmlTemplateName')
        END
        ELSE IF(@HtmlTemplateNameCount>0)
        BEGIN
          RAISERROR(50001,16,1,'HtmlTemplateName')
         END
         ELSE
		  BEGIN
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			         IF (@HavePermission = '1')
			         BEGIN
			         	DECLARE @IsLatest BIT = (CASE WHEN @HtmlTemplateId  IS NULL
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [HtmlTemplates] WHERE Id = @HtmlTemplateId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			            IF(@IsLatest = 1)
			         	BEGIN

			                DECLARE @Currentdate DATETIME = GETDATE()
							IF(@IsConfigurable IS NULL) SET @IsConfigurable = 0
							IF(@IsRoleBased IS NULL) SET @IsRoleBased = 0
							IF(@IsMailBAsed IS NULL) SET @IsMailBased = 0

			 IF( @HtmlTemplateId IS NULL)
			 BEGIN

			 SET @HtmlTemplateId = NEWID()
			 INSERT INTO [dbo].[HtmlTemplates](
                         [Id],
						 [TemplateName],
						 [HtmlTemplate],
						 [InActiveDateTime],
						 [CreatedDateTime],
						 [CreatedByUserId],
						 IsConfigurable,
						 [CompanyId]
						 )
                  SELECT @HtmlTemplateId,
						 @HtmlTemplateName,
						 @HtmlTemplate,
						 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
						 @Currentdate,
						 @OperationsPerformedBy,
						 @IsConfigurable,
						 @CompanyId
			END
			ELSE
			BEGIN

				UPDATE [dbo].[HtmlTemplates]
					SET	 [TemplateName]		       =  		 @HtmlTemplateName,
						 [HtmlTemplate]            =         @HtmlTemplate,
						 [InActiveDateTime]		   =  		 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
						 [UpdatedDateTime]		   =  		 @Currentdate,
						 [UpdatedByUserId]		   =  		 @OperationsPerformedBy,
						 IsConfigurable = @IsConfigurable
						 --,[CompanyId]               =         @CompanyId
					WHERE Id = @HtmlTemplateId

			END

			IF(@IsConfigurable = 1)
			BEGIN
				DECLARE @ConfigurationId UNIQUEIDENTIFIER = (SELECT Id FROM TemplateConfiguration WHERE HtmlTemplateId = @HtmlTemplateId AND CompanyId = @CompanyId)

				IF(@ConfigurationId IS NULL)
				BEGIN
					
					INSERT INTO TemplateConfiguration(Id,HtmlTemplateId,Roles,Mails,CompanyId,CreatedByUserId,CreatedDateTime)
					SELECT NEWID(),@HtmlTemplateId,@Roles,@Mails,@CompanyId,@OperationsPerformedBy,@Currentdate

				END
				ELSE
				BEGIN
					
					UPDATE TemplateConfiguration SET Roles = @Roles,Mails = @Mails,UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = @Currentdate
					WHERE Id = @ConfigurationId

				END
			
			END
			
			SELECT Id FROM [dbo].[HtmlTemplates] WHERE Id = @HtmlTemplateId
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