------------------------------------------------------------------------------------
---- Author       Sri Susmitha Pothuri
---- Created      '2019-11-08 00:00:00.000'
---- Purpose      To Get Expense Merchants by applying different filters
---- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------------------
---- EXEC [dbo].[USP_GetExpenseMerchants] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @ExpenseMerchantId = '5F805CE2-107D-4242-9403-7B14607B170A'
------------------------------------------------------------------------------------
--CREATE PROCEDURE [dbo].[USP_GetExpenseMerchants]
--(
--    @OperationsPerformedBy UNIQUEIDENTIFIER, 
--    @ExpenseMerchantId UNIQUEIDENTIFIER = NULL, 
--	@ExpenseId UNIQUEIDENTIFIER = NULL, 
--	@BranchId UNIQUEIDENTIFIER = NULL, 
--    @SearchText NVARCHAR(250) = NULL,
--	@IsArchived BIT = NULL,
--	@PageSize INT = 10,
--    @PageNumber INT = 1,
--	@SortBy NVARCHAR(100) = 'CreatedDateTime',
--    @SortDirection NVARCHAR(50) = 'DESC'
--)
--AS
--BEGIN
--   SET NOCOUNT ON
--   BEGIN TRY

--        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
--        IF (@HavePermission = '1')
--        BEGIN

--           IF(@SearchText = '') SET @SearchText = NULL

--		   SET @SearchText = '%'+ @SearchText +'%';              

--           IF(@ExpenseMerchantId = '00000000-0000-0000-0000-000000000000') SET @ExpenseMerchantId = NULL
           
--           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
--           SELECT EM.OriginalId AS ExpenseMerchantId,
--				  EM.ExpenseId,
--				  EM.MerchantName,
--				  EM.StatusId,
--				  EM.CreatedDateTime,
--                  EM.CreatedByUserId,
--				  EM.OriginalCreatedDateTime,
--				  EM.OriginalCreatedByUserId,
--				  EM.InActiveDateTime,
--				  EM.VersionNumber,
--                  EM.[TimeStamp],  
--                  TotalCount = COUNT(1) OVER()
--           FROM ExpenseMerchant AS EM
--		   LEFT JOIN Expense E ON E.OriginalId = EM.ExpenseId
--		   LEFT JOIN Branch B ON B.OriginalId = EM.BranchId AND B.AsAtInactiveDateTime IS NULL
--           WHERE (EM.AsAtInactiveDateTime IS NULL)
--				AND (E.AsAtInactiveDateTime IS NULL)
--				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND EM.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND EM.InactiveDateTime IS NULL))
--                AND (@ExpenseMerchantId IS NULL OR EM.OriginalId = @ExpenseMerchantId)
--				AND (@ExpenseId IS NULL OR EM.ExpenseId = @ExpenseId)
--				AND (@BranchId IS NULL OR B.OriginalId = @BranchId) 
--				AND (@SearchText IS NULL OR (EM.MerchantName LIKE @SearchText ))
--		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
--		  	        CASE WHEN @SortBy = 'MerchantName' THEN EM.MerchantName
--		  	       		 WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,EM.CreatedDateTime,121) AS sql_variant)
--		  	       			END
--		  			END ASC,
--		  	      	CASE WHEN @SortDirection = 'DESC' THEN
--		  	       	CASE WHEN @SortBy = 'MerchantName' THEN EM.MerchantName
--		  	       		 WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,EM.CreatedDateTime,121) AS sql_variant)
--		  	       		END
--		  	       	END DESC

--			OFFSET ((@PageNumber - 1) * @PageSize) ROWS
--		    FETCH NEXT @PageSize Rows ONLY
--        END
--        ELSE
--        BEGIN
        
--                RAISERROR (@HavePermission,11, 1)
--        END
--   END TRY
--   BEGIN CATCH
       
--       THROW

--   END CATCH 
--END
--GO
