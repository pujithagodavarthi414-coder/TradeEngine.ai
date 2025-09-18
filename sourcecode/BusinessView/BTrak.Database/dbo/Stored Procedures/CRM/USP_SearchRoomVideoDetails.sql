CREATE PROCEDURE [dbo].[USP_SearchRoomVideoDetails]
(
	@UniqueName NVARCHAR(250),
	@Status NVARCHAR(100) = NULL,
	@ReferenceId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = '1'

		IF (@HavePermission = '1')
		BEGIN
			SELECT TOP(1)[Id] AS Id,
						 [RoomUniqueName] AS [Name],
						 [RoomSid] AS RoomSid,
						 [Status],
						 [ReferenceId] AS ReceiverId,
						 [CompanyId],
						 [CreatedByUserId] 
				FROM [RoomVideoSetup] 
				WHERE RoomUniqueName = @UniqueName
					AND (@ReferenceId IS NULL OR ReferenceId = @ReferenceId)
				ORDER BY CreatedDateTime DESC

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