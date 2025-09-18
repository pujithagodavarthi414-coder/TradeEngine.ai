-------------------------------------------------------------------------------
-- Author       nikhitha yamsani 
-- Created      '2020-01-07 00:00:00.000'
-- Purpose      To Get Room and Venue Amenities
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetAllAmenities]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetAllAmenities]
(
  @AmenityId UNIQUEIDENTIFIER=NULL,
  @RoomId UNIQUEIDENTIFIER = NULL,
  @VenueId UNIQUEIDENTIFIER = NULL,
  @RoomAmenityId UNIQUEIDENTIFIER = NULL,
  @VenueAmenityId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy  UNIQUEIDENTIFIER,
  @SearchText NVARCHAR(250) = NULL,
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
        
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
       
	   IF (@HavePermission = '1')
        BEGIN
          IF(@AmenityId = '00000000-0000-0000-0000-000000000000') SET @AmenityId = NULL
          IF(@RoomId = '00000000-0000-0000-0000-000000000000') SET @RoomId = NULL
          IF(@VenueId = '00000000-0000-0000-0000-000000000000') SET @VenueId = NULL
          IF(@SearchText = '') SET @SearchText = NULL
          SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'
            SELECT A.Id AS AmenityId,
                   A.[Name] AS AmenityName,
                   A.[Description],
                   RA.RoomId,
				   V.VenueId,
				   V.Id AS VenueAmenityId,
				   RA.Id AS RoomAmenityId,
                  CASE WHEN A.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
           FROM  [dbo].[Amenity] A  WITH (NOLOCK)
           LEFT JOIN [dbo].[RoomAmenity] AS RA ON RA.AmenityId = A.Id
		   LEFT JOIN [dbo].[VenueAmenity] AS V ON V.AmenityId = A.Id
           Where (@AmenityId is NULL or A.Id= @AmenityId)
		   AND (@RoomAmenityId is NULL or RA.Id= @RoomAmenityId)
		   AND (@VenueAmenityId is NULL or V.Id= @VenueAmenityId)
           AND (@SearchText IS NULL OR  A.[Name] LIKE @SearchText)
           ORDER BY
           CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy IS NULL OR @SortBy = 'Amenity') THEN Name
                              END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                       CASE WHEN(@SortBy IS NULL OR @SortBy = 'Amenity') THEN Name
                              END
                      END DESC
          OFFSET ((@PageNo - 1) * @PageSize) ROWS
         FETCH NEXT @PageSize ROWS ONLY
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
 