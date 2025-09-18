CREATE PROCEDURE [dbo].[USP_GetExcelSheetDetails]
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        BEGIN
            SELECT ExcelSheetName AS ExcelSheetName,
                   IsUploaded,
                   ExcelPath,
                   ExcelSheetErrorFolder,
                   ExcelSheetProcessedFolder,
                   CAR.CompanyId,
                   CustomApplicationId,
                   FormId,
                   (U.FirstName + SPACE(1) + U.SurName) as CreatedUserName,
                   CAR.CreatedUserId,
                   CAR.CreatedDateTime AS UploadedDateTime,
                   CAR.AuthToken
            FROM [CustomApplicationRecordsExcelDetails] CAR
                INNER JOIN [User] U
                    ON U.UserAuthenticationId = CAR.CreatedUserId
            WHERE CAR.IsUploaded = 0
                  AND CAR.IsHavingErrors = 0
            ORDER BY CAR.CreatedDateTime DESC

        END

    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END