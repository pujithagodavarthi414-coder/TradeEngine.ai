CREATE PROCEDURE [dbo].[USP_LogTimeReport]
(
   @SelectedDate DATETIME = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @TeamLeadId UNIQUEIDENTIFIER = NULL,
   @PageLoad BIT = 1,
   @CompanyId UNIQUEIDENTIFIER
)
AS
BEGIN
   IF(@PageLoad = 1)
    BEGIN
        IF((SELECT IsAdmin FROM [User] WHERE Id = @TeamLeadId) = 1)
            SET @TeamLeadId = NULL
   END

  DECLARE @IsReporting INT = (SELECT COUNT(Id) FROM EmployeeReportTo WHERE ReportToEmployeeId = (SELECT Id FROM Employee WHERE UserId = @TeamLeadId))
  
  IF(@IsReporting <> 0)
  BEGIN
        SELECT * FROM [dbo].[Ufn_GetLogTimeReport](@SelectedDate,@BranchId,@TeamLeadId,@CompanyId)
		WHERE UserId <> @TeamLeadId
  END
  ELSE
  BEGIN
	SELECT * FROM [dbo].[Ufn_GetLogTimeReport](@SelectedDate,@BranchId,@TeamLeadId,@CompanyId)
  END
END