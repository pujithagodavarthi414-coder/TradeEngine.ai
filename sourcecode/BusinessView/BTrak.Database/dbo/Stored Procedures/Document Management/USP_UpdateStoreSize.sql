----------------------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-02-14 00:00:00.000'
-- Purpose      To Update Store size and folder size for a company
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpdateStoreSize] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
----------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpdateStoreSize]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET NOCOUNT ON
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        
		DECLARE @Currentdate DATETIME = GETDATE()

		CREATE TABLE #StoreIds(
								Id UNIQUEIDENTIFIER
							  )

		INSERT INTO #StoreIds SELECT Id FROM Store S1 WHERE S1.CompanyId = @CompanyId AND S1.InActiveDateTime IS NULL
                        
        CREATE TABLE #FolderIds(
                                Id UNIQUEIDENTIFIER,
		                        Lvl INT
                               )
           
        ;WITH Tree as
        (
         SELECT F.Id,1 AS Lvl
         FROM Folder F
         WHERE F.StoreId IN (SELECT Id FROM #StoreIds) AND F.InActiveDateTime IS NULL AND F.ParentFolderId IS NULL
  
         UNION ALL
  
         SELECT F1.Id,T.Lvl + 1
         FROM Folder F1
         INNER JOIN Tree T
         ON T.Id = F1.ParentFolderId AND F1.InActiveDateTime IS NULL
         WHERE T.Id IS NOT NULL
        )

		INSERT INTO #FolderIds SELECT Id,Lvl FROM Tree
        
		DECLARE @MaxLevel INT = (SELECT ISNULL(MAX(Lvl),0) FROM #FolderIds)
		
		WHILE(@MaxLevel > 0)
		BEGIN

		UPDATE Folder SET FolderSize = (SELECT SUM(T.Size) 
		                                       FROM (
													SELECT ISNULL(SUM(FolderSize),0) as Size from Folder where ParentFolderId = F.Id AND InActiveDateTime IS NULL
													UNION
													SELECT ISNULL(SUM(FileSize),0) as Size from UploadFile where FolderId = F.Id AND InActiveDateTime IS NULL) T) 
			   FROM Folder F JOIN #FolderIds FI ON FI.Id = F.Id AND FI.Lvl = @MaxLevel

		SET @MaxLevel = @MaxLevel - 1
		END

		UPDATE Store SET StoreSize = (SELECT SUM(T.Size)
											 FROM(
													SELECT ISNULL(SUM(FolderSize),0) AS Size FROM Folder F WHERE F.ParentFolderId IS NULL AND F.StoreId = S.Id AND F.InActiveDateTime IS NULL
													UNION
													SELECT ISNULL(SUM(FileSize),0) AS Size FROM UploadFile UF WHERE UF.FolderId IS NULL AND UF.StoreId = S.Id AND UF.InActiveDateTime IS NULL
												 ) T )
									 FROM Store S WHERE S.Id IN (SELECT Id FROM #StoreIds) AND S.InActiveDateTime IS NULL
		
    END TRY  
    BEGIN CATCH 
        
           THROW
    END CATCH
END
GO