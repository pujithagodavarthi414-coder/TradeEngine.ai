------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Salary Bill Register
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetSalaryBillRegister] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetSalaryBillRegister]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@Date DATETIME = NULL
	,@EntityId UNIQUEIDENTIFIER = NULL
	,@UserId UNIQUEIDENTIFIER = NULL
	,@IsActiveEmployeesOnly BIT = 0
    ,@PageNo INT = 1
    ,@SortDirection NVARCHAR(250) = NULL
    ,@SortBy NVARCHAR(250) = NULL
    ,@PageSize INT = NULL
    ,@SearchText NVARCHAR(100) = NULL
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
            
			DECLARE @PayrollComponentsList NVARCHAR(MAX),@ColumnString NVARCHAR(1500) = NULL
            
            SELECT @PayrollComponentsList = COALESCE(@PayrollComponentsList + ',' ,'') + '[' + ComponentName + ']'
            FROM PayrollComponent
            WHERE InactiveDateTime IS NULL AND CompanyId = @CompanyId

			SET @ColumnString = '[Name],[Employee Number],[ProfileImage],[UserId],[IsArchived],[Date Of Joining],[Designation],[Days In Month],[Effective Working Days],'+ @PayrollComponentsList
			                     +',[Actual Net Pay Amount]'

			IF(@Date IS NULL) SET @Date = GETDATE()

			IF(@PageNo IS NULL OR @PageNo = 0) SET @PageNo = 1

            IF(@PageSize IS NULL OR @PageSize = 0) SET @PageSize = 30000 --2147483647 -- INTEGER MAX NUMBER 

            IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'

            IF(@SearchText = '') SET @SearchText = NULL

            IF(@SortBy IS NULL) SET @SortBy = '[Name]'
			ELSE  SET @SortBy = '[' + @SortBy + ']'

            SET @SearchText = '%' + @SearchText + '%'

			DECLARE @ComponentList NVARCHAR(1500) = 
			(SELECT PC.ComponentName
			       ,PC.IsDeduction AS IsDeduction
             	   ,CASE WHEN PC.ComponentName <> 'Leave Encashment' AND PC.IsDeduction = 0 THEN 1 ELSE 0 END AS IsEarning
             	   ,CASE WHEN PC.ComponentName = 'Leave Encashment' THEN 1 ELSE 0 END AS IsOther
			FROM PayrollComponent PC
			WHERE InactiveDateTime IS NULL AND CompanyId = @CompanyId
			FOR JSON PATH)

			--TODO
			--DECLARE @RejectStatusId UNIQUEIDENTIFIER = (SELECT Id FROM PayrollStatus WHERE IsArchived = 0 AND PayrollStatusName = 'Rejected' AND CompanyId = @CompanyId)

			DECLARE @SqlQuery NVARCHAR(MAX) = '('

			SET @SqlQuery = @SqlQuery + 'SELECT PRE.Id PayrollRunEmployeeId,
										   PRE.EmployeeName AS [Name],
										   E.EmployeeNumber AS [Employee Number],
										   U.ProfileImage,
										   U.Id AS UserId,
                                           CASE WHEN U.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
										   CONVERT(VARCHAR,J.JoinedDate,106) AS [Date Of Joining],
										   PRE.TotalWorkingDays AS [Days In Month],
										   PRE.EffectiveWorkingDays AS [Effective Working Days],
										   PRE.LossOfPay AS LOP,
										   PRE.ActualPaidAmount AS [Actual Net Pay Amount],
										   PRE.PaidAmount AS [Net Pay Amount],
										   -(PRE.TotalDeductionsToDate) AS [Total Deductions ToDate],
										   -(PRE.ActualDeductionsToDate) AS [Actual Deductions ToDate],
										   PRE.TotalEarningsToDate AS [Total Earnings ToDate],
										   PRE.ActualEarningsToDate AS [Actual Earnings ToDate],
										   CASE WHEN ISNULL(PRE.IsInResignation,0) = 0 THEN ''No'' ELSE ''Yes'' END AS [Is In Resignation],
										   CASE WHEN ISNULL(PRE.IsHold,0) = 1 THEN ''Yes''
										        WHEN ISNULL(PRE.IsInResignation,0) = 1 THEN ''Yes'' 
										        ELSE ''No'' END AS [Is Hold],
												D.DesignationName AS [Designation],
										   OuterPivot.* 
									FROM PayrollRunEmployee PRE
									     INNER JOIN Employee E On E.Id = PRE.EmployeeId 
										            AND E.InActiveDateTime IS NULL
										 INNER JOIN [User] U ON U.Id = E.UserId
												    AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
										 LEFT JOIN Job J ON J.EmployeeId = E.Id
							                               AND J.InActiveDateTime IS NULL
										 LEFT JOIN Designation D ON D.Id = J.DesignationId --TODO
                                                    AND D.InActiveDateTime IS NULL
									INNER JOIN 
									(
										SELECT T.* 
										FROM
										   (
										    SELECT EmployeeId
											       ,ComponentName
												   ,Actual
												   ,PayrollRunId
										    FROM (
											SELECT PRE.EmployeeId,
										           PREC.ComponentId,
										    	   SUM(ABS(PREC.ActualComponentAmount)) Actual
										    	   ,PRE.PayrollRunId
										    FROM PayrollRunEmployee PRE
												 INNER JOIN Employee E ON E.Id = PRE.EmployeeId
												            AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)
             		                                        AND (PRE.IsInResignation IS NULL OR PRE.IsInResignation = 0)
										         INNER JOIN [User] U ON U.Id = E.UserId
												 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
												 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                                                        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                	                                    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy)) '

           IF(@EntityId IS NOT NULL) SET @SqlQuery = @SqlQuery + ' AND (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)) '
		   
		   IF(@UserId IS NOT NULL) SET @SqlQuery = @SqlQuery + ' AND @UserId = U.Id '
		   
		   IF(@IsActiveEmployeesOnly =1)
				SET  @SqlQuery = @SqlQuery + ' AND E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL '

				   SET @SqlQuery = @SqlQuery + ' INNER JOIN (SELECT EmployeeId
												                    ,MAX(RunDate) AS RunDate
												                    ,DATENAME(MONTH,PR.PayrollEndDate) AS PayrollMonth
															        ,DATENAME(YEAR,PR.PayrollEndDate) AS PayrollYear
															 FROM PayrollRun PR
															      INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                                      INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = ''Paid''
															      INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
															 WHERE DATENAME(YEAR,PR.PayrollEndDate) = DATENAME(YEAR,@Date)
																   AND DATENAME(MONTH,PR.PayrollEndDate) = DATENAME(MONTH,@Date)
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

		DECLARE @FinalSql NVARCHAR(MAX) = 'SELECT (SELECT ' + @ColumnString + '  ,COUNT(1) OVER() AS TotalRecordsCount FROM ' + @SqlQuery

		IF (@SearchText IS NOT NULL) SET @FinalSql = @FinalSql + N' WHERE (([Name] LIKE @SearchText)
		                                                                   OR ([Employee Number] LIKE @SearchText)
																		   OR ([Date Of Joining] LIKE @SearchText)
																		   OR ([Designation] LIKE @SearchText)
																		  ) '
        IF (@PageSize IS NOT NULL AND @PageSize > 0) SET @FinalSql = @FinalSql + N' ORDER BY ' +  @SortBy + ' ' + @SortDirection + N'
                                                                                                 OFFSET ((@PageNo - 1) * @PageSize) ROWS 
                                                                                                 FETCH NEXT @pageSize ROWS ONLY'
		SELECT @FinalSql = @FinalSql + ' FOR JSON PATH ) AS DataJson,@ComponentList AS ComponentJson'
		PRINT @FinalSql

		EXEC SP_EXECUTESQL @FinalSql,
		N'@CompanyId UNIQUEIDENTIFIER
		  ,@Date DATETIME
		  ,@EntityId UNIQUEIDENTIFIER
		  ,@UserId UNIQUEIDENTIFIER
          ,@SearchText NVARCHAR(100)
          ,@PageSize INT	
          ,@PageNo INT
          ,@SortBy NVARCHAR(100)
          ,@SortDirection VARCHAR(50)
		  ,@ComponentList NVARCHAR(1500)
		  ,@OperationsPerformedBy UNIQUEIDENTIFIER'
		  ,@CompanyId
		  ,@Date
		  ,@EntityId
		  ,@UserId
		  ,@SearchText
		  ,@PageSize
		  ,@PageNo
		  ,@SortBy 
		  ,@SortDirection
		  ,@ComponentList
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