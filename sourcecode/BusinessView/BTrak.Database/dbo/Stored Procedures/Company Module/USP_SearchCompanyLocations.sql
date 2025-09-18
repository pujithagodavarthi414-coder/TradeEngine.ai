-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Get the CompanyLocations By Applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_SearchCompanyLocations] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_SearchCompanyLocations]
(
	@CompanyLocationId UNIQUEIDENTIFIER = NULL,
	@LocationName NVARCHAR(250) = NULL,
	@Address      NVARCHAR(250) = NULL,
	@Latitude     FLOAT = NULL,
	@Longitude     FLOAT = NULL,
	@SearchText NVARCHAR(100) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

           IF(@HavePermission = '1')
           BEGIN

	       IF(@CompanyLocationId = '00000000-0000-0000-0000-000000000000') SET  @CompanyLocationId = NULL

	       IF(@LocationName = '') SET  @LocationName = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   SET @SearchText = '%' + @SearchText + '%'

			SELECT CL.Id AS CompanyLocationId,
				   CL.LocationName,
				   CL.[Address],
				   CL.Latitude,
				   CL.Longitude,				  
				   CL.CreatedByUserId,
				   CL.CreatedDateTime,
				   CL.InActiveDateTime,
				   CL.[TimeStamp],
				   IsArchived = CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END,
				   TotalCount = COUNT(1) OVER()
			  FROM [dbo].[CompanyLocation] CL WITH (NOLOCK) 
			  WHERE CL.CompanyId = @CompanyId 
					AND (@CompanyLocationId IS NULL OR CL.Id = @CompanyLocationId)
					AND (@Address IS NULL OR CL.[Address] = @Address)
					AND (@Longitude IS NULL OR CL.Longitude = @Longitude)
					AND (@Latitude IS NULL OR CL.Latitude = @Latitude)			        
					AND (@LocationName IS NULL OR CL.LocationName = @LocationName)								
					AND (@SearchText IS NULL OR (CONVERT(NVARCHAR(250),CL.CreatedDateTime,121) LIKE @SearchText)
					                         OR (CONVERT(NVARCHAR(250),CL.LocationName) LIKE @SearchText) 
											 OR (CONVERT(NVARCHAR(250),CL.[Address]) LIKE @SearchText)
											 OR (CONVERT(NVARCHAR(250),CL.Longitude) LIKE @SearchText)
											 OR (CONVERT(NVARCHAR(250),CL.Latitude) LIKE @SearchText)
								 	          )	
				   AND(@IsArchived IS NULL OR (@IsArchived = 0 AND InActiveDateTime IS NULL) OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))
				ORDER BY CL.LocationName									
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
