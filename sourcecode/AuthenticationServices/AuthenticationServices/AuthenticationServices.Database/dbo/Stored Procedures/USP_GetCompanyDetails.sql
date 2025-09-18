CREATE PROCEDURE [dbo].[USP_GetCompanyDetails]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @CompanyId UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
  
    IF(@HavePermission = '1')
    BEGIN
    SELECT  [Id] AS CompanyId,
            [CompanyName],
            [SiteAddress],
            [WorkEmail],
            [Password],
            [IndustryId],
            [MainUseCaseId],
            [TeamSize],
            [PhoneNumber],
            [CountryId],
            [TimeZoneId],
            [CurrencyId],
            [NumberFormatId],
            [DateFormatId],
            [TimeFormatId],
            [CreatedDateTime],
            [InActiveDateTime],
			[TimeStamp],
			[IsSoftWare],
			[RegistrerSiteAddress]
    FROM Company WHERE Id = @CompanyId
    END
    END TRY
	BEGIN CATCH

		THROW

	END CATCH

END