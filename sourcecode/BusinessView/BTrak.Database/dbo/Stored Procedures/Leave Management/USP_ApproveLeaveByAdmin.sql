CREATE PROCEDURE [dbo].[USP_ApproveLeaveByAdmin]
(
	@LeaveApplicationId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@IsApproved BIT = NULL,
	@Reason NVARCHAR(MAX) = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	BEGIN TRY

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
	IF (@HavePermission = '1')
	BEGIN
		
		DECLARE @LeaveApplicability NVARCHAR(100)

		IF(ISNULL(@IsApproved,0) = 0)
		BEGIN

			SET @LeaveApplicability ='1'

		END
		ELSE
		BEGIN

			SET @LeaveApplicability = (SELECT [dbo].[Ufn_CheckYetToDateLeaves](@LeaveApplicationId))
		
		END

		IF(@LeaveApplicability = '1')
		BEGIN

			DECLARE @IsLatest BIT = (CASE WHEN @LeaveApplicationId IS NULL 
			                                   THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                               FROM LeaveApplication WHERE Id = @LeaveApplicationId) = @TimeStamp
			                                                        THEN 1 ELSE 0 END END)
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @LeaveStatusId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveStatus WHERE ((IsApproved = 1 AND @IsApproved = 1) OR (IsRejected = 1 AND (@IsApproved IS NULL OR @IsApproved = 0))) AND CompanyId = @CompanyId)

			DECLARE @AppliedUserId UNIQUEIDENTIFIER = (SELECT UserId FROM LeaveApplication WHERE Id = @LeaveApplicationId)
			DECLARE @DateFrom DATETIME = (SELECT [LeaveDateFrom] FROM LeaveApplication WHERE Id = @LeaveApplicationId)
			DECLARE @DateTo DATETIME = (SELECT [LeaveDateTo] FROM LeaveApplication WHERE Id = @LeaveApplicationId)
			DECLARE @ApproveOrRejectedBy NVARCHAR(100) = (SELECT FirstName +' '+ SurName FROM [User] WHERE Id = @OperationsPerformedBy)

			IF(@IsLatest = 1)
			BEGIN

				UPDATE LeaveApplication SET OverallLeaveStatusId = @LeaveStatusId,UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE()
				WHERE Id = @LeaveApplicationId
				
				UPDATE LeaveApplicationStatusSetHistory SET InActiveDateTime = GETDATE() WHERE InActiveDateTime IS NULL AND LeaveApplicationId = @LeaveApplicationId

				INSERT INTO LeaveApplicationStatusSetHistory(
													 Id,
													 LeaveStatusId,
													 [Description],
												     [LeaveStuatusSetByUserId],
													 CreatedByUserId,
													 CreatedDateTime,
													 LeaveApplicationId,
													 Reason
													)
											 SELECT NEWID(),
											        @LeaveStatusId,
													IIF(@IsApproved = 1,'Approved','Rejected'),
													@OperationsPerformedBy,
													@OperationsPerformedBy,
													GETDATE(),
													@LeaveApplicationId,
													@Reason

					SELECT  @ApproveOrRejectedBy AS ApproveOrRejectedBy, 
							IIF(@IsApproved = 1,'Approved','Rejected') AS LeaveStatus, 
							@AppliedUserId AS AppliedUserId, 
							FORMAT(@DateFrom, 'dd-MM-yyyy') AS DateFrom,  
							FORMAT(@DateTo, 'dd-MM-yyyy') AS DateTo, 
							@Reason AS Reason
			
			END
			ELSE

				RAISERROR(50008,11,1)
		END			
		ELSE

			RAISERROR('RestrictionCrossed',16,1)

    END
    ELSE

		RAISERROR(@HavePermission,11,1)
	
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO
