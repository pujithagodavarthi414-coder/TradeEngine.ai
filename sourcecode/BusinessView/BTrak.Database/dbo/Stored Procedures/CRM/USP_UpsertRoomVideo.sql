CREATE PROCEDURE [dbo].[USP_UpsertRoomVideo]
(
	@UniqueName NVARCHAR(250),
	@Status NVARCHAR(100),
	@ReferenceId UNIQUEIDENTIFIER,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@Id UNIQUEIDENTIFIER = NULL,
	@RoomSid NVARCHAR(1000) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @CurrentDate DATETIME = GETDATE()
	    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		
		DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF(@Id IS NULL)
			BEGIN
				SET @Id = (SELECT NEWID())
				INSERT INTO [dbo].[RoomVideoSetup]([Id],
												   [RoomUniqueName],
												   [Status],
												   [RoomSid],
												   [ReferenceId],
												   [CompanyId],
												   [CreatedByUserId],
												   [CreatedDateTime]
												)
									SELECT @Id,
										   @UniqueName,
										   @Status,
										   @RoomSid,
										   @ReferenceId,
										   @CompanyId,
										   @OperationsPerformedBy,
										   @CurrentDate
			END
			ELSE
			BEGIN
				UPDATE [dbo].[RoomVideoSetup] SET
									[RoomUniqueName] = @UniqueName,
									[Status] = @Status,
									[ReferenceId] = @ReferenceId,
									[RoomSid] = @RoomSid,
									[UpdatedByUserId] = @OperationsPerformedBy,
									[UpdatedDateTime] = @CurrentDate
						WHERE Id = @Id
			END
					SELECT @Id
		END
		ELSE
		BEGIN
				     
			RAISERROR (@HavePermission,11, 1)
				     		
		END
	END TRY  
	BEGIN CATCH 
		THROW
	END CATCH
END
