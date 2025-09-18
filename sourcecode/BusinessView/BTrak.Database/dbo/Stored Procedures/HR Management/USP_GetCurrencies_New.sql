---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      To get the currencies by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetCurrencies_New] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived=0

CREATE PROCEDURE [dbo].[USP_GetCurrencies_New]
(
  	@CurrencyId UNIQUEIDENTIFIER = NULL,	
	@CurrencyCode NVARCHAR(500) = NULL,
	@CurrencySymbol NVARCHAR(500) = NULL,
	@SearchText   NVARCHAR(250) = NULL,
	@IsArchived BIT= NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF (@HavePermission = '1')
		BEGIN

		   IF(@SearchText  = '') SET @SearchText  = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@CurrencyId = '00000000-0000-0000-0000-000000000000') SET @CurrencyId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT C.Id AS CurrencyId,
		   	      C.CompanyId,
				  C.CurrencyName,
		   	      C.CurrencyCode,
				  C.Symbol AS CurrencySymbol,			
		   	      C.InActiveDateTime,
		   	      C.CreatedDateTime,
		   	      C.CreatedByUserId,
		   	      C.[TimeStamp],
				  (CASE WHEN C.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER(),
				  SC.Id SysCurrencyId
           FROM Currency AS C
		   LEFT JOIN SYS_Currency SC on SC.CurrencyCode = C.CurrencyCode  
           WHERE (C.CompanyId = @CompanyId OR @CompanyId IS NULL)
		     AND (@SearchText  IS NULL OR (C.CurrencyName LIKE  @SearchText ))
			 AND (@CurrencyCode IS NULL OR C.CurrencyCode = @CurrencyCode)
		     AND (@CurrencyId IS NULL OR (C.Id = @CurrencyId OR SC.id = @CurrencyId))
			 AND (@IsArchived IS NULL 
			  OR (@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL)
			  OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL))
		   	    
           ORDER BY C.CurrencyName ASC

	END

   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END