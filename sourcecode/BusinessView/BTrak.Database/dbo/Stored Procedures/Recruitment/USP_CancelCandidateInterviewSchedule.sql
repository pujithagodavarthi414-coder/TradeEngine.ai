--EXEC [dbo].[USP_CancelCandidateInterviewSchedule] @CandidateInterviewScheduleId = '529d9b6a-0429-4fb6-a91c-cd12b4988e36',
--@CandidateId='ae9a26e1-bdd0-49f8-9f82-a767e635c3f4',@InterviewTypeId='5cb61e75-d649-4fbc-aa73-16f7c52adbca',
--@OperationsPerformedBy='fb5d135e-d329-47d4-9ddb-d5a65d9542f3',@CancelComment='1'
CREATE PROCEDURE [dbo].[USP_CancelCandidateInterviewSchedule]
(
   @CandidateInterviewScheduleId UNIQUEIDENTIFIER = NULL,
   @InterviewTypeId UNIQUEIDENTIFIER,
   @CandidateId UNIQUEIDENTIFIER,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @CancelComment NVARCHAR(MAX)
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@CandidateId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'CandidateId')

		END
		IF(@InterviewTypeId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'InterviewTypeId')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @CandidateInterviewScheduleIdCount INT = (SELECT COUNT(1) FROM CandidateInterviewSchedule  WHERE Id = @CandidateInterviewScheduleId)

			DECLARE @CandidateInterviewScheduleCount INT = (SELECT COUNT(1) FROM CandidateInterviewSchedule WHERE CandidateId = @CandidateId AND InterviewTypeId = @InterviewTypeId AND (@CandidateInterviewScheduleId IS NULL OR @CandidateInterviewScheduleId = Id))
       
			IF(@CandidateInterviewScheduleIdCount = 0 AND @CandidateInterviewScheduleId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'CandidateInterviewSchedule')

			END
			IF (@CandidateInterviewScheduleCount < 1)
			BEGIN

				RAISERROR(50001,11,1,'CandidateInterviewSchedule')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				  UPDATE [CandidateInterviewSchedule] SET
														        IsCancelled = 1,
																InactiveDateTime =GETDATE(),
																UpdatedDateTime = GETDATE(),
																UpdatedByUserId = @OperationsPerformedBy,
																ScheduleCancelComment =  @CancelComment
						WHERE CandidateId = @CandidateId AND InterviewTypeId = @InterviewTypeId
					
					SELECT Id AS CandidateInterviewScheduleId,InterviewTypeId,CandidateId, JobOpeningId, StatusId, 
				  convert(char(5), StartTime, 108) AS StartTime,
				  convert(char(5), EndTime, 108) AS EndTime, 
				  InterviewDate,IsCancelled,IsConfirmed,IsRescheduled,ScheduleComments,
				  CreatedByUserId,CreatedDateTime,InActiveDateTime,UpdatedDateTime,
				  UpdatedByUserId,[TimeStamp],Assignee,ScheduleCancelComment
				  FROM CandidateInterviewSchedule WHERE CandidateId = @CandidateId
				  AND InterviewTypeId = @InterviewTypeId  AND InActiveDateTime IS NOT NULL AND IsCancelled = 1
				     
				END
				ELSE
				BEGIN
				     
					RAISERROR (@HavePermission,11, 1)
				     		
			    END

			END
	END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO
