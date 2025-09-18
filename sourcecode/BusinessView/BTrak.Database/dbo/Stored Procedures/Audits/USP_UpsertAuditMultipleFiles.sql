---------------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-09-15 00:00:00.000'
-- Purpose      To Upsert Audit Files
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertAuditMultipleFiles]
--@FilesXML='<GenericListOfFileModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
---<ListItems>
---<FileModel>
--<FileId xsi:nil="true"/>
--<FileName>Screenshot (1).png</FileName>
--<FileSize>356149</FileSize>
--<FilePath>https://bviewstorage.blob.core.windows.net/snovasysso-4afeb444-e826-4f95-ac41-2175e36a0c16/projects/0b2921a9-e930-4013-9047-670b5352f308/Screenshot_(1)-17ea168f-c208-4ad4-84b6-2b5037511535.png</FilePath>
--<FileExtension>.png</FileExtension>
--<IsArchived>false</IsArchived>
--</FileModel>
--</ListItems>
--</GenericListOfFileModel>'
--,@FolderId= '2af40f14-794e-4921-bb03-b8b92d352b8e',@ReferenceTypeName='UserStory',@OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308'
---------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertAuditMultipleFiles]
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
    
            RAISERROR(50011,16, 2, 'QuestionId')
    
        END
		ELSE IF(@FolderId IS NULL OR  @FolderId = '00000000-0000-0000-0000-000000000000')
        BEGIN
    
            RAISERROR(50011,16, 2, 'AuditQuestionId')
    
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

					DECLARE @FolderCount INT = (SELECT COUNT(1) FROM Folder WHERE Id = @ReferenceId)

					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

					SET @StoreId = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId )
					
					IF(@FolderCount = 0 )
					BEGIN
						
						DECLARE @ReferenceTypeName NVARCHAR(250) = (SELECT ReferenceTypeName FROM ReferenceType WHERE Id = @ReferenceTypeId)
				    
						DECLARE @MainAuditParentFolderId UNIQUEIDENTIFIER = (SELECT Id From Folder WHERE FolderName = 'Audit management' AND ParentFolderId IS NULL AND InActiveDateTime IS NULL AND StoreId = @StoreId)
				    
						IF(@MainAuditParentFolderId IS NULL)
						BEGIN

							SET @MainAuditParentFolderId = NEWID()

							EXEC [USP_UpsertFolder] @DeafultFolderId = @MainAuditParentFolderId,@FolderName = 'Audit management',@ParentFolderId = NULL,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy

						END
						
						DECLARE @AuditOrConductFolderId UNIQUEIDENTIFIER = (SELECT Id From Folder WHERE FolderName = @ReferenceTypeName AND ParentFolderId = @MainAuditParentFolderId AND InActiveDateTime IS NULL AND StoreId = @StoreId)

						IF(@AuditOrConductFolderId IS NULL)
						BEGIN

							SET @AuditOrConductFolderId = NEWID()

							EXEC [USP_UpsertFolder] @DeafultFolderId = @AuditOrConductFolderId,@FolderName = @ReferenceTypeName,@ParentFolderId= @MainAuditParentFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy

						END

						DECLARE @AuditOrConductIndividualName NVARCHAR(300) = CASE WHEN @ReferenceTypeName = 'Audits'	THEN (SELECT TOP(1) ACC.AuditName FROM AuditQuestions AQ 
																																	INNER JOIN AuditCategory AC ON AC.Id = AQ.AuditCategoryId AND AC.InActiveDateTime IS NULL AND AQ.InActiveDateTime IS NULL
																																	INNER JOIN AuditCompliance ACC ON ACC.Id = AC.AuditComplianceId AND ACC.InActiveDateTime IS NULL
																																		WHERE AQ.Id = @ReferenceId)
																				  WHEN @ReferenceTypeName = 'Conducts'  THEN (SELECT TOP(1) AC.AuditConductName + '-' + CONVERT(NVARCHAR(50), AC.Id) FROM AuditConductQuestions ACQ 
																																	INNER JOIN AuditConduct AC ON AC.Id = ACQ.AuditConductId AND AC.InActiveDateTime IS NULL AND ACQ.InActiveDateTime IS NULL
																																		WHERE ACQ.Id = @ReferenceId)
																			 END

						DECLARE @AuditOrConductIndividualFolderId UNIQUEIDENTIFIER = (SELECT Id From Folder WHERE FolderName = @AuditOrConductIndividualName AND ParentFolderId = @AuditOrConductFolderId AND InActiveDateTime IS NULL AND StoreId = @StoreId)

						IF(@AuditOrConductIndividualFolderId IS NULL)
						BEGIN

							SET @AuditOrConductIndividualFolderId = CASE WHEN @ReferenceTypeName = 'Audits'	THEN (SELECT TOP(1) ACC.Id FROM AuditQuestions AQ 
																																	INNER JOIN AuditCategory AC ON AC.Id = AQ.AuditCategoryId AND AC.InActiveDateTime IS NULL AND AQ.InActiveDateTime IS NULL
																																	INNER JOIN AuditCompliance ACC ON ACC.Id = AC.AuditComplianceId AND ACC.InActiveDateTime IS NULL
																																		WHERE AQ.Id = @ReferenceId)
																				  WHEN @ReferenceTypeName = 'Conducts'  THEN (SELECT TOP(1) AC.Id FROM AuditConductQuestions ACQ 
																																	INNER JOIN AuditConduct AC ON AC.Id = ACQ.AuditConductId AND AC.InActiveDateTime IS NULL AND ACQ.InActiveDateTime IS NULL
																																		WHERE ACQ.Id = @ReferenceId)
																			 END

							EXEC [USP_UpsertFolder] @DeafultFolderId = @AuditOrConductIndividualFolderId,@FolderName = @AuditOrConductIndividualName,@ParentFolderId= @AuditOrConductFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy

						END

						DECLARE @AuditOrConductQuestionName NVARCHAR(50) = CASE WHEN @ReferenceTypeName = 'Audits'	THEN (SELECT QuestionIdentity FROM AuditQuestions
																																		WHERE Id = @ReferenceId AND InActiveDateTime IS NULL)
																				  WHEN @ReferenceTypeName = 'Conducts'  THEN (SELECT QuestionIdentity FROM AuditConductQuestions 
																																		WHERE Id = @ReferenceId AND InActiveDateTime IS NULL)
																			 END

						EXEC [USP_UpsertFolder] @DeafultFolderId = @FolderId,@FolderName = @AuditOrConductQuestionName,@ParentFolderId= @AuditOrConductIndividualFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy

				END
				
				EXEC [USP_UpsertFile] @FilesXML = @FilesXML,@FolderId = @FolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = @ReferenceTypeId, @OperationsPerformedBy = @OperationsPerformedBy, @IsFromFeedback = 0
				
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
