-------------------------------------------------------------------------------
-- Author       kandapu sushmitha 
-- Created      '2019-12-27 00:00:00.000'
-- Purpose      To Get All rooms By Applying venue Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetAllRoomsBasedOnEvent]@OperationsPerformedBy='7F4DD877-AEA3-43D9-B24C-2F6D90F5224B' ,@EventTypeId='94B3B963-4776-451A-B456-563D3E28435B', @RoomId='53D5B9B4-2B23-4B14-938C-F8C25DC374B9' ,@DateFrom='2020-01-08 12:27:15.757' , @DateTo='2020-01-08 12:27:15.757'
CREATE PROCEDURE [dbo].[USP_GetAllRoomsBasedOnEvent]
(
  @RoomId UNIQUEIDENTIFIER = NULL,
  @EventTypeId UNIQUEIDENTIFIER = NULL,
  @RoomName NVARCHAR(250) = NULL,
  @OperationsPerformedBy  UNIQUEIDENTIFIER,
  @VenueId XML = NULL,
  @SearchText NVARCHAR(250) = NULL,
  @OrganisationId XML = NULL,
  @PageNo INT = 1,
  @SortDirection NVARCHAR(250) = NULL,
  @SortBy NVARCHAR(250) = NULL,
  @PageSize INT = 1000,
  @DateFrom DATETIME = NULL,
  @DateTo DATETIME = NULL,
  @FromTime VARCHAR = NULL,
  @ToTime VARCHAR = NULL,
  @IsActive BIT = NULL,
  @DayType VARCHAR = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        IF (@HavePermission = '1')
        BEGIN
         IF (@DayType like 'Week day')
         BEGIN
                 DECLARE @PriceCatergoryId UNIQUEIDENTIFIER = (CASE WHEN @FromTime >= 9 AND @ToTime < =5 THEN 'B8C1714C-338C-442E-88B8-376B71AF4C2A'
                                                            WHEN @FromTime >=9 AND @ToTime > =5 THEN'AE0C2442-40B7-49E0-A14C-71B1B5D539E0'
                                                            END)
         END
         ELSE
         BEGIN
            SET @PriceCatergoryId= 'CAF11971-F08F-4BA8-A568-F4C50287EF29'
         END
          IF(@RoomId = '00000000-0000-0000-0000-000000000000') SET @RoomId = NULL

          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		  IF (@EventTypeId  IS NOT NULL) 
		  BEGIN
		  DECLARE @EventPriceId UNIQUEIDENTIFIER = (SELECT Id From EventPricing where EventTypeId = @EventTypeId)
		  END
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
                SELECT  x.value('ListItemId[1]','UNIQUEIDENTIFIER')
                FROM  @VenueId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
        END
        IF(@OrganisationId Is NOT NULL)
        BEGIN
            INSERT INTO @OrganisationIdList (OrganisationId)
                SELECT  x.value('ListItemId[1]','UNIQUEIDENTIFIER')
                FROM  @OrganisationId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
        END 
          IF(@SearchText = '') SET @SearchText = NULL
          SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'
           SELECT R.Id AS RoomId,
                  R.Name AS RoomName,
                  R.VenueId,
                  R.ImageJson,
                  R.Town,
                  ET.EventTypeName,
                  R.Locality,
                  V.OrganisationId,
                  V.Name AS VenueName,
                  (select MIN(RPP.Cost) from RoomPricing RPP where EventPricingId = @EventPriceId) MinPrice,
                  (select MAX(RPP.Cost) from RoomPricing RPP where EventPricingId =@EventPriceId) MaxPrice ,
                  R.Description ,
                  R.Video,
                  O.Name  as OrganisationName,
                  R.[Timestamp],
                  CASE WHEN R.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
                  --TotalCount = Count(1)OVER()
           FROM  [dbo].[Room] R WITH (NOLOCK)
           LEFT JOIN [dbo].[RoomCost] AS RC ON RC.RoomId = R.Id
           INNER JOIN  [dbo].[RoomPricing] AS RP ON RP.RoomId = R.Id 
           INNER JOIN [dbo].[Venue] AS V ON V.Id = R.VenueId AND R.InActiveDateTime IS NULL
           INNER JOIN [dbo].[Organisation] AS O ON O.Id = V.OrganisationId AND O.InActiveDateTime IS NULL
           INNER JOIN  [EventPricing]  AS EP ON EP.Id = RP.EventPricingId AND EP.InActiveDateTime IS NULL
           INNER JOIN  [dbo].[EventType] AS ET ON ET.Id = EP.EventTypeId AND ET.InActiveDateTime IS NULL
           LEFT JOIN @OrganisationIdList AS OL ON OL.OrganisationId = V.OrganisationId  OR OL.OrganisationId IS NULL
           LEFT JOIN @VenueIdList as VL ON VL.VenueId =  R.VenueId OR VL.VenueId IS NULL
           WHERE (@RoomId IS NULL OR R.Id = @RoomId)
                AND (@EventTypeId IS NULL Or ET.Id = @EventTypeId)
                AND R.Id Not IN (SELECT RoomID from Booking where BookingFrom = @DateFrom and BookingTo=@DateTo)
                AND (@VenueId IS NULL OR R.VenueId = Vl.VenueId)        
                AND (@OrganisationId IS NULL OR V.OrganisationId = OL.OrganisationId)
                AND (@PriceCatergoryId IS NULL OR RP.PricingCategoryTypeId = @PriceCatergoryId)
                AND (@SearchText IS NULL OR R.Name LIKE @SearchText)
                    GROUP BY  R.Id ,R.Name ,R.VenueId,R.ImageJson,R.Town,ET.EventTypeName,R.Locality, V.OrganisationId,V.Name , R.Description ,R.Video,O.Name  ,R.[Timestamp], CASE WHEN R.InActiveDateTime IS NULL THEN 0 ELSE 1 END 
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
