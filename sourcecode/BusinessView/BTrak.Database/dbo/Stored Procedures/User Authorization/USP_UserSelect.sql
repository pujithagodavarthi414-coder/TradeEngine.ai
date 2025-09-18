CREATE PROCEDURE [dbo].[USP_UserSelect]
(
	@Id uniqueidentifier
)

AS

SET NOCOUNT ON

SELECT [Id],
	[CompanyId],
	[SurName],
	[FirstName],
	[UserName],
	[Password],
	--[RoleId],
	[IsPasswordForceReset],
	[IsActive],
	[TimeZoneId],
	[MobileNo],
	[IsAdmin],
	[IsActiveOnMobile],
	[ProfileImage],
	[RegisteredDateTime],
	[LastConnection],
	[CreatedDateTime],
	[CreatedByUserId],
	[UpdatedDateTime],
	[UpdatedByUserId]
FROM [User]
WHERE [Id] = @Id
