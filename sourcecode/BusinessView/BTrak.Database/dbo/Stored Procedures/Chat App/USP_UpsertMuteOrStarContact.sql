CREATE PROCEDURE [dbo].[USP_UpsertMuteOrStarContact]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @ChannelId UNIQUEIDENTIFIER = NULL,
 @UserId UNIQUEIDENTIFIER = NULL,
 @IsMuted BIT = NULL,
 @IsStarred BIT = NULL,
 @IsLeave BIT=NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
​
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
​
		IF (@HavePermission = '1')
		BEGIN
			IF (@ChannelId = '00000000-0000-0000-0000-000000000000') SET @ChannelId = NULL
			
			IF (@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
​
			IF (@ChannelId IS NULL AND @UserId IS NULL)
				BEGIN
​
					RAISERROR('EitherChannelIdOrUserIdShouldBeProvided',11,1)
​
				END
			ELSE
				DECLARE @IsAlreadyExist UNIQUEIDENTIFIER
				SET @IsAlreadyExist = (SELECT Id FROM MutedOrStarredContacts WHERE ((UserId = @UserId AND @ChannelId IS NULL) OR (ChannelId = @ChannelId AND @UserId IS NULL)) AND CreatedByUserId = @OperationsPerformedBy)
					IF (@IsAlreadyExist IS NULL)
						BEGIN
							INSERT INTO MutedOrStarredContacts
							(Id,ChannelId,UserId,IsMuted,IsStarred,IsLeave,CreatedByUserId,CreatedDateTime)
							VALUES
							(NEWID(),@ChannelId,@UserId,@IsMuted,@IsStarred,@IsLeave,@OperationsPerformedBy,GETDATE())
						END
					ELSE
							UPDATE MutedOrStarredContacts SET IsMuted=@IsMuted,IsStarred=@IsStarred,IsLeave=@IsLeave,CreatedDateTime=GETDATE() WHERE Id=@IsAlreadyExist AND CreatedByUserId=@OperationsPerformedBy		
		END
		ELSE
			RAISERROR(@HavePermission,11,1)
	END TRY
	BEGIN CATCH
​
		THROW
​
	END CATCH
END
