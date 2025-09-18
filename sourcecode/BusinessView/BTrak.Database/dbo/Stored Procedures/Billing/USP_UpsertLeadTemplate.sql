CREATE PROCEDURE [dbo].[USP_UpsertLeadTemplate]
	@TemplateId UNIQUEIDENTIFIER = NULL,
	@FormName NVARCHAR(250) = NULL,
	@FormJson NVARCHAR(MAX) = NULL,
	@IsArchived BIT = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 
	 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
     IF (@HavePermission = '1')
        BEGIN
		   DECLARE @IsLatest BIT = (CASE WHEN @TemplateId IS NULL THEN 1 ELSE 
                                 CASE WHEN (SELECT [TimeStamp] FROM LeadTemplates WHERE Id = @TemplateId) = @TimeStamp THEN 1 ELSE 0 END END)
           IF(@IsLatest = 1)
             BEGIN
                 DECLARE @Currentdate DATETIME = GETDATE()
                 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                 DECLARE @TemplateNameCount INT = (SELECT COUNT(1) FROM LeadTemplates WHERE FormName = @FormName AND CompanyId = @CompanyId AND (Id <> @TemplateId OR @TemplateId IS NULL) AND InActiveDateTime IS NULL)
                 IF(@TemplateNameCount > 0)
                 BEGIN
                    
                   RAISERROR(50001,16,1,'Leadtemplate')
                       
                 END
                 ELSE
                 BEGIN
                   IF(@TemplateId IS NULL)
                   BEGIN
                         SET @TemplateId = NEWID()
                         INSERT INTO [dbo].[LeadTemplates](
                                           [Id],
                                           [FormName],
                                           [FormJson],
                                           [CompanyId],
                                           [CreatedDateTime],
                                           [CreatedByUserId]
                                          )
                                  SELECT  @TemplateId,
                                          @FormName,
                                          @FormJson,
                                          @CompanyId,
                                          @Currentdate,
                                          @OperationsPerformedBy
                   END
                   ELSE
                   BEGIN
                           UPDATE [dbo].[LeadTemplates]
                           SET [FormName] = @FormName,
                               [FormJson] = @FormJson,
                               [CompanyId] = @CompanyId,
                               [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate
                                                    ELSE NULL END,
                               [UpdatedByUserId] = @OperationsPerformedBy,
                               [UpdatedDateTime] = @Currentdate
                            WHERE Id = @TemplateId

                   END
                    SELECT @TemplateId
                 END
             END
             ELSE
             BEGIN
                RAISERROR(50008,11,1)
             END
		END
		ELSE
      BEGIN
              
        RAISERROR (@HavePermission,11, 1)
                 
      END
	END TRY  
    BEGIN CATCH 
        
        THROW
    END CATCH
END