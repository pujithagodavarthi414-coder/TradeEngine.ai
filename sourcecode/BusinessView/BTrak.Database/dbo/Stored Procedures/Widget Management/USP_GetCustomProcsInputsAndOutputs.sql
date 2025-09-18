	-------------------------------------------------------------------------------
-- Author       Ranadher
-- Created      '2020-02-20 00:00:00.000'
-- Purpose      To Get stored proc widgte related inputs and outputs
-- Copyright © 2019,Snovasys Software Solutions India Pvt. LtW., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetCustomProcsInputsAndOutputs] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetCustomProcsInputsAndOutputs]
(
   @CustomWidgetId UNIQUEIDENTIFIER = NULL,
   @ProcName NVARCHAR(800) = NULL,  
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @TimeStamp TIMESTAMP = NULL,
   @CustomStoredProcId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   		   
		   SELECT [Id] AS CustomStoredProcId,
				  [CustomWidgetId],
                  [CompanyId],
                  [ProcName],
                  [Inputs] AS InputsJson,
                  [Outputs] AS OutputsJson,
				  [Legends] AS LegendsJson
		          FROM CustomStoredProcWidget
                  WHERE (@CustomStoredProcId IS NULL OR Id = @CustomStoredProcId)
                    AND (@CustomWidgetId IS NULL OR CustomWidgetId = @CustomWidgetId) --AND CompanyId = @CompanyId
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