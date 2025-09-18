CREATE PROCEDURE [dbo].[USP_UpsertCandidateInterviewScheduleAssignee]
(
   @CandidateInteviewScheduleAssigneeId UNIQUEIDENTIFIER = NULL,
   @AssignToUserId UNIQUEIDENTIFIER,
   @CandidateInterviewScheduleId UNIQUEIDENTIFIER,
   @IsApproved BIT,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@AssignToUserId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'AssignToUserId')

		END
		IF(@CandidateInterviewScheduleId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'CandidateInterviewScheduleId')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @CandidateInteviewScheduleAssigneeIdCount INT = (SELECT COUNT(1) FROM CandidateInterviewScheduleAssignee  WHERE Id = @CandidateInteviewScheduleAssigneeId)

			DECLARE @CandidateInteviewScheduleAssigneeCount INT = (SELECT COUNT(1) FROM CandidateInterviewScheduleAssignee WHERE AssignToUserId = @AssignToUserId AND CandidateInterviewScheduleId = @CandidateInterviewScheduleId AND (@CandidateInteviewScheduleAssigneeId IS NULL OR @CandidateInteviewScheduleAssigneeId <> Id))
       
			IF(@CandidateInteviewScheduleAssigneeIdCount = 0 AND @CandidateInteviewScheduleAssigneeId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'CandidateInteviewScheduleAssignee')

			END
			IF (@CandidateInteviewScheduleAssigneeCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'CandidateInteviewScheduleAssignee')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @CandidateInteviewScheduleAssigneeId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [CandidateInterviewScheduleAssignee] WHERE Id = @CandidateInteviewScheduleAssigneeId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@CandidateInteviewScheduleAssigneeId IS NULL)
					  BEGIN

						 SET @CandidateInteviewScheduleAssigneeId = NEWID()

						 INSERT INTO [dbo].[CandidateInterviewScheduleAssignee]([Id],
														  AssignToUserId,
								                          CandidateInterviewScheduleId,
														  IsApproved,
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @CandidateInteviewScheduleAssigneeId,
								                          @AssignToUserId,
								                          @CandidateInterviewScheduleId,
														  @IsApproved,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy		
							         
					END
					ELSE
					BEGIN

						UPDATE [CandidateInterviewScheduleAssignee] SET AssignToUserId = @AssignToUserId,
								                  CandidateInterviewScheduleId = @CandidateInterviewScheduleId,
												  IsApproved = @IsApproved,
									              InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @CandidateInteviewScheduleAssigneeId

					END
				            
				    SELECT Id FROM [dbo].[CandidateInterviewScheduleAssignee] WHERE Id = @CandidateInteviewScheduleAssigneeId
				                   
				  END
				  ELSE
				     
				      RAISERROR (50008,11, 1)
				     
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
