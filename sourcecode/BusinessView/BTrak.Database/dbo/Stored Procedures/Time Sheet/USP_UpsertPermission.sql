-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-01-29 00:00:00.000'
-- Purpose      To Save or Update the Permission
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertPermission] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserId='127133F1-4427-4149-9DD6-B02E0E036972',
 --@Date='2019-06-11 18:32:42.437',@PermissionReasonId='888DC899-7F61-46D7-8F7B-14AA223A3D65'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPermission]
(
  @PermissionId UNIQUEIDENTIFIER = NULL,
  @UserId UNIQUEIDENTIFIER = NULL,
  @Date  DateTime = NULL,
  @Duration TIME = NULL,
  @Ismorning BIT =NULL,
  @ISDeleted BIT = NULL,
  @IsArchived BIT =NULL,
  @TimeStamp TIMESTAMP = NULL,
  @PermissionReasonId  UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
 SET NOCOUNT ON
 BEGIN TRY
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

     IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

     IF (@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

     IF (@PermissionReasonId = '00000000-0000-0000-0000-000000000000') SET @PermissionReasonId = NULL

     DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

     IF (@HavePermission = '1')
     BEGIN

        IF(@UserId IS NULL)
        BEGIN
              
               RAISERROR(50011,16, 2, 'User')

        END
        ELSE IF(@Date IS NULL)
        BEGIN
              
               RAISERROR(50011,16, 2, 'Date')

        END
        ELSE IF(@PermissionReasonId IS NULL)
        BEGIN
              
               RAISERROR(50011,16, 2, 'Reason')

        END
        ELSE
        BEGIN
        
          
        
        

            DECLARE @PermissionIdCount INT = (SELECT COUNT(1) FROM [Permission] WHERE Id = @PermissionId)

            IF(@PermissionIdCount = 0 AND @PermissionId IS NOT NULL)
            BEGIN

                RAISERROR(50002,16, 1,'Permission')

            END

            ELSE
            BEGIN
                
                DECLARE @IsLatest BIT = (CASE WHEN @PermissionId IS NULL THEN 1 ELSE
                                         CASE WHEN (SELECT [TimeStamp] FROM Permission
                                                    WHERE Id = @PermissionId ) = @TimeStamp THEN 1 ELSE 0 END
                                         END)

				IF (@IsLatest = 1)
				BEGIN

					DECLARE @CurrentDate DATETIME = GETDATE()

				    DECLARE @NewPermissionId UNIQUEIDENTIFIER = NEWID()

				    DECLARE @TimeInMin INT = (SELECT DATEPART(HOUR,@Duration) * 60) + (SELECT DATEPART(MINUTE,@Duration))

					IF(@TimeInMin = 0)
					BEGIN

							RAISERROR('PleaseEnterValidTime',16,2)

					END

					ELSE
					BEGIN

					    IF(@PermissionId IS NULL)
						BEGIN

						SET @PermissionId = NEWID()

						 INSERT INTO Permission (
							                    Id,
						                        UserId,
						                        [Date],
						                        CreatedDateTime,
						                        CreatedByUserId,
						                        IsMorning,
						                        IsDeleted,
						                        Duration,
						                        DurationInMinutes,
						                        PermissionReasonId,
						                        InActiveDateTime
						                       )

						                 SELECT @PermissionId,
						                        @UserId,
						                        @Date,
						                        @CurrentDate,
						                        @OperationsPerformedBy,
						                        @Ismorning,
						                        @IsDeleted,
						                        @Duration,
						                        @TimeInMin,
						                        @PermissionReasonId,
						                        CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END

							END
							ELSE
							BEGIN

							UPDATE [Permission]
							   SET  [UserId] = @UserId,
						            [Date] = @Date,
						            UpdatedDateTime = @CurrentDate,
						            UpdatedByUserId = @OperationsPerformedBy,
						            IsMorning = @Ismorning,
						            IsDeleted = @ISDeleted,
						            Duration = @Duration,
						            DurationInMinutes = @TimeInMin,
						            PermissionReasonId = @PermissionReasonId,
						            InActiveDateTime  = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
									WHERE Id = @PermissionId

							END


						SELECT Id FROM Permission WHERE Id = @PermissionId
					END

				  END
				  ELSE
				         
				        RAISERROR(50008,16,1)

				  END

			END

    END
    ELSE

        RAISERROR(@HavePermission,16,1)


    END TRY
    BEGIN CATCH

       THROW

    END CATCH
END
GO