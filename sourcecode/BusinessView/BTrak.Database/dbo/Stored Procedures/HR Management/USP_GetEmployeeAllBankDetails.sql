-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-27 00:00:00.000'
-- Purpose      To Get Employee Bank Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEmployeeAllBankDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetEmployeeAllBankDetails]
(
   @EmployeeBankDetailsId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250) = NULL,
   @AccountNameSearchText NVARCHAR(250) = NULL,
   @AccountNumberSearchText NVARCHAR(250) = NULL,
   @BankNameSearchText NVARCHAR(250) = NULL,
   @BranchNameSearchText NVARCHAR(250) = NULL,  
   @EffectiveFrom DateTime = NULL,
   @EffectiveTo DateTime = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @SortDirection VARCHAR(50)=NULL,
   @IsArchived BIT = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			IF(@EmployeeBankDetailsId = '00000000-0000-0000-0000-000000000000') SET @EmployeeBankDetailsId = NULL
	      
	      IF(@SearchText = '') SET @SearchText = NULL

		  IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		  SET @SearchText = '%'+ LTRIM(RTRIM(@SearchText))+'%'

	      SELECT B.Id employeeBankId ,
				 E.Id EmployeeId,
		         U.FirstName,
				 U.SurName,
				 U.UserName Email,
				 [IFSCCode],
				 [AccountNumber],
				 [AccountName],
				 [BuildingSocietyRollNumber] ,
				 [BankId] ,
				 BL.BankName,
				 [BranchName] ,
				 [DateFrom],
				 [EffectiveFrom] ,
				 [EffectiveTo] ,
				 B.[TimeStamp],
				 U.FirstName + ' ' + U.SurName UserName,
				 CASE WHEN B.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				 TotalCount = COUNT(1) OVER()
		  FROM  [dbo].BankDetail B WITH (NOLOCK)
				JOIN Employee E ON E.Id = B.EmployeeId
				LEFT JOIN Bank BL ON BL.Id = B.BankId
		        JOIN [User] U ON U.Id = E.UserId
		  WHERE (@EmployeeId IS NULL OR E.Id = @EmployeeId) AND U.CompanyId = @CompanyId
		       AND (@EmployeeBankDetailsId IS NULL OR B.Id = @EmployeeBankDetailsId)
		       AND (@SearchText IS NULL 
			        OR (REPLACE(CONVERT(NVARCHAR,B.EffectiveTo,106),' ','-') LIKE @SearchText)
					OR (REPLACE(CONVERT(NVARCHAR,B.EffectiveFrom,106),' ','-') LIKE @SearchText)
				    OR (B.BranchName LIKE @SearchText)
					OR (BL.BankName LIKE @SearchText)
					OR (B.AccountName LIKE @SearchText)
					OR (B.BranchName LIKE @SearchText)
					OR (B.AccountNumber LIKE @SearchText)
					OR (B.IFSCCode LIKE @SearchText))
				AND (B.AccountName LIKE @AccountNameSearchText OR @AccountNameSearchText IS NULL)
				AND (B.AccountNumber LIKE @AccountNumberSearchText OR @AccountNumberSearchText IS NULL)
				AND (BL.BankName LIKE @BankNameSearchText OR @BankNameSearchText IS NULL)
				AND (B.BranchName LIKE @BranchNameSearchText OR @BranchNameSearchText IS NULL)
				AND (@EffectiveFrom IS NULL OR B.EffectiveFrom = @EffectiveFrom)
				AND (@EffectiveTo IS NULL OR B.EffectiveTo = @EffectiveTo)
				ORDER BY 
                    CASE WHEN (@SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'UserName') THEN  U.FirstName + ' ' + U.SurName
							  WHEN(@SortBy = 'AccountNumber') THEN B.[AccountNumber]
							  WHEN(@SortBy = 'AccountName') THEN B.[AccountName]
							  WHEN(@SortBy = 'BankName') THEN BL.BankName
                              WHEN(@SortBy = 'BranchName') THEN B.[BranchName]
							  WHEN(@SortBy = 'EffectiveTo') THEN CAST(CONVERT(DATETIME, B.EffectiveTo,121)AS sql_variant)
							  WHEN(@SortBy = 'EffectiveFrom') THEN CAST(CONVERT(DATETIME, B.EffectiveFrom,121)AS sql_variant)
							  WHEN(@SortBy = 'CreatedDateTime') THEN CAST(CONVERT(DATETIME, B.CreatedDateTime,121)AS sql_variant)
                          END
                      END ASC,
                     CASE WHEN (@SortDirection = 'DESC' OR @SortDirection IS NULL) THEN
                        CASE  WHEN(@SortBy = 'UserName') THEN  U.FirstName + ' ' + U.SurName
                              WHEN(@SortBy = 'AccountNumber') THEN B.[AccountNumber]
							  WHEN(@SortBy = 'AccountName') THEN B.[AccountName]
							  WHEN(@SortBy = 'BankName') THEN BL.BankName
                              WHEN(@SortBy = 'BranchName') THEN B.[BranchName]
							  WHEN(@SortBy = 'EffectiveTo') THEN CAST(CONVERT(DATETIME, B.EffectiveTo,121)AS sql_variant)
							  WHEN(@SortBy = 'EffectiveFrom') THEN CAST(CONVERT(DATETIME, B.EffectiveFrom,121)AS sql_variant)
							  WHEN(@SortBy = 'CreatedDateTime') THEN CAST(CONVERT(DATETIME, B.CreatedDateTime,121)AS sql_variant)
                          END
                      END DESC

			OFFSET ((@PageNo - 1) * @PageSize) ROWS

		     FETCH NEXT @PageSize ROWS ONLY
		  
		END

	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END
