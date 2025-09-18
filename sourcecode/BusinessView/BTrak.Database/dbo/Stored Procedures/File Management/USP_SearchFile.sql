-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get the File  Details By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified By   Sai Praneeth M
-- Created      '2019-11-05 00:00:00.000'
-- Purpose      To Get the File  Details By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_SearchFile] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@StoreId='6A24B8C6-E8D9-4606-A404-DBB884163F72'
--,@FolderId='5a74c78b-6c4f-4aaf-b6be-e3d69d27e9b8'

CREATE PROCEDURE [dbo].[USP_SearchFile]
(
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @FileId  UNIQUEIDENTIFIER = NULL,
   @FolderId  UNIQUEIDENTIFIER = NULL, 
   @StoreId  UNIQUEIDENTIFIER = NULL, 
   @ReferenceId  UNIQUEIDENTIFIER = NULL, 
   @ReferenceTypeId  UNIQUEIDENTIFIER = NULL, 
   @IsArchived BIT= NULL, 
   @SearchText NVARCHAR(250) = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @SortDirection NVARCHAR(100)=NULL,
   @PageNumber INT = 1,
   @PageSize INT = 10,
   @UserStoryId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')

        BEGIN

			IF(@SearchText   = '') SET @SearchText   = NULL
           
			IF(@FileId = '00000000-0000-0000-0000-000000000000') SET @FileId = NULL

			IF(@FolderId = '00000000-0000-0000-0000-000000000000') SET @FolderId = NULL

			IF(@StoreId = '00000000-0000-0000-0000-000000000000') SET @StoreId = NULL

			IF(@ReferenceId = '00000000-0000-0000-0000-000000000000') SET @ReferenceId = NULL

			IF(@ReferenceTypeId = '00000000-0000-0000-0000-000000000000') SET @ReferenceTypeId = NULL

			IF(@Pagesize = 0) SET @Pagesize =10

			IF(@Pagenumber IS NULL) SET @Pagenumber = 1

			IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

			IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

            SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))               

			SELECT  UF.Id AS FileId,
			        UF.Id,
					UF.[FileName],
					UF.FileExtension,
					UF.FilePath,
					UF.FileSize,  
					UF.FolderId,
					UF.StoreId,
					UF.ReferenceId,
					UF.ReferenceTypeId,
					IsArchived = CASE WHEN UF.InActiveDateTime IS NULL THEN 0 ELSE 1 END,
					UF.CreatedDateTime,
					UF.CreatedByUserId,
					UF.[TimeStamp],
					UF.[Description]
			FROM	[dbo].[UploadFile] UF
			WHERE UF.CompanyId = @CompanyId 
					AND (@FileId IS NULL OR UF.Id = @FileId)
					AND ((@StoreId IS NOT NULL AND UF.StoreId = @StoreId 
					      AND ((@FolderId IS NULL AND UF.FolderId IS NULL) OR (@FolderId IS NOT NULL AND UF.FolderId = @FolderId))) OR @StoreId IS NULL)
					AND (@FolderId IS NULL OR UF.FolderId = @FolderId)
					AND (@ReferenceId IS NULL OR UF.ReferenceId = @ReferenceId)
					AND (@UserStoryId IS NULL  OR UF.QuestionDocumentId IN (SELECT Id FROM Candidate) OR UF.Id IN (SELECT Id FROM dbo.UfnSplit ((SELECT FileIds FROM LinkedFilesForUserStory WHERE UserStoryId = @UserStoryId))))
					AND (@ReferenceTypeId IS NULL OR UF.ReferenceTypeId = @ReferenceTypeId)
					AND (@SearchText IS NULL OR (UF.[FileName] LIKE @SearchText))
					AND (@IsArchived IS NULL OR (@IsArchived = 1 AND UF.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND UF.InActiveDateTime IS NULL))
					AND (UF.IsQuestionDocuments IS NULL OR UF.IsQuestionDocuments = 0)
		                      
			ORDER BY CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'DESC') THEN
						  CASE  WHEN (@SortBy = 'FileName') THEN  UF.[FileName]
								WHEN (@SortBy = 'CreatedDateTime') THEN CAST(CONVERT(DATETIME,UF.CreatedDateTime,121) AS sql_variant)
						  END
					 END DESC,

                     CASE WHEN @SortDirection = 'ASC' THEN							                                     
						  CASE  WHEN (@SortBy = 'FileName') THEN  UF.[FileName]
								WHEN (@SortBy = 'CreatedDateTime') THEN CAST(CONVERT(DATETIME,UF.CreatedDateTime,121) AS sql_variant)
                          END
                     END ASC

			OFFSET ((@PageNumber - 1) * @PageSize) ROWS

            FETCH NEXT @PageSize ROWS ONLY

		END
        ELSE
        BEGIN
        
                RAISERROR (@HavePermission,11, 1)
                
        END
	 END TRY  
	 BEGIN CATCH 
		
		EXEC USP_GetErrorInformation

	END CATCH
END