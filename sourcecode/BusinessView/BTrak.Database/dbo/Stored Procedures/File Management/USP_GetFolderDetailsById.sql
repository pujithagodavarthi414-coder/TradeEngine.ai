CREATE PROCEDURE [dbo].[USP_GetFolderDetailsById]
(
	@FolderId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

SET NOCOUNT ON

	BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SELECT F.Id AS FolderId,
				   F.FolderName,
				   F.FolderSize,
				   F.ParentFolderId,
				   F.StoreId,  
				   F.Description,
				   F.FolderReferenceId,
				   F.FolderReferenceTypeId,
				   IsArchived = CASE WHEN F.InActiveDateTime IS NULL THEN 0 ELSE 1 END,
				   F.CreatedDateTime,
				   F.CreatedByUserId,
				   F.[TimeStamp]
			 FROM  Folder F WHERE F.Id = @FolderId

		END
        ELSE
        BEGIN
        
                RAISERROR (@HavePermission,11, 1)
                
        END
	END TRY  
	BEGIN CATCH 
		
		EXEC USP_GetErrorInformation

	END CATCH
END