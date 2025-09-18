-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Income Tax Monthly Statement
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetIncomeTaxMonthlyStatement] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE  PROCEDURE [dbo].[USP_GetIncomeTaxMonthlyStatement]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@Month DATETIME = NULL
	,@EntityId UNIQUEIDENTIFIER = NULL
	,@UserId UNIQUEIDENTIFIER = NULL
	,@IsActiveEmployeesOnly BIT = 0
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
            
			DECLARE @YearStartDate DATETIME = NULL, @YearEndDate DATETIME = NULL
			
			IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
			
			IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
           	
			IF(@Month IS NULL) SET @Month = GETDATE()

			IF(@IsActiveEmployeesOnly IS NULL) SET @IsActiveEmployeesOnly = 0
			 
			 DECLARE @FromMonth INT,@ToMonth INT,@FromYear INT,@ToYear INT,@TaxYear INT,@Year INT = DATEPART(YEAR,@Month),@MonthValue INT = DATEPART(MONTH,@Month)
			 
			 DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee E WHERE E.UserId = ISNULL(@UserId,@OperationsPerformedBy))
		     
             SELECT @FromMonth = FromMonth, @ToMonth = ToMonth FROM [FinancialYearConfigurations] 
		     WHERE CountryId = (SELECT B.CountryId FROM EmployeeBranch EB INNER JOIN Branch B ON B.Id = EB.BranchId
			                  WHERE EB.EmployeeId = @EmployeeId AND EB.[ActiveFrom] IS NOT NULL 
							        AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE()))
                                    AND InActiveDateTime IS NULL 
                                    AND FinancialYearTypeId = (SELECT Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Tax') --Tax Type Id
             
			 SELECT @FromMonth = ISNULL(@FromMonth,4), @ToMonth = ISNULL(@ToMonth,3)

		     SELECT @FromYear = CASE WHEN @MonthValue - @FromMonth >= 0 THEN @Year ELSE @Year - 1 END
		     SELECT @ToYear = CASE WHEN @MonthValue - @ToMonth > 0 THEN @Year + 1 ELSE @Year END
             
		     SELECT @YearStartDate = DATEFROMPARTS(@FromYear,@FromMonth,1), @YearEndDate = EOMONTH(DATEFROMPARTS(@ToYear,@ToMonth,1))
                
		     SELECT @TaxYear = CASE WHEN @MonthValue - @FromMonth >= 0 THEN @Year ELSE @Year - 1 END
            
			IF(@YearStartDate IS NULL OR @YearEndDate IS NULL)
			BEGIN
				
				SET @YearStartDate = DATEFROMPARTS(DATEPART(YEAR,@Month),1,1)
				
				SET @YearEndDate = DATEFROMPARTS(DATEPART(YEAR,@Month),12,1)

			END
			
			DECLARE @TAXComponentId UNIQUEIDENTIFIER = (SELECT Id FROM PayrollComponent PC WHERE PC.CompanyId = @CompanyId AND PC.ComponentName = 'TAX' AND InactiveDateTime IS NULL)
			
			--DECLARE @CurrencyCode NVARCHAR(50) = (SELECT [dbo].[Ufn_GetCurrencyCodeOfaCompany](@OperationsPerformedBy))

			SELECT EmployeeNumber AS [Employee Number]
			       ,EmployeeName AS [Employee Name]
				   ,CONVERT(VARCHAR,JoinedDate,106) AS [Date Of Joining]
				   ,PANNumber AS [PAN Number]
				   ,TaxableIncome AS [Taxable Income]
				   ,IncomeTax AS [Income Tax]
				   --,Cess
				   --,DirectTaxableIncome AS [Direct Taxable Income]
				   --,TDSIncomeTax AS [TDS Income Tax]
				   --,TotalTax AS [Total Tax]
				   --,COUNT(1) OVER() AS TotalRecordsCount
			FROM
			(
			SELECT EmployeeNumber
			       ,EmployeeName
				   ,JoinedDate
				   ,TaxableIncome
				   ,PANNumber
				   ,IncomeTax
				   --,(IncomeTax * 3 * 0.01) AS Cess
				   --,TaxableIncome AS DirectTaxableIncome
				   --,IncomeTax + (IncomeTax * 3 * 0.01) AS TDSIncomeTax
				   --,IncomeTax + (IncomeTax * 3 * 0.01) AS TotalTax
			FROM
			(
				SELECT E.EmployeeNumber
					   ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS EmployeeName
					   ,CONVERT(VARCHAR,J.JoinedDate,106) AS JoinedDate
					   --,J.JoinedDate AS JoinedDateValue
			           ,EAD.PANNumber
					   ,([dbo].[Ufn_GetEmployeeTaxableAmount](E.Id,@TaxYear,@YearStartDate,@YearEndDate,NULL,NULL,NULL,NULL)) AS TaxableIncome
					   ,ISNULL(ABS(PREC.ActualComponentAmount),0) AS IncomeTax
				FROM Employee E
				     INNER JOIN [User] U ON U.Id = E.UserId
					 --INNER JOIN PayrollRunEmployee PRE ON PRE.EmployeeId = E.Id
					 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                                AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                        	    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
					 INNER JOIN (SELECT EmployeeId
							            ,MAX(RunDate) AS RunDate
							     FROM PayrollRun PR
								      INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
							          INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
							     WHERE DATENAME(YEAR,PR.PayrollEndDate) = DATENAME(YEAR,@Month)
							         AND DATENAME(MONTH,PR.PayrollEndDate) = DATENAME(MONTH,@Month)
							         --AND PRE.PayrollStatusId <> @RejectStatusId
							         AND PR.InactiveDateTime IS NULL
							         AND PRE.InactiveDateTime IS NULL
							         AND PR.CompanyId = @CompanyId
							     GROUP BY EmployeeId,DATENAME(MONTH,PR.PayrollEndDate), DATENAME(YEAR,PR.PayrollEndDate)
							     		) RE ON RE.EmployeeId = E.Id
				     INNER JOIN PayrollRunEmployee PRE ON E.Id = PRE.EmployeeId
					            AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)				 
                                AND (PRE.IsInResignation IS NULL OR PRE.IsInResignation = 0)
			         INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId AND RE.RunDate = PR.RunDate
					            AND PR.CompanyId = @CompanyId
					 LEFT JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = PRE.EmployeeId 
                  	            AND PREC.PayrollRunId = PRE.PayrollRunId
								AND PREC.ComponentId = @TAXComponentId
					 --CROSS APPLY (SELECT EmployeeId,EmployeeName,NetSalary,TaxableAmount,Tax 
					 --             FROM dbo.[Ufn_GetEmployeeTaxDetails](E.Id,@TaxYear,@YearStartDate,@YearEndDate)) TDS
					 LEFT JOIN Job J ON J.EmployeeId = E.Id
			                   AND J.InActiveDateTime IS NULL
					 LEFT JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = E.Id
			                   AND EAD.InActiveDateTime IS NULL
			    WHERE U.CompanyId = @CompanyId
	        		  AND (@IsActiveEmployeesOnly = 0 
	        		    OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
	        		  AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
	        		  AND (@UserId IS NULL OR @UserId = U.Id)
			--GROUP BY EmployeeNumber,U.FirstName + ' ' + ISNULL(U.SurName,''),J.JoinedDate,EAD.PANNumber,TDS.TaxableAmount,ABS(PREC.ActualComponentAmount)

			) T
			) Temp

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