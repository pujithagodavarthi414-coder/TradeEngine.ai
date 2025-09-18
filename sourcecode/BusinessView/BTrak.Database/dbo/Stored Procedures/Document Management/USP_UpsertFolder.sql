---------------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-07-31 00:00:00.000'
-- Purpose      To Upsert Folder by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
-- Updated By   Sai Praneeth Mamidi
-- Created      '2019-11-12 00:00:00.000'
-- Purpose      To Upsert Folder 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertFolder]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@FolderName = 'test',@IsArchived = 0 ,@FolderReferenceId = '853a06f0-145b-478d-96a2-e86696f3cdef'  
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertFolder]
(
	@FolderId UNIQUEIDENTIFIER = NULL,
	@FolderName NVARCHAR(300),  
	@DeafultFolderId UNIQUEIDENTIFIER = NULL,
	@ParentFolderId UNIQUEIDENTIFIER = NULL,
	@StoreId UNIQUEIDENTIFIER = NULL,
	@FolderReferenceId UNIQUEIDENTIFIER = NULL,
	@FolderReferenceTypeId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL,
	@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN 
    SET NOCOUNT ON
	BEGIN TRY
                
		IF(@FolderName = '') SET @FolderName = NULL

        IF(@StoreId = '00000000-0000-0000-0000-000000000000') SET @StoreId = NULL  

		IF(@FolderId = '00000000-0000-0000-0000-000000000000') SET @FolderId = NULL  

		IF(@ParentFolderId = '00000000-0000-0000-0000-000000000000') SET @ParentFolderId = NULL 

		IF(@FolderReferenceId = '00000000-0000-0000-0000-000000000000') SET @FolderReferenceId = NULL 

		IF(@FolderReferenceTypeId = '00000000-0000-0000-0000-000000000000') SET @FolderReferenceTypeId = NULL 
		
		IF(@DeafultFolderId = '00000000-0000-0000-0000-000000000000') SET @DeafultFolderId = NULL  
        
        IF(@FolderName IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'FolderName')
        
        END
        IF(@StoreId IS NULL AND @FolderReferenceId IS NULL AND @FolderReferenceTypeId IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'StoreId')
        
        END
        ELSE 

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				DECLARE @MaxSizeLimit BIGINT = (SELECT CAST([Value]AS BIGINT) FROM CompanySettings WHERE [Key] = 'DocumentsSizeLimit' AND CompanyId = @CompanyId AND InactiveDateTime IS NULL)
				DECLARE @CurrentSize BIGINT = (SELECT SUM(FileSize) FROM [UploadFile] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL GROUP BY CompanyId)
				DECLARE @FolderReferenceTypeIdCount INT = (SELECT COUNT(1) FROM ReferenceType WHERE Id = @FolderReferenceTypeId)

				IF(@CurrentSize >= (@MaxSizeLimit * 3))
				BEGIN
					RAISERROR ('MaxUploadedSizeLimitExceededForYourCompanyPleaseContactAdministrator',11, 1)
				END
				ELSE IF(@FolderReferenceTypeIdCount = 0 AND @FolderReferenceTypeId IS NOT NULL)
				BEGIN
        
					  RAISERROR(50002,16, 2,'ReferenceTypeId')
        
				END
				ELSE
				BEGIN

					IF(@StoreId IS NULL AND @FolderReferenceId IS NOT NULL AND @FolderReferenceTypeId IS NOT NULL)
					BEGIN
					
						SET @StoreId = (SELECT S.Id FROM Store S JOIN Company C ON C.Id = S.CompanyId AND C.Id = @CompanyId AND C.InActiveDateTime IS NULL WHERE StoreName = (LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 10) + ' doc store') AND S.InActiveDateTime IS NULL)
					
					END

					IF(@ParentFolderId IS NULL AND @FolderReferenceId IS NOT NULL AND @FolderReferenceTypeId IS NOT NULL)
					BEGIN

						DECLARE @ReferenceTypeName NVARCHAR(300) = (SELECT ReferenceTypeName + ' docs' FROM ReferenceType WHERE Id = @FolderReferenceTypeId AND InActiveDateTime IS NULL)
						
						DECLARE @CustomFolderId UNIQUEIDENTIFIER = NULL

						DECLARE @CustomFolderIdCount INT = (SELECT COUNT(1) FROM Folder WHERE FolderName = @ReferenceTypeName AND FolderReferenceTypeId = @FolderReferenceTypeId AND FolderReferenceId IS NULL AND ParentFolderId IS NULL AND StoreId = @StoreId AND InActiveDateTime IS NULL)

						DECLARE @Temp1 Table ( Id UNIQUEIDENTIFIER )

						IF(@CustomFolderIdCount = 0)
						BEGIN
			
						IF(@StoreId IS NULL AND @FolderReferenceId IS NOT NULL AND @FolderReferenceTypeId IS NOT NULL)
					   BEGIN
					
						SET @StoreId = (SELECT S.Id FROM Store S JOIN Company C ON C.Id = S.CompanyId AND C.Id = @CompanyId AND C.InActiveDateTime IS NULL WHERE StoreName = (LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 10) + ' doc store') AND S.InActiveDateTime IS NULL)
					
					  END	
		                SET @CustomFolderId = NEWID()

									INSERT INTO [dbo].[Folder](
													[Id],
													[FolderName],
													[StoreId],
													[FolderReferenceTypeId],
													[CreatedDateTime],
													[CreatedByUserId]                   
												)
											 SELECT @CustomFolderId,
												    @ReferenceTypeName,
													@StoreId,
													@FolderReferenceTypeId,
													GETDATE(),
													@OperationsPerformedBy

			
						END
						
						ELSE
						BEGIN 
			
							SET @CustomFolderId = (SELECT Id FROM Folder WHERE FolderName = @ReferenceTypeName AND FolderReferenceTypeId = @FolderReferenceTypeId AND FolderReferenceId IS NULL AND ParentFolderId IS NULL AND StoreId = @StoreId AND InActiveDateTime IS NULL)

						END

						DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM [dbo].[Sprints] WHERE Id = @FolderReferenceId AND InActiveDateTime IS NULL)
						DECLARE @DocumentFolderName NVARCHAR(800)

						IF(@ReferenceTypeName = 'Document store docs')
						BEGIN
							SET @DocumentFolderName = (SELECT ISNULL(DashboardName,[Name]) FROM WorkspaceDashboards WHERE Id = @FolderReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)

							IF(@DocumentFolderName IS NULL)
							BEGIN
								SET @DocumentFolderName = (SELECT WidgetName FROM Widget WHERE Id = @FolderReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
							END
						END

						DECLARE @ParentFolderName NVARCHAR(300) = CASE WHEN @ReferenceTypeName = 'Project docs'	THEN (SELECT ProjectName FROM Project WHERE Id = @FolderReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
																	  WHEN @ReferenceTypeName = 'Goal docs'		THEN (SELECT GoalUniqueName FROM Goal WHERE Id = @FolderReferenceId)-- AND InActiveDateTime IS NULL)
																	  WHEN @ReferenceTypeName = 'Sprint docs'	THEN (SELECT SprintName FROM Sprints WHERE Id = @FolderReferenceId AND ProjectId = @ProjectId AND InActiveDateTime IS NULL)
																	  WHEN @ReferenceTypeName = 'App docs'		THEN (SELECT ISNULL(DashboardName,[Name]) FROM WorkspaceDashboards WHERE Id = @FolderReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
																	  WHEN @ReferenceTypeName = 'Document store docs'   THEN @DocumentFolderName
																	  WHEN @ReferenceTypeName = 'Audits docs'   THEN (SELECT AuditName FROM AuditCompliance WHERE Id = @FolderReferenceId AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
																	  WHEN @ReferenceTypeName = 'Conducts docs'   THEN (SELECT AuditConductName + '-' + CONVERT(NVARCHAR(50), Id) FROM AuditConduct WHERE Id = @FolderReferenceId AND InActiveDateTime IS NULL)
																 END

						DECLARE @ParentFolderIdCount INT = (SELECT COUNT(1) FROM Folder WHERE FolderReferenceTypeId = @FolderReferenceTypeId AND FolderReferenceId = @FolderReferenceId AND ParentFolderId = @CustomFolderId AND StoreId = @StoreId AND InActiveDateTime IS NULL)
		
						IF(@ParentFolderIdCount = 0)
						BEGIN
						    

							INSERT INTO @Temp1(Id) 
							EXEC [USP_UpsertFolder] @FolderName = @ParentFolderName,@StoreId = @StoreId,@FolderReferenceTypeId = @FolderReferenceTypeId,@FolderReferenceId = @FolderReferenceId,@ParentFolderId = @CustomFolderId,@OperationsPerformedBy = @OperationsPerformedBy
			
							SELECT TOP(1) @ParentFolderId =  Id FROM @Temp1

							DELETE FROM @Temp1

						END
						ELSE
						BEGIN 
			
							SET @ParentFolderId = (SELECT Id FROM Folder WHERE FolderReferenceTypeId = @FolderReferenceTypeId AND FolderReferenceId = @FolderReferenceId AND ParentFolderId = @CustomFolderId AND StoreId = @StoreId AND InActiveDateTime IS NULL)

						END

					END
					IF (@ParentFolderId IS NULL AND @StoreId IS NOT NULL AND @FolderReferenceTypeId = 'DF52BB58-F895-4C7F-B0C1-5D3C5737CC3E')
						BEGIN

				          IF(@FolderId IS NULL)
				          BEGIN

				           DECLARE @StoreName  NVARCHAR(250) = (SELECT StoreName FROM Store WHERE Id = @StoreId AND InActiveDateTime IS NULL)

				          --SET @FolderId = (SELECT F.Id FROM Folder F INNER JOIN Store S ON S.Id = f.StoreId WHERE FolderName =  @StoreName +' store docs' AND CompanyId = @CompanyId  and s.InActiveDateTime IS NULL)

				         --IF(@FolderId IS NULL)
				         --BEGIN
				         
				          SET @ParentFolderId = NEWID()
				         
				          	INSERT INTO [dbo].[Folder](
					       				  [Id],
					       				  [FolderName],
					       				  [StoreId],
					       				  [FolderReferenceTypeId],
					       				  [CreatedDateTime],
					       				  [CreatedByUserId]                   
					       				  )
					       		   SELECT @ParentFolderId,
					       				  @StoreName +' store docs',
					       				  @StoreId,
					       				  @FolderReferenceTypeId,
					       				  GETDATE(),
					       				  @OperationsPerformedBy

                           -- END
				         END

						END
				
					DECLARE @FolderIdCount INT = (SELECT COUNT(1) FROM Folder  WHERE Id = @FolderId)
          
					DECLARE @FolderNameCount INT = (SELECT COUNT(1) FROM Folder WHERE FolderName = @FolderName AND ([FolderReferenceId] = @FolderReferenceId OR @FolderReferenceId IS NULL)
					AND ((@ParentFolderId IS NOT NULL AND ParentFolderId = @ParentFolderId) OR (@ParentFolderId IS NULL AND StoreId = @StoreId)) AND(@FolderId IS NULL OR Id <> @FolderId) AND InActiveDateTime IS NULL)       
          
					IF(@FolderIdCount = 0 AND @FolderId IS NOT NULL)
					BEGIN
            
					   RAISERROR(50002,16, 2,'Folder')
          
					END
					ELSE IF(@FolderNameCount>0)
					BEGIN
          
					   RAISERROR(50001,16,2,'Folder')
            
					END
					ELSE
					BEGIN
				
						DECLARE @IsLatest BIT = 1--(CASE WHEN @FolderId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM Folder WHERE Id = @FolderId) = @TimeStamp THEN 1 ELSE 0 END END)
				
						IF(@IsLatest = 1)
						BEGIN
				    
							DECLARE @Currentdate DATETIME = GETDATE()
						
							IF(@FolderId IS NULL)
							BEGIN
								SET @FolderId = ISNULL(@DeafultFolderId,NEWID())
										INSERT INTO [dbo].[Folder](
													[Id],
													[FolderName],
													[ParentFolderId],
													[StoreId],
													[FolderReferenceId],
													[FolderReferenceTypeId],
													[InActiveDateTime],
													[CreatedDateTime],
													[CreatedByUserId]                   
												)
											 SELECT @FolderId,
													@FolderName,
													@ParentFolderId,
													@StoreId,
													@FolderReferenceId,
													@FolderReferenceTypeId,
													CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
													@Currentdate,
													@OperationsPerformedBy
							END
							ELSE
							BEGIN
								UPDATE [dbo].[Folder]
									SET [FolderName] = @FolderName
										,[ParentFolderId] = @ParentFolderId
										,[StoreId] = @StoreId
										,[FolderReferenceId] = @FolderReferenceId
										,[FolderReferenceTypeId] = @FolderReferenceTypeId
										,[InActiveDateTime] = CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END
										,[UpdatedDateTime] = @Currentdate
										,[UpdatedByUserId] = @OperationsPerformedBy 
									WHERE Id = @FolderId
							END

							IF(@DeafultFolderId IS NULL)
							SELECT Id AS FolderId
							FROM [dbo].[Folder] WHERE Id = @FolderId
				      
						END             
						ELSE
              
								RAISERROR (50008,11, 1)
				
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