-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-10-22 00:00:00.000'
-- Purpose      To Get Stores
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetStores] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetStores]
(
  @StoreId UNIQUEIDENTIFIER = NULL,
  @StoreName NVARCHAR(50) = NULL,
  @IsDefault BIT = NULL,
  @IsCompany BIT = NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy  UNIQUEIDENTIFIER
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

       DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

       IF (@HavePermission = '1')
       BEGIN
           IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

           IF(@StoreName = '') SET @StoreName = NULL

           SET @StoreName = '%'+ RTRIM(LTRIM(@StoreName)) +'%'

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

           SELECT S.Id StoreId,
				  S.StoreName,
				  S.IsDefault,
				  S.IsCompany,
				  CASE WHEN STORENAME IN( (SELECT LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 10) + ' doc store' FROM Company WHERE Id = @CompanyId AND InactiveDateTime IS NULL)
				             ,(SELECT LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 10) + ' store' FROM Company WHERE Id = @CompanyId AND InactiveDateTime IS NULL)) THEN 1 ELSE 0 END IsSystemLevel,
                  CASE WHEN S.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				  S.StoreSize,
                  S.[TimeStamp],
				  (SELECT COUNT(1) FROM UploadFile UF WHERE UF.StoreId = S.Id AND InActiveDateTime IS NULL) AS StoreCount,
                  TotalCount = COUNT(1) OVER()
            FROM  [dbo].Store S WITH (NOLOCK)
            WHERE S.CompanyId = @CompanyId
		        AND (@StoreName IS NULL OR (S.StoreName LIKE  '%'+ @StoreName +'%'))
		   	    AND (@StoreId IS NULL OR S.Id = @StoreId)
		   	    AND (@IsCompany IS NULL OR S.IsCompany = @IsCompany)
		   	    AND (@IsDefault IS NULL OR S.IsDefault = @IsDefault)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND S.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND S.InActiveDateTime IS NULL))

               ORDER BY S.StoreName ASC

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