---------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-03-03 00:00:00.000'
-- Purpose      To Upsert Custom Doc Files
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertCustomDocFiles]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@FolderName = 'test'   
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertCustomDocFiles]
(
   @FilesXML XML = NULL,
   @FolderId UNIQUEIDENTIFIER = NULL,
   @StoreId UNIQUEIDENTIFIER = NULL,
   @ReferenceId UNIQUEIDENTIFIER = NULL,
   @ReferenceTypeId UNIQUEIDENTIFIER = NULL, 
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
   @IsTobeReviewed BIT = NULL
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

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       
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
				ELSE IF(@FolderIdCount = 0AND @FolderId IS NOT NULL)
				BEGIN

					RAISERROR(50002,16, 2,'Folder')
            
				END
				ELSE
				BEGIN

					IF(@StoreId IS NULL AND @ReferenceId IS NOT NULL AND @ReferenceTypeId IS NOT NULL)
					BEGIN
				
						SET @StoreId = (SELECT S.Id FROM Store S JOIN Company C ON C.Id = @CompanyId AND C.InActiveDateTime IS NULL WHERE StoreName = (LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 10) + ' doc store') AND S.InActiveDateTime IS NULL AND S.CompanyId = @CompanyId)
				
					END

					IF(@FolderId IS NULL AND @ReferenceId IS NOT NULL AND @ReferenceTypeId IS NOT NULL)
					BEGIN

						DECLARE @ReferenceTypeName NVARCHAR(300) = (SELECT ReferenceTypeName + ' docs' FROM ReferenceType WHERE Id = @ReferenceTypeId AND InActiveDateTime IS NULL)
						
						DECLARE @CustomFolderId UNIQUEIDENTIFIER = NULL

						DECLARE @CustomFolderIdCount INT = (SELECT COUNT(1) FROM Folder WHERE FolderName = @ReferenceTypeName AND FolderReferenceTypeId = @ReferenceTypeId AND FolderReferenceId IS NULL AND ParentFolderId IS NULL AND StoreId = @StoreId AND InActiveDateTime IS NULL)

						DECLARE @Temp1 Table ( Id UNIQUEIDENTIFIER )

						IF(@CustomFolderIdCount = 0)
						BEGIN
			
							INSERT INTO @Temp1(Id) 
							EXEC [USP_UpsertFolder] @FolderName = @ReferenceTypeName,@StoreId = @StoreId,@FolderReferenceTypeId = @ReferenceTypeId,@OperationsPerformedBy = @OperationsPerformedBy
			
							SELECT TOP(1) @CustomFolderId =  Id FROM @Temp1

							DELETE FROM @Temp1
			
						END
						ELSE
						BEGIN 
			
							SET @CustomFolderId = (SELECT Id FROM Folder WHERE FolderName = @ReferenceTypeName AND FolderReferenceTypeId = @ReferenceTypeId AND FolderReferenceId IS NULL AND ParentFolderId IS NULL AND StoreId = @StoreId AND InActiveDateTime IS NULL)

						END

						DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM Sprints WHERE Id = @ReferenceId AND InActiveDateTime IS NULL)
						
						DECLARE @ParentFolderName NVARCHAR(300) = CASE WHEN @ReferenceTypeName = 'Project docs'			THEN (SELECT ProjectName FROM Project WHERE Id = @ReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
																		  WHEN @ReferenceTypeName = 'Goal docs'				THEN (SELECT GoalUniqueName FROM Goal WHERE Id = @ReferenceId AND InActiveDateTime IS NULL)
																		  WHEN @ReferenceTypeName = 'App docs'				THEN (SELECT ISNULL(DashboardName,[Name]) FROM WorkspaceDashboards WHERE Id = @ReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
																		  WHEN @ReferenceTypeName = 'Sprint docs'	THEN (SELECT SprintName FROM Sprints WHERE Id = @ReferenceId AND ProjectId = @ProjectId AND InActiveDateTime IS NULL)
																		  WHEN @ReferenceTypeName = 'Document store docs'   THEN (SELECT ISNULL(DashboardName,[Name]) FROM WorkspaceDashboards WHERE Id = @ReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
																		  WHEN @ReferenceTypeName = 'Audits docs'   THEN (SELECT AuditName FROM AuditCompliance WHERE Id = @ReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
																		  WHEN @ReferenceTypeName = 'Conducts docs'   THEN (SELECT AuditConductName + '-' + CONVERT(NVARCHAR(50), Id) FROM AuditConduct WHERE Id = @ReferenceId AND InActiveDateTime IS NULL)
																	 END
						IF(@ParentFolderName IS NULL)
							BEGIN
								SET @ParentFolderName = (SELECT WidgetName FROM Widget WHERE Id = @ReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
							END

						DECLARE @ParentFolderIdCount INT = (SELECT COUNT(1) FROM Folder WHERE FolderReferenceTypeId = @ReferenceTypeId AND FolderReferenceId = @ReferenceId AND ParentFolderId = @CustomFolderId AND StoreId = @StoreId AND InActiveDateTime IS NULL)
		
						IF(@ParentFolderIdCount = 0)
						BEGIN

							INSERT INTO @Temp1(Id) 
							EXEC [USP_UpsertFolder] @FolderName = @ParentFolderName,@StoreId = @StoreId,@FolderReferenceTypeId = @ReferenceTypeId,@FolderReferenceId = @ReferenceId,@ParentFolderId = @CustomFolderId,@OperationsPerformedBy = @OperationsPerformedBy
			
							SELECT TOP(1) @FolderId =  Id FROM @Temp1

							DELETE FROM @Temp1

						END
						ELSE
						BEGIN 
			
							SET @FolderId = (SELECT Id FROM Folder WHERE FolderReferenceTypeId = @ReferenceTypeId AND FolderReferenceId = @ReferenceId AND ParentFolderId = @CustomFolderId AND StoreId = @StoreId AND InActiveDateTime IS NULL)

						END

					END				


					EXEC [USP_UpsertFile] @FilesXML = @FilesXML,@FolderId = @FolderId,@StoreId= @StoreId,@ReferenceId = @ReferenceId,@ReferenceTypeId = @ReferenceTypeId, @OperationsPerformedBy = @OperationsPerformedBy, @IsFromFeedback = NULL,@IsTobeReviewed = @IsTobeReviewed

				END
			END       
			ELSE
			BEGIN

				RAISERROR (@HavePermission,11, 1)

			END

        END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO