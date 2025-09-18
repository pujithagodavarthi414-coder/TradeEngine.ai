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

CREATE PROCEDURE [dbo].[USP_SearchFolders]
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

        DECLARE @HavePermission NVARCHAR(250)  = '1'

        IF (@HavePermission = '1')

        BEGIN
                   WITH Tree AS
    (
        SELECT E_Parent.Id AS FolderId,E_Parent.FolderName,E_Parent.FolderReferenceId,E_Parent.FolderReferenceTypeId,E_Parent.StoreId,E_Parent.ParentfolderId,E_Parent.[Description],E_Parent.FolderSize
        FROM Folder E_Parent
        WHERE (E_Parent.Id = @FolderId) AND InActiveDateTime IS NULL 
       
	    UNION ALL
        SELECT E_Child.Id AS FolderId, E_Child.FolderName,E_Child.FolderReferenceId,E_Child.FolderReferenceTypeId,E_Child.StoreId,E_Child.ParentfolderId,E_Child.[Description],E_Child.FolderSize
        FROM Folder E_Child 
		INNER JOIN Tree ON Tree.ParentFolderId = E_Child.Id
        WHERE E_Child.InActiveDateTime IS NULL
    )
	SELECT T.FolderId,T.FolderName,T.FolderReferenceId,T.FolderReferenceTypeId,T.ParentFolderId,T.[Description],T.FolderSize,T.StoreId
    FROM Tree T
	     INNER JOIN Folder E ON E.Id = T.FolderId
		 
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