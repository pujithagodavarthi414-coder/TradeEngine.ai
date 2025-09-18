-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Quick Salary Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetSalaryforITReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetSalaryforITReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@Date DATETIME = NULL
	,@EntityId UNIQUEIDENTIFIER = NULL
	--,@IsActiveEmployeesOnly BIT = 0
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
			
			DECLARE @PayrollComponentsList NVARCHAR(MAX)
            
			IF(@Date IS NULL) SET @Date = GETDATE()
            
			DECLARE @RunMonth NVARCHAR(100) = (SELECT DATENAME(MONTH,@Date) + ' ' + DATENAME(YEAR,@Date))

			       CREATE TABLE #SalaryDetails 
                    (
                    	EmployeeId UNIQUEIDENTIFIER
                    	,ComponentId UNIQUEIDENTIFIER
                    	,ActualComponentAmount DECIMAL(18,2)
                    	,PayrollRunId UNIQUEIDENTIFIER
                    	,ComponentName NVARCHAR(250)
                    	,PayrollComponentName NVARCHAR(250)
                    	,IsDeduction BIT
                    )
                    
                    INSERT INTO #SalaryDetails(EmployeeId,ComponentId,ActualComponentAmount,PayrollRunId,ComponentName,PayrollComponentName,IsDeduction)
                    SELECT T.EmployeeId,T.ComponentId,ISNULL(T.ActualComponentAmount,0),T.PayrollRunId,PC.ComponentName,T.PayrollComponentName,T.IsDeduction
                    FROM PayrollComponent PC
                    LEFT JOIN (
                    SELECT PRE.EmployeeId
                           ,PREC.ComponentId
                    	   ,SUM(ABS(PREC.ActualComponentAmount)) AS ActualComponentAmount
                    	   ,PRE.PayrollRunId
                    	   ,PREC.ComponentName AS PayrollComponentName
                    	   ,PREC.IsDeduction
                    	   --,PRE.ActualPaidAmount
                    FROM PayrollRunEmployee PRE
                              INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
                         	  INNER JOIN (SELECT PRE.EmployeeId
                                                ,MAX(RunDate) AS RunDate
                         				        ,PRInner.RunMonth
                                     FROM (SELECT PR.Id,PR.RunDate,DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate) AS RunMonth 
                         			      FROM PayrollRun PR
                         				  WHERE PR.InactiveDateTime IS NULL
                    							AND DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate) = @RunMonth
                         				        AND PR.CompanyId = @CompanyId
                    							) PRInner
                                          INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PRInner.Id
                         				            AND PRE.InactiveDateTime IS NULL
                                     GROUP BY PRE.EmployeeId,PRInner.RunMonth
                                      ) RE ON RE.EmployeeId = PRE.EmployeeId AND RE.RunDate = PR.RunDate
                         	 INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = PRE.EmployeeId 
                         	            AND PREC.PayrollRunId = PRE.PayrollRunId
                    GROUP BY PRE.EmployeeId,PREC.ComponentId,PRE.PayrollRunId,PREC.ComponentName,PREC.IsDeduction
                    ) T ON T.ComponentId = PC.Id
                    WHERE PC.InactiveDateTime IS NULL AND PC.CompanyId = @CompanyId
                    
                    --INSERT INTO #SalaryDetails(EmployeeId,ActualComponentAmount,PayrollRunId,ComponentName,IsDeduction)
                    --SELECT
                    --FROM #SalaryDetails SD
                    
                    INSERT INTO #SalaryDetails(EmployeeId,ActualComponentAmount,PayrollRunId,ComponentName,IsDeduction)
                    SELECT SD.EmployeeId,PRE.ActualPaidAmount,PRE.PayrollRunId,'Salary Control Account',1
                    FROM #SalaryDetails SD
                         INNER JOIN PayrollRunEmployee PRE ON PRE.EmployeeId = SD.EmployeeId AND PRE.PayrollRunId = SD.PayrollRunId
                    GROUP BY SD.EmployeeId,PRE.ActualPaidAmount,PRE.PayrollRunId
                    
                    SELECT * FROM
                    (
                    SELECT ComponentName
                           ,COUNT(EmployeeId) AS EmployeesCount
                    	   --,SUM(ActualComponentAmount) AS ActualComponentAmount
                    	   ,SUM(CASE WHEN IsDeduction = 0 THEN ActualComponentAmount ELSE 0 END) AS Debit
                    	   ,SUM(CASE WHEN IsDeduction = 1 THEN ActualComponentAmount ELSE 0 END) AS Credit
                    	   --,IsDeduction
                    FROM #SalaryDetails
                    GROUP BY ComponentName --,IsDeduction
                    UNION --ALL
                    SELECT 'Total'
                           ,COUNT(DISTINCT EmployeeId)
                    	   ,SUM(CASE WHEN IsDeduction = 0 THEN ActualComponentAmount ELSE 0 END) AS Debit
                    	   ,SUM(CASE WHEN IsDeduction = 1 THEN ActualComponentAmount ELSE 0 END) AS Credit
                    FROM #SalaryDetails
                    ) T
                    ORDER BY T.Credit
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

