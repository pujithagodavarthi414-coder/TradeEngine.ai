-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-01-31 00:00:00.000'
-- Purpose      To Get The TransitionDeadlines By Applying DifferenT Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetTransitionDeadlineById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TransitionDeadlineId='946E9D06-B22D-4019-9AE0-10871C3C4886'

CREATE PROCEDURE [dbo].[USP_GetTransitionDeadlineById]
(
    @TransitionDeadlineId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)  
AS
BEGIN
    SET NOCOUNT ON

       BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

           SELECT TD.Id AS TransitionDeadlineId,
		          TD.Deadline,
				  TD.CompanyId,
		          TD.CreatedDateTime,
				  TD.CreatedByUserId,
				  TD.UpdatedDateTime,
				  TD.UpdatedByUserId
        FROM [TransitionDeadline] TD WITH (NOLOCK)
        WHERE TD.[Id] = @TransitionDeadlineId AND TD.[CompanyId] = @CompanyId

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