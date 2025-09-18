---------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-11-12 00:00:00.000'
-- Purpose      To Upsert TestSuite Files
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTestSuiteFiles]
--@FilesXML='<GenericListOfFileModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
---<ListItems>
---<FileModel>
--<FileId xsi:nil="true"/>
--<FileName>image (6).png</FileName>
--<FileSize>46584</FileSize>
--<FilePath>https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/localsiteuploads/0b2921a9-e930-4013-9047-670b5352f308/image_(6)-8d8519af-34f7-4f9d-9fdb-b3cafc931e8c.png</FilePath>
--<FileExtension>.png</FileExtension>
--<IsArchived>false</IsArchived>
--</FileModel>
---<FileModel>
--<FileId xsi:nil="true"/>
--<FileName>image.png</FileName>
--<FileSize>113683</FileSize>
--<FilePath>https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/localsiteuploads/0b2921a9-e930-4013-9047-670b5352f308/image-fd6da9b9-68ed-4293-b991-9cf20c9ee7c8.png</FilePath>
--<FileExtension>.png</FileExtension>
--<IsArchived>false</IsArchived>
--</FileModel>
---<FileModel>
--<FileId xsi:nil="true"/>
--<FileName>image.png</FileName>
--<FileSize>113683</FileSize>
--<FilePath>https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/localsiteuploads/0b2921a9-e930-4013-9047-670b5352f308/image-a4f1ba93-e01e-4cfd-bbcd-0b7f9839557d.png</FilePath>
--<FileExtension>.png</FileExtension>
--<IsArchived>false</IsArchived>
--</FileModel>
--</ListItems>
--</GenericListOfFileModel>'
--,@FolderId= '0a8a0656-d288-4933-a6bc-400b91376284',@ReferenceId='0a8a0656-d288-4933-a6bc-400b91376284',@ReferenceTypeId='225BEB5C-1A53-40BB-A29B-B03BE3FA2779',@OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308'
---------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertTestSuiteFiles]
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

					DECLARE @FolderCount INT = NULL

					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

					DECLARE @FileFolderId UNIQUEIDENTIFIER = NULL;
				    
					SET @StoreId = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)

					IF(@ReferenceTypeId IN( 'FFDFBE28-D3D9-49F9-9018-50E02D9C8F5B' ,'77F086EA-E23F-414D-AD14-D4725CEF36C2' ,'CFB83453-60DD-4EB5-9818-95CDB3478AC5' ,'ED61D300-9A7C-450F-8942-2444DACEAD0F' ,'4232A177-164E-456C-B427-7BDEED92DA1D' ,'6520F42D-DA2E-40E2-BAFA-D5EE4D37F4A3'))
						SET @FolderCount = (SELECT COUNT(1) FROM Folder WHERE Id = @FolderId AND InActiveDateTime IS NULL)
					ELSE IF (@ReferenceTypeId IN( '225BEB5C-1A53-40BB-A29B-B03BE3FA2779' ,'3A3E185B-BD74-4DB6-86BC-677EB9AB1609'))
					BEGIN
					
						SET @FolderId = (SELECT Id FROM Folder WHERE FolderName = 'Steps' AND ParentFolderId = (SELECT TC.Id FROM TestCaseStep TCS INNER JOIN TestCase TC ON TC.Id = TCS.TestCaseId WHERE TCS.Id = @ReferenceId AND StoreId = @StoreId) AND InActiveDateTime IS NULL)
						SET @FolderCount = (SELECT COUNT(1) FROM Folder WHERE Id = @FolderId AND InActiveDateTime IS NULL)
					
					END

					IF(@FolderCount = 0 )
					BEGIN

						DECLARE @ProjectId UNIQUEIDENTIFIER = NULL;

						DECLARE @ProjectName NVARCHAR(50) = NULL;

						DECLARE @TestrailManagementFolderId UNIQUEIDENTIFIER = NULL;

						DECLARE @TestSuiteParentFolderId UNIQUEIDENTIFIER = NULL;

						DECLARE @TestSuiteId UNIQUEIDENTIFIER = NULL;

						DECLARE @TestSuiteName NVARCHAR(50) = NULL;

						DECLARE @TestSuiteCaseName NVARCHAR(50) = NULL;

						--DECLARE @StepFolderId UNIQUEIDENTIFIER = NULL;
						
						IF(@ReferenceTypeId IN('FFDFBE28-D3D9-49F9-9018-50E02D9C8F5B' ,'77F086EA-E23F-414D-AD14-D4725CEF36C2' ,'CFB83453-60DD-4EB5-9818-95CDB3478AC5' ,'ED61D300-9A7C-450F-8942-2444DACEAD0F' ,'4232A177-164E-456C-B427-7BDEED92DA1D' ,'6520F42D-DA2E-40E2-BAFA-D5EE4D37F4A3')) --TestCase
						BEGIN
						
							SELECT  @ProjectId = TS.ProjectId,
									@ProjectName = P.ProjectName,
									@TestSuiteId = TC.TestSuiteId,
									@TestSuiteName = TS.TestSuiteName,
									@TestSuiteCaseName = TC.TestCaseId
							FROM TestCase TC INNER JOIN TestSuite TS ON TS.Id = TC.TestSuiteId
											 INNER JOIN Project P ON P.Id = TS.ProjectId
											 WHERE TC.Id = @ReferenceId

						END
						IF(@ReferenceTypeId IN ( '225BEB5C-1A53-40BB-A29B-B03BE3FA2779' ,'3A3E185B-BD74-4DB6-86BC-677EB9AB1609'))   --TestStep
						BEGIN

							DECLARE @TestSuiteCaseId UNIQUEIDENTIFIER = NULL;
	
							--DECLARE @TestSuiteStepName NVARCHAR(50) = NULL;

							SELECT  @ProjectId = TS.ProjectId,
									@ProjectName = P.ProjectName,
									@TestSuiteId = TC.TestSuiteId,
									@TestSuiteName = TS.TestSuiteName,
									@TestSuiteCaseId = TCS.TestCaseId,
									@TestSuiteCaseName = TC.TestCaseId
									--@TestSuiteStepName = TCS.StepOrder
							FROM TestCaseStep TCS   INNER JOIN TestCase TC ON TC.Id = TCS.TestCaseId
													INNER JOIN TestSuite TS ON TS.Id = TC.TestSuiteId
													INNER JOIN Project P ON P.Id = TS.ProjectId
													WHERE TCS.Id = @ReferenceId

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
						
						DECLARE @TestSuiteParentFolderIdCount INT = (SELECT COUNT(1) FROM Folder  WHERE FolderName = 'Test suites and cases' AND ParentFolderId = @TestrailManagementFolderId AND InActiveDateTime IS NULL AND StoreId = @StoreId)
	
						IF(@TestSuiteParentFolderIdCount = 0)
						BEGIN

							INSERT INTO @Temp(Id) EXEC [USP_UpsertFolder] @FolderName = 'Test suites and cases',@ParentFolderId= @TestrailManagementFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy

							SELECT TOP(1) @TestSuiteParentFolderId =  Id FROM @Temp
		   
							DELETE FROM @Temp

						END
						ELSE
						BEGIN

							SET @TestSuiteParentFolderId = (SELECT Id From Folder WHERE FolderName = 'Test suites and cases' AND ParentFolderId= @TestrailManagementFolderId AND InActiveDateTime IS NULL AND StoreId = @StoreId)

						END

						DECLARE @TestSuiteFolderIdCount INT = (SELECT COUNT(1) FROM Folder WHERE Id = @TestSuiteId AND InActiveDateTime IS NULL AND StoreId = @StoreId)
	
						IF(@TestSuiteFolderIdCount = 0)
						BEGIN

							EXEC [USP_UpsertFolder] @DeafultFolderId = @TestSuiteId,@FolderName = @TestSuiteName,@ParentFolderId= @TestSuiteParentFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
		   
						END	

						IF(@ReferenceTypeId IN( 'FFDFBE28-D3D9-49F9-9018-50E02D9C8F5B' ,'77F086EA-E23F-414D-AD14-D4725CEF36C2' ,'CFB83453-60DD-4EB5-9818-95CDB3478AC5' ,'ED61D300-9A7C-450F-8942-2444DACEAD0F' ,'4232A177-164E-456C-B427-7BDEED92DA1D' ,'6520F42D-DA2E-40E2-BAFA-D5EE4D37F4A3')) --TestCase
						BEGIN

							EXEC [USP_UpsertFolder] @DeafultFolderId = @FolderId,@FolderName = @TestSuiteCaseName,@ParentFolderId= @TestSuiteId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy		

						END
						IF(@ReferenceTypeId IN( '225BEB5C-1A53-40BB-A29B-B03BE3FA2779' ,'3A3E185B-BD74-4DB6-86BC-677EB9AB1609'))   --TestStep
						BEGIN

							DECLARE @TestSuiteCaseFolderIdCount INT = (SELECT COUNT(1) FROM Folder WHERE Id = @TestSuiteCaseId AND InActiveDateTime IS NULL AND StoreId = @StoreId)

							IF(@TestSuiteCaseFolderIdCount = 0)
							BEGIN
		
								EXEC [USP_UpsertFolder] @DeafultFolderId = @TestSuiteCaseId,@FolderName = @TestSuiteCaseName,@ParentFolderId= @TestSuiteId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
		
							END

							INSERT INTO @Temp(Id) EXEC [USP_UpsertFolder] @FolderName = 'Steps',@ParentFolderId= @TestSuiteCaseId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy

							SELECT TOP(1) @FolderId =  Id FROM @Temp
		   
							DELETE FROM @Temp
							

						END
					END
					
					IF(@ReferenceTypeId = 'FFDFBE28-D3D9-49F9-9018-50E02D9C8F5B') SET @FileFolderId = @FolderId
					
					ELSE IF(@ReferenceTypeId IN( '77F086EA-E23F-414D-AD14-D4725CEF36C2' ,'CFB83453-60DD-4EB5-9818-95CDB3478AC5' ,'ED61D300-9A7C-450F-8942-2444DACEAD0F' ,'4232A177-164E-456C-B427-7BDEED92DA1D' ,'6520F42D-DA2E-40E2-BAFA-D5EE4D37F4A3' ,'225BEB5C-1A53-40BB-A29B-B03BE3FA2779' ,'3A3E185B-BD74-4DB6-86BC-677EB9AB1609'))
					BEGIN
						
						DECLARE @FolderName NVARCHAR(50)

						DECLARE @FolderIdCount INT = NULL	

						IF(@ReferenceTypeId = '77F086EA-E23F-414D-AD14-D4725CEF36C2') SET @FolderName = 'Mission'
						ELSE IF(@ReferenceTypeId = 'CFB83453-60DD-4EB5-9818-95CDB3478AC5') SET @FolderName = 'Goals'
						ELSE IF(@ReferenceTypeId = 'ED61D300-9A7C-450F-8942-2444DACEAD0F') SET @FolderName = 'Preconditions'
						ELSE IF(@ReferenceTypeId = '4232A177-164E-456C-B427-7BDEED92DA1D') SET @FolderName = 'Step description(Text)'
						ELSE IF(@ReferenceTypeId = '6520F42D-DA2E-40E2-BAFA-D5EE4D37F4A3') SET @FolderName = 'Expected result(Text)'
						ELSE IF(@ReferenceTypeId = '225BEB5C-1A53-40BB-A29B-B03BE3FA2779') SET @FolderName = 'Step description'
						ELSE IF(@ReferenceTypeId = '3A3E185B-BD74-4DB6-86BC-677EB9AB1609') SET @FolderName = 'Expected result'

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

					EXEC [USP_UpsertFile] @FilesXML = @FilesXML,@FolderId = @FileFolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = @ReferenceTypeId, @OperationsPerformedBy = @OperationsPerformedBy, @IsFromFeedback = NULL
				
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