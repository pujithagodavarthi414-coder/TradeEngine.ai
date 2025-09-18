-------------------------------------------------------------------------------
-- Author       nikhitha yamsani 
-- Created      '2020-01-08 00:00:00.000'
-- Purpose      To Get Rooms By Applying Search Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetRoomsBasedOnSearch]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetRoomsBasedOnSearch]
(
@AmenityId UNIQUEIDENTIFIER=NULL,
@VenueId  UNIQUEIDENTIFIER=NULL,
@TownOrLocality NVARCHAR(MAX)=NULL,
@SearchText NVARCHAR(250) = NULL,
@OperationsPerformedBy  UNIQUEIDENTIFIER,
@PageNo INT = 1,
@SortDirection NVARCHAR(250) = NULL,
@SortBy NVARCHAR(250) = NULL,
@PageSize INT = 10
)
AS
BEGIN
    SET NOCOUNT ON
BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED		
	
	DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
        BEGIN
		 IF(@SearchText = '') SET @SearchText = NULL
          SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'
		   IF(@TownOrLocality = '') SET @TownOrLocality = NULL
			SET @TownOrLocality = '%' + @TownOrLocality + '%'
			SELECT R.Id AS RoomId,
			R.[Name] AS RoomName,
			R.Town,
			R.Locality
			FROM Room R 
			JOIN Venue V ON V.Id = R.VenueId 
			JOIN Organisation O ON O.Id = V.OrganisationId
			LEFT JOIN VenueAmenity VA ON VA.VenueId = V.Id
			LEFT JOIN RoomAmenity RA ON R.Id = RA.RoomId
			INNER JOIN Amenity A ON (A.Id = Ra.AmenityId) OR (A.Id = VA.AmenityId )
			WHERE (@TownOrLocality IS NULL OR R.Town LIKE @TownOrLocality OR R.Locality LIKE @TownOrLocality 
			OR V.Town LIKE @TownOrLocality OR V.Locality LIKE @TownOrLocality 
			OR O.Town LIKE @TownOrLocality OR O.Locality LIKE @TownOrLocality)
			AND (@AmenityId IS NULL OR RA.AmenityId = @AmenityId OR VA.AmenityId = @AmenityId)
			AND (@VenueId IS NULL OR R.VenueId = @VenueId)
			 AND (@SearchText IS NULL OR A.[Name] LIKE  @SearchText)
										
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


