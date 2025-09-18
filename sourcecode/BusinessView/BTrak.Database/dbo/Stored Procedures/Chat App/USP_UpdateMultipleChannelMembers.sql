-------------------------------------------------------------------------------
-- EXEC [USP_UpdateMultipleChannelMembers]
-- @OperationsPerformedBy ='127133F1-4427-4149-9DD6-B02E0E036971',
-- @ChannelId = '11B4393C-3ADF-499B-BB6F-59AE5873736D'
--,@UsersXML = '<GenericListOfChannelMemberModel>
-- <ListItems>
-- <ChannelMemberModel>
-- <MemberUserId>127133F1-4427-4149-9DD6-B02E0E036971</MemberUserId>
-- <IsReadOnly>1</IsReadOnly>
-- </ChannelMemberModel>
-- </ListItems>
-- </GenericListOfChannelMemberModel>'

CREATE PROCEDURE [dbo].[USP_UpdateMultipleChannelMembers]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@ChannelId UNIQUEIDENTIFIER = NULL
	,@UsersXML XML = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON

	BEGIN TRY
		
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = '1')
		BEGIN

			IF (@ChannelId = '00000000-0000-0000-0000-000000000000') SET @ChannelId = NULL
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF(@UsersXML IS NULL)
			BEGIN

				RAISERROR(50011,16, 2, 'Users')

			END
			ELSE IF(@ChannelId IS NULL)
			BEGIN
				
			   RAISERROR(50011,16, 2, 'Channel')

			END
			ELSE
			BEGIN

				UPDATE ChannelMember SET IsReadOnly = ISNULL(X.value('IsReadOnly[1]','BIT') ,0)
				FROM ChannelMember CM
				     INNER JOIN @UsersXML.nodes('/GenericListOfChannelMemberModel/ListItems/ChannelMemberModel') XmlData(X) ON X.value('MemberUserId[1]','UNIQUEIDENTIFIER') = CM.MemberUserId
				                AND CM.ChannelId = @ChannelId

			END

		END
		ELSE
		BEGIN

		      RAISERROR (@HavePermission,11, 1)

		 END

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO