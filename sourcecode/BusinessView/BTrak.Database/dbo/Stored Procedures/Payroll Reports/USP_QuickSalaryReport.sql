-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Quick Salary Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_QuickSalaryReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_QuickSalaryReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@Month DATETIME = NULL
	,@EntityId UNIQUEIDENTIFIER = NULL
	,@IsActiveEmployeesOnly BIT = 0
	,@ColumnString NVARCHAR(1500) = NULL
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
			
			IF(@IsActiveEmployeesOnly IS NULL) SET @IsActiveEmployeesOnly = 0
            
			DECLARE @PayrollComponentsList NVARCHAR(MAX)
            
            SELECT @PayrollComponentsList = COALESCE(@PayrollComponentsList + ',' ,'') + '[' + ComponentName + ']'
            FROM PayrollComponent
            WHERE InactiveDateTime IS NULL AND CompanyId = @CompanyId

			IF(@ColumnString IS NULL OR @ColumnString = '') 
			SET @ColumnString = '[Employee Name],[Employee Number],[Date Of Joining],[Days In Month],[Effective Working Days],[LOP],'+ @PayrollComponentsList
			                     +',[Actual Net Pay Amount],[Net Pay Amount],[Total Deductions ToDate],[Actual Deductions ToDate],[Total Earnings ToDate],[Actual Earnings ToDate],[Is In Resignation],[Is Hold]'

			IF(@Month IS NULL) SET @Month = GETDATE()

			--TODO
			DECLARE @RejectStatusId UNIQUEIDENTIFIER = (SELECT Id FROM PayrollStatus WHERE IsArchived = 0 AND PayrollStatusName = 'Rejected' AND CompanyId = @CompanyId)

			DECLARE @SqlQuery NVARCHAR(MAX) = '('

			SET @SqlQuery = @SqlQuery + 'SELECT PRE.Id PayrollRunEmployeeId,
										   PRE.EmployeeName AS [Employee Name],
										   E.EmployeeNumber AS [Employee Number],
										   CONVERT(VARCHAR,J.JoinedDate,106) AS [Date Of Joining],
										   PRE.TotalWorkingDays AS [Days In Month],
										   PRE.EffectiveWorkingDays AS [Effective Working Days],
										   PRE.LossOfPay AS LOP,
										   PRE.ActualPaidAmount AS [Actual Net Pay Amount],
										   PRE.PaidAmount AS [Net Pay Amount],
										   ABS(PRE.TotalDeductionsToDate) AS [Total Deductions ToDate],
										   ABS(PRE.ActualDeductionsToDate) AS [Actual Deductions ToDate],
										   ABS(PRE.TotalEarningsToDate) AS [Total Earnings ToDate],
										   ABS(PRE.ActualEarningsToDate) AS [Actual Earnings ToDate],
										   CASE WHEN ISNULL(PRE.IsInResignation,0) = 0 THEN ''No'' ELSE ''Yes'' END AS [Is In Resignation],
										   CASE WHEN ISNULL(PRE.IsHold,0) = 1 THEN ''Yes''
										        WHEN ISNULL(PRE.IsInResignation,0) = 1 THEN ''Yes'' 
										        ELSE ''No'' END AS [Is Hold],
										   OuterPivot.* 
									FROM PayrollRunEmployee PRE
									     INNER JOIN Employee E On E.Id = PRE.EmployeeId 
										            AND E.InActiveDateTime IS NULL
										 INNER JOIN [User] U ON U.Id = E.UserId
												    AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
										 LEFT JOIN Job J ON J.EmployeeId = E.Id
							                               AND J.InActiveDateTime IS NULL
									INNER JOIN 
									(
										SELECT T.* 
										FROM
										   (
										    SELECT EmployeeId
											       ,ComponentName
												   --,[dbo].[Ufn_GetCurrency](CurrencyCode,Actual,1) AS Actual
												   ,Actual
												   ,PayrollRunId
										    FROM (
											SELECT PRE.EmployeeId,
										           PREC.ComponentId,
										    	   SUM(ABS(PREC.ActualComponentAmount)) Actual
										    	   ,PRE.PayrollRunId
										    FROM PayrollRunEmployee PRE
												 INNER JOIN Employee E ON E.Id = PRE.EmployeeId
										         INNER JOIN [User] U ON U.Id = E.UserId
												 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
												 
												 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                                                        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                	                                    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy)) '

           IF(@EntityId IS NOT NULL) SET @SqlQuery = @SqlQuery + ' AND (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)) '
		    
		   IF(@IsActiveEmployeesOnly =1)
				SET  @SqlQuery = @SqlQuery + ' AND E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL '

				   SET @SqlQuery = @SqlQuery + ' INNER JOIN (SELECT EmployeeId
												                    ,MAX(RunDate) AS RunDate
												                    ,DATENAME(MONTH,PR.PayrollEndDate) AS PayrollMonth
															        ,DATENAME(YEAR,PR.PayrollEndDate) AS PayrollYear
															 FROM PayrollRun PR
															      INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
																  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                                      INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = ''Paid''
															 WHERE DATENAME(YEAR,PR.PayrollEndDate) = DATENAME(YEAR,@Month)
																   AND DATENAME(MONTH,PR.PayrollEndDate) = DATENAME(MONTH,@Month)
																  -- AND PRE.PayrollStatusId <> @RejectStatusId
																   AND PR.InactiveDateTime IS NULL
																   AND PRE.InactiveDateTime IS NULL
																   AND PR.CompanyId = @CompanyId
															 GROUP BY EmployeeId,DATENAME(MONTH,PR.PayrollEndDate), DATENAME(YEAR,PR.PayrollEndDate)
															) PREINNER ON PREINNER.EmployeeId = PRE.EmployeeId AND PREINNER.RunDate = PR.RunDate
											     INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = PRE.EmployeeId AND PREC.PayrollRunId = PRE.PayrollRunId
											WHERE PR.CompanyId = @CompanyId
											GROUP BY PRE.EmployeeId,PREC.ComponentId,PRE.PayrollRunId
                                            ) PRECInner
											INNER JOIN PayrollComponent PC ON PC.Id = PRECInner.ComponentId
											) MainQuery
											PIVOT 
											(
												SUM(Actual)
												FOR ComponentName IN (' + @PayrollComponentsList + ')
											)T
									) OuterPivot ON OuterPivot.EmployeeId = PRE.EmployeeId AND OuterPivot.PayrollRunId = PRE.PayrollRunId'
		
		SET @SqlQuery = @SqlQuery + ') InnerSql'

		DECLARE @FinalSql NVARCHAR(MAX) = 'SELECT ' + @ColumnString + '  FROM ' + @SqlQuery + ' ORDER BY [Employee Name]'

		PRINT @FinalSql

		EXEC SP_EXECUTESQL @FinalSql,
		N'@CompanyId UNIQUEIDENTIFIER
		  ,@Month DATETIME
		  ,@RejectStatusId UNIQUEIDENTIFIER
		  ,@EntityId UNIQUEIDENTIFIER
		  ,@OperationsPerformedBy UNIQUEIDENTIFIER'
		  ,@CompanyId
		  ,@Month
		  ,@RejectStatusId
		  ,@EntityId
		  ,@OperationsPerformedBy

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
