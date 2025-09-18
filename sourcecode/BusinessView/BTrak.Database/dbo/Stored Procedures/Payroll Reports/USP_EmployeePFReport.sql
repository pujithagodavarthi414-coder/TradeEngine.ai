------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Employee PF Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_EmployeePFReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_EmployeePFReport]
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
			
			IF(@IsActiveEmployeesOnly IS NULL) SET @IsActiveEmployeesOnly = 0
            
			IF(@Date IS NULL) SET @Date = GETDATE()

			IF(@PageNo IS NULL OR @PageNo = 0) SET @PageNo = 1

            IF(@PageSize IS NULL OR @PageSize = 0) SET @PageSize = 30000 --2147483647 -- INTEGER MAX NUMBER 

            IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'

            IF(@SearchText = '') SET @SearchText = NULL
            
            SET @SearchText = '%' + @SearchText + '%'

            IF(@SortBy IS NULL) SET @SortBy = 'Employeename'
			
            DECLARE @PFDetails TABLE
            (
            	UANNumber NVARCHAR(50),
            	Employeename NVARCHAR(250),
            	EmployeeId UNIQUEIDENTIFIER,
            	UserId UNIQUEIDENTIFIER,
            	LOPDays INT,
            	TotalWages FLOAT,
            	GrossWages FLOAT,
            	PFContribution FLOAT,
            	PFDependentId UNIQUEIDENTIFIER,
            	EPSContribution FLOAT,
            	PFANDPSDifference FlOAT,
            	PayrollRunId UNIQUEIDENTIFIER
            )
            
            INSERT INTO @PFDetails(Employeename,EmployeeId,UserId,LOPDays,TotalWages,PFDependentId,PayrollRunId,PFContribution)
            SELECT PRE.EmployeeName,E.Id,E.UserId,PRE.LossOfPay,PRE.EmployeeSalary,PTC.DependentPayrollComponentId,PRE.PayrollRunId,SUM(ABS(ActualComponentAmount))
            FROM PayrollRunEmployee PRE 
            INNER JOIN (SELECT EmployeeId
               		            ,MAX(RunDate) AS RunDate
               		     FROM PayrollRun PR
						      INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							  INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
               		          INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
               		     WHERE DATENAME(YEAR,PR.PayrollEndDate) = DATENAME(YEAR,@Date)
               		         AND DATENAME(MONTH,PR.PayrollEndDate) = DATENAME(MONTH,@Date)
               		         AND PR.InactiveDateTime IS NULL
               		         AND PRE.InactiveDateTime IS NULL
               		         AND PR.CompanyId = @CompanyId
               		     GROUP BY EmployeeId,DATENAME(MONTH,PR.PayrollEndDate), DATENAME(YEAR,PR.PayrollEndDate)
               		     		) RE ON RE.EmployeeId = PRE.EmployeeId
                           AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)				 
                           AND (PRE.IsInResignation IS NULL OR PRE.IsInResignation = 0)
                INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId AND RE.RunDate = PR.RunDate
                           AND PR.CompanyId = @CompanyId
            	INNER JOIN Employee E ON E.Id = PRE.EmployeeId
            	INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = E.Id AND EPC.InActiveDateTime IS NULL
            					            AND ( (EPC.ActiveTo IS NOT NULL AND PR.PayrollEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo AND PR.PayrollEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo)
            				  		            OR (EPC.ActiveTo IS NULL AND PR.PayrollEndDate >= EPC.ActiveFrom)
            									OR (EPC.ActiveTo IS NOT NULL AND PR.PayrollStartDate <= EPC.ActiveTo AND PR.PayrollStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EPC.ActiveFrom), 0))
            				  			     )
            	INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = EPC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL
                INNER JOIN PayrollComponent PC ON PTC.PayrollComponentId = PC.Id
                    				AND PC.ComponentName = 'PF'
            	INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = PRE.EmployeeId AND PREC.PayrollRunId = PRE.PayrollRunId AND PREC.ComponentId = PC.Id
                INNER JOIN [User] U ON U.Id = E.UserId
                INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
                                AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                        	    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
            WHERE U.CompanyId = @CompanyId
                  AND (@IsActiveEmployeesOnly = 0 
	        		    OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
	        	  AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
	        	  AND (@UserId IS NULL OR @UserId = U.Id)
            GROUP BY PRE.EmployeeName,E.Id,E.UserId,PRE.LossOfPay,PRE.EmployeeSalary,PTC.DependentPayrollComponentId,PRE.PayrollRunId
            
            UPDATE @PFDetails SET GrossWages = PREC.ActualComponentAmount
            FROM @PFDetails PD 
                 INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = PD.EmployeeId 
                            AND PREC.PayrollRunId = PD.PayrollRunId AND PREC.ComponentId = PD.PFDependentId
            
			UPDATE @PFDetails SET PFContribution = GrossWages*0.12

            UPDATE @PFDetails SET EPSContribution = ROUND(PFContribution * 0.833,2)
            
            UPDATE @PFDetails SET PFANDPSDifference = PFContribution - EPSContribution
            
            UPDATE @PFDetails SET UANNumber = EAD.UANNumber
            FROM @PFDetails PD INNER JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = PD.EmployeeId AND EAD.InActiveDateTime IS NULL
            
            SELECT * 
                  ,COUNT(1) OVER() AS TotalRecordsCount
            FROM
            (
            SELECT UANNumber,Employeename,U.ProfileImage,TotalWages AS GrossWages,GrossWages AS EPFWages
                   ,CASE WHEN GrossWages > 15000 THEN 15000 ELSE GrossWages END AS EPSWages
                   ,CASE WHEN GrossWages > 15000 THEN 15000 ELSE GrossWages END AS EDLIWages
            	   ,PFContribution AS EPFContribution
            	   ,EPSContribution
            	   ,PFANDPSDifference AS EPFANDPSDifference
            	   ,LOPDays AS NCPDays
            	   ,0 AS RefundOfAdvance
                   ,CASE WHEN U.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
                   ,UserId
            FROM @PFDetails PD
            LEFT JOIN [User] U ON U.Id = PD.UserId
            ) T
            WHERE (@SearchText IS NULL OR (UANNumber LIKE @SearchText)
			        OR (Employeename LIKE @SearchText)
			        OR (GrossWages LIKE @SearchText)
			        OR (EPFWages LIKE @SearchText)
			        OR (EPSWages LIKE @SearchText)
			        OR (EDLIWages LIKE @SearchText)
			        OR (EPFContribution LIKE @SearchText)
			        OR (EPSContribution LIKE @SearchText)
			        OR (EPFANDPSDifference LIKE @SearchText)
			        OR (NCPDays LIKE @SearchText)
			        OR (RefundOfAdvance LIKE @SearchText)
			   )
		 ORDER BY       
              CASE WHEN (@SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'UANNumber') THEN UANNumber
                              WHEN(@SortBy = 'Employeename') THEN Employeename
                              WHEN(@SortBy = 'GrossWages') THEN CAST(GrossWages AS SQL_VARIANT)
                              WHEN(@SortBy = 'EPFWages') THEN CAST(EPFWages AS SQL_VARIANT)
                              WHEN(@SortBy = 'EPSWages') THEN CAST(EPSWages AS SQL_VARIANT)
                              WHEN(@SortBy = 'EDLIWages') THEN CAST(EDLIWages AS SQL_VARIANT)
                              WHEN(@SortBy = 'EPFContribution') THEN CAST(EPFContribution AS SQL_VARIANT)
                              WHEN(@SortBy = 'EPSContribution') THEN CAST(EPSContribution AS SQL_VARIANT)
                              WHEN(@SortBy = 'EPFANDPSDifference') THEN CAST(EPFANDPSDifference AS SQL_VARIANT)
                              WHEN(@SortBy = 'NCPDays') THEN CAST(NCPDays AS SQL_VARIANT)
                              WHEN(@SortBy = 'RefundOfAdvance') THEN CAST(RefundOfAdvance AS SQL_VARIANT)
                          END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                           CASE WHEN(@SortBy = 'UANNumber') THEN UANNumber
                              WHEN(@SortBy = 'Employeename') THEN Employeename
                              WHEN(@SortBy = 'GrossWages') THEN CAST(GrossWages AS SQL_VARIANT)
                              WHEN(@SortBy = 'EPFWages') THEN CAST(EPFWages AS SQL_VARIANT)
                              WHEN(@SortBy = 'EPSWages') THEN CAST(EPSWages AS SQL_VARIANT)
                              WHEN(@SortBy = 'EDLIWages') THEN CAST(EDLIWages AS SQL_VARIANT)
                              WHEN(@SortBy = 'EPFContribution') THEN CAST(EPFContribution AS SQL_VARIANT)
                              WHEN(@SortBy = 'EPSContribution') THEN CAST(EPSContribution AS SQL_VARIANT)
                              WHEN(@SortBy = 'EPFANDPSDifference') THEN CAST(EPFANDPSDifference AS SQL_VARIANT)
                              WHEN(@SortBy = 'NCPDays') THEN CAST(NCPDays AS SQL_VARIANT)
                              WHEN(@SortBy = 'RefundOfAdvance') THEN CAST(RefundOfAdvance AS SQL_VARIANT)
                          END
                      END DESC
          OFFSET ((@PageNo - 1) * @PageSize) ROWS
          FETCH NEXT @PageSize ROWS ONLY

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