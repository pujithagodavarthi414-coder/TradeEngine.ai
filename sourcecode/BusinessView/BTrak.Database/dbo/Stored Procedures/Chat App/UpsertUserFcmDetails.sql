CREATE PROCEDURE [dbo].[UpsertUserFcmDetails]
(
@UserFcmDetailId UNIQUEIDENTIFIER = NULL,
@UserId NVARCHAR(max) = NULL,
@FcmToken NVARCHAR(max) = NULL,
@DeviceUniqueId NVARCHAR(max),
@IsDelete BIT,
@IsFromBTrakMobile BIT,
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	    IF (@HavePermission = '1')
        BEGIN


        IF ((SELECT @DeviceUniqueId FROM [UserFcmDetails] WHERE DeviceUniqueId = @DeviceUniqueId) IS NOT NULL)
        BEGIN
              UPDATE [dbo].[UserFcmDetails]
              SET [FcmToken] = @FcmToken,
			      [IsDelete] = @IsDelete,
				  [UpdatedDateTime] = @Currentdate
              WHERE DeviceUniqueId = @DeviceUniqueId

        END
        ELSE
        BEGIN

		SELECT @UserFcmDetailId = NEWID()
             INSERT INTO [dbo].[UserFcmDetails](
                         [Id],
						 [UserId],
						 [FcmToken],
						 [DeviceUniqueId],
						 [IsDelete],
						 [CreatedDateTime],
						 [IsFromBTrakMobile]
						 )
                  SELECT @UserFcmDetailId,
						 @UserId, 
						 @FcmToken,
						 @DeviceUniqueId,
						 @IsDelete,
						 @Currentdate,
						 @IsFromBTrakMobile
						 
			  END
     END
	 ELSE 
     BEGIN
     
        RAISERROR (@HavePermission,11, 1)
     
     END
    END TRY
    BEGIN CATCH
        
        SELECT ERROR_NUMBER() AS ErrorNumber,
               ERROR_SEVERITY() AS ErrorSeverity,
               ERROR_STATE() AS ErrorState,
               ERROR_PROCEDURE() AS ErrorProcedure,
               ERROR_LINE() AS ErrorLine,
               ERROR_MESSAGE() AS ErrorMessage

    END CATCH
END