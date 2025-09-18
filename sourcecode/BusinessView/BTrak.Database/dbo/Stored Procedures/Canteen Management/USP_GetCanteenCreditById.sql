-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-16 00:00:00.000'
-- Purpose      To Get the CanteenCredit By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--   EXEC [dbo].[USP_GetCanteenCreditById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

 CREATE PROCEDURE [dbo].[USP_GetCanteenCreditById]
(
   @CanteenCreditId  UNIQUEIDENTIFIER = NULL, 
   @OperationsPerformedBy  UNIQUEIDENTIFIER 
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	      
		SELECT UCC.Id AS CanteenCreditId,
		       UCC.CreditedToUserId ,
               UCC.CreditedByUserId,
               UCC.Amount,
			   UCC.IsOffered,
               UCC.CreatedDateTime,
               UCC.CreatedByUserId
		FROM  [dbo].[UserCanteenCredit] UCC WITH (NOLOCK) JOIN [User] U ON U.Id = UCC.CreditedToUserId
		WHERE UCC.Id = @CanteenCreditId AND U.CompanyId = @CompanyId

	 END TRY  
	 BEGIN CATCH 
		
		SELECT ERROR_NUMBER() AS ErrorNumber,
			   ERROR_SEVERITY() AS ErrorSeverity, 
			   ERROR_STATE() AS ErrorState,  
			   ERROR_PROCEDURE() AS ErrorProcedure,  
			   ERROR_LINE() AS ErrorLine,  
			   ERROR_MESSAGE() AS ErrorMessage

	END CATCH
END