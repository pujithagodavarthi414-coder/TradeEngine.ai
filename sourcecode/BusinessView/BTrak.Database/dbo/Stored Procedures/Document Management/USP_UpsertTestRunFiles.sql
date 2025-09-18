---------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-11-12 00:00:00.000'
-- Purpose      To Upsert TestRun Files
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTestRunFiles]
--@FilesXML='<GenericListOfFileModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
---<ListItems>
---<FileModel>
--<FileId xsi:nil="true"/>
--<FileName>image (6).png</FileName>
--<FileSize>46584</FileSize>
--<FilePath>https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/localsiteuploads/0b2921a9-e930-4013-9047-670b5352f308/image_(6)-0d274080-d54b-4cad-a703-951d8c9ebe5f.png</FilePath>
--<FileExtension>.png</FileExtension>
--<IsArchived>false</IsArchived>
--</FileModel>
---<FileModel>
--<FileId xsi:nil="true"/>
--<FileName>image.png</FileName>
--<FileSize>113683</FileSize>
--<FilePath>https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/localsiteuploads/0b2921a9-e930-4013-9047-670b5352f308/image-2243ed2b-e6ef-4b50-bbee-96b75b0b86f5.png</FilePath>
--<FileExtension>.png</FileExtension>
--<IsArchived>false</IsArchived>
--</FileModel>
--</ListItems>
--</GenericListOfFileModel>'
--,@FolderId= '67252e44-8cda-45e0-8956-e196bfa63ca0',@ReferenceId='67252e44-8cda-45e0-8956-e196bfa63ca0',@ReferenceTypeId='37ef5578-77aa-4a44-ab1e-be76b585b2ce',@OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308'
---------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertTestRunFiles]
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
        ELSE 
        BEGIN

			DECLARE @ReferenceTypeIdCount INT = (SELECT COUNT(1) FROM ReferenceType  WHERE Id = @ReferenceTypeId AND InActiveDateTime IS NULL)
       
			IF(@ReferenceTypeIdCount = 0 AND @ReferenceTypeId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'ReferenceTypeId')
            
            END
            ELSE
            BEGIN

				DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

				IF (@HavePermission = '1')
				BEGIN

					DECLARE @FolderCount INT = (SELECT COUNT(1) FROM Folder WHERE Id = @FolderId AND InActiveDateTime IS NULL)

					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				    
					DECLARE @FileFolderId UNIQUEIDENTIFIER = NULL;
					
					SET @StoreId = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)

					IF(@ReferenceTypeId = '37EF5578-77AA-4A44-AB1E-BE76B585B2CE' OR @ReferenceTypeId = 'E6A6B453-3D12-4F24-894F-E923FFB1C154') SET @FolderCount = (SELECT COUNT(1) FROM Folder WHERE Id = @FolderId AND InActiveDateTime IS NULL)
					ELSE IF (@ReferenceTypeId = 'F86D67E1-D351-4A76-9FDD-06D1A9D84181')
					BEGIN
					
						SET @FileFolderId = (SELECT Id FROM Folder WHERE FolderName = 'Actual result' AND ParentFolderId = (SELECT TRSC.Id FROM TestRunSelectedStep TRSS INNER JOIN TestCaseStep TCS ON TCS.Id = TRSS.StepId
																																							  INNER JOIN TestCase TC ON TC.Id = TCS.TestCaseId
																																							  INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id AND TRSC.TestRunId = TRSS.TestRunId
																																							  WHERE TRSS.Id = @ReferenceId) AND InActiveDateTime IS NULL)
						SET @FolderCount = (SELECT COUNT(1) FROM Folder WHERE Id = @FileFolderId AND InActiveDateTime IS NULL)
					
					END
				
					IF(@FolderCount = 0 )
					BEGIN

						DECLARE @ProjectId UNIQUEIDENTIFIER = NULL;

						DECLARE @ProjectName NVARCHAR(50) = NULL;

						DECLARE @TestrailManagementFolderId UNIQUEIDENTIFIER = NULL;

						DECLARE @TestRunParentFolderId UNIQUEIDENTIFIER = NULL;

						DECLARE @TestRunId UNIQUEIDENTIFIER = NULL;

						DECLARE @TestRunName NVARCHAR(50) = NULL;

						DECLARE @TestRunSelectedCaseName NVARCHAR(50) = NULL;

						IF(@ReferenceTypeId = 'F86D67E1-D351-4A76-9FDD-06D1A9D84181')   --TestStep
						BEGIN

							DECLARE @TestRunSelectedCaseId UNIQUEIDENTIFIER = NULL;
	
							--DECLARE @TestRunSelectedStepName NVARCHAR(50) = NULL;

							SELECT  @ProjectId = TR.ProjectId,
									@ProjectName = P.ProjectName,
									@TestRunId = TRSS.TestRunId,
									@TestRunName = TR.[Name],
									@TestRunSelectedCaseId = TRSC.Id,
									@TestRunSelectedCaseName = TC.TestCaseId
									--@TestRunSelectedStepName = TCS.StepOrder
							FROM TestRunSelectedStep TRSS INNER JOIN TestCaseStep TCS ON TCS.Id = TRSS.StepId
														  INNER JOIN TestCase TC ON TC.Id = TCS.TestCaseId
														  INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id AND TRSC.TestRunId = TRSS.TestRunId
														  INNER JOIN TestRun TR ON TR.Id = TRSS.TestRunId
														  INNER JOIN Project P ON P.Id = TR.ProjectId
														  WHERE TRSS.Id = @ReferenceId

						END
						IF(@ReferenceTypeId = '37EF5578-77AA-4A44-AB1E-BE76B585B2CE' OR @ReferenceTypeId = 'E6A6B453-3D12-4F24-894F-E923FFB1C154') --TestCase
						BEGIN

							SELECT  @ProjectId = TR.ProjectId,
									@ProjectName = P.ProjectName,
									@TestRunId = TRSC.TestRunId,
									@TestRunName = TR.[Name],
									@TestRunSelectedCaseName = TC.TestCaseId
							FROM TestRunSelectedCase TRSC INNER JOIN TestCase TC ON TC.Id = TRSC.TestCaseId
														  INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId
														  INNER JOIN Project P ON P.Id = TR.ProjectId
														  WHERE TRSC.Id = @ReferenceId

						END

						DECLARE @ProjectFolderIdCount INT = (SELECT COUNT(1) FROM Folder  WHERE Id = @ProjectId AND InActiveDateTime IS NULL AND StoreId = @StoreId)

						IF(@ProjectFolderIdCount = 0)
						BEGIN

							DECLARE @ProjectParentFolderId UNIQUEIDENTIFIER = (SELECT Id From Folder WHERE FolderName = 'Project management' AND InActiveDateTime IS NULL AND StoreId = @StoreId)
				            

							EXEC [USP_UpsertFolder] @DeafultFolderId = @ProjectId,@FolderName = @ProjectName,@ParentFolderId= @ProjectParentFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
				             
						END
	
						DECLARE @TestrailManagementFolderIdCount INT = (SELECT COUNT(1) FROM Folder  WHERE FolderName = 'Test management' AND ParentFolderId = @ProjectId AND InActiveDateTime IS NULL AND StoreId = @StoreId)
	
						DECLARE @Temp Table ( Id UNIQUEIDENTIFIER )
	
						IF(@TestrailManagementFolderIdCount = 0)
						BEGIN

							INSERT INTO @Temp(Id) EXEC [USP_UpsertFolder] @FolderName = 'Test management',@ParentFolderId= @ProjectId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy

							SELECT TOP(1) @TestrailManagementFolderId =  Id FROM @Temp

							DELETE FROM @Temp
		   
						END
						ELSE
						BEGIN

							SET @TestrailManagementFolderId = (SELECT Id From Folder WHERE FolderName = 'Test management' AND ParentFolderId= @ProjectId AND InActiveDateTime IS NULL AND StoreId = @StoreId)

						END

						DECLARE @TestRunParentFolderIdCount INT = (SELECT COUNT(1) FROM Folder  WHERE FolderName = 'Test runs and results' AND ParentFolderId = @TestrailManagementFolderId AND InActiveDateTime IS NULL AND StoreId = @StoreId)
	
						IF(@TestRunParentFolderIdCount = 0)
						BEGIN

							INSERT INTO @Temp(Id) EXEC [USP_UpsertFolder] @FolderName = 'Test runs and results',@ParentFolderId= @TestrailManagementFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy

							SELECT TOP(1) @TestRunParentFolderId =  Id FROM @Temp
							
							DELETE FROM @Temp

						END
						ELSE
						BEGIN

							SET @TestRunParentFolderId = (SELECT Id From Folder WHERE FolderName = 'Test runs and results' AND ParentFolderId= @TestrailManagementFolderId AND InActiveDateTime IS NULL AND StoreId = @StoreId)

						END

						DECLARE @TestRunFolderIdCount INT = (SELECT COUNT(1) FROM Folder WHERE Id = @TestRunId AND InActiveDateTime IS NULL AND StoreId = @StoreId)
	
						IF(@TestRunFolderIdCount = 0)
						BEGIN

							EXEC [USP_UpsertFolder] @DeafultFolderId = @TestRunId,@FolderName = @TestRunName,@ParentFolderId= @TestRunParentFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
		   
						END	
						IF(@ReferenceTypeId = 'F86D67E1-D351-4A76-9FDD-06D1A9D84181')   --TestStep
						BEGIN

							DECLARE @TestRunCaseFolderIdCount INT = (SELECT COUNT(1) FROM Folder WHERE Id = @TestRunSelectedCaseId AND InActiveDateTime IS NULL AND StoreId = @StoreId)

							IF(@TestRunCaseFolderIdCount = 0)
							BEGIN
		
								EXEC [USP_UpsertFolder] @DeafultFolderId = @TestRunSelectedCaseId,@FolderName = @TestRunSelectedCaseName,@ParentFolderId= @TestRunId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
		
							END

							INSERT INTO @Temp(Id) EXEC [USP_UpsertFolder] @FolderName = 'Actual result',@ParentFolderId= @TestRunSelectedCaseId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy

							SELECT TOP(1) @FileFolderId =  Id FROM @Temp
		   
							DELETE FROM @Temp

						END
						IF(@ReferenceTypeId = '37EF5578-77AA-4A44-AB1E-BE76B585B2CE' OR @ReferenceTypeId = 'E6A6B453-3D12-4F24-894F-E923FFB1C154') --TestCase
						BEGIN

							EXEC [USP_UpsertFolder] @DeafultFolderId = @FolderId,@FolderName = @TestRunSelectedCaseName,@ParentFolderId= @TestRunId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy

						END
					END
				
					--IF(@ReferenceTypeId = 'F86D67E1-D351-4A76-9FDD-06D1A9D84181') SET @FileFolderId = @FolderId
					
					IF(@ReferenceTypeId = '37EF5578-77AA-4A44-AB1E-BE76B585B2CE' OR @ReferenceTypeId = 'E6A6B453-3D12-4F24-894F-E923FFB1C154')
					BEGIN
						
						DECLARE @FolderName NVARCHAR(50)

						DECLARE @FolderIdCount INT = NULL	

						IF(@ReferenceTypeId = '37EF5578-77AA-4A44-AB1E-BE76B585B2CE') SET @FolderName = 'Status comment'
						ELSE IF(@ReferenceTypeId = 'E6A6B453-3D12-4F24-894F-E923FFB1C154') SET @FolderName = 'Assignee comment'
						
						SET @FolderIdCount = (SELECT COUNT(1) FROM Folder  WHERE FolderName = @FolderName AND ParentFolderId = @FolderId AND InActiveDateTime IS NULL AND StoreId = @StoreId)

						IF(@FolderIdCount = 0)
						BEGIN

							INSERT INTO @Temp(Id) EXEC [USP_UpsertFolder] @FolderName = @FolderName,@ParentFolderId = @FolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy

							SELECT TOP(1) @FileFolderId =  Id FROM @Temp

							DELETE FROM @Temp
		   
						END
						ELSE
						BEGIN

							SET @FileFolderId = (SELECT Id From Folder WHERE FolderName = @FolderName AND ParentFolderId= @FolderId AND InActiveDateTime IS NULL AND StoreId = @StoreId)
						
						END
					
					END

					EXEC [USP_UpsertFile] @FilesXML = @FilesXML,@FolderId = @FileFolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = @ReferenceTypeId, @OperationsPerformedBy = @OperationsPerformedBy , @IsFromFeedback = NULL
				
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