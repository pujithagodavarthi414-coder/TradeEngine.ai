---------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-03-04 00:00:00.000'
-- Purpose      To Upsert Folder Description
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertFolderDescription]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@Description = 'test',@FolderId =''
--,@FolderReferenceId='',@FolderReferenceTypeId=''
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertFolderDescription]
(
   @FolderId UNIQUEIDENTIFIER = NULL,
   @Description NVARCHAR(MAX) = NULL,
   @FolderReferenceId UNIQUEIDENTIFIER = NULL,
   @FolderReferenceTypeId UNIQUEIDENTIFIER = NULL, 
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        
        IF(@FolderId = '00000000-0000-0000-0000-000000000000') SET @FolderId = NULL

		IF(@FolderReferenceId = '00000000-0000-0000-0000-000000000000') SET @FolderReferenceId = NULL

        IF(@FolderReferenceTypeId = '00000000-0000-0000-0000-000000000000') SET @FolderReferenceTypeId = NULL

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       
			DECLARE @FolderReferenceTypeIdCount INT = (SELECT COUNT(1) FROM ReferenceType WHERE Id = @FolderReferenceTypeId AND InActiveDateTime IS NULL)
       
			DECLARE @FolderIdCount INT = (SELECT COUNT(1) FROM Folder WHERE Id = @FolderId )

			IF(@FolderReferenceTypeIdCount = 0 AND @FolderReferenceTypeId IS NOT NULL)
			BEGIN
        
				RAISERROR(50002,16, 2,'ReferenceTypeId')
        
			END
			ELSE IF(@FolderIdCount = 0 AND @FolderId IS NOT NULL)
			BEGIN

				RAISERROR(50002,16, 2,'Folder')
        
			END
			ELSE
			BEGIN

				DECLARE @Currentdate DATETIME = GETDATE()

				IF(@FolderId IS NULL AND @FolderReferenceId IS NOT NULL AND @FolderReferenceTypeId IS NOT NULL)
				BEGIN

					DECLARE @StoreId UNIQUEIDENTIFIER = (SELECT S.Id FROM Store S JOIN Company C ON C.Id = S.CompanyId AND C.Id = @CompanyId AND C.InActiveDateTime IS NULL WHERE StoreName = (LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 10) + ' doc store') AND S.InActiveDateTime IS NULL)

					DECLARE @ReferenceTypeName NVARCHAR(250) = (SELECT ReferenceTypeName + ' docs' FROM ReferenceType WHERE Id = @FolderReferenceTypeId AND InActiveDateTime IS NULL)
					
					DECLARE @CustomFolderId UNIQUEIDENTIFIER = NULL

					DECLARE @CustomFolderIdCount INT = (SELECT COUNT(1) FROM Folder WHERE FolderName = @ReferenceTypeName AND FolderReferenceTypeId = @FolderReferenceTypeId AND FolderReferenceId IS NULL AND ParentFolderId IS NULL AND StoreId = @StoreId AND InActiveDateTime IS NULL)

					DECLARE @Temp1 Table ( Id UNIQUEIDENTIFIER )

					IF(@CustomFolderIdCount = 0)
					BEGIN
		
						INSERT INTO @Temp1(Id) 
						EXEC [USP_UpsertFolder] @FolderName = @ReferenceTypeName,@StoreId = @StoreId,@FolderReferenceTypeId = @FolderReferenceTypeId,@OperationsPerformedBy = @OperationsPerformedBy
		
						SELECT TOP(1) @CustomFolderId =  Id FROM @Temp1

						DELETE FROM @Temp1
		
					END
					ELSE
					BEGIN 
		
						SET @CustomFolderId = (SELECT Id FROM Folder WHERE FolderName = @ReferenceTypeName AND FolderReferenceTypeId = @FolderReferenceTypeId AND FolderReferenceId IS NULL AND ParentFolderId IS NULL AND StoreId = @StoreId AND InActiveDateTime IS NULL)

					END

					DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM [dbo].[Sprints] WHERE Id = @FolderReferenceId)
						DECLARE @FolderName NVARCHAR(50) = CASE WHEN @ReferenceTypeName = 'Project docs'	THEN (SELECT ProjectName FROM Project WHERE Id = @FolderReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
																WHEN @ReferenceTypeName = 'Goal docs'		THEN (SELECT GoalUniqueName FROM Goal WHERE Id = @FolderReferenceId AND InActiveDateTime IS NULL)
																WHEN @ReferenceTypeName = 'Sprint docs'		THEN (SELECT SprintName FROM Sprints WHERE Id = @FolderReferenceId AND InActiveDateTime IS NULL AND ProjectId = @ProjectId)
																WHEN @ReferenceTypeName = 'App docs'		THEN (SELECT ISNULL(DashboardName,[Name]) FROM WorkspaceDashboards WHERE Id = @FolderReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
																WHEN @ReferenceTypeName = 'Document store docs'   THEN (SELECT ISNULL(DashboardName,[Name]) FROM WorkspaceDashboards WHERE Id = @FolderReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)

														   END

					SET @FolderIdCount = (SELECT COUNT(1) FROM Folder WHERE FolderReferenceTypeId = @FolderReferenceTypeId AND FolderReferenceId = @FolderReferenceId AND ParentFolderId = @CustomFolderId AND StoreId = @StoreId AND InActiveDateTime IS NULL)
		
					IF(@FolderIdCount = 0)
					BEGIN

						INSERT INTO @Temp1(Id) 
						EXEC [USP_UpsertFolder] @FolderName = @FolderName,@StoreId = @StoreId,@FolderReferenceTypeId = @FolderReferenceTypeId,@FolderReferenceId = @FolderReferenceId,@ParentFolderId = @CustomFolderId,@OperationsPerformedBy = @OperationsPerformedBy
			
						SELECT TOP(1) @FolderId =  Id FROM @Temp1

						DELETE FROM @Temp1

					END
					ELSE
					BEGIN 

						SET @FolderId = (SELECT Id FROM Folder WHERE FolderReferenceTypeId = @FolderReferenceTypeId AND FolderReferenceId = @FolderReferenceId AND ParentFolderId = @CustomFolderId AND StoreId = @StoreId AND InActiveDateTime IS NULL)

					END

				END

				IF(@FolderId IS NULL)
				BEGIN
        
					RAISERROR(50011,16, 2,'FolderId')
        
				END
				ELSE
				BEGIN

					UPDATE [dbo].[Folder]
					SET  [Description] = @Description
						,[UpdatedDateTime] = @Currentdate
						,[UpdatedByUserId] = @OperationsPerformedBy 
					WHERE Id = @FolderId

					SELECT Id FROM Folder WHERE Id = @FolderId

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


