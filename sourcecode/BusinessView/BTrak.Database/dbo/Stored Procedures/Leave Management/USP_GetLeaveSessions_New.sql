-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-27 00:00:00.000'
-- Purpose      To Get LeaveSessions By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetLeaveSessions_New]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetLeaveSessions_New]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SearchText NVARCHAR(100) = NULL,
	@IsArchived BIT = NULL,
	@LeaveSessionId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@HavePermission = '1')
           BEGIN
           
		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	  
              SELECT LS.Id AS LeaveSessionId,
		      	     LS.LeaveSessionName,
		      	     LS.CreatedDateTime,
		      	     LS.CreatedByUserId,
					 CASE WHEN LS.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
					 LS.InActiveDateTime,
		      	     LS.UpdatedDateTime,
		      	     LS.UpdatedByUserId,
		      	     LS.CompanyId,
					 LS.[TimeStamp],
					 TotalCount = COUNT(1) OVER()

                FROM LeaveSession AS LS WITH (NOLOCK)
               WHERE (@LeaveSessionId IS NULL OR LS.Id = @LeaveSessionId)
			        AND LS.CompanyId = @CompanyId
					AND (@IsArchived IS NULL OR (@IsArchived = 0 AND InActiveDateTime IS NULL)
				    OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))	  
					AND(@SearchText IS NULL OR (LS.LeaveSessionName LIKE '%'+ @SearchText+'%'))

              ORDER BY LS.LeaveSessionName ASC 
      END
	  ELSE
	  BEGIN
	  
	       RAISERROR (@HavePermission,10, 1)
	  
	  END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
