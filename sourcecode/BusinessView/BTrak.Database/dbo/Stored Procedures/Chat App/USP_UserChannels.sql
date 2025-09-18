CREATE PROCEDURE [dbo].[USP_UserChannels]
(
   @UserId UNIQUEIDENTIFIER = null,
   @ChannelId UNIQUEIDENTIFIER = null
)
AS
SET NOCOUNT ON

DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@UserId,(SELECT OBJECT_NAME(@@PROCID))))

 IF (@HavePermission = '1')
 BEGIN

	 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))

	SELECT CM.Id,CM.ChannelId,C.CompanyId,C.ChannelName,C.IsDeleted,CM.MemberUserId,CM.IsActiveMember,U.FirstName+' '+ISNULL(U.SurName,'') EmployeeName,U.*
		FROM ChannelMember CM 
		JOIN Channel C ON CM.ChannelId = C.Id 
		JOIN [User] U ON U.Id = CM.MemberUserId
			WHERE CM.ActiveTo IS NULL 
			AND U.CompanyId = @CompanyId
			AND (@UserId IS NULL OR CM.MemberUserId = @UserId) 
			AND (@ChannelId IS NULL OR CM.ChannelId = @ChannelId) 
			AND (C.IsDeleted IS NULL OR C.IsDeleted = 0)

END