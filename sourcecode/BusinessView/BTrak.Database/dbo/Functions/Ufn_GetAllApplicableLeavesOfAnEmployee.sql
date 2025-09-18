CREATE FUNCTION [dbo].[Ufn_GetAllApplicableLeavesOfAnEmployee]
(
	@UserId UNIQUEIDENTIFIER,
	@Year INT,
	@IsPaid BIT
)
RETURNS FLOAT
AS
BEGIN
	
	DECLARE @DateFrom DATETIME,@DateTo DATETIME,@NoOfLeaves FLOAT

	SELECT @DateFrom = DateFrom,@DateTo = DateTo FROM [dbo].[Ufn_GetFinancialYearDatesForleaves] (@UserId,@Year)

	SET @NoOfLeaves = ISNULL((SELECT SUM(LeaveCount) FROM [dbo].[Ufn_GetLeavesReportOfAnUser](@UserId,NULL,@DateFrom,@DateTo) WHERE (@IsPaid IS NULL OR (@IsPaid IS NOT NULL AND @IsPaid = 1 AND IsPaid = 1))),0)
	
    RETURN ISNULL(@NoOfLeaves,0)
END
