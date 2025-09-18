CREATE PROCEDURE [dbo].[USP_GetEmployeeRosterPlans]
(
	@RequestId UNIQUEIDENTIFIER = NULL,
	@IsTemplate BIT = NULL,
	@SearchText varchar(max) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@PageSize INT = 1,
	@PageNumber INT = 0,
	@SortBy VARCHAR(50) = NULL,
	@SortDirection VARCHAR(15) = NULL,
	@IsArchived BIT = NULL,
	@BranchId UNIQUEIDENTIFIER = NULL
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

			 IF(@SearchText = '') SET @SearchText = NULL
			 ELSE SET @SearchText = REPLACE(@SearchText, '\', '')

		   	IF(@SortDirection IS NULL )
			BEGIN
				SET @SortDirection = 'DESC'
			END

			IF(@IsTemplate IS NULL)
			BEGIN
				SET @IsTemplate = 0
			END

			IF(@SortBy IS NULL)
			BEGIN
				SET @SortBy = 'requiredToDate'
			END
			ELSE
			BEGIN
				SET @SortBy = @SortBy
			END

			IF(@IsArchived IS NULL)
			BEGIN
				SET @IsArchived = 0;
			END
			
				CREATE TABLE #FilterData 
				(
					[field] NVARCHAR(250),
					[operator] NVARCHAR(250),
					[value] NVARCHAR(250)
				)

				INSERT INTO #FilterData
				SELECT *
				FROM OPENJSON(@SearchText)
				WITH ([field] NVARCHAR(250),
					[operator] NVARCHAR(250),
					[value] NVARCHAR(250))

		select * from (
			  SELECT R.Id RequestId,
					RosterName RequestName, 
					RequiredFromDate,
					RequiredToDate,
					RequiredEmployee,
					RequiredBudget,
					RequiredBreakMins,
					IncludeHolidays,
					IncludeWeekends,
					TotalWorkingDays,
					TotalWorkingHours,
					R.CreatedDateTime,
					R.CreatedByUserId,
					U.FirstName + COALESCE(' ' + U.SURNAME, '') CreatedByUserName,
					u.ProfileImage,
					R.[TimeStamp],
					R.CompanyId,
					RPS.StatusName,
					RPS.StatusColor,
					CASE WHEN R.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   			TotalCount = COUNT(1) OVER(),
					LAG(R.Id) OVER (ORDER BY RequiredToDate DESC) PreviousValue,
					LEAD(R.Id) OVER (ORDER BY RequiredToDate DESC) NextValue,
					B.Id BranchId,
					B.BranchName,
					R.IsTemplate
			 FROM RosterRequest R
			 INNER JOIN [USER] U ON U.Id = R.CreatedByUserId 
			 INNER JOIN [Employee] E ON E.UserId = U.Id
			 INNER JOIN RosterPlanStatus RPS on RPS.Id = R.StatusId
			 INNER JOIN Branch B ON B.Id = R.BranchId AND B.InActiveDateTime is null		 	 
			 WHERE R.CompanyId = @CompanyId
					AND E.Id IN (
						SELECT EEB1.EmployeeId FROM [User] U1
						INNER JOIN [Employee] E1 ON E1.UserId = U1.Id
						INNER JOIN EmployeeEntityBranch EEB2 ON EEB2.EmployeeId = E1.Id  
						INNER JOIN EmployeeEntityBranch EEB1 ON EEB1.EmployeeId = E.Id 
							 AND EEB1.BranchId = EEB2.BranchId
						WHERE U1.Id = @OperationsPerformedBy
					)
					AND (@BranchId IS NULL OR R.BranchId = @BranchId)
					AND R.Id IN (SELECT DISTINCT RequestId fROM RosterActualPlan)
					AND (@IsTemplate = 0 OR (COALESCE(R.IsTemplate, 0) = @IsTemplate) AND RPS.StatusName <> 'Draft')
					AND (@IsArchived IS NULL OR(@IsArchived = 0 AND R.InActiveDateTime IS NULL) OR(@IsArchived = 1 AND R.InActiveDateTime IS NOT NULL))
					AND (@SearchText IS NULL OR @SearchText = '' OR 
							(
								((SELECT COUNT(*) FROM #FilterData WHERE field = 'requestName') = 0 OR RosterName LIKE '%'+(SELECT value FROM #FilterData WHERE field = 'requestName')+'%' )
								AND ((SELECT COUNT(*) FROM #FilterData WHERE field = 'branchName') = 0 OR BranchName LIKE '%'+(SELECT value FROM #FilterData WHERE field = 'branchName')+'%' )
								AND ((SELECT COUNT(*) FROM #FilterData WHERE field = 'requiredFromDate') = 0 OR RequiredFromDate = (SELECT value FROM #FilterData WHERE field = 'requiredFromDate'))
								AND ((SELECT COUNT(*) FROM #FilterData WHERE field = 'requiredToDate')  = 0 OR RequiredToDate = (SELECT value FROM #FilterData WHERE field = 'requiredToDate'))
								AND ((SELECT COUNT(*) FROM #FilterData WHERE field = 'requiredEmployee') = 0 OR RequiredEmployee LIKE  '%'+(SELECT value FROM #FilterData WHERE field = 'requiredEmployee') + '%')
								AND ((SELECT COUNT(*) FROM #FilterData WHERE field = 'requiredBudget') = 0 OR requiredBudget LIKE  '%'+(SELECT value FROM #FilterData WHERE field = 'requiredBudget') + '%')
								AND ((SELECT COUNT(*) FROM #FilterData WHERE field = 'totalWorkingDays') = 0 OR TotalWorkingDays LIKE  '%'+(SELECT value FROM #FilterData WHERE field = 'totalWorkingDays') + '%')
								AND ((SELECT COUNT(*) FROM #FilterData WHERE field = 'totalWorkingHours') = 0 OR TotalWorkingHours LIKE  '%'+(SELECT value FROM #FilterData WHERE field = 'totalWorkingHours') + '%')
								AND ((SELECT COUNT(*) FROM #FilterData WHERE field = 'statusName') = 0 OR StatusName LIKE '%'+(SELECT value FROM #FilterData WHERE field = 'statusName')+'%') 
								AND ((SELECT COUNT(*) FROM #FilterData WHERE field = 'includeHolidays') =0 OR IncludeHolidays = (SELECT value FROM #FilterData WHERE field = 'includeHolidays'))
								AND ((SELECT COUNT(*) FROM #FilterData WHERE field = 'includeWeekends') = 0 OR IncludeWeekends = (SELECT value FROM #FilterData WHERE field = 'includeWeekends'))
								AND ((SELECT COUNT(*) FROM #FilterData WHERE field = 'createdByUserName') = 0 OR (U.FirstName + COALESCE(' ' + U.SURNAME, '')) like '%' + (SELECT value FROM #FilterData WHERE field = 'createdByUserName') +'%' )
							)
						)
			 
		) as tbl
		where (@RequestId IS NULL OR RequestId = @RequestId)
				
		ORDER BY 
		CASE WHEN @SortDirection = 'ASC' THEN
			CASE WHEN @SortBy = 'requestName' THEN CAST(RequestName AS SQL_VARIANT)
					WHEN @SortBy = 'requiredFromDate' THEN CAST(RequiredFromDate AS SQL_VARIANT)
					WHEN @SortBy = 'requiredToDate' THEN CAST(RequiredToDate AS SQL_VARIANT)
					WHEN @SortBy = 'branchName' THEN CAST(BranchName AS SQL_VARIANT)
					WHEN @SortBy = 'requiredBudget' THEN CAST(RequiredBudget AS SQL_VARIANT)
					WHEN @SortBy = 'includeHolidays' THEN CAST(IncludeHolidays AS SQL_VARIANT)
					WHEN @SortBy = 'includeWeekends' THEN CAST(IncludeWeekends AS SQL_VARIANT)
					WHEN @SortBy = 'totalWorkingDays' THEN CAST(TotalWorkingDays AS SQL_VARIANT)
					WHEN @SortBy = 'totalWorkingHours' THEN CAST(TotalWorkingHours AS SQL_VARIANT)
					WHEN @SortBy = 'statusName' THEN CAST(StatusName AS SQL_VARIANT)
					WHEN @SortBy = 'requiredEmployee' THEN CAST(RequiredEmployee AS SQL_VARIANT)
					WHEN @SortBy = 'createdByUserName' THEN CAST(tbl.CreatedByUserName AS SQL_VARIANT)
					WHEN @SortBy = 'createdDateTime' THEN CAST(tbl.CreatedDateTime AS SQL_VARIANT)
			END
		END ASC,
		CASE WHEN @SortDirection = 'DESC' THEN
			CASE WHEN @SortBy = 'requestName' THEN CAST(RequestName AS SQL_VARIANT)
					WHEN @SortBy = 'requiredFromDate' THEN CAST(RequiredFromDate AS SQL_VARIANT)
					WHEN @SortBy = 'requiredToDate' THEN CAST(RequiredToDate AS SQL_VARIANT)
					WHEN @SortBy = 'branchName' THEN CAST(BranchName AS SQL_VARIANT)
					WHEN @SortBy = 'requiredBudget' THEN CAST(RequiredBudget AS SQL_VARIANT)
					WHEN @SortBy = 'includeHolidays' THEN CAST(IncludeHolidays AS SQL_VARIANT)
					WHEN @SortBy = 'includeWeekends' THEN CAST(IncludeWeekends AS SQL_VARIANT)
					WHEN @SortBy = 'totalWorkingDays' THEN CAST(TotalWorkingDays AS SQL_VARIANT)
					WHEN @SortBy = 'totalWorkingHours' THEN CAST(TotalWorkingHours AS SQL_VARIANT)
					WHEN @SortBy = 'statusName' THEN CAST(StatusName AS SQL_VARIANT)
					WHEN @SortBy = 'requiredEmployee' THEN CAST(RequiredEmployee AS SQL_VARIANT)
					WHEN @SortBy = 'createdByUserName' THEN CAST(tbl.CreatedByUserName AS SQL_VARIANT)
					WHEN @SortBy = 'createdDateTime' THEN CAST(tbl.CreatedDateTime AS SQL_VARIANT)						
			END
		END DESC

		OFFSET @PageNumber ROWS
			 
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