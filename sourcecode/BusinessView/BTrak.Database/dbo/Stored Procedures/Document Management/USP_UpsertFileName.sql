CREATE PROCEDURE [dbo].[USP_UpsertFileName]
(
   @FileId UNIQUEIDENTIFIER = NULL,
   @FileName NVARCHAR(MAX) = NULL,  
   @FileSize BIGINT = NULL,  
   @FilePath NVARCHAR(MAX) = NULL,  
   @FileExtension NVARCHAR(100) = NULL,  
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@FileName = '') SET @FileName = NULL

	    IF(@FileName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'FileName')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        DECLARE @FileCount INT = (SELECT COUNT(1) FROM UploadFile WHERE Id = @FileId)

        DECLARE @FolderId UNIQUEIDENTIFIER = (SELECT FolderId FROM UploadFile WHERE Id = @FileId)

		DECLARE @FileNameCount INT = (SELECT COUNT(1) FROM UploadFile WHERE [FileName] = @FileName AND CompanyId = @CompanyId and FolderId = @FolderId AND Id <> @FileId)
        
        IF(@FileCount = 0 AND @FileId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'File')

        END
		ELSE IF(@FileNameCount > 0)
        BEGIN
        
          RAISERROR(50001,16,1,'File')
           
        END
        ELSE
        BEGIN
       
             DECLARE @HavePermission NVARCHAR(250)  = 1--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
             IF (@HavePermission = '1')
             BEGIN
                        
                IF(@FileId IS NOT NULL AND @TimeStamp IS NULL)
                BEGIN
                  SET @TimeStamp = (SELECT [TimeStamp] FROM [UploadFile] WHERE Id = @FileId)
                END
                  DECLARE @IsLatest BIT = (CASE WHEN @FileId  IS NULL 
                                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                                FROM [UploadFile] WHERE Id = @FileId) = @TimeStamp
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
                                   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                   @Currentdate,
                                   @OperationsPerformedBy        
                                   
						END
						ELSE
						BEGIN

						IF(@FileExtension IS NULL)
						BEGIN
							SET @FileExtension = (SELECT FileExtension FROM UploadFile WHERE Id = @FileId AND InActiveDateTime IS NULL)
						END

						UPDATE [UploadFile]
						   SET [CompanyId] = @CompanyId,
                               [FileName] = @FileName,
							   [FilePath] = @FilePath,
							   FileExtension = @FileExtension,
							   FileSize = @FileSize,
                               [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							   UpdatedDateTime = @Currentdate,
							   UpdatedByUserId = @OperationsPerformedBy
							   WHERE Id = @FileId

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