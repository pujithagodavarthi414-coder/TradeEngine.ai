---------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-05-06
-- Purpose      To get the departments by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetWebHook] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived=1
-----------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetWebHook]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@WebHookId UNIQUEIDENTIFIER = NULL,	
	@SearchText  NVARCHAR(250) = NULL,
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
		   IF(@SearchText = '') SET @SearchText = NULL

		   SET @SearchText = '%'+ @SearchText +'%'
		   
		   IF(@WebHookId = '00000000-0000-0000-0000-000000000000') SET @WebHookId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT WH.Id AS WebHookId,
		   	      WH.CompanyId,
		   	      WH.WebHookName,
		   	      WH.WebHookUrl,
		   	      WH.InActiveDateTime,
		   	      WH.CreatedDateTime ,
		   	      WH.CreatedByUserId,
		   	      WH.[TimeStamp],
				  (CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(*) OVER()
           FROM WebHook AS WH	        
           WHERE WH.CompanyId = @CompanyId
		        AND (@SearchText IS NULL OR (WH.WebHookName LIKE  '%'+ @SearchText +'%'))
		   	    AND (@WebHookId IS NULL OR WH.Id = @WebHookId)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND WH.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND WH.InActiveDateTime IS NULL))
		   	    
           ORDER BY WH.WebHookName ASC

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