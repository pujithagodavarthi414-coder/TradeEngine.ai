-------------------------------------------------------------------------------
-- Author       nikhitha yamsani 
-- Created      '2019-12-28 00:00:00.000'
-- Purpose      To Get All Venues By Applying Organisation Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetAllVenues]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetAllVenues]
(
  @Id UNIQUEIDENTIFIER = NULL,
  @Name NVARCHAR(250) = NULL,
  @OperationsPerformedBy  UNIQUEIDENTIFIER,
  @OrganisationId UNIQUEIDENTIFIER = NULL,
  @SearchText NVARCHAR(250) = NULL,
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
       
	   DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
          IF(@Id = '00000000-0000-0000-0000-000000000000') SET @Id = NULL
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
          IF(@OrganisationId = '00000000-0000-0000-0000-000000000000') SET @OrganisationId = NULL
          IF(@SearchText = '') SET @SearchText = NULL      
          SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'
            SELECT V.Id AS Id,
                  V.Name AS VenueName,
                  V.OrganisationId,
                  V.ImageJson,
                  V.CreatedDateTime,
                  V.CreatedByUserId,
                  V.UpdatedDateTime,
                  V.UpdatedByUserId,
				   V.[Description],
                  O.Name OrganisationName,
                  V.[Timestamp],
				   
                  CASE WHEN V.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                  TotalCount = Count(1)OVER()
           FROM  [dbo].[Venue] V WITH (NOLOCK)
           INNER JOIN [dbo].[Organisation] AS O ON O.Id = V.OrganisationId AND V.InActiveDateTime IS NULL
           WHERE (@Id IS NULL OR V.Id = @Id)        
                 AND (@OrganisationId IS NULL OR V.OrganisationId = @OrganisationId)
                 AND (@SearchText IS NULL             
                     OR (V.Name LIKE @SearchText)
					 --OR (O.Name LIKE @SearchText)
                    )
           ORDER BY
              CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy IS NULL OR @SortBy = 'Venue') THEN V.Name
						  WHEN(@SortBy IS NULL OR @SortBy = 'Oraganisation') THEN V.Name
                              END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                        CASE WHEN(@SortBy IS NULL OR @SortBy = 'Venue') THEN V.Name
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
GO


