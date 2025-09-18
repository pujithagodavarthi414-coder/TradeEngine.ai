-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-30 00:00:00.000'
-- Purpose      To Get the TestRailReport Options
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTestRailReportOptions] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FeatureId = 'a31b0c81-28c4-4920-9f7e-0fd5b52f058f'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetTestRailReportOptions]
(
	@TestRailReportOptionId UNIQUEIDENTIFIER = NULL,
	@FeatureId  UNIQUEIDENTIFIER = NULL,
	@OptionName NVARCHAR(250) = NULL,
	@IsMilestone BIT = NULL,
	@IsTestPlan BIT = NULL,
	@IsTestRun BIT = NULL,
	@IsProject BIT = NULL,
	@OperationsPerformedBy  UNIQUEIDENTIFIER 
)		
AS
BEGIN
    
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
		IF (@HavePermission = '1')
		BEGIN
			
			 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			 SELECT  TRRO.Id AS TestRailReportId, 
			         TRRO.CompanyId,
					 TRRO.OptionName,
					 TRRO.IsMilstone,
					 TRRO.IsPoject,
					 TRRO.IsTestPlan,
					 TRRO.IsTestRun,
					 TRRO.CreatedDateTime,
					 TRRO.CreatedByUserId,
					 TRRO.[TimeStamp],			 
				  	 TotalCount = COUNT(1) OVER()
			    FROM  TestRailReportOption TRRO WITH (NOLOCK) 			    
			   WHERE TRRO.CompanyId = @CompanyId
					AND (@OptionName IS NULL OR TRRO.OptionName = @OptionName)	
					AND (@IsMilestone IS NULL OR TRRO.IsMilstone = 1)
					AND (@IsTestRun IS NULL OR TRRO.IsTestRun = @IsTestRun)
					AND (@IsProject IS NULL OR TRRO.IsPoject = @IsProject)						    
			 ORDER BY TRRO.CreatedDateTime

			END
			ELSE
				RAISERROR (@HavePermission,11, 1)

	END TRY
	BEGIN CATCH
		
		EXEC USP_GetErrorInformation

	END CATCH

END