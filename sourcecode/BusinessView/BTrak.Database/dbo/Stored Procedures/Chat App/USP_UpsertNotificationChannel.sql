-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-19 00:00:00.000'
-- Purpose      To Save NotificationChannel
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_UpsertNotificationChannel] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@NotificationId = '373CD867-5690-46D3-8F3C-09E28C8BC77A',@Channel = 'Test'

CREATE PROCEDURE [dbo].[USP_UpsertNotificationChannel]
(
	@NotificationChannelId UNIQUEIDENTIFIER = NULL,
	@NotificationId UNIQUEIDENTIFIER = NULL,
	@Channel NVARCHAR(250) = NULL,
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

     IF(@NotificationChannelId IS NULL)
	 BEGIN

	 SET @NotificationChannelId = NEWID()

      INSERT INTO [dbo].[NotificationChannel](
			            Id,
			            NotificationId,
			            Channel,
			            CreatedDateTime,
			            CreatedByUserId
						)
			     SELECT @NotificationChannelId,
			            @NotificationId,
			            @Channel,
			            @Currentdate,
			            @OperationsPerformedBy

		END
		ELSE
		BEGIN

		UPDATE [dbo].[NotificationChannel]
			      SET   NotificationId = @NotificationId,
			            Channel = @Channel,
						UpdatedDateTime = @CurrentDate,
						UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @NotificationChannelId

		END

    SELECT Id FROM [dbo].[NotificationChannel] WHERE Id = @NotificationChannelId

	END

	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH
END
GO
