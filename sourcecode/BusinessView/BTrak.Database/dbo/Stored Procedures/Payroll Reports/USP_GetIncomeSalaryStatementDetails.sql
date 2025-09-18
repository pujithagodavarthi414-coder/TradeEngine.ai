-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Income Salary Statement Details
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetIncomeSalaryStatementDetails] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetIncomeSalaryStatementDetails]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@Date DATETIME = NULL
	,@EntityId UNIQUEIDENTIFIER = NULL
	,@IsActiveEmployeesOnly BIT = 0
	,@UserId UNIQUEIDENTIFIER = NULL
	,@IsFinantialYearBased BIT = 0
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
	
	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
			
			IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
			
			IF(@IsActiveEmployeesOnly IS NULL) SET @IsActiveEmployeesOnly = 0
			
			IF(@Date IS NULL) SET @Date = GETDATE()
            
			DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee E WHERE E.UserId = ISNULL(@UserId,@OperationsPerformedBy))

			DECLARE @YearStartDate DATETIME = NULL, @YearEndDate DATETIME = NULL
            
			DECLARE @ResignationApprovedId UNIQUEIDENTIFIER = (SELECT Id FROM ResignationStatus RS 
			                                                   WHERE RS.IsApproved = 1 AND RS.StatusName = 'Approved'
															         AND RS.InactiveDateTime IS NULL)

			IF(@IsFinantialYearBased = 1)
			BEGIN
				
                DECLARE @FromMonth INT,@ToMonth INT,@FromYear INT,@ToYear INT,@Year INT = DATEPART(YEAR,@Date),@Month INT = DATEPART(MONTH,@Date)

                SELECT @FromMonth = FromMonth, @ToMonth = ToMonth FROM [FinancialYearConfigurations] 
		        WHERE CountryId = (SELECT B.CountryId FROM EmployeeBranch EB INNER JOIN Branch B ON B.Id = EB.BranchId
					                  WHERE EB.EmployeeId = @EmployeeId AND EB.[ActiveFrom] IS NOT NULL 
									        AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE()))
                      AND InActiveDateTime IS NULL 
                      AND FinancialYearTypeId = (SELECT Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Tax') --Tax Type Id
                  --      AND ( (ActiveTo IS NOT NULL AND @Date BETWEEN ActiveFrom AND ActiveTo)
			             --   OR (ActiveTo IS NULL AND @Date >= ActiveFrom)
				            --OR (ActiveTo IS NOT NULL AND @Date <= ActiveTo AND @Date >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			             -- )

                SELECT @FromMonth = ISNULL(@FromMonth,4), @ToMonth = ISNULL(@ToMonth,3)

		        SELECT @FromYear = CASE WHEN @Month - @FromMonth >= 0 THEN @Year ELSE @Year - 1 END
		        SELECT @ToYear = CASE WHEN @Month - @ToMonth > 0 THEN @Year + 1 ELSE @Year END
                
		        SELECT @YearStartDate = DATEFROMPARTS(@FromYear,@FromMonth,1), @YearEndDate = EOMONTH(DATEFROMPARTS(@ToYear,@ToMonth,1))
                
			END

			IF(@YearStartDate IS NULL OR @YearEndDate IS NULL)
			BEGIN
				
				SET @YearStartDate = DATEFROMPARTS(DATEPART(YEAR,@Date),1,1)
				
				SET @YearEndDate = DATEFROMPARTS(DATEPART(YEAR,@Date),12,1)

			END

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
				WHERE NextRow <= @YearEndDate
			)
			INSERT INTO #MonthTable(MonthValue,MonthNumber)
			SELECT  [MonthName] + ' ' + CONVERT(VARCHAR,[MonthYear])
			        ,[MonthNumber]
			FROM MonthCte
			OPTION(MAXRECURSION 0)
			
            DECLARE @MonthsList NVARCHAR(MAX)
            			
            SELECT @MonthsList = COALESCE(@MonthsList + ',' ,'') + '[' + MonthValue + ']'
            FROM #MonthTable
            
            CREATE TABLE #EmployeepayrollDetail 
            (
              PayrollEndDate DATETIME
              ,RunDate NVARCHAR(100)
              ,EmployeeName NVARCHAR(500)
              ,IsInResignation BIT
              ,ActualComponentAmount DECIMAL(18,2)
              ,ComponentName NVARCHAR(250)
              ,ComponentId UNIQUEIDENTIFIER
              ,BranchId UNIQUEIDENTIFIER
              ,IsDeduction BIT
              ,IsBonus BIT
              ,EmployeeId UNIQUEIDENTIFIER
              ,OriginalAmountValue DECIMAL(18,2)
            )
            
            INSERT INTO #EmployeepayrollDetail(PayrollEndDate,RunDate,EmployeeName,IsInResignation,ActualComponentAmount,ComponentName,ComponentId,IsDeduction,IsBonus,EmployeeId,BranchId)
            SELECT PR.PayrollEndDate
                   ,DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate) AS RunDate
            	   ,PRE.EmployeeName
            	   ,PRE.IsInResignation
                   ,PCInner.Actual AS ActualComponentAmount
            	   ,PC.ComponentName
            	   ,PC.Id AS ComponentId
            	   ,PC.IsDeduction AS IsDeduction
            	   ,CASE WHEN PC.ComponentName = 'Bonus' THEN 1 ELSE 0 END AS IsBonus
            	   ,PRE.EmployeeId
                   ,EB.BranchId
            FROM PayrollRunEmployee PRE
            INNER JOIN Employee E ON E.Id = PRE.EmployeeId
                       AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)
            		   AND (PRE.IsInResignation IS NULL OR PRE.IsInResignation = 0)
            		   AND PRE.EmployeeId = @EmployeeId
            INNER JOIN [User] U ON U.Id = E.UserId
            INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
            	       AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
            	       AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))  
            INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
            INNER JOIN (
            		     	SELECT PRE.EmployeeId,
            		                PREC.ComponentId,
            		         	    SUM(ABS(ISNULL(PREC.ActualComponentAmount,0))) Actual
            		         	   ,PRE.PayrollRunId
            		         FROM PayrollRunEmployee PRE
            		     		 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
            		     		 INNER JOIN (SELECT PRE.EmployeeId
                                                    ,MAX(RunDate) AS RunDate
                                             		,PRInner.RunMonth
                                             FROM (SELECT PR.Id,PR.RunDate,DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate) AS RunMonth 
                                                  FROM PayrollRun PR
												       INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                           INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
                          	   				      INNER JOIN #MonthTable MT ON MT.MonthValue = DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate)
                                             	  WHERE PR.InactiveDateTime IS NULL
                                             	        AND PR.CompanyId = @CompanyId) PRInner
                                                  INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PRInner.Id
                                             	            AND PRE.InactiveDateTime IS NULL
                                             	 --INNER JOIN #MonthTable MT ON MT.MonthValue = PRInner.RunMonth
                                             GROUP BY PRE.EmployeeId,PRInner.RunMonth
                                  ) PREINNER ON PREINNER.EmployeeId = PRE.EmployeeId AND PREINNER.RunDate = PR.RunDate
            		     	     INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = PRE.EmployeeId AND PREC.PayrollRunId = PRE.PayrollRunId
                       AND PREC.EmployeeId = PRE.EmployeeId
            		   AND PREC.InactiveDateTime IS NULL
            		   GROUP BY  PRE.EmployeeId,PREC.ComponentId,PRE.PayrollRunId
            		   ) PCInner ON PCInner.PayrollRunId = PR.Id AND PCInner.EmployeeId = E.Id
            INNER JOIN PayrollComponent PC ON PC.Id = PCInner.ComponentId
            WHERE PRE.EmployeeId = @EmployeeId
                   AND U.CompanyId = @CompanyId
	        	   AND (@IsActiveEmployeesOnly = 0 
	        	     OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
	        	   AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
	        	   --AND (@UserId IS NULL OR @UserId = U.Id)

            UPDATE #EmployeepayrollDetail SET OriginalAmountValue = CASE WHEN IsDeduction = 1 THEN 0 -(ActualComponentAmount) ELSE ActualComponentAmount END
            
            DECLARE @SqlQuery NVARCHAR(MAX) = ''

            SET @SqlQuery = '
            SELECT 
            (
            SELECT * FROM 
            (SELECT EPD.ComponentName
                   ,EPD.ActualComponentAmount
            	   ,MT.MonthValue
            	   ,EPDInner.Total
            FROM #MonthTable MT
                 LEFT JOIN (SELECT ComponentName,RunDate,ActualComponentAmount
                            FROM 
                            ( SELECT EPD.ComponentName,EPD.ActualComponentAmount,EPD.RunDate 
                              FROM #EmployeepayrollDetail EPD
                              WHERE IsDeduction = 0 AND IsBonus = 0
                              UNION
                              SELECT
                              ''Total''
                              ,SUM(ActualComponentAmount) TotalComponentAmount
                              ,RunDate
                              FROM #EmployeepayrollDetail
                              WHERE IsDeduction = 0 AND IsBonus = 0
                              GROUP BY RunDate
                            ) 
            			T) EPD ON MT.MonthValue = EPD.RunDate
            	 LEFT JOIN (SELECT ComponentName,SUM(ActualComponentAmount) AS Total
                            FROM #EmployeepayrollDetail EPD
            	            WHERE EPD.IsDeduction = 0 AND IsBonus = 0
                            GROUP BY ComponentName
            				UNION
            				SELECT ''Total''
                                    ,SUM(ActualComponentAmount) TotalComponentAmount
                            FROM #EmployeepayrollDetail
                            WHERE IsDeduction = 0 AND IsBonus = 0
                            ) EPDInner ON EPDInner.ComponentName = EPD.ComponentName
            	 WHERE EPD.ComponentName IS NOT NULL --EPD.IsDeduction = 1 AND IsBonus = 0
            ) MainQuery
            PIVOT
            (
                 SUM(ActualComponentAmount)
                  FOR MonthValue IN (' + @MonthsList + ')
            )PivotQuery
			ORDER BY ComponentName
            FOR JSON PATH
            ) AS MonthlyIncome
            ,(
            SELECT * FROM 
            (SELECT EPD.ComponentName
                   ,EPD.ActualComponentAmount
            	   ,MT.MonthValue
            	   ,EPDInner.Total
            FROM #MonthTable MT
                 LEFT JOIN (SELECT ComponentName,RunDate,ActualComponentAmount
                            FROM 
                            ( SELECT EPD.ComponentName,EPD.ActualComponentAmount,EPD.RunDate 
                              FROM #EmployeepayrollDetail EPD
                              WHERE IsBonus = 1
                              UNION
                              SELECT
                              ''Total''
                              ,SUM(ActualComponentAmount) TotalComponentAmount
                              ,RunDate
                              FROM #EmployeepayrollDetail
                              WHERE IsBonus = 1
                              GROUP BY RunDate
                            ) 
            			T) EPD ON MT.MonthValue = EPD.RunDate
            	 LEFT JOIN (SELECT ComponentName,SUM(ActualComponentAmount) AS Total
                            FROM #EmployeepayrollDetail EPD
            	            WHERE IsBonus = 1
                            GROUP BY ComponentName
            				UNION
            				SELECT ''Total''
                                    ,SUM(ActualComponentAmount) TotalComponentAmount
                            FROM #EmployeepayrollDetail
                            WHERE IsBonus = 1
                            ) EPDInner ON EPDInner.ComponentName = EPD.ComponentName
            	 WHERE EPD.ComponentName IS NOT NULL --EPD.IsDeduction = 1 AND IsBonus = 0
            ) MainQuery
            PIVOT
            (
                 SUM(ActualComponentAmount)
                  FOR MonthValue IN (' + @MonthsList + ')
            )PivotQuery
			ORDER BY ComponentName
            FOR JSON PATH
            ) AS AdhocIncome
            ,(
            SELECT * FROM 
            (SELECT EPD.ComponentName
                   ,EPD.ActualComponentAmount
            	   ,MT.MonthValue
            	   ,EPDInner.Total
            FROM #MonthTable MT
                 LEFT JOIN (SELECT ComponentName,RunDate,ActualComponentAmount
                            FROM 
                            ( SELECT EPD.ComponentName,EPD.ActualComponentAmount,EPD.RunDate 
                              FROM #EmployeepayrollDetail EPD
                              WHERE IsDeduction = 1 AND IsBonus = 0
                              UNION
                              SELECT
                              ''Total''
                              ,SUM(ActualComponentAmount) TotalComponentAmount
                              ,RunDate
                              FROM #EmployeepayrollDetail
                              WHERE IsDeduction = 1 AND IsBonus = 0
                              GROUP BY RunDate
                            ) 
            			T) EPD ON MT.MonthValue = EPD.RunDate
            	 LEFT JOIN (SELECT ComponentName,SUM(ActualComponentAmount) AS Total
                            FROM #EmployeepayrollDetail EPD
            	            WHERE EPD.IsDeduction = 1 AND IsBonus = 0
                            GROUP BY ComponentName
            				UNION
            				SELECT ''Total''
                                    ,SUM(ActualComponentAmount) TotalComponentAmount
                            FROM #EmployeepayrollDetail
                            WHERE IsDeduction = 1 AND IsBonus = 0
                            ) EPDInner ON EPDInner.ComponentName = EPD.ComponentName
            	 WHERE EPD.ComponentName IS NOT NULL --EPD.IsDeduction = 1 AND IsBonus = 0
            ) MainQuery
            PIVOT
            (
                 SUM(ActualComponentAmount)
                  FOR MonthValue IN (' + @MonthsList + ')
                  --FOR MonthValue IN ([January 2020],[February 2020],[March 2020],[April 2020],[May 2020],[June 2020],[July 2020],[August 2020],[September 2020],[October 2020],[November 2020],[December 2020])
            )PivotQuery
			ORDER BY ComponentName
            FOR JSON PATH
            ) AS Deductions
            ,(
            SELECT * FROM 
            (
            SELECT EPD.ComponentName
                   ,EPD.ActualComponentAmount
            	   ,MT.MonthValue
            	   ,EPDInner.Total
            FROM #MonthTable MT
                 LEFT JOIN (SELECT ComponentName,RunDate,ActualComponentAmount
                            FROM 
                            ( 
                              SELECT
                              ''Total'' AS ComponentName
                              ,SUM(OriginalAmountValue) ActualComponentAmount
                              ,RunDate
                              FROM #EmployeepayrollDetail
                              GROUP BY RunDate
                            ) 
            			T) EPD ON MT.MonthValue = EPD.RunDate
            	 LEFT JOIN (
            				SELECT ''Total'' AS ComponentName
                                    ,SUM(OriginalAmountValue) Total
                            FROM #EmployeepayrollDetail
                            ) EPDInner ON EPDInner.ComponentName = EPD.ComponentName
            	 WHERE EPD.ComponentName IS NOT NULL --EPD.IsDeduction = 1 AND IsBonus = 0
            ) MainQuery
            PIVOT
            (
                 SUM(ActualComponentAmount)
                  FOR MonthValue IN (' + @MonthsList + ')
            )PivotQuery
            FOR JSON PATH
            ) AS TotalIncome
            ,E.EmployeeNumber
            ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS EmployeeName
            ,U.ProfileImage
            ,U.Id AS UserId
            ,CASE WHEN U.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
            ,EAD.PANNumber
            ,G.Gender
            ,B.BranchName AS Location
            ,CONVERT(VARCHAR,J.JoinedDate,106) AS JoinedDate
            ,CONVERT(VARCHAR,E.DateofBirth,106) AS DateofBirth
            ,CONVERT(VARCHAR,ER.LastDate,106) AS DateOfLeavingService
            FROM Employee E
             INNER JOIN [User] U ON U.Id = E.userId
                        AND E.Id = ''' + CONVERT(NVARCHAR(70),@EmployeeId) + '''
             LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
            	       AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
             LEFT JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = E.Id
		               AND EAD.InActiveDateTime IS NULL
	         LEFT JOIN Job J ON J.EmployeeId = E.Id
		             AND J.InActiveDateTime IS NULL
	         LEFT JOIN Designation D ON D.Id = J.DesignationId
		               AND D.InActiveDateTime IS NULL
             LEFT JOIN Branch B ON B.Id = EB.BranchId
		               AND B.InActiveDateTime IS NULL
             LEFT JOIN Gender G ON G.Id = E.GenderId
		               AND G.InActiveDateTime IS NULL
             LEFT JOIN EmployeeResignation ER ON ER.EmployeeId = E.Id
                         AND ER.ResignationStastusId = ''' + CONVERT(NVARCHAR(70),@ResignationApprovedId) + '''
		  	   	  AND ER.InactiveDateTime IS NULL
            '
            PRINT @SqlQuery
            
            EXECUTE(@SqlQuery)

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


--SELECT RunDate,SUM(ActualComponentAmount) AS Total
--FROM #EmployeepayrollDetail
--WHERE IsDeduction = 0
--GROUP BY RunDate