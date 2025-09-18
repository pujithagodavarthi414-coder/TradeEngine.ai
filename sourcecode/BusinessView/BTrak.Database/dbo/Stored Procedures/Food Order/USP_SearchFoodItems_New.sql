-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Search the FoodItems By Applying different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------------
--EXEC [dbo].[USP_SearchFoodItems_New] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@SearchText='15'
------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SearchFoodItems_New]
(   
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@FoodItemId  UNIQUEIDENTIFIER = NULL,
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL,
	@PageNumber INT = 1,
	@PageSize INT = 10,
	@SortBy NVARCHAR(100) = NULL,
	@SortDirection NVARCHAR(100) = NULL,
	@SearchText  NVARCHAR(100) = NULL,
    @EntityId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL --TODO
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

			DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		    
			IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

			IF(@HavePermission = '1')
			BEGIN

				 DECLARE @Count INT = (SELECT COUNT(1) FROM CanteenFoodItem)

				 IF(@Count >= 1)
				 BEGIN   

				 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
					
				DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE InActiveDateTime IS NULL AND UserId = @OperationsPerformedBy) 

			   DECLARE @FeatureId UNIQUEIDENTIFIER = '814BCE6B-8162-425F-8222-64E802DE881E'

               DECLARE @CanteenPermit BIT = (CASE WHEN  EXISTS(SELECT 1 FROM [RoleFeature] WHERE InActiveDateTime IS NULL AND RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy))
																											 AND FeatureId = @FeatureId ) THEN 1 ELSE 0 END)

				 IF(@SearchText = '')  SET @SearchText = NULL

				 SET @SearchText = LTRIM(RTRIM(@SearchText))

				 SET @SearchText = '%'+ @SearchText+'%'
	         
				 SELECT CFI.Id AS FoodItemId,
						CFI.FoodItemName AS FoodItemName,
						CFI.Price,
						CFI.ActiveFrom,
						CFI.ActiveTo,
						CFI.CurrencyId,
						C.CurrencyName,
						B.BranchName,
						CFI.BranchId,
						CFI.CreatedDateTime AS ItemAddedDate,
						CFI.CreatedByUserId,
						CreatedByUserName=(SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') FROM [User] U WHERE U.Id = CFI.CreatedByUserId),
						TotalCount = COUNT(1) OVER(),
						CFI.[TimeStamp]
				   FROM [dbo].[CanteenFoodItem] CFI WITH (NOLOCK)
				        INNER JOIN Currency C ON C.Id = CFI.CurrencyId AND C.InActiveDateTime IS NULL
				        INNER JOIN Branch B ON B.Id = CFI.BranchId AND B.InActiveDateTime IS NULL
				 WHERE CFI.CompanyId = @CompanyId 
				       AND CFI.[ActiveFrom] <= GETDATE() AND (CFI.[ActiveTo] IS NULL OR CFI.[ActiveTo] >= GETDATE())
					   AND (@FoodItemId IS NULL OR CFI.Id = @FoodItemId)
					   AND (@DateFrom IS NULL OR CFI.ActiveFrom = @DateFrom)
					   AND (@DateTo IS NULL OR CFI.ActiveTo = @DateTo)
					   AND ((CFI.BranchId IN (SELECT BranchId FROM EmployeeEntityBranch WHERE InactiveDateTime IS NULL AND EmployeeId = @EmployeeId) AND @CanteenPermit = 0) 
					   OR @CanteenPermit = 1)
					   AND (@EntityId IS NULL OR CFI.BranchId IN (SELECT BranchId FROM EntityBranch WHERE InActiveDateTime IS NULL AND EntityId = @EntityId))
					   AND (@SearchText IS NULL OR (CFI.FoodItemName LIKE @SearchText)
										 OR(CONVERT(NVARCHAR(250),CFI.Price) LIKE @SearchText)
										 --OR (CONVERT(NVARCHAR(250),CONVERT(DATE,CFI.ActiveFrom)) LIKE @SearchText)
										 --OR (CONVERT(NVARCHAR(250),CONVERT(DATE,CFI.ActiveTo)) LIKE @SearchText)
										 OR (REPLACE(CONVERT(NVARCHAR,CFI.CreatedDateTime,106),' ','-')) LIKE @SearchText
										 )
				 ORDER BY 
					CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
						 CASE  WHEN(@SortBy IS NULL OR @SortBy = 'FoodItemName') THEN CFI.FoodItemName
							   WHEN(@SortBy = 'Price') THEN CFI.Price
							   WHEN @SortBy = 'ActiveFrom' THEN Cast(CFI.ActiveFrom as sql_variant)
							   WHEN @SortBy = 'ActiveTo' THEN Cast(CFI.ActiveTo as sql_variant)
							   WHEN @SortBy = 'ItemAddedDate' THEN  Cast (CFI.CreatedDateTime as date)
						  END
					 END ASC,
					 CASE WHEN @SortDirection = 'DESC' THEN
						 CASE  WHEN(@SortBy IS NULL OR @SortBy = 'FoodItemName') THEN CFI.FoodItemName
							   WHEN(@SortBy = 'Price') THEN CFI.Price
							   WHEN @SortBy = 'ActiveFrom' THEN Cast(CFI.ActiveFrom as sql_variant)
							   WHEN @SortBy = 'ActiveTo' THEN Cast(CFI.ActiveTo as sql_variant)
							   WHEN @SortBy = 'ItemAddedDate' THEN  Cast (CFI.CreatedDateTime as date)
							   END
					  END DESC OFFSET ((@PageNumber - 1) * @PageSize) ROWS
				
				FETCH NEXT @PageSize ROWS ONLY

				 END
				 ELSE
				 BEGIN
		     
					 RAISERROR (50002,11, 1,'FoodItems')
		     
				 END
			END
			ELSE
			BEGIN

				 RAISERROR (@HavePermission,10, 1)

			END
	 END TRY
	 BEGIN CATCH
    
		   THROW

	END CATCH
END
GO
