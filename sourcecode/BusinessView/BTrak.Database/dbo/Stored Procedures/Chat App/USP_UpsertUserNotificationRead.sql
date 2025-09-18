-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-19 00:00:00.000'
-- Purpose      To Save UserNotificationRead
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertUserNotificationRead] @OperationsPerformedBy='184E0507-BBFB-4F4B-8FE4-07B36028C67F'
--,@NotificationIdXml = '<GenericListOfNullableOfGuid><ListItems><guid>2DD805F3-564B-4DB9-B06B-BF97EB0274FE</guid>
--</ListItems></GenericListOfNullableOfGuid>'
--,@UserId = '0019AF86-8618-4F46-9DFA-A41D9E98275F'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertUserNotificationRead]
(
    @NotificationIdXml XML = NULL,
    @UserId UNIQUEIDENTIFIER = NULL,
    @ReadDateTime DATETIME = NULL,
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

    CREATE TABLE #UserNotifications
     (
            UserNotificationId UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID()
           ,NotificationId UNIQUEIDENTIFIER
           ,Id UNIQUEIDENTIFIER
		   ,UserId UNIQUEIDENTIFIER
     )

     IF (@UserId IS NULL) SET @UserId = @OperationsPerformedBy

     IF(@NotificationIdXml IS NOT NULL) 
     BEGIN
       
       INSERT INTO #UserNotifications(NotificationId)
       SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
       FROM @NotificationIdXml.nodes('/GenericListOfNullableOfGuid/ListItems/guid') X(Y)

       UPDATE #UserNotifications SET Id = UNR.Id,UserId = UNR.UserId 
       FROM  UserNotificationRead UNR 
             INNER JOIN #UserNotifications US ON UNR.NotificationId = US.NotificationId AND UNR.InActiveDateTime IS NULL
    END
    ELSE 
        RAISERROR(50011,11,1,'Notification')
	
     DECLARE @NewUserNotificationReadId UNIQUEIDENTIFIER = NEWID()
   
     INSERT INTO [dbo].[UserNotificationRead](
                        Id,
                        NotificationId,
                        UserId,
                        ReadDateTime,
                        CreatedDateTime,
                        CreatedByUserId
                        )
                 SELECT UserNotificationId,
                        NotificationId,
                        ISNULL(@UserId,UserId),
                        @ReadDateTime,
                        @Currentdate,
                        @OperationsPerformedBy
                FROM #UserNotifications UN

	IF(@ReadDateTime IS NOT NULL)
	BEGIN
       UPDATE [UserNotificationRead] SET InActiveDateTime = @CurrentDate 
       FROM  UserNotificationRead UNR 
             INNER JOIN #UserNotifications US ON UNR.NotificationId = US.NotificationId
			 AND UNR.Id <> US.UserNotificationId 
   END
      SELECT UserNotificationId FROM #UserNotifications
    END
	END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO