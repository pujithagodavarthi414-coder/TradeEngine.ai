-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertProbationSubmissionDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertProbationSubmissionDetails]
(
	@ProbationDetailsId UNIQUEIDENTIFIER = NULL,
	@ProbationId UNIQUEIDENTIFIER = NULL,
	@IsCompleted BIT = NULL,
	@SubmissionFrom INT = NULL,
	@FormData NVARCHAR(MAX) = NULL,
	@SubmittedBy UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@IsCompleted IS NULL) SET @IsCompleted = 0
			
			IF (@ProbationDetailsId =  '00000000-0000-0000-0000-000000000000') SET @ProbationDetailsId = NULL

			IF (@ProbationId =  '00000000-0000-0000-0000-000000000000') SET @ProbationId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @ProbationIdCount INT = (SELECT COUNT(1) FROM ProbationSubmission WHERE Id = @ProbationId)

			DECLARE @InviteeCount INT = (SELECT COUNT(1) FROM ProbationSubmissionDetails WHERE ProbationSubmissionId = @ProbationId AND SubmissionFrom = 2 AND SubmittedBy = @SubmittedBy)
			
			IF (@ProbationIdCount = 0 AND @ProbationId IS NOT NULL)
			BEGIN
				    
					RAISERROR(50002,16,1,'Probation')

			END
			IF (@ProbationDetailsId IS NULL AND @InviteeCount > 0 AND @SubmissionFrom = 2)
			BEGIN
				   
	          RAISERROR('ThisUserIsAlreadyInvited',11,1)

			END
			ELSE
			BEGIN
				DECLARE @CurrentDate DATETIME = GETDATE()

				IF(@ProbationDetailsId IS NULL)
				BEGIN

					  SET @ProbationDetailsId = NEWID()

						  INSERT INTO ProbationSubmissionDetails(Id,
							    			ProbationSubmissionId,
											SubmissionFrom,
											IsCompleted,
											FormData,
											SubmittedBy,
							    			CreatedDateTime,
							    			CreatedByUserId
							    		   )
							    	SELECT  @ProbationDetailsId,
											@ProbationId,
											@SubmissionFrom,
											@IsCompleted,
											@FormData,
											@SubmittedBy,
							    			@CurrentDate,
							    			@OperationsPerformedBy
		              
					   END
					   ELSE
					   BEGIN

					   UPDATE ProbationSubmissionDetails
					     SET  SubmissionFrom = @SubmissionFrom,
							  FormData = @FormData,
							  IsCompleted = @IsCompleted,
							  SubmittedBy = @SubmittedBy,
							  UpdatedByUserId = @OperationsPerformedBy,
							  UpdatedDateTime = @CurrentDate
							 WHERE Id = @ProbationDetailsId

					   END

				SELECT Id FROM ProbationSubmissionDetails WHERE Id = @ProbationDetailsId
					
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