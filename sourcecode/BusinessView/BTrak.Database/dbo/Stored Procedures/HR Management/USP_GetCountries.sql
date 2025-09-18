-------------------------------------------------------------------------------------------------------
-- Author       Aswani k
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update SoftLabel
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetCountries]  @SearchText = 'India'
---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetCountries]
(
    @CountryId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@CountryName NVARCHAR(250) = NULL,
	@CountryCode NVARCHAR(250) = NULL,
	@IsArchived BIT= NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF (@HavePermission = '1')
		BEGIN

		   IF(@SearchText = '') SET @SearchText = NULL
		   
		   SET @SearchText  = '%'+ @SearchText +'%'

		   IF(@CountryId = '00000000-0000-0000-0000-000000000000') SET @CountryId = NULL	
		   
		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		     
           SELECT C.Id AS CountryId,
		   	      C.CompanyId,
		   	      C.CountryName,
				  C.CountryCode,
		   	      C.InActiveDateTime,
		   	      C.CreatedDateTime ,
		   	      C.CreatedByUserId,
		   	      C.[TimeStamp],	
		   	      TotalCount = COUNT(1) OVER()
           FROM Country AS C		        
           WHERE C.CompanyId = @CompanyId
			   AND (@CountryName IS NULL OR (C.CountryName = @CountryName))
			   AND (@CountryCode IS NULL OR (C.CountryCode = @CountryCode))
		       AND (@SearchText IS NULL 
			        OR (C.CountryName LIKE @SearchText)
					OR (C.CountryCode LIKE @SearchText))
		   	   AND (@CountryId IS NULL OR C.Id = @CountryId)
			   AND (@IsArchived IS NULL OR(@IsArchived = 0 AND InActiveDateTime IS NULL) OR(@IsArchived = 1 AND InActiveDateTime IS NOT NULL))
		   	    
           ORDER BY C.CountryName ASC

		END
   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
Go