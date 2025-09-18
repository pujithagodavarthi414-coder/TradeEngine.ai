CREATE PROCEDURE [dbo].[USP_UpsertCallFeedback]
(
    @CallFeedbackId UNIQUEIDENTIFIER = NULL,
	@FeedbackByUserId UNIQUEIDENTIFIER = NULL,
	@ReceiverId UNIQUEIDENTIFIER = NULL,
	@CallConnectedTo NVARCHAR(250) = null,
	@CallOutcomeCode NVARCHAR(250),
	@CallStartedOn DATETIME = null,
	@CallEndedOn DATETIME = null,
	@CallRecordingLink NVARCHAR(MAX) = null,
	@CallDescription NVARCHAR(1000) = null,
	@CallLogDate DATETIME = null,
	@CallLogTime DATETIME = null,
	@ActivityType NVARCHAR(50),
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@CallResource nvarchar(max)
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
        
		DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()
	    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @activityTypeId UNIQUEIDENTIFIER = (select Id from CRMActivityType where ActivityCode = @ActivityType)
		
		IF (@CallFeedbackId IS NOT NULL)
		BEGIN

		      UPDATE [dbo].[CRMCallLog]
		      SET [CallConnectedTo]= @CallConnectedTo,
			      [CallOutcomeCode] = @CallOutcomeCode,
				  [CallDescription] = @CallDescription,
			      [CallStartedOn] = @CallStartedOn,
				  [CallEndedOn] = @CallEndedOn,
				  [CallRecordingLink] = @CallRecordingLink,
				  [CallLoggedDate] = @CallLogDate,
				  [CallLoggedTime] = @CallLogTime,
				  [ActivityTypeId] = @activityTypeId,
			      [CompanyId]= @CompanyId,
				  [UpdatedDateTime] = @Currentdate,
				  [UpdatedByUserId] = @OperationsPerformedBy,
				  [CallResource] = @CallResource
		      WHERE Id = @CallFeedbackId

		END
		ELSE
		BEGIN

			   SELECT @CallFeedbackId = NEWID()

		       INSERT INTO [dbo].[CRMCallLog](
			               [Id],
			   			   [CallConnectedTo],
			   			   [ReceiverId],
			   			   [CallOutcomeCode],
			   			   [CallDescription],
			   			   [CallStartedOn],
						   [CallEndedOn],
						   [CallRecordingLink],
						   [CallLoggedDate],
						   [CallLoggedTime],
						   [ActivityTypeId],
			   			   [CompanyId],
						   [CallResource],
			   			   [CreatedDateTime],
			   			   [CreatedByUserId])
			        SELECT @CallFeedbackId,
			   			   @CallConnectedTo,
			   			   @ReceiverId,
			   			   @CallOutcomeCode,
			   			   @CallDescription,
			   			   @CallStartedOn,
						   @CallEndedOn,
						   @CallRecordingLink,
						   @CallLogDate,
						   @CallLogTime,
						   @activityTypeId,
			   			   @CompanyId,
						   @CallResource,
			   			   @Currentdate,
			   			   @OperationsPerformedBy
			
		END
		
		SELECT Id FROM [dbo].[CRMCallLog] WHERE Id = @CallFeedbackId

	
	END TRY  
	BEGIN CATCH 
		
		EXEC USP_GetErrorInformation

	END CATCH

END