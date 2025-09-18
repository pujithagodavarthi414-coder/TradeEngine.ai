--SELECT * FROM [dbo].[Ufn_GetUsersBasedOnFeaturePermission]('11C1EA8D-BEE2-48C1-90AE-769580131173','D4220276-C1C7-4B45-AB38-FF326BB37908')
CREATE FUNCTION [dbo].[Ufn_GetUsersBasedOnFeaturePermission]
(
	@CompanyId UNIQUEIDENTIFIER,
	@FeatureId UNIQUEIDENTIFIER
)
RETURNS @returntable TABLE
(
	UserId UNIQUEIDENTIFIER,
	UserName NVARCHAR(MAX)
)
AS
BEGIN
	INSERT @returntable
	SELECT U.Id AS UserId
	      ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS UserName 
		   FROM [User] U 
		   JOIN [UserRole] UR ON UR.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.IsActive = 1
		    AND UR.InactiveDateTime IS NULL AND U.CompanyId = @CompanyId
           JOIN [RoleFeature] RF ON RF.RoleId = UR.RoleId AND RF.InActiveDateTime IS NULL AND RF.FeatureId = @FeatureId
	RETURN
END
