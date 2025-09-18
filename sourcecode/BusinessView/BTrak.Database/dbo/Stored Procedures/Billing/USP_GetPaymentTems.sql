CREATE PROCEDURE [dbo].[USP_GetPaymentTems]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@Id UNIQUEIDENTIFIER = NULL,	
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

		   IF(@SearchText   = '') SET @SearchText   = NULL
		   
		   IF(@Id = '00000000-0000-0000-0000-000000000000') SET @Id = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT PM.Id,
		   	      PM.CompanyId,
				  PM.PaymentTermName AS [Name],			
		   	      PM.InActiveDateTime,
		   	      PM.CreatedDateTime,
		   	      PM.CreatedByUserId,
		   	      PM.[TimeStamp],
				  (CASE WHEN PM.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(*) OVER()
           FROM [PaymentTerms] AS PM		        
           WHERE PM.CompanyId = @CompanyId
		        AND (@SearchText   IS NULL OR (PM.PaymentTermName LIKE  '%'+ @SearchText +'%'  ))				
		   	    AND (@Id IS NULL OR PM.Id = @Id)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND PM.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND PM.InActiveDateTime IS NULL))
		   	    
           ORDER BY PM.PaymentTermName ASC

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