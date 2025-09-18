--EXEC [dbo].[USP_SearchJobOpenings] @OperationsPerformedBy = 'FB5D135E-D329-47D4-9DDB-D5A65D9542F3',@Email='ggg@rrr.rrr'
CREATE PROCEDURE [dbo].[USP_SearchJobOpenings]
(
	@JobOpeningId UNIQUEIDENTIFIER = NULL,
	@JobOpeningTitle NVARCHAR(500)=NULL,
	@JobDescription NVARCHAR(MAX)=NULL,
	@NoOfOpenings INT=NULL,
	@DateFrom DATETIME=NULL,
	@DateTo DATETIME=NULL,
	@MinExperience FLOAT=NULL,
	@MaxExperience FLOAT=NULL,
	@Email NVARCHAR(500)=NULL,
	@Qualification NVARCHAR(500)=NULL,
	@Certification NVARCHAR(500)=NULL,
	@MinSalary FLOAT=NULL,
	@MaxSalary FLOAT=NULL,
	@JobTypeId UNIQUEIDENTIFIER = NULL,
	@JobOpeningStatusId UNIQUEIDENTIFIER = NULL,
	@InterviewProcessId UNIQUEIDENTIFIER = NULL,
	@DesignationId UNIQUEIDENTIFIER = NULL,
	@HiringManagerId UNIQUEIDENTIFIER = NULL,
	@SortBy NVARCHAR(100) = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50)=NULL,
    @PageSize INT = NULL,
    @PageNumber INT = NULL,
	@CandidateId UNIQUEIDENTIFIER=null,
	@StatusColour NVARCHAR(50)=NULL,
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

	       IF(@JobOpeningId = '00000000-0000-0000-0000-000000000000') SET  @JobOpeningId = NULL

		   IF(@JobTypeId = '00000000-0000-0000-0000-000000000000') SET  @JobTypeId = NULL

		   IF(@JobOpeningStatusId = '00000000-0000-0000-0000-000000000000') SET  @JobOpeningStatusId = NULL

		   IF(@InterviewProcessId = '00000000-0000-0000-0000-000000000000') SET  @InterviewProcessId = NULL

		   IF(@DesignationId = '00000000-0000-0000-0000-000000000000') SET  @DesignationId = NULL

		   IF(@HiringManagerId = '00000000-0000-0000-0000-000000000000') SET  @HiringManagerId = NULL

		   IF(@CandidateId = '00000000-0000-0000-0000-000000000000') SET  @CandidateId = NULL

		   IF(@JobOpeningTitle = '') SET  @JobOpeningTitle = NULL

		   IF(@JobDescription = '') SET  @JobDescription = NULL

		   IF(@NoOfOpenings = '') SET  @NoOfOpenings = NULL

		   IF(@DateFrom = '') SET  @DateFrom = NULL

		   IF(@DateTo = '') SET  @DateTo = NULL

		   IF(@MinExperience = '') SET  @MinExperience = NULL

		   IF(@MaxExperience = '') SET  @MaxExperience = NULL

		   IF(@Email = '') SET  @Email = NULL

		   IF(@Qualification = '') SET  @Qualification = NULL

		   IF(@Certification = '') SET  @Certification = NULL

		   IF(@MinSalary = '') SET  @MinSalary = NULL

		   IF(@MaxSalary = '') SET  @MaxSalary = NULL

		   IF(@DateTo = '') SET  @DateTo = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [JobOpening])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [JobOpening]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT JO.Id AS JobOpeningId,
				  JO.JobOpeningTitle,
				  JO.JobOpeningUniqueName,
				  JO.JobDescription,
				  JO.NoOfOpenings,
				  JO.DateFrom,
				  JO.DateTo,
				  JO.MinExperience,
				  JO.MaxExperience,
				  JO.Qualification,
				  JO.Certification,
				  JO.MinSalary,
				  JO.MaxSalary,
				  JO.JobTypeId,
				  ET.EmploymentStatusName,
				  JO.JobOpeningStatusId,
				  JOS.[Status] JobOpeningStatus,
				  JOS.[StatusColour] StatusColour,
				  JO.InterviewProcessId,
				  IPS.InterviewProcessName,
				  JO.DesignationId,
				  D.DesignationName,
				   STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),JL.BranchId))
                                FROM [JobLocation] JL
                                     INNER JOIN Branch B ON B.Id = JL.BranchId 
                                                AND B.InactiveDateTime IS NULL AND JL.InactiveDateTime IS NULL
                                WHERE JL.JobOpeningId = JO.Id
                                ORDER BY BranchName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS LocationIds,
                    STUFF((SELECT ', ' + BranchName 
                                FROM [JobLocation] JL
                                     INNER JOIN Branch B ON B.Id = JL.BranchId 
                                                AND B.InactiveDateTime IS NULL AND JL.InactiveDateTime IS NULL
                                WHERE JL.JobOpeningId = JO.Id
                                ORDER BY BranchName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS LocationNames, 
				   STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),JOSK.SkillId))
                                FROM [JobOpeningSkill] JOSK
                                     INNER JOIN Skill S ON S.Id = JOSK.SkillId 
                                                AND S.InactiveDateTime IS NULL AND JOSK.InactiveDateTime IS NULL
                                WHERE JOSK.JobOpeningId = JO.Id
                                ORDER BY SkillName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS SkillIds,
                    STUFF((SELECT ', ' + SkillName 
                                FROM [JobOpeningSkill] JOSK
                                     INNER JOIN Skill S ON S.Id = JOSK.SkillId 
                                                AND S.InactiveDateTime IS NULL AND JOSK.InactiveDateTime IS NULL
                                WHERE JOSK.JobOpeningId = JO.Id
                                ORDER BY SkillName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS SkillNames,
                  JO.HiringManagerId, 
				  U.ProfileImage,
				  U.FirstName + ISNULL(U.SurName,'') HiringManagerName,
				  Totaloffered = (SELECT COUNT(1) FROM CandidateJobOpening CJO 
					JOIN HiringStatus HS ON HS.Id=CJO.HiringStatusId
					WHERE CJO.JobOpeningId=JO.Id AND HS.[Status]='On boarding'),
				  TotalCandidates = (SELECT COUNT(1) FROM Candidate C 
										INNER JOIN CandidateJobOpening CJO ON CJO.CandidateId=C.Id
										INNER JOIN JobOpening J ON J.Id = CJO.JobOpeningId
										WHERE J.InactiveDateTime IS NULL AND C.InActiveDateTime IS NULL AND CJO.InActiveDateTime IS NULL AND J.CompanyId = @CompanyId),
				  TotalCandidatesInJobOpening = (SELECT COUNT(1) FROM Candidate C 
										INNER JOIN CandidateJobOpening CJO ON CJO.CandidateId=C.Id
										INNER JOIN JobOpening J ON J.Id = CJO.JobOpeningId
										WHERE J.InactiveDateTime IS NULL 
										AND C.InActiveDateTime IS NULL AND CJO.InActiveDateTime IS NULL AND J.Id=JO.Id AND J.CompanyId = @CompanyId),
				  CA.PublicUrl,
				  JO.CreatedByUserId,
				  JO.CreatedDateTime,
				  JO.[TimeStamp],
				  TotalCount = COUNT(1) OVER()
		   FROM [dbo].[JobOpening] JO WITH (NOLOCK)
		        LEFT JOIN EmploymentStatus ET WITH (NOLOCK) ON ET.Id = JO.JobTypeId
				LEFT JOIN JobOpeningStatus JOS WITH (NOLOCK) ON JOS.Id = JO.JobOpeningStatusId
				LEFT JOIN InterviewProcess IPS WITH (NOLOCK) ON IPS.Id = JO.InterviewProcessId
				LEFT JOIN [Designation] D WITH (NOLOCK) ON D.Id = JO.DesignationId
				INNER JOIN [User] U WITH (NOLOCK) ON U.Id = JO.HiringManagerId
				LEFT JOIN CandidateJobOpening CJO WITH (NOLOCK) ON CJO.JobOpeningId = JO.Id AND CJO.InActiveDateTime IS NULL
				LEFT JOIN Candidate C WITH (NOLOCK) ON C.Id = CJO.CandidateId
				LEFT JOIN CustomApplicationForms CA WITH (NOLOCK) ON CA.PublicUrl LIKE '%'+CONVERT(NVARCHAR(50), JO.Id)+'%'
		   WHERE (@JobOpeningId IS NULL OR JO.Id = @JobOpeningId)
		   AND JO.InActiveDateTime IS NULL AND JO.CompanyId = @CompanyId
		   AND U.CompanyId=@CompanyId 
		   	     AND (@JobOpeningTitle IS NULL OR JO.JobOpeningTitle = @JobOpeningTitle)
				 AND (@Email IS NULL OR C.Email = @Email)
				  AND (@CandidateId IS NULL OR C.id = @CandidateId)
				 AND (@JobDescription IS NULL OR JO.JobDescription = @JobDescription)
				 AND (@NoOfOpenings IS NULL OR JO.NoOfOpenings = @NoOfOpenings)
				 AND (@DateFrom IS NULL OR JO.DateFrom = @DateFrom)
				 AND (@DateTo IS NULL OR JO.DateTo = @DateTo)
				 AND (@MinExperience IS NULL OR JO.MinExperience = @MinExperience)
				 AND (@MaxExperience IS NULL OR JO.MaxExperience = @MaxExperience)
				 AND (@Qualification IS NULL OR JO.Qualification = @Qualification)
				 AND (@Certification IS NULL OR JO.Certification = @Certification)
				 AND (@MinSalary IS NULL OR JO.MinSalary = @MinSalary)
				 AND (@MaxSalary IS NULL OR JO.MaxSalary = @MaxSalary)
				 AND (@JobTypeId IS NULL OR JO.JobTypeId = @JobTypeId)
				 AND (@JobOpeningStatusId IS NULL OR JO.JobOpeningStatusId = @JobOpeningStatusId)
				 AND (@InterviewProcessId IS NULL OR JO.InterviewProcessId = @InterviewProcessId)
				 AND (@DesignationId IS NULL OR JO.DesignationId = @DesignationId)
				 AND (@HiringManagerId IS NULL OR JO.HiringManagerId = @HiringManagerId)
		   	     AND (@SearchText IS NULL OR (JO.JobOpeningTitle LIKE @SearchText)
				                          OR (JO.JobDescription LIKE @SearchText)
										  OR (JO.NoOfOpenings LIKE @SearchText)
										  OR (JO.DateFrom LIKE @SearchText)
										  OR (JO.DateTo LIKE @SearchText)
										  OR (JO.MinExperience LIKE @SearchText)
										  OR (JO.MaxExperience LIKE @SearchText)
										  OR (JO.Qualification LIKE @SearchText)
										  OR (JO.Certification LIKE @SearchText)
										  OR (JO.MinSalary LIKE @SearchText)
										  OR (JO.MaxSalary LIKE @SearchText)
										  OR (ET.EmploymentStatusName LIKE @SearchText)
										  OR (JOS.[Status] LIKE @SearchText)
										  OR (IPS.InterviewProcessName LIKE @SearchText)
										  OR (D.DesignationName LIKE @SearchText)
										  OR (U.FirstName + ISNULL(U.SurName,'') LIKE @SearchText))
										  GROUP BY JO.JobOpeningTitle,JO.Id,JO.JobDescription,JO.NoOfOpenings,JO.DateFrom,JO.DateTo,JO.MinExperience,JO.MaxExperience,
										  JO.Qualification,JO.JobOpeningUniqueName,JO.Certification,JO.MinSalary,JO.MaxSalary,JO.JobTypeId,ET.EmploymentStatusName,JO.JobOpeningStatusId,JOS.[Status],
										  JO.InterviewProcessId,IPS.InterviewProcessName,JO.DesignationId,D.DesignationName,JO.HiringManagerId,U.ProfileImage,U.FirstName,U.SurName,JO.CreatedByUserId,JO.CreatedDateTime,JO.[TimeStamp],JOS.[StatusColour],
										  CA.PublicUrl
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'JobOpeningTitle' THEN JO.JobOpeningTitle
		   	    WHEN @SortBy = 'JobDescription' THEN CAST(JO.JobDescription AS NVARCHAR(1000))
				WHEN @SortBy = 'DateFrom' THEN CAST(CONVERT(DATETIME,JO.DateFrom,121) AS sql_variant)
				WHEN @SortBy = 'DateTo' THEN CAST(CONVERT(DATETIME,JO.DateTo,121) AS sql_variant)
				WHEN @SortBy = 'Qualification' THEN JO.Qualification
				WHEN @SortBy = 'Certification' THEN JO.Certification
				WHEN @SortBy = 'JobTypeName' THEN ET.EmploymentStatusName
				WHEN @SortBy = 'JobOpeningStatus' THEN JOS.[Status]
				WHEN @SortBy = 'InterviewProcessName' THEN IPS.InterviewProcessName
				WHEN @SortBy = 'DesignationName' THEN D.DesignationName
				WHEN @SortBy = 'HiringManagerName' THEN  U.FirstName + ISNULL(U.SurName,'')
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,JO.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'NoOfOpenings' THEN JO.NoOfOpenings
				WHEN @SortBy = 'MinExperience' THEN JO.MinExperience
				WHEN @SortBy = 'MaxExperience' THEN JO.MaxExperience
				WHEN @SortBy = 'MinSalary' THEN JO.MinSalary
				WHEN @SortBy = 'MaxSalary' THEN JO.MaxSalary
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'JobOpeningTitle' THEN JO.JobOpeningTitle
		   	    WHEN @SortBy = 'JobDescription' THEN CAST(JO.JobDescription AS NVARCHAR(1000))
				WHEN @SortBy = 'DateFrom' THEN CAST(CONVERT(DATETIME,JO.DateFrom,121) AS sql_variant)
				WHEN @SortBy = 'DateTo' THEN CAST(CONVERT(DATETIME,JO.DateTo,121) AS sql_variant)
				WHEN @SortBy = 'Qualification' THEN JO.Qualification
				WHEN @SortBy = 'Certification' THEN JO.Certification
				WHEN @SortBy = 'JobTypeName' THEN ET.EmploymentStatusName
				WHEN @SortBy = 'JobOpeningStatus' THEN JOS.[Status]
				WHEN @SortBy = 'InterviewProcessName' THEN IPS.InterviewProcessName
				WHEN @SortBy = 'DesignationName' THEN D.DesignationName
				WHEN @SortBy = 'HiringManagerName' THEN  U.FirstName + ISNULL(U.SurName,'')
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,JO.CreatedDateTime,121) AS sql_variant)
		   END
		   END DESC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'NoOfOpenings' THEN JO.NoOfOpenings
				WHEN @SortBy = 'MinExperience' THEN JO.MinExperience
				WHEN @SortBy = 'MaxExperience' THEN JO.MaxExperience
				WHEN @SortBy = 'MinSalary' THEN JO.MinSalary
				WHEN @SortBy = 'MaxSalary' THEN JO.MaxSalary
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
