--SELECT UserId FROM [dbo].[Ufn_GetAccessibleMembersForSlack]('FFDFD332-9AC2-4CD0-9EA1-9730AAA16DC5','127133F1-4427-4149-9DD6-B02E0E036971','A3B9B81A-109B-445D-9AEA-6B8A2B71C884')
CREATE FUNCTION [dbo].[Ufn_GetAccessibleMembersForSlack]
(
	@CompanyId UNIQUEIDENTIFIER,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@FeatureId UNIQUEIDENTIFIER
)
RETURNS TABLE AS RETURN
(
	(SELECT CM.MemberUserId AS UserId
    FROM ChannelMember (NOLOCK) CM
         INNER JOIN Channel (NOLOCK) C ON C.Id = CM.ChannelId AND C.InactiveDateTime IS NULL AND CM.InActiveDateTime IS NULL
    WHERE CM.ChannelId IN (SELECT ChannelId FROM ChannelMember (NOLOCK) WHERE MemberUserId = @OperationsPerformedBy AND InActiveDateTime IS NULL)
    GROUP BY CM.MemberUserId
    ) 
    UNION
    SELECT @OperationsPerformedBy
    UNION
    (SELECT UR.UserId 
     FROM [RoleFeature] (NOLOCK) RF
          INNER JOIN [UserRole] (NOLOCK) UR ON UR.RoleId = RF.RoleId
                     AND UR.InactiveDateTime IS NULL
                     AND RF.InActiveDateTime IS NULL
    	  INNER JOIN [Role] (NOLOCK) R ON R.Id = UR.RoleId
    	             AND R.InactiveDateTime IS NULL
     WHERE R.CompanyId = @CompanyId
           AND RF.FeatureId = @FeatureId)
)
GO