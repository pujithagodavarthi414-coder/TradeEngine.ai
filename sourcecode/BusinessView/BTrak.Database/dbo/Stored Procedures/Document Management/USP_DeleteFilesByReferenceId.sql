--exec USP_DeleteFilesByReferenceId @ReferenceId='F5A19753-6F22-F4BD-3B33-752E16EEA992',@OperationsPerformedBy='B82B86D7-C09C-40AA-AD3A-66E6AEF3A918'
CREATE PROCEDURE [dbo].[USP_DeleteFilesByReferenceId]
(
  @ReferenceId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
    BEGIN TRY
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        IF(@ReferenceId = '00000000-0000-0000-0000-000000000000') SET @ReferenceId = NULL

        IF(@ReferenceId IS NULL)
        BEGIN
			             
            RAISERROR(50011,16, 2, 'ReferenceId')
          
        END
        ELSE
        BEGIN
			DECLARE @FileIdCount INT = (SELECT COUNT(1) FROM [UploadFile] WHERE ReferenceId = @ReferenceId AND InActiveDateTime IS NULL)
       
			IF(@FileIdCount = 0 AND @ReferenceId IS NOT NULL)
            BEGIN
            
                SELECT @ReferenceId AS ReferenceId
            
            END
            ELSE
            BEGIN

				DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			    
				IF (@HavePermission = '1')
				BEGIN
				
					DECLARE @Currentdate DATETIME = GETDATE()
			        
					declare @fileSize DECIMAL(10,2) = (SELECT ISNULL(SUM(U.filesize),0) FROM UploadFile U WHERE U.ReferenceId = @ReferenceId)

					DECLARE @FolderId UNIQUEIDENTIFIER = (SELECT FolderId From UploadFile where ReferenceId = @ReferenceId)
					
					DECLARE @StoreId UNIQUEIDENTIFIER = (SELECT StoreId From UploadFile where ReferenceId = @ReferenceId)

					DELETE FROM UploadFile WHERE ReferenceId = @ReferenceId

					SELECT @ReferenceId AS ReferenceId,@FolderId AS FolderId,@StoreId AS StoreId,@fileSize
					
				END
				ELSE
			
					RAISERROR (@HavePermission,11, 1)

			END

		END
    END TRY  
    BEGIN CATCH 
        
           THROW

    END CATCH
END
GO
