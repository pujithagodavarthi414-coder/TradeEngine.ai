-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-01 00:00:00.000'
-- Purpose      To Get the ProcessDashboardStatuses By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetProcessDashboardStatuses] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetProcessDashboardStatuses]
(
   @ProcessDashboardStatusId  UNIQUEIDENTIFIER = NULL,
   @ProcessDashboardStatusName  NVARCHAR(250) = NULL,
   @ProcessDashboardStatusHexaValue  NVARCHAR(250) = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

          DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		  IF (@HavePermission = 1)
		  BEGIN

          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      IF(@ProcessDashboardStatusId = '00000000-0000-0000-0000-000000000000') SET @ProcessDashboardStatusId = NULL

	      IF(@ProcessDashboardStatusName = '') SET @ProcessDashboardStatusName = NULL

	      IF(@ProcessDashboardStatusHexaValue = '') SET @ProcessDashboardStatusHexaValue = NULL

	      SELECT PDS.Id AS ProcessDashboardStatusId,
		         PDS.StatusName AS ProcessDashboardStatusName,
				 PDS.HexaValue AS ProcessDashboardStatusHexaValue,
				 PDS.CompanyId,
				 PDS.CreatedDateTime,
				 PDS.CreatedByUserId,
				 PDS.UpdatedByUserId,
				 PDS.UpdatedDateTime,
				 PDS.[TimeStamp],
				 PDS.ShortName AS StatusShortName,
				 CASE WHEN PDS.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
				 TotalCount = COUNT(1) OVER()
		  FROM  [dbo].[ProcessDashboardStatus] PDS WITH (NOLOCK)
		  WHERE PDS.CompanyId=@CompanyId
	            AND (@ProcessDashboardStatusId IS NULL OR PDS.Id = @ProcessDashboardStatusId)
	            AND (@ProcessDashboardStatusName IS NULL OR PDS.StatusName = @ProcessDashboardStatusName)
	            AND (@ProcessDashboardStatusHexaValue IS NULL OR PDS.HexaValue = @ProcessDashboardStatusHexaValue)
				AND (@IsArchived IS NULL OR (PDS.InActiveDateTime IS NULL OR @IsArchived = 0) OR (PDS.InActiveDateTime IS NOT NULL OR @IsArchived = 1))
		  ORDER BY StatusName ASC

		  END
		  ELSE

		    RAISERROR(@HavePermission,11,1)

	 END TRY  
	 BEGIN CATCH 
		
		  THROW

	END CATCH
END
GO