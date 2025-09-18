-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      2020-03-06
-- Purpose      To Get Estimate History
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEstimateHistory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetEstimateHistory]
(
	@EstimateId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		IF(@EstimateId = '00000000-0000-0000-0000-000000000000') SET @EstimateId = NULL

		SELECT EH.EstimateId,
			   E.EstimateNumber,
			   E.Title AS EstimateTitle,
			   EH.OldValue,
			   -- CASE WHEN IH.[Description] = 'InvoiceDueDate' THEN CONVERT(NVARCHAR,INV.DueDate,107)
					--WHEN IH.[Description] = 'InvoiceIssueDate' THEN CONVERT(NVARCHAR,INV.IssueDate,107)
					--ELSE IH.NewValue END AS NewValue,
			   EH.NewValue,
			   EH.[Description],
			   ET.Id AS EstimateTaskId,
			   ET.TaskName,
			   ET.TaskDescription,
			   ET.Rate,
			   ET.[Hours],
			   EI.Id AS EstimateItemId,
			   EI.ItemName,
			   EI.ItemDescription,
			   EI.Price,
			   EI.Quantity,
			   CONCAT(U.FirstName, ' ',U.SurName) AS PerformedByUserName,
			   U.ProfileImage AS PerformedByUserProfileImage,
			   EH.CreatedDateTime
		FROM [EstimateHistory] EH
			INNER JOIN Estimate E ON E.Id = EH.EstimateId
			INNER JOIN [User] U ON U.Id = EH.CreatedByUserId
			LEFT JOIN EstimateTask ET ON ET.Id = EH.EstimateTaskId
			LEFT JOIN EstimateItem EI ON EI.Id = EH.EstimateItemId
		WHERE EH.EstimateId = @EstimateId
		ORDER BY EH.CreatedDateTime DESC

	END TRY
	BEGIN CATCH
        
        THROW

    END CATCH

END
GO