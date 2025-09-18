-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-15 00:00:00.000'
-- Purpose      To Get the Canteen FoodItems By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetCanteenFoodItems] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetCanteenFoodItems]
(   
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	     
		 DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE InActiveDateTime IS NULL AND UserId = @OperationsPerformedBy) 

		 DECLARE @FeatureId UNIQUEIDENTIFIER = '814BCE6B-8162-425F-8222-64E802DE881E'

         DECLARE @HavePermission BIT = (CASE WHEN  (SELECT COUNT(1) FROM [RoleFeature] WHERE InActiveDateTime IS NULL AND RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy))
																										 AND FeatureId = @FeatureId) >= 1 THEN 1 ELSE 0 END)

          SELECT CFI.Id AS CanteenFoodItemId,
		         CFI.FoodItemName AS CanteenFoodItemName,
				 CFI.Price,
				 CFI.ActiveFrom,
				 CFI.ActiveTo,
				 CFI.CreatedDateTime,
				 CFI.CreatedByUserId,
				 CFI.[TimeStamp],
				TotalCount = COUNT(1) OVER()
          FROM [dbo].[CanteenFoodItem] CFI WITH (NOLOCK)
          WHERE CFI.CompanyId = @CompanyId 
			AND ((@HavePermission = 0 AND CFI.BranchId IN (SELECT BranchId FROM EmployeeEntityBranch WHERE InactiveDateTime IS NULL AND EmployeeId = @EmployeeId))
			 OR (@HavePermission = 1))
		  ORDER BY FoodItemName ASC 	

     END TRY
     BEGIN CATCH
        
           THROW

    END CATCH
END
