CREATE PROCEDURE [dbo].[USP_GetCandidateScheduleRecurrings]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@IsVideoCallCheck BIT = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
    BEGIN
	
SELECT * FROM (SELECT CIS.InterviewDate,
				  convert(char(5), CIS.StartTime, 108) AS StartTime,
				  convert(char(5), CIS.EndTime, 108) AS EndTime,
				  IT.InterviewTypeName,
				  C.FirstName+' '+C.LastName AS CandidateName,
				  C.Email AS UserName,
				  C.Id AS CandidateId,
				  CIS.CreatedByUserId AS AssignToUserId,
				  IT.IsVideoCalling,
				  C.CompanyId,
				  CIS.id CandidateInterviewScheduleId,
					(SELECT COUNT(1) FROM CandidateInterviewSchedule CIS WHERE CIS.CandidateId = C.Id AND CIS.JobOpeningId = CJO.JobOpeningId AND CIS.InActiveDateTime IS NULL) TotalCount
FROM Candidate C
INNER JOIN CandidateJobOpening CJO ON CJO.CandidateId = C.Id
INNER JOIN CandidateInterviewSchedule CIS ON CIS.CandidateId = CJO.CandidateId AND CIS.JobOpeningId = CJO.JobOpeningId
INNER JOIN InterviewType IT ON IT.Id = CIS.InterviewTypeId
WHERE CJO.InActiveDateTime IS NULL 
--AND CIS.InterviewDate = CAST(GETUTCDATE() as date) 
AND ((@IsVideoCallCheck IS NOT NULL AND IT.IsVideoCalling = 1 AND @IsVideoCallCheck = 1 AND CONVERT(Char(16), CAST(SWITCHOFFSET(CIS.StartTime, '+00:00')  AS datetime),20) =  CONVERT(Char(16), DATEADD(MINUTE,2,GETUTCDATE()) ,20) ) OR 
			((@IsVideoCallCheck IS NULL OR @IsVideoCallCheck = 0) AND CONVERT(Char(16), CAST(SWITCHOFFSET(CIS.StartTime, '+00:00')  AS datetime),20) =  CONVERT(Char(16), DATEADD(HOUR,2,GETUTCDATE()) ,20)))
AND CIS.InActiveDateTime IS NULL
) T WHERE TotalCount > 0

	END
	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH

END
GO

