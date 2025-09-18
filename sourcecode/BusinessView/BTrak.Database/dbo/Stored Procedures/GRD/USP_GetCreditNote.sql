CREATE PROCEDURE [dbo].[USP_GetCreditNote]
(
	@CreditNoteId UNIQUEIDENTIFIER = NULL,
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


			 SELECT CN.Id,
				    CN.SiteId,
				    CN.Term,
				    CN.[Name],
					CN.[TVA],
				    CN.IsTVAApplied,
				    CN.IsGenerateInvoice,
					CN.InvoiceUrl,
				    CN.EntryDate,
					S.[Name] AS SiteName,
					S.Email,
					GrdId,
					GR.[Name] AS GRDName,
					[Month],
					CN.StartDate,
					CN.EndDate,
					[Year],
					CN.CompanyId,
					CN.CreatedByUserId,
					CN.CreatedDateTime,
					CN.[TimeStamp]
			FROM [dbo].[CreditNotes] AS CN
			INNER JOIN GRD AS GR ON GR.Id = CN.GrdId
			INNER JOIN [site] AS S ON S.Id = CN.SiteId
			WHERE CN.CompanyId = @CompanyId
			AND CN.InActiveDateTime IS NULL
			AND (@CreditNoteId IS NULL OR CN.Id = @CreditNoteId)
			ORDER BY CN.CreatedDateTime DESC

		END
		ELSE   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END