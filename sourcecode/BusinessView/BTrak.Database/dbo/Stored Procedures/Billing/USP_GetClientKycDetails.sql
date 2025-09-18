---------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetClientKycDetails]@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetClientKycDetails]
(
    @ClientId UNIQUEIDENTIFIER
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = '1'
		
		IF (@HavePermission = '1')
	    BEGIN
		   DECLARE @UserId UNIQUEIDENTIFIER = (SELECT UserId FROM Client WHERE Id = @ClientId)
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
       	   
           SELECT 
		   	      C.KycFormData,
				  CONCAT(U.FirstName,' ',U.SurName)FullName,
				  REPLACE(REPLACE(REPLACE(CK.FormJson,'##UserId##',@UserId),'##CompanyId##',@CompanyId),'##ClientId##',C.Id) AS FormJson,
				  C.CompanyId,
				  C.Id AS ClientId,
				  CKS.KycStatusName,
				  C.[UserId],
				  C.[TimeStamp],
				  CK.FormBgColor
           FROM [Client] AS C	        
		   LEFT JOIN ClientKycConfiguration CK ON CK.Id = C.ClientKycId
		   LEFT JOIN [ClientKycFormStatus] CKS ON CKS.Id = C.KycFormStatusId
		   LEFT JOIN [User] U ON C.UserId = U.Id 
           WHERE C.CompanyId = @CompanyId AND C.Id = @ClientId
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