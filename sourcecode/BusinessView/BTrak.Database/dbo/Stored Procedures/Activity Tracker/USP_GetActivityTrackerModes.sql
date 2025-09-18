CREATE PROCEDURE [dbo].[USP_GetActivityTrackerModes](
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	 SET NOCOUNT ON
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRY
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
						 
			IF (@HavePermission = '1')
			BEGIN
				SELECT * FROM [dbo].[ActivityTrackerMode]
			END
		END TRY
		
		BEGIN CATCH        
            THROW
        END CATCH
END
GO