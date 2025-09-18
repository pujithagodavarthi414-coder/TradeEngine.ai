-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Leave Encashment Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_LeaveEncashmentReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_LeaveEncashmentReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@DateFrom DATETIME = NULL
	,@DateTo DATETIME = NULL
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

			IF(@DateFrom IS NULL) SET @DateFrom = DATEADD(DAY,1,EOMONTH(GETDATE(),-3))
			
			IF(@DateTo IS NULL) SET @DateTo = EOMONTH(GETDATE())

			IF(@ColumnString IS NULL OR @ColumnString = '') SET @ColumnString = '[Employee Name],[Employee Number],[Days],[Paid month],[Paid Amount]'
			
			--TODO
			DECLARE @PayRollRunApprovedId UNIQUEIDENTIFIER =  (SELECT Id FROM PayrollStatus 
                                                   WHERE CompanyId = @CompanyId 
												         AND PayrollStatusName = 'Paid' AND IsArchived = 0)

			DECLARE @SqlQuery NVARCHAR(MAX) = '('

			SET @SqlQuery = @SqlQuery + 'SELECT PRE.EmployeeName AS [Employee Name]
                                               ,E.EmployeeNumber AS [Employee Number]
                                        	   ,DATENAME(MONTH,PR.PayrollEndDate) + '' '' + DATENAME(YEAR,PR.PayrollEndDate) AS [Paid month]
                                               --,[dbo].[Ufn_GetCurrency](CU.CurrencyCode,PREC.ActualComponentAmount,1) AS [Paid Amount]
                                               ,PREC.ActualComponentAmount AS [Paid Amount]
                                        	   --,CASE WHEN ISNULL(PRE.AllowedLeaves,0) - ISNULL(PRE.PaidLeaves,0) <= 0 THEN 0 ELSE ISNULL(PRE.AllowedLeaves,0) - ISNULL(PRE.PaidLeaves,0) END AS [Days]
											   ,PRE.EncashedLeaves AS [Days]
                                        FROM PayrollrunEmployee PRE
                                        INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
                                        INNER JOIN Employee E ON E.Id = PRE.EmployeeId
                                                   AND PRE.InactiveDateTime IS NULL 
                                                   AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)				 
                                                   AND (PRE.IsInResignation IS NULL OR PRE.IsInResignation = 0)
                                        INNER JOIN [User] U ON U.Id = E.UserId
                                        INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
                                        	       AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                                        	       AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                                        INNER JOIN (
                                        			SELECT EmployeeId
                                        			       ,MAX(RunDate) AS RunDate
                                        			       ,DATENAME(MONTH,PR.PayrollEndDate) AS PayrollMonth
                                        			       ,DATENAME(YEAR,PR.PayrollEndDate) AS PayrollYear
                                        			FROM PayrollRun PR
													     INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                             INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = ''Paid''
                                        			     INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
                                        			WHERE PR.PayrollEndDate >= @DateFrom
                                        			    AND PR.PayrollEndDate <= @DateTo
                                        			    --AND PRE.PayrollStatusId = @PayRollRunApprovedId
                                        			    AND PR.InactiveDateTime IS NULL
                                        			    AND PRE.InactiveDateTime IS NULL
                                        			    AND PR.CompanyId = @CompanyId
                                        			GROUP BY EmployeeId,DATENAME(MONTH,PR.PayrollEndDate), DATENAME(YEAR,PR.PayrollEndDate)
                                        ) PREInner ON PREINNER.EmployeeId = PRE.EmployeeId AND PREINNER.RunDate = PR.RunDate								              
                                        INNER JOIN PayrollRunEmployeeComponent PREC 
                                                   ON PREC.EmployeeId = PRE.EmployeeId
                                        		   AND PREC.PayrollRunId = PRE.PayrollRunId
                                        WHERE U.CompanyId = @CompanyId 
										      AND PREC.ComponentName = ''Leave Encashment'''
		
		SET @SqlQuery = @SqlQuery + ') InnerSql'

		DECLARE @FinalSql NVARCHAR(MAX) = 'SELECT ' + @ColumnString + '  FROM ' + @SqlQuery + ' ORDER BY [Employee Name]'

		EXEC SP_EXECUTESQL @FinalSql,
		N'@CompanyId UNIQUEIDENTIFIER
		  ,@DateFrom DATETIME
		  ,@DateTo DATETIME
		  ,@PayRollRunApprovedId UNIQUEIDENTIFIER
		  ,@EntityId UNIQUEIDENTIFIER
		  ,@OperationsPerformedBy UNIQUEIDENTIFIER'
		  ,@CompanyId
		  ,@DateFrom
		  ,@DateTo
		  ,@PayRollRunApprovedId
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