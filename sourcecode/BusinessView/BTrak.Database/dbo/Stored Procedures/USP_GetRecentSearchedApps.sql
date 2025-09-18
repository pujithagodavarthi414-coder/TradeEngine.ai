 -- EXEC [dbo].[USP_GetRecentSearchedApps] @OperationsPerformedBy='D2D64A3C-CB87-4E88-B5CC-4A93A6E91341'
CREATE PROCEDURE [dbo].[USP_GetRecentSearchedApps]
(
@OperationsPerformedBy UNIQUEIDENTIFIER,
@SearchText NVARCHAR(250) = NULL,
@SearchTag NVARCHAR(250) = NULL,
@PageNumber INT = 1,
@PageSize INT = 10,
@SortBy NVARCHAR(100) = NULL,
@SortDirection VARCHAR(20) = NULL,
@TagId UNIQUEIDENTIFIER =NULL,
@WidgetIdsXml XML = NULL,
@IsFavouriteWidget Bit = NULL,
@IsFromSearch BIT = NULL
)
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            IF (@HavePermission = '1')
            BEGIN
            DECLARE @IdsXml XML = (
			 SELECT ItemId, CreatedDateTime
			  FROM (
							SELECT   ItemId, CreatedDateTime,
									ROW_NUMBER() OVER(PARTITION BY SearchText ORDER BY CreatedDateTime DESC) rn
								FROM RecentSearch WHERE CreatedByUserId = @OperationsPerformedBy AND InActiveDateTime IS NULL AND SearchType = 3
						  ) a 
			WHERE rn = 1 order by CreatedDateTime DESC
			FOR XML PATH)
			EXEC  [dbo].[USP_GetWidgetsBasedOnUser] @OperationsPerformedBy=@OperationsPerformedBy, @WidgetIdsXml=@IdsXml, @SearchText=@SearchText, @SearchTag=@SearchTag, @PageNumber=@PageNumber,@PageSize=@PageSize,@TagId=@TagId, @IsFromSearch = @IsFromSearch
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