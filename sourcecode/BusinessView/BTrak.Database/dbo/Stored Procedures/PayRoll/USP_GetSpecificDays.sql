-------------------------------------------------------------------------------
-- Author       Aswani
-- Created      '2019-06-04 00:00:00.000'
-- Purpose      To Get the SpecificDays By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetSpecificDays] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetSpecificDays]
(
  @SpecificDayId UNIQUEIDENTIFIER = NULL,
  @SearchText NVARCHAR(250) = NULL,
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
		   
	        IF(@SpecificDayId = '00000000-0000-0000-0000-000000000000') SET  @SpecificDayId = NULL
		   
	           SELECT SD.Id AS SpecificDayId,
		              SD.Reason,
			    	  Archived = CASE WHEN SD.InActiveDateTime IS NULL THEN 0 ELSE 1 END,
		              SD.CompanyId,
					  SD.[Date],
		              SD.CreatedByUserId,
			    	  SD.CreatedDateTime,
			    	  SD.[TimeStamp],
		              TotalCount = COUNT(1) OVER()
		       FROM  [dbo].[SpecificDay] SD WITH (NOLOCK)
		       WHERE SD.CompanyId = @CompanyId 
		             AND (@SpecificDayId IS NULL OR SD.Id = @SpecificDayId)
		             AND (@IsArchived IS NULL 
					      OR (@IsArchived = 0 AND SD.InActiveDateTime IS NULL)
			    	      OR (@IsArchived = 1 AND SD.InActiveDateTime IS NOT NULL))
		       ORDER BY [Date]
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