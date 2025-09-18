---------------------------------------------------------------------------
-- Author       Gududhuru Raghavendra
-- Created      '2020-01-22 00:00:00.000'
-- Purpose      To Get the Cron expression details
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetCronExpressionDetails] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCronExpressionDetails]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@CustomWidgetId UNIQUEIDENTIFIER = NULL
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
       	   
           SELECT CE.Id AS CronExpressionId,
				  CE.CronExpression,
				  CE.CronExpressionName,
				  CE.JobId,
				  CE.SelectedChartIds,
				  CE.CustomWidgetId,
				  CE.TemplateType,
				  CE.TemplateUrl,
				  CE.CompanyId,
				  CE.ChartsUrls,
				  CE.[TimeStamp]
           FROM [dbo].[CronExpression] AS CE	
		        
           WHERE CE.CustomWidgetId = @CustomWidgetId
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