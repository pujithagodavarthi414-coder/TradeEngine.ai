-------------------------------------------------------------------------------
-- Author       nikhitha yamsani 
-- Created      '2020-01-08 00:00:00.000'
-- Purpose      To Get Rooms and Venue Amenities
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetRoomAndVenuAmenities]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetRoomAndVenuAmenities]
(
@AmenityId UNIQUEIDENTIFIER=NULL,
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
		 BEGIN
          SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

		SELECT AmenityId,A.[Name] AmenityName FROM RoomAmenity RA JOIN Amenity A ON A.Id = RA.AmenityId
		Where (@AmenityId is NULL or A.Id= @AmenityId)
           AND (@SearchText IS NULL OR  A.[Name] LIKE @SearchText) 
		UNION 
		SELECT AmenityId,A.[Name] AmenityName FROM VenueAmenity VA JOIN Amenity A ON A.Id = VA.AmenityId

		 Where (@AmenityId is NULL or A.Id= @AmenityId)
           AND (@SearchText IS NULL OR  A.[Name] LIKE @SearchText)       
		END
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

