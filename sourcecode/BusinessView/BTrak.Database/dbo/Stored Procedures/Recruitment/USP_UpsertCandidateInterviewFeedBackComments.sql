CREATE PROCEDURE [dbo].[USP_UpsertCandidateInterviewFeedBackComments]
(
   @CandidateInterviewFeedBackCommentsId UNIQUEIDENTIFIER = NULL,
   @CandidateInterviewScheduleId UNIQUEIDENTIFIER,
   @AssigneeComments NVARCHAR(MAX),
   @AssigneeId UNIQUEIDENTIFIER,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@AssigneeId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'AssigneeId')

		END
		IF(@CandidateInterviewScheduleId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'CandidateInteviewScheduleId')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @CandidateInterviewFeedBackCommentsIdCount INT = (SELECT COUNT(1) FROM CandidateInterviewFeedBackComments WHERE Id = @CandidateInterviewFeedBackCommentsId)

			--DECLARE @CandidateInterviewFeedBackCommentsCount INT = (SELECT COUNT(1) FROM CandidateInterviewFeedBackComments WHERE AssigneeId = @AssigneeId AND CandidateInterviewScheduleId = @CandidateInterviewScheduleId AND (@CandidateInterviewFeedBackCommentsId IS NULL OR @CandidateInterviewFeedBackCommentsId <> Id))
       
			IF(@CandidateInterviewFeedBackCommentsIdCount = 0 AND @CandidateInterviewFeedBackCommentsId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'CandidateInterviewFeedBackComments')

			END
			--IF (@CandidateInterviewFeedBackCommentsCount > 0)
			--BEGIN

			--	RAISERROR(50001,11,1,'CandidateInterviewFeedBackComments')

			--END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @CandidateInterviewFeedBackCommentsId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [CandidateInterviewFeedBackComments] WHERE Id = @CandidateInterviewFeedBackCommentsId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@CandidateInterviewFeedBackCommentsId IS NULL)
					  BEGIN

						 SET @CandidateInterviewFeedBackCommentsId = NEWID()

						 INSERT INTO [dbo].[CandidateInterviewFeedBackComments]([Id],
														  AssigneeId,
								                          CandidateInterviewScheduleId,
														  AssigneeComments,
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @CandidateInterviewFeedBackCommentsId,
								                          @AssigneeId,
								                          @CandidateInterviewScheduleId,
														  @AssigneeComments,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy		
							         
					END
					ELSE
					BEGIN

						UPDATE [CandidateInterviewFeedBackComments] SET AssigneeId = @AssigneeId,
								                  CandidateInterviewScheduleId = @CandidateInterviewScheduleId,
												  AssigneeComments = @AssigneeComments,
									              InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @CandidateInterviewFeedBackCommentsId

					END
				            
				    SELECT Id FROM [dbo].[CandidateInterviewFeedBackComments] WHERE Id = @CandidateInterviewFeedBackCommentsId
				                   
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
