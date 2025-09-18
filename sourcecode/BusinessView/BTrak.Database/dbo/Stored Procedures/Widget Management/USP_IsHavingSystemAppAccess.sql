CREATE PROCEDURE [dbo].[USP_IsHavingSystemAppAccess]
(
@OperationsPerformedBy UNIQUEIDENTIFIER,
@WidgetName NVARCHAR(500)
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @RoleIds TABLE
		   (
				UserRoleId UNIQUEIDENTIFIER
		   )

		   INSERT INTO @RoleIds(UserRoleId)
		   SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)
		   
		DECLARE @IsAccess BIT = (CASE WHEN (select count(1) as counts FROM  Widget W 
			     INNER JOIN  (
			        SELECT WRC.WidgetId
		            FROM WidgetRoleConfiguration WRC
			             INNER JOIN @RoleIds R ON R.UserRoleId = WRC.RoleId AND WRC.Inactivedatetime IS NULL
						 WHERE WidgetId = (SELECT Id FROM Widget WHERE WidgetName=@WidgetName AND CompanyId=@CompanyId)
		            GROUP BY WRC.WidgetId
			       ) WR ON WR.WidgetId = W.Id
				   WHERE W.CompanyId = @CompanyId AND W.WidgetName=@WidgetName)>0 THEN 1 ELSE 0 END)

				   SELECT @IsAccess
		END
		ELSE
			   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END