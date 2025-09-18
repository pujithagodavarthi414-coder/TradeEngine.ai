CREATE PROCEDURE [dbo].[USP_InsertLeaveApplicationAuditHistory]
(
 @LeaveApplicationId UNIQUEIDENTIFIER = NULL,
 @FromDate DATE = NULL,
 @ToDate DATE = NULL,
 @Reason NVARCHAR(800) = NULL,
 @FromLeaveSession UNIQUEIDENTIFIER = NULL,
 @ToLeaveSession UNIQUEIDENTIFIER = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
 @LeaveStatusId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	
 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
 IF (@HavePermission = '1')
 BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	SET @LeaveStatusId = (SELECT Id FROM LeaveStatus WHERE IsWaitingForApproval = 1 AND CompanyId = @CompanyId)

	DECLARE @OldFromDate DATE = NULL

	DECLARE @OldToDate DATE = NULL

	DECLARE @OldValue NVARCHAR(MAX),@NewValue NVARCHAR(MAX)

	DECLARE @OldReason NVARCHAR(800) = NULL

	DECLARE @OldFromLeaveSession UNIQUEIDENTIFIER = NULL

	DECLARE @OldToLeaveSession UNIQUEIDENTIFIER = NULL

	DECLARE @OldLeaveStatus UNIQUEIDENTIFIER 

	SELECT @OldFromDate         =  LeaveDateFrom,
		   @OldToDate			=  LeaveDateTo,
		   @OldReason 			=  LeaveReason,
		   @OldFromLeaveSession	=  FromLeaveSessionId,
		   @OldToLeaveSession 	=  ToLeaveSessionId,
		   @OldLeaveStatus      =  OverallLeaveStatusId
		   FROM LeaveApplication WHERE Id = @LeaveApplicationId

	IF(@OldFromDate <> @FromDate)
	BEGIN

		SET @OldValue =  CONVERT(VARCHAR, @OldFromDate, 101)
		SET @NewValue =  CONVERT(VARCHAR, @FromDate, 101)

		EXEC UpsertLeaveHistory @OldValue = @OldValue,@NewValue = @NewValue,@OperationsPerformedBy = @OperationsPerformedBy,
		                        @LeaveApplicationId = @LeaveApplicationId,@Description = 'leave date from'

	END

	IF(@OldToDate <> @ToDate)
	BEGIN

		SET @OldValue =  CONVERT(VARCHAR, @OldToDate, 101)
		SET @NewValue =  CONVERT(VARCHAR, @ToDate, 101)

		EXEC UpsertLeaveHistory @OldValue = @OldValue,@NewValue = @NewValue,@OperationsPerformedBy = @OperationsPerformedBy,
		                        @LeaveApplicationId = @LeaveApplicationId,@Description = 'leave date to'

	END

	IF(@OldFromLeaveSession <> @FromLeaveSession)
	BEGIN

		SET @OldValue =  (SELECT LeaveSessionName FROM LeaveSession WHERE Id = @OldFromLeaveSession)
		SET @NewValue =  (SELECT LeaveSessionName FROM LeaveSession WHERE Id = @FromLeaveSession)

		EXEC UpsertLeaveHistory @OldValue = @OldValue,@NewValue = @NewValue,@OperationsPerformedBy = @OperationsPerformedBy,
		                        @LeaveApplicationId = @LeaveApplicationId,@Description = 'from leave session'

	END
	IF(@OldToLeaveSession <> @ToLeaveSession)
	BEGIN

		SET @OldValue =  (SELECT LeaveSessionName FROM LeaveSession WHERE Id = @OldToLeaveSession)
		SET @NewValue =  (SELECT LeaveSessionName FROM LeaveSession WHERE Id = @ToLeaveSession)

		EXEC UpsertLeaveHistory @OldValue = @OldValue,@NewValue = @NewValue,@OperationsPerformedBy = @OperationsPerformedBy,
		                        @LeaveApplicationId = @LeaveApplicationId,@Description = 'to leave session'

	END
	IF(@OldReason <> @Reason)
	BEGIN

		SET @OldValue =  @OldReason
		SET @NewValue =  @Reason

		EXEC UpsertLeaveHistory @OldValue = @OldValue,@NewValue = @NewValue,@OperationsPerformedBy = @OperationsPerformedBy,
		                        @LeaveApplicationId = @LeaveApplicationId,@Description = 'reason'

	END

	IF(@OldFromDate = @FromDate AND @OldToDate = @ToDate AND @OldFromLeaveSession = @FromLeaveSession AND @OldToLeaveSession = @ToLeaveSession AND @OldReason = @Reason)
	BEGIN

		EXEC UpsertLeaveHistory @OldValue = NULL,@NewValue = NULL,@OperationsPerformedBy = @OperationsPerformedBy,
		                        @LeaveApplicationId = @LeaveApplicationId,@Description = 'Reapplied'

	END

	IF(@OldFromDate = @FromDate AND @OldToDate = @ToDate AND @OldFromLeaveSession = @FromLeaveSession AND @OldToLeaveSession = @ToLeaveSession AND @OldReason = @Reason AND @OldLeaveStatus = @LeaveStatusId)
	BEGIN

		SELECT 1 AS IsAlreadyUptoDate

	END
 END
END