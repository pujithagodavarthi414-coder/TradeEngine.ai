CREATE PROCEDURE [dbo].[USP_GetApprovedUserMails]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
				DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				IF(@HavePermission = '1')
				BEGIN

					IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL		   

					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

					SELECT U.Id AS UserId
					  ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS UserName
					  ,U.UserName AS Email
					FROM [RoleFeature] RF
					     INNER JOIN [Role] R ON R.Id = RF.RoleId AND R.InactiveDateTime IS NULL AND RF.InactiveDateTime IS NULL
					INNER JOIN UserRole UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
					INNER JOIN [user] U ON U.Id = UR.UserId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
					WHERE RF.FeatureId = '7F6C2F9E-C678-4544-86AF-BC32D8BB3F1B' AND R.CompanyId = @CompanyId
					GROUP BY U.Id,U.FirstName + ' ' + ISNULL(U.SurName,''),U.UserName
				END
				ELSE
				BEGIN
			
				RAISERROR (@HavePermission,11, 1)
					
				END
	 END TRY  
	 BEGIN CATCH 
		
		  EXEC [dbo].[USP_GetErrorInformation]

	END CATCH

END
GO