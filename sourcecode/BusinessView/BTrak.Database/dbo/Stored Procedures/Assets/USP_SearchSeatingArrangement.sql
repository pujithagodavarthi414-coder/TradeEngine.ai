CREATE PROCEDURE [dbo].[USP_SearchSeatingArrangement]
(
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @SeatCode NVARCHAR(50) = NULL,
   @CompanyId UNIQUEIDENTIFIER = NULL,
   @PageSize INT = 100,
   @skip INT = 0,
   @SearchText NVARCHAR(250)= NULL,
   @OrderByColumnName NVARCHAR(250)= NULL,
   @OrderByDirectionAsc BIT = 1
)
AS
BEGIN

	DECLARE @SearchSqlScript NVARCHAR(MAX)  
	DECLARE @lFirstRec  INT,
			@lLastRec   INT
	
	DECLARE @OrderByDirection NVARCHAR(250) 
	IF(@OrderByDirectionAsc = 1 )
	BEGIN
		SET @OrderByDirection = 'Asc'
	END
	ELSE
	BEGIN
		SET @OrderByDirection = 'Desc'
	END

	DECLARE @OrderByColumn NVARCHAR(250) 
	IF(@OrderByColumnName IS NULL)
	BEGIN
		SET @OrderByColumn = 'FirstName'
	END
	ELSE
	BEGIN
		SET @OrderByColumn = @OrderByColumnName
	END

	SET @lFirstRec  = @skip
	SET @lLastRec   = @skip + @pageSize
	SET @SearchText = LOWER(@SearchText)

	SET @SearchSqlScript = N'WITH CTE_Results AS (SELECT SA.Id,EmployeeId,SeatCode,Description,Comment,SA.CreatedDateTime,U.FirstName FirstName,U.SurName SurName,CompanyId  FROM [SeatingArrangement] SA
													JOIN [User] U ON U.Id = SA.EmployeeId
												WHERE (U.CompanyId = @CompanyId)'
												 
	IF(@EmployeeId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (EmployeeId = @EmployeeId)'
	IF(@SeatCode IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (SeatCode LIKE ''%''+ @SeatCode +''%'')'
	IF(@SearchText IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (U.FirstName LIKE ''%''+ @SearchText +''%'')' 
	  
	SET @SearchSqlScript = @SearchSqlScript + N' ) '
	
	SET @SearchSqlScript = @SearchSqlScript +  N' SELECT Id,EmployeeId,SeatCode,Description,Comment,CreatedDateTime,FirstName,SurName,CompanyId FROM CTE_Results AS CPC
				CROSS JOIN (SELECT Count(1) AS Count FROM CTE_Results) AS CountTable
				ORDER BY ' +  @OrderByColumn + ' ' + @OrderByDirection + ' 
				OFFSET @skip ROWS'
	IF (@pageSize <> -1) SET @SearchSqlScript = @SearchSqlScript + N' FETCH NEXT @pageSize ROWS ONLY'
	
	PRINT @SearchSqlScript;

	exec sp_executesql @SearchSqlScript, 
		N'@EmployeeId UNIQUEIDENTIFIER = NULL,
			@SeatCode NVARCHAR(50) = NULL,
			@CompanyId UNIQUEIDENTIFIER = NULL,
			@PageSize INT = 100,
			@skip INT = 0,
			@SearchText NVARCHAR(250)= NULL,
			@OrderByColumnName NVARCHAR(250)= NULL,
			@OrderByDirectionAsc BIT = 1', @EmployeeId,@SeatCode,@CompanyId, @PageSize, @skip, @SearchText, @OrderByColumnName, @OrderByDirectionAsc
END			


--EXEC [USP_SearchSeatingArrangement]