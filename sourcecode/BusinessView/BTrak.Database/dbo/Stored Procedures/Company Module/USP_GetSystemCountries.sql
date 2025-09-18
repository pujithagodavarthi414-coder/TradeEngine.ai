-------------------------------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-07-26 00:00:00.000'
-- Purpose      To Get System Countries
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetSystemCountries] 
---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetSystemCountries]
(
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
	@CountryId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

		   IF(@SearchText = '') SET @SearchText = NULL
		   
		   SET @SearchText  = '%'+ @SearchText +'%'  
		     
           SELECT C.Id AS CountryId,
		   	      C.CountryName,
				  C.CountryCode,
		   	      C.InActiveDateTime,
		   	      C.CreatedDateTime,
		   	      C.[TimeStamp],	
		   	      TotalCount = COUNT(1) OVER()
           FROM SYS_Country AS C		      
           WHERE (@CountryId IS NULL OR Id = @CountryId) 
		        AND(@SearchText IS NULL 
			        OR (C.CountryName LIKE @SearchText)
					OR (C.CountryCode LIKE @SearchText))
			   AND (@IsArchived IS NULL OR(@IsArchived = 0 AND C.InActiveDateTime IS NULL) OR(@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL))
		   	    
           ORDER BY C.CountryName ASC

   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END