CREATE PROCEDURE [dbo].[USP_SearchUserCandidateInterviewSchedules]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
    BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   SELECT CIS.Id AS CandidateInterviewScheduleId,
				  CIS.InterviewTypeId,
				  IT.InterviewTypeName,
				  CIS.CandidateId,
				  C.FirstName + ' ' +ISNULL(C.LastName,'') CandidateName,
				  C.ProfileImage,
				  convert(char(5), CIS.StartTime, 108) AS StartTime,
				  convert(char(5), CIS.EndTime, 108) AS EndTime,
				  CIS.InterviewDate,
				  CISA.IsApproved AS IsConfirmed,
				  CIS.IsCancelled,
				  CIS.IsRescheduled,
				  CIS.ScheduleComments,
				  CIS.CreatedByUserId,
				  CIS.CreatedDateTime,
				  CIS.[TimeStamp],
				  CIS.[Assignee],
				  IT.IsVideoCalling,
				  IT.IsPhoneCalling,
				  AssigneeIds = (STUFF((SELECT ',' + LOWER(CAST(U.Id AS NVARCHAR(MAX))) [text()]
				  FROM CandidateInterviewScheduleAssignee CISA 
				  INNER JOIN [User] U WITH (NOLOCK) ON U.Id = CISA.AssignToUserId
				  WHERE CISA.CandidateInterviewScheduleId = CIS.Id 
						AND CISA.InActiveDateTime IS NULL
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))		   
				  ,AssigneeNames = (STUFF((SELECT ',' + LOWER(CAST(U.FirstName +' ' + ISNULL(U.SurName,'') AS NVARCHAR(MAX))) [text()]
				  FROM CandidateInterviewScheduleAssignee CISA 
				  INNER JOIN [User] U WITH (NOLOCK) ON U.Id = CISA.AssignToUserId
				  WHERE CISA.CandidateInterviewScheduleId = CIS.Id 
						AND CISA.InActiveDateTime IS NULL
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
		   FROM [dbo].[CandidateInterviewSchedule] CIS WITH (NOLOCK)
		   INNER JOIN CandidateInterviewScheduleAssignee CISA ON CISA.CandidateInterviewScheduleId = CIS.Id AND CISA.AssignToUserId = @OperationsPerformedBy
		        INNER JOIN InterviewType IT WITH (NOLOCK) ON IT.Id = CIS.InterviewTypeId
				INNER JOIN Candidate C WITH (NOLOCK) ON C.Id = CIS.CandidateId
		   WHERE 
				CIS.InActiveDateTime IS NULL AND CISA.InActiveDateTime IS NULL AND IT.InActiveDateTime IS NULL AND C.InActiveDateTime IS NULL
				AND CIS.IsCancelled <> 1
		  
	END
	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH

END
GO