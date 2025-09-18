-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get ESI Monthly Statement
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetESIMonthlyStatement] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetESIMonthlyStatement]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@Date DATETIME = NULL
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
            
           	IF(@Date IS NULL) SET @Date = GETDATE()
	        
			DECLARE @RunMonth NVARCHAR(100) = (SELECT DATENAME(MONTH,@Date) + ' ' + DATENAME(YEAR,@Date))
            
            IF(@SearchText = '') SET @SearchText = NULL

            SET @SearchText = '%' + @SearchText + '%'

            CREATE TABLE #ESIDetails 
            (
                ComponentName NVARCHAR(250)
                ,ComponentId UNIQUEIDENTIFIER
                ,EmployeeId UNIQUEIDENTIFIER
                ,EmployeeSalary DECIMAL(18,2)
                ,BranchId UNIQUEIDENTIFIER
		        ,BranchName NVARCHAR(250)
                ,EmployeeContribusion DECIMAL(18,2)
                ,EmployeerContribusion DECIMAL(18,2)
                ,TotalContribution DECIMAL(18,2)
                ,PayrollRunId UNIQUEIDENTIFIER
            )
            
            INSERT INTO #ESIDetails(ComponentName,ComponentId,EmployeeId,EmployeeSalary,BranchId,BranchName,PayrollRunId)
            SELECT PC.ComponentName
                   ,PREC.ComponentId
            	,PRE.EmployeeId
            	,PRE.EmployeeSalary
            	,EB.BranchId
			    ,B.BranchName
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
                  	            AND PREC.PayrollRunId = PRE.PayrollRunId
            	 INNER JOIN PayrollComponent PC ON PREC.ComponentId = PC.Id
                  				AND PC.ComponentName = 'ESI'
				 INNER JOIN Branch B ON B.Id = EB.BranchId --TODO
             WHERE U.CompanyId = @CompanyId
				   AND (@IsActiveEmployeesOnly = 0 
				     OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
				   AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
				   AND (@UserId IS NULL OR @UserId = U.Id)
             GROUP BY PC.ComponentName,PREC.ComponentId,PRE.EmployeeId,PRE.EmployeeSalary,EB.BranchId,B.BranchName,PRE.PayrollRunId

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
            
            UPDATE #ESIDetails SET TotalContribution = ISNULL(ED.EmployeeContribusion,0) + ISNULL(ED.EmployeerContribusion,0)
            FROM #ESIDetails ED

            SELECT * 
                   ,COUNT(1) OVER() AS TotalRecordsCount
            FROM 
            (
                SELECT ED.EmployeeId
                       ,E.EmployeeNumber
                       ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS EmployeeName
                       ,U.ProfileImage
                       ,U.Id AS UserId
                       ,CASE WHEN U.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
                       ,ED.BranchName
                       ,EAD.ESINumber
                       ,ED.EmployeeSalary AS ESIGross
                       ,ED.EmployeeContribusion
                       ,ED.EmployeerContribusion
                       ,ED.TotalContribution
            	       ,SUM(EmployeeSalary) OVER() AS ESIGrossGrandTotal
            		   ,SUM(EmployeeContribusion) OVER()  AS EmployeeContributionGrandTotal
            		   ,SUM(EmployeerContribusion) OVER() AS EmployeerContributionGrandTotal
            		   ,SUM(TotalContribution) OVER() AS TotalContributionGrandTotal
                       ,Branch.ESIGrossByBranch
                       ,Branch.EmployeeContributionByBranch
                       ,Branch.EmployeerContributionByBranch
                       ,Branch.TotalContributionByBranch
            	FROM #ESIDetails ED
                     INNER JOIN Employee E ON E.Id = ED.EmployeeId
                     INNER JOIN [User] U ON U.Id = E.UserId
	                 LEFT JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = ED.EmployeeId
			          AND EAD.InActiveDateTime IS NULL
            	INNER JOIN  (
                SELECT BranchId
            	       ,SUM(EmployeeSalary) AS ESIGrossByBranch
            		   ,SUM(EmployeeContribusion) AS EmployeeContributionByBranch
            		   ,SUM(EmployeerContribusion) AS EmployeerContributionByBranch
            		   ,SUM(TotalContribution) AS TotalContributionByBranch
            	FROM #ESIDetails
            	GROUP BY BranchId
            	) Branch ON Branch.BranchId = ED.BranchId
            ) T
             WHERE (@SearchText IS NULL
                          OR (EmployeeNumber LIKE @SearchText)
                          OR (EmployeeName LIKE @SearchText)
                          OR (BranchName LIKE @SearchText)
                          OR (ESINumber LIKE @SearchText)
                          OR (ESIGross LIKE @SearchText)
                          OR (EmployeeContribusion LIKE @SearchText)
                          OR (EmployeerContribusion LIKE @SearchText)
                          OR (TotalContribution LIKE @SearchText)
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