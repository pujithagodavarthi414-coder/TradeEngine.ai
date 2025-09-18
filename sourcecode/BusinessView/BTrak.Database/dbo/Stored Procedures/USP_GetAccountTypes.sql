---------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-03-14 00:00:00.000'
-- Purpose      To get the Account Types by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetAccountTypes] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetAccountTypes]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@AccountTypeId UNIQUEIDENTIFIER = NULL,	
	@AccountTypeName NVARCHAR(150) = NULL,	
	@SearchText    NVARCHAR(250) = NULL,
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

		   IF(@SearchText = '') SET @SearchText   = NULL
		   
		   IF(@AccountTypeId = '00000000-0000-0000-0000-000000000000') SET @AccountTypeId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT AT.Id AS AccountTypeId,
		   	      AT.CompanyId,
				  AT.AccountTypeName,			
		   	      AT.InActiveDateTime,
		   	      AT.CreatedDateTime ,
		   	      AT.CreatedByUserId,
		   	      AT.[TimeStamp],
				  (CASE WHEN AT.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(*) OVER()
           FROM [AccountType] AS AT		        
           WHERE AT.CompanyId = @CompanyId
		        AND (@SearchText IS NULL OR (AT.AccountTypeName LIKE  '%'+ @SearchText +'%'  ))				
		   	    AND (@AccountTypeId IS NULL OR AT.Id = @AccountTypeId)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND AT.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND AT.InActiveDateTime IS NULL))
           ORDER BY AT.AccountTypeName ASC

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