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

            IF(EXISTS(SELECT 1 FROM [User] WHERE Id = @OperationsPerformedBy)) SET @OperationsPerformedBy = (SELECT UserAuthenticationId FROM [User] WHERE Id = @OperationsPerformedBy)
            
            --Hardcoded Values
             DECLARE @ExcelSheetErrorFolder NVARCHAR(500) = 'F:\excel-to-custom-application-records\error-excels',
             @ExcelSheetProcessedFolder NVARCHAR(500) = 'F:\excel-to-custom-application-records\uploaded-excels';

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
                           SET [CustomApplicationId] = 'cad14691-2ced-4ac5-9356-37cbe85ee815'
                               ,[FormId] = '7263fb39-8ad4-4e80-a33b-dbbf65993328'
							   WHERE ExcelSheetName = @ExcelSheetName
                END
                ELSE IF(CHARINDEX('Share India', @ExcelSheetName) > 0 AND @CompanyId = '406895a5-a90b-4d84-a3c5-dde1c1e139ef')
                BEGIN 
                    UPDATE [CustomApplicationRecordsExcelDetails]
                           SET [CustomApplicationId] = 'fbf75b42-3f2d-4e5c-ba24-d3a231cf3117'
                               ,[FormId] = 'df3b7422-5a3d-4355-9563-ae1c6a6c6f0a'
							   WHERE ExcelSheetName = @ExcelSheetName
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