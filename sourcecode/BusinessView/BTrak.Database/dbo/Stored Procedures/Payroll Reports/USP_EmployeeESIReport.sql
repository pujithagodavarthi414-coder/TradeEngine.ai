------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Employee ESI Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_EmployeeESIReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_EmployeeESIReport]
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

            IF(@SortBy IS NULL) SET @SortBy = 'IPName'
			
            DECLARE @PreviousMonth DATETIME = DATEADD(MONTH,-1,@Date)
            
            DECLARE @ResignationApprovedId UNIQUEIDENTIFIER = (SELECT Id FROM ResignationStatus RS 
            			                                                   WHERE RS.IsApproved = 1 AND RS.StatusName = 'Approved'
            															         AND RS.InactiveDateTime IS NULL)
            
            CREATE TABLE #ESiDetails 
            (
            	IPNumber NVARCHAR(50),
            	IPName NVARCHAR(250),
            	EmployeeId UNIQUEIDENTIFIER,
            	UserId UNIQUEIDENTIFIER,
            	EffectiveDays INT,
            	TotalWages Float,
            	ReasonCode INT,
            	LastWorkingDay NVARCHAR(50)
            )
            
            INSERT INTO #ESiDetails(IPNumber,IPName,EmployeeId,UserId,EffectiveDays,TotalWages)
            SELECT E.IPNumber,PRE.EmployeeName,E.Id,E.UserId,CEILING(PRE.EffectiveWorkingDays),PRE.EmployeeSalary
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
                           --AND (PRE.IsInResignation IS NULL OR PRE.IsInResignation = 0)
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
                    				AND PC.ComponentName = 'ESI'
                INNER JOIN [User] U ON U.Id = E.UserId
                INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
                                AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                        	    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
            WHERE U.CompanyId = @CompanyId
                  AND (@IsActiveEmployeesOnly = 0 
	        		    OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
	        	  AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
	        	  AND (@UserId IS NULL OR @UserId = U.Id)

            UPDATE #ESiDetails SET ReasonCode = 0 WHERE EffectiveDays > 0
            
            UPDATE #ESiDetails SET ReasonCode = 1 
            FROM #ESiDetails ED 
                 INNER JOIN LeaveApplication LA ON LA.UserId = ED.UserId
            	            AND LA.InActiveDateTime IS NULL
                            AND LeaveDateFrom <= DATEADD(DAY,1,EOMONTH(GETDATE(),-1))
                            AND LeaveDateTo >= EOMONTH(GETDATE())
            WHERE ED.EffectiveDays = 0
            
            UPDATE #ESiDetails SET ReasonCode = 2,LastWorkingDay =  CASE WHEN EffectiveDays = 0 THEN CONVERT(VARCHAR,ER.LastDate,103)
                                                                         ELSE NULL END
            FROM #ESiDetails ED 
            INNER JOIN EmployeeResignation ER ON ER.EmployeeId = ED.EmployeeId
                       AND ER.ResignationStastusId = @ResignationApprovedId 
            --WHERE ER.Id IS NOT NULL
            
            INSERT INTO #ESiDetails(IPNumber,IPName,EmployeeId,UserId,EffectiveDays,TotalWages,ReasonCode,LastWorkingDay)
            SELECT E.IPNumber,PRE.EmployeeName,E.Id,E.UserId,CEILING(PRE.EffectiveWorkingDays),PRE.EmployeeSalary,4,CONVERT(VARCHAR,EOMONTH(@Date,-1),103)
            FROM PayrollRunEmployee PRE 
            INNER JOIN (SELECT EmployeeId
               		            ,MAX(RunDate) AS RunDate
               		     FROM PayrollRun PR
               		          INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
               		     WHERE DATENAME(YEAR,PR.PayrollEndDate) = DATENAME(YEAR,@PreviousMonth)
               		         AND DATENAME(MONTH,PR.PayrollEndDate) = DATENAME(MONTH,@PreviousMonth)
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
                    				AND PC.ComponentName = 'ESI'
                INNER JOIN [User] U ON U.Id = E.UserId
                INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
                                AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                        	    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
            WHERE PRE.EmployeeId NOT IN (SELECT EmployeeId FROM #ESiDetails)
                  AND U.CompanyId = @CompanyId
                  AND (@IsActiveEmployeesOnly = 0 
	        		    OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
	        		  AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
	        		  AND (@UserId IS NULL OR @UserId = U.Id)

            SELECT IPNumber,IPName,U.ProfileImage,EffectiveDays,TotalWages,ReasonCode,LastWorkingDay,UserId
                   ,CASE WHEN U.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
                  ,COUNT(1) OVER() AS TotalRecordsCount
            FROM #ESiDetails ED
            LEFT JOIN [User] U ON U.Id = ED.UserId
            WHERE (@SearchText IS NULL OR (IPNumber LIKE @SearchText)
			        OR (IPName LIKE @SearchText)
			        OR (EffectiveDays LIKE @SearchText)
			        OR (TotalWages LIKE @SearchText)
			        OR (ReasonCode LIKE @SearchText)
			        OR (LastWorkingDay LIKE @SearchText)
			   )
		 ORDER BY       
              CASE WHEN (@SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'IPNumber') THEN IPNumber
                              WHEN(@SortBy = 'IPName') THEN IPName
                              WHEN(@SortBy = 'EffectiveDays') THEN CAST(EffectiveDays AS SQL_VARIANT)
                              WHEN(@SortBy = 'TotalWages') THEN CAST(TotalWages AS SQL_VARIANT)
                              WHEN(@SortBy = 'ReasonCode') THEN CAST(ReasonCode AS SQL_VARIANT)
                              WHEN(@SortBy = 'LastWorkingDay') THEN CAST(LastWorkingDay AS SQL_VARIANT)
                          END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                           CASE WHEN(@SortBy = 'IPNumber') THEN IPNumber
                              WHEN(@SortBy = 'IPName') THEN IPName
                              WHEN(@SortBy = 'EffectiveDays') THEN CAST(EffectiveDays AS SQL_VARIANT)
                              WHEN(@SortBy = 'TotalWages') THEN CAST(TotalWages AS SQL_VARIANT)
                              WHEN(@SortBy = 'ReasonCode') THEN CAST(ReasonCode AS SQL_VARIANT)
                              WHEN(@SortBy = 'LastWorkingDay') THEN CAST(LastWorkingDay AS SQL_VARIANT)
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