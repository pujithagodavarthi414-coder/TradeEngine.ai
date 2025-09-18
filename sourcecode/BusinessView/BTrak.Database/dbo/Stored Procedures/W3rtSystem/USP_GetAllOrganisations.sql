-------------------------------------------------------------------------------
-- Author       nikhitha yamsani 
-- Created      '2019-12-28 00:00:00.000'
-- Purpose      To Get All Organisations
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetAllOrganisations]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'



CREATE PROCEDURE [dbo].[USP_GetAllOrganisations]
(
  @OrganisationId UNIQUEIDENTIFIER = NULL,
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
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
          IF(@OrganisationId = '00000000-0000-0000-0000-000000000000') SET @OrganisationId = NULL
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
          IF(@SearchText = '') SET @SearchText = NULL
          SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'
            SELECT Id AS OrganisationId,
                   Name AS OrganisationName,
                   Description,
                   AddressJson,
                   Telephone as PhoneNumber,
				   [Town],
                   ImageJson,
                   [Timestamp],				     
				   Locality,
                  CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
           FROM  [dbo].[Organisation]  WITH (NOLOCK)
		   Where (@OrganisationId is NULL or Id= @OrganisationId)
		   AND (@SearchText IS NULL OR  Name LIKE @SearchText)
		   ORDER BY
		   CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy IS NULL OR @SortBy = 'Organisation') THEN Name
                              END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                       CASE WHEN(@SortBy IS NULL OR @SortBy = 'Organisation') THEN Name
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

