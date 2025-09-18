---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-07 00:00:00.000'
-- Purpose      To Get the company struture by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetCompanyStructure] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCompanyStructure]
(
    @BranchId UNIQUEIDENTIFIER = NULL,
	@CountryId UNIQUEIDENTIFIER = NULL,
	@RegionId UNIQUEIDENTIFIER = NULL,
	@CountryNameSearchText NVARCHAR(250)  = NULL,
	@RegionNameSearchText NVARCHAR(250)  = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@BranchNameSearchText NVARCHAR(250)  = NULL		
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		  
		   IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
       	   
           SELECT C.Id AS CountryId,
		   	      C.CountryName,
				  (
				  SELECT R1.Id AS RegionId,
				         R1.RegionName,
				        (SELECT  B1.Id AS BranchId,
				                 B1.BranchName
				         FROM Branch B1 
						 WHERE B1.CountryId = R1.CountryId 
						       AND (@BranchId IS NULL OR B1.Id = @BranchId)
							   AND (@BranchNameSearchText IS NULL OR B1.BranchName = @BranchNameSearchText)
							    FOR XML PATH('BranchApiReturnModel'),TYPE) BranchesXml 		   				  				  
				    FROM Region AS R1 
					WHERE R1.CountryId = C.Id
					     AND (@RegionId IS NULL OR R1.Id = @RegionId)
						 AND (@RegionNameSearchText IS NULL OR R1.RegionName = @RegionNameSearchText)					   
					 FOR XML PATH('RegionApiReturnModel'), ROOT('RegionApiReturnModel'), TYPE) AS RegionsXml,			  
		   	      TotalCount = COUNT(*) OVER()
           FROM  [dbo].[Country]C 
		         INNER JOIN [Region]R ON C.Id = R.CountryId
		         INNER JOIN [dbo].[Branch] AS B	ON B.CountryId = C.Id   
           WHERE C.CompanyId = @CompanyId	
		        AND (@BranchId IS NULL OR B.Id = @BranchId)
				AND (@RegionId IS NULL OR R.Id = @RegionId)
				AND (@CountryId IS NULL OR C.Id = @CountryId)
				AND (@CountryNameSearchText IS NULL OR C.CountryName LIKE '%'+@CountryNameSearchText+'%')
				AND (@RegionNameSearchText IS NULL OR R.RegionName LIKE '%'+@RegionNameSearchText+'%')
				AND (@BranchNameSearchText IS NULL OR B.BranchName LIKE  '%'+@BranchNameSearchText+'%')	        		   	    
           GROUP BY C.Id,C.CountryName
		   ORDER BY C.CountryName ASC

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