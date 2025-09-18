---------------------------------------------------------------------------------------------------------------
----EXEC USP_FM_UpsertUploadDocument @ReferenceId = '2B28F734-8F71-4485-85C5-1865C5C3F39D',@ReferenceTypeId = '99F52614-3394-44FE-8C7F-F308B00E472D', 
----@FileName = 'test', @FilePath = 'https://mathstorageclassic.blob.core.windows.net/uploadedimages/4fc598f2c9f2c0cdc5e0decc18d_ft_xl--366563420.jpg',
----@FileExtension = 'jpg',@FileSize = '200', @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
----@FeatureId = 'FC361D23-F317-4704-B86F-0D6E7287EEE9'
---------------------------------------------------------------------------------------------------------------
--CREATE PROCEDURE [dbo].[USP_FM_UpsertUploadDocument]
--(
--  @FileId UNIQUEIDENTIFIER = NULL,
--  @ReferenceId UNIQUEIDENTIFIER,
--  @ReferenceTypeId UNIQUEIDENTIFIER,
--  @FileName NVARCHAR(800),
--  @FilePath NVARCHAR(2000),
--  @FileExtension NVARCHAR(2000),
--  @FileSize NVARCHAR(100) = NULL,
--  @OperationsPerformedBy UNIQUEIDENTIFIER,
--  @FeatureId UNIQUEIDENTIFIER,
--  @TimeStamp TIMESTAMP = NULL
--)
--AS 
--BEGIN    
--	SET NOCOUNT ON
--	BEGIN TRY
    
--          DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

--          IF(@HavePermission = '1')
--          BEGIN

--			  DECLARE @IsLatest BIT = (CASE WHEN @FileId IS NULL THEN 1 ELSE 
--                      CASE WHEN (SELECT [TimeStamp] FROM [UploadFile] 
--                                  WHERE OriginalId = @FileId AND AsAtInActiveDateTime IS NULL) = @TimeStamp
--                                  THEN 1 ELSE 0 END END)
								   		
--			  IF(@IsLatest = 1)
--			  BEGIN

--			      DECLARE @Currentdate DATETIME = GETDATE()

--		          DECLARE @NewFileId UNIQUEIDENTIFIER = NEWID()
		          
--                  DECLARE @OriginalId UNIQUEIDENTIFIER 
	              
--                  DECLARE @VersionNumber INT 
     	          
--	              SELECT @OriginalId = OriginalId, @VersionNumber = VersionNumber  FROM UploadFile WHERE OriginalId = @FileId AND AsAtInActiveDateTime IS NULL

--				  UPDATE [UploadFile] SET AsAtInactiveDateTime = @CurrentDate WHERE OriginalId = @FileId AND AsAtInActiveDateTime IS NULL

--		          INSERT INTO [dbo].[UploadFile](
--			        		     [Id],	
--                                 [FileName],
--                                 [FilePath], 
--                                 [FileExtension],	
--                                 [FileSize],	
--                                 [ReferenceId],	
--                                 [ReferenceTypeId],
--                                 [CreatedDateTime],	
--                                 [CreatedByUserId],	
--                                 [VersionNumber],	
--                                 [OriginalId])
--                          SELECT @NewFileId,
--								 @FileName,	
--			        			 @FilePath,	
--			        			 @FileExtension,
--								 @FileSize,	
--			        			 @ReferenceId,	
--			        			 @ReferenceTypeId,	
--			        			 @Currentdate,	
--			        			 @OperationsPerformedBy,	
--			        			 ISNULL(@VersionNumber,0) + 1,
--			        			 ISNULL(@OriginalId,@NewFileId)

--                  SET @OriginalId = (SELECT OriginalId Id FROM [dbo].[UploadFile] WHERE Id = @NewFileId)
		         
--				  EXEC [dbo].[USP_FM_InsertDocumentSet] @ReferenceId = @ReferenceId, @ReferenceTypeId = @ReferenceTypeId, 
--				  @FileId =  @OriginalId, @FolderId = NULL, @OperationsPerformedBy = @OperationsPerformedBy, @FeatureId = @FeatureId

--		          SELECT @OriginalId Id 

--			  END
--			  ELSE
--			  BEGIN

--			      RAISERROR (50008,11, 1)

--			  END
--          END
--		  ELSE
--		  BEGIN

--		       RAISERROR (@HavePermission,10, 1)

--		  END

--	END TRY  
--	BEGIN CATCH 
		
--		  EXEC USP_GetErrorInformation

--	END CATCH
--END