-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-19 00:00:00.000'
-- Purpose      To Get Subscription Paid By Option
-- Copyright © 2019,Snovasys Software Solutions India Pvt. LtSP., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetSubscriptionPaidByOptions] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetSubscriptionPaidByOptions]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SubscriptionPaidById UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL	
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

		   IF(@SubscriptionPaidById = '00000000-0000-0000-0000-000000000000') SET @SubscriptionPaidById = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT SP.Id AS SubscriptionPaidById,
		   	      SP.CompanyId,
		   	      SP.SubscriptionPaidByName,
		   	      SP.InActiveDateTime,
		   	      SP.CreatedDateTime,
		   	      SP.CreatedByUserId,
		   	      SP.[TimeStamp],	
				  CASE WHEN SP.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM SubscriptionPaidBy AS SP	        
           WHERE SP.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (SP.SubscriptionPaidByName LIKE @SearchText))
		   	   AND (@SubscriptionPaidById IS NULL OR SP.Id = @SubscriptionPaidById)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND SP.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND SP.InActiveDateTime IS NULL))
           ORDER BY SP.SubscriptionPaidByName ASC

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