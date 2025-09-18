-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Leave Summary Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_LeaveSummaryReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_LeaveSummaryReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@Year DATETIME = NULL
	,@EntityId UNIQUEIDENTIFIER = NULL
	,@IsActiveEmployeesOnly BIT = 0
	,@UserId UNIQUEIDENTIFIER = NULL
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
			
			--IF(@IsActiveEmployeesOnly IS NULL) SET @IsActiveEmployeesOnly = 0
			
			IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
			
			IF(@Year IS NULL) SET @Year = GETDATE()
			
			DECLARE @YearStartDate DATETIME = DATEFROMPARTS(DATEPART(YEAR,@Year),1,1)
			
			CREATE TABLE #MonthTable 
			(
				MonthValue NVARCHAR(50)
				,MonthNumber INT
			)
			
			;WITH MonthCte AS
			(
			    SELECT   [MonthName]    = DATENAME(MONTH ,@YearStartDate)  
			            ,[MonthNumber]  = DATEPART(mm ,@YearStartDate)  
			            ,[MonthYear]    = DATENAME(YEAR ,@YearStartDate) 
			            ,NextRow        = DATEADD(MONTH, 1, @YearStartDate) 
			    UNION ALL
			    SELECT   DATENAME(MONTH ,NextRow)
			            ,DATEPART(mm ,NextRow)
			            ,DATENAME(YEAR ,NextRow)
			            ,DATEADD(MONTH, 1, NextRow)
			    FROM    MonthCte
				WHERE DATEPART(YEAR,NextRow) <= DATEPART(YEAR,@Year)
			)
			INSERT INTO #MonthTable(MonthValue,MonthNumber)
			SELECT  [MonthName] + ' ' + CONVERT(VARCHAR,[MonthYear])
			        ,[MonthNumber]
			FROM MonthCte
			OPTION(MAXRECURSION 0)
			
			DECLARE @MonthsList NVARCHAR(MAX)
			
			SELECT @MonthsList = COALESCE(@MonthsList + ',' ,'') + '[' + MonthValue + ']'
			FROM #MonthTable

			IF(@ColumnString IS NULL OR @ColumnString = '') 
			SET @ColumnString = '[Employee Name],[Employee Number],[Date Of Joining],[Designation],'+ @MonthsList

			DECLARE @SqlQuery NVARCHAR(MAX) = '('

			SET @SqlQuery = @SqlQuery + 'SELECT *
                                         FROM
                                         (
                                         SELECT MT.MonthValue
                                                ,E.EmployeeNumber AS [Employee Number]
                                           	   ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Employee Name]
                                           	   ,CONVERT(VARCHAR,J.JoinedDate,106) AS [Date Of Joining]
                                           	   ,D.DesignationName AS [Designation]
                                           	   ,ISNULL(LossOfPay,0) AS [LOP]
                                           FROM #MonthTable MT
                                                CROSS APPLY Employee E
                                           	 INNER JOIN [User] U ON U.Id = E.UserId '

						IF(@UserId IS NOT NULL) SET @SqlQuery = @SqlQuery + ' AND @UserId = U.Id '

           SET @SqlQuery = @SqlQuery + ' INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
                                                    AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                                                    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy)) '
           
		   IF(@EntityId IS NOT NULL) SET @SqlQuery = @SqlQuery + ' AND (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)) '
                 
		   IF(@IsActiveEmployeesOnly IS NOT NULL AND @IsActiveEmployeesOnly = 1)
				SET  @SqlQuery = @SqlQuery + ' AND E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL '

		   IF(@IsActiveEmployeesOnly IS NOT NULL AND @IsActiveEmployeesOnly = 0)
		   	SET  @SqlQuery = @SqlQuery + ' AND (E.InActiveDateTime IS NOT NULL OR U.InActiveDateTime IS NOT NULL) '
              
           SET @SqlQuery = @SqlQuery + ' LEFT JOIN Job J ON J.EmployeeId = E.Id
		                                 LEFT JOIN Designation D ON D.Id = J.DesignationId
                                         LEFT JOIN (
                                                     SELECT PRE.EmployeeId
                                                            ,PRE.EmployeeName
                                                            ,PRE.LossOfPay
                                                     	   ,DATENAME(MONTH,PR.PayrollEndDate) + '' '' + DATENAME(YEAR,PR.PayrollEndDate) AS RunDate
                                                     FROM PayrollRunEmployee PRE
                                                          INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
                                                     			           AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)
                                                     					   AND (PRE.IsInResignation IS NULL OR PRE.IsInResignation = 0)
                                                     			            			INNER JOIN (SELECT PRE.EmployeeId
                                                     			                   ,MAX(RunDate) AS RunDate
                                                     			                   ,DATENAME(MONTH,PR.PayrollEndDate) AS PayrollMonth
                                                     			                   ,DATENAME(YEAR,PR.PayrollEndDate) AS PayrollYear
                                                     			            FROM PayrollRun PR
																			     INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                                                     INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = ''Paid''
                                                     			                 INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
                                                     			            WHERE DATENAME(YEAR,PR.PayrollEndDate) = DATENAME(YEAR,@Year)
                                                     			            	  --AND DATENAME(MONTH,PR.PayrollEndDate) = DATENAME(MONTH,ER.LastDate)
                                                     			                  AND PR.InactiveDateTime IS NULL
                                                     			                  AND PRE.InactiveDateTime IS NULL
                                                     			                  AND PR.CompanyId = @CompanyId
                                                     			            GROUP BY PRE.EmployeeId,DATENAME(MONTH,PR.PayrollEndDate), DATENAME(YEAR,PR.PayrollEndDate)
                                                     			) RE ON RE.EmployeeId = PRE.EmployeeId AND RE.RunDate = PR.RunDate
                                            ) LOP ON LOP.RunDate = MT.MonthValue AND LOP.EmployeeId = E.Id
                                         WHERE U.CompanyId = @CompanyId	
										 ) MainQuery
                                         PIVOT(
                                         	
                                         	SUM([LOP])
                                         	FOR MonthValue IN (' + @MonthsList + ')
                                         
                                         ) PivotQuery'
		
		SET @SqlQuery = @SqlQuery + ') InnerSql'

		DECLARE @FinalSql NVARCHAR(MAX) = 'SELECT ' + @ColumnString + '  FROM ' + @SqlQuery + ' ORDER BY [Employee Name]'

		PRINT @FinalSql

		EXEC SP_EXECUTESQL @FinalSql,
		N'@CompanyId UNIQUEIDENTIFIER
		  ,@Year DATETIME
		  ,@EntityId UNIQUEIDENTIFIER
		  ,@OperationsPerformedBy UNIQUEIDENTIFIER
		  ,@IsActiveEmployeesOnly BIT
		  ,@UserId UNIQUEIDENTIFIER'
		  ,@CompanyId
		  ,@Year
		  ,@EntityId
		  ,@OperationsPerformedBy
		  ,@IsActiveEmployeesOnly
		  ,@UserId

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

