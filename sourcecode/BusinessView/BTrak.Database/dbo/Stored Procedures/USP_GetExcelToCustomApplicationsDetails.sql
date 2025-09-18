CREATE PROCEDURE [dbo].[USP_GetExcelToCustomApplicationsDetails]
	@IsUploaded BIT,
    @IsHavingErrors BIT,
	@OperationsPerformedBy UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        BEGIN

            IF(@OperationsPerformedBy = CAST(0x0 as UNIQUEIDENTIFIER)) SET @OperationsPerformedBy = NULL

            DECLARE @CompanyId UNIQUEIDENTIFIER = dbo.Ufn_GetCompanyIdBasedOnUserId(@OperationsPerformedBy);

            SELECT LEFT(ExcelSheetName, IIF(CHARINDEX('.xlsx', ExcelSheetName) > 0 ,CHARINDEX('.xlsx', ExcelSheetName)- 19,CHARINDEX('.xls', ExcelSheetName)-19 ))  + IIF(CHARINDEX('.xlsx', ExcelSheetName) > 0,'.xlsx','.xls') AS ExcelSheetName,
			IsUploaded,(U.FirstName + SPACE(1) + U.SurName) as UploaderName ,CAR.CreatedDateTime AS UploadedDateTime FROM [CustomApplicationRecordsExcelDetails] CAR
			INNER JOIN [User] U  ON U.UserAuthenticationId = CAR.CreatedUserId
			WHERE CAR.CompanyId = @CompanyId AND CAR.IsUploaded = @IsUploaded AND CAR.IsHavingErrors=@IsHavingErrors
			ORDER BY CAR.CreatedDateTime DESC

        END

    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
