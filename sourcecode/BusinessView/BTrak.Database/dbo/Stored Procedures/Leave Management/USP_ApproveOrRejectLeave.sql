--EXEC [USP_ApproveOrRejectLeave] @OperationsPerformedBy = 'DC914F23-1F7C-45E1-8253-A674D3ADE939',@LeaveApplicationId ='E0BF2583-7CEB-482F-B0A2-EC8B7B3C112C',@IsApproved = 1
CREATE PROCEDURE [dbo].[USP_ApproveOrRejectLeave]
(
 @LeaveApplicationId UNIQUEIDENTIFIER = NULL,
 @IsApproved BIT = NULL,
 @LeaveStatusId UNIQUEIDENTIFIER = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
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

		DECLARE @LeaveApplicantUserId UNIQUEIDENTIFIER = (SELECT UserId FROM LeaveApplication WHERE Id = @LeaveApplicationId);

		IF (@LeaveApplicationId IS NULL)
		BEGIN

			RAISERROR(50011,11,1,'LeaveApplication')

		END
		ELSE IF (@IsApproved IS NULL)
		BEGIN

			RAISERROR(50011,11,1,'LeaveStatus')

		END
		ELSE
		BEGIN

			IF(ISNULL(@IsApproved,0) = 0)
			BEGIN

				SET @LeaveApplicability ='1'

			END

				SET @LeaveApplicability = (SELECT [dbo].[Ufn_CheckYetToDateLeaves](@LeaveApplicationId))

			IF(@LeaveApplicability = '1')
			BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			DECLARE @ReportToCount INT = (SELECT COUNT(1) FROM [dbo].[Ufn_GetEmployeeReportToMembers](@LeaveApplicantUserId))

			DECLARE @DateFrom DATETIME = (SELECT [LeaveDateFrom] FROM LeaveApplication WHERE Id = @LeaveApplicationId)

			DECLARE @DateTo DATETIME = (SELECT [LeaveDateTo] FROM LeaveApplication WHERE Id = @LeaveApplicationId)

			DECLARE @ApproveOrRejectedBy NVARCHAR(100) = (SELECT FirstName +' '+ SurName FROM [User] WHERE Id = @OperationsPerformedBy)

			SET @LeaveStatusId = (CASE WHEN @IsApproved = 1 THEN (SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId) ELSE (SELECT Id FROM LeaveStatus WHERE IsRejected = 1 AND CompanyId = @CompanyId) END)

			--SELECT @LeaveStatusId

			IF(@IsApproved = 0)
			BEGIN

				UPDATE LeaveApplication SET OverallLeaveStatusId = (SELECT Id FROM LeaveStatus WHERE IsRejected = 1 AND CompanyId = @CompanyId),UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE Id = @LeaveApplicationId

				UPDATE LeaveApplicationStatusSetHistory SET InActiveDateTime = GETDATE() WHERE LeaveApplicationId = @LeaveApplicationId AND InActiveDateTime IS NULL

			END

			INSERT INTO [LeaveApplicationStatusSetHistory](
											               [Id]
											              ,[LeaveApplicationId]
											              ,[LeaveStatusId]
											              ,[LeaveStuatusSetByUserId]
											              ,[CreatedDateTime]
											              ,[CreatedByUserId]
														  ,[Reason]
														  ,[Description]
				                                          )
									                SELECT NEWID()
									                      ,@LeaveApplicationId
									                      ,@LeaveStatusId
									                      ,@OperationsPerformedBy
									                      ,GETDATE()
									                      ,@OperationsPerformedBy
														  ,@Reason
														  ,CASE WHEN @IsApproved = 1 THEN 'Approved' ELSE 'Rejected'END

            IF(@IsApproved = 1) 
			BEGIN

			DECLARE @ToApproveCount INT = (SELECT COUNT(1) FROM (SELECT UserId FROM [dbo].[Ufn_GetEmployeeReportToMembers](@LeaveApplicantUserId) WHERE (@ReportToCount = 1 OR (@ReportToCount > 1 AND UserLevel > 0)) GROUP BY UserId)T)
			
			DECLARE @ApproveCount INT = (SELECT COUNT(1) FROM [LeaveApplicationStatusSetHistory] WHERE LeaveApplicationId = @LeaveApplicationId AND InActiveDateTime IS NULL AND [Description] = 'Approved' GROUP BY LeaveApplicationId)

				IF(@ToApproveCount = @ApproveCount)
				BEGIN
			    
					UPDATE LeaveApplication SET OverallLeaveStatusId = (SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId),UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE Id = @LeaveApplicationId

				END
			END

			SELECT @LeaveApplicationId AS LeaveApplicationId, 
				   @ApproveOrRejectedBy AS ApproveOrRejectedBy, 
				   IIF(@IsApproved = 1,'Approved','Rejected') AS LeaveStatus, 
				   @LeaveApplicantUserId AS AppliedUserId, 
				   FORMAT(@DateFrom, 'dd-MM-yyyy') AS DateFrom,  
				   FORMAT(@DateTo, 'dd-MM-yyyy') AS DateTo, 
				   @Reason AS Reason,
				   @LeaveStatusId AS LeaveStatusId

			END
			ELSE

				RAISERROR('RestrictionCrossed',16,1)
		END
		END
		ELSE
			
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO