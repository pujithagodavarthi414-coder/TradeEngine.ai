-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetClientKycHistory] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetClientKycHistory]
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

		DECLARE @HavePermission NVARCHAR(250)  =(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN	  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT CLH.OldValue,
				  CLH.NewValue,
				  CLH.[Description],
				  CLH.CreatedDateTime,
				  CLH.CreatedByUserId,
				  CLH.ClientId,
				  CONCAT(U.FirstName,' ',U.SurName) AS CreatedUser,
				  CONCAT(CU.FirstName,' ',CU.SurName) AS ClientName
           FROM ClientKycFormHistory AS CLH
				LEFT JOIN Client C ON C.Id = CLH.ClientId
				INNER JOIN [User] U ON U.Id = CLH.CreatedByUserId
				INNER JOIN [User] CU ON CU.Id = C.UserId
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
