CREATE PROCEDURE [dbo].[USP_ReviewFile]
(
  @FileId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
	SET NOCOUNT ON
    BEGIN TRY
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        IF(@FileId = '00000000-0000-0000-0000-000000000000') SET @FileId = NULL

        IF(@FileId IS NULL)
        BEGIN
			             
            RAISERROR(50011,16, 2, 'FileId')
          
        END
        ELSE
        BEGIN
			DECLARE @FileIdCount INT = (SELECT COUNT(1) FROM [UploadFile] WHERE Id = @FileId AND InActiveDateTime IS NULL)
       
			IF(@FileIdCount = 0 AND @FileId IS NOT NULL)
            BEGIN
            
                RAISERROR(50002,16, 2,'FileId')
            
            END
            ELSE
            BEGIN

				DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			    
				IF (@HavePermission = '1')
				BEGIN
				
					DECLARE @Currentdate DATETIME = GETDATE()
			            
					DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp] FROM UploadFile WHERE Id = @FileId AND CompanyId = @CompanyId) = @TimeStamp THEN 1 ELSE 0 END)
			            
					IF(@IsLatest = 1)
					BEGIN			

						 UPDATE [dbo].[UploadFile]
							SET [ReviewedDateTime] = @Currentdate,
								[ReviewedByUserId] = @OperationsPerformedBy 
							WHERE Id = @FileId

						 SELECT Id AS FileId,FolderId,StoreId,FileSize FROM [dbo].[UploadFile] where Id = @FileId
								   
					END			   
					ELSE 		   
			
						RAISERROR (50015,11, 1)
			
				END
				ELSE
			
					RAISERROR (@HavePermission,11, 1)

			END

		END
    END TRY  
    BEGIN CATCH 
        
           THROW

    END CATCH
END
GO
