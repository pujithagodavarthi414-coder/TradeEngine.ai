-------------------------------------------------------------------------------
-- Author       Anupam sai kumar Vuyyuru
-- Created      '2020-02-03 00:00:00.000'
-- Purpose      To Get the ObservationTypes By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetObservationTypes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetObservationTypes]
(
  @ObservationTypeId UNIQUEIDENTIFIER = NULL,
  @ObservationTypeName NVARCHAR(150) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @IsArchived BIT = NULL	
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
	       IF(@ObservationTypeId = '00000000-0000-0000-0000-000000000000') SET  @ObservationTypeId = NULL
	       IF(@ObservationTypeName = '') SET  @ObservationTypeName = NULL
	       SELECT OT.Id AS ObservationTypeId,
		          OT.ObservationName AS ObservationTypeName,
		          OT.CompanyId,
				  OT.CreatedByUserId,
				  OT.CreatedDateTime,
		          OT.[TimeStamp],	
				  CASE WHEN OT.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
		   FROM  [dbo].[ObservationType] OT WITH (NOLOCK)
		   WHERE OT.CompanyId = @CompanyId
		         AND ((@ObservationTypeId IS NULL OR OT.Id = @ObservationTypeId))
		         AND (@ObservationTypeName IS NULL OR OT.ObservationName = @ObservationTypeName)
				 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND OT.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND OT.InActiveDateTime IS NULL))
		   ORDER BY ObservationName ASC 	
	 
	    END	    
		ELSE
        BEGIN
                
				RAISERROR (@HavePermission,11, 1)
                   
        END
	 END TRY
	 BEGIN CATCH
		  THROW
	END CATCH
END
GO