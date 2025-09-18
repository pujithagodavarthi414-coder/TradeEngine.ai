---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Get the Currencyconversions by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetRegions] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived=0
CREATE PROCEDURE [dbo].[USP_GetRegions]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @SearchText NVARCHAR(250)  = NULL,
    @CountryId UNIQUEIDENTIFIER = NULL,
    @RegionId UNIQUEIDENTIFIER = NULL,      
    @IsArchived BIT= NULL   
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		  
		   IF(@RegionId = '00000000-0000-0000-0000-000000000000') SET @RegionId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
           
           SELECT R.Id AS RegionId,
                  R.CompanyId,
                  R.RegionName,
                  R.CountryId,
                  C.CountryName,                        
                  R.InActiveDateTime,
                  R.CreatedDateTime ,
                  R.CreatedByUserId,
                  R.[TimeStamp],
                  (CASE WHEN R.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As InArchived,   
                  TotalCount = COUNT(*) OVER()
           FROM [dbo].[Region] AS R INNER JOIN [Country] C ON C.Id = R.CountryId         
           WHERE R.CompanyId = @CompanyId
                 AND (@RegionId IS NULL OR R.Id = @RegionId)
                 AND (@CountryId IS NULL OR R.CountryId = @CountryId)
                 AND (@SearchText IS NULL OR R.RegionName LIKE  '%'+ @SearchText +'%')
                 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND R.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND R.InActiveDateTime IS NULL))   
           ORDER BY R.RegionName ASC
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