----------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-03-06 00:00:00.000'
-- Purpose      To Get Estimates by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetEstimates] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @EstimateId = '2857B4FC-9010-49DB-8F6F-167EBDCC1E52'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEstimates]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @EstimateId UNIQUEIDENTIFIER = NULL, 
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

        DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

            IF(@SearchText   = '') SET @SearchText   = NULL

            SET @SearchText = '%'+ @SearchText +'%';       
		          
            IF(@EstimateId = '00000000-0000-0000-0000-000000000000') SET @EstimateId = NULL

			IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

			IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

			IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [Estimate])

			IF(@PageSize = 0) SET @PageSize = 10

			IF(@PageNumber IS NULL) SET @PageNumber = 1
			
			IF(@IsArchived IS NULL) SET @IsArchived = 0
           
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

			SELECT E.Id AS EstimateId,
				   E.ClientId,
				   E.CurrencyId,
				   E.EstimateStatusId,
				   ISS.InvoiceStatusName AS EstimateStatusName,
				   ISS.InvoiceStatusColor AS EstimateStatusColor,
				   C.UserId,
				   CONCAT(U.FirstName,' ',U.SurName) AS ClientName,
				   U.UserName,
				   CR.CurrencyCode,
				   CR.Symbol,
				   E.EstimateNumber,
				   E.EstimateImageUrl,
				   E.BranchId,
				   B.BranchName,
				   E.CC,
				   E.BCC,
				   E.Title,
				   E.PO,
				   E.IsRecurring,
				   E.DueDate,
				   CONVERT(NUMERIC(30,2),E.Discount) AS Discount,
				   CONVERT(NUMERIC(30,2),E.TotalAmount) AS TotalEstimateAmount,
				   CONVERT(NUMERIC(30,2),E.SubTotalAmount) AS SubTotalEstimateAmount,
				   CONVERT(NUMERIC(30,2),E.DiscountAmount) AS EstimateDiscountAmount,
				   E.Notes,
				   E.Terms,
				   E.IssueDate,
				   (SELECT ET.Id AS EstimateTaskId,
						   ET.EstimateId,
						   ET.TaskName,
						   ET.TaskDescription,
						   CONVERT(NUMERIC(30,2),ET.Rate) AS Rate,
						   CONVERT(NUMERIC(30,2),ET.[Hours]) AS [Hours],
						   ET.[Order],
						   ET.[TimeStamp]
					FROM EstimateTask ET WHERE ET.EstimateId = E.Id AND ET.InActiveDateTime IS NULL Order by ET.[Order]
					FOR XML PATH('EstimateTasksInputModel'), ROOT('EstimateTasksInputModel'), TYPE) AS EstimateTasksXml,
					(SELECT EI.Id AS EstimateItemId,
						   EI.EstimateId,
						   EI.ItemName,
						   EI.ItemDescription,
						   CONVERT(NUMERIC(30,2),EI.Price) AS Price,
						   CONVERT(NUMERIC(30,2),EI.Quantity) AS Quantity,
						   EI.[Order],
						   EI.[TimeStamp]
					FROM EstimateItem EI WHERE EI.EstimateId = E.Id AND EI.InActiveDateTime IS NULL Order by EI.[Order]
					FOR XML PATH('EstimateItemsInputModel'), ROOT('EstimateItemsInputModel'), TYPE) AS EstimateItemsXml,
				   E.CreatedByUserId,
				   E.UpdatedDateTime,
				   E.UpdatedByUserId,
				   E.InActiveDateTime,
				   E.[TimeStamp],							  
				   TotalCount = COUNT(1) OVER()  
			FROM Estimate AS E
			INNER JOIN Client C ON C.Id = E.ClientId 
			INNER JOIN [User] U ON  U.Id = C.UserId
			LEFT JOIN InvoiceStatus ISS ON ISS.Id = E.EstimateStatusId AND ISS.InActiveDateTime IS NULL AND ISS.CompanyId = @CompanyId
			LEFT JOIN Currency CR ON CR.Id = E.CurrencyId
			LEFT JOIN Branch B ON B.Id = E.BranchId
			--LEFT JOIN EstimateTask IT ON IT.EstimateId = E.Id AND IT.InactiveDateTime IS NULL
			--LEFT JOIN EstimateItem II ON II.EstimateId = E.Id AND II.InactiveDateTime IS NULL
			WHERE (@IsArchived IS NULL OR (@IsArchived = 1 AND E.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND E.InactiveDateTime IS NULL))
				AND (@EstimateId IS NULL OR E.Id = @EstimateId)
				AND (@ClientId IS NULL OR C.Id = @ClientId)
				AND (@BranchId IS NULL OR B.Id = @BranchId)
				AND (@SearchText IS NULL OR (CONCAT(U.FirstName,' ',U.SurName) LIKE @SearchText )
										 OR (CONVERT(NVARCHAR(100), E.DueDate, 107) LIKE @SearchText)
										 OR (E.EstimateNumber LIKE @SearchText)
										 OR (E.TotalAmount LIKE @SearchText)
									     OR ((CR.Symbol + CONVERT(NVARCHAR(100), CAST(E.TotalAmount AS money), 1)) LIKE @SearchText)
										 OR (ISS.InvoiceStatusName LIKE @SearchText)
										 OR (CONVERT(NVARCHAR(100), E.IssueDate, 107) LIKE @SearchText)
										 )
				AND E.CompanyId = @CompanyId
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
						CASE WHEN @SortBy = 'CreatedDateTime' THEN CAST(E.CreatedDateTime AS sql_variant)
							 WHEN @SortBy = 'EstimateNumber' THEN E.EstimateNumber
							 WHEN @SortBy = 'ClientName' THEN CONCAT(U.FirstName,' ',U.SurName)
							 WHEN @SortBy = 'TotalEstimateAmount' THEN CAST(E.TotalAmount AS sql_variant)
							 WHEN @SortBy = 'EstimateStatusName' THEN ISS.InvoiceStatusName
							 WHEN @SortBy = 'IssueDate' THEN CONVERT(NVARCHAR(100), E.IssueDate , 107)
							 WHEN @SortBy = 'DueDate' THEN CONVERT(NVARCHAR(100), E.DueDate , 107)
						END
					 END ASC,
					 CASE WHEN @SortDirection = 'DESC' THEN
						CASE WHEN @SortBy = 'CreatedDateTime' THEN CAST(E.CreatedDateTime AS sql_variant)
							 WHEN @SortBy = 'EstimateNumber' THEN E.EstimateNumber
							 WHEN @SortBy = 'ClientName' THEN CONCAT(U.FirstName,' ',U.SurName)
							 WHEN @SortBy = 'TotalEstimateAmount' THEN CAST(E.TotalAmount AS sql_variant)
							 WHEN @SortBy = 'EstimateStatusName' THEN ISS.InvoiceStatusName
							 WHEN @SortBy = 'IssueDate' THEN CONVERT(NVARCHAR(100), E.IssueDate , 107)
							 WHEN @SortBy = 'DueDate' THEN CONVERT(NVARCHAR(100), E.DueDate , 107)
						END
					 END DESC

			OFFSET ((@PageNumber - 1) * @PageSize) ROWS
			FETCH NEXT @PageSize ROWS ONLY
		   --ORDER BY E.CreatedDateTime DESC

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