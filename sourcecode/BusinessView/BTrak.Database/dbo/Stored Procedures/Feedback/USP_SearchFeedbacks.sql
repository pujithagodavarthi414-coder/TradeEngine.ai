CREATE PROCEDURE [dbo].[USP_SearchFeedbacks]
	@FeedbackId UNIQUEIDENTIFIER = NULL,
	@Description NVARCHAR(800) = NULL,
	@SearchText NVARCHAR(MAX) = NULL,
	@PageNumber INT = 1,
	@PageSize INT = 10,
	@SortBy NVARCHAR(20) = NULL,
	@SortDirection NVARCHAR(20) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN
		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
            IF(@SearchText = '') SET @SearchText = NULL
			 SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'
			   SELECT F.Id AS FeedbackId,
			          F.[Description],
					  F.SenderUserId,
					  F.CreatedDateTime,
					  U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
					  U.ProfileImage,
					  U.UserName,
					  C.CompanyName,
					  U.MobileNo,
					  TotalCount = COUNT(1) OVER()
					FROM [dbo].[Feedback]F
					  INNER JOIN [dbo].[User]U ON F.CreatedByUserId = U.Id
					  INNER JOIN [dbo].[Company]C ON C.Id = U.CompanyId
					WHERE  U.InActiveDateTime IS NULL
					 AND (@FeedbackId IS NULL OR F.Id = @FeedbackId)
					 AND (@SearchText IS NULL
                     OR (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText)
					 OR (U.UserName LIKE @SearchText)
					 OR (C.CompanyName LIKE @SearchText)
                     OR (F.[Description] LIKE @SearchText)
                     OR (REPLACE(CONVERT(NVARCHAR,F.CreatedDateTime,106),' ','-')) LIKE @SearchText
                    )
		 ORDER BY       
              CASE WHEN ( @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy IS NULL OR @SortBy = 'CreatedDateTime') THEN U.FirstName + ' ' + U.SurName
                              WHEN(@SortBy = 'Description') THEN  F.Description
                              WHEN(@SortBy = 'CreatedDateTime') THEN Cast(F.CreatedDateTime as sql_variant)
                          END
                      END ASC,
                      CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'DESC') THEN
                         CASE WHEN(@SortBy IS NULL OR @SortBy = 'CreatedDateTime') THEN U.FirstName + ' ' + U.SurName
                              WHEN(@SortBy = 'Description') THEN  F.Description
                              WHEN(@SortBy = 'CreatedDateTime') THEN Cast(F.CreatedDateTime as sql_variant)
                          END
                      END DESC
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
GO