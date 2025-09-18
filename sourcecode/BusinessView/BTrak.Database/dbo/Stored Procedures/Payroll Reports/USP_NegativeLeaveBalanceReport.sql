-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Negative Leave Balance Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_NegativeLeaveBalanceReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_NegativeLeaveBalanceReport]
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
			
			IF(@ColumnString IS NULL OR @ColumnString = '') 
			
			SET @ColumnString = '[Employee Name],[Employee Number],[Date Of Joining],[Designation],[Negative Leave Balance]'

			IF(@Month IS NULL) SET @Month = GETDATE()

			--TODO
			DECLARE @RejectStatusId UNIQUEIDENTIFIER = (SELECT Id FROM PayrollStatus WHERE IsArchived = 0 AND PayrollStatusName = 'Rejected' AND CompanyId = @CompanyId)
			
			DECLARE @SqlQuery NVARCHAR(MAX) = '('

			SET @SqlQuery = @SqlQuery + 'SELECT PRE.EmployeeName AS [Employee Name]
										        ,E.EmployeeNumber AS [Employee Number]
												,CONVERT(VARCHAR,J.JoinedDate,106) AS [Date Of Joining]
												,D.DesignationName AS [Designation]
												,PRE.LossOfPay AS [Negative Leave Balance]
										 FROM PayrollRunEmployee PRE
										 INNER JOIN Employee E ON E.Id = PRE.EmployeeId
													AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)
		                                            AND (PRE.IsInResignation IS NULL OR PRE.IsInResignation = 0)
										 INNER JOIN [User] U ON U.Id = E.UserId
										 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
										 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
													AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                								AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))'

						IF(@EntityId IS NOT NULL) SET @SqlQuery = @SqlQuery + ' AND (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)) '
		   
		   IF(@IsActiveEmployeesOnly =1)
				SET  @SqlQuery = @SqlQuery + ' AND E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL '

		   SET @SqlQuery = @SqlQuery +  'INNER JOIN (SELECT EmployeeId
										                    ,MAX(RunDate) AS RunDate
										                    ,DATENAME(MONTH,PR.PayrollEndDate) AS PayrollMonth
										 		            ,DATENAME(YEAR,PR.PayrollEndDate) AS PayrollYear
										 		     FROM PayrollRun PR
													      INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                              INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = ''Paid''
										 		          INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
										 		     WHERE DATENAME(YEAR,PR.PayrollEndDate) = DATENAME(YEAR,@Month)
										 		  	     AND DATENAME(MONTH,PR.PayrollEndDate) = DATENAME(MONTH,@Month)
										 		  	     --AND PRE.PayrollStatusId <> @RejectStatusId
										 		  	     AND PR.InactiveDateTime IS NULL
										 		  	     AND PRE.InactiveDateTime IS NULL
										 		  	     AND PR.CompanyId = @CompanyId
										 		     GROUP BY EmployeeId,DATENAME(MONTH,PR.PayrollEndDate), DATENAME(YEAR,PR.PayrollEndDate)
									              ) PREINNER ON PREINNER.EmployeeId = PRE.EmployeeId AND PREINNER.RunDate = PR.RunDate
				                        LEFT JOIN Job J ON J.EmployeeId = E.Id
							                      AND J.InActiveDateTime IS NULL
										LEFT JOIN Designation D ON D.Id = J.DesignationId
							                      AND D.InActiveDateTime IS NULL
										WHERE PR.CompanyId = @CompanyId
										      AND PRE.LossOfPay > 0'
		
		SET @SqlQuery = @SqlQuery + ') InnerSql'

		DECLARE @FinalSql NVARCHAR(MAX) = 'SELECT ' + @ColumnString + '  FROM ' + @SqlQuery + ' ORDER BY [Employee Name]'

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