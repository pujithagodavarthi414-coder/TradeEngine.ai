CREATE PROCEDURE [dbo].[USP_UpsertActivityTrackerUserConfiguration]
(
@Id UNIQUEIDENTIFIER = NULL,
@Track BIT = NULL,
@UserId UNIQUEIDENTIFIER,
@EmployeeId UNIQUEIDENTIFIER,
@AppUrlId UNIQUEIDENTIFIER,
@ScreenshotFrequency INT = NULL,
@Multiplier INT = NULL,
@IsTrack BIT = NULL,
@IsScreenshot BIT = NULL,
@IsKeyboardTracking BIT = NULL,
@IsMouseTracking BIT = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

SET NOCOUNT ON

	BEGIN TRY
	
		DECLARE @HavePermission NVARCHAR(250)  = '1'

		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
        IF(@AppUrlId = '00000000-0000-0000-0000-000000000000') SET @AppUrlId = NULL

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        IF(@AppUrlId IS NULL)
        BEGIN
            RAISERROR(50011,11,2,'AppUrlId')
        END
        ELSE
		BEGIN
			IF (@HavePermission = '1')
			BEGIN
				DECLARE @IsLatest BIT = (CASE WHEN @Id IS NULL 
			   	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                         FROM [ActivityTrackerUserConfiguration] WHERE Id = @Id) = @TimeStamp
			   													THEN 1 ELSE 0 END END)
				IF(@IsLatest = 1)
				BEGIN
					IF(@Id IS NULL)
					BEGIN
						SET @Id = (SELECT NEWID())

						INSERT INTO [ActivityTrackerUserConfiguration]( 
																Id,
																UserId,
																ActivityTrackerAppUrlTypeId,
																ScreenShotFrequency,
																Multiplier,
																IsTrack,
																IsScreenshot,
																IsKeyboardTracking,
																IsMouseTracking,
																CreatedByUserId,
																CreatedDateTime,
																ComapnyId
																)
														SELECT @Id,
															   @UserId,
															   @AppUrlId,
															   @ScreenshotFrequency,
															   @Multiplier,
															   @IsTrack,
															   @IsScreenshot,
															   @IsKeyboardTracking,
															   @IsMouseTracking,
															   @OperationsPerformedBy,
															   GETDATE(),
															   @CompanyId

							UPDATE [Employee] SET TrackEmployee = @Track
											WHERE UserId =  @UserId AND Id = @EmployeeId

						SELECT @Id AS Id, FirstName, SurName AS LastName, UserName AS WorkEmail FROM [User] WHERE Id = @UserId AND CompanyId = @CompanyId			  
					END
					ELSE
					BEGIN
						UPDATE [ActivityTrackerUserConfiguration] SET 
															ActivityTrackerAppUrlTypeId = @AppUrlId,
															ScreenShotFrequency = @ScreenshotFrequency,
															Multiplier = @Multiplier,
															IsTrack = @IsTrack,
															IsScreenshot = @IsScreenshot,
															IsKeyboardTracking = @IsKeyboardTracking,
															IsMouseTracking = @IsMouseTracking,
															UpdatedByUserId = @OperationsPerformedBy,
															UpdatedDateTime = GETDATE(),
															ComapnyId =  @CompanyId
													WHERE UserId = @UserId AND ComapnyId =  @CompanyId
						UPDATE [Employee] SET TrackEmployee = @Track
											WHERE UserId =  @UserId AND Id = @EmployeeId

						SELECT @Id AS Id, FirstName, SurName AS LastName, UserName AS WorkEmail FROM [User] WHERE Id = @UserId AND CompanyId = @CompanyId
					END
				END
				ELSE
				BEGIN
					RAISERROR (50008,11, 1)
				END
			END
			ELSE
			BEGIN
			         
			    RAISERROR (@HavePermission,11, 1)
			         		
			END
		END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END