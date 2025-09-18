-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-01-08 00:00:00.000'
-- Purpose      To Get the triggers By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetTriggers] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetTriggers]
(
  @TriggerId UNIQUEIDENTIFIER = NULL,
  @TriggerName NVARCHAR(250) = NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
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
		   
	       IF (@TriggerId = '00000000-0000-0000-0000-000000000000')  SET @TriggerId = NULL
		   
	       IF (@TriggerName = '')  SET @TriggerName = NULL
		   
	       IF (@IsArchived IS NULL)  SET @IsArchived = 0
		   
	        SELECT T.Id AS TriggerId,
		           T.TriggerName,
		   		   T.CreatedDatetime,
		   		   T.CreatedByUserId,
		   		   T.UpdatedByUserId,
		   		   T.UpdatedDateTime,
				   CASE WHEN T.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
		   		   TotalCount = COUNT(1) OVER()
	       FROM [dbo].[Trigger] T WITH (NOLOCK)
	       WHERE (@TriggerId IS NULL OR T.Id = @TriggerId)
		         AND  (T.InActiveDateTime IS NULL AND @IsArchived = 0) OR (T.InActiveDateTime IS NOT NULL AND @IsArchived = 1)
           ORDER BY T.TriggerName 

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

