CREATE PROCEDURE [dbo].[USP_GetEmployeesBonusDetails]
(
@OperationsPerformedBy UNIQUEIDENTIFIER,
@EmployeeId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = '1'

		IF (@HavePermission = '1')
		BEGIN

		     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

             SELECT
             EMB.Id,
             EMB.EmployeeId,
             EMB.IsArchived, 
             EMB.Bonus, 
             dbo.Ufn_GetCurrency(CU.CurrencyCode,EMB.Bonus,1) ModifiedBonus, 
             EMB.PayrollRunEmployeeId, 
             us.FirstName + ' ' + ISNULL(us.SurName,'') as EmployeeName, 
             us.ProfileImage,
             us.Id AS UserId,
             emp.EmployeeNumber,
             EMB.IsApproved,
             (CASE WHEN EMB.PayRollComponentId IS NOT NULL THEN 0 WHEN EMB.IsCtcType = 1 THEN  1 ELSE NULL END) As [AmountType],
             (CASE WHEN EMB.Bonus IS NOT NULL THEN 0 WHEN EMB.[Percentage]  IS NOT NULL THEN  1 ELSE NULL END) As [Type],
              PC.[ComponentName] PayRollComponentName,
             (CASE WHEN EMB.Bonus IS NOT NULL THEN EMB.Bonus WHEN EMB.[Percentage] IS NOT NULL THEN  EMB.[Percentage] ELSE NULL END) Value,
             EMB.PayRollComponentId,
             EMB.[Percentage],
             EMB.[IsCtcType],
             EMB.GeneratedDate,
             EMB.IsPaid
             FROM EmployeeBonus emb
             join Employee AS emp ON emp.Id = EMB.EmployeeId
             join [User] AS us ON us.Id = emp.UserId
             LEFT JOIN Currency CU ON CU.Id = us.CurrencyId
             LEFT JOIN PayrollComponent PC ON PC.Id = EMB.PayRollComponentId
             WHERE us.CompanyId = @CompanyId
			 AND (@EmployeeId IS NULL OR EMB.EmployeeId = @EmployeeId)

		END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END