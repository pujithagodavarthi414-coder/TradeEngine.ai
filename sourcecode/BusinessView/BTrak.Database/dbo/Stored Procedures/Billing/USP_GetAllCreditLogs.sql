-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetAllCreditLogs] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAllCreditLogs]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT = NULL,	
	@ClientId UNIQUEIDENTIFIER = NULL	
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN	  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT CLH.OldCreditLimit,
				  CLH.NewCreditLimit,
				  CLH.OldAvailableCreditLimit,
				  CLH.NewAvailableCreditLimit,
				  CLH.Amount,
				  CLH.[Description],
				  CLH.CreatedDateTime,
				  CLH.CreatedByUserId,
				  CLH.ClientId,
				  CONCAT(U.FirstName,' ',U.SurName) AS CreatedUser,
				  CONCAT(CN.FirstName,' ',CN.SurName) AS ClientName
           FROM ClientCreditLimitHistory AS CLH
				LEFT JOIN Client C ON C.Id = CLH.ClientId
				LEFT JOIN [User] U ON U.Id = CLH.CreatedByUserId
				LEFT JOIN [User] CN ON CN.Id = C.UserId
           WHERE CLH.CompanyId = @CompanyId
		       AND (@ClientId IS NULL OR (CLH.ClientId = @ClientId))
           ORDER BY CLH.CreatedDateTime DESC

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