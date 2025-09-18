--EXEC [USP_GetLeaveFrequency] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetLeaveFrequency]
(
  @LeaveFrequencyId UNIQUEIDENTIFIER = NULL,
  @DateFrom DATETIME = NULL,  
  @DateTo DATETIME = NULL,
  @NoOfLeaves FLOAT = 0,
  @LeaveTypeId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT = NULL,
  @IsToGetLeaveTypes BIT = NULL,
  @Date DATE = NULL,
  @SearchText NVARCHAR(600) = NULL,
  @SortBy NVARCHAR(40) = NULL,
  @SortDirection NVARCHAr(20) = 'ASC',
  @PageNumber INT = 1,
  @PageSize INT = 10
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        
        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))        
        IF (@HavePermission = '1')
        BEGIN

		IF (@SortBy IS NULL) SET @SortBy = 'FromDate'

		SET @SearchText = '%' + @SearchText + '%'

                SELECT LF.LeaveTypeId AS LeaveTypeId,
                   LT.LeaveTypeName,
                   LF.Id AS LeaveFrequencyId,
                   DateFrom,
                   DateTo,
                   LF.LeaveTypeId,
                   LF.CompanyId,
                   LF.NoOfLeaves,
                   LF.CreatedByUserId,
                   LF.CreatedDateTime,
                   LF.[TimeStamp] AS LeaveFrequencyTimeStamp,
                   CASE WHEN LF.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
                   LF.LeaveFormulaId,
                   LFO.Formula,
                   LF.EncashmentTypeId,
                   ECT.Encashmenttype,
                   LF.RestrictionTypeId,
                   RT.Restriction,
                   LF.IsPaid,
                   LF.IsEncashable,
                   LF.IsToCarryForward,
                   LT.IsIncludeHolidays AS IsToIncludeHolidays,
                   LF.IsToRepeatTheInterval AS IsToRepeatInterval,
                   LF.NumberOfDaysToBeIntimated AS NoOfDaysToBeIntimated,
                   LF.CarryForwardLeavesCount,
                   LF.PayableLeavesCount,
                   JC.EmploymentStatusName,
                   LF.EmploymentTypeId AS EmploymentStatusId,
				   LF.EncashedLeavesCount,
                   TotalCount = COUNT(1) OVER()
                   FROM LeaveFrequency LF 
                   INNER JOIN LeaveType LT ON LT.Id = LF.LeaveTypeId  AND LT.InactiveDateTime IS NULL
                   LEFT JOIN LeaveFormula LFO ON LFO.Id = LF.LeaveFormulaId  AND LFO.InactiveDateTime IS NULL
                   LEFT JOIN EncashmentType ECT ON LF.EncashmentTypeId = ECT.Id  AND ECT.InActiveDateTime IS NULL
                   LEFT JOIN RestrictionType RT ON LF.RestrictionTypeId = RT.Id  AND RT.InActiveDateTime IS NULL
                   LEFT JOIN EmploymentStatus JC ON JC.Id = LF.EmploymentTypeId AND JC.InActiveDateTime IS NULL
                   WHERE LF.CompanyId = @CompanyId
                     AND (@LeaveFrequencyId IS NULL OR @LeaveFrequencyId = LF.Id)
                     AND ((LF.LeaveTypeId = @LeaveTypeId) OR @LeaveTypeId IS NULL)
                     AND (@NoOfLeaves = 0 OR LF.NoOfLeaves = @NoOfLeaves)
                     AND (@IsArchived IS NULL OR (@IsArchived = 0 AND LF.InActiveDateTime IS NULL) OR (@IsArchived = 1 AND LF.InActiveDateTime IS NOT NULL))
                     AND (@DateFrom IS NULL OR DateFrom >= @DateFrom)
                     AND (@DateTo IS NULL OR DateFrom <= @DateTo)
                     AND (@Date IS NULL OR @Date BETWEEN DateFrom AND DateTo)
					   AND (@SearchText IS NULL OR (LT.LeaveTypeName LIKE @SearchText)
			                             OR (CAST(LF.NoOfLeaves AS NVARCHAR(60)) LIKE @SearchText)
										 --OR (REPLACE(CONVERT(NVARCHAR,LF.DateFrom,106),' ','-')) LIKE @SearchText
										 --OR (REPLACE(CONVERT(NVARCHAR,LF.DateTo,106),' ','-')) LIKE @SearchText
										 )
		    ORDER BY 
			        CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE  WHEN(@SortBy = 'NoOfLeaves') THEN CAST(LF.NoOfLeaves AS SQL_VARIANT)
						       WHEN(@SortBy = 'LeaveTypeName') THEN CAST(LT.LeaveTypeName AS SQL_VARIANT)
							   WHEN(@SortBy = 'DateFrom') THEN LF.DateFrom
						       WHEN(@SortBy = 'DateTo') THEN LF.DateTo
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                          CASE  WHEN(@SortBy = 'NoOfLeaves') THEN CAST(LF.NoOfLeaves AS SQL_VARIANT)
						       WHEN(@SortBy = 'LeaveTypeName') THEN CAST(LT.LeaveTypeName AS SQL_VARIANT)
							   WHEN(@SortBy = 'DateFrom') THEN LF.DateFrom
						       WHEN(@SortBy = 'DateTo') THEN LF.DateTo
                          END
                      END DESC 

					OFFSET ((@PageNumber - 1) * @PageSize) ROWS
					
		            FETCH NEXT @PageSize ROWS ONLY	
		      
        END
        ELSE
            
            RAISERROR(@HavePermission,11,1)
   
   END TRY
   BEGIN CATCH
   
    THROW
   
   END CATCH
END
GO