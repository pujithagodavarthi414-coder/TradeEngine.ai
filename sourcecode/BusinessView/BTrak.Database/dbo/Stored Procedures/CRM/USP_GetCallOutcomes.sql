CREATE PROCEDURE [dbo].[USP_GetCallOutcomes]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SELECT OutcomeCode, OutcomeName FROM CallOutcome
END
