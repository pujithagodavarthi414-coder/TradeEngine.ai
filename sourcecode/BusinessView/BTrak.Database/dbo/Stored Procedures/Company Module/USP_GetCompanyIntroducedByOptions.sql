-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-09 00:00:00.000'
-- Purpose      To Get CompanyIntroducedByOptions with different filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetCompanyIntroducedByOptions] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetCompanyIntroducedByOptions]
(
	@CompanyIntroducedByOptionId UNIQUEIDENTIFIER = NULL,
	@Option NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
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
			 
			 IF(@CompanyIntroducedByOptionId = '00000000-0000-0000-0000-000000000000') SET @CompanyIntroducedByOptionId = NULL
			 
			 IF(@Option = '') SET @Option = NULL
			 
			  SELECT CMO.Id AS CompanyIntroducedByOptionId
					,CMO.[Option]
					,CMO.CompanyId
					,CMO.InActiveDateTime
					,CMO.CreatedByUserId
					,CMO.CreatedDateTime
					,CMO.[TimeStamp]
					,CASE WHEN CMO.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
		   			,TotalCount = COUNT(1) OVER()

			    FROM CompanyIntroducedByOption CMO WITH (NOLOCK)
			   WHERE CMO.CompanyId = @CompanyId
				     AND (@CompanyIntroducedByOptionId IS NULL OR CMO.Id = @CompanyIntroducedByOptionId)
				     AND (@Option IS NULL OR CMO.[Option] = @Option)
				     AND (@IsArchived IS NULL 
					      OR (@IsArchived = 1 AND CMO.InActiveDateTime IS NOT NULL) 
					      OR (@IsArchived = 0 AND CMO.InActiveDateTime IS NULL))
			 ORDER BY CMO.[Option]

			END
			ELSE
				RAISERROR (@HavePermission,11, 1)

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH

END
GO