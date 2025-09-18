--exec [USP_GetLeaveApplicability] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036972'
CREATE PROCEDURE [dbo].[USP_GetLeaveApplicability]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @LeaveTypeId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

	DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
	BEGIN
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		SELECT LA.Id AS LeaveApplicabilityId,
		       LA.LeaveTypeId,
			   LA.MinExperienceInMonths/12.0 AS MinExperienceInMonths,
			   LA.MaxExperienceInMonths/12.0 AS MaxExperienceInMonths,
			   LA.MaxLaves AS MaxLeaves,
			   (SELECT(SELECT RL.RoleId
                      FROM [RoleLeaveType] RL WITH (NOLOCK)
                           WHERE RL.LeaveTypeId = LA.LeaveTypeId
						     AND RL.CompanyId = @CompanyId
							 AND RL.InactiveDateTime IS NULL
							 AND RL.RoleId IS NOT NULL
						   ORDER BY RL.CreatedDateTime DESC FOR XML PATH('RolesInputModel'), TYPE)
                      FOR XML PATH('LeaveApplicabilityRoleModel'), TYPE) AS RoleXml,
			    (SELECT(SELECT BL.BranchId
                        FROM [BranchLeaveType] BL WITH (NOLOCK)
                        WHERE BL.LeaveTypeId = LA.LeaveTypeId
						  AND BL.CompanyId = @CompanyId
						  AND BL.InactiveDateTime IS NULL
						  AND BL.BranchId IS NOT NULL
						ORDER BY BL.CreatedDateTime DESC FOR XML PATH('BranchApiReturnModel'), TYPE)
                      FOR XML PATH('LeaveApplicabilityBranchModel'), TYPE) AS BranchXml,
				(SELECT(SELECT GL.GenderId 
                        FROM [GenderLeaveType] GL WITH (NOLOCK)
                        WHERE GL.LeaveTypeId = LA.LeaveTypeId
						  AND GL.CompanyId = @CompanyId
						  AND GL.InactiveDateTime IS NULL
						  AND GL.GenderId IS NOT NULL
						ORDER BY GL.CreatedDateTime DESC FOR XML PATH('GendersOutputModel'), TYPE)
                      FOR XML PATH('LeaveApplicabilityGenderModel'), TYPE) AS GenderXml,
			   (SELECT(SELECT ML.MariatalStatusId as MaritalStatusId
                       FROM [MariatalStatusLeaveType] ML WITH (NOLOCK)
                       WHERE ML.LeaveTypeId = LA.LeaveTypeId
						 AND ML.CompanyId = @CompanyId
						 AND ML.InactiveDateTime IS NULL
						 AND ML.MariatalStatusId IS NOT NULL
					   ORDER BY ML.CreatedDateTime DESC FOR XML PATH('MaritalStatusesOutputModel'), TYPE)
                      FOR XML PATH('LeaveApplicabilityMariatalStatusModel'), TYPE) AS MariatalStatusXml,
			   (SELECT(SELECT EL.EmployeeId AS EmployeeId
                       FROM [EmployeeLeaveType] EL WITH (NOLOCK)
                       WHERE EL.LeaveTypeId = LA.LeaveTypeId
						 AND EL.CompanyId = @CompanyId
						 AND EL.InactiveDateTime IS NULL
						 AND EL.EmployeeId IS NOT NULL
					   ORDER BY EL.CreatedDateTime DESC FOR XML PATH('EmployeesOutputModel'), TYPE)
                      FOR XML PATH('LeaveApplicabilityEmployeeModel'), TYPE) AS EmployeeXml,
				LA.[TimeStamp]
		       FROM LeaveApplicability LA
               WHERE (@LeaveTypeId IS NULL OR LA.LeaveTypeId = @LeaveTypeId)
	END
END TRY
BEGIN CATCH

	THROW

END CATCH
END
GO