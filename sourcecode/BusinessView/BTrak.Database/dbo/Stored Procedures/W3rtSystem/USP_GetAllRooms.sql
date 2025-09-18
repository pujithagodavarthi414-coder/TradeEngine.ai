-------------------------------------------------------------------------------
-- Author       kandapu sushmitha 
-- Created      '2019-12-27 00:00:00.000'
-- Purpose      To Get All rooms By Applying venue Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetAllRooms]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'  ,@DateFrom='2020-01-08 12:27:15.757' , @DateTo='2020-01-08 12:27:15.757'

CREATE PROCEDURE [dbo].[USP_GetAllRooms]
(
  @RoomId UNIQUEIDENTIFIER = NULL,
  @RoomName NVARCHAR(250) = NULL,
  @OperationsPerformedBy  UNIQUEIDENTIFIER,
  @VenueId XML = NULL,
  @SearchText NVARCHAR(250) = NULL,
  @OrganisationId XML = NULL,
  @PageNo INT = 1,
  @SortDirection NVARCHAR(250) = NULL,
  @SortBy NVARCHAR(250) = NULL,
  @PageSize INT = 10,
  @DateFrom DATETIME = NULL,
  @DateTo DATETIME = NULL,
  @IsActive BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        IF (@HavePermission = '1')
        BEGIN
         
          
          IF(@RoomId = '00000000-0000-0000-0000-000000000000') SET @RoomId = NULL
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
          
          
		  DECLARE @VenueIdList TABLE
			(
				VenueId UNIQUEIDENTIFIER NULL
			)
		 DECLARE @OrganisationIdList TABLE
			(
				OrganisationId UNIQUEIDENTIFIER NULL
			)
		IF(@VenueId Is NOT NULL)
		BEGIN
			INSERT INTO @VenueIdList (VenueId)
				SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
				FROM  @VenueId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
		END
		IF(@OrganisationId Is NOT NULL)
		BEGIN
			INSERT INTO @OrganisationIdList (OrganisationId)
				SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
				FROM  @OrganisationId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
        END 
          IF(@SearchText = '') SET @SearchText = NULL
          SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'
		  
           SELECT R.Id AS RoomId,
                  R.Name AS RoomName,
                  R.VenueId,
                  R.ImageJson,
				  R.Town,
				  R.Locality,
				  V.OrganisationId,
				  V.Name AS VenueName,
                  R.CreatedDateTime,
                  R.CreatedByUserId,
				  ISNULL(RC.Cost,0.0) AS Price,
				  ISNULL(RC.Tax,0.0),
				  RC.DepositAmount,
                  R.UpdatedDateTime,
				  R.Description ,
				  R.Video,
                  R.UpdatedByUserId,
                  O.Name  as OrganisationName,
                  R.[Timestamp],
                  CASE WHEN R.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                  TotalCount = Count(1)OVER()
           FROM  [dbo].[Room] R WITH (NOLOCK)
		   LEFT JOIN [dbo].[RoomCost] AS RC ON RC.RoomId = R.Id
           INNER JOIN [dbo].[Venue] AS V ON V.Id = R.VenueId AND R.InActiveDateTime IS NULL
		   INNER JOIN [dbo].[Organisation] AS O ON O.Id = V.OrganisationId AND O.InActiveDateTime IS NULL
		   LEFT JOIN @OrganisationIdList AS OL ON OL.OrganisationId = V.OrganisationId  OR OL.OrganisationId IS NULL
		   LEFT JOIN @VenueIdList as VL ON VL.VenueId =  R.VenueId OR VL.VenueId IS NULL
		   WHERE (@RoomId IS NULL OR R.Id = @RoomId)
				 AND R.Id Not IN (SELECT RoomID from Booking where BookingFrom = @DateFrom and BookingTo=@DateTo)
                 AND (@VenueId IS NULL OR R.VenueId = Vl.VenueId)        
				 AND (@OrganisationId IS NULL OR V.OrganisationId = OL.OrganisationId)
                 AND (@SearchText IS NULL )
                     OR (R.Name LIKE @SearchText)
                     --OR (V.Name LIKE @SearchText)
					 --OR (O.Name LIKE @SearchText)
           ORDER BY       
              CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy IS NULL OR @SortBy = 'Room') THEN R.Name
							  WHEN(@SortBy IS NULL OR @SortBy = 'Venue') THEN V.Name
						      WHEN(@SortBy IS NULL OR @SortBy = 'Oraganisation') THEN O.Name
                              END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN                               
                        CASE WHEN(@SortBy IS NULL OR @SortBy = 'Room') THEN R.Name
						WHEN(@SortBy IS NULL OR @SortBy = 'Venue') THEN V.Name
						WHEN(@SortBy IS NULL OR @SortBy = 'Oraganisation') THEN O.Name
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


