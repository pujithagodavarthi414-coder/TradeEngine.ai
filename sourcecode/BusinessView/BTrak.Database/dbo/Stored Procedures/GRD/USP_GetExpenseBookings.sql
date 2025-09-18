CREATE PROCEDURE [dbo].[USP_GetExpenseBookings]
(
	@ExpenseBookingId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF(@HavePermission = '1')
		BEGIN				
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))


			 SELECT EB.Id,
					EB.[Type],
					EB.EntryDate,
					EB.[Month],
					EB.[Year],
					EB.[Term],
				    EB.SiteId,
					S.[Name] AS SiteName,
					S.Email,
					EB.VendorName,
					EB.InvoiceNo,
					EB.InvoiceDate,
					EB.[Description],
					EB.AccountId,
					EB.Comments,
					EB.InvoiceValue,
					EB.IsTVAApplied,
				   EB.[TVA],
					EB.CompanyId,
					EB.CreatedByUserId,
					EB.CreatedDateTime,
					EB.[TimeStamp]
			FROM [dbo].[ExpenseBooking] AS EB
			INNER JOIN [site] AS S ON S.Id = EB.SiteId
			WHERE EB.CompanyId = @CompanyId
			AND EB.InActiveDateTime IS NULL
			AND (@ExpenseBookingId IS NULL OR EB.Id = @ExpenseBookingId)

		END
		ELSE   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END