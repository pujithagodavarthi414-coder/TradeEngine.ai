CREATE PROCEDURE [dbo].[USP_UpsertVideoCallLog]
(
	@VideoCallLogId UNIQUEIDENTIFIER = NULL,
	@ReceiverId UNIQUEIDENTIFIER = NULL,
	@CompositionSid NVARCHAR(200) = NULL,
	@RoomSid NVARCHAR(200) = NULL,
	@RoomName NVARCHAR(200) = NULL,
	@VideoRecordingLink NVARCHAR(MAX) = null,
	@FileName NVARCHAR(1000) = NULL,
	@Extension NVARCHAR(100) = NULL,
	@Type NVARCHAR(100) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
        
		DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()
	    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @IsExists BIT = 0

		IF(@CompositionSid IS NOT NULL)
		BEGIN
			DECLARE @Value NVARCHAR(200) = (SELECT @CompositionSid FROM CRMVideoLog WHERE CompositionSid = @CompositionSid)
			IF(@Value <> '' AND @Value IS NOT NULL AND @Value = @CompositionSid)
			BEGIN
				SET @IsExists = 1
			END
		END

		IF(@VideoCallLogId IS NOT NULL OR (@CompositionSid IS NOT NULL AND @IsExists = 1))
		BEGIN
			
			UPDATE [dbo].[CRMVideoLog]
				SET [ReceiverId] = @ReceiverId,
					[VideoRecordingLink] = @VideoRecordingLink,
					[RoomName] = @RoomName,
					[FileName] = @FileName,
					[Type] = @Type,
					[Extension] = @Extension,
					[UpdatedByUserId] = @OperationsPerformedBy,
					[UpdatedDateTime] = @Currentdate,
					[CompanyId] = @CompanyId,
					[RoomSid] = @RoomSid,
					[CompositionSid] = @CompositionSid
				WHERE Id = @VideoCallLogId OR CompositionSid = @CompositionSid

		END
		ELSE
		BEGIN
			SET @VideoCallLogId = (SELECT NEWID())
			INSERT INTO [dbo].[CRMVideoLog](
								[Id],
								[ReceiverId],
								[VideoRecordingLink],
								[RoomName],
								[RoomSid],
								[CompositionSid],
								[VideoCallDateTime],
								[FileName],
								[Type],
								[Extension],
								[CompanyId],
								[CreatedByUserId],
								[CreatedDateTime]
								)
						SELECT @VideoCallLogId,
							   @ReceiverId,
							   @VideoRecordingLink,
							   @RoomName,
							   @RoomSid,
							   @CompositionSid,
							   @Currentdate,
							   @FileName,
							   @Type,
							   @Extension,
							   @CompanyId,
							   @OperationsPerformedBy,
							   @Currentdate

		END

		SELECT Id FROM [dbo].[CRMVideoLog] WHERE Id = @VideoCallLogId

	END TRY
	BEGIN CATCH 
		
		EXEC USP_GetErrorInformation

	END CATCH

END
