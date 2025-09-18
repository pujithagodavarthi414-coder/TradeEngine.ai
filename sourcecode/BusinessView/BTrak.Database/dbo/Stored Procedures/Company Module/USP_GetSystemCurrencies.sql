---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      To get the currencies by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetSystemCurrencies] 
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetSystemCurrencies]
(
	@SearchText   NVARCHAR(250) = NULL,
	@IsArchived BIT= NULL	
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY  
		       	   
           SELECT C.Id AS CurrencyId,
		   	      C.CurrencyName,
		   	      C.CurrencyCode,
				  C.Symbol AS CurrencySymbol,			
		   	      C.InActiveDateTime,
		   	      C.CreatedDateTime ,
		   	      C.[TimeStamp],
				  (CASE WHEN C.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM SYS_Currency AS C	        
           WHERE (@SearchText  IS NULL 
				 OR (C.CurrencyName LIKE  '%'+ @SearchText +'%' ) 
				 OR (C.CurrencyCode LIKE '%'+ @SearchText +'%' )
				 OR (C.Symbol LIKE  '%'+ @SearchText +'%' ))
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL))
           ORDER BY C.CurrencyName ASC
   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END