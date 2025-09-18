--EXEC [dbo].[USP_GetActTrackerAppUrls] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@IsProductive=NULL
---------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetActTrackerAppUrls](
@AppUrlsId UNIQUEIDENTIFIER = NULL,
@IsProductive BIT = NULL,
@SearchText NVARCHAR(250) = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER ,
@IsArchive BIT = NULL,
@ApplicationCategoryId UNIQUEIDENTIFIER = NULL,
@CompanyIdFromTracker UNIQUEIDENTIFIER = NULL
)
AS
BEGIN 
SET NOCOUNT ON

BEGIN TRY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		  
	IF(@AppUrlsId = '00000000-0000-0000-0000-000000000000') SET @AppUrlsId = NULL	
	
	IF(@ApplicationCategoryId = '00000000-0000-0000-0000-000000000000') SET @ApplicationCategoryId = NULL		  
		   
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000' AND @CompanyIdFromTracker IS NOT NULL)
	BEGIN
		SET @CompanyId = @CompanyIdFromTracker
	END
       	   
	SELECT AUN.Id As AppUrlNameId,
		AUN.AppUrlName,
		ATA.Id AppUrlTypeId,
		AUN.AppUrlImage,
		AUN.CreatedDateTime,
		AUN.ApplicationCategoryId,
		STUFF((SELECT ',' +  CONVERT(NVARCHAR(50),ATR.RoleId)
				FROM ActivityTrackerApplicationUrlRole ATR
				WHERE ATR.ActivityTrackerApplicationUrlId = AUN.Id
					AND ATR.InActiveDateTime IS NULL
					AND ISNULL(ATR.IsProductive,0) = 1
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''
		) AS ProductiveRoles,
		STUFF((SELECT ',' +  CONVERT(NVARCHAR(50),ATR.RoleId)
				FROM ActivityTrackerApplicationUrlRole ATR
				WHERE ATR.ActivityTrackerApplicationUrlId = AUN.Id
					AND ATR.InActiveDateTime IS NULL
					AND ISNULL(ATR.IsProductive,0) = 0
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''
		) AS UnproductiveRoles,
		STUFF((SELECT ',' +  R.RoleName
				FROM ActivityTrackerApplicationUrlRole ATR
					INNER JOIN [Role] R ON R.Id = ATR.RoleId
				WHERE ATR.ActivityTrackerApplicationUrlId = AUN.Id
					AND ATR.InActiveDateTime IS NULL
					AND ISNULL(ATR.IsProductive,0) = 1
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''
		) AS ProductiveRoleNames,
		STUFF((SELECT ',' +  R.RoleName
				FROM ActivityTrackerApplicationUrlRole ATR
					INNER JOIN [Role] R ON R.Id = ATR.RoleId
				WHERE ATR.ActivityTrackerApplicationUrlId = AUN.Id
					AND ATR.InActiveDateTime IS NULL
					AND ISNULL(ATR.IsProductive,0) = 0
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''
		) AS UnproductiveRoleNames,
		CASE WHEN ATA.AppURL = 'URL' THEN 0 ELSE 1 END AS IsApp
		,AC.ApplicationCategoryName
	FROM  ActivityTrackerApplicationUrl AUN
			JOIN [dbo].[ActivityTrackerAppUrlType] ATA ON AUN.ActivityTrackerAppUrlTypeId = ATA.Id 
			LEFT JOIN ApplicationCategory AC ON AC.Id = AUN.ApplicationCategoryId AND AC.InActiveDateTime IS NULL
  	WHERE @CompanyId = AUN.CompanyId 
				--AND AUN.InActiveDateTime IS NULL
				AND (@AppUrlsId IS NULL OR @AppUrlsId = AUN.Id)
				AND (@ApplicationCategoryId IS NULL OR AUN.ApplicationCategoryId = @ApplicationCategoryId)
				--AND (@IsProductive IS NULL OR @IsProductive = A.IsProductive)
				AND (@SearchText IS NULL OR AUN.AppUrlName LIKE '%'+@SearchText+'%')
				AND ((@IsArchive IS NULL AND AUN.InActiveDateTime IS NULL)
				OR (@IsArchive = 1 AND AUN.InActiveDateTime IS NOT NULL) 
				OR (@IsArchive = 0 AND AUN.InActiveDateTime IS NULL))
	ORDER BY AUN.AppUrlName

   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO
