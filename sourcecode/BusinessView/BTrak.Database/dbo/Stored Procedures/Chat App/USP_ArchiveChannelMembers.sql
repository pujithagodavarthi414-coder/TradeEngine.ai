CREATE PROCEDURE [dbo].[USP_ArchiveChannelMembers]
(
	@UserIds nvarchar(max),
	@ChannelId uniqueidentifier,
	@UpdatedUserId uniqueidentifier,
	@OperationsPerformedBy uniqueidentifier = NULL
)

AS
BEGIN
SET NOCOUNT ON

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	    IF (@HavePermission = '1')
        BEGIN

          UPDATE [ChannelMember] SET IsActiveMember = 0
          WHERE [ChannelId] = @ChannelId and MemberUserId IN (SELECT Id FROM dbo.UfnSplit (@UserIds))

	    END
	   ELSE 
       BEGIN
       
          RAISERROR (@HavePermission,11, 1)
       
       END
END
