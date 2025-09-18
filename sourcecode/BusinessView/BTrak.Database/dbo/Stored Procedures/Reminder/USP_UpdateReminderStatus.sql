-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To update Reminder status
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_UpdateReminderStatus] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [USP_UpdateReminderStatus]
(
	@ReminderId UNIQUEIDENTIFIER = NULL, 
    @Status NVARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
		 UPDATE [Reminder]
			SET [Status] = @Status
			 WHERE Id = @ReminderId
		
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO
