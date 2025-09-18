--EXEC [USP_GetLeaveFrequency] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetMasterLeaveTypes]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN

			SELECT MLT.Id AS MasterLeaveTypeId,
				   MLT.MasterLeaveTypeName,
				   MLT.IsCasualLeave,
				   MLT.IsOnSite,
				   MLT.IsSickLeave,
				   MLT.IsWithoutIntimation,
				   MLT.IsWorkFromHome,
				   TotalCount = COUNT(1)OVER()
			       FROM MasterLeaveType MLT
		END
		ELSE
			
			RAISERROR(@HavePermission,11,1)
   END TRY
   BEGIN CATCH

	THROW

   END CATCH
END
GO

