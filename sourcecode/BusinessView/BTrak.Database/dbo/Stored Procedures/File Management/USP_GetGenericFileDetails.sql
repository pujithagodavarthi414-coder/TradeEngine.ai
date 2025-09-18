CREATE PROCEDURE [dbo].[USP_GetGenericFileDetails]
(
	@FileId UNIQUEIDENTIFIER
)
AS
BEGIN

SET NOCOUNT ON

	BEGIN TRY

			SELECT Id AS FileId,
				   [FileName],
				   FileExtension,
				   FilePath,
				   FileSize,  
				   FolderId,
				   StoreId,
				   ReferenceId,
				   ReferenceTypeId,
				   IsArchived = CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END,
				   CreatedDateTime,
				   CreatedByUserId,
				   [TimeStamp]
			 FROM [UploadFile] WHERE Id = @FileId

	END TRY  
	BEGIN CATCH 
		
		EXEC USP_GetErrorInformation

	END CATCH
END
GO