----------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-03-02 00:00:00.000'
-- Purpose      To Get Invoices by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetInvoices] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @InvoiceId = '2857B4FC-9010-49DB-8F6F-167EBDCC1E52'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetInvoices]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @InvoiceId UNIQUEIDENTIFIER = NULL, 
	@ClientId UNIQUEIDENTIFIER = NULL, 
    @SearchText NVARCHAR(250) = NULL,
    @IsArchived BIT = NULL,
	@ProjectActive BIT = NULL,
	@SortBy NVARCHAR(100) = NULL,
	@SortDirection NVARCHAR(50) = NULL,
	@BranchId NVARCHAR(250) = NULL,
	@PageSize INT = NULL,
	@PageNumber INT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

            IF(@SearchText   = '') SET @SearchText   = NULL

            SET @SearchText = '%'+ @SearchText +'%';       
		          
            IF(@InvoiceId = '00000000-0000-0000-0000-000000000000') SET @InvoiceId = NULL

			IF(@SortBy IS NULL) SET @SortBy = 'InvoiceNumber'

			IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

			IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [Invoice_New])

			IF(@PageSize = 0) SET @PageSize = 10

			IF(@PageNumber IS NULL) SET @PageNumber = 1

			IF(@IsArchived IS NULL) SET @IsArchived = 0
           
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

			SELECT I.Id AS InvoiceId,
				   I.ClientId,
				   I.CurrencyId,
				   I.InvoiceStatusId,
				   ISS.InvoiceStatusName,
				   ISS.InvoiceStatusColor,
				   C.UserId,
				   CONCAT(U.FirstName,' ',U.SurName) AS ClientName,
				   U.UserName,
				   CR.CurrencyCode,
				   CR.Symbol,
				   I.InvoiceNumber,
				   I.InvoiceImageUrl,
				   I.BranchId,
				   B.BranchName,
				   I.CC,
				   I.BCC,
				   I.Title,
				   I.PO,
				   I.IsRecurring,
				   I.DueDate,
				   CONVERT(NUMERIC(30,2),I.Discount) AS Discount,
				   CONVERT(NUMERIC(30,2),I.TotalAmount) AS TotalInvoiceAmount,
				   CONVERT(NUMERIC(30,2),I.SubTotalAmount) AS SubTotalInvoiceAmount,
				   CONVERT(NUMERIC(30,2),I.DiscountAmount) AS InvoiceDiscountAmount,
				   I.Notes,
				   I.Terms,
				   I.IssueDate,
				   (SELECT ITN.Id AS InvoiceTaskId,
						   ITN.InvoiceId,
						   ITN.TaskName,
						   ITN.TaskDescription,
						   CONVERT(NUMERIC(30,2),ITN.Rate) AS Rate,
						   CONVERT(NUMERIC(30,2),ITN.[Hours]) AS [Hours],
						   ITN.[Order],
						   ITN.[TimeStamp]
					FROM InvoiceTask_New ITN WHERE ITN.InvoiceId = I.Id AND ITN.InActiveDateTime IS NULL Order by ITN.[Order]
					FOR XML PATH('InvoiceTasksInputModel'), ROOT('InvoiceTasksInputModel'), TYPE) AS InvoiceTasksXml,
					(SELECT IIN.Id AS InvoiceItemId,
						   IIN.InvoiceId,
						   IIN.ItemName,
						   IIN.ItemDescription,
						   CONVERT(NUMERIC(30,2),IIN.Price) AS Price,
						   CONVERT(NUMERIC(30,2),IIN.Quantity) AS Quantity,
						   IIN.[Order],
						   IIN.[TimeStamp]
					FROM InvoiceItem_New IIN WHERE IIN.InvoiceId = I.Id AND IIN.InActiveDateTime IS NULL Order by IIN.[Order]
					FOR XML PATH('InvoiceItemsInputModel'), ROOT('InvoiceItemsInputModel'), TYPE) AS InvoiceItemsXml,
				   ISNULL(IPL.AmountPaid,0) AS AmountPaid,
				   ISNULL((I.TotalAmount - ISNULL(IPL.AmountPaid,0)),0) AS DueAmount,
				   I.CreatedByUserId,
				   I.UpdatedDateTime,
				   I.UpdatedByUserId,
				   I.InActiveDateTime,
				   I.[TimeStamp],							  
				   TotalCount = COUNT(1) OVER()  
			FROM Invoice_New AS I
			INNER JOIN Client C ON C.Id = I.ClientId 
			INNER JOIN [User] U ON  U.Id = C.UserId 
			LEFT JOIN InvoiceStatus ISS ON ISS.Id = I.InvoiceStatusId AND ISS.InActiveDateTime IS NULL AND ISS.CompanyId = @CompanyId
			LEFT JOIN (SELECT IPL1.InvoiceId,SUM(IPL1.AmountPaid) AS AmountPaid FROM InvoicePaymentLog IPL1 
						INNER JOIN Invoice_New INV1 ON INV1.Id = IPL1.InvoiceId AND INV1.CompanyId = @CompanyId
						GROUP BY InvoiceId) IPL ON IPL.InvoiceId = I.Id
			LEFT JOIN Currency CR ON CR.Id = I.CurrencyId
			LEFT JOIN Branch B ON B.Id = I.BranchId
			--LEFT JOIN InvoiceTask_New IT ON IT.InvoiceId = I.Id AND IT.InactiveDateTime IS NULL
			--LEFT JOIN InvoiceItem_New II ON II.InvoiceId = I.Id AND II.InactiveDateTime IS NULL
			WHERE (@IsArchived IS NULL OR (@IsArchived = 1 AND I.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND I.InactiveDateTime IS NULL))
				AND (@InvoiceId IS NULL OR I.Id = @InvoiceId)
				AND (@ClientId IS NULL OR C.Id = @ClientId)
				AND (@BranchId IS NULL OR B.Id = @BranchId)
				AND (@SearchText IS NULL OR (CONCAT(U.FirstName,' ',U.SurName) LIKE @SearchText )
										 OR (CONVERT(NVARCHAR(100), I.DueDate, 107) LIKE @SearchText)
										 OR (I.InvoiceNumber LIKE @SearchText)
										 OR (I.TotalAmount LIKE @SearchText)
										 OR (CR.Symbol LIKE @SearchText)
										 OR ((CR.Symbol + CONVERT(NVARCHAR(100), CAST(I.TotalAmount AS money), 1)) LIKE @SearchText)
										 OR (ISS.InvoiceStatusName LIKE @SearchText)
										 OR (CONVERT(NVARCHAR(100), I.IssueDate, 107) LIKE @SearchText)
										 )
				AND I.CompanyId = @CompanyId
			ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
						CASE WHEN @SortBy = 'CreatedDateTime' THEN CAST(I.CreatedDateTime AS sql_variant)
							 WHEN @SortBy = 'InvoiceNumber' THEN I.InvoiceNumber
							 WHEN @SortBy = 'ClientName' THEN CONCAT(U.FirstName,' ',U.SurName)
							 WHEN @SortBy = 'TotalInvoiceAmount' THEN CAST(I.TotalAmount AS sql_variant)
							 WHEN @SortBy = 'InvoiceStatusName' THEN ISS.InvoiceStatusName
							 WHEN @SortBy = 'IssueDate' THEN CONVERT(NVARCHAR(100), I.IssueDate , 107)
							 WHEN @SortBy = 'DueDate' THEN CONVERT(NVARCHAR(100), I.DueDate , 107)
						END
					 END ASC,
					 CASE WHEN @SortDirection = 'DESC' THEN
						CASE WHEN @SortBy = 'CreatedDateTime' THEN CAST(I.CreatedDateTime AS sql_variant)
							 WHEN @SortBy = 'InvoiceNumber' THEN I.InvoiceNumber
							 WHEN @SortBy = 'ClientName' THEN CONCAT(U.FirstName,' ',U.SurName)
							 WHEN @SortBy = 'TotalInvoiceAmount' THEN CAST(I.TotalAmount AS sql_variant)
							 WHEN @SortBy = 'InvoiceStatusName' THEN ISS.InvoiceStatusName
							 WHEN @SortBy = 'IssueDate' THEN CONVERT(NVARCHAR(100), I.IssueDate , 107)
							 WHEN @SortBy = 'DueDate' THEN CONVERT(NVARCHAR(100), I.DueDate , 107)
						END
					 END DESC

			OFFSET ((@PageNumber - 1) * @PageSize) ROWS
			FETCH NEXT @PageSize ROWS ONLY
		   --ORDER BY I.CreatedDateTime DESC

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
GO
