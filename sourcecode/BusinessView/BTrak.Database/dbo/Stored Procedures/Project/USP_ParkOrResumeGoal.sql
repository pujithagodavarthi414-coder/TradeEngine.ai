CREATE PROCEDURE [dbo].[USP_ParkOrResumeGoal]
(
    @GoalId UNIQUEIDENTIFIER,
    @IsGoalPark BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
	@TimeZone NVARCHAR(250) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        DECLARE @ProjectId UNIQUEIDENTIFIER = (
                                                  SELECT [dbo].[Ufn_GetProjectIdByGoalId](@GoalId)
                                              )

        DECLARE @HavePermission NVARCHAR(250)
            =   (
                    SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](   @OperationsPerformedBy,
                                                                         @ProjectId,
                           (
                               SELECT OBJECT_NAME(@@PROCID)
                           )
                                                                     )
                )

        IF (@HavePermission = '1')
        BEGIN
            DECLARE @IsLatest BIT = (CASE
                                         WHEN
                                         (
                                             SELECT [TimeStamp]
                                             FROM [Goal]
                                             WHERE Id = @GoalId
                                                   AND InActiveDateTime IS NULL
                                         ) = @TimeStamp THEN
                                             1
                                         ELSE
                                             0
                                     END
                                    )

            IF (@IsLatest = 1)
            BEGIN

                IF (@IsGoalPark IS NULL)
                    SET @IsGoalPark = 0

               DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
			   SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			
               DECLARE @Currentdate DATETIMEOFFSET =  ISNULL(dbo.Ufn_GetCurrentTime(@Offset),SYSDATETIMEOFFSET())

                DECLARE @NewGoalId UNIQUEIDENTIFIER = NEWID()

                DECLARE @CompanyId UNIQUEIDENTIFIER
                    =   (
                            SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)
                        )

                DECLARE @OldValue NVARCHAR(50) = CASE
                                                     WHEN @IsGoalPark = 1 THEN
                                                         'unparked'
                                                     ELSE
                                                         'parked'
                                                 END

                DECLARE @NewValue NVARCHAR(50) = CASE
                                                     WHEN @IsGoalPark = 1 THEN
                                                         'parked'
                                                     ELSE
                                                         'unparked'
                                                 END

                DECLARE @GoalStatusId UNIQUEIDENTIFIER = (
                                                             SELECT Id
                                                             FROM GoalStatus
                                                             WHERE IsParked = 1
                                                                   AND InActiveDateTime IS NULL
                                                                   --AND CompanyId = @CompanyId
                                                         )

                DECLARE @PreviousGoalStatusId UNIQUEIDENTIFIER = (
                                                                     SELECT GoalStatusId FROM Goal WHERE Id = @GoalId
                                                                 )

                UPDATE [Goal]
                SET GoalStatusId = CASE
                                       WHEN @IsGoalPark = 1 THEN
                                           @GoalStatusId
                                       ELSE
                                           [OldGoalStatusId]
                                   END,
                    [ParkedDateTime] = (CASE
                                            WHEN @IsGoalPark = 1 THEN
                                                @CurrentDate
                                            ELSE
                                                NULL
                                        END
                                       ),
                    [ParkedDateTimeZoneId] = CASE WHEN @IsGoalPark = 1 THEN @TimeZoneId ELSE NULL END,
					[OldGoalStatusId] =  CASE WHEN @IsGoalPark = 1 THEN  @PreviousGoalStatusId ELSE NULL END,
                    [UpdatedDateTime] = @Currentdate,
					[UpdatedDateTimeZoneId] = @TimeZoneId,
                    [UpdatedByUserId] = @OperationsPerformedBy
                WHERE Id = @GoalId


				IF(ISNULL(@IsGoalPark,0) = 0)
				UPDATE [Goal] SET GoalStatusColor = (SELECT [dbo].[Ufn_GoalColour] (@GoalId)) WHERE Id = @GoalId --Handled in Background Process

                INSERT INTO [dbo].[GoalHistory]
                (
                    [Id],
                    [GoalId],
                    [OldValue],
                    [NewValue],
                    [FieldName],
                    [Description],
                    CreatedDateTime,
					CreatedDateTimeZoneId,
                    CreatedByUserId
                )
                SELECT NEWID(),
                       @GoalId,
                       @OldValue,
                       @NewValue,
                       'GoalParked',
                       'GoalParked',
                       SYSDATETIMEOFFSET(),
					   @TimeZoneId,
                       @OperationsPerformedBy

                SELECT Id
                FROM [dbo].[Goal]
                WHERE Id = @NewGoalId

            END
            ELSE
                RAISERROR(50008, 11, 1)
        END
        ELSE
            RAISERROR(@HavePermission, 11, 1)

    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO
