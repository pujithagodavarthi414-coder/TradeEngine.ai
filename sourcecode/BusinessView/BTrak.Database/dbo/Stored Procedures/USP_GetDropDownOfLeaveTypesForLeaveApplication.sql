CREATE PROCEDURE [dbo].[USP_GetDropDownOfLeaveTypesForLeaveApplication]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
SET NOCOUNT ON
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		SELECT OriginalId AS LeaveTypeId,
		       LeaveTypeName,
			   LeaveShortName AS LeaveTypeShortName,
			   CreatedByUserId,
			   CreatedDateTime
		       FROM LeaveType LT
			   JOIN (SELECT LeaveTypeId FROM [dbo].[Ufn_GetEligibleLeaveTypes](@OperationsPerformedBy)) T ON T.LeaveTypeId = LT.OriginalId AND LT.AsAtInactiveDateTime IS NULL AND LT.InActiveDateTime IS NULL AND LT.CompanyId = @CompanyId
END
