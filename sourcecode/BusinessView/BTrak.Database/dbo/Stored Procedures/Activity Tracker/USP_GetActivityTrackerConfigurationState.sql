---------------------------------------------------------------------------------
---- Author       Praneeth Kumar Reddy Salukooti
---- Created      '2020-03-28 00:00:00.000'
---- Purpose      To Get the toggle state of Manage Activity Tracker
---- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetActivityTrackerConfigurationState]
(
@OperationsPerformedBy UNIQUEIDENTIFIER
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

			SELECT Id, IsBasicTracking, IsTracking, IsScreenshot, IsDelete, DeleteRoles, IsRecord, RecordRoles, IsIdealTime, IdealTimeRoles, IsManualTime, ManualTimeRole, IsOfflineTracking, offlineOpen, IsMouse, MouseRoles, DisableUrls, TimeStamp
							 FROM ActivityTrackerConfigurationState WHERE CompanyId = @CompanyId

		END

	END TRY

	BEGIN CATCH
		
			THROW

	END CATCH
END