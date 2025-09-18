-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get ESI Monthly Summary Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_ESIMonthlySummaryReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ESIMonthlySummaryReport]
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
			
			IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
			
			IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
			
			IF(@IsActiveEmployeesOnly IS NULL) SET @IsActiveEmployeesOnly = 0
            
           	IF(@Month IS NULL) SET @Month = GETDATE()
	        
			DECLARE @RunMonth NVARCHAR(100) = (SELECT DATENAME(MONTH,@Month) + ' ' + DATENAME(YEAR,@Month))
            
            CREATE TABLE #ESIDetails 
            (
                ComponentName NVARCHAR(250)
                ,ComponentId UNIQUEIDENTIFIER
                ,EmployeeId UNIQUEIDENTIFIER
                ,EmployeeSalary DECIMAL(18,2)
                ,DesignationId UNIQUEIDENTIFIER
                ,DesignationName NVARCHAR(250)
                ,EmployeeContribusion DECIMAL(18,2)
                ,EmployeerContribusion DECIMAL(18,2)
                ,EmployeeContribusionAsESIPortal DECIMAL(18,2)
                ,TotalContribution DECIMAL(18,2)
                ,PayrollRunId UNIQUEIDENTIFIER
            )
            
            INSERT INTO #ESIDetails(ComponentName,ComponentId,EmployeeId,EmployeeSalary,DesignationId,DesignationName,PayrollRunId)
            SELECT PC.ComponentName
                   ,PREC.ComponentId
            	,PRE.EmployeeId
            	,PRE.EmployeeSalary
            	,J.DesignationId
            	,D.DesignationName
            	,PRE.PayrollRunId
            FROM PayrollRunEmployee PRE
                 INNER JOIN Employee E ON E.Id = PRE.EmployeeId
                            AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)				 
                            AND (PRE.IsInResignation IS NULL OR PRE.IsInResignation = 0)
                 INNER JOIN [User] U ON U.Id = E.UserId
                 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
                 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                	    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                 INNER JOIN (SELECT PRE.EmployeeId
                                    ,MAX(RunDate) AS RunDate
                 			        ,PRInner.RunMonth
                         FROM (SELECT PR.Id,PR.RunDate,DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate) AS RunMonth 
                 		      FROM PayrollRun PR
							       INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							       INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
                 			  WHERE PR.InactiveDateTime IS NULL
            					AND DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate) = @RunMonth
                 			        AND PR.CompanyId = @CompanyId
            					) PRInner
                              INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PRInner.Id
                 			            AND PRE.InactiveDateTime IS NULL
                         GROUP BY PRE.EmployeeId,PRInner.RunMonth
                          ) RE ON RE.EmployeeId = PRE.EmployeeId AND RE.RunDate = PR.RunDate
                 INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = PRE.EmployeeId 
                  	            AND PREC.PayrollRunId = PRE.PayrollRunId AND PREC.PayrollRunId = PRE.PayrollRunId
            	 INNER JOIN PayrollComponent PC ON PREC.ComponentId = PC.Id
                  				AND PC.ComponentName = 'ESI'
                                AND PC.InactiveDateTime IS NULL
                 INNER JOIN Job J ON J.EmployeeId = E.Id
			                AND J.InActiveDateTime IS NULL
            	 --INNER JOIN EmployeeDesignation ED ON ED.EmployeeId = PRE.EmployeeId --TODO
            	 INNER JOIN Designation D ON D.Id = J.DesignationId --TODO
                            AND D.InActiveDateTime IS NULL
             WHERE U.CompanyId = @CompanyId
				   AND (@IsActiveEmployeesOnly = 0 
				     OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
				   AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
				   AND (@UserId IS NULL OR @UserId = U.Id)
             GROUP BY PC.ComponentName,PREC.ComponentId,PRE.EmployeeId,PRE.EmployeeSalary,J.DesignationId,D.DesignationName,PRE.PayrollRunId

             UPDATE #ESIDetails SET EmployeeContribusion = ABS(PREC.ActualComponentAmount)
	                FROM #ESIDetails ED
		                 INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = ED.EmployeeId 
                          	            AND PREC.PayrollRunId = ED.PayrollRunId
			         					AND (PREC.ComponentName = 'Employee ' + ED.ComponentName)
                    
            UPDATE #ESIDetails SET EmployeerContribusion = ABS(PREC.ActualComponentAmount)
                   FROM #ESIDetails ED
            	        INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = ED.EmployeeId 
                            	            AND PREC.PayrollRunId = ED.PayrollRunId
            							AND (PREC.ComponentName = 'Employeer ' + ED.ComponentName)
            
            UPDATE #ESIDetails SET EmployeeContribusionAsESIPortal = ED.EmployeerContribusion,TotalContribution = ISNULL(ED.EmployeeContribusion,0) + ISNULL(ED.EmployeerContribusion,0)
            FROM #ESIDetails ED
            
            DECLARE @RecordsCount INT = (SELECT COUNT(1) FROM #ESIDetails)
			
            --DECLARE @CurrencyCode NVARCHAR(50) = (SELECT [dbo].[Ufn_GetCurrencyCodeOfaCompany](@OperationsPerformedBy))

            IF(@RecordsCount > 0)
            BEGIN

                SELECT [DesignationName] AS [Designation Name]
                       ,COUNT(1) AS [Employee Count]
                	   ,SUM(EmployeeSalary) AS [Employee Salary]
                	   ,SUM(EmployeeContribusion) AS [Employee Contribution]
                	   ,SUM(EmployeerContribusion) AS [Employer Contribution]
                	   ,SUM(EmployeeContribusionAsESIPortal) AS [Employer Contribution As Per ESI Portal]
                	   ,SUM(TotalContribution) AS [Total Contribution]
                FROM #ESIDetails
                GROUP BY DesignationName
                --UNION --ALL
                --SELECT 'Total'
                --       ,COUNT(1)
                --	   ,SUM(EmployeeSalary) AS EmployeeSalary
                --	   ,SUM(EmployeeContribusion) AS EmployeeContribusion
                --	   ,SUM(EmployeerContribusion) AS EmployeerContribusion
                --	   ,SUM(EmployeeContribusionAsESIPortal) AS EmployeeContribusionAsESIPortal
                --	   ,SUM(TotalContribution) AS TotalContribution
                --   FROM #ESIDetails
                --   WHERE @RecordsCount > 0

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
