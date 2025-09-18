-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-19 00:00:00.000'
-- Purpose      To Save RoleNotificationType
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertRoleNotificationType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @RoleId = '860484F4-2E1F-4A0A-BD36-3509611EA6E3',@NotificationTypeId = 'C672CFAC-41C3-4510-ACAA-2C87EA498F1F',@IsDefaultEnable = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertRoleNotificationType]
(
	@RoleNotificationTypeId UNIQUEIDENTIFIER = NULL,
	@RoleId UNIQUEIDENTIFIER = NULL,
	@NotificationTypeId UNIQUEIDENTIFIER = NULL,
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
	IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	IF (@RoleId = '00000000-0000-0000-0000-000000000000') SET @RoleId = NULL

	IF (@NotificationTypeId = '00000000-0000-0000-0000-000000000000') SET @NotificationTypeId = NULL

	IF(@RoleId IS NULL)
	BEGIN
	  
	  RAISERROR(50011,16, 2, 'Role')

	END
	ELSE IF(@NotificationTypeId IS NULL)
	BEGIN
	  
	  RAISERROR(50011,16, 2, 'NotificationType')

	END
	ELSE IF(@IsDefaultEnable IS NULL)
	BEGIN
	  
	  RAISERROR(50011,16, 2, 'IsDefaultEnable')

	END
	ELSE 
	BEGIN

    DECLARE @CurrentDate DATETIME = GETDATE()

     IF(@NotificationTypeId IS NULL)
	 BEGIN

	 SET @RoleNotificationTypeId = NEWID()

      INSERT INTO [dbo].[RoleNotificationType](
			            Id,
			            RoleId,
			            NotificationTypeId,
			            CreatedDateTime,
			            CreatedByUserId,
						IsDefaultEnable
						)
			     SELECT @RoleNotificationTypeId,
			            @RoleId,
			            @NotificationTypeId,
			            @Currentdate,
			            @OperationsPerformedBy,
						@IsDefaultEnable

		END
		ELSE
		BEGIN

		UPDATE [RoleNotificationType]
	     SET  RoleId = @RoleId,
		      NotificationTypeId = @NotificationTypeId,
			  UpdatedDateTime = @CurrentDate,
			  UpdatedByUserId = @OperationsPerformedBy,
			  IsDefaultEnable = @IsDefaultEnable
			  WHERE Id = @RoleNotificationTypeId

		END

    SELECT Id FROM [dbo].[RoleNotificationType] WHERE Id = @RoleNotificationTypeId
	END
	END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO
