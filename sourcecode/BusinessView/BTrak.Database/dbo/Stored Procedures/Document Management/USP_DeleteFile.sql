----------------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-11-22 00:00:00.000'
-- Purpose      To Delete File 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_DeleteFile] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @FileId = '4E69F14D-74D1-4B2A-AF03-016BDD48127E',@TimeStamp = 0x0000000000005E22
----------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_DeleteFile]
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
			            
					DECLARE @IsLatest BIT = 1
			            
					IF(@IsLatest = 1)
					BEGIN						                          
						
						DECLARE @ExpenseId UNIQUEIDENTIFIER = (SELECT ReferenceId FROM UploadFile UF JOIN Expense E ON UF.ReferenceId = E.Id AND UF.Id = @FileId)

						 UPDATE [dbo].[UploadFile]
							SET [InActiveDateTime] = @Currentdate,
								[UpdatedDateTime] = @Currentdate,
								[UpdatedByUserId] = @OperationsPerformedBy 

							WHERE Id = @FileId
			             
						 IF(@ExpenseId IS NOT NULL)
						 BEGIN
							INSERT INTO ExpenseHistory(
											 Id,
											 ExpenseId,
											 FieldName,
											 [Description],
											 CreatedByUserId,
											 CreatedDateTime
											)
										  SELECT  NEWID(),
										          @ExpenseId,
										          'ReceiptDeleted',
												  'ReceiptDeleted',
												  @OperationsPerformedBy,
												  GETDATE()	
						 END

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