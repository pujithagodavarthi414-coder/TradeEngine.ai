CREATE PROCEDURE [dbo].[USP_GetPaymentReceipts]
(
	@PaymentReceiptId UNIQUEIDENTIFIER = NULL,
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


			 SELECT PR.Id,
					PR.EntryDate,
					PR.[Month],
					PR.[Year],
					PR.[Term],
				    PR.SiteId,
					S.[Name] AS SiteName,
					S.Email,
					PR.BankReceiptDate,
					PR.BankReference,
					PR.BankId,
					B.BankAccountName,
					B.Iban,
					PR.PayValue,
					PR.Comments,
					PR.CompanyId,
					PR.CreatedByUserId,
					PR.CreatedDateTime,
					PR.[TimeStamp],
					STUFF((SELECT ',' + 'NC-'+S.[Name]+'-'+LOWER(YEAR(CN.[Year]))
					FROM [PaymentReceiptCreditNotes] PRCN
						INNER JOIN [CreditNotes] CN ON CN.Id = PRCN.CreditNoteId
						INNER JOIN [Site] S ON S.Id = CN.SiteId
									 AND CN.InactiveDateTime IS NULL AND PRCN.InactiveDateTime IS NULL
									WHERE PRCN.PaymentReceiptId = PR.Id
                          ORDER BY CN.[Name]
							FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS CreditNoteNames,
					STUFF((SELECT ',' + LOWER(CN.Id)
					FROM [PaymentReceiptCreditNotes] PRCN
						INNER JOIN [CreditNotes] CN ON CN.Id = PRCN.CreditNoteId
						AND CN.InactiveDateTime IS NULL AND PRCN.InactiveDateTime IS NULL
								WHERE PRCN.PaymentReceiptId = PR.Id
                          ORDER BY CN.[Name]
			FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS CreditNoteIds,
			STUFF((SELECT ',' + GR.[GridInvoiceName]
					FROM [PaymentReceiptEntryForms] PREF
						INNER JOIN [GrERomande] GR ON GR.Id = PREF.EntryFormId
									 AND GR.InactiveDateTime IS NULL AND PREF.InactiveDateTime IS NULL
									WHERE PREF.PaymentReceiptId = PR.Id
                          ORDER BY GR.[GridInvoiceName]
							FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS EntryFormNames,
					STUFF((SELECT ',' + LOWER(GR.Id)
					FROM [PaymentReceiptEntryForms] PREF
						INNER JOIN [GrERomande] GR ON GR.Id = PREF.EntryFormId
						AND GR.InactiveDateTime IS NULL AND PREF.InactiveDateTime IS NULL
								WHERE PREF.PaymentReceiptId = PR.Id
                          ORDER BY GR.[GridInvoiceName]
			FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS EntryFormIds
			FROM [dbo].[PaymentReceipt] AS PR
			INNER JOIN [site] AS S ON S.Id = PR.SiteId
			INNER JOIN BankAccount AS B ON B.Id = PR.BankId
			WHERE PR.CompanyId = @CompanyId
			AND PR.InActiveDateTime IS NULL
			AND (@PaymentReceiptId IS NULL OR PR.Id = @PaymentReceiptId)

		END
		ELSE   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END