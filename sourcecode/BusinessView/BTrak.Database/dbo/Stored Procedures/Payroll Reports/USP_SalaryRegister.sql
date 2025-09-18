-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Salary Register
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_SalaryRegister] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SalaryRegister]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@DateFrom DATETIME = NULL
	,@DateTo DATETIME = NULL
	,@EntityId UNIQUEIDENTIFIER = NULL
	,@UserId UNIQUEIDENTIFIER = NULL
	,@IsActiveEmployeesOnly BIT = 0
    ,@SearchText NVARCHAR(250) = NULL
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
            
            IF(@DateFrom IS NULL) SET @DateFrom = DATEADD(DAY,1,EOMONTH(GETDATE(),-3))
			
			IF(@DateTo IS NULL) SET @DateTo = EOMONTH(GETDATE())
            
            IF(@SearchText = '') SET @SearchText = NULL

            SET @SearchText = '%' + @SearchText + '%'

             DECLARE @MonthTable TABLE
             (
             	MonthValue NVARCHAR(50)
             	,MonthNumber INT
             )
             
             ;WITH MonthCte AS
             (
                 SELECT   [MonthName]    = DATENAME(MONTH ,@DateFrom)  
                         ,[MonthNumber]  = DATEPART(mm ,@DateFrom)  
                         ,[MonthYear]    = DATENAME(YEAR ,@DateFrom) 
                         ,NextRow        = DATEADD(MONTH, 1, @DateFrom) 
                 UNION ALL
                 SELECT   DATENAME(MONTH ,NextRow)
                         ,DATEPART(mm ,NextRow)
                         ,DATENAME(YEAR ,NextRow)
                         ,DATEADD(MONTH, 1, NextRow)
                 FROM    MonthCte
             	WHERE DATEPART(YEAR,NextRow) <= DATEPART(YEAR,@DateTo)
             	      AND DATEPART(MONTH,NextRow) <= DATEPART(MONTH,@DateTo)
             )
             INSERT INTO @MonthTable(MonthValue,MonthNumber)
             SELECT  [MonthName] + ' ' + CONVERT(VARCHAR,[MonthYear])
                     ,[MonthNumber]
             FROM MonthCte
             OPTION(MAXRECURSION 0)

             SELECT EmployeeNumber
                    ,EmployeeName
                    ,ProfileImage
                    ,UserId
                    ,IsArchived
                    ,JoinedDate
                    ,MonthValue
                    ,BonusAmount
                    ,[ActualNetPayAmount]
                    ,COUNT(1) OVER() AS TotalRecordsCount
             FROM
             (
               SELECT E.EmployeeNumber
                     ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS EmployeeName
                     ,U.ProfileImage
                     ,U.Id AS UserId
                       ,CASE WHEN U.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
                	   ,CONVERT(NVARCHAR,J.JoinedDate,106) AS JoinedDate
                       ,J.JoinedDate AS JoinedDateValue
                	   ,M.MonthValue
                       ,Payroll.RunDate
                	   ,ISNULL(PayRoll.BonusAmount,0) AS BonusAmount
                	   ,ISNULL(PayRoll.ActualPaidAmount,0) AS [ActualNetPayAmount] 
                FROM Employee E 
                     INNER JOIN [User] U ON U.Id = E.UserId
                	            AND U.CompanyId = @CompanyId
                     INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                          AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                  	    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
			    				--AND (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
                	   INNER JOIN @MonthTable M ON 1 = 1
                	   LEFT JOIN [Job] J ON J.EmployeeId = E.Id
                	   LEFT JOIN (SELECT RE.EmployeeId,RE.RunMonth,RE.RunDate
                                          ,PRE.ActualPaidAmount 
                                   	    ,ABS(PREC.ActualComponentAmount) BonusAmount 
                                   FROM PayrollRunEmployee PRE
                                        INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
                                                   AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)				 
                                                   AND (PRE.IsInResignation IS NULL OR PRE.IsInResignation = 0)
                                   	  INNER JOIN (SELECT PRE.EmployeeId
                                                          ,MAX(RunDate) AS RunDate
                                   				        ,PRInner.RunMonth
                                               FROM (SELECT PR.Id,PR.RunDate,DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate) AS RunMonth 
                                   			      FROM PayrollRun PR
												       INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							                           INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
                	   							       INNER JOIN @MonthTable MT ON MT.MonthValue = DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate)
                                   				  WHERE PR.InactiveDateTime IS NULL
                                   				        AND PR.CompanyId = @CompanyId) PRInner
                                                    INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PRInner.Id
                                   				            AND PRE.InactiveDateTime IS NULL
                                   				 --INNER JOIN @MonthTable MT ON MT.MonthValue = PRInner.RunMonth
                                               GROUP BY PRE.EmployeeId,PRInner.RunMonth
                                                ) RE ON RE.EmployeeId = PRE.EmployeeId AND RE.RunDate = PR.RunDate
                                   	 LEFT JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = PRE.EmployeeId 
                                   	            AND PREC.PayrollRunId = PRE.PayrollRunId
                                   				AND PREC.ComponentName = 'Bonus') PayRoll ON Payroll.EmployeeId = E.Id
                	   							AND PayRoll.RunMonth = M.MonthValue
                WHERE U.CompanyId = @CompanyId
                      AND (@UserId IS NULL OR U.Id = @UserId)
			    	    AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
                      AND (@IsActiveEmployeesOnly = 0 
			    	     OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
               ) T
                WHERE (@SearchText IS NULL
                          OR (EmployeeNumber LIKE @SearchText)
                          OR (EmployeeName LIKE @SearchText)
                          OR (MonthValue LIKE @SearchText)
                          OR (JoinedDate LIKE @SearchText)
                          OR (BonusAmount LIKE @SearchText)
                          OR (ActualNetPayAmount LIKE @SearchText)
                         )

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
