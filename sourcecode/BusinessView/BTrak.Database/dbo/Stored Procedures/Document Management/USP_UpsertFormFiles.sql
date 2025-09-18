CREATE PROCEDURE [dbo].[USP_UpsertFormFiles]
(
   @FilesXML XML = NULL,
   @FolderId UNIQUEIDENTIFIER = NULL,
   @StoreId UNIQUEIDENTIFIER = NULL,
   @ReferenceId UNIQUEIDENTIFIER = NULL,
   @ReferenceTypeId UNIQUEIDENTIFIER = NULL, 
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        
        IF(@FolderId = '00000000-0000-0000-0000-000000000000') SET @FolderId = NULL

		IF(@StoreId = '00000000-0000-0000-0000-000000000000') SET @StoreId = NULL

		IF(@ReferenceId = '00000000-0000-0000-0000-000000000000') SET @ReferenceId = NULL

        IF(@ReferenceTypeId = '00000000-0000-0000-0000-000000000000') SET @ReferenceTypeId = NULL
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        IF(@ReferenceTypeId IS NULL OR  @ReferenceTypeId = '00000000-0000-0000-0000-000000000000')
        BEGIN
           
            RAISERROR(50011,16, 2, 'ReferenceTypeId')
        
        END
        ELSE 
        BEGIN

       IF(@StoreId IS NULL OR  @StoreId = '00000000-0000-0000-0000-000000000000')
        BEGIN
    
            SET @StoreId = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)
    
        END
            DECLARE @StoreIdCount INT = (SELECT COUNT(1) FROM Store WHERE Id = @StoreId AND CompanyId = @CompanyId)

			DECLARE @ReferenceTypeIdCount INT = (SELECT COUNT(1) FROM ReferenceType WHERE Id = @ReferenceTypeId AND InActiveDateTime IS NULL)
       
            IF(@FolderId IS NOT NULL) DECLARE @FolderIdCount INT = (SELECT COUNT(1) FROM Folder WHERE Id = @FolderId )

            IF(@ReferenceTypeIdCount = 0 AND @ReferenceTypeId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'ReferenceTypeId')
            
            END
            ELSE IF(@StoreIdCount = 0 AND @StoreId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'Store')
            
            END
            ELSE IF(@FolderIdCount = 0 AND @FolderId IS NOT NULL)
            BEGIN

                RAISERROR(50002,16, 2,'Folder')
            
            END
            ELSE
            BEGIN

				DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

				IF (@HavePermission = '1')
				BEGIN

				   IF(@FolderId IS NULL)
				   BEGIN

				  DECLARE @StoreName  NVARCHAR(250) = (SELECT StoreName FROM Store WHERE Id = @StoreId AND InActiveDateTime IS NULL)

				  SET @FolderId = (SELECT F.Id FROM Folder F INNER JOIN Store S ON S.Id = f.StoreId WHERE FolderName =  @StoreName +' store docs' AND CompanyId = @CompanyId  and s.InActiveDateTime IS NULL)

				         IF(@FolderId IS NULL)
				         BEGIN
				         
				          SET @FolderId = NEWID()
				         
				          	INSERT INTO [dbo].[Folder](
					       				  [Id],
					       				  [FolderName],
					       				  [StoreId],
					       				 [FolderReferenceTypeId],
					       				  [CreatedDateTime],
					       				  [CreatedByUserId]                   
					       				  )
					       		   SELECT @FolderId,
					       				  @StoreName +' store docs',
					       				  @StoreId,
					       				  '6C568A74-51F2-4568-AD3E-3D61F438A55B',
					       				  GETDATE(),
					       				  @OperationsPerformedBy
                            END
				   END

					EXEC [USP_UpsertFile] @FilesXML = @FilesXML,@FolderId = @FolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = @ReferenceTypeId, @OperationsPerformedBy = @OperationsPerformedBy, @IsFromFeedback = NULL,@IsDuplicatesAllowed=1

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