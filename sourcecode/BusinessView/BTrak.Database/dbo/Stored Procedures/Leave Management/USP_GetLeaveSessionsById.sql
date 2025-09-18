-------------------------------------------------------------------------------
-- Author       Sai Praneeth Mamidi
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get LeaveSessions By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetLeaveSessionsById]@OperationPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@LeaveSessionId='3C6F106A-160F-4644-86B8-6214123ACA0E'

CREATE PROCEDURE [dbo].[USP_GetLeaveSessionsById]
(
	@OperationPerformedBy UNIQUEIDENTIFIER,
	@LeaveSessionId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	  IF(@HavePermission = '1')
      BEGIN
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationPerformedBy))

        SELECT LS.Id AS LeaveSessionId,
			   LS.LeaveSessionName,
			   LS.CreatedDateTime,
			   LS.CreatedByUserId,
			   LS.CompanyId
        FROM LeaveSession AS LS WITH (NOLOCK)
        WHERE (@LeaveSessionId IS NULL OR LS.Id = @LeaveSessionId)
			  AND LS.CompanyId = @CompanyId
    END
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
GO
