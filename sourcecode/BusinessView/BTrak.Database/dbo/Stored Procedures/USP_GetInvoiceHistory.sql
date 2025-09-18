-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      2020-02-28
-- Purpose      To Get Invoice History
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetInvoiceHistory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetInvoiceHistory]
(
	@InvoiceId UNIQUEIDENTIFIER = NULL,
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

		IF(@InvoiceId = '00000000-0000-0000-0000-000000000000') SET @InvoiceId = NULL

		SELECT IH.InvoiceId,
			   INV.InvoiceNumber,
			   INV.Title AS InvoiceTitle,
			   IH.OldValue,
			   -- CASE WHEN IH.[Description] = 'InvoiceDueDate' THEN CONVERT(NVARCHAR,INV.DueDate,107)
					--WHEN IH.[Description] = 'InvoiceIssueDate' THEN CONVERT(NVARCHAR,INV.IssueDate,107)
					--ELSE IH.NewValue END AS NewValue,
			   IH.NewValue,
			   IH.[Description],
			   ITN.Id AS InvoiceTaskId,
			   ITN.TaskName,
			   ITN.TaskDescription,
			   ITN.Rate,
			   ITN.[Hours],
			   IIN.Id AS InvoiceItemId,
			   IIN.ItemName,
			   IIN.ItemDescription,
			   IIN.Price,
			   IIN.Quantity,
			   CONCAT(U.FirstName, ' ',U.SurName) AS PerformedByUserName,
			   U.ProfileImage AS PerformedByUserProfileImage,
			   IH.CreatedDateTime
		FROM [InvoiceHistory] IH
			INNER JOIN Invoice_New INV ON INV.Id = IH.InvoiceId
			INNER JOIN [User] U ON U.Id = IH.CreatedByUserId
			LEFT JOIN InvoiceTask_New ITN ON ITN.Id = IH.InvoiceTaskId
			LEFT JOIN InvoiceItem_New IIN ON IIN.Id = IH.InvoiceItemId
		WHERE IH.InvoiceId = @InvoiceId
		ORDER BY IH.CreatedDateTime DESC

		END
		ELSE
		BEGIN

			RAISERROR (@HavePermission,11, 1)
				
		END

	END TRY
	BEGIN CATCH
        
        THROW

    END CATCH

END
