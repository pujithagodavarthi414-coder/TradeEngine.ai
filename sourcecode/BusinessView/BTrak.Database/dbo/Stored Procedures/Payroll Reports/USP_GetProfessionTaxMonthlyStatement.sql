-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Profession Tax Monthly Statement
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetProfessionTaxMonthlyStatement] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetProfessionTaxMonthlyStatement]
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
			
			IF(@PageNo IS NULL OR @PageNo = 0) SET @PageNo = 1

            IF(@PageSize IS NULL OR @PageSize = 0) SET @PageSize = 30000 --2147483647 -- INTEGER MAX NUMBER 

            IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'

            IF(@SearchText = '') SET @SearchText = NULL

            IF(@SortBy IS NULL) SET @SortBy = 'EmployeeName'

            SET @SearchText = '%' + @SearchText + '%'

			CREATE TABLE #ProfessionTaxReturnDetails 
			(
				EmployeeId UNIQUEIDENTIFIER
				,ActualComponentAmount DECIMAL(18,2)
				,ProfileImage NVARCHAR(1000)
				,UserId UNIQUEIDENTIFIER
				,EmployeeName NVARCHAR(500)
	            ,EmployeeNumber NVARCHAR(100)
				,ProfBasic DECIMAL(18,2)
				,RangeText NVARCHAR(100)
				,IsArchived BIT
			)
			
			INSERT INTO #ProfessionTaxReturnDetails(EmployeeId,EmployeeName,ProfileImage,UserId,EmployeeNumber,ActualComponentAmount,ProfBasic,RangeText,IsArchived)
			SELECT EmployeeId,EmployeeName,ProfileImage,UserId,EmployeeNumber,ActualComponentAmount,ActualEarning,RangeText,IsArchived
			FROM
			(
			SELECT E.Id EmployeeId
					   ,ABS(PREC.ActualComponentAmount) ActualComponentAmount
					   ,PRE.ActualEarning
					   ,PRE.EmployeeName
					   ,U.ProfileImage
                       ,CASE WHEN U.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
					   ,U.Id AS UserId
					   ,E.EmployeeNumber
					   ,EB.BranchId
				FROM Employee E
				INNER JOIN [User] U ON U.Id = E.UserId
				INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                       AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	               	       AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
				INNER JOIN (SELECT EmployeeId
							       ,MAX(RunDate) AS RunDate
							FROM PayrollRun PR
							     INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
							     INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
							     INNER JOIN PayrollRunEmployee PRE ON PRE.PayrollRunId = PR.Id
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
					 INNER JOIN EmployeepayrollConfiguration EPC ON EPC.EmployeeId = E.Id AND EPC.InActiveDateTime IS NULL --AND EPC.IsApproved = 1
					            AND ( (EPC.ActiveTo IS NOT NULL AND PR.PayrollEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo AND PR.PayrollEndDate BETWEEN EPC.ActiveFrom AND EPC.ActiveTo)
				  		            OR (EPC.ActiveTo IS NULL AND PR.PayrollEndDate >= EPC.ActiveFrom)
									OR (EPC.ActiveTo IS NOT NULL AND PR.PayrollStartDate <= EPC.ActiveTo AND PR.PayrollStartDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, EPC.ActiveFrom), 0))
				  			     )
					 INNER JOIN PayrollTemplateConfiguration PTC ON PTC.PayrollTemplateId = EPC.PayrollTemplateId AND PTC.InActiveDateTime IS NULL AND PTC.IsRelatedToPT = 1
					 INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.ComponentId = PTC.PayrollComponentId AND PREC.EmployeeId = PRE.EmployeeId AND PREC.PayrollRunId = PR.Id
				WHERE U.CompanyId = @CompanyId
				       AND (@UserId IS NULL OR U.Id = @UserId)
				       AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
                       AND (@IsActiveEmployeesOnly = 0 
				            OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
				      AND PTC.IsRelatedToPT = 1
			) T 
			INNER JOIN (SELECT FromRange,ToRange,TaxAmount,BranchId
			       ,CASE WHEN FromRange IS NULL THEN 'Upto ' + CONVERT(NVARCHAR(100),CONVERT(FLOAT,ToRange))
				         WHEN ToRange IS NULL THEN 'Above ' + CONVERT(NVARCHAR(100),CONVERT(FLOAT,FromRange))
						 ELSE CONVERT(NVARCHAR(100),CONVERT(FLOAT,FromRange)) + ' to ' + CONVERT(NVARCHAR(100),CONVERT(FLOAT,ToRange))
					END AS RangeText
			FROM [dbo].[ProfessionalTaxRange]
			WHERE (IsArchived IS NULL OR IsArchived = 0)
			       AND ( (ActiveTo IS NOT NULL AND @Date BETWEEN ActiveFrom AND ActiveTo)
			                OR (ActiveTo IS NULL AND @Date >= ActiveFrom)
				            OR (ActiveTo IS NOT NULL AND @Date <= ActiveTo AND @Date >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			              )
			GROUP BY FromRange,ToRange,TaxAmount,BranchId) PT ON (PT.FromRange IS NULL OR ActualEarning >= PT.FromRange) 
			        AND (PT.ToRange IS NULL OR ActualEarning <= PT.ToRange)
					AND PT.BranchId = T.BranchId
			
            DECLARE @RecordsCount INT = (SELECT COUNT(1) FROM #ProfessionTaxReturnDetails)

			DECLARE @Summary NVARCHAR(MAX) = NULL

			IF(@RecordsCount > 0)
			BEGIN

			   SELECT @Summary = (
				SELECT RangeText,NoOfEmployee,TotalTax 
				FROM
				(
				SELECT RangeText
				       ,COUNT(EmployeeId) AS NoOfEmployee
					   ,SUM(ActualComponentAmount) TotalTax
				FROM #ProfessionTaxReturnDetails
				WHERE (@SearchText IS NULL
                          OR (EmployeeNumber LIKE @SearchText)
                          OR (EmployeeName LIKE @SearchText)
                          OR (ProfBasic LIKE @SearchText)
                          OR (ActualComponentAmount LIKE @SearchText)
						)
				GROUP BY RangeText
				) T 
				FOR JSON PATH
				)

				SELECT EmployeeNumber
				       ,EmployeeName
					   ,ProfileImage
					   ,IsArchived
					   ,UserId
					   ,ProfBasic
					   ,ActualComponentAmount AS Amount
					   ,@Summary AS SummaryJson
					   ,COUNT(1) OVER() AS TotalCount
				FROM #ProfessionTaxReturnDetails
				WHERE (@SearchText IS NULL
                          OR (EmployeeNumber LIKE @SearchText)
                          OR (EmployeeName LIKE @SearchText)
                          OR (ProfBasic LIKE @SearchText)
                          OR (ActualComponentAmount LIKE @SearchText)
                         )
               ORDER BY       
                    CASE WHEN (@SortDirection = 'ASC') THEN
                               CASE WHEN(@SortBy = 'EmployeeNumber') THEN EmployeeNumber
                                    WHEN(@SortBy = 'EmployeeName') THEN  EmployeeName
                                    WHEN(@SortBy = 'ProfBasic') THEN CAST(ProfBasic AS SQL_VARIANT)
                                    WHEN(@SortBy = 'Amount') THEN CAST(ActualComponentAmount AS SQL_VARIANT)
                                END
                            END ASC,
                            CASE WHEN @SortDirection = 'DESC' THEN
                                 CASE WHEN(@SortBy = 'EmployeeNumber') THEN EmployeeNumber
                                    WHEN(@SortBy = 'EmployeeName') THEN  EmployeeName
                                    WHEN(@SortBy = 'ProfBasic') THEN CAST(ProfBasic AS SQL_VARIANT)
                                    WHEN(@SortBy = 'Amount') THEN CAST(ActualComponentAmount AS SQL_VARIANT)
                                END
                            END DESC
                OFFSET ((@PageNo - 1) * @PageSize) ROWS
                FETCH NEXT @PageSize ROWS ONLY

			END

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