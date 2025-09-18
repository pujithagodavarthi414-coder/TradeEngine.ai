-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-19 00:00:00.000'
-- Purpose      To Save Notification
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_UpsertNotification] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@NotificationTypeId = 'C3ECFA40-48E6-4AA2-9DC2-0DC1BFCDD7E3',@Summary = 'Test Purpose',@NotificationJson = 'Notification Send Successfully'

CREATE PROCEDURE [dbo].[USP_UpsertNotification]
(
	@NotificationId UNIQUEIDENTIFIER = NULL,
	@NotificationTypeId UNIQUEIDENTIFIER = NULL,
	@Summary NVARCHAR(500) = NULL,
	@NotificationJson NVARCHAR(MAX) = NULL,
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

    IF(@NotificationId IS NULL)
	BEGIN

	SET @NotificationId = NEWID()

    INSERT INTO [dbo].[Notification](
		            Id,
		            NotificationTypeId,
		            Summary,
		            NotificationJson,
		            CreatedDateTime,
		            CreatedByUserId
				    )
		     SELECT @NotificationId,
		            @NotificationTypeId,
		            @Summary,
		            @NotificationJson,
		            @Currentdate,
		            @OperationsPerformedBy
					
		 END
		 ELSE
		 BEGIN

		  UPDATE   [dbo].[Notification]
		       SET  NotificationTypeId = @NotificationTypeId,
		            Summary = @Summary,
		            NotificationJson = @NotificationJson,
		            UpdatedDateTime = @CurrentDate,
		            UpdatedByUserId = @OperationsPerformedBy
					WHERE Id = @NotificationId

		 END

	SELECT Id FROM [dbo].[Notification] WHERE Id = @NotificationId

	END

	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH
END
GO


