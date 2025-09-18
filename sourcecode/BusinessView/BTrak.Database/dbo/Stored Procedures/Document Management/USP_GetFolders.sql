-- Author       Sri Susmitha Pothuri
-- Created      '2019-07-31 00:00:00.000'
-- Purpose      To get all Folders by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified By   Sai Praneeth M
-- Created      '2019-11-05 00:00:00.000'
-- Purpose      To get all Folders by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetFolders] @OperationsPerformedBy = '29CF2670-1EEE-42D1-9BD3-7D243D2C80BC',
--@FolderReferenceId='f99ec51f-9e3e-fcb7-c8a5-574160e8a345',@IsTreeView = 1
--,@FolderReferenceTypeId = '2039ee64-bb6e-4757-9e33-55521dc7cc46',@ParentFolderId= NULL

CREATE PROCEDURE [dbo].[USP_GetFolders]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @FolderId UNIQUEIDENTIFIER = NULL,    
    @ParentFolderId UNIQUEIDENTIFIER = NULL,
    @StoreId UNIQUEIDENTIFIER = NULL,
    @FolderReferenceId  UNIQUEIDENTIFIER = NULL,
    @FolderReferenceTypeId UNIQUEIDENTIFIER = NULL,
    @SearchText NVARCHAR(250) = NULL,
    @IsArchived BIT= 0,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(100)=NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10,
    @Count INT = NULL,
    @IsTreeView BIT = 0,
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
             
             --CREATE TABLE #Temp (FolderId UNIQUEIDENTIFIER)
			 
        --    CREATE TABLE #Folders (FolderId UNIQUEIDENTIFIER)
		    
        --  IF(@SearchText IS NOT NULL AND @FolderId IS NULL AND ISNULL(@IsTreeView,0) = 0)
       --BEGIN
       
       --DECLARE Cur_sor CURSOR FOR (SELECT Id FROM Folder
       --                                     WHERE ((@ParentFolderId IS NULL AND FolderReferenceId = @FolderReferenceId)
       --    OR (@ParentFolderId = ParentFolderId)) AND InActiveDateTime IS NULL)
       
       --OPEN Cur_sor;
       
       --FETCH NEXT FROM Cur_sor INTO @FolderId
       
       --WHILE(@@FETCH_STATUS = 0)
       --BEGIN
       
       --;WITH Tree1 as
       --   (
       --     SELECT P.Id FolderId
       --     FROM Folder P
       --     WHERE P.Id = @FolderId
            
       --     UNION ALL
            
       --     SELECT P1.Id AS FolderId
       --     FROM Folder P1  
       --     INNER JOIN Tree1 M
       --     ON M.FolderId = P1.ParentFolderId AND P1.InActiveDateTime IS NULL
       --     WHERE M.FolderId IS NOT NULL
       --   )
       
       --INSERT INTO #Temp
       --SELECT FolderId FROM Tree1 GROUP BY FolderId
       
       --IF(EXISTS(SELECT Id FROM UploadFile WHERE InActiveDateTime IS NULL AND FolderId IN (SELECT FolderId FROM #Temp) AND [FileName] LIKE '%' + ISNULL(@SearchText,'') + '%'))
       --BEGIN
       
       --INSERT INTO #Folders
       --SELECT @FolderId
       
       --END
       
       --DELETE FROM #Temp
       
       --FETCH NEXT FROM Cur_sor INTO @FolderId
       
       --END
       
       --CLOSE Cur_sor;
       
       --DEALLOCATE Cur_sor;
       
       --SET @FolderId = NULL
       
       --END
		    
            IF(@FolderId = '00000000-0000-0000-0000-000000000000') SET @FolderId = NULL    
            
            IF(@ParentFolderId = '00000000-0000-0000-0000-000000000000') SET @ParentFolderId = NULL    
            
            IF(@StoreId = '00000000-0000-0000-0000-000000000000') SET @StoreId = NULL  
            
            IF(@FolderReferenceId = '00000000-0000-0000-0000-000000000000') SET @FolderReferenceId = NULL  
            
            IF(@FolderReferenceTypeId = '00000000-0000-0000-0000-000000000000') SET @FolderReferenceTypeId = NULL  
            
            IF(@Pagesize = 0) SET @Pagesize = 10
            
            IF(@Pagenumber IS NULL) SET @Pagenumber = 1
            
            IF(@IsArchived IS NULL)SET @IsArchived = 0

			DECLARE @IsHaveStoreId BIT = 0

			IF(@StoreId IS NOT NULL )SET @IsHaveStoreId = 1
            
            SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

            DECLARE @StoreIdCount INT = (SELECT COUNT(1) FROM Store  WHERE Id = @StoreId)
            
            DECLARE @ParentFolderIdCount INT = (SELECT COUNT(1) FROM Folder  WHERE Id = @ParentFolderId)
            
            DECLARE @FolderReferenceTypeIdCount INT = (SELECT COUNT(1) FROM ReferenceType WHERE Id = @FolderReferenceTypeId AND @FolderReferenceTypeId IS NOT NULL)
         
            IF(@StoreIdCount = 0 AND @StoreId IS NOT NULL AND @FolderReferenceId IS NULL AND @FolderReferenceTypeId IS NULL)
            BEGIN
           
               RAISERROR(50002,16, 2,'Store')
         
            END
            ELSE IF(@ParentFolderIdCount = 0 AND @ParentFolderId IS NOT NULL AND @FolderReferenceId IS NULL AND @FolderReferenceTypeId IS NULL)
            BEGIN
           
               RAISERROR(50002,16, 2,'Folder')
         
            END
            ELSE IF(@FolderReferenceTypeIdCount = 0 AND @FolderReferenceTypeId IS NOT NULL)
            BEGIN
            
               RAISERROR(50002,16, 2,'FolderReferenceTypeId')
            
            END
            ELSE

            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))  

            IF(@StoreId IS NULL AND @FolderReferenceId IS NOT NULL AND @FolderReferenceTypeId IS NOT NULL)
            BEGIN
            
              SET @StoreId = (SELECT S.Id FROM Store S JOIN Company C ON C.Id = S.CompanyId AND C.Id = @CompanyId AND C.InActiveDateTime IS NULL WHERE StoreName = (LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 10) + ' doc store') AND S.InActiveDateTime IS NULL)
            
            END            

            IF((@ParentFolderId IS NULL AND @FolderReferenceId IS NOT NULL AND @FolderReferenceTypeId IS NOT NULL AND ISNULL(@IsTreeView,0) = 0) )
            BEGIN
            
              DECLARE @ReferenceTypeName NVARCHAR(250) = (SELECT ReferenceTypeName + ' docs' FROM ReferenceType WHERE Id = @FolderReferenceTypeId AND InActiveDateTime IS NULL)
              
              DECLARE @CustomFolderId UNIQUEIDENTIFIER = (SELECT Id FROM Folder WHERE FolderName = @ReferenceTypeName AND FolderReferenceTypeId = @FolderReferenceTypeId AND FolderReferenceId IS NULL AND ParentFolderId IS NULL AND StoreId = @StoreId AND InActiveDateTime IS NULL)
              
              SET @ParentFolderId = (SELECT  Id FROM Folder WHERE FolderReferenceTypeId = @FolderReferenceTypeId AND FolderReferenceId = @FolderReferenceId AND ParentFolderId = @CustomFolderId AND StoreId = @StoreId AND InActiveDateTime IS NULL)
         

            END

		
	
			IF(@ParentFolderId IS NULL  AND @StoreId IS NOT NULL AND @IsHaveStoreId = 1)
			BEGIN

			SET @ParentFolderId = (SELECT TOP 1 Id FROM Folder WHERE StoreId = @StoreId  AND InActiveDateTime IS NULL ORDER BY CreatedDateTime,[TimeStamp])

			END
		

            IF(ISNULL(@IsTreeView,0) = 0)
            BEGIN
            
			  DECLARE @FoldersAndFile NVARCHAR(MAX) 
            
              SET @FoldersAndFile =( 
              SELECT  (SELECT T.*,  totalCount = COUNT(1) OVER()  FROM
                      (SELECT P.ParentFolderId AS parentFolderId,null as isToBeReviewed,null as reviewedDateTime, null as reviewedByUserId,null as  reviewedByUserName,cast(P.FolderName as nvarchar(1000)) [name],P.Id AS id,P.CreatedDateTime AS createdDateTime,FolderSize size ,NULL fileExtension,
                      (SELECT COUNT(1) FROM Folder FC WHERE FC.ParentFolderId = P.Id AND InActiveDateTime IS NULL) + (SELECT COUNT(1) FROM UploadFile UFC WHERE UFC.FolderId = P.Id  
                      AND InActiveDateTime IS NULL AND (@UserStoryId IS NULL OR UFC.Id IN (SELECT Id FROM dbo.UfnSplit ((SELECT FileIds FROM LinkedFilesForUserStory WHERE UserStoryId = @UserStoryId)))))[count],1 isFolder, null filePath,[timeStamp],storeId
                      FROM Folder P
                      WHERE (P.ParentFolderId = @ParentFolderId OR (@FolderReferenceId IS NULL AND @FolderReferenceTypeId = 'DF52BB58-F895-4C7F-B0C1-5D3C5737CC3E' AND @ParentFolderId IS NULL AND @StoreId IS NOT NULL AND ParentFolderId IS NULL AND StoreId = @StoreId))  
					  AND InActiveDateTime IS NULL 
                      UNION ALL
                      SELECT up.folderId parentFolderId ,isToBeReviewed,reviewedDateTime,reviewedByUserId,U.FirstName + ' ' + U.SurName reviewedByUserName
					  ,cast([FileName]as nvarchar(1000)) name ,UP.Id AS id,UP.createdDateTime,FileSize size,fileExtension ,0 [count],0 isFolder,FilePath AS filePath,UP.[timeStamp] ,UP.storeId
					  FROM UploadFile UP  LEFT JOIN Folder F ON F.Id = UP.FolderId AND F.InActiveDateTime IS NULL
					    LEFT JOIN [User] U ON U.Id = UP.ReviewedByUserId
                      where UP.InActiveDateTime IS NULL AND (@UserStoryId IS NULL OR UP.Id IN (SELECT Id FROM dbo.UfnSplit ((SELECT FileIds FROM LinkedFilesForUserStory WHERE UserStoryId = @UserStoryId))))
                      AND ((@StoreId IS NOT NULL AND UP.StoreId = @StoreId
                      AND ((@ParentFolderId IS NULL AND UP.FolderId IS NULL) OR (@ParentFolderId IS NOT NULL AND UP.FolderId = @ParentFolderId))) OR @StoreId IS NULL)
                       AND ((@ParentFolderId IS NULL OR UP.FolderId = @ParentFolderId))
					   AND (F.Id IS NULL OR @ParentFolderId IS NOT NULL OR (@FolderReferenceTypeId = 'DF52BB58-F895-4C7F-B0C1-5D3C5737CC3E' AND @ParentFolderId IS NULL AND @StoreId IS NOT NULL AND ParentFolderId IS NULL))
                       )T 
                       WHERE (@SearchText IS NULL OR (T.[name] LIKE  '%'+ @SearchText +'%')
                                         OR (T.[FileExtension] LIKE  '%'+ @SearchText +'%')
                                         OR (T.[Size] LIKE  '%'+ @SearchText +'%')
            							 OR  (CAST(T.[count] AS nvarchar(250)) LIKE  '%'+ @SearchText +'%')
                                         OR (FORMAT(T.CreatedDateTime ,'dd-MMM-yyyy')) LIKE  '%'+ @SearchText +'%')
                       ORDER BY CASE WHEN ( @SortDirection = 'DESC') THEN
                                  CASE WHEN (@SortBy = 'Name') THEN T.[Name]
                                       WHEN (@SortBy = 'CreatedDateTime' OR @SortBy IS NULL) THEN cast(T.CreatedDateTime as sql_variant)
                                       WHEN (@SortBy = 'Size') THEN T.Size
            	                       WHEN (@SortBy = 'Count') THEN cast(T.[count] as sql_variant)
                                       WHEN (@SortBy = 'FileExtension') THEN T.FileExtension
                                       END
                                   END DESC,
                                CASE WHEN (@SortDirection = 'ASC'  OR @SortDirection IS NULL ) THEN                                    
                                 CASE  WHEN (@SortBy = 'CreatedDateTime'  OR @SortBy IS NULL) THEN cast(T.CreatedDateTime as sql_variant) 
                                       WHEN (@SortBy = 'Name' ) THEN T.[Name]
                                       WHEN (@SortBy = 'Size') THEN T.Size
            	                       WHEN (@SortBy = 'Count') THEN cast(T.[count] as sql_variant)
                                       WHEN (@SortBy = 'FileExtension') THEN T.FileExtension
                                       END
                                    END ASC,TimeStamp
                       OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                       FETCH NEXT @PageSize ROWS ONLY FOR JSON PATH,INCLUDE_NULL_VALUES)) 


                        ;WITH Tree as
                        (
                         SELECT P.ParentFolderId,P.FolderName,P.Id FolderId,1 AS lvl
                         FROM Folder P
                         WHERE P.Id = @ParentFolderId
                         
                         UNION ALL
                         
                         SELECT P1.ParentFolderId,P1.FolderName,P1.Id,lvl + 1
                         FROM Folder P1  
                         INNER JOIN Tree M
                         ON M.ParentFolderId = P1.Id
                         WHERE M.ParentFolderId IS NOT NULL
                        )

                    SELECT 
                    --(SELECT  F.Id folderId,
                    --F.FolderName folderName,
                    --F.ParentFolderId parentFolderId,
                    --F.StoreId storeId,
                    --@IsArchived isArchived ,
                    --F.CreatedDateTime createdDateTime,
                    --F.CreatedByUserId createdByUserId,
                    --F.[TimeStamp] [timeStamp],
                    --F.FolderSize folderSize,
                    --(SELECT COUNT(1) FROM Folder FC WHERE FC.ParentFolderId = F.Id AND InActiveDateTime IS NULL) + (SELECT COUNT(1) FROM UploadFile UFC WHERE UFC.FolderId = F.Id AND UFC.StoreId = S.Id AND InActiveDateTime IS NULL) AS folderCount
                    --FROM Folder AS F
                    --LEFT JOIN Store S ON S.Id = F.StoreId AND S.InActiveDateTime IS NULL
                    --WHERE S.CompanyId = @CompanyId
                    -- AND (@SearchText IS NULL
                    --  OR ((F.FolderName LIKE  '%'+ @SearchText +'%')
                    --    OR (F.Id IN (SELECT FolderId FROM #Folders))
                    --OR (F.FolderSize LIKE  '%'+ @SearchText +'%')))                
                    -- AND ((F.ParentFolderId IS NULL AND @ParentFolderId IS NULL AND @FolderReferenceId IS NULL AND @FolderReferenceTypeId IS NULL) OR F.ParentFolderId = @ParentFolderId OR @StoreId IS NULL OR (F.ParentFolderId IS NULL AND @ParentFolderId IS NULL AND @FolderReferenceId IS NULL AND @FolderReferenceTypeId = 'DF52BB58-F895-4C7F-B0C1-5D3C5737CC3E'))
                    -- AND ((@IsArchived = 1 AND F.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND F.InActiveDateTime IS NULL))
                    -- AND (@StoreId IS NULL OR F.StoreId = @StoreId)
                    -- AND (@FolderId IS NULL OR F.Id = @FolderId)
                    --ORDER BY CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'DESC') THEN
                    -- CASE  WHEN (@SortBy = 'FolderName') THEN F.FolderName
                    --WHEN (@SortBy = 'CreatedDateTime') THEN CAST(CONVERT(DATETIME,F.CreatedDateTime,121) AS sql_variant)
                    -- END
                    --END DESC,
                    
                    --CASE WHEN @SortDirection = 'ASC' THEN                                    
                    -- CASE  WHEN (@SortBy = 'FolderName') THEN F.FolderName
                    --WHEN (@SortBy = 'CreatedDateTime') THEN CAST(CONVERT(DATETIME,F.CreatedDateTime,121) AS sql_variant)
                    -- END
                    --END ASC
                    
                    --OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                    
                    --FETCH NEXT @PageSize ROWS ONLY
                    --FOR JSON PATH) AS Folders,
                    (SELECT folderId,folderName From Tree ORDER BY lvl DESC FOR JSON PATH) AS BreadCrumb,--Here BreadCrumb header code
                    @FoldersAndFile FoldersAndFiles,--Table view code here
                    (SELECT [Description] from Folder where Id = @ParentFolderId) AS ParentFolderDescription,
					(SELECT FolderName FROM Folder WHERE Id = @ParentFolderId AND InActiveDateTime IS NULL AND @ParentFolderId IS NOT NULL) AS FolderName,
                    (SELECT S.IsDefault isDefault,
                    S.IsCompany isCompany,
                    S.StoreName storeName,
					  
                    S.Id storeId,
                    (SELECT ISNULL(SUM(StoreSize),0) FROM Store WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL) AS overallStoreSize
                    FROM Store AS S
                    WHERE (@StoreId IS NULL OR S.Id = @StoreId)
                    AND ((@IsArchived = 1 AND S.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND S.InActiveDateTime IS NULL))
                    FOR JSON PATH) AS Store
                    --(SELECT UF.Id AS fileId,
                    --UF.[FileName] [fileName],
                    --UF.FileExtension fileExtension,
                    --UF.FilePath filePath,
                    --UF.FileSize fileSize,  
                    --UF.FolderId folderId,
                    --UF.StoreId storeId,
                    --UF.ReferenceId referenceId,
                    --UF.ReferenceTypeId referenceTypeId,
                    --isArchived = CASE WHEN UF.InActiveDateTime IS NULL THEN 0 ELSE 1 END,
                    --UF.CreatedDateTime createdDateTime,
                    --UF.CreatedByUserId createdByUserId,
                    --UF.IstoBeReviewed AS isToBeReviewed,
                    --UF.ReviewedDateTime AS reviewedDateTime,
                    --UF.ReviewedByUserId AS reviewedByUserId,
                    --U.[FirstName] + ' ' +ISNULL(U.SurName,'') reviewedByUserName,
                    --UF.[TimeStamp] [timeStamp]
                    --FROM [dbo].[UploadFile] UF
                    --LEFT JOIN [User] U ON U.Id = UF.ReviewedByUserId AND U.InActiveDateTime IS NULL
                    --WHERE UF.CompanyId = @CompanyId AND UF.InactiveDateTime IS NULL
                    --AND ((@StoreId IS NOT NULL AND UF.StoreId = @StoreId
                    -- AND ((@ParentFolderId IS NULL AND UF.FolderId IS NULL) OR (@ParentFolderId IS NOT NULL AND UF.FolderId = @ParentFolderId))) OR @StoreId IS NULL)
                    --AND (@ParentFolderId IS NULL OR UF.FolderId = @ParentFolderId)
                    ----AND @FolderReferenceId IS NULL OR UF.ReferenceId = @FolderReferenceId
                    --AND ((@IsArchived = 1 AND UF.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND UF.InActiveDateTime IS NULL))
                    --                       AND (@SearchText IS NULL OR (UF.[FileName] LIKE  '%'+ @SearchText +'%')
                    --OR (UF.[FileExtension] LIKE  '%'+ @SearchText +'%')
                    --OR (UF.[FileSize] LIKE  '%'+ @SearchText +'%')
                    --OR (CONVERT(NVARCHAR,UF.CreatedDateTime,107)) LIKE  '%'+ @SearchText +'%')
                    --ORDER BY CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'DESC') THEN
                    -- CASE  WHEN (@SortBy = 'FileName') THEN  UF.[FileName]
                    --WHEN (@SortBy = 'CreatedDateTime') THEN CAST(CONVERT(DATETIME,UF.CreatedDateTime,121) AS sql_variant)
                    -- END
                    --END DESC,
                    
                    --CASE WHEN @SortDirection = 'ASC' THEN                                    
                    -- CASE  WHEN (@SortBy = 'FileName') THEN  UF.[FileName]
                    --WHEN (@SortBy = 'CreatedDateTime') THEN CAST(CONVERT(DATETIME,UF.CreatedDateTime,121) AS sql_variant)
                    -- END
                    --END ASC
                    
                    --OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                    
                    --FETCH NEXT @PageSize ROWS ONLY
                    --FOR JSON PATH) AS Files
            END
            ELSE
            BEGIN
         
		 CREATE TABLE #Temp (FolderId UNIQUEIDENTIFIER)
                --DELETE FROM #Folders
                                             
               ;With ParentFolders AS 
                (
                 SELECT F.Id AS FolderId,ParentFolderId FROM Folder F JOIN Store S ON S.Id = F.StoreId AND F.InActiveDateTime IS NULL AND S.InActiveDateTime IS NULL AND (@StoreId IS NULL OR S.Id = @StoreId)
                 WHERE ((((@FolderReferenceId IS NULL AND @StoreId IS NOT NULL AND ParentFolderId IS NULL)
                      OR (@FolderReferenceId IS NOT NULL AND FolderReferenceId = @FolderReferenceId))AND F.InActiveDateTime IS NULL) 
					 ) -- line added for alternative of another cte
                 UNION ALL
                 SELECT P1.Id AS FolderId,P1.ParentFolderId  
                 FROM Folder P1 
                      INNER JOIN ParentFolders M ON M.FolderId = P1.ParentFolderId AND P1.InActiveDateTime IS NULL
                 WHERE M.FolderId IS NOT NULL 
                       AND (@FolderReferenceId IS NULL OR P1.FolderReferenceId = @FolderReferenceId)
                )
                INSERT INTO #Temp
                SELECT FolderId FROM ParentFolders
                --WHERE FolderId NOT IN (SELECT FolderId FROM #Temp)
                OPTION (MAXRECURSION 0)

       --        ;With Foldertable As 
			    --(
       --         SELECT FolderId  FROM #Temp GROUP BY FolderId
       --          UNION ALL
       --         SELECT P1.Id FROM Folder P1  INNER JOIN Foldertable M ON M.FolderId = P1.ParentFolderId AND P1.InActiveDateTime IS NULL
       --         WHERE M.FolderId IS NOT NULL AND (@FolderReferenceId IS NULL OR P1.FolderReferenceId = @FolderReferenceId)
       --         )
       --            INSERT INTO #Temp
       --            SELECT FolderId FROM Foldertable WHERE FolderId NOT IN (SELECT FolderId FROM #Temp) GROUP BY FolderId

				   SELECT * FROM
                    (SELECT Id AS FolderId
                           ,NULL AS FileId
                           ,FolderName
                           ,ParentFolderId
                           ,NULL AS Extension
                           ,FolderSize AS FileSize
                           ,NULL AS FilePath	     
                           ,StoreId AS StoreId
                           ,FolderReferenceTypeId
                           ,FolderReferenceId
                           ,[TimeStamp],CreatedDateTime
                        FROM Folder
                        WHERE Id IN (SELECT FolderId FROM #Temp)
                             AND ((@FolderReferenceId IS NOT NULL AND ParentFolderId IS NOT NULL) OR @FolderReferenceId IS NULL)
                     UNION ALL
                       SELECT FolderId
                             ,Id AS FileId
                             ,[FileName] AS FolderName
                             ,NULL AS ParentFolderId
                             ,FileExtension AS Extension
                             ,FileSize
                             ,FilePath
                             ,StoreId
                             ,ReferenceTypeId AS FolderReferenceTypeId
                             ,ReferenceId AS FolderReferenceId
                             ,[TimeStamp],CreatedDateTime
                         FROM UploadFile 
						 WHERE FolderId IN (SELECT FolderId FROM #Temp) AND InActiveDateTime IS NULL  AND (@UserStoryId IS NULL OR Id IN (SELECT Id FROM dbo.UfnSplit ((SELECT FileIds FROM LinkedFilesForUserStory WHERE UserStoryId = @UserStoryId))))
                                   AND (@SearchText IS NULL OR [FileName] LIKE '%' + @SearchText + '%'))T 
								   ORDER BY T.CreatedDateTime,[TimeStamp]
                   
                  END
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