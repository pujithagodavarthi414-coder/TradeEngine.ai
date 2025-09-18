CREATE PROCEDURE [dbo].[USP_UpsertAuditFolder]
(
	@AuditFolderId UNIQUEIDENTIFIER = NULL,
	@AuditFolderName NVARCHAR(300),  
	@Description NVARCHAR(MAX) = NULL,
	@ParentAuditFolderId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN 
    SET NOCOUNT ON
	BEGIN TRY
                
		IF(@AuditFolderName = '') SET @AuditFolderName = NULL

		IF(@AuditFolderId = '00000000-0000-0000-0000-000000000000') SET @AuditFolderId = NULL  

		IF(@ParentAuditFolderId = '00000000-0000-0000-0000-000000000000') SET @ParentAuditFolderId = NULL 
		
		IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL 

		IF(@IsArchived IS NULL)SET @IsArchived = 0

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @AuditFolderNameCount INT = (SELECT COUNT(1) FROM AuditFolder 
		                                     WHERE AuditFolderName = @AuditFolderName 
											       AND (@AuditFolderId IS NULL OR Id <> @AuditFolderId) 
												   AND ProjectId = @ProjectId
												   AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)
        
		DECLARE @CustomAuditFolderId UNIQUEIDENTIFIER
		DECLARE @DeafultAuditFolderId UNIQUEIDENTIFIER

        IF(@AuditFolderName IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'AuditFolderName')
        
        END
		ELSE IF(@AuditFolderNameCount > 0)
        BEGIN
           
            RAISERROR(50001,16, 2, 'Folder')
        
        END
		ELSE IF (@ProjectId IS NULL)
        BEGIN
            RAISERROR(50011,16,1,'Project')
        END
        ELSE 

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN

				IF(@ParentAuditFolderId IS NULL)
				BEGIN
	
					SELECT @DeafultAuditFolderId = Id 
					FROM AuditFolder 
					WHERE AuditFolderName = 'Audits'
					     AND InActiveDateTime IS NULL 
						 AND CompanyId = @CompanyId 
						 AND ProjectId = @ProjectId
						 AND ParentAuditFolderId IS NULL

					IF(@DeafultAuditFolderId IS NULL)
					BEGIN

						SET @CustomAuditFolderId = NEWID()

						INSERT INTO [dbo].[AuditFolder](
												[Id],
												[AuditFolderName],
												[Description],
												CompanyId,
												[CreatedDateTime],
												[CreatedByUserId],
												[ProjectId]
											)
										 SELECT @CustomAuditFolderId,
											    'Audits',
												'Root Folder',
												@CompanyId,
												GETDATE(),
											@OperationsPerformedBy,
											@ProjectId

							SET @ParentAuditFolderId = @CustomAuditFolderId

				END
				ELSE
				BEGIN 
			
					SET @ParentAuditFolderId = @DeafultAuditFolderId

				END
			
			END

			    DECLARE @IsLatest BIT = 1 --(SELECT CASE WHEN @AuditFolderId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM AuditFolder WHERE Id = @AuditFolderId) = @TimeStamp THEN 1 ELSE 0 END END)
				
				IF(@IsLatest = 1)
					BEGIN
				    
						DECLARE @Currentdate DATETIME = GETDATE()
					
						IF(@AuditFolderId IS NULL)
						BEGIN
							SET @AuditFolderId = NEWID()

									INSERT INTO [dbo].[AuditFolder](
												[Id],
												[AuditFolderName],
												[ParentAuditFolderId],
												[Description],
												CompanyId,
												[InActiveDateTime],
												[CreatedDateTime],
												[CreatedByUserId],
												[ProjectId],
												[UpdatedDateTime]
											)
										 SELECT @AuditFolderId,
												@AuditFolderName,
												@ParentAuditFolderId,
												@Description,
												@CompanyId,
												CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
												@Currentdate,
												@OperationsPerformedBy,
												@ProjectId,
												@Currentdate

									INSERT INTO [dbo].[AuditQuestionHistory]([Id], [FolderId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
									SELECT NEWID(), @AuditFolderId, NULL, @AuditFolderName, 'AuditFolderCreated', GETDATE(), @OperationsPerformedBy				

						END
						ELSE
						BEGIN
							
							IF(@IsArchived = 1)
							BEGIN

								UPDATE AuditFolder SET UpdatedDateTime  = @Currentdate,
						                               UpdatedByUserId  = @OperationsPerformedBy,
													   InActiveDateTime = @Currentdate
								WHERE Id IN (SELECT Id FROM dbo.[Ufn_GetAuditSubFolders](@AuditFolderId))
									  AND Id <> @AuditFolderId AND @IsArchived = 1 AND InActiveDateTime IS NULL

								UPDATE AuditCompliance SET UpdatedDateTime  = @Currentdate,
						                                   UpdatedByUserId  = @OperationsPerformedBy,
													       InActiveDateTime = @Currentdate
								WHERE (AuditFolderId IN (SELECT Id FROM dbo.[Ufn_GetAuditSubFolders](@AuditFolderId))
									   OR AuditFolderId = @AuditFolderId)
									  AND @IsArchived = 1 
									  AND InActiveDateTime IS NULL

								INSERT INTO [dbo].[AuditQuestionHistory]([Id], [FolderId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
									SELECT NEWID(), @AuditFolderId, NULL, @AuditFolderName, 'AuditFolderDeleted', GETDATE(), @OperationsPerformedBy	

							END

							DECLARE @OldFolderName NVARCHAR(800) = NULL

							SELECT @OldFolderName = AuditFolderName FROM AuditFolder WHERE Id = @AuditFolderId

							UPDATE [dbo].[AuditFolder]
								SET [AuditFolderName] = @AuditFolderName
									,[ParentAuditFolderId] = @ParentAuditFolderId
									,[Description] = @Description
									,[ProjectId] = @ProjectId
									,[InActiveDateTime] = CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END
									,[UpdatedDateTime] = @Currentdate
									,[UpdatedByUserId] = @OperationsPerformedBy 
								WHERE Id = @AuditFolderId

							IF(ISNULL(@OldFolderName,'') <> @AuditFolderName)
								INSERT INTO [dbo].[AuditQuestionHistory]([Id], [FolderId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
									SELECT NEWID(), @AuditFolderId, @OldFolderName, @AuditFolderName, 'AuditFolderUpdated', GETDATE(), @OperationsPerformedBy
						END

						SELECT Id FROM [dbo].[AuditFolder] WHERE Id = @AuditFolderId
				    
					END             
					ELSE
              
							RAISERROR (50008,11, 1)
				
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
