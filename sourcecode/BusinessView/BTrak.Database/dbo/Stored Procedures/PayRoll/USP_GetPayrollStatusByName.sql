CREATE PROCEDURE [dbo].[USP_GetPayrollStatusByName]
(
@StatusName nvarchar(250),
@CompanyId uniqueidentifier
)
AS
BEGIN
SELECT TOP 1 Id from PayrollStatus where CompanyId = @CompanyId and PayrollStatusName = @StatusName
END