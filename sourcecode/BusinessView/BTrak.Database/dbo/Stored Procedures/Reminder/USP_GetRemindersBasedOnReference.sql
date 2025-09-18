-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To Get Reminders based on reference
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetRemindersBasedOnReference] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetRemindersBasedOnReference]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
     @ReferenceId UNIQUEIDENTIFIER
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
            
              SELECT R.Id AS ReminderId,
					 R.RemindOn,
					 R.OfUser,
					 R.NotificationType,
					 R.ReferenceTypeId,
					 R.ReferenceId,
					 R.AdditionalInfo,
					 R.CompanyId,
					 R.[Status],
					 R.CreatedDateTime,
					 R.CreatedByUserId,
					 CASE WHEN R.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
                     TotalCount = COUNT(1) OVER()
            FROM Reminder R WHERE R.CompanyId = @CompanyId
				AND (R.ReferenceId = @ReferenceId)
				AND (R.CreatedByUserId = @OperationsPerformedBy)
				AND R.InactiveDateTime IS NULL
            ORDER BY R.Status DESC,R.RemindOn DESC
 
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
