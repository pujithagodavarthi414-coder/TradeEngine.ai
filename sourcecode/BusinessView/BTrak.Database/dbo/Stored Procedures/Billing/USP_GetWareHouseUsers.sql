CREATE PROCEDURE [dbo].[USP_GetWareHouseUsers]
(
@RoleName nvarchar(200) = NULL,
@OperationsPerformedBy uniqueidentifier
)
AS
BEGIN
		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

                DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                DECLARE @RoleId UNIQUEIDENTIFIER = (SELECT Id FROM [Role] WHERE RoleName='Ware House' AND CompanyId=@CompanyId)

                        SELECT US.UserName,
                            US.Id, 
                            US.ProfileImage,
                            US.FirstName +' '+ISNULL(US.SurName,'') AS FullName,
							US.FirstName ,
							US.SurName,
							ISNULL(C.CountryCode,'') + US.MobileNo AS MobileNo
                            FROM [User] US
                        INNER JOIN Employee E ON E.UserId = US.Id
                        LEFT JOIN EmployeeContactDetails ECD ON E.Id=ECD.EmployeeId
                        LEFT JOIN Country C ON C.Id = ECD.CountryId
						WHERE  @RoleId IN (SELECT RoleId FROM Ufn_GetRoleIdsBasedOnUserId(US.Id))
						AND US.CompanyId = @CompanyId
                        AND C.InActiveDateTime IS NULL
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END