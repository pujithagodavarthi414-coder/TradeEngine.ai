CREATE PROCEDURE [dbo].[USP_CreateStatusReport]
(
	@StatusConfigurationId UNIQUEIDENTIFIER = NULL,
	@FormId UNIQUEIDENTIFIER,
	@FormName NVARCHAR(100),
	@Description NVARCHAR(200),
	@FormData NVARCHAR(MAX),
	@UploadedFileName NVARCHAR(MAX),
	@UploadedFileUrl NVARCHAR(MAX),
	@CreatedBy UNIQUEIDENTIFIER,
	@ReportAssignedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @ReportId UNIQUEIDENTIFIER = NEWID()

             INSERT INTO [dbo].[StatusReports](
                         [Id],
                         [StatusConfigurationId],
						 [FormId],
						 [FormName],
						 [Description],
						 [FormData],
						 [UploadedFileName],
						 [UploadedFileUrl],
						 [CreatedOn],
						 [CreatedBy],
						 [ReportAssignedBy])
                  SELECT @ReportId,
						 @StatusConfigurationId,
						 @FormId,
						 @FormName,
						 @Description,
						 @FormData,
						 @UploadedFileName,
						 @UploadedFileUrl,
						 @Currentdate,
						 @CreatedBy,
						 @ReportAssignedBy
	
		SELECT Id FROM [dbo].[StatusReports] where Id = @ReportId

    END TRY
    BEGIN CATCH
        
        SELECT ERROR_NUMBER() AS ErrorNumber,
               ERROR_SEVERITY() AS ErrorSeverity,
               ERROR_STATE() AS ErrorState,
               ERROR_PROCEDURE() AS ErrorProcedure,
               ERROR_LINE() AS ErrorLine,
               ERROR_MESSAGE() AS ErrorMessage

    END CATCH
END
GO