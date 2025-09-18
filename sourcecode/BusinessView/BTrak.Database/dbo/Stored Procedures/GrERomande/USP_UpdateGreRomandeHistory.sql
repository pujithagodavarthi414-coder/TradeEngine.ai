CREATE PROCEDURE [dbo].[USP_UpdateGreRomandeHistory]
	@GreRomandeHistoryId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	      UPDATE [dbo].[GreRomandeEHistory]
		  SET InActiveDateTime = GETDATE(),
		      UpdatedByUserId = @OperationsPerformedBy,
			  UpdatedByDateTime = GETDATE()
			WHERE Id = @GreRomandeHistoryId

		  SELECT @GreRomandeHistoryId
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO

