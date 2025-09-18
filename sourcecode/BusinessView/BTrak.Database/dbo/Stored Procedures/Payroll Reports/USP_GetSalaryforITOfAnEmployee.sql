-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Salary for IT Of An Employee
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetSalaryforITOfAnEmployee] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetSalaryforITOfAnEmployee]
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
			
			DECLARE @PayrollComponentsList NVARCHAR(MAX)
            
			IF(@IsActiveEmployeesOnly IS NULL) SET @IsActiveEmployeesOnly = 0
			
			IF(@Date IS NULL) SET @Date = GETDATE()
            
			IF(@SearchText = '') SET @SearchText = NULL

            SET @SearchText = '%' + @SearchText + '%'

			DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee E WHERE E.UserId = ISNULL(@UserId,@OperationsPerformedBy))

			DECLARE @YearStartDate DATETIME = NULL, @YearEndDate DATETIME = NULL
            
            DECLARE @FromMonth INT,@ToMonth INT,@FromYear INT,@ToYear INT,@Year INT = DATEPART(YEAR,@Date),@Month INT = DATEPART(MONTH,@Date),@TaxYear INT

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
		    SELECT @TaxYear = CASE WHEN @Month - @FromMonth >= 0 THEN @Year ELSE @Year - 1 END
            
		    SELECT @YearStartDate = DATEFROMPARTS(@FromYear,@FromMonth,1), @YearEndDate = EOMONTH(DATEFROMPARTS(@ToYear,@ToMonth,1))

			IF(@YearStartDate IS NULL OR @YearEndDate IS NULL)
			BEGIN
				
				SET @YearStartDate = DATEFROMPARTS(DATEPART(YEAR,@Date),1,1)
				
				SET @YearEndDate = DATEFROMPARTS(DATEPART(YEAR,@Date),12,1)

			END

            SELECT * 
            INTO #TaxAllowanes
            FROM dbo.[Ufn_GetEmployeeTaxDetails](@EmployeeId,@TaxYear,@YearStartDate,@YearEndDate)

			DECLARE @Sectionscount INT = ISNULL((SELECT COUNT(1) FROM #TaxAllowanes WHERE SectionName IS NOT NULL),0)

			IF(@Sectionscount > 0)
			BEGIN

				;WITH Tree AS
               (
                   SELECT TA_Parent.SectionId, TA_Parent.ParentSectionId, TA_Parent.[SectionName], [level] = 1 , Path = TA_Parent.SectionName
                   FROM #TaxAllowanes TA_Parent
                   WHERE TA_Parent.ParentSectionId IS NULL
                   UNION ALL
                   SELECT TA_Child.SectionId, TA_Child.ParentSectionId, TA_Child.[SectionName], [level] = Tree.[level] + 1 , Path = Tree.Path + '/' + TA_Child.SectionName
                   FROM #TaxAllowanes TA_Child INNER JOIN Tree ON Tree.SectionId = TA_Child.ParentSectionId
               )
			   SELECT * FROM
			   (
               SELECT TA.EmployeeId
			          ,TA.EmployeeName
					  ,U.ProfileImage
					  ,EAD.PANNumber
					  ,U.Id AS UserId
					  ,CONVERT(NVARCHAR(100),E.DateofBirth,106) AS DateofBirth
					  ,DATEDIFF(YEAR,E.DateofBirth,CAST(GETDATE() AS DATE)) AS Age
					  --,CASE WHEN ETA.IsRelatedToHRA = 1 THEN 0 ELSE TA.MaxInvestment END AS MaxInvestment
					  ,TA.MaxInvestment
					  ,CASE WHEN ISNULL(TA.MaxInvestment,TA.InvestedAmount) < TA.InvestedAmount THEN ISNULL(TA.MaxInvestment,TA.InvestedAmount) ELSE TA.InvestedAmount END AS Investment
					  ,TA.Tax
					  ,TA.NetSalary
					  ,TA.TaxableAmount
					  ,TA.Tax AS TotalTax
					  --,SUM(TA.Tax) OVER() AS TotalTax
					  ,TA.ParentSectionName
					  ,TA.SectionName
					  ,Tree.[Path]
					  ,CASE WHEN TA.ParentSectionName IS NULL THEN 1 ELSE 0 END AS IsParent
               FROM Tree Tree
			        INNER JOIN #TaxAllowanes TA ON TA.SectionId = Tree.SectionId
					INNER JOIN Employee E ON E.Id = TA.EmployeeId
					INNER JOIN [User] U ON U.Id = E.UserId
					INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
             	               AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
             	               AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))  
					LEFT JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = TA.EmployeeId
					          AND EAD.InActiveDateTime IS NULL
					--LEFT JOIN EmployeeTaxAllowances ETA ON ETA.TaxAllowanceId = TA.SectionId
               WHERE U.CompanyId = @CompanyId
                  AND (@UserId IS NULL OR U.Id = @UserId)
			      AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
                  AND (@IsActiveEmployeesOnly = 0 
			           OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
			   ) T
			   WHERE (@SearchText IS NULL
                          OR (EmployeeName LIKE @SearchText)
                          OR (PANNumber LIKE @SearchText)
                          OR (ParentSectionName LIKE @SearchText)
                          OR (SectionName LIKE @SearchText)
                          OR (DateofBirth LIKE @SearchText)
                          OR (Age LIKE @SearchText)
                          OR (MaxInvestment LIKE @SearchText)
                          OR (Investment LIKE @SearchText)
                          OR (Tax LIKE @SearchText)
                          OR (NetSalary LIKE @SearchText)
                          OR (TaxableAmount LIKE @SearchText)
                          OR (TotalTax LIKE @SearchText)
                         )
			   ORDER BY [Path]
			END
			ELSE 
			BEGIN
				
				SELECT TA.EmployeeId
			          ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS EmployeeName
					  ,U.ProfileImage
					  ,EAD.PANNumber
					  ,U.Id AS UserId
					  ,CONVERT(NVARCHAR(100),E.DateofBirth,106) AS DateofBirth
					  ,DATEDIFF(YEAR,E.DateofBirth,CAST(GETDATE() AS DATE)) AS Age
					  ,TA.MaxInvestment
					  ,TA.Investment
					  ,TA.Tax
					  ,TA.NetSalary
					  ,TA.TaxableAmount
					  ,TA.Tax AS TotalTax
					  --,SUM(TA.Tax) OVER() AS TotalTax
					  ,TA.ParentSectionName
					  ,TA.SectionName
					  ,CASE WHEN TA.ParentSectionName IS NULL THEN 1 ELSE 0 END AS IsParent
				FROM #TaxAllowanes TA
					 INNER JOIN Employee E ON E.Id = TA.EmployeeId
					 INNER JOIN [User] U ON U.Id = E.UserId
					 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
             	                AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
             	                AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))  
					 LEFT JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = TA.EmployeeId
					           AND EAD.InActiveDateTime IS NULL
                WHERE U.CompanyId = @CompanyId
                  AND (@UserId IS NULL OR U.Id = @UserId)
			      AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
                  AND (@IsActiveEmployeesOnly = 0 
			           OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))

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