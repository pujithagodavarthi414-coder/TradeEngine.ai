
--EXEC [dbo].[USP_GetRecentSearch] @OperationsPerformedBy='80D61BE0-A923-40B6-ACE4-FF98CE74F0E1'
CREATE PROCEDURE [dbo].[USP_GetRecentSearch]
(
@OperationsPerformedBy UNIQUEIDENTIFIER,
@PageNumber INT = 1,
@PageSize INT = 10
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            IF (@HavePermission = '1')
            BEGIN
             SELECT RecentSearch, CreatedDateTime, ItemId, RecentSearchType
			  FROM (
							SELECT   SearchText AS RecentSearch, CreatedDateTime,ItemId, SearchType RecentSearchType,
									ROW_NUMBER() OVER(PARTITION BY SearchText ORDER BY CreatedDateTime DESC) rn
								FROM RecentSearch WHERE CreatedByUserId = @OperationsPerformedBy AND InActiveDateTime IS NULL
						  ) a
			WHERE rn = 1 order by CreatedDateTime DESC
			OFFSET ((@PageNumber - 1) * @PageSize) ROWS
				
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