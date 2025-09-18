-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-04 00:00:00.000'
-- Purpose      To search expenses
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_SearchExpenses @OperationsPerformedBy = '1092b152-8a6e-470a-8fca-1ef14f3a0ca3', @ExpenseStatusId = 'a29cc333-5c29-4ddd-9ce3-7bd608d5ab77,29b80753-bf1a-4fa1-ab65-d5788a3a0f4d,2f8a8ddd-a8f4-486c-81ba-7dd061dce1c4'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SearchExpenses]
(
  @ExpenseId UNIQUEIDENTIFIER = NULL,
  @ExpenseCategoryId UNIQUEIDENTIFIER = NULL,
  @PaymentStatusId UNIQUEIDENTIFIER = NULL,
  @ClaimedByUserId UNIQUEIDENTIFIER = NULL,
  @ExpenseStatusId NVARCHAR(1000) = NULL,
  @ClaimReimbursement BIT = NULL,
  @MerchantId UNIQUEIDENTIFIER = NULL,
  @ExpenseDate DATETIME = NULL,
  @SearchText NVARCHAR(500) = NULL,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection NVARCHAR(50)=NULL,
  @PageSize INT = NULL,
  @PageNumber INT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,		
  @IsArchived BIT = NULL,
  @IsMyExpenses BIT = NULL,
  @IsApprovedExpenses BIT = NULL,
  @IsPendingExpenses BIT = NULL,
  @DateFrom DATETIME = NULL,
  @DateTo DATETIME = NULL,
  @ExpenseDateFrom DATETIME = NULL,
  @ExpenseDateTo DATETIME = NULL,
  @BranchId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

			DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			IF(@HavePermission = '1')
			BEGIN
	 
		   IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL		   

		       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		       IF(@ExpenseId = '00000000-0000-0000-0000-000000000000') SET @ExpenseId = NULL
		       
		       IF(@ExpenseCategoryId = '00000000-0000-0000-0000-000000000000') SET @ExpenseCategoryId = NULL
		       
		       IF(@PaymentStatusId = '00000000-0000-0000-0000-000000000000') SET @PaymentStatusId = NULL
		       
		       IF(@ClaimedByUserId = '00000000-0000-0000-0000-000000000000') SET @ClaimedByUserId = NULL

		       IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL
		       
		       IF(@ExpenseStatusId = '') SET @ExpenseStatusId = NULL
		       
		       IF(@MerchantId = '00000000-0000-0000-0000-000000000000') SET @MerchantId = NULL

	           IF(@SearchText = '') SET  @SearchText = NULL
		     
			   SET @SearchText = '%'+ @SearchText +'%'

		       IF(@SortBy IS NULL) SET @SortBy = 'ExpenseDate'
		     
		       IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
		     
		       IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [Expense])

			   IF(@PageSize = 0) SET @PageSize = 10
		     
		       IF(@PageNumber IS NULL) SET @PageNumber = 1
	           
			   SELECT ExpenseId
			          ,ExpenseName
					  ,[ClaimedByUserId]
					  ,ClaimedByUserName
					  ,ClaimedByUserMail
					  ,CreatedByUserId
					  ,CreatedByUserName
					  ,CreatedByUserMail
					  ,PaidStatusSetByUserId
					  ,PaidStatusSetByUserName
					  ,[ExpenseStatusId]
					  ,ExpenseStatus
					  ,[CurrencyId]
					  ,CurrencyName
					  ,CurrencySymbol
					  ,BranchId
					  ,BranchName
					  ,[ClaimReimbursement]
					  ,ExpenseDate
					  ,[IsApproved]
					  ,CronExpression
					  ,CronExpressionId
					  ,JobId
					  ,CronExpressionTimestamp
					  ,[TimeStamp]
					  ,[CreatedDateTime]
					  ,TotalAmount
					    ,(SELECT ECC1.Id AS ExpenseCategoryConfigurationId,
										  ECC1.[Description],
										  ECC1.ExpenseCategoryId,
										  ECC1.MerchantId,
										  ECC1.ExpenseCategoryName,
										  M1.MerchantName,
										  CONVERT(NUMERIC(30,2),ECC1.Amount) AS Amount,
										  EC.CategoryName,
										  E1.Id AS ExpenseId,
										  Receipts = STUFF(( SELECT  ',' + Convert(nvarchar(1000),UF1.FilePath)[text()]
						                                      FROM [UploadFile] UF1
						                                      WHERE ECC1.Id = UF1.ReferenceId AND UF1.InActiveDateTime IS NULL
																FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
									FROM [Expense] E1
									INNER JOIN ExpenseCategoryConfiguration ECC1 ON ECC1.ExpenseId = E1.Id AND ECC1.InactiveDateTime IS NULL
									INNER JOIN ExpenseCategory EC ON EC.Id = ECC1.ExpenseCategoryId AND EC.InActiveDateTime IS NULL
									LEFT JOIN Merchant M1 ON M1.Id = ECC1.MerchantId AND M1.InActiveDateTime IS NULL
									WHERE E1.Id = T.ExpenseId AND E1.CompanyId = @CompanyId
									FOR XML PATH('ExpenseCategoryConfigurationModel'), ROOT('ExpenseCategoryConfigurationModel'), TYPE) AS ExpenseCategorieConfigurationsXml,
								  Receipts = STUFF(( SELECT  ',' + Convert(nvarchar(1000),UF.FilePath)[text()]
						                                      FROM [UploadFile] UF
						                                      INNER JOIN Expense E1 ON UF.ReferenceId = e1.Id
						                                      WHERE E1.Id = T.ExpenseId AND UF.InActiveDateTime IS NULL
						                                      AND E1.CompanyId = @CompanyId
																FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),
								 ExpenseCategoryNames = STUFF(( SELECT  ',' + Convert(nvarchar(1000),EC1.CategoryName)[text()]
						                                      FROM [Expense] E2
						                                      INNER JOIN ExpenseCategoryConfiguration ECC2 ON E2.Id = ECC2.ExpenseId
																INNER JOIN ExpenseCategory EC1 ON EC1.Id = ECC2.ExpenseCategoryId
						                                      WHERE E2.Id = T.ExpenseId AND ECC2.InActiveDateTime IS NULL
																AND E2.CompanyId = @CompanyId
						                                      FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),
								MerchantName = STUFF(( SELECT  ',' + Convert(nvarchar(1000),M.MerchantName)[text()]
						                                      FROM [Expense] E3
						                                      INNER JOIN ExpenseCategoryConfiguration ECC3 ON E3.Id = ECC3.ExpenseId
															  INNER JOIN Merchant M ON M.Id = ECC3.MerchantId
						                                      WHERE E3.Id = T.ExpenseId AND ECC3.InActiveDateTime IS NULL
																AND E3.CompanyId = @CompanyId
						                                      FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
					  ,IdentificationNumber
					  ,ExpenseNumber
					  ,TotalCount
			   FROM
			   (
			    SELECT ExpenseId
			          ,ExpenseName
					  ,[ClaimedByUserId]
					  ,ClaimedByUserName
					  ,ClaimedByUserMail
					  ,CreatedByUserId
					  ,CreatedByUserName
					  ,CreatedByUserMail
					  ,PaidStatusSetByUserId
					  ,PaidStatusSetByUserName
					  ,[ExpenseStatusId]
					  ,ExpenseStatus
					  ,[CurrencyId]
					  ,CurrencyName
					  ,CurrencySymbol
					  ,BranchId
					  ,BranchName
					  ,[ClaimReimbursement]
					  ,ExpenseDate
					  ,[IsApproved]
					  ,CronExpression
					  ,CronExpressionId
					  ,JobId
					  ,CronExpressionTimestamp
					  ,[TimeStamp]
					  ,[CreatedDateTime]
					  ,TotalAmount
					  --,ExpenseCategorieConfigurationsXml
					  --,Receipts
					  --,ExpenseCategoryNames
					  --,MerchantName
					  ,IdentificationNumber
					  ,ExpenseNumber
					  ,TotalCount = COUNT(1) OVER()
					FROM
						(
						 SELECT E.[Id] AS ExpenseId,
								  E.ExpenseName,
						 	      E.[ClaimedByUserId],
								  U1.[FirstName] + ' ' +ISNULL(U1.SurName,'') ClaimedByUserName ,
								  U1.UserName AS ClaimedByUserMail,
								  E.CreatedByUserId,
								  U2.[FirstName] + ' ' +ISNULL(U2.SurName,'') CreatedByUserName ,
								  U2.UserName AS CreatedByUserMail,
								  E.PaidStatusSetByUserId,
								  U.[FirstName] + ' ' +ISNULL(U.SurName,'') PaidStatusSetByUserName ,
						 	      E.[ExpenseStatusId],
								  ES.[Name] AS ExpenseStatus,
								  E.[CurrencyId],
								  C.CurrencyName,
								  C.Symbol AS CurrencySymbol,
								  E.BranchId,
								  B.BranchName,
						 	      E.[ClaimReimbursement],
						 	      E.[ExpenseDate] AS ExpenseDate,
						 	      E.[IsApproved],
								  CE.CronExpression,
								  CE.Id AS CronExpressionId,
								  CE.JobId,
								  CE.TimeStamp AS CronExpressionTimestamp,
								  E.[TimeStamp],
								  E.[CreatedDateTime],
								  ECC.Amount AS TotalAmount,
								  E.IdentificationNumber,
								  E.ExpenseNumber
						 FROM  [dbo].[Expense] E WITH (NOLOCK)
								 INNER JOIN (SELECT SUM(Amount) AS Amount,ExpenseId 
								             FROM ExpenseCategoryConfiguration 
											 WHERE InactiveDateTime IS NULL
											 GROUP BY ExpenseId) ECC ON ECC.ExpenseId = E.Id 
								 LEFT JOIN PaymentStatus PS ON PS.Id = E.PaymentStatusId AND PS.InActiveDateTime IS NULL
								 LEFT JOIN MasterTable MT ON MT.Id = E.CurrencyId
								 LEFT JOIN ExpenseReport ER ON ER.Id = E.ExpenseReportId AND ER.InActiveDateTime IS NULL
								 LEFT JOIN [User] U ON U.Id = E.PaidStatusSetByUserId AND U.InActiveDateTime IS NULL
								 LEFT JOIN [User] U1 ON U1.Id = E.ClaimedByUserId AND U1.InActiveDateTime IS NULL
								 LEFT JOIN [User] U2 ON U2.Id = E.CreatedByUserId AND U2.InActiveDateTime IS NULL
								 LEFT JOIN ExpenseStatus ES ON ES.Id = E.ExpenseStatusId AND ES.InActiveDateTime IS NULL
								 LEFT JOIN Currency C  ON C.Id = E.CurrencyId AND C.InActiveDateTime IS NULL
								 LEFT JOIN Branch B  ON B.Id = E.BranchId AND B.InActiveDateTime IS NULL
								 LEFT JOIN CronExpression CE ON CE.CustomWidgetId = E.Id AND CE.InActiveDateTime IS NULL
						 WHERE E.CompanyId = @CompanyId 
						 AND (@IsArchived IS NULL 
								      OR (@IsArchived = 1 AND E.InActiveDateTime IS NOT NULL)
									  OR (@IsArchived = 0 AND E.InActiveDateTime IS NULL))
								 AND ((@IsMyExpenses = 1 AND ClaimedByUserId = @OperationsPerformedBy) OR (ISNULL(@IsMyExpenses ,0) = 0))
								 AND ((@IsApprovedExpenses = 1 AND ExpenseStatusId = (SELECT Id FROM ExpenseStatus WHERE IsApproved = 1)) OR (ISNULL(@IsApprovedExpenses,0) = 0))
								 AND ((@IsPendingExpenses = 1 AND ExpenseStatusId = (SELECT Id FROM ExpenseStatus WHERE IsPending = 1)) OR (ISNULL(@IsPendingExpenses,0) = 0))
							     AND (@ExpenseId IS NULL OR E.Id = @ExpenseId) 
								 AND (@ExpenseStatusId IS NULL OR E.ExpenseStatusId IN (SELECT IIF([Value] = '',NULL,[Value]) FROM [dbo].[Ufn_StringSplit](@ExpenseStatusId,',')))
								 AND (@PaymentStatusId IS NULL OR E.PaymentStatusId = @PaymentStatusId) 
								 AND (@ClaimedByUserId IS NULL OR E.ClaimedByUserId = @ClaimedByUserId) 
								 AND (@BranchId IS NULL OR E.BranchId = @BranchId) 
								 --AND (@ExpenseStatusId IS NULL OR E.ExpenseStatusId = @ExpenseStatusId) 
								 AND ((@DateFrom IS NULL OR CAST(E.CreatedDateTime AS DATE) >= CAST(@DateFrom AS DATE)) AND (@DateTo IS NULL OR CAST(E.CreatedDateTime AS DATE) <=  CAST(@DateTo AS DATE)))
								 AND ((@ExpenseDateFrom IS NULL OR CAST(E.ExpenseDate AS DATE) >= CAST(@ExpenseDateFrom AS DATE)) AND (@ExpenseDateTo IS NULL OR CAST(E.ExpenseDate AS DATE) <=  CAST(@ExpenseDateTo AS DATE)))
								 AND (@ClaimReimbursement IS NULL OR E.ClaimReimbursement = @ClaimReimbursement)
								 AND (@ExpenseDate IS NULL OR  CAST(E.ExpenseDate AS DATE) = CAST(@ExpenseDate AS DATE))
						) TT
						WHERE (@SearchText IS NULL 
							  --OR ([MerchantName] LIKE @SearchText)
							  OR (FORMAT(ExpenseDate,'MMM d,yyyy') LIKE @SearchText)
							  OR (TotalAmount LIKE @SearchText)
							  OR ([ExpenseName] LIKE @SearchText)
							  --OR (ExpenseCategoryNames LIKE @SearchText)
							  OR (ClaimedByUserName LIKE @SearchText)
							  OR (PaidStatusSetByUserName LIKE @SearchText)
							  OR (CreatedByUserName LIKE @SearchText)
							  OR (ExpenseStatus LIKE @SearchText)
							  OR (BranchName LIKE @SearchText)
							  OR ('E-' + CAST([ExpenseNumber] AS VARCHAR(255)) LIKE @SearchText)
							  OR (FORMAT(CreatedDateTime,'MMM d,yyyy') LIKE @SearchText)
							  OR (CurrencyName LIKE @SearchText)
							  )
						ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		  	  			CASE WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CreatedDateTime,121) AS sql_variant)
		  	  				 WHEN @SortBy = 'ExpenseDate' THEN CAST(ExpenseDate AS sql_variant)
		  	  			     --WHEN @SortBy = 'CategoryName' THEN  CAST(ExpenseCategoryNames  AS NVARCHAR(1000))
		  	  			     WHEN @SortBy = 'ExpenseName' THEN  ExpenseName
		  	  			     WHEN @SortBy = 'ClaimedByUserName' THEN  ClaimedByUserName
		  	  			     WHEN @SortBy = 'paidBy' THEN  PaidStatusSetByUserName
		  	  			     WHEN @SortBy = 'CreatedByUserName' THEN  CreatedByUserName
		  	  			     --WHEN @SortBy = 'MerchantName' THEN  CAST(MerchantName AS NVARCHAR(1000))
							 WHEN @SortBy = 'ExpenseStatus' THEN ExpenseStatus
							 WHEN @SortBy = 'Amount' THEN CAST(TotalAmount AS sql_variant)
							 WHEN @SortBy = 'IdentificationNumber' THEN ExpenseNumber
							 WHEN @SortBy = 'BranchName' THEN BranchName
		  	  			END
		  	  		  END ASC,
		  	  		  CASE WHEN @SortDirection = 'DESC' THEN
		  	  		  		CASE WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,CreatedDateTime,121) AS sql_variant)
		  	  		  			 WHEN @SortBy = 'ExpenseDate' THEN CAST(ExpenseDate AS sql_variant)
		  	  		  		     --WHEN @SortBy = 'CategoryName' THEN  CAST(ExpenseCategoryNames  AS NVARCHAR(1000))
		  	  		  		     WHEN @SortBy = 'ExpenseName' THEN  ExpenseName
					  			 WHEN @SortBy = 'ClaimedByUserName' THEN  ClaimedByUserName
					  			 WHEN @SortBy = 'paidBy' THEN  PaidStatusSetByUserName
		  	  		  		     WHEN @SortBy = 'CreatedByUserName' THEN  CreatedByUserName
		  	  		  		     --WHEN @SortBy = 'MerchantName' THEN  CAST(MerchantName AS NVARCHAR(1000))
					  			 WHEN @SortBy = 'ExpenseStatus' THEN ExpenseStatus
					  			 WHEN @SortBy = 'Amount' THEN CAST(TotalAmount AS sql_variant)
					  			 WHEN @SortBy = 'IdentificationNumber' THEN ExpenseNumber
					  			 WHEN @SortBy = 'BranchName' THEN BranchName
		  	  		  		END
		             END DESC
		                OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		                FETCH NEXT @PageSize Rows ONLY
					) T
			

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