--EXEC [USP_UpserFileDetails] @FileId='5a3be4aa-4e55-4424-b45c-b3b1da447b79',@FileExtension='.mp4',@FileName='file_example_MP4_480_1_5MG-1b4e70e8-5d58-452f-88e8-aa735f672990.mp4',
--@FilePath='https://bviewstorage.blob.core.windows.net/51ef0ac5-c721-4518-bd48-985ca6c20f00/projects/84e33321-a7b5-4c95-8c68-0f901b6df670/file_example_MP4_480_1_5MG-1b4e70e8-5d58-452f-88e8-aa735f672990-021a0339-7521-422c-8a0c-40e5348f28ce.mp4',
--@FileSize=2621440,@ReferenceId='bdf12472-abb6-4510-8981-8aa2063f52a6',@referenceTypeId='df52bb58-f895-4c7f-b0c1-5d3c5737cc3e',
--@FolderId='bdf12472-abb6-4510-8981-8aa2063f52a6',@StoreId='3df70b6c-be04-4626-a719-1b0a17db1f7f',
--@OperationsPerformedBy='84e33321-a7b5-4c95-8c68-0f901b6df670'

CREATE PROCEDURE [dbo].[USP_UpserFileDetails]
(
   @FileId UNIQUEIDENTIFIER = NULL,
   @FileName NVARCHAR(MAX) = NULL,
   @FilePath NVARCHAR(MAX) = NULL,
   @FileExtension NVARCHAR(50) = NULL,
   @FileSize BIGINT = NULL,
   @ReferenceId UNIQUEIDENTIFIER = NULL,
   @ReferenceTypeId UNIQUEIDENTIFIER = NULL,
   @FolderId UNIQUEIDENTIFIER = NULL,
   @StoreId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF(@FileId = '00000000-0000-0000-0000-000000000000') SET @FileId = NULL

			IF(@FileName = '') SET @FileName = NULL

			IF(@FileName IS NULL)
			BEGIN
			    RAISERROR(50011,16, 2, 'FileName')
			END
			ELSE IF(@FilePath IS NULL)
			BEGIN
			    RAISERROR(50011,16, 2, 'FilePath')
			END
			ELSE IF(@FileExtension IS NULL)
			BEGIN
			    RAISERROR(50011,16, 2, 'FileExtension')
			END
			ELSE IF(@FileSize IS NULL)
			BEGIN
			    RAISERROR(50011,16, 2, 'FileSize')
			END
			ELSE
			BEGIN
			DECLARE @FileIdCount INT = (SELECT COUNT(1) FROM [UploadFile]  WHERE Id = @FileId AND InactiveDateTime IS NULL)

			DECLARE @FileNameCount INT = (SELECT COUNT(1) FROM [UploadFile] WHERE FileName = @FileName AND CompanyId = @CompanyId AND FolderId = @FolderId AND (@FileId IS NULL OR Id <> @FileId) AND InactiveDateTime IS NULL)
			
			IF(@FileIdCount = 0 AND @FileId IS NOT NULL)
			BEGIN
			    RAISERROR(50002,16, 2,'File')
			END
			ELSE IF(@FileNameCount > 0)
			BEGIN
			  RAISERROR(50001,16,1,'File')
			 END
			 ELSE
			  BEGIN
			     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				 
				 IF (@HavePermission = '1')
				 BEGIN
				 	DECLARE @IsLatest BIT = (CASE WHEN @FileId  IS NULL
				 	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
				                                                            FROM [uploadfile] WHERE Id = @FileId) = @TimeStamp
				 													THEN 1 ELSE 0 END END)
					 IF(@IsLatest = 1)
					 BEGIN
					      DECLARE @Currentdate DATETIME = GETDATE()
						
						IF(@FileId IS NULL)
						BEGIN

						SET @FileId = NEWID()

						INSERT INTO [dbo].[UploadFile](
						             [Id],
									 [CompanyId],
									 [FileName],
									 [FilePath],
									 [FileExtension],
									 [FileSize],
									 [FolderId],
									 [StoreId],
									 [ReferenceTypeId],
									 [ReferenceId],
									 [InActiveDateTime],
									 [CreatedDateTime],
									 [CreatedByUserId]					
									 )
						      SELECT @FileId,
									 @CompanyId,
									 @FileName,
									 @FilePath,
									 @FileExtension,
									 @FileSize,
									 @FolderId,
									 @StoreId,
									 @ReferenceTypeId,
									 @ReferenceId,
									 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
									 @Currentdate,
									 @OperationsPerformedBy
							
						END
						ELSE
						BEGIN
						
						DECLARE @PreviousFolderId UNIQUEIDENTIFIER = (SELECT FolderId FROM [UploadFile] WHERE Id = @FileId AND InActiveDateTime IS NULL)
						DECLARE @PreviousStoreId UNIQUEIDENTIFIER = (SELECT StoreId FROM [UploadFile] WHERE Id = @FileId AND InActiveDateTime IS NULL)

						EXEC [USP_UpsertFolderAndStoreSize] @FolderId = @PreviousFolderId,@StoreId = @PreviousStoreId,@FilesSize = @FileSize,@IsDeletion = 1,@OperationsPerformedBy = @OperationsPerformedBy

							UPDATE [dbo].[UploadFile]
								SET  [CompanyId]		=   @CompanyId,
									 [FileName]			=   @FileName,
									 [FilePath]			=   @FilePath,
									 [FileExtension]	=   @FileExtension,
									 [FileSize]			=   @FileSize,
									 [FolderId]			=   @FolderId,
									 [StoreId]			=   @StoreId,
									 [ReferenceTypeId]	=   @ReferenceTypeId,
									 [ReferenceId]		=   @ReferenceId,
									 [InActiveDateTime]	=   CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
									 [UpdatedDateTime]	=   @Currentdate,
									 [UpdatedByUserId]	=   @OperationsPerformedBy
								WHERE Id = @FileId

						EXEC [USP_UpsertFolderAndStoreSize] @FolderId = @FolderId,@StoreId = @StoreId,@FilesSize = @FileSize,@IsDeletion = 0,@OperationsPerformedBy = @OperationsPerformedBy

						END
						     SELECT Id FROM [dbo].[UploadFile] WHERE Id = @FileId
					  END
					  ELSE
					  		RAISERROR (50008,11, 1)
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