-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Get AssetHistory and Comments Related to Assets
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_GetAssetHistory @OperationsPerformedBy = N'77d4a8d7-0760-45f8-ab52-d18c2e23fc70',@AssetId='1fb27116-818e-4acf-9218-7fadf5822d5d'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAssetHistory]
(
  @AssetId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @PageNumber INT = NULL,
  @PageSize INT = NULL,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection NVARCHAR(100) = NULL
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
    
			IF (@AssetId = '00000000-0000-0000-0000-000000000000') SET @AssetId = NULL
    
			IF(@PageNumber IS NULL) SET @PageNumber = 1
    
			IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [dbo].[AssetHistory]) + (SELECT COUNT(1) FROM [dbo].[Comment])
    
			IF(@PageSize = 0) SET @PageSize = 10
    
			SELECT Z.AssetHistoryId,
				   Z.CreatedByUserId,
				   Z.FullName,
				   Z.ProfileImage,
				   Z.CreatedDateTime,
				   Z.AssetHistoryJson,
				   Z.Comment,
				   TotalCount = COUNT(1) OVER()
			 FROM ((SELECT AH.Id AssetHistoryId,
						   AH.CreatedByUserId,
						   U.FirstName+' ' + ISNULL(U.SurName,'') AS FullName,
						   U.ProfileImage,
						   AH.CreatedDateTime,
						   AssetHistoryJson,
						   NULL Comment
					FROM [AssetHistory] AH
						  INNER JOIN [User] U ON AH.CreatedByUserId = U.Id
					WHERE U.CompanyId = @CompanyId 
						   AND (@AssetId IS NULL OR @AssetId = AH.AssetId) 
					)
					UNION ALL
					(SELECT C.Id AssetHistoryId,
							C.CommentedByUserId,
							U.FirstName+' '+ISNULL(U.SurName,''),
							U.ProfileImage,
							C.CreatedDateTime,
							NULL AS AssetHistoryJson,
							C.Comment
					 FROM Comment C
				          INNER JOIN [User] U ON U.Id = C.CommentedByUserId 
					 WHERE C.CompanyId = @CompanyId AND C.ReceiverId = @AssetId)
					) Z
			ORDER BY Z.CreatedDateTime DESC
			OFFSET ((@PageNumber - 1) * @PageSize) ROWS
			FETCH NEXT @PageSize ROWS ONLY

		END
		ELSE
	
		RAISERROR(@HavePermission,11,1)

	END TRY  
	BEGIN CATCH 
   
		THROW

	END CATCH
END
GO