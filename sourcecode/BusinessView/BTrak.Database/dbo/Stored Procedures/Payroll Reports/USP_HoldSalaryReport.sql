-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Hold Salary Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_HoldSalaryReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_HoldSalaryReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@Month DATETIME = NULL
	,@EntityId UNIQUEIDENTIFIER = NULL
	,@ColumnString NVARCHAR(1500) = NULL
	,@IsActiveEmployeesOnly bit = null
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
			
			IF(@ColumnString IS NULL OR @ColumnString = '') 
			
			SET @ColumnString = '[Employee Name],[Employee Number],[Hold Month],[Is Released],[Hold Reason],[Holded Salary],[Released Month],[Released Salary]'

			IF(@Month IS NULL) SET @Month = GETDATE()

			--TODO
			DECLARE @RejectStatusId UNIQUEIDENTIFIER = (SELECT Id FROM PayrollStatus WHERE IsArchived = 0 AND PayrollStatusName = 'Rejected' AND CompanyId = @CompanyId)
			
			--TODO
			DECLARE @PayRollRunApprovedId UNIQUEIDENTIFIER =  (SELECT Id FROM PayrollStatus 
                                                   WHERE CompanyId = @CompanyId 
												         AND PayrollStatusName = 'Paid' AND IsArchived = 0)
	        
			DECLARE @ResignationApprovedId UNIQUEIDENTIFIER = (SELECT Id FROM ResignationStatus RS 
			                                                   WHERE RS.IsApproved = 1 AND RS.StatusName = 'Approved'
															         AND RS.InactiveDateTime IS NULL)

			DECLARE @SqlQuery NVARCHAR(MAX) = '('

			SET @SqlQuery = @SqlQuery + 'SELECT PRE.EmployeeName AS [Employee Name]
										        ,E.EmployeeNumber AS [Employee Number]
												,DATENAME(MONTH,PR.PayrollEndDate) + '' '' + DATENAME(YEAR,PR.PayrollEndDate) AS [Hold Month]
												,CASE WHEN PRER.Id IS NOT NULL THEN ''Yes'' ELSE ''No'' END AS [Is Released]
												,CASE WHEN  PRE.IsInResignation = 1 THEN ''In Resignation'' ELSE NULL END [Hold Reason]
												,PRE.ActualPaidAmount [Holded Salary]
												,DATENAME(MONTH,PRR.PayrollEndDate) + '' '' + DATENAME(YEAR,PRR.PayrollEndDate) AS [Released Month]
												,PRER.ActualPaidAmount AS [Released Salary]
										 FROM PayrollRunEmployee PRE
										 INNER JOIN Employee E ON E.Id = PRE.EmployeeId
										            AND E.InActiveDateTime IS NULL
													AND ((PRE.IsHold IS NOT NULL AND PRE.IsHold = 1)
													    OR (PRE.IsInResignation  IS NOT NULL AND PRE.IsInResignation = 1))
										 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
										 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
													AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                								AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))'

						IF(@EntityId IS NOT NULL) SET @SqlQuery = @SqlQuery + ' AND (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)) '
		   
		   SET @SqlQuery = @SqlQuery +  'INNER JOIN (SELECT EmployeeId
										                    ,MAX(RunDate) AS RunDate
										 		     FROM PayrollRun PR
										 		          INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
														  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                              INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = ''Paid''
										 		     WHERE DATENAME(YEAR,PR.PayrollEndDate) = DATENAME(YEAR,@Month)
										 		  	     AND DATENAME(MONTH,PR.PayrollEndDate) = DATENAME(MONTH,@Month)
										 		  	     --AND PRE.PayrollStatusId <> @RejectStatusId
										 		  	     AND PR.InactiveDateTime IS NULL
										 		  	     AND PRE.InactiveDateTime IS NULL
										 		  	     AND PR.CompanyId = @CompanyId
										 		     GROUP BY EmployeeId,DATENAME(MONTH,PR.PayrollEndDate), DATENAME(YEAR,PR.PayrollEndDate)
									              ) PREINNER ON PREINNER.EmployeeId = PRE.EmployeeId AND PREINNER.RunDate = PR.RunDate
										  LEFT JOIN (SELECT PRE.EmployeeId
                                                          ,MAX(RunDate) AS RunDate
                                                   FROM PayrollRun PR
                                                        INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
														INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                              INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = ''Paid''
                                                   	   INNER JOIN EmployeeResignation ER ON ER.EmployeeId = PRE.EmployeeId
                                                                   AND ER.ResignationStastusId = @ResignationApprovedId 
                                                   WHERE DATENAME(YEAR,PR.PayrollEndDate) = DATENAME(YEAR,ER.LastDate)
                                                   	    AND DATENAME(MONTH,PR.PayrollEndDate) = DATENAME(MONTH,ER.LastDate)
                                                   	    --AND ER.LastDate = DATENAME(YEAR,@Month)
                                                         AND PR.InactiveDateTime IS NULL
                                                         AND PRE.InactiveDateTime IS NULL
                                                         AND PR.CompanyId = @CompanyId
                                                   GROUP BY PRE.EmployeeId,DATENAME(MONTH,PR.PayrollEndDate), DATENAME(YEAR,PR.PayrollEndDate)
                                                   ) RE ON RE.EmployeeId = PRE.EmployeeId 
                                          LEFT JOIN PayrollRun PRR ON PRR.RunDate = RE.RunDate
                                          LEFT JOIN PayrollRunEmployee PRER ON PRER.EmployeeId = RE.EmployeeId
                                                    AND PRER.PayrollRunId = PRR.Id
                                         WHERE PR.CompanyId = @CompanyId'
		
		SET @SqlQuery = @SqlQuery + ') InnerSql'

		DECLARE @FinalSql NVARCHAR(MAX) = 'SELECT ' + @ColumnString + '  FROM ' + @SqlQuery + ' ORDER BY [Employee Name]'

		EXEC SP_EXECUTESQL @FinalSql,
		N'@CompanyId UNIQUEIDENTIFIER
		  ,@Month DATETIME
		  ,@RejectStatusId UNIQUEIDENTIFIER
		  ,@PayRollRunApprovedId UNIQUEIDENTIFIER
		  ,@EntityId UNIQUEIDENTIFIER
		  ,@OperationsPerformedBy UNIQUEIDENTIFIER
		  ,@ResignationApprovedId UNIQUEIDENTIFIER'
		  ,@CompanyId
		  ,@Month
		  ,@RejectStatusId
		  ,@PayRollRunApprovedId
		  ,@EntityId
		  ,@OperationsPerformedBy
		  ,@ResignationApprovedId

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