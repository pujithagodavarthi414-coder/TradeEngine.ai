-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Search the CanteenCredit By Applying different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------------
--   EXEC [dbo].[USP_SearchCanteenCredit] @OperationsPerformedBy='DB9458B5-D28B-4DD5-A059-69EEA129DF6E'

CREATE PROCEDURE [dbo].[USP_SearchCanteenCredit]
(   
    @CanteenCreditId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @UserId  UNIQUEIDENTIFIER = NULL,
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
	 
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
         IF (@HavePermission = '1')
         BEGIN


          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

          SET @SearchText = LTRIM(RTRIM(@SearchText))

		  SET @SearchText = '%'+ @SearchText+'%'

          IF (@HavePermission = 1 AND @UserId IS NULL)
          BEGIN
           
           SELECT T.CanteenCreditId,
                  T.UserId,
                  T.UserName,
                  T.UserProfileImage,
                  T.Amount,
                  T.CurrencyId,
                  T.CurrencyName,
                  T.CreatedByUserId,
                  T.CreatedByUserName,
                  T.CreditedDate,
				  T.CreatedByProfileImage,
                  TotalCount = COUNT(1) OVER()
                  FROM
                (SELECT UCC.Id AS CanteenCreditId,
                        UCC.CreditedToUserId AS UserId,
                        ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') UserName,
                        U.ProfileImage UserProfileImage,
                        UCC.Amount,
                        UCC.CurrencyId,
                        UCC.CreatedByUserId,
                        C.CurrencyName AS CurrencyName,
                        CreatedByUserName=(SELECT ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') FROM [User] U WHERE U.Id = UCC.CreatedByUserId),
						CreatedByProfileImage=(SELECT ProfileImage FROM [User] U WHERE U.Id = UCC.CreatedByUserId),
                        UCC.CreatedDateTime AS CreditedDate
                 FROM [dbo].[UserCanteenCredit] UCC WITH (NOLOCK) 
					  INNER JOIN [User] U ON U.Id = UCC.CreditedToUserId
                      INNER JOIN [Employee] E ON E.UserId = U.Id 
	                  INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                             AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                             --AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                                 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
					  LEFT JOIN [Currency] C ON C.Id = UCC.CurrencyId
                 WHERE U.CompanyId = @CompanyId
                        )T
              WHERE (@CanteenCreditId IS NULL OR T.CanteenCreditId = @CanteenCreditId)
                   AND (@UserId IS NULL OR T.UserId = @UserId)
                   AND (@SearchText IS NULL OR (T.UserName LIKE @SearchText)
                                            OR(CONVERT(NVARCHAR(250),T.Amount) LIKE @SearchText)
											OR (REPLACE(CONVERT(NVARCHAR,T.CreditedDate,106),' ','-')) LIKE @SearchText
                                            OR (T.CurrencyName LIKE @SearchText)
                                            OR (T.CreatedByUserName LIKE @SearchText)
                                         )
          GROUP BY T.CanteenCreditId, T.UserId,T.Amount,T.CurrencyId,T.CurrencyName,T.CreatedByUserId,T.CreatedByUserName,T.CreditedDate,T.UserName,T.UserProfileImage,T.CreatedByProfileImage
            ORDER BY CASE  WHEN (@SortBy IS NULL) THEN T.CreditedDate  END DESC,
                    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN 
                         CASE  WHEN(@SortBy = 'UserName') THEN T.UserName
                               WHEN(@SortBy = 'Amount') THEN T.Amount
                               WHEN(@SortBy = 'CreatedByUserName') THEN T.CreatedByUserName
                               WHEN @SortBy = 'CreditedDate' THEN Cast(T.CreditedDate as sql_variant)
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                         CASE  WHEN(@SortBy = 'UserName') THEN T.UserName
                               WHEN(@SortBy = 'Amount') THEN T.Amount
                               WHEN(@SortBy = 'CreatedByUserName') THEN T.CreatedByUserName
                               WHEN @SortBy = 'CreditedDate' THEN Cast(T.CreditedDate as sql_variant)
                               END
                      END DESC ,T.UserName ASC OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                    
        FETCH NEXT @PageSize ROWS ONLY  
     END
     ELSE
     BEGIN
           SELECT T.CanteenCreditId,
                  T.UserId,
                  T.UserName,
                  T.UserProfileImage,
                  T.Amount,
                  T.CurrencyId,
                  T.CurrencyName,
                  T.CreatedByUserId,
                  T.CreatedByUserName,
				  T.CreatedByProfileImage,
                  T.CreditedDate,
                  TotalCount = COUNT(1) OVER()
                  FROM
                (SELECT UCC.Id AS CanteenCreditId,
                        UCC.CreditedToUserId AS UserId,
                        ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') UserName,
                        U.ProfileImage UserProfileImage,
                        UCC.Amount,
                        UCC.CurrencyId,
                        UCC.CreatedByUserId,
                        C.CurrencyName AS CurrencyName,
                        CreatedByUserName=(SELECT ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') FROM [User]U WHERE U.Id = UCC.CreatedByUserId),
						CreatedByProfileImage=(SELECT ProfileImage FROM [User] U WHERE U.Id = UCC.CreatedByUserId),
                        UCC.CreatedDateTime AS CreditedDate
                 FROM [dbo].[UserCanteenCredit] UCC WITH (NOLOCK) 
					  INNER JOIN [User] U ON U.Id = UCC.CreditedToUserId
                      INNER JOIN [Employee] E ON E.UserId = U.Id 
                      INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                             AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                             --AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                                 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
					  LEFT JOIN [Currency] C ON C.Id = UCC.CurrencyId
                 WHERE U.CompanyId = @CompanyId AND U.Id = (CASE WHEN @UserId IS NULL THEN @OperationsPerformedBy ELSE @UserId END)
                        )T
                        
                        WHERE (@SearchText IS NULL OR (T.UserName LIKE @SearchText)
                                            OR(CONVERT(NVARCHAR(250),T.Amount) LIKE @SearchText)
											OR (REPLACE(CONVERT(NVARCHAR,T.CreditedDate,106),' ','-')) LIKE @SearchText
                                            OR (T.CurrencyName LIKE @SearchText)
                                            OR (T.CreatedByUserName LIKE @SearchText))
                        Order BY 
                                 CASE  WHEN (@SortBy IS NULL) THEN T.CreditedDate  END DESC,
                    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN 
                         CASE  WHEN(@SortBy = 'UserName') THEN T.UserName
                               WHEN(@SortBy = 'Amount') THEN T.Amount
                               WHEN(@SortBy = 'CreatedByUserName') THEN T.CreatedByUserName
                               WHEN @SortBy = 'CreditedDate' THEN Cast(T.CreditedDate as sql_variant)
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                         CASE  WHEN(@SortBy = 'UserName') THEN T.UserName
                               WHEN(@SortBy = 'Amount') THEN T.Amount
                               WHEN(@SortBy = 'CreatedByUserName') THEN T.CreatedByUserName
                               WHEN @SortBy = 'CreditedDate' THEN Cast(T.CreditedDate as sql_variant)
                               END
                      END DESC ,T.UserName ASC OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                    
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