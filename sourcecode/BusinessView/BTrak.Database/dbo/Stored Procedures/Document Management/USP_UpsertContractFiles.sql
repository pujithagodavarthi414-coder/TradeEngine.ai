CREATE PROCEDURE [dbo].[USP_UpsertContractFiles]
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
      DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	  IF (@HavePermission = '1')
	  BEGIN
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
    
            RAISERROR(50011,16, 2, 'CoontractId')
    
        END
        ELSE 
        BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       

			DECLARE @ReferenceTypeIdCount INT = (SELECT COUNT(1) FROM ReferenceType WHERE Id = @ReferenceTypeId AND InActiveDateTime IS NULL)
       
            IF(@ReferenceTypeIdCount = 0 AND @ReferenceTypeId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'ReferenceTypeId')
            
            END
        
            ELSE
            BEGIN

					SET @StoreId = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId )

					DECLARE @ContractParentFolderId UNIQUEIDENTIFIER = (SELECT Id From Folder WHERE FolderName = 'Master Contract' AND StoreId = @StoreId AND InActiveDateTime IS NULL)

					IF(@ContractParentFolderId IS NULL)
					BEGIN
						
						DECLARE @Temp1 Table ( Id UNIQUEIDENTIFIER )
				    
					    INSERT INTO @Temp1(Id) EXEC [USP_UpsertFolder] @FolderName = 'Master Contract',@ParentFolderId = NULL,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
				    
						SELECT TOP(1) @ContractParentFolderId =  Id FROM @Temp1

					END

					DECLARE @ContractFolderName NVARCHAR(50) = (SELECT REPLACE(CONVERT(NVARCHAR(15), ContractNumber, 106),' ',' - ') FROM MasterContract WHERE Id = @ReferenceId AND InActiveDateTime IS NULL)

					IF(@ContractFolderName IS NULL)
					BEGIN
						EXEC [USP_UpsertFile] @FilesXML = @FilesXML,@FolderId = @ContractParentFolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = @ReferenceTypeId, @OperationsPerformedBy = @OperationsPerformedBy, @IsFromFeedback = NULL,@IsDuplicatesAllowed = 1
					END
					ELSE
						BEGIN
							DECLARE @FolderCount INT = (SELECT COUNT(1) FROM Folder WHERE FolderName = @ContractFolderName 
												AND ((@ContractParentFolderId IS NOT NULL AND ParentFolderId = @ContractParentFolderId) OR (@ContractParentFolderId IS NULL AND StoreId = @StoreId)) AND InActiveDateTime IS NULL)

							IF(@FolderCount = 0 )
								BEGIN
								
								DECLARE @Temp Table ( Id UNIQUEIDENTIFIER )
							
							    INSERT INTO @Temp(Id) EXEC [USP_UpsertFolder] @FolderName = @ContractFolderName,@ParentFolderId = @ContractParentFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
							
								SELECT TOP(1) @FolderId =  Id FROM @Temp

							END
								BEGIN
							
								SET @FolderId = (SELECT Top(1)Id FROM Folder WHERE FolderName = @ContractFolderName 
								AND ((@ContractParentFolderId IS NOT NULL AND ParentFolderId = @ContractParentFolderId) OR (@ContractParentFolderId IS NULL AND StoreId = @StoreId))
								AND InActiveDateTime IS NULL)

							END

							EXEC [USP_UpsertFile] @FilesXML = @FilesXML,@FolderId = @FolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = @ReferenceTypeId, @OperationsPerformedBy = @OperationsPerformedBy, @IsFromFeedback = NULL

						END
			END       
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
GO