---------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-11-12 00:00:00.000'
-- Purpose      To Upsert UserStory Files
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertUserStoryFiles] 
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

CREATE PROCEDURE [dbo].[USP_UpsertUserStoryFiles]
(
   @FilesXML XML = NULL,
   @FolderId UNIQUEIDENTIFIER = NULL,
   @StoreId UNIQUEIDENTIFIER = NULL,
   @ReferenceId UNIQUEIDENTIFIER = NULL,
   @ReferenceTypeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsFromFeedback BIT = NULL  
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
        ELSE IF(@FolderId IS NULL OR  @FolderId = '00000000-0000-0000-0000-000000000000')
        BEGIN
    
            RAISERROR(50011,16, 2, 'UserStoryId')
    
        END
        ELSE 
        BEGIN

			DECLARE @ReferenceTypeIdCount INT = (SELECT COUNT(1) FROM ReferenceType  WHERE Id = @ReferenceTypeId AND InActiveDateTime IS NULL)
       
			DECLARE @UserStoryIdCount INT = (SELECT COUNT(1) FROM UserStory WHERE Id = @FolderId AND InActiveDateTime IS NULL)
            
			IF(@ReferenceTypeIdCount = 0 AND @ReferenceTypeId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'ReferenceTypeId')
            
            END
            ELSE IF(@UserStoryIdCount = 0 AND @FolderId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'UserStory')
            
            END
            ELSE
            BEGIN

				DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

				IF (@HavePermission = '1')
				BEGIN

					DECLARE @FolderCount INT = (SELECT COUNT(1) FROM Folder WHERE Id = @FolderId)

					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

					IF (@IsFromFeedback = 1)
					BEGIN 

						SET @StoreId = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = (SELECT Id FROM Company WHERE CompanyName='nxusworld') )
				    
					END
					ELSE
					BEGIN

						SET @StoreId = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId )
					
					END
					IF(@FolderCount = 0 )
					BEGIN
						
						DECLARE @ReferenceTypeName NVARCHAR(250) = (SELECT ReferenceTypeName FROM ReferenceType WHERE Id = @ReferenceTypeId)

						DECLARE @GoalId UNIQUEIDENTIFIER = CASE WHEN @ReferenceTypeName = 'UserStory'	THEN (SELECT GoalId FROM UserStory WHERE Id = @FolderId AND InActiveDateTime IS NULL)
																WHEN @ReferenceTypeName = 'Sprint User story'THEN (SELECT SprintId FROM UserStory WHERE Id = @FolderId AND InActiveDateTime IS NULL)
														   END
						--DECLARE @GoalId UNIQUEIDENTIFIER = (SELECT GoalId FROM UserStory WHERE Id = @FolderId AND InActiveDateTime IS NULL)
						DECLARE @ProjectId UNIQUEIDENTIFIER = CASE WHEN @ReferenceTypeName = 'UserStory' THEN (SELECT ProjectId From Goal Where Id = @GoalId AND InActiveDateTime IS NULL)
																   WHEN @ReferenceTypeName = 'Sprint User story' THEN (SELECT ProjectId FROM Sprints WHERE Id = @GoalId AND InActiveDateTime IS NULL)
															  END
						--DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId From Goal Where Id = @GoalId AND InActiveDateTime IS NULL)
				    
						DECLARE @ProjectParentFolderId UNIQUEIDENTIFIER = (SELECT Id From Folder WHERE FolderName = 'Project management' AND InActiveDateTime IS NULL AND StoreId = @StoreId)
				    
						DECLARE @GoalFolderIdCount INT = (SELECT COUNT(1) FROM Folder  WHERE Id = @GoalId AND InActiveDateTime IS NULL AND StoreId = @StoreId)
				    
						DECLARE @ProjectFolderIdCount INT = (SELECT COUNT(1) FROM Folder  WHERE Id = @ProjectId AND InActiveDateTime IS NULL AND StoreId = @StoreId)
				    
						DECLARE @ProjectFolderName NVARCHAR(50) = (SELECT ProjectName FROM Project  WHERE Id = @ProjectId AND InActiveDateTime IS NULL)
				    
						DECLARE @TempGoalName NVARCHAR(250) = (SELECT GoalUniqueName FROM Goal  WHERE Id = @GoalId AND InActiveDateTime IS NULL)
						
						IF(@TempGoalName IS NULL)
						
							SET @TempGoalName = (SELECT GoalName FROM Goal WHERE Id = @GoalId AND InActiveDateTime IS NULL)

						DECLARE @GoalFolderName NVARCHAR(50) = CASE WHEN @ReferenceTypeName = 'UserStory' THEN @TempGoalName
																    WHEN @ReferenceTypeName = 'Sprint User story'		THEN (SELECT SprintName FROM Sprints  WHERE Id = @GoalId AND ProjectId = @ProjectId AND InActiveDateTime IS NULL)
															   END
						--DECLARE @GoalFolderName NVARCHAR(50) = (SELECT GoalUniqueName FROM Goal  WHERE Id = @GoalId AND InActiveDateTime IS NULL)
				    
						DECLARE @UserStoryFolderName NVARCHAR(50) = (SELECT UserStoryUniqueName FROM UserStory  WHERE Id = @FolderId AND InActiveDateTime IS NULL)
				    
						IF(@ProjectFolderIdCount = 0)
						BEGIN
				
							EXEC [USP_UpsertFolder] @DeafultFolderId = @ProjectId,@FolderName = @ProjectFolderName,@ParentFolderId= @ProjectParentFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
				   
						END
						IF(@GoalFolderIdCount = 0)
						BEGIN
				
							EXEC [USP_UpsertFolder] @DeafultFolderId = @GoalId,@FolderName = @GoalFolderName,@ParentFolderId= @ProjectId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
				    
						END
				
						EXEC [USP_UpsertFolder] @DeafultFolderId = @FolderId,@FolderName = @UserStoryFolderName,@ParentFolderId= @GoalId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
				    
				END
				
				EXEC [USP_UpsertFile] @FilesXML = @FilesXML,@FolderId = @FolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = @ReferenceTypeId, @OperationsPerformedBy = @OperationsPerformedBy, @IsFromFeedback = @IsFromFeedback
				
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