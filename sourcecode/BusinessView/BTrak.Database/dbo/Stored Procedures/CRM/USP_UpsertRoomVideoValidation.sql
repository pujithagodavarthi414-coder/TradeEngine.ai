CREATE PROCEDURE [dbo].[USP_UpsertRoomVideoValidation]
(
	@UniqueName NVARCHAR(250)=NULL,
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

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @RoomCount INT, @CanCreate BIT = 0

		SET @RoomCount = (SELECT COUNT(*) FROM RoomVideoSetup WHERE RoomUniqueName = @UniqueName AND ReferenceId = @ReferenceId AND CompanyId = @CompanyId AND [Status] = 'in-progress' )

		IF(@RoomCount = 0 OR @RoomCount IS NULL)
		BEGIN
			SET @CanCreate = 1
			SELECT @CanCreate
		END
		ELSE
		BEGIN
			SET @CanCreate = 0
			SELECT @CanCreate
		END

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END