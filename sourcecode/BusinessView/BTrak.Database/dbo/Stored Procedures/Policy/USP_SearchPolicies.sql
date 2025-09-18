----------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-06-12 00:00:00.000'
-- Purpose      To Search Policies
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
--	EXEC [dbo].[USP_SearchPolicies] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @Name='Sample'

CREATE PROCEDURE [dbo].[USP_SearchPolicies]
(
    @PolicyId UNIQUEIDENTIFIER = NULL, 
    @SearchText NVARCHAR(250) = NULL,
    @IsArchived BIT = NULL,
	@ProjectActive BIT = NULL,
	@SortBy NVARCHAR(100) = NULL,
	@SortDirection NVARCHAR(50) = NULL,
	@PageSize INT = NULL,
	@PageNumber INT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
SET NOCOUNT ON
       BEGIN TRY
          
            DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            IF(@HavePermission = '1')			 
            BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

                IF(@SearchText   = '') SET @SearchText   = NULL

				SET @SearchText = '%'+ @SearchText +'%';       
				      
				IF(@PolicyId = '00000000-0000-0000-0000-000000000000') SET @PolicyId = NULL

				IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

				IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

				IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [Policy] WHERE CompanyId = @CompanyId)

				IF(@PageSize = 0) SET @PageSize = 10

				IF(@PageNumber IS NULL) SET @PageNumber = 1

				IF(@IsArchived IS NULL) SET @IsArchived = 0

				SELECT P.Id AS PolicyId,
					   P.[Name] AS PolicyName,
					   P.[Description] AS PolicyDescription,
					   P.MustRead,
					   P.ReviewDate,
					   PU.[Role] AS SelectedRoles,
					   PU.[User] AS SelectedUsers,
					   P.InActiveDateTime,
					   P.CreatedDateTime,
					   P.CreatedByUserId,
					   CONCAT(U.FirstName,' ',U.SurName) AS CreatedByUserName,
					   P.[TimeStamp],
					   TotalCount = COUNT(1) OVER()
				FROM [Policy] P
				INNER JOIN [User] U ON U.Id = P.CreatedByUserId
				LEFT JOIN [PolicyUser] PU ON PU.PolicyId = P.Id
				WHERE (@IsArchived IS NULL OR (@IsArchived = 1 AND P.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND P.InactiveDateTime IS NULL))
				AND (@PolicyId IS NULL OR P.Id = @PolicyId)
				AND (@SearchText IS NULL OR (P.[Name] LIKE @SearchText )
										 OR (P.[Description] LIKE @SearchText)
										 OR (CONVERT(NVARCHAR(100), P.ReviewDate, 107) LIKE @SearchText))
				AND P.CompanyId = @CompanyId
				ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'CreatedDateTime' THEN CAST(P.CreatedDateTime AS sql_variant)
								 WHEN @SortBy = 'Name' THEN P.[Name]
								 WHEN @SortBy = 'Description' THEN P.[Description]
								 WHEN @SortBy = 'ReviewDate' THEN CAST(P.ReviewDate AS sql_variant)
							END
						 END ASC,
						 CASE WHEN @SortDirection = 'DESC' THEN
						 	CASE WHEN @SortBy = 'CreatedDateTime' THEN CAST(P.CreatedDateTime AS sql_variant)
						 		 WHEN @SortBy = 'Name' THEN P.[Name]
						 		 WHEN @SortBy = 'Description' THEN P.[Description]
						 		 WHEN @SortBy = 'ReviewDate' THEN CAST(P.ReviewDate AS sql_variant)
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
