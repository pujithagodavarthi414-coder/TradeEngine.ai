---------------------------------------------------------------------------------
---- Author       Padmini B
---- Created      '2019-04-18 00:00:00.000'
---- Purpose      To Delete Leave Application
---- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
----DECLARE @Temp TIMESTAMP = (SELECT TimeStamp FROM LeaveApplication WHERE Id = 'BB3EA960-9F77-490B-9C58-F097F4690A95')
----EXEC [dbo].[USP_DeleteLeave] @LeaveId='BB3EA960-9F77-490B-9C58-F097F4690A95'
----,@FeatureId = '89E07D67-ED72-48E0-9F43-FB1715848312'
----,@TimeStamp = @Temp
----,@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--CREATE PROCEDURE [dbo].[USP_DeleteLeave]
--(
--   @LeaveId UNIQUEIDENTIFIER = NULL,
--   @TimeStamp TIMESTAMP = NULL,
--   @OperationsPerformedBy UNIQUEIDENTIFIER
--)
--AS
--BEGIN
--   SET NOCOUNT ON
--   BEGIN TRY
--   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   
--		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
    
--       IF (@HavePermission = '1')
--       BEGIN

--           DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp]
--                                               FROM LeaveApplication WHERE OriginalId = (SELECT OriginalId FROM LeaveApplication WHERE OriginalId = @LeaveId) AND AsAtInactiveDateTime IS NULL AND [InActiveDateTime] IS NULL) = @TimeStamp
--                                         THEN 1 ELSE 0 END)

--           IF(@IsLatest = 1)
--           BEGIN

--               DECLARE @CurrentDate DATETIME = GETDATE()

--               DECLARE @NewLeaveId UNIQUEIDENTIFIER = NEWID()

--               DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
--                 INSERT INTO [dbo].LeaveApplication(
--                                   [Id],
--								   [UserId],
--								   [LeaveAppliedDate],
--								   [LeaveReason],
--								   [LeaveTypeId],
--								   [LeaveDateFrom],
--								   [LeaveDateTo],
--								   [IsDeleted],
--								   [OverallLeaveStatusId],
--								   [FromLeaveSessionId],
--								   [ToLeaveSessionId],
--								   [InActiveDateTime],
--								   [CreatedDateTime],
--								   [CreatedByUserId],
--								   [VersionNumber], 
--								   [OriginalId])
--                            SELECT @NewLeaveId,
--                                   [UserId],
--								   [LeaveAppliedDate],
--								   [LeaveReason],
--								   [LeaveTypeId],
--								   [LeaveDateFrom],
--								   [LeaveDateTo],
--								   [IsDeleted],
--								   [OverallLeaveStatusId],
--								   [FromLeaveSessionId],
--								   [ToLeaveSessionId],
--								   @Currentdate,
--                                   @Currentdate,
--                                   @OperationsPerformedBy,
--                                   ISNULL(VersionNumber,0) + 1,
--                                   OriginalId
--                              FROM LeaveApplication WHERE OriginalId = @LeaveId

--				UPDATE LeaveApplication SET AsAtInactiveDateTime = @CurrentDate WHERE OriginalId = @LeaveId AND AsAtInactiveDateTime IS NULL AND Id <> @NewLeaveId

--               SELECT OriginalId FROM [dbo].LeaveApplication WHERE Id = @NewLeaveId
                
--           END

--           ELSE

--               RAISERROR (50015,11, 1)

--       END

--       ELSE

--           RAISERROR (@HavePermission,11, 1)

--   END TRY
--   BEGIN CATCH

--          THROW

--   END CATCH
--END
--GO