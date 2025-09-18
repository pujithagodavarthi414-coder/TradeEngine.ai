-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-01 00:00:00.000'
-- Purpose      To Get the ProcessDashboardStatuses By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetProcessDashboardStatusById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ProcessDashboardStatusId='D70543D9-691F-44D9-BD80-4E23CCA3B3BF'

CREATE PROCEDURE [dbo].[USP_GetProcessDashboardStatusById]
(
	@ProcessDashboardStatusId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

 SET NOCOUNT ON

	 BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        SELECT PDS.Id AS ProcessDashboardStatusId,
		         PDS.StatusName AS ProcessDashboardStatusName,
				 PDS.HexaValue AS ProcessDashboardStatusHexaValue,
				 PDS.CompanyId,
				 PDS.CreatedDateTime,
				 PDS.CreatedByUserId,
				 PDS.UpdatedByUserId,
				 PDS.UpdatedDateTime
		  FROM  [dbo].[ProcessDashboardStatus] PDS WITH (NOLOCK)
	      WHERE PDS.CompanyId = @CompanyId AND PDS.Id = @ProcessDashboardStatusId

	END TRY  
	BEGIN CATCH 
		
		 THROW

	END CATCH

END