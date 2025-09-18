CREATE PROCEDURE [dbo].[USP_SearchCallFeedback]
(
    @CallFeedbackId UNIQUEIDENTIFIER = NULL,
	@CallFeedbackUserId UNIQUEIDENTIFIER = NULL,
	@ReceiverId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@PageNumber INT = 1,
    @PageSize INT = 10
)
AS
BEGIN
        SET NOCOUNT ON
       
       	BEGIN TRY
			SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			IF (@CallFeedbackId = '00000000-0000-0000-0000-000000000000') SET @CallFeedbackId = NULL

			IF (@CallFeedbackUserId = '00000000-0000-0000-0000-000000000000') SET @CallFeedbackUserId = NULL

			IF (@ReceiverId = '00000000-0000-0000-0000-000000000000') SET @ReceiverId = NULL


			SELECT CCL.Id [CallFeedbackId], CCL.ReceiverId, CallConnectedTo, 
					CallOutcomeCode OutcomeCode, COC.OutcomeName, CallDescription, 
					CallRecordingLink, 
					CONVERT(DATE, CallLoggedDate) CallLoggedDate, 
					CONVERT(TIME, CallLoggedTime) CallLoggedTime,
					CallStartedOn, CallEndedOn, 
					cat.Id  [ActivityTypeId], cat.ActivityName [ActivityTypeName], 
					CASE WHEN CallStartedOn IS NOT NULL AND CallEndedOn IS NOT NULL THEN CONVERT(VARCHAR(8), CONVERT(TIME, convert(datetime, CallEndedOn) - convert(datetime, CallStartedOn))) ELSE NULL END [Duration],
					CCL.CreatedByUserId FeedbackByUserId,
					U.FirstName +' '+ ISNULL(U.SurName,'') AS FeedbackByUserFullName,
					U.IsActive AS FeedbackByUserIsActive,
					U.ProfileImage AS FeedbackByUserProfileImage,
					CCL.CreatedDateTime,
					CCL.UpdatedDateTime
			FROM CRMCallLog CCL
			INNER JOIN CallOutcome COC ON CCL.CallOutcomeCode = COC.OutcomeCode
			INNER JOIN CRMActivityType CAT ON CCL.ActivityTypeId = CAT.Id
			INNER JOIN [dbo].[User] U ON U.Id = CCL.CreatedByUserId
			WHERE CCL.CompanyId = @CompanyId
			        AND (@CallFeedbackId IS NULL OR CCL.Id = @CallFeedbackId)
			        AND (@CallFeedbackUserId IS NULL OR CCL.CreatedByUserId = @CallFeedbackUserId)
			        AND (@ReceiverId IS NULL OR CCL.ReceiverId = @ReceiverId)
		      ORDER BY CCL.CreatedDateTime DESC OFFSET ((@PageNumber - 1) * @PageSize) ROWS

        FETCH NEXT @PageSize ROWS ONLY
		
       END TRY  
	   BEGIN CATCH 
		
		   EXEC USP_GetErrorInformation

	  END CATCH
END
