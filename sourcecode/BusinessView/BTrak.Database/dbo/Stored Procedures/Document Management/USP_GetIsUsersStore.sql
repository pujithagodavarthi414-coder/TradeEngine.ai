-- Author       Sai Praneeth M
-- Created      '2019-01-02 00:00:00.000'
-- Purpose      To get is user store or not
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetIsUsersStore] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@FolderId='322AF378-47FE-4987-8A28-B4D2C4400441'

CREATE PROCEDURE [dbo].[USP_GetIsUsersStore]
(
	@FolderId UNIQUEIDENTIFIER,
	@OperationsPerformedBy UNIQUEIDENTIFIER
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

			;WITH Tree as
			(
			  SELECT F.Id,F.ParentFolderId, 1 lvl
			  FROM Folder F
			  WHERE F.Id = @FolderId
  
			  UNION ALL
  
			  SELECT F1.Id,F1.ParentFolderId,M.lvl + 1
			  FROM Folder F1  
			  INNER JOIN Tree M
			  ON M.ParentFolderId = F1.Id
			  WHERE F1.Id IS NOT NULL
			)
			SELECT TOP(1) Id From Tree WHERE ParentFolderId IS NULL

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