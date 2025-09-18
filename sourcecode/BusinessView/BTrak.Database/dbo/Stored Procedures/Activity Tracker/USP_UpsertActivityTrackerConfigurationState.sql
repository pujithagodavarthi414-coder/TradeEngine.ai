---------------------------------------------------------------------------------
---- Author       Praneeth Kumar Reddy Salukooti
---- Created      '2020-03-28 00:00:00.000'
---- Purpose      Update Toggle State in Manage Activity Tracker
---- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertActivityTrackerConfigurationState]
(
@ConfigurationStateId UNIQUEIDENTIFIER = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@IsTracking BIT,
@IsBasicTracking BIT,
@IsScreenshot BIT, 
@IsDelete BIT , 
@DeleteRoles BIT , 
@IsRecord BIT , 
@RecordRoles BIT , 
@IsMouse BIT,
@MouseRoles BIT,
@IsIdealTime BIT , 
@IdealTimeRoles BIT , 
@IsManualTime BIT , 
@ManualTimeRole BIT ,
@IsOfflineTracking BIT ,
@offlineOpen BIT,
@TimeStamp TIMESTAMP = NULL,
@DisableUrls BIT
)
AS
BEGIN

SET NOCOUNT ON

	BEGIN  TRY

		DECLARE @HavePermission NVARCHAR(250)  = '1'

		IF (@HavePermission = '1')
        BEGIN
			
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @IsLatest BIT = (CASE WHEN @ConfigurationStateId IS NULL 
			   	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                         FROM [ActivityTrackerConfigurationState] WHERE Id = @ConfigurationStateId AND CompanyId = @CompanyId) = @TimeStamp
			   													THEN 1 ELSE 0 END END)
			IF(@IsLatest = 1)
			BEGIN
				
				
				
				DECLARE @OldIsTracking BIT = NULL
				DECLARE @OldIsBasicTracking BIT = NULL
				DECLARE @OldIsScreenshot BIT = NULL
				DECLARE @OldIsDelete BIT = NULL 
				DECLARE @OldDeleteRoles BIT = NULL 
				DECLARE @OldIsRecord BIT = NULL  
				DECLARE @OldRecordRoles BIT = NULL  
				DECLARE @OldIsMouse BIT = NULL
				DECLARE @OldMouseRoles BIT = NULL
				DECLARE @OldIsIdealTime BIT = NULL 
				DECLARE @OldIdealTimeRoles BIT = NULL
				DECLARE @OldIsManualTime BIT = NULL
				DECLARE @OldManualTimeRole BIT = NULL
				DECLARE @OldIsOfflineTracking BIT = NULL
				DECLARE @OldofflineOpen BIT = NULL
				DECLARE @OldTimeStamp TIMESTAMP = NULL
				DECLARE @OldDisableUrls BIT = NULL
				DECLARE @OldValue NVARCHAR(MAX)
				DECLARE @NewValue NVARCHAR(MAX)

				SELECT @OldIsTracking = IsTracking ,
					   @OldIsBasicTracking = IsBasicTracking,
					   @OldIsScreenshot = IsScreenshot ,
					   @OldIsDelete = IsDelete ,
					   @OldDeleteRoles = DeleteRoles ,
					   @OldIsRecord = IsRecord ,
					   @OldRecordRoles = RecordRoles ,
					   @OldIsIdealTime = IsIdealTime ,
					   @OldIdealTimeRoles = IdealTimeRoles ,
					   @OldIsManualTime = IsManualTime ,
					   @OldManualTimeRole = ManualTimeRole,
					   @OldIsOfflineTracking = IsOfflineTracking,
					   @OldofflineOpen = offlineOpen,
					   @OldIsMouse = IsMouse,
					   @OldMouseRoles = MouseRoles,
					   @OldDisableUrls = DisableUrls
					   FROM ActivityTrackerConfigurationState WHERE CompanyId = @CompanyId

				IF(@ConfigurationStateId IS NULL)
				BEGIN
					DECLARE @Id UNIQUEIDENTIFIER = NEWID()

					INSERT INTO ActivityTrackerConfigurationState ( Id, IsBasicTracking, IsTracking, IsScreenshot, IsDelete, DeleteRoles, IsRecord, RecordRoles, IsIdealTime, IdealTimeRoles, IsManualTime, ManualTimeRole, IsOfflineTracking, offlineOpen, IsMouse, MouseRoles, CompanyId, DisableUrls)
					
					VALUES ( @Id, @IsBasicTracking, @IsTracking, @IsScreenshot, @IsDelete, @DeleteRoles, @IsRecord, @RecordRoles, @IsIdealTime, @IdealTimeRoles, @IsManualTime, @ManualTimeRole, @IsOfflineTracking, @offlineOpen, @IsMouse, @MouseRoles, @CompanyId, @DisableUrls)

				END
				ELSE
				BEGIN

					UPDATE ActivityTrackerConfigurationState 
							SET IsTracking = @IsTracking ,
								IsBasicTracking = @IsBasicTracking,
								IsScreenshot = @IsScreenshot ,
								IsDelete = @IsDelete ,
								DeleteRoles = @DeleteRoles ,
								IsRecord = @IsRecord ,
								RecordRoles = @RecordRoles ,
								IsIdealTime = @IsIdealTime ,
								IdealTimeRoles = @IdealTimeRoles ,
								IsManualTime = @IsManualTime ,
								ManualTimeRole = @ManualTimeRole,
								IsOfflineTracking = @IsOfflineTracking,
								offlineOpen = @offlineOpen,
								IsMouse = @IsMouse,
								MouseRoles = @MouseRoles,
								DisableUrls = @DisableUrls
						WHERE CompanyId = @CompanyId

				END

				SET @OldValue = IIF(@OldIsTracking = 0,'Disabled','Enabled')
				SET @NewValue = IIF(@IsTracking = 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Track apps and urls',
				@FieldName = 'TrackingEnable',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId

				SET @OldValue = IIF(@OldIsBasicTracking = 0,'Disabled','Enabled')
				SET @NewValue = IIF(@IsBasicTracking = 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Basic tracking',
				@FieldName = 'BasicTracking',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId

				SET @OldValue = IIF(@OldDisableUrls= 0,'Disabled','Enabled')
				SET @NewValue = IIF(@DisableUrls = 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Track apps and urls',
				@FieldName = 'DisableUrlsEnable',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId

				SET @OldValue = IIF(@OldIsScreenshot = 0,'Disabled','Enabled')
				SET @NewValue = IIF(@IsScreenshot = 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Screenshot frequency',
				@FieldName = 'Screenshot',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId

				SET @OldValue = IIF(@OldIsDelete = 0,'Disabled','Enabled')
				SET @NewValue = IIF(@IsDelete = 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Delete screenshots',
				@FieldName = 'DeleteScreenShot',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId


				SET @OldValue = IIF(@OldDeleteRoles = 0,'Disabled','Enabled')
				SET @NewValue = IIF(@DeleteRoles = 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Delete screenshots',
				@FieldName = 'DeleteRoles',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId

				SET @OldValue = IIF(@OldIsRecord = 0,'Disabled','Enabled')
				SET @NewValue = IIF(@IsRecord = 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Key board strokes tracking',
				@FieldName = 'KeyBoard',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId
				
				SET @OldValue = IIF(@OldRecordRoles = 0,'Disabled','Enabled')
				SET @NewValue = IIF(@RecordRoles = 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Key board strokes tracking',
				@FieldName = 'KeyBoardRoles',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId

				SET @OldValue = IIF(@OldIsMouse = 0,'Disabled','Enabled')
				SET @NewValue = IIF(@IsMouse = 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Mouse clicks tracking',
				@FieldName = 'Mouse',@OldValue = @OldValue,@NewValue = @NewValue , @CompanyId = @CompanyId

				SET @OldValue = IIF(@OldMouseRoles = 0,'Disabled','Enabled')
				SET @NewValue = IIF(@MouseRoles= 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Mouse clicks tracking',
				@FieldName = 'MouseRoles',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId

				SET @OldValue = IIF(@OldIsIdealTime = 0,'Disabled','Enabled')
				SET @NewValue = IIF(@IsIdealTime = 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Idle time',
				@FieldName = 'IdealTime',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId

				SET @OldValue = IIF(@OldIdealTimeRoles = 0,'Disabled','Enabled')
				SET @NewValue = IIF(@IdealTimeRoles = 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Idle time',
				@FieldName = 'IdealTimeRoles',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId

				SET @OldValue = IIF(@OldIsOfflineTracking = 0,'Disabled','Enabled')
				SET @NewValue = IIF(@IsOfflineTracking = 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Offline tracking',
				@FieldName = 'OfflineTracking',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId

				SET @OldValue = IIF(@OldOfflineOpen = 0,'Disabled','Enabled')
				SET @NewValue = IIF(@OfflineOpen = 0,'Disabled','Enabled')
				    
				IF(@OldValue <> @NewValue)
				EXEC [dbo].[USP_UpsertActivityTrackerHistory] @OperationsPerformedBy = @OperationsPerformedBy,@Category = 'Offline tracking',
				@FieldName = 'OfflineTrackingRoles',@OldValue = @OldValue,@NewValue = @NewValue, @CompanyId = @CompanyId

				SELECT TimeStamp FROM ActivityTrackerConfigurationState WHERE CompanyId = @CompanyId
			END


			ELSE	
			BEGIN
				RAISERROR (50008,11, 1)
			END
		END

	END TRY

	BEGIN CATCH
		
			THROW

	END CATCH
END