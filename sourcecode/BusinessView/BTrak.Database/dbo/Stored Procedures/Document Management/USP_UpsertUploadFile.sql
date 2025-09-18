---------------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-07-31 00:00:00.000'
-- Purpose      To Upsert UploadFile by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertUploadFile]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@FileName = 'test3',
-- @FilePath='https://bviewstorage.blob.core.windows.net/localsiteuploads/Food_Bill_(620)_(08-09-2018)-71303f9b-f090-4531-bafe-cf3694ef4c03.jpeg',
-- @IsArchived = 1,@ReferenceTypeId = 'B367553E-79BE-4E37-8D3A-8906793BA0A8',@ReferenceId = '127133F1-4427-4149-9DD6-B02E0E036971'	,
-- @FileExtension = 'jpeg',@UploadFileId = '6034F2E2-A3B6-4BEE-BC74-3AD87ED6FC8B',@TimeStamp = 0x000000000000286D	
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertUploadFile]
(
   @UploadFileId UNIQUEIDENTIFIER = NULL,
   @FileName NVARCHAR(800) = NULL,  
   @FilePath NVARCHAR(2000) = NULL,
   @FileSize INT = NULL,
   @ReferenceId UNIQUEIDENTIFIER = NULL,
   @ReferenceTypeName NVARCHAR(800) = NULL, 
   @FolderId UNIQUEIDENTIFIER = NULL,
   @StoreId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @FileExtension NVARCHAR(50)= NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	   
	   	  IF(@FileName = '') SET @FileName = NULL

		  IF(@FilePath = '') SET @FilePath = NULL

		  IF(@FileExtension = '') SET @FileExtension = NULL

		  IF(@ReferenceId = '00000000-0000-0000-0000-000000000000') SET @ReferenceId = NULL  

	      IF(@FileName IS NULL)
		  BEGIN
		     
		      RAISERROR(50011,16, 2, 'File Name')
		  
		  END
		  IF(@FilePath IS NULL)
		  BEGIN
		     
		      RAISERROR(50011,16, 2, 'File Path')
		  
		  END
		  IF(@FileExtension IS NULL)
		  BEGIN
		     
		      RAISERROR(50011,16, 2, 'File Extension')
		  
		  END
		  IF(@ReferenceTypeName IS NULL)
		  BEGIN
		     
		      RAISERROR(50011,16, 2, 'Reference Type')
		  
		  END
		  -- IF(@ReferenceId IS NULL)
		  --BEGIN
		     
		  --    RAISERROR(50011,16, 2, 'ReferenceId')
		  
		  --END
		  ELSE 
		  
		  DECLARE @UploadFileIdCount INT = (SELECT COUNT(1) FROM UploadFile  WHERE Id = @UploadFileId)
          
		  DECLARE @FileNameCount INT = (SELECT COUNT(1) FROM UploadFile WHERE FileName = @FileName AND (@UploadFileId IS NULL OR Id <> @UploadFileId))       

		  DECLARE @ReferenceTypeId UNIQUEIDENTIFIER = (SELECT Id FROM ReferenceType WHERE ReferenceTypeName = @ReferenceTypeName)
       	  
	      IF(@UploadFileIdCount = 0 AND @UploadFileId IS NOT NULL)
          BEGIN
              
		  	RAISERROR(50002,16, 2,'UploadFile')
          
		  END
          ELSE IF(@FileNameCount > 0)
          BEGIN
          
            RAISERROR(50001,16,1,@FileName,'UploadFile')
             
          END
		  ELSE IF(@ReferenceTypeId IS NULL OR  @ReferenceTypeId = '00000000-0000-0000-0000-000000000000')
          BEGIN
          
            RAISERROR(50001,16,1,@ReferenceTypeName,'Reference type name')
             
          END
          ELSE
		 
			DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')

			BEGIN	    
       
					  DECLARE @IsLatest BIT = (CASE WHEN @UploadFileId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM UploadFile WHERE Id = @UploadFileId) = @TimeStamp THEN 1 ELSE 0 END END)
			        
					  IF(@IsLatest = 1)
					  BEGIN
			      
							DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

							DECLARE @ArchivedDateTime DATETIME = (SELECT InActiveDateTime FROM UploadFile WHERE Id = @UploadFileId)
			      
							DECLARE @Currentdate DATETIME = GETDATE()

							DECLARE @HistoryDescription NVARCHAR(800)

							IF(@UploadFileId IS NULL)
							BEGIN

							SET @UploadFileId = NEWID()

									INSERT INTO [dbo].[UploadFile](
								            [Id],
			   				 				[FileName],
											[FilePath],
											[FileSize],
											[FileExtension],
											[ReferenceId],
											[ReferenceTypeId],
											[FolderId],
											[StoreId],
			   				 				[InActiveDateTime],
			   				 				[CreatedDateTime],
			   				 				[CreatedByUserId]
			   				 				)
									 SELECT @UploadFileId,
			   				 		        @FileName,
											@FilePath,	
											@FileSize,
											@FileExtension,
											@ReferenceId,
											@ReferenceTypeId,
											@FolderId,
											@StoreId,
			   				 				CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
			   				 				@Currentdate,
			   				 				@OperationsPerformedBy

									--SET @HistoryDescription = 'File added by <em><b>' + (SELECT [dbo].[Ufn_GetUsernameBasedOnUserId] (@OperationsPerformedBy)) + 'ON' + CONVERT(NVARCHAR(50),GETDATE()) + '</br>'
							 
									--EXEC USP_InsertUploadFileHistory @FileId = @UploadFileId,@Comment = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy

							END
							ELSE
							BEGIN

								UPDATE [dbo].[UploadFile]
									SET [FileName] = @FileName
									    ,[FilePath] = @FilePath
										,[FileSize] = @FileSize
										,[FileExtension] = @FileExtension
										,[ReferenceId] = @ReferenceId
										,[ReferenceTypeId] = @ReferenceTypeId
										,[FolderId] = @FolderId
										,[StoreId] = @StoreId
										,[InActiveDateTime] = CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END
										,[UpdatedDateTime] = @Currentdate
			   				  			,[UpdatedByUserId] = @OperationsPerformedBy 
									WHERE Id = @UploadFileId                          																                               

							END

							SELECT Id FROM [dbo].[UploadFile] WHERE Id = @UploadFileId
			                    
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