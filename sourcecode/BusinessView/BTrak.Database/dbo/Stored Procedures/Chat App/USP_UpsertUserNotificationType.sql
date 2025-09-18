-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-19 00:00:00.000'
-- Purpose      To Save UserNotificationType
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_UpsertUserNotificationType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserId = 'DB9458B5-D28B-4DD5-A059-69EEA129DF6E',@NotificationTypeId = '9AB37862-4D0B-4A7F-8F55-3B5578A95739',@IsActive = 1,@IsDefaultEnable = 0

CREATE PROCEDURE [dbo].[USP_UpsertUserNotificationType]
(
	@UserNotificationTypeId UNIQUEIDENTIFIER = NULL,
	@UserId UNIQUEIDENTIFIER = NULL,
	@NotificationTypeId UNIQUEIDENTIFIER = NULL,
	@IsActive BIT = NULL,
	@IsDefaultEnable BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

    IF (@HavePermission = '1')
     BEGIN
    DECLARE @CurrentDate DATETIME = GETDATE()

	 IF(@UserNotificationTypeId IS NULL)
	 BEGIN
     
	 SET @UserNotificationTypeId = NEWID()

	 INSERT INTO [dbo].[UserNotificationType](
			            Id,
			            UserId,
			            NotificationTypeId,
			            CreatedDateTime,
			            CreatedByUserId,
						IsActive,
						IsDefaultEnable
						)
			     SELECT @UserNotificationTypeId,
			            @UserId,
			            @NotificationTypeId,
			            @Currentdate,
			            @OperationsPerformedBy,
			            @IsActive,
			            @IsDefaultEnable

			END
			ELSE
			BEGIN

			UPDATE [UserNotificationType]
			        SET UserId  =  @UserId,
			            NotificationTypeId = @NotificationTypeId,
			            UpdatedDateTime = @CurrentDate,
			            UpdatedByUserId = @OperationsPerformedBy,
						IsActive = @IsActive,
						IsDefaultEnable = @IsDefaultEnable
				  WHERE Id = @UserNotificationTypeId

			END

      SELECT Id FROM [dbo].[UserNotificationType] WHERE Id = @UserNotificationTypeId

	END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO

