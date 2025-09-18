-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Search the Canteen purchases by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------------

--EXEC [dbo].[USP_SearchCanteenPurchases_New] @OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308',@PageSize=100,@UserId = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_SearchCanteenPurchases_New]
(   
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@UserId  UNIQUEIDENTIFIER = NULL,
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(100) = NULL,
    @EntityId UNIQUEIDENTIFIER = NULL,
    @SearchText  NVARCHAR(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = '1')
		BEGIN
		
		IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  IF (@SearchText = '') SET @SearchText = NULL

		  SET @SearchText = LTRIM(RTRIM(@SearchText))

		  SET @SearchText = '%'+ @SearchText+'%'

		  DECLARE @IsBalanceOnly BIT = (CASE WHEN EXISTS(SELECT 1 FROM UserPurchasedCanteenFoodItem UPCF JOIN [User] U ON U.Id = UPCF.UserId 
		                                                 JOIN CanteenFoodItem CFI ON CFI.Id = UPCF.FoodItemId AND (@UserId IS NULL OR U.Id = @UserId) 
														 AND (CFI.ActiveTo IS NULL OR CFI.ActiveTo >= GETDATE())
		                                                 AND (@SearchText IS NULL OR (CFI.FoodItemName LIKE @SearchText)
			                                              OR (CONVERT(NVARCHAR(250),CFI.Price) LIKE @SearchText)
										                  OR (REPLACE(CONVERT(NVARCHAR,CFI.CreatedDateTime,106),' ','-')) LIKE @SearchText
										                  OR (REPLACE(CONVERT(NVARCHAR,UPCF.PurchasedDateTime,106),' ','-')) LIKE @SearchText
										                  OR (ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') LIKE @SearchText)
										                  OR (UPCF.Quantity LIKE @SearchText))) THEN 1 ELSE 0 END)

		  DECLARE @Balance FLOAT = (ISNULL((SELECT SUM(UC.Amount) FROM [UserCanteenCredit]UC 
		                            WHERE UC.CreditedToUserId = @OperationsPerformedBy),0) 
		                            - ISNULL((SELECT SUM(UFI.FoodItemPrice * UFI.Quantity) 
                                                   FROM [UserPurchasedCanteenFoodItem]UFI
		                                           INNER JOIN [CanteenFoodItem]CFI ON CFI.Id = UFI.FoodItemId 
				                                   AND UFI.UserId = @OperationsPerformedBy),0))

		  IF (@IsBalanceOnly = 1)
		  BEGIN
				
          IF (@HavePermission = 1 AND @UserId IS NULL)
	      BEGIN

           SELECT UPFI.Id AS UserPurchasedCanteenFoodItemId,
				  UPFI.FoodItemId AS CanteenItemId, 
		          CFI.FoodItemName AS CanteenItemName,
		          UPFI.UserId AS PurchasedByUserId, 
			 	  UPFI.Quantity,
			 	  UPFI.FoodItemPrice AS Amount,
			 	  UPFI.PurchasedDateTime,
			 	  U.ProfileImage AS PurchasedByProfileImage,
			 	  ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') AS PurchasedByUserName,
				  @Balance AS Balance,
			 	  TotalCount = COUNT(1) OVER()
           FROM [dbo].[UserPurchasedCanteenFoodItem] UPFI WITH (NOLOCK)
		        INNER JOIN [dbo].[CanteenFoodItem] CFI WITH (NOLOCK) ON CFI.Id = UPFI.FoodItemId AND (CFI.ActiveTo IS NULL OR CFI.ActiveTo >= GETDATE ())
		        LEFT JOIN [dbo].[User] U WITH (NOLOCK) ON U.Id = UPFI.UserId AND U.InActiveDateTime IS NULL
				LEFT JOIN [Employee] E ON E.UserId = U.Id
	            LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                       AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
		   WHERE CFI.CompanyId = @CompanyId 
	             AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
		         AND (@UserId IS NULL OR UPFI.UserId = @UserId)
			     AND (@DateFrom IS NULL OR CFI.ActiveFrom = @DateFrom)
			     AND (@DateTo IS NULL OR CFI.ActiveTo = @DateTo)
			     AND (@SearchText IS NULL OR (CFI.FoodItemName LIKE @SearchText)
			                              OR (CONVERT(NVARCHAR(250),CFI.Price) LIKE @SearchText)
				 						 OR (REPLACE(CONVERT(NVARCHAR,CFI.CreatedDateTime,106),' ','-')) LIKE @SearchText
				 						 OR (REPLACE(CONVERT(NVARCHAR,UPFI.PurchasedDateTime,106),' ','-')) LIKE @SearchText
				 						 OR (ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') LIKE @SearchText)
				 						 OR (UPFI.Quantity LIKE @SearchText)
				 						 )
				 AND UPFI.InActiveDateTime IS NULL
		    ORDER BY 
			        CASE  WHEN (@SortBy IS NULL) THEN UPFI.PurchasedDateTime  END DESC,
					CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE  WHEN(  @SortBy = 'CanteenItemName') THEN CFI.FoodItemName
						       WHEN(@SortBy = 'Amount') THEN CFI.Price
							   WHEN @SortBy = 'Quantity' THEN UPFI.Quantity
						       WHEN(@SortBy = 'PurchasedByUserName') THEN (ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,''))
							   WHEN @SortBy = 'PurchasedDateTime' THEN Cast(UPFI.PurchasedDateTime as sql_variant)
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                         CASE  WHEN( @SortBy = 'CanteenItemName') THEN CFI.FoodItemName
						       WHEN(@SortBy = 'Amount') THEN CFI.Price
							   WHEN @SortBy = 'Quantity' THEN UPFI.Quantity
						       WHEN(@SortBy = 'PurchasedByUserName') THEN (ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,''))
							   WHEN @SortBy = 'PurchasedDateTime' THEN Cast(UPFI.PurchasedDateTime as sql_variant)
							   END
                      END DESC,CFI.FoodItemName ASC OFFSET ((@PageNumber - 1) * @PageSize) ROWS
					
		FETCH NEXT @PageSize ROWS ONLY	
	 END
	 ELSE
	 BEGIN
	      SELECT UPFI.Id AS UserPurchasedCanteenFoodItemId,
				  UPFI.FoodItemId AS CanteenItemId, 
		          CFI.FoodItemName AS CanteenItemName,
		          UPFI.UserId AS PurchasedByUserId, 
			 	  UPFI.Quantity,
			 	  CFI.Price AS Amount,
			 	  UPFI.PurchasedDateTime,
				  U.ProfileImage AS PurchasedByProfileImage,
			 	  ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') AS PurchasedByUserName,
				  @Balance AS Balance,
			 	  TotalCount = COUNT(1) OVER()
           FROM [dbo].[UserPurchasedCanteenFoodItem] UPFI WITH (NOLOCK) 
					   INNER JOIN [dbo].[CanteenFoodItem] CFI WITH (NOLOCK) ON CFI.Id = UPFI.FoodItemId AND (CFI.ActiveTo IS NULL OR CFI.ActiveTo >= GETDATE())
					   JOIN [dbo].[User] U WITH (NOLOCK) ON U.Id = UPFI.UserId AND U.InActiveDateTime IS NULL
				       INNER JOIN [Employee] E ON E.UserId = U.Id 
					   INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                             AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                			 AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                                 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
		   WHERE CFI.CompanyId = @CompanyId AND UPFI.UserId = (CASE WHEN @UserId IS NULL THEN @OperationsPerformedBy ELSE @UserId END)
		    AND (@SearchText IS NULL OR (CFI.FoodItemName LIKE @SearchText)
			                             OR (CONVERT(NVARCHAR(250),CFI.Price) LIKE @SearchText)
										 OR (CONVERT(NVARCHAR(250),CFI.ActiveFrom) LIKE @SearchText)
										 OR (CONVERT(NVARCHAR(250),CFI.ActiveTo) LIKE @SearchText)
										 OR (REPLACE(CONVERT(NVARCHAR,CFI.CreatedDateTime,106),' ','-')) LIKE @SearchText
										 OR (CONVERT(NVARCHAR(250),CFI.CreatedByUserId) LIKE @SearchText)
										 OR (REPLACE(CONVERT(NVARCHAR,UPFI.PurchasedDateTime,106),' ','-')) LIKE @SearchText
										 OR (ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') LIKE @SearchText)
										 OR (UPFI.Quantity LIKE @SearchText)
										 )
			AND UPFI.InActiveDateTime IS NULL
		    ORDER BY 
			        CASE  WHEN (@SortBy IS NULL) THEN UPFI.PurchasedDateTime  END DESC,
					CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE  WHEN(@SortBy = 'CanteenItemName') THEN CFI.FoodItemName
						       WHEN(@SortBy = 'Amount') THEN CFI.Price
							   WHEN @SortBy = 'Quantity' THEN UPFI.Quantity
						       WHEN(@SortBy = 'PurchasedByUserName') THEN (ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,''))
							   WHEN @SortBy = 'PurchasedDateTime' THEN Cast(UPFI.PurchasedDateTime as sql_variant)
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                         CASE  WHEN(@SortBy = 'CanteenItemName') THEN CFI.FoodItemName
						       WHEN(@SortBy = 'Amount') THEN CFI.Price
							   WHEN @SortBy = 'Quantity' THEN UPFI.Quantity
						       WHEN(@SortBy = 'PurchasedByUserName') THEN (ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,''))
							   WHEN @SortBy = 'PurchasedDateTime' THEN Cast(UPFI.PurchasedDateTime as sql_variant)
							   END
                      END DESC,CFI.FoodItemName ASC OFFSET ((@PageNumber - 1) * @PageSize) ROWS
					
		   FETCH NEXT @PageSize ROWS ONLY	
	 END
	 END
	 ELSE
	 BEGIN

		IF(@Balance <> 0 ) SELECT @Balance AS Balance

	 END
	 END
	 ELSE
	 BEGIN
	 
	      RAISERROR (@HavePermission,10, 1)
	 
	 END
     END TRY
     BEGIN CATCH
        
           EXEC USP_GetErrorInformation

    END CATCH
END