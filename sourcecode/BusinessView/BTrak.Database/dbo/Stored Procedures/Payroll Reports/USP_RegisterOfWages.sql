-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Register Of Wages
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_RegisterOfWages] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_RegisterOfWages]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@Date DATETIME = NULL --Month Filter
	,@EntityId UNIQUEIDENTIFIER = NULL
	,@UserId UNIQUEIDENTIFIER = NULL
	,@IsActiveEmployeesOnly BIT = 0
	,@PageNo INT = 1
    ,@SortDirection NVARCHAR(250) = NULL
    ,@SortBy NVARCHAR(250) = NULL
    ,@PageSize INT = NULL
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
            
			DECLARE @YearStartDate DATETIME = NULL, @YearEndDate DATETIME = NULL
			
			IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
			
			IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
           	
			IF(@Date IS NULL) SET @Date = GETDATE()
			
			IF(@PageNo IS NULL OR @PageNo = 0) SET @PageNo = 1

            IF(@PageSize IS NULL OR @PageSize = 0) SET @PageSize = 30000 --2147483647 -- INTEGER MAX NUMBER 

            IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'

            IF(@SearchText = '') SET @SearchText = NULL

            IF(@SortBy IS NULL) SET @SortBy = 'EmployeeName'

            SET @SearchText = '%' + @SearchText + '%'

			DECLARE @PayrollPaidStatus UNIQUEIDENTIFIER = (SELECT Id FROM PayrollStatus WHERE InactiveDateTime IS NULL AND CompanyId = @CompanyId AND PayrollStatusName = 'Paid')

			IF(@IsActiveEmployeesOnly IS NULL) SET @IsActiveEmployeesOnly = 0
			 
			SELECT EmployeeNumber
			       ,EmployeeName
				   ,ProfileImage
				   ,UserId
				   ,IsArchived
				   ,JoinedDate
				   ,EmployeeSalary
				   ,ActualEmployeeSalary
				   ,ActualDeduction
				   ,ActualPaidAmount
				   ,DateOfPayment
                  ,COUNT(1) OVER() AS TotalRecordsCount
			FROM
			(
				SELECT E.EmployeeNumber
					   ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS EmployeeName
					   ,U.ProfileImage
					   ,U.Id AS UserId
                       ,CASE WHEN U.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
					   ,CONVERT(VARCHAR,J.JoinedDate,106) AS JoinedDate
					   ,J.JoinedDate AS JoinedDateValue
					   ,PRE.EmployeeSalary
					   ,PRE.ActualEarning AS ActualEmployeeSalary
					   ,ABS(PRE.ActualDeduction) AS ActualDeduction
					   ,PRE.ActualPaidAmount
					   ,CONVERT(VARCHAR,PRS.StatusChangeDateTime,106) AS DateOfPayment
					   ,PRS.StatusChangeDateTime
				FROM Employee E
				     INNER JOIN [User] U ON U.Id = E.UserId
					 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                                AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                        	    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
					 INNER JOIN (SELECT EmployeeId
							            ,MAX(RunDate) AS RunDate
							     FROM PayrollRun PR
							          INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
									  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							          INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
							     WHERE DATENAME(YEAR,PR.PayrollEndDate) = DATENAME(YEAR,@Date)
							         AND DATENAME(MONTH,PR.PayrollEndDate) = DATENAME(MONTH,@Date)
							         --AND PRE.PayrollStatusId <> @RejectStatusId
							         AND PR.InactiveDateTime IS NULL
							         AND PRE.InactiveDateTime IS NULL
							         AND PR.CompanyId = @CompanyId
							     GROUP BY EmployeeId,DATENAME(MONTH,PR.PayrollEndDate), DATENAME(YEAR,PR.PayrollEndDate)
							     		) RE ON RE.EmployeeId = E.Id
				     INNER JOIN PayrollRunEmployee PRE ON E.Id = PRE.EmployeeId
					            AND (PRE.IsHold IS NULL OR PRE.IsHold = 0)				 
                                AND (PRE.IsInResignation IS NULL OR PRE.IsInResignation = 0)
			         INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId AND RE.RunDate = PR.RunDate
					            AND PR.CompanyId = @CompanyId
					 LEFT JOIN Job J ON J.EmployeeId = E.Id
			                   AND J.InActiveDateTime IS NULL
					 LEFT JOIN (SELECT PayrollRunId,MAX(CreatedDateTime) AS StatusChangeDateTime
					            FROM PayrollRunStatus
								WHERE InactiveDateTime IS NULL 
								      AND PayrollStatusId = @PayrollPaidStatus
								GROUP BY payrollRunId) PRS ON PRS.PayrollRunId = PRE.PayrollRunId
					 --LEFT JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = E.Id
			   --                AND EAD.InActiveDateTime IS NULL
			    WHERE U.CompanyId = @CompanyId
	        		  AND (@IsActiveEmployeesOnly = 0 
	        		    OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
	        		  AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
	        		  AND (@UserId IS NULL OR @UserId = U.Id)
			) T
			WHERE (@SearchText IS NULL OR (EmployeeNumber LIKE @SearchText)
			        OR (EmployeeName LIKE @SearchText)
			        OR (JoinedDate LIKE @SearchText)
			        OR (EmployeeSalary LIKE @SearchText)
			        OR (ActualEmployeeSalary LIKE @SearchText)
			        OR (ActualDeduction LIKE @SearchText)
			        OR (ActualPaidAmount LIKE @SearchText)
			        OR (DateOfPayment LIKE @SearchText)
			   )
		 ORDER BY       
              CASE WHEN (@SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'EmployeeNumber') THEN EmployeeNumber
                              WHEN(@SortBy = 'EmployeeName') THEN EmployeeName
                              WHEN(@SortBy = 'JoinedDate') THEN CAST(JoinedDateValue AS SQL_VARIANT)
                              WHEN(@SortBy = 'EmployeeSalary') THEN CAST(EmployeeSalary AS SQL_VARIANT)
                              WHEN(@SortBy = 'ActualEmployeeSalary') THEN CAST(ActualEmployeeSalary AS SQL_VARIANT)
                              WHEN(@SortBy = 'ActualDeduction') THEN CAST(ActualDeduction AS SQL_VARIANT)
                              WHEN(@SortBy = 'ActualPaidAmount') THEN CAST(ActualPaidAmount AS SQL_VARIANT)
                              WHEN(@SortBy = 'DateOfPayment') THEN CAST(DateOfPayment AS SQL_VARIANT)
                          END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                           CASE WHEN(@SortBy = 'EmployeeNumber') THEN EmployeeNumber
                              WHEN(@SortBy = 'EmployeeName') THEN EmployeeName
                              WHEN(@SortBy = 'JoinedDate') THEN CAST(JoinedDateValue AS SQL_VARIANT)
                              WHEN(@SortBy = 'EmployeeSalary') THEN CAST(EmployeeSalary AS SQL_VARIANT)
                              WHEN(@SortBy = 'ActualEmployeeSalary') THEN CAST(ActualEmployeeSalary AS SQL_VARIANT)
                              WHEN(@SortBy = 'ActualDeduction') THEN CAST(ActualDeduction AS SQL_VARIANT)
                              WHEN(@SortBy = 'ActualPaidAmount') THEN CAST(ActualPaidAmount AS SQL_VARIANT)
                              WHEN(@SortBy = 'DateOfPayment') THEN CAST(DateOfPayment AS SQL_VARIANT)
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
