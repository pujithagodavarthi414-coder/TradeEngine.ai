-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get IT Savings Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetITSavingsReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetITSavingsReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@Year DATETIME = NULL
	,@EntityId UNIQUEIDENTIFIER = NULL
	,@UserId UNIQUEIDENTIFIER = NULL
	,@IsActiveEmployeesOnly BIT = 0
	,@IsFinantialYearBased BIT = 0
	--,@PageNo INT = 1
 --   ,@SortDirection NVARCHAR(250) = NULL
 --   ,@SortBy NVARCHAR(250) = NULL
 --   ,@PageSize INT = NULL
 --   ,@SearchText NVARCHAR(250) = NULL
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
			
			DECLARE @YearStartDate DATETIME = NULL,@YearEndDate DATETIME = NULL
			
			DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee E WHERE E.UserId = ISNULL(@UserId,@OperationsPerformedBy))
			
			IF(@Year IS NULL) SET @Year = GETDATE()

			IF(@IsFinantialYearBased = 1)
			BEGIN
				
                DECLARE @FromMonth INT,@ToMonth INT,@FromYear INT,@ToYear INT,@YearValue INT = DATEPART(YEAR,@Year),@Month INT = DATEPART(MONTH,@Year)

                SELECT @FromMonth = FromMonth, @ToMonth = ToMonth FROM [FinancialYearConfigurations] 
		        WHERE CountryId = (SELECT B.CountryId FROM EmployeeBranch EB INNER JOIN Branch B ON B.Id = EB.BranchId
					                  WHERE EB.EmployeeId = @EmployeeId AND EB.[ActiveFrom] IS NOT NULL 
									        AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE()))
                      AND InActiveDateTime IS NULL 
                      AND FinancialYearTypeId = (SELECT Id FROM FinancialYearType WHERE FinancialYearTypeName = 'Tax') --Tax Type Id
                --      AND ( (ActiveTo IS NOT NULL AND @Year BETWEEN ActiveFrom AND ActiveTo)
			             --   OR (ActiveTo IS NULL AND @Year >= ActiveFrom)
				            --OR (ActiveTo IS NOT NULL AND @Year <= ActiveTo AND @Year >= DATEADD(MONTH, DATEDIFF(MONTH, 0, ActiveFrom), 0))
			             -- )

				SELECT @FromMonth = ISNULL(@FromMonth,4), @ToMonth = ISNULL(@ToMonth,3)

		        SELECT @FromYear = CASE WHEN @Month - @FromMonth >= 0 THEN @YearValue ELSE @YearValue - 1 END
		        SELECT @ToYear = CASE WHEN @Month - @ToMonth > 0 THEN @YearValue + 1 ELSE @YearValue END
                
		        SELECT @YearStartDate = DATEFROMPARTS(@FromYear,@FromMonth,1), @YearEndDate = EOMONTH(DATEFROMPARTS(@ToYear,@ToMonth,1))
                
			END

			IF(@YearStartDate IS NULL OR @YearEndDate IS NULL)
			BEGIN
				
				SET @YearStartDate = DATEFROMPARTS(DATEPART(YEAR,@Year),1,1)
				
				SET @YearEndDate = DATEFROMPARTS(DATEPART(YEAR,@Year),12,1)

			END

			----IF(@PageNo IS NULL OR @PageNo = 0) SET @PageNo = 1

   ----         IF(@PageSize IS NULL OR @PageSize = 0) SET @PageSize = 30000 --2147483647 -- INTEGER MAX NUMBER 

   ----         IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'

   ----         IF(@SearchText = '') SET @SearchText = NULL

   ----         IF(@SortBy IS NULL) SET @SortBy = 'EmployeeName'

   ----         SET @SearchText = '%' + @SearchText + '%'

			DECLARE @ResignationApprovedId UNIQUEIDENTIFIER = (SELECT Id FROM ResignationStatus RS 
			                                                   WHERE RS.IsApproved = 1 AND RS.StatusName = 'Approved'
															         AND RS.InactiveDateTime IS NULL)
            
			--DECLARE @CurrencyCode NVARCHAR(50) = (SELECT [dbo].[Ufn_GetCurrencyCodeOfaCompany](@OperationsPerformedBy))
				
				SELECT [Employee Number]
				       ,[Employee Name]
					   ,[PAN Number]
					   ,[Rent Paid]
					   ,[Landlord PAN Number]
					   ,[Date Of Joining]
					   ,[Date Of Leaving]
					   ,[Approved Date]
				FROM
				(
           			SELECT E.EmployeeNumber AS [Employee Number]
                           ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS [Employee Name]
                    	   ,ETA.InvestedAmount AS [Rent Paid] 
						   ,ETA.OwnerPanNumber AS [Landlord PAN Number]
	           	           ,CONVERT(VARCHAR,J.JoinedDate,106) AS [Date Of Joining]
						   ,J.JoinedDate AS JoinedDateValue
						   ,EAD.PANNumber AS [PAN Number]
						   ,CONVERT(VARCHAR,ER.LastDate,106) AS [Date Of Leaving]
						   ,ER.LastDate
                    	   --,TA.[Name] AS [Section]
                    	   --,ETA.Comments AS [Comments]
                    	   --,CASE WHEN ETA.IsOnlyEmployee = 1 THEN (CASE WHEN ETA.InvestedAmount > TA.OnlyEmployeeMaxAmount 
                    	   --                                          THEN TA.OnlyEmployeeMaxAmount ELSE ETA.InvestedAmount END) 
                    	   --      ELSE (CASE WHEN ETA.InvestedAmount > TA.MaxAmount THEN TA.MaxAmount ELSE ETA.InvestedAmount END) 
                    	   -- END AS [Approved Amount]
						   ,CONVERT(NVARCHAR,ETA.ApprovedDateTime,106) AS [Approved Date]
                    FROM EmployeeTaxAllowances ETA
                         INNER JOIN TaxAllowances TA ON TA.Id = ETA.TaxAllowanceId
                    	            AND ETA.InactiveDateTime IS NULL
                    				AND TA.InactiveDateTime IS NULL
                         INNER JOIN Employee E ON E.Id = ETA.EmployeeId
                    	 INNER JOIN [User] U ON U.Id = E.UserId
						 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                                AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                	            AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
						 LEFT JOIN Job J ON J.EmployeeId = E.Id
		                           AND J.InActiveDateTime IS NULL
						 LEFT JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = E.Id
		                           AND EAD.InActiveDateTime IS NULL
						 LEFT JOIN EmployeeResignation ER ON ER.EmployeeId = E.Id
                                    AND ER.ResignationStastusId = @ResignationApprovedId
		  	   	                    AND ER.InactiveDateTime IS NULL
				  WHERE U.CompanyId = @CompanyId
				        AND ETA.ApprovedDateTime IS NOT NULL
						AND (ETA.[IsRelatedToHRA] = 1)
						--AND (ETA.[IsRelatedToHRA] = 1 OR ETA.[IsOnlyEmployee] = 1)
				        AND (@IsActiveEmployeesOnly = 0 
						     OR (E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL))
						AND (DATEPART(YEAR,ETA.ApprovedDateTime) >= DATEPART(YEAR,@YearStartDate) AND DATEPART(MONTH,ETA.ApprovedDateTime) >= DATEPART(MONTH,@YearStartDate)) 
						AND (DATEPART(YEAR,ETA.ApprovedDateTime) <= DATEPART(YEAR,@YearEndDate) AND DATEPART(MONTH,ETA.ApprovedDateTime) <= DATEPART(MONTH,@YearEndDate))
						AND (@UserId IS NULL OR @UserId = U.Id)
						AND (@EntityId IS NULL OR (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)))
			)T
			--WHERE (@SearchText IS NULL
   --                       OR (EmployeeNumber LIKE @SearchText)
   --                       OR (EmployeeName LIKE @SearchText)
   --                       OR (JoinedDate LIKE @SearchText)
   --                       OR (RentPaid LIKE @SearchText)
   --                       OR (LandlordPANNumber LIKE @SearchText)
   --                       OR (PANNumber LIKE @SearchText)
   --                       OR ([DateOfLeaving] LIKE @SearchText)
   --                      )
   --         ORDER BY       
   --                 CASE WHEN (@SortDirection = 'ASC') THEN
   --                            CASE WHEN(@SortBy = 'EmployeeNumber') THEN EmployeeNumber
   --                                 WHEN(@SortBy = 'EmployeeName') THEN  EmployeeName
   --                                 WHEN(@SortBy = 'LandlordPANNumber') THEN LandlordPANNumber
   --                                 WHEN(@SortBy = 'JoinedDate') THEN CAST(JoinedDateValue AS SQL_VARIANT)
   --                                 WHEN(@SortBy = 'RentPaid') THEN CAST(RentPaid AS SQL_VARIANT)
   --                                 WHEN(@SortBy = 'PANNumber') THEN CAST(PANNumber AS SQL_VARIANT)
   --                                 WHEN(@SortBy = 'DateOfLeaving') THEN CAST(LastDate AS SQL_VARIANT)
   --                             END
   --                         END ASC,
   --                         CASE WHEN @SortDirection = 'DESC' THEN
   --                              CASE WHEN(@SortBy = 'EmployeeNumber') THEN EmployeeNumber
   --                                 WHEN(@SortBy = 'EmployeeName') THEN  EmployeeName
   --                                 WHEN(@SortBy = 'LandlordPANNumber') THEN LandlordPANNumber
   --                                 WHEN(@SortBy = 'JoinedDate') THEN CAST(JoinedDateValue AS SQL_VARIANT)
   --                                 WHEN(@SortBy = 'RentPaid') THEN CAST(RentPaid AS SQL_VARIANT)
   --                                 WHEN(@SortBy = 'PANNumber') THEN CAST(PANNumber AS SQL_VARIANT)
   --                                 WHEN(@SortBy = 'DateOfLeaving') THEN CAST(LastDate AS SQL_VARIANT)
   --                             END
   --                         END DESC
   --             OFFSET ((@PageNo - 1) * @PageSize) ROWS
   --             FETCH NEXT @PageSize ROWS ONLY

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

