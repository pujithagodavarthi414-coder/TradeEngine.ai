-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Search the FoodItems By Applying different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------------

--   EXEC [dbo].[USP_SearchCanteenBalanceDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@SortBy = 'TotalDebitedAmount'

CREATE PROCEDURE [dbo].[USP_SearchCanteenBalanceDetails]
(   
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@UserId  UNIQUEIDENTIFIER = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(100) = NULL,
    @SearchText  NVARCHAR(100) = NULL,
	@EntityId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
         IF (@HavePermission = '1')
         BEGIN

          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

          SET @SearchText = LTRIM(RTRIM(@SearchText))

		  SET @SearchText = '%'+ @SearchText+'%'

		  IF (@SortBy IS NULL) SET @SortBy = 'UserName'

          IF (@HavePermission = 1 AND @UserId IS NULL)
		  BEGIN

		   SELECT Z.UserId,
		          Z.UserName,
		          Z.UserProfileImage,
				  Z.TotalCreditedAmount,
				  Z.TotalDebitedAmount,
				--  Z.TotalBalanceAmount,
				  TotalBalanceAmount = (z.TotalCreditedAmount-(z.TotalDebitedAmount)),
				  TotalCount = COUNT(1) OVER()
		           FROM
		           (SELECT UCC.CreditedToUserId AS UserId,               
			                           ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') UserName,
			                           U.ProfileImage AS UserProfileImage,
			                          -- TotalCreditedAmount = ISNULL((SELECT SUM(UC.Amount) FROM [UserCanteenCredit] UC WHERE UC.CreditedToUserId = UCC.CreditedToUserId),0),
					                   SUM(ISNULL(UCC.Amount,0)) TotalCreditedAmount,
									  TotalDebitedAmount = ISNULL((SELECT SUM(UFI.FoodItemPrice * UFI.Quantity) 
					                                         FROM [UserPurchasedCanteenFoodItem] UFI INNER JOIN [CanteenFoodItem] CFI ON CFI.Id = UFI.FoodItemId
					                                         WHERE UFI.UserId = UCC.CreditedToUserId),0),
									   UCC.CurrencyId, 
					                   C.CurrencyName
		                               FROM [dbo].[UserCanteenCredit] UCC WITH (NOLOCK) 
									        INNER JOIN [User] U ON U.Id = UCC.CreditedToUserId AND U.InActiveDateTime IS NULL
								            INNER JOIN [Employee] E ON E.UserId = U.Id 
											INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
														AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
										   LEFT JOIN EntityBranch ET ON ET.BranchId = EB.BranchId AND ET.InactiveDateTime IS NULL AND  ET.EntityId = @EntityId
														--AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
			                                LEFT JOIN Currency C ON C.Id = UCC.CurrencyId AND C.InActiveDateTime IS NULL
		                         WHERE U.CompanyId = @CompanyId
								       AND (@EntityId IS NULL OR ET.BranchId IS NOT NULL)
								GROUP BY UCC.CreditedToUserId,	U.FirstName,U.SurName,U.ProfileImage,UCC.CurrencyId,C.CurrencyName
									 )Z
			  WHERE (@UserId IS NULL OR Z.UserId = @UserId)
			        AND (@SearchText IS NULL OR (Z.UserName LIKE @SearchText)
				                              OR(CONVERT(NVARCHAR(250),Z.CurrencyName) LIKE @SearchText)
											  OR (CONVERT(NVARCHAR(250),Z.TotalCreditedAmount) LIKE @SearchText)
											  OR (CONVERT(NVARCHAR(250),Z.TotalDebitedAmount) LIKE @SearchText)
											  OR (CONVERT(NVARCHAR(250),Z.TotalCreditedAmount-Z.TotalDebitedAmount) LIKE @SearchText)
				   
					 )
			 -- GROUP BY Z.UserId,Z.UserName,Z.UserProfileImage,Z.TotalCreditedAmount,Z.TotalDebitedAmount
			  ORDER BY 
			            CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN 
		                     CASE  WHEN( @SortBy = 'UserName') THEN CAST(Z.UserName AS SQL_VARIANT)
							       WHEN(@SortBy = 'TotalCreditedAmount') THEN  Z.TotalCreditedAmount
							       WHEN(@SortBy = 'TotalDebitedAmount')  THEN Z.TotalDebitedAmount
								   WHEN (@SortBy = 'TotalBalanceAmount')THEN (z.TotalCreditedAmount-(z.TotalDebitedAmount))
		                      END
		                  END ASC,
		                 CASE WHEN @SortDirection = 'DESC' THEN
		                      CASE  WHEN( @SortBy = 'UserName') THEN CAST(Z.UserName AS SQL_VARIANT)
							        WHEN(@SortBy = 'TotalCreditedAmount') THEN  Z.TotalCreditedAmount
							        WHEN(@SortBy = 'TotalDebitedAmount')  THEN Z.TotalDebitedAmount
								    WHEN (@SortBy = 'TotalBalanceAmount')THEN (z.TotalCreditedAmount-(z.TotalDebitedAmount))
						      END
		                  END DESC 
			  OFFSET ((@PageNumber - 1) * @PageSize) ROWS
						
			  FETCH NEXT @PageSize ROWS ONLY	

		 END
		 ELSE
		 BEGIN
				 SELECT Z.UserId,
		          Z.UserName,
		          Z.UserProfileImage,
				  Z.TotalCreditedAmount,
				  Z.TotalDebitedAmount,
				 -- Z.TotalBalanceAmount,
				  TotalBalanceAmount = (z.TotalCreditedAmount-(z.TotalDebitedAmount)),
				  TotalCount = COUNT(1) OVER()
		           FROM
		           (SELECT UCC.CreditedToUserId AS UserId,               
			                           ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') UserName,
									   U.ProfileImage AS UserProfileImage,
			                            SUM(ISNULL(UCC.Amount,0)) TotalCreditedAmount, --= ISNULL((SELECT SUM(UC.Amount) FROM [UserCanteenCredit] UC WHERE UC.CreditedToUserId = UCC.CreditedToUserId),0),
					                   TotalDebitedAmount = ISNULL((SELECT SUM(UFI.FoodItemPrice * UFI.Quantity) 
					                                         FROM [UserPurchasedCanteenFoodItem] UFI INNER JOIN [CanteenFoodItem] CFI ON CFI.Id = UFI.FoodItemId
					                                         WHERE UFI.UserId = UCC.CreditedToUserId),0), 
					                   UCC.CurrencyId,	
									   C.CurrencyName
		                               FROM [dbo].[UserCanteenCredit] UCC WITH (NOLOCK) 
									   INNER JOIN [User] U ON U.Id = UCC.CreditedToUserId AND U.InActiveDateTime IS NULL
			                           INNER JOIN [Employee] E ON E.UserId = U.Id 
									   INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
														AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
														AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
									   LEFT JOIN Currency C ON C.Id = UCC.CurrencyId AND C.InActiveDateTime IS NULL
		                         WHERE U.CompanyId = @CompanyId AND U.Id = @UserId--(CASE WHEN @UserId IS NULL THEN @OperationsPerformedBy ELSE @UserId END)
									GROUP BY UCC.CreditedToUserId,	U.FirstName,U.SurName,U.ProfileImage,UCC.CurrencyId,C.CurrencyName
								
									 )Z

						WHERE (@UserId IS NULL OR Z.UserId = @UserId)
			        AND (@SearchText IS NULL OR (Z.UserName LIKE @SearchText)
				                              OR(CONVERT(NVARCHAR(250),Z.CurrencyName) LIKE @SearchText)
											  OR (CONVERT(NVARCHAR(250),Z.TotalCreditedAmount) LIKE @SearchText)
											  OR (CONVERT(NVARCHAR(250),Z.TotalDebitedAmount) LIKE @SearchText)
											  OR (CONVERT(NVARCHAR(250),Z.TotalCreditedAmount-Z.TotalDebitedAmount) LIKE @SearchText)
				     )
				 GROUP BY Z.UserId,Z.UserName,Z.UserProfileImage,Z.TotalCreditedAmount,Z.TotalDebitedAmount

				  ORDER BY 
							  CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN 
		                           CASE  WHEN( @SortBy = 'UserName') THEN CAST(Z.UserName AS SQL_VARIANT)
							             WHEN(@SortBy = 'TotalCreditedAmount') THEN  Z.TotalCreditedAmount
							             WHEN(@SortBy = 'TotalDebitedAmount')  THEN Z.TotalDebitedAmount
								         WHEN (@SortBy = 'TotalBalanceAmount')THEN  (z.TotalCreditedAmount-(z.TotalDebitedAmount))
		                           END
		                      END ASC,
		                      CASE WHEN @SortDirection = 'DESC' THEN
		                           CASE  WHEN( @SortBy = 'UserName') THEN CAST(Z.UserName AS SQL_VARIANT)
							             WHEN(@SortBy = 'TotalCreditedAmount') THEN  Z.TotalCreditedAmount
							             WHEN(@SortBy = 'TotalDebitedAmount')  THEN Z.TotalDebitedAmount
								         WHEN (@SortBy = 'TotalBalanceAmount')THEN   (z.TotalCreditedAmount-(z.TotalDebitedAmount))
						           END
		                      END DESC 
				  OFFSET ((@PageNumber - 1) * @PageSize) ROWS
							
				  FETCH NEXT @PageSize ROWS ONLY	
		 END
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