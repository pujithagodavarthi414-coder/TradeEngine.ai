CREATE PROCEDURE [dbo].[USP_GetCandidateAssigneeRecurrings]
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

	SELECT CISA.Id AS CandidateInterviewScheduleAssigneeId,
				  CISA.AssignToUserId,
				  CISA.CandidateInterviewScheduleId,
				  CIS.InterviewDate,
				  convert(char(5), CIS.StartTime, 108) AS StartTime,
				  convert(char(5), CIS.EndTime, 108) AS EndTime,
				  U.UserName,
				  U.CompanyId,
				  U.FirstName+' '+U.SurName AS AssignToUserName,
				  IT.InterviewTypeName,
				  C.FirstName+' '+C.LastName AS CandidateName,
				  IT.IsVideoCalling
				FROM CandidateInterviewScheduleAssignee CISA 
INNER JOIN CandidateInterviewSchedule CIS ON CIS.Id = CISA.CandidateInterviewScheduleId 
AND CIS.InterviewDate = CAST(GETUTCDATE() as date) 
AND CIS.InActiveDateTime IS NULL
INNER JOIN InterviewType IT ON IT.Id = CIS.InterviewTypeId
AND  ((@IsVideoCallCheck IS NOT NULL AND IT.IsVideoCalling = 1 AND @IsVideoCallCheck = 1 AND CONVERT(Char(16), CAST(SWITCHOFFSET(CIS.StartTime, '+00:00')  AS datetime),20) =  CONVERT(Char(16), DATEADD(MINUTE,2,GETUTCDATE()) ,20) )OR 
			((@IsVideoCallCheck IS NULL OR @IsVideoCallCheck = 0) AND CONVERT(Char(16), CAST(SWITCHOFFSET(CIS.StartTime, '+00:00')  AS datetime),20) =  CONVERT(Char(16), DATEADD(HOUR,2,GETUTCDATE()) ,20)))
INNER JOIN CandidateJobOpening CJO ON CJO.CandidateId = CIS.CandidateId AND CJO.InActiveDateTime IS NULL AND CIS.JobOpeningId = CJO.JobOpeningId
INNER JOIN Candidate C ON C.Id = CJO.CandidateId
LEFT JOIN [User] U ON U.Id = CISA.AssignToUserId
WHERE CISA.InActiveDateTime IS NULL AND CISA.IsApproved = 1

	END
	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH

END
GO
