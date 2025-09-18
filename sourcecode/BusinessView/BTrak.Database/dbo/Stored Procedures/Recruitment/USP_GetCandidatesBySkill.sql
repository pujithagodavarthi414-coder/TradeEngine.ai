--EXEC [dbo].[USP_GetCandidatesBySkill] @SkillId='c88ff65b-9d6c-4cc6-ba1c-0675d0e9119a',@PageSize=25,@PageNumber=1,@OperationsPerformedBy='FB5D135E-D329-47D4-9DDB-D5A65D9542F3'

CREATE PROCEDURE [dbo].[USP_GetCandidatesBySkill]
(
	@SkillId UNIQUEIDENTIFIER,
	@PageSize INT = NULL,
    @PageNumber INT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	
	IF (@HavePermission = '1')
    BEGIN
		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   
		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [Candidate])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [Candidate]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [Candidate])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [Candidate]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

	       IF(@SkillId = '00000000-0000-0000-0000-000000000000') SET  @SkillId = NULL

		    SELECT C.Id AS CandidateId,
				  C.FirstName,
				  C.LastName,
				  C.CandidateUniqueName,
				  C.Email,
				  C.SecondaryEmail,
				  C.ProfileImage,
				  C.Mobile,
				  C.Phone,
				  C.Fax,
				  C.Website,
				  C.SkypeId,
				  C.TwitterId,
				  C.AddressJson,
				  C.CountryId,
				  SC.CountryName,
				  C.ExperienceInYears,
				  C.CurrentDesignation,
				  D.DesignationName AS CurrentDesignationName,
				  C.CurrentSalary,
				  C.ExpectedSalary,
				  C.SourceId,
				  S.[Name] SourceName,
				  C.SourcePersonId,
				  SU.FirstName + ISNULL(SU.SurName,'') SourcePersonName,
				  CJO.HiringStatusId,
				  CJO.JobOpeningId,
				  CJO.Id AS CandidateJobOpeningId,
				  HS.[Status] HiringStatusName,
				  HS.Color,
				  C.AssignedToManagerId,
				  AU.FirstName + ISNULL(AU.SurName,'') AssignedToManagerName,
				  C.ClosedById,
				  JO.JobOpeningTitle,
				  CJO.AppliedDateTime,
				  CU.FirstName + ISNULL(CU.SurName,'') ClosedByUserName,
				  CJO.[Description],
				  IP.InterviewProcessName,
				  IP.Id AS InterviewProcessId,
				  C.CreatedByUserId,
				  C.CreatedDateTime,
				  C.[TimeStamp],
				  (SELECT  STUFF((SELECT ', ' + CAST(CIS1.InterviewTypeId AS VARCHAR(50)) [text()]
        FROM CandidateInterviewSchedule CIS1 INNER JOIN ScheduleStatus SS ON SS.Id = CIS1.StatusId AND SS.[Order] = 1
		WHERE CIS1.CandidateId = C.Id AND CIS1.InActiveDateTime IS NULL AND ISNULL(CIS1.IsCancelled ,0)= 0
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ')) InterviewTypeIds,
				  CASE WHEN (SELECT  Email FROM [USER] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND UserName = C.Email) IS NOT NULL THEN 1 ELSE 0 END IsEmployee,
				  'EM ' + CAST((SELECT COUNT(1) + 1 FROM Employee) AS NVARCHAR(100)) As EmployeeNumber,
				  (SELECT ID from [ROLE] WHERE CompanyID=@companyID AND RoleName ='Super Admin') DesignationId,
				  (SELECT Top(1)ID from [Branch] WHERE CompanyID=@companyID ORDER BY CreatedDATETIME DESC) BranchId,
				  TotalCount = COUNT(1) OVER(),
				  @PageSize AS PageSize,
				  @PageNumber AS PageNumber
		   FROM [dbo].[Candidate] C WITH (NOLOCK)
		   INNER JOIN CandidateSkills SK ON SK.CandidateId = C.Id
		        LEFT JOIN Country SC WITH (NOLOCK) ON SC.Id = C.CountryId
				LEFT JOIN [Source] S WITH (NOLOCK) ON S.Id = C.SourceId
				LEFT JOIN [User] SU WITH (NOLOCK) ON SU.Id = C.SourcePersonId
				LEFT JOIN [User] AU WITH (NOLOCK) ON AU.Id = C.AssignedToManagerId
				LEFT JOIN [User] CU WITH (NOLOCK) ON CU.Id = C.ClosedById
				LEFT JOIN CandidateJobOpening CJO WITH (NOLOCK) ON CJO.CandidateId = C.Id
				LEFT JOIN InterviewProcess IP WITH (NOLOCK) ON IP.Id = CJO.InterviewProcessId
				LEFT JOIN JobOpening JO WITH (NOLOCK) ON JO.Id = CJO.JobOpeningId
				LEFT JOIN HiringStatus HS WITH (NOLOCK) ON HS.Id = CJO.HiringStatusId
				LEFT JOIN Designation D WITH (NOLOCK) ON D.Id = C.CurrentDesignation
		   WHERE C.CompanyId = @CompanyId
				 AND C.InActiveDateTime IS NULL 
				 AND CJO.InActiveDateTime IS NULL
				 AND SK.InActiveDateTime IS NULL
				 AND SK.SkillId=@SkillId
				 AND JO.InActiveDateTime IS NULL
				GROUP BY C.Id,C.FirstName,C.LastName,C.CandidateUniqueName,C.Email,C.SecondaryEmail,C.ProfileImage,C.Mobile,C.Phone,C.Fax,C.Website,C.SkypeId,C.TwitterId,C.AddressJson,C.CountryId,SC.CountryName,
				C.ExperienceInYears,C.CurrentDesignation,C.CurrentSalary,C.ExpectedSalary,
				C.SourceId,S.Name,C.SourcePersonId,SU.FirstName,SU.SurName,
				CJO.HiringStatusId,CJO.JobOpeningId,CJO.Id,HS.Status,HS.Color,
				C.AssignedToManagerId,CU.FirstName,CU.SurName,AU.FirstName,AU.SurName,
				C.ClosedById,JO.JobOpeningTitle,CJO.AppliedDateTime,CJO.Description,
				IP.InterviewProcessName,IP.Id,C.CreatedByUserId,
				D.DesignationName,JO.Id,C.CreatedDateTime,C.TimeStamp
		  ORDER BY C.CreatedByUserId ASC

		   OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		   FETCH NEXT @PageSize Rows ONLY
	END
	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH

END
GO
