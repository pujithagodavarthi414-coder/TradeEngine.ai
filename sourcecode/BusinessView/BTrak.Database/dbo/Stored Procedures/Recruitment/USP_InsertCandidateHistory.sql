CREATE PROCEDURE [dbo].[USP_InsertCandidateHistory]
(
  @CandidateId UNIQUEIDENTIFIER = NULL,
  @JobOpeningId UNIQUEIDENTIFIER = NULL,
  @OldValue NVARCHAR(250) = NULL,
  @NewValue NVARCHAR(250) = NULL,
  @FieldName NVARCHAR(100) = NULL,
  @Description NVARCHAR(800) = NULL,
  @ReferenceId UNIQUEIDENTIFIER = NULL, 
  @OperationsPerformedBy UNIQUEIDENTIFIER
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @CandidateHistoryId UNIQUEIDENTIFIER = NEWID()
		
		INSERT INTO [dbo].[CandidateHistory](
		            [Id],
		            [CandidateId],
					[JobOpeningId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
		            CreatedByUserId)
		     SELECT @CandidateHistoryId,
		            @CandidateId,
					@JobOpeningId,
		            @OldValue,
					@NewValue,
					@FieldName,
					@Description,
		            SYSDATETIMEOFFSET(),
		            @OperationsPerformedBy

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO