-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Profession Tax Returns
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetProfessionTaxReturns] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetProfessionTaxReturns]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@BranchId UNIQUEIDENTIFIER = NULL
	,@Date DATETIME = NULL
	--,@EntityId UNIQUEIDENTIFIER = NULL
	--,@UserId UNIQUEIDENTIFIER = NULL
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
			
			IF(@IsActiveEmployeesOnly IS NULL) SET @IsActiveEmployeesOnly = 0
            
            IF(@Date IS NULL) SET @Date = GETDATE() 

			IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL

			IF(@BranchId IS NULL)
			BEGIN
				
				SELECT @BranchId = EB.BranchId 
				FROM EmployeeBranch EB
				     INNER JOIN [Employee] E ON E.Id = EB.EmployeeId
					            AND EB.ActiveFrom IS NOT NULL AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= GETDATE())
				 WHERE E.UserId = @OperationsPerformedBy

			END

			CREATE TABLE #ProfessionTaxReturnDetails 
			(
				EmployeeId UNIQUEIDENTIFIER
				,CompanyName NVARCHAR(250)
				,[Address] NVARCHAR(1000) NULL
				,ActualComponentAmount DECIMAL(18,2) 
				,TaxAmount DECIMAL(18,2) 
				,ProfBasic DECIMAL(18,2)
				,RangeText NVARCHAR(100)
			)
			
			INSERT INTO #ProfessionTaxReturnDetails(EmployeeId,ActualComponentAmount,TaxAmount,ProfBasic,RangeText,CompanyName,[Address])
			SELECT EmployeeId,ActualComponentAmount,TaxAmount,ActualEarning,RangeText,CompanyName,[Address] 
			FROM
			(
			SELECT E.Id EmployeeId
				    --   ,EPC.PayrollTemplateId
					   --,PREC.ComponentId AS PayrollComponentId
					   --,PC.Componentname
					   ,ABS(PREC.ActualComponentAmount) ActualComponentAmount
					   --,DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate) AS RunMonth
					   ,PRE.ActualEarning
					   --,PRE.EmployeeName
					   ,C.CompanyName
					   ,B.[Address]
					   ,B.Id AS BranchId
				FROM Employee E
				INNER JOIN [User] U ON U.Id = E.UserId
				--INNER JOIN Job J ON J.EmployeeId = E.Id
				--           AND J.InActiveDateTime IS NULL
				--		   AND J.BranchId = @LocationId
				INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
					       AND EB.ActiveFrom IS NOT NULL AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= GETDATE())
				           AND EB.BranchId = @BranchId
	               	       AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
				INNER JOIN Branch B ON B.Id = EB.BranchId
				           AND B.InActiveDateTime IS NULL
				INNER JOIN (SELECT EmployeeId
							       ,MAX(RunDate) AS RunDate
							FROM PayrollRun PR
							     INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							     INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
							     INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
							WHERE DATENAME(YEAR,PR.PayrollEndDate) = DATENAME(YEAR,@Date)
							    AND DATENAME(MONTH,PR.PayrollEndDate) = DATENAME(MONTH,@Date)
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
					 INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = E.Id AND EPC.InActiveDateTime IS NULL --AND EPC.IsApproved = 1
					            AND ( (EPC.ActiveTo IS NOT NULL AND PR.PayrollEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo AND PR.PayrollEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo)
				  		            OR (EPC.ActiveTo IS NULL AND PR.PayrollEndDate >= EPC.ActiveFrom)
									OR (EPC.ActiveTo IS NOT NULL AND PR.PayrollStartDate <= EPC.ActiveTo AND PR.PayrollStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EPC.ActiveFrom), 0))
				  			     )
					 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = EPC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND PTC.IsRelatedToPT = 1
					 INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.ComponentId = PTC.PayrollComponentId AND PREC.EmployeeId = PRE.EmployeeId AND PREC.PayrollRunId = PR.Id
					 INNER JOIN Company C ON C.Id = U.CompanyId
				WHERE U.CompanyId = @CompanyId
				       AND (@IsActiveEmployeesOnly = 0 
				            OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
				      AND PTC.IsRelatedToPT = 1
			) T 
			INNER JOIN (SELECT FromRange,ToRange,TaxAmount,BranchId
			       ,CASE WHEN FromRange IS NULL THEN 'Upto ' + CONVERT(NVARCHAR(100),CONVERT(FLOAT,ToRange))
				         WHEN ToRange IS NULL THEN 'Above ' + CONVERT(NVARCHAR(100),CONVERT(FLOAT,FromRange))
						 ELSE CONVERT(NVARCHAR(100),CONVERT(FLOAT,FromRange)) + ' to ' + CONVERT(NVARCHAR(100),CONVERT(FLOAT,ToRange))
					END AS RangeText
			FROM [dbo].[ProfessionalTaxRange]
			WHERE (IsArchived IS NULL OR IsArchived = 0)
			       AND ( (ActiveTo IS NOT NULL AND @Date BETWEEN ActiveFrom AND ActiveTo)
			                OR (ActiveTo IS NULL AND @Date >= ActiveFrom)
				            OR (ActiveTo IS NOT NULL AND @Date <= ActiveTo AND @Date >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			              )
			GROUP BY FromRange,ToRange,TaxAmount,BranchId) PT ON (PT.FromRange IS NULL OR ActualEarning >= PT.FromRange) 
			AND (PT.ToRange IS NULL OR ActualEarning <= PT.ToRange)
			AND PT.BranchId = T.BranchId
			
            --DECLARE @RecordsCount INT = (SELECT COUNT(1) FROM #ProfessionTaxReturnDetails)

            SELECT RangeText AS Ranges
			       ,CompanyName
				   ,[Address]
			       ,COUNT(EmployeeId) AS NoOfEmployee
				   ,TaxAmount
				   ,SUM(ActualComponentAmount) TotalTax
				   --,SUM(ActualComponentAmount) OVER() AS Total
                   ,COUNT(1) OVER() AS TotalRecordsCount
			FROM #ProfessionTaxReturnDetails
			GROUP BY RangeText,TaxAmount,CompanyName,[Address]

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