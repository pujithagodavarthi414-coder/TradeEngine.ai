CREATE PROCEDURE [dbo].[USP_GetActivityTrackerRecorder](
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
@Mac XML = NULL
)
AS
BEGIN
	 SET NOCOUNT ON
		BEGIN TRY
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			IF(@OperationsPerformedBy IS NULL AND @Mac IS NULL)
			BEGIN
				RAISERROR(50011,11,2,'OperationsPerformedBy')
			END
			ELSE
			BEGIN

				SELECT IsTracking FROM [dbo].[Ufn_GetTrackerConfigAndStatus](@OperationsPerformedBy,NULL, GETUTCDATE(), GETUTCDATE(), 0)

		    END
		END TRY
		
		BEGIN CATCH
        
		    THROW

	    END CATCH
END