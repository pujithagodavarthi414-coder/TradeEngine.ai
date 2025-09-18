CREATE PROCEDURE [dbo].[USP_UpsertExcelToCustomApplicationDetails]
(
    @ExcelSheetName NVARCHAR(200),
    @IsUploaded BIT,
    @CustomApplicationId UNIQUEIDENTIFIER NULL,
    @FormId UNIQUEIDENTIFIER NULL,
    @IsHavingErrors BIT,
    @UpdateRecord BIT,
    @NeedManualCorrection BIT = 0,
    @ErrorText NVARCHAR(2000) = NULL,
    @ExcelPath NVARCHAR(2000) = NULL,
    @MailAddress NVARCHAR(500) = NULL,
    @AuthToken NVARCHAR(2000) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @CompanyId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        IF (@UpdateRecord = 0)
        BEGIN

            IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL


            IF(@CompanyId IS NULL) SET @CompanyId = dbo.Ufn_GetCompanyIdBasedOnUserId(@OperationsPerformedBy) 
            
            --Hardcoded Values
             DECLARE @ExcelSheetErrorFolder NVARCHAR(500) = 'G:\Sudharshan\excel-to-custom-application-records\error-excels',
             @ExcelSheetProcessedFolder NVARCHAR(500) = 'G:\Sudharshan\excel-to-custom-application-records\uploaded-excels';

            INSERT INTO [CustomApplicationRecordsExcelDetails]
                (
                    Id,
                    CompanyId,
                    ExcelSheetName,
                    IsUploaded,
                    CustomApplicationId,
                    FormId,
                    IsHavingErrors,
                    NeedManualCorrection,
                    [MailAddress],
                    [ExcelPath],
                    AuthToken,
                    ExcelSheetErrorFolder,
                    ExcelSheetProcessedFolder,
                    CreatedDateTime,
                    CreatedUserId,
                    UpdatedDateTime
                )
                VALUES
                (NEWID(),
                 @CompanyId,
                 @ExcelSheetName,
                 ISNULL(@IsUploaded,0),
                 @CustomApplicationId,
                 @FormId,
                 ISNULL(@IsHavingErrors,0),
                 0,
                 @MailAddress,
                 @ExcelPath,
                 @AuthToken,
                 @ExcelSheetErrorFolder,
                 @ExcelSheetProcessedFolder,
                 GETUTCDATE(),
                 @OperationsPerformedBy,
                 NULL
                )

                IF(CHARINDEX('Share India', @ExcelSheetName) > 0 AND @CompanyId = '81AD93D0-05C2-49D5-9C20-16779EDF2CA7')
                BEGIN 
                    UPDATE [CustomApplicationRecordsExcelDetails]
                           SET [CustomApplicationId] = 'ade4c047-8aef-4194-9a1b-0eec90ac7f5a'
                               ,[FormId] = '0246022b-515c-4322-8874-a91f0471cf47'
                END
                ELSE IF(@ExcelSheetName = '' AND @CompanyId = '')
                BEGIN 
                    UPDATE [CustomApplicationRecordsExcelDetails]
                           SET [CustomApplicationId] = ''
                               ,[FormId] = ''
                END

            SELECT 1 AS [Status];
        END
        ELSE
        BEGIN
            
            IF(@NeedManualCorrection IS NULL) SET @NeedManualCorrection = 0;

            UPDATE [CustomApplicationRecordsExcelDetails]
            SET IsUploaded = @IsUploaded,
                IsHavingErrors = @IsHavingErrors,
                NeedManualCorrection = @NeedManualCorrection,
                ErrorText = @ErrorText,
                UpdatedDateTime = GETUTCDATE()
            WHERE ExcelSheetName = @ExcelSheetName

            SELECT 1 AS [Status];
        END

    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END