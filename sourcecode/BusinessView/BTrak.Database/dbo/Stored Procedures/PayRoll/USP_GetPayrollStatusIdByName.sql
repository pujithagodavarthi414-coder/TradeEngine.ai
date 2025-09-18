CREATE PROCEDURE [dbo].[USP_GetPayrollStatusIdByName]
(
@StatusName nvarchar(250),
@CompanyId uniqueidentifier
)
AS
BEGIN
select top 1 Id from PayrollStatus where PayrollStatusName = @StatusName and CompanyId = @CompanyId
END



