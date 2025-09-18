--EXEC [dbo].[USP_SearchCandidates] @OperationsPerformedBy = 'fb5d135e-d329-47d4-9ddb-d5a65d9542f3',@CanJobById='559177b7-3453-4c32-95cc-b44482f78d54',@jobOpeningId='5547a9b0-8940-457e-af0d-d30fcffd386a'
CREATE  PROCEDURE [dbo].[USP_SearchCandidates]
(
	@CandidateId UNIQUEIDENTIFIER = NULL,
	@InterviewTypeId UNIQUEIDENTIFIER = NULL,
	@InterviewerId UNIQUEIDENTIFIER = NULL,
	@JobOpeningId UNIQUEIDENTIFIER = NULL,
	@FirstName NVARCHAR(500) = NULL,
	@LastName NVARCHAR(500) = NULL,
	@Email NVARCHAR(500) = NULL,
	@SecondaryEmail NVARCHAR(500) = NULL,
	@Mobile NVARCHAR(100) = NULL,
	@Phone NVARCHAR(100) = NULL,
	@Fax NVARCHAR(500) = NULL,
	@Website NVARCHAR(500) = NULL,
	@SkypeId NVARCHAR(500) = NULL,
	@TwitterId NVARCHAR(500) = NULL,
	@AddressJson NVARCHAR(MAX) = NULL,
	@CountryId UNIQUEIDENTIFIER = NULL,
	@ExperienceInYears FLOAT = NULL,
	@CurrentDesignation UNIQUEIDENTIFIER = NULL,
	@CurrentSalary FLOAT = NULL,
	@ExpectedSalary FLOAT = NULL,
	@SourceId UNIQUEIDENTIFIER = NULL,
	@SourcePersonId UNIQUEIDENTIFIER = NULL,
	@HiringStatusId UNIQUEIDENTIFIER = NULL,
	@AssignedToManagerId UNIQUEIDENTIFIER = NULL,
	@ClosedById UNIQUEIDENTIFIER = NULL,
	@SortBy NVARCHAR(100) = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50)=NULL,
    @PageSize INT = NULL,
    @PageNumber INT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@CanJobById  UNIQUEIDENTIFIER = NULL
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

	       IF(@CandidateId = '00000000-0000-0000-0000-000000000000') SET  @CandidateId = NULL

		   IF(@JobOpeningId = '00000000-0000-0000-0000-000000000000') SET  @JobOpeningId = NULL

		   IF(@CountryId = '00000000-0000-0000-0000-000000000000') SET  @CountryId = NULL

		   IF(@SourceId = '00000000-0000-0000-0000-000000000000') SET  @SourceId = NULL

		   IF(@SourcePersonId = '00000000-0000-0000-0000-000000000000') SET  @SourcePersonId = NULL

		   IF(@HiringStatusId = '00000000-0000-0000-0000-000000000000') SET  @HiringStatusId = NULL

		   IF(@AssignedToManagerId = '00000000-0000-0000-0000-000000000000') SET  @AssignedToManagerId = NULL

		   IF(@ClosedById = '00000000-0000-0000-0000-000000000000') SET  @ClosedById = NULL

		   IF(@CurrentDesignation = '00000000-0000-0000-0000-000000000000') SET @CurrentDesignation = NULL
		   
		   IF(@FirstName = '') SET  @FirstName = NULL

		   IF(@LastName = '') SET  @LastName = NULL

		   IF(@Email = '') SET  @Email = NULL

		   IF(@SecondaryEmail = '') SET  @SecondaryEmail = NULL

		   IF(@Mobile = '') SET  @Mobile = NULL

		   IF(@Phone = '') SET  @Phone = NULL

		   IF(@Fax = '') SET  @Fax = NULL

		   IF(@Website = '') SET  @Website = NULL

		   IF(@SkypeId = '') SET  @SkypeId = NULL

		   IF(@TwitterId = '') SET  @TwitterId = NULL

		   IF(@AddressJson = '') SET  @AddressJson = NULL

		   IF(@ExperienceInYears = '') SET  @ExperienceInYears = NULL

		   IF(@CurrentSalary = '') SET  @CurrentSalary = NULL

		   IF(@ExpectedSalary = '') SET  @ExpectedSalary = NULL
		   
	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [Candidate])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [Candidate]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'
		   
		   SELECT C.Id AS CandidateId,
				  C.FirstName,
				  C.LastName,
				  C.FatherName,
				  C.CandidateUniqueName,
				  C.Email,
				  C.SecondaryEmail,
				  C.ProfileImage,
				  C.Mobile,
				  REPLACE(REPLACE(REPLACE(REPLACE(C.Phone,'(',''),')',''),'-', ''), ' ', '') AS Phone,
				  ISNULL(SC.CountryCode, '+91') AS CountryCode,
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
				  CASE WHEN CJO.JobOpeningId=@CanJobById THEN 1 ELSE 0 END AS IsJobOpening,
				  C.CreatedDateTime,
				  C.[TimeStamp],
				  (SELECT  STUFF((SELECT ', ' + CAST(CIS1.InterviewTypeId AS VARCHAR(50)) [text()]
        FROM CandidateInterviewSchedule CIS1 INNER JOIN ScheduleStatus SS ON SS.Id = CIS1.StatusId AND SS.[Order] = 1
		WHERE CIS1.CandidateId = C.Id AND CIS1.InActiveDateTime IS NULL AND ISNULL(CIS1.IsCancelled ,0)= 0
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ')) InterviewTypeIds,
				  CASE WHEN (SELECT  Top(1) Email FROM [USER] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND UserName = C.Email) IS NOT NULL THEN 1 ELSE 0 END IsEmployee,
				  'EM ' + CAST((SELECT COUNT(1) + 1 FROM Employee) AS NVARCHAR(100)) As EmployeeNumber,
				  (SELECT ID from [ROLE] WHERE CompanyID=@companyID AND RoleName ='Super Admin') DesignationId,
				  (SELECT Top(1)ID from [Branch] WHERE CompanyID=@companyID ORDER BY CreatedDATETIME DESC) BranchId,
				  TotalCount = COUNT(1) OVER(),
				  @PageSize AS PageSize,
				  @PageNumber AS PageNumber
		   FROM [dbo].[Candidate] C WITH (NOLOCK)
		        LEFT JOIN Country SC WITH (NOLOCK) ON SC.Id = C.CountryId
				LEFT JOIN [Source] S WITH (NOLOCK) ON S.Id = C.SourceId
				LEFT JOIN [User] SU WITH (NOLOCK) ON SU.Id = C.SourcePersonId
				LEFT JOIN [User] AU WITH (NOLOCK) ON AU.Id = C.AssignedToManagerId
				LEFT JOIN [User] CU WITH (NOLOCK) ON CU.Id = C.ClosedById
				LEFT JOIN CandidateJobOpening CJO WITH (NOLOCK) ON CJO.CandidateId = C.Id AND CJO.InActiveDateTime IS NULL AND ( CJO.JobopeningId= @CanJobById or @CanJobById IS NULL) AND ((@JobOpeningId  IS NOT NULL OR @CanJobById IS NOT NULL) OR (@InterviewerId IS NOT  NULL  AND @CanJobById IS NULL) )
				LEFT JOIN InterviewProcess IP WITH (NOLOCK) ON IP.Id = CJO.InterviewProcessId AND @CanJobById IS NULL
				LEFT JOIN JobOpening JO WITH (NOLOCK) ON JO.Id = CJO.JobOpeningId
				LEFT JOIN HiringStatus HS WITH (NOLOCK) ON HS.Id = CJO.HiringStatusId
				LEFT JOIN Designation D WITH (NOLOCK) ON D.Id = C.CurrentDesignation
				LEFT JOIN [CandidateInterviewSchedule] CIS  WITH (NOLOCK) ON CIS.CandidateId= CJO.CandidateId  AND @CanJobById IS NULL  AND @InterviewerId IS NOT  NULL AND CIS.InActiveDateTime IS NULL AND CIS.JobOpeningId = CJO.JobOpeningId
				LEFT JOIN CandidateInterviewScheduleAssignee CISA WITH (NOLOCK) ON CISA.CandidateInterviewScheduleId= CIS.Id  AND @CanJobById IS NULL  AND @InterviewerId IS NOT  NULL AND CISA.AssignToUserId = @InterviewerId AND CISA.InActiveDateTime IS NULL
		   WHERE (@CandidateId IS NULL OR C.Id = @CandidateId)
				 AND C.CompanyId = @CompanyId
				 AND C.InActiveDateTime IS NULL
				 AND JO.InActiveDateTime IS NULL
		   	     AND (@JobOpeningId IS NULL OR JO.Id = @JobOpeningId)
				 AND (@InterviewerId IS NULL OR (CISA.AssignToUserId = @InterviewerId AND CJO.InActiveDateTime IS NULL AND JO.InActiveDateTime IS NULL))
				 AND (@FirstName IS NULL OR C.FirstName = @FirstName)
				 AND (@LastName IS NULL OR C.LastName = @LastName)
				 AND (@Email IS NULL OR C.Email = @Email)
				 AND (@SecondaryEmail IS NULL OR C.SecondaryEmail = @SecondaryEmail)
				 AND (@Mobile IS NULL OR C.Mobile = @Mobile)
				 AND (@Phone IS NULL OR C.Phone = @Phone)
				 AND (@Fax IS NULL OR C.Fax = @Fax)
				 AND (@Website IS NULL OR C.Website = @Website)
				 AND (@SkypeId IS NULL OR C.SkypeId = @SkypeId)
				 AND (@TwitterId IS NULL OR C.TwitterId = @TwitterId)
				 AND (@AddressJson IS NULL OR C.AddressJson = @AddressJson)
				 AND (@CountryId IS NULL OR C.CountryId = @CountryId)
				 AND (@ExperienceInYears IS NULL OR C.ExperienceInYears = @ExperienceInYears)
				 AND (@CurrentDesignation IS NULL OR C.CurrentDesignation = @CurrentDesignation)
				 AND (@CurrentSalary IS NULL OR C.CurrentSalary = @CurrentSalary)
				 AND (@ExpectedSalary IS NULL OR C.ExpectedSalary = @ExpectedSalary)
				 AND (@SourceId IS NULL OR C.SourceId = @SourceId)
				 AND (@SourcePersonId IS NULL OR C.SourcePersonId = @SourcePersonId)
				 AND (@HiringStatusId IS NULL OR C.HiringStatusId = @HiringStatusId)
				 AND (@AssignedToManagerId IS NULL OR C.AssignedToManagerId = @AssignedToManagerId)
				 AND (@ClosedById IS NULL OR C.ClosedById = @ClosedById)
		   	     AND (@SearchText IS NULL OR (C.FirstName LIKE @SearchText)
				                          OR (C.LastName LIKE @SearchText)
										  OR (C.Email LIKE @SearchText)
										  OR (C.SecondaryEmail LIKE @SearchText)
										  OR (C.Mobile LIKE @SearchText)
										  OR (C.Phone LIKE @SearchText)
										  OR (C.Fax LIKE @SearchText)
										  OR (C.Website LIKE @SearchText)
										  OR (C.SkypeId LIKE @SearchText)
										  OR (C.TwitterId LIKE @SearchText)
										  OR (C.AddressJson LIKE @SearchText)
										  OR (SC.CountryName LIKE @SearchText)
										  OR (C.ExperienceInYears LIKE @SearchText)
										  OR (D.DesignationName LIKE @SearchText)
										  OR (C.CurrentSalary LIKE @SearchText)
										  OR (C.ExpectedSalary LIKE @SearchText)
										  OR (S.[Name] LIKE @SearchText)
										  OR (SU.FirstName + ISNULL(SU.SurName,'') LIKE @SearchText)
										  OR (HS.[Status] LIKE @SearchText)
										  OR (AU.FirstName + ISNULL(AU.SurName,'') LIKE @SearchText)
										  OR (CU.FirstName + ISNULL(CU.SurName,'') LIKE @SearchText))
				GROUP BY C.Id,C.FirstName,C.LastName,C.CandidateUniqueName,C.Email,C.SecondaryEmail,C.ProfileImage,C.Mobile,C.Phone,C.Fax,C.Website,C.SkypeId,C.TwitterId,C.AddressJson,C.CountryId,SC.CountryName,C.ExperienceInYears,C.CurrentDesignation,C.CurrentSalary,C.ExpectedSalary,C.SourceId,S.Name,C.SourcePersonId,SU.FirstName,SU.SurName,CJO.HiringStatusId,CJO.JobOpeningId,CJO.Id,HS.Status,HS.Color,C.AssignedToManagerId,CU.FirstName,CU.SurName,AU.FirstName,AU.SurName,C.ClosedById,JO.JobOpeningTitle,CJO.AppliedDateTime,CJO.Description,IP.InterviewProcessName,IP.Id,C.CreatedByUserId,
				D.DesignationName,JO.Id,C.CreatedDateTime,C.TimeStamp,SC.CountryCode,C.FatherName
		   ORDER BY IsJobOpening DESC,CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'FirstName' THEN C.FirstName
		   	    WHEN @SortBy = 'LastName' THEN C.LastName
				WHEN @SortBy = 'Email' THEN C.Email
				WHEN @SortBy = 'SecondaryEmail' THEN C.SecondaryEmail
				WHEN @SortBy = 'Mobile' THEN C.Mobile
				WHEN @SortBy = 'Phone' THEN C.Phone
				WHEN @SortBy = 'Fax' THEN C.Fax
				WHEN @SortBy = 'Website' THEN C.Website
				WHEN @SortBy = 'SkypeId' THEN C.SkypeId
				WHEN @SortBy = 'TwitterId' THEN C.TwitterId
				WHEN @SortBy = 'AddressJson' THEN  CAST(C.AddressJson AS NVARCHAR(1000))
				WHEN @SortBy = 'CountryName' THEN SC.CountryName
				WHEN @SortBy = 'CurrentDesignation' THEN D.DesignationName
				WHEN @SortBy = 'SourceName' THEN S.[Name]
				WHEN @SortBy = 'SourcePersonName' THEN SU.FirstName + ISNULL(SU.SurName,'')
				WHEN @SortBy = 'HiringPersonName' THEN HS.[Status]
				WHEN @SortBy = 'AssignedToManagerName' THEN AU.FirstName + ISNULL(AU.SurName,'')
				WHEN @SortBy = 'ClosedByUserName' THEN CU.FirstName + ISNULL(CU.SurName,'')
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,C.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'ExperienceInYears' THEN C.ExperienceInYears
				WHEN @SortBy = 'CurrentSalary' THEN C.CurrentSalary
				WHEN @SortBy = 'ExpectedSalary' THEN C.ExpectedSalary
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'FirstName' THEN C.FirstName
		   	    WHEN @SortBy = 'LastName' THEN C.LastName
				WHEN @SortBy = 'Email' THEN C.Email
				WHEN @SortBy = 'SecondaryEmail' THEN C.SecondaryEmail
				WHEN @SortBy = 'Mobile' THEN C.Mobile
				WHEN @SortBy = 'Phone' THEN C.Phone
				WHEN @SortBy = 'Fax' THEN C.Fax
				WHEN @SortBy = 'Website' THEN C.Website
				WHEN @SortBy = 'SkypeId' THEN C.SkypeId
				WHEN @SortBy = 'TwitterId' THEN C.TwitterId
				WHEN @SortBy = 'AddressJson' THEN  CAST(C.AddressJson AS NVARCHAR(1000))
				WHEN @SortBy = 'CountryName' THEN SC.CountryName
				WHEN @SortBy = 'CurrentDesignation' THEN D.DesignationName
				WHEN @SortBy = 'SourceName' THEN S.[Name]
				WHEN @SortBy = 'SourcePersonName' THEN SU.FirstName + ISNULL(SU.SurName,'')
				WHEN @SortBy = 'HiringPersonName' THEN HS.[Status]
				WHEN @SortBy = 'AssignedToManagerName' THEN AU.FirstName + ISNULL(AU.SurName,'')
				WHEN @SortBy = 'ClosedByUserName' THEN CU.FirstName + ISNULL(CU.SurName,'')
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,C.CreatedDateTime,121) AS sql_variant)
		   END
		   END DESC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'ExperienceInYears' THEN C.ExperienceInYears
				WHEN @SortBy = 'CurrentSalary' THEN C.CurrentSalary
				WHEN @SortBy = 'ExpectedSalary' THEN C.ExpectedSalary
		   END
		   END DESC
		   OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		   FETCH NEXT @PageSize Rows ONLY

	END
	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH

END
GO
