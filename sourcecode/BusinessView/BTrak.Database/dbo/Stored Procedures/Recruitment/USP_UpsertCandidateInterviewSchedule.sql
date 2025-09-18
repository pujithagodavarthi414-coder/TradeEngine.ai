CREATE PROCEDURE [dbo].[USP_UpsertCandidateInterviewSchedule]
(
   @CandidateInterviewScheduleId UNIQUEIDENTIFIER = NULL,
   @StatusId UNIQUEIDENTIFIER = NULL,
   @InterviewTypeId UNIQUEIDENTIFIER,
   @CandidateId UNIQUEIDENTIFIER,
   @StartTime DATETIMEOFFSET,
   @EndTime DATETIMEOFFSET,
   @InterviewDate DATETIME,
   @IsConfirmed BIT,
   @IsCancelled BIT,
   @IsRescheduled BIT,
   @ScheduleComments NVARCHAR(MAX),
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @Assignee UNIQUEIDENTIFIER =	NULL,
   @JobOpeningId UNIQUEIDENTIFIER,
   @AssigneeIds NVARCHAR(MAX) = NULL
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

			DECLARE @AssigneeIdsList TABLE
					        (
					               AssigneeId UNIQUEIDENTIFIER
					        )
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @CandidateInterviewScheduleId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [CandidateInterviewSchedule] WHERE Id = @CandidateInterviewScheduleId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     IF(@StatusId = '00000000-0000-0000-0000-000000000000') SET  @StatusId = NULL
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@CandidateInterviewScheduleId IS NULL)
					  BEGIN

						 SET @CandidateInterviewScheduleId = NEWID()

						  IF(@IsRescheduled =1)
						 BEGIN
						 UPDATE [CandidateInterviewSchedule] SET 
																InactiveDateTime = @Currentdate,
																UpdatedDateTime = @Currentdate,
																UpdatedByUserId = @OperationsPerformedBy,
																IsRescheduled = @IsRescheduled
																
								WHERE InActiveDateTime IS NULL AND InterviewTypeId = @InterviewTypeId AND CandidateId = @CandidateId
						 END
						 DECLARE @DefaultStatus UNIQUEIDENTIFIER = (SELECT ID FROM ScheduleStatus WHERE [Order]='1' AND CompanyId=@CompanyId)
						 INSERT INTO [dbo].[CandidateInterviewSchedule]([Id],
														  InterviewTypeId,
														  CandidateId,
														  StartTime,
														  EndTime,
														  InterviewDate,
														  IsConfirmed,
														  IsCancelled,
														  IsRescheduled,
														  ScheduleComments,
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId],
														  [JobOpeningId],
														  [StatusId]
														  )
								                   SELECT @CandidateInterviewScheduleId,
								                          @InterviewTypeId,
														  @CandidateId,
														  @StartTime,
														  @EndTime,
														  @InterviewDate,
														  @IsConfirmed,
														  @IsCancelled,
														  @IsRescheduled,
														  @ScheduleComments,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy,
														  @JobOpeningId,
														  @DefaultStatus
					
					INSERT INTO @AssigneeIdsList(AssigneeId)
					SELECT Id FROM dbo.UfnSplit(@AssigneeIds)

					INSERT INTO [CandidateInterviewScheduleAssignee]([Id],
													[AssignToUserId],
													[CandidateInterviewScheduleId],
								                    [IsApproved],
								                    [CreatedDateTime],
								                    [CreatedByUserId]
													)
											SELECT NEWID(),
												   SL.AssigneeId,
												   @CandidateInterviewScheduleId,
												   0,						 
												   @Currentdate,
								                   @OperationsPerformedBy
											FROM @AssigneeIdsList SL
							         
					END
					ELSE
					BEGIN
					IF(@StatusId IS NOT NULL)
					BEGIN

					UPDATE [CandidateInterviewSchedule] SET statusId = @StatusId
						WHERE Id = @CandidateInterviewScheduleId

					END
					ELSE
					BEGIN

						UPDATE [CandidateInterviewSchedule] SET InterviewTypeId = @InterviewTypeId,
														        CandidateId = @CandidateId,
														        StartTime = @StartTime,
														        EndTime = @EndTime,
														        InterviewDate = @InterviewDate,
														        IsConfirmed = @IsConfirmed,
														        IsCancelled = @IsCancelled,
														        IsRescheduled = @IsRescheduled,
														        ScheduleComments = @ScheduleComments,
																InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
																UpdatedDateTime = @Currentdate,
																UpdatedByUserId = @OperationsPerformedBy,
																[JobOpeningId] = @JobOpeningId
						WHERE Id = @CandidateInterviewScheduleId


							INSERT INTO @AssigneeIdsList(AssigneeId)
					SELECT Id FROM dbo.UfnSplit(@AssigneeIds)

					UPDATE [CandidateInterviewScheduleAssignee] SET InactiveDateTime = @Currentdate
                                           ,UpdatedByUserId = @OperationsPerformedBy
                                           ,UpdatedDateTime = @Currentdate
                                       WHERE [CandidateInterviewScheduleId] = @CandidateInterviewScheduleId 
									   AND AssignToUserId NOT IN (SELECT AssigneeId FROM @AssigneeIdsList)

					INSERT INTO [CandidateInterviewScheduleAssignee]([Id],
													[AssignToUserId],
													[CandidateInterviewScheduleId],
								                    [CreatedDateTime],
								                    [CreatedByUserId]
													)
											SELECT NEWID(),
												   SL.AssigneeId,
												   @CandidateInterviewScheduleId,
												   @Currentdate,
								                   @OperationsPerformedBy
											FROM @AssigneeIdsList SL WHERE SL.AssigneeId NOT IN 
											(SELECT AssignToUserId FROM [CandidateInterviewScheduleAssignee] WHERE CandidateInterviewScheduleId=@CandidateInterviewScheduleId AND InActiveDateTime IS NULL)

					END
					END

					EXEC USP_InsertCandidateHistory @CandidateId = @CandidateId, @OldValue = NULL, @NewValue = NULL, @FieldName = NULL,
                       @Description = 'CandidateInterviewScheduleChanged', @OperationsPerformedBy = @OperationsPerformedBy,@JobOpeningId = NULL
				
				            
				    SELECT Id FROM [dbo].[CandidateInterviewSchedule] WHERE Id = @CandidateInterviewScheduleId
				                   
				  END
				  ELSE
				     
				      RAISERROR (50008,11, 1)
				     
				END
				ELSE
				BEGIN
				     
					RAISERROR (@HavePermission,11, 1)
				     		
			    END

			--END
	END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO
