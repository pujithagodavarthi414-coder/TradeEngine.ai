--EXEC [dbo].[USP_SearchExpenseDownloadDetails] @OperationsPerformedBy = '22C43506-5DA8-4765-9597-4727E8EF89ED'

CREATE PROCEDURE [dbo].[USP_SearchExpenseDownloadDetails]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @ExpenseId UNIQUEIDENTIFIER = NULL,
  @ExpenseIdList NVARCHAR(MAX) = NULL,
  @BranchId UNIQUEIDENTIFIER = NULL,
  @ClaimedByUserId UNIQUEIDENTIFIER = NULL,
  @IsArchived BIT = NULL,
  @ExpenseDateFrom DATETIME = NULL,
  @ExpenseDateTo DATETIME = NULL,
  @DateFrom DATETIME = NULL,
  @DateTo DATETIME = NULL
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

			DECLARE @HavePermission NVARCHAR(250) = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			IF(@HavePermission = '1')
			BEGIN
	 
		   IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL		   

		       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
					SELECT  U.Id AS UserId
					,U.FirstName + ISNULL(U.SurName,'') + ' (' + B.BranchName + ')'AS UserName
					,BD.IFSCCode AS UserIFSCCode
					--,BD.BankName AS UserBankName
					,BD.AccountNumber AS BeneficiaryAccountNumber
					,TotalAmount
					,ExpenseName
					,IdentificationNumber
					,ECD.AccountNumber AS DebitAccountNumber
					,CASE WHEN EBKD.BankName IS NOT NULL AND ECBKD.BankName IS NOT NULL AND EBKD.BankName = ECBKD.BankName THEN 'WIB' ELSE 'NFT' END AS Transactiontype
					FROM(
					      SELECT  E.ExpenseName,
								  E.IdentificationNumber,
								  E.ClaimedByUserId
					             ,B.Id AS BranchId
					      	    ,SUM(ECC.amount) AS TotalAmount
					      FROM Expense E 
					          INNER JOIN ExpenseCategoryConfiguration ECC ON ECC.expenseId = E.Id AND E.InactiveDateTime IS NULL
					          INNER JOIN Branch B ON E.BranchId = B.Id AND B.InactiveDateTime IS NULL
					      WHERE (E.Id IN (SELECT IIF([Value] = '',NULL,[Value]) FROM [dbo].[Ufn_StringSplit](@ExpenseIdList,',')))
						  --E.ExpenseStatusId = 'A29CC333-5C29-4DDD-9CE3-7BD608D5AB77'
						  AND (@ClaimedByUserId IS NULL OR E.ClaimedByUserId = @ClaimedByUserId) 
						  AND (@BranchId IS NULL OR E.BranchId = @BranchId) 
						  AND ((@DateFrom IS NULL OR CAST(E.CreatedDateTime AS DATE) >= CAST(@DateFrom AS DATE)) AND (@DateTo IS NULL OR CAST(E.CreatedDateTime AS DATE) <=  CAST(@DateTo AS DATE)))
						  AND ((@ExpenseDateFrom IS NULL OR CAST(E.ExpenseDate AS DATE) >= CAST(@ExpenseDateFrom AS DATE)) AND (@ExpenseDateTo IS NULL OR CAST(E.ExpenseDate AS DATE) <=  CAST(@ExpenseDateTo AS DATE)))
						  AND E.InactiveDateTime IS NULL
					      GROUP BY E.ExpenseName, E.IdentificationNumber, E.ClaimedByUserId, B.Id
					 ) T
					INNER JOIN [User] U ON U.Id = T.ClaimedByUserId AND U.CompanyId = @CompanyId
					INNER JOIN Employee E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL
					INNER JOIN BankDetail BD ON BD.EmployeeId = E.Id AND E.InActiveDateTime IS NULL AND BD.InActiveDateTime IS NULL
					LEFT JOIN Bank EBKD ON EBKD.Id = BD.BankId
					LEFT JOIN Branch B ON B.Id = T.BranchId
					LEFT JOIN EmployeeCreditorDetails ECD ON ECD.BranchId = T.BranchId AND ECD.InactiveDateTime IS NULL
					LEFT JOIN Bank ECBKD ON ECBKD.Id = BD.BankId
			   END
			ELSE
			BEGIN
			
				RAISERROR (@HavePermission,11, 1)
					
			END
		   
	 END TRY  
	 BEGIN CATCH 
		
		  EXEC [dbo].[USP_GetErrorInformation]

	END CATCH

END
GO