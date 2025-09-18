---------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-11-12 00:00:00.000'
-- Purpose      To Upsert FoodOrder Files
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertFoodOrderFiles]
--@FilesXML=''
--,@FolderId= '2af40f14-794e-4921-bb03-b8b92d352b8e',@ReferenceTypeName='Food Order files',@OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308'
---------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertFoodOrderFiles]
(
   @FilesXML XML = NULL,
   @FolderId UNIQUEIDENTIFIER = NULL,
   @StoreId UNIQUEIDENTIFIER = NULL,
   @ReferenceId UNIQUEIDENTIFIER = NULL,
   @ReferenceTypeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        
        IF(@FolderId = '00000000-0000-0000-0000-000000000000') SET @FolderId = NULL

        IF(@StoreId = '00000000-0000-0000-0000-000000000000') SET @StoreId = NULL

		IF(@ReferenceId = '00000000-0000-0000-0000-000000000000') SET @ReferenceId = NULL

        IF(@ReferenceTypeId = '00000000-0000-0000-0000-000000000000') SET @ReferenceTypeId = NULL

        IF(@ReferenceTypeId IS NULL OR  @ReferenceTypeId = '00000000-0000-0000-0000-000000000000')
        BEGIN
           
            RAISERROR(50011,16, 2, 'ReferenceTypeId')
        
        END
        ELSE IF(@ReferenceId IS NULL OR  @ReferenceId = '00000000-0000-0000-0000-000000000000')
        BEGIN
    
            RAISERROR(50011,16, 2, 'FoodOrderId')
    
        END
        ELSE 
        BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       
			DECLARE @FoodOrderIdCount INT = (SELECT COUNT(1) FROM FoodOrder WHERE Id = @ReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)

			DECLARE @ReferenceTypeIdCount INT = (SELECT COUNT(1) FROM ReferenceType WHERE Id = @ReferenceTypeId AND InActiveDateTime IS NULL)
       
            IF(@ReferenceTypeIdCount = 0 AND @ReferenceTypeId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'ReferenceTypeId')
            
            END
            ELSE IF(@FoodOrderIdCount = 0 AND @ReferenceId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'FoodOrder')
            
            END
            ELSE
            BEGIN

				DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

				IF (@HavePermission = '1')
				BEGIN

					SET @StoreId = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId )

					DECLARE @FoodOrderParentFolderId UNIQUEIDENTIFIER = (SELECT Id From Folder WHERE FolderName = 'Food order management' AND StoreId = @StoreId AND InActiveDateTime IS NULL)

					DECLARE @FoodOrderFolderName NVARCHAR(50) = (SELECT REPLACE(CONVERT(NVARCHAR(15), OrderedDateTime, 106),' ',' - ') FROM FoodOrder WHERE Id = @ReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)

					DECLARE @FolderCount INT = (SELECT COUNT(1) FROM Folder WHERE FolderName = @FoodOrderFolderName AND ParentFolderId = @FoodOrderParentFolderId AND StoreId = @StoreId AND InActiveDateTime IS NULL)

					IF(@FolderCount = 0 )
					BEGIN
						
						DECLARE @Temp Table ( Id UNIQUEIDENTIFIER )
				    
					    INSERT INTO @Temp(Id) EXEC [USP_UpsertFolder] @FolderName = @FoodOrderFolderName,@ParentFolderId = @FoodOrderParentFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
				    
						SELECT TOP(1) @FolderId =  Id FROM @Temp

					END
					BEGIN
						
						SET @FolderId = (SELECT Id FROM Folder WHERE FolderName = @FoodOrderFolderName AND ParentFolderId = @FoodOrderParentFolderId AND InActiveDateTime IS NULL)

					END

					EXEC [USP_UpsertFile] @FilesXML = @FilesXML,@FolderId = @FolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = @ReferenceTypeId, @OperationsPerformedBy = @OperationsPerformedBy, @IsFromFeedback = NULL
				
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