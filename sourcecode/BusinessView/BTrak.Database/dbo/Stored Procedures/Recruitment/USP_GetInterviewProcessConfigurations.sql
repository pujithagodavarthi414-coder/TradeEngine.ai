--EXEC [dbo].[USP_GetInterviewProcessConfiguration] @OperationsPerformedBy='FB5D135E-D329-47D4-9DDB-D5A65D9542F3',@CandidateId='A1FF7D19-0DE3-405D-8CBF-3142811373F5',@JobOpeningId='0999f991-e54d-414b-88c4-b8e7a0758d83'
CREATE PROCEDURE [dbo].[USP_GetInterviewProcessConfiguration]
(
	@InterviewProcessConfigurationId UNIQUEIDENTIFIER = NULL,
	@InterviewTypeId UNIQUEIDENTIFIER = NULL,
	@InterviewProcessTypeId UNIQUEIDENTIFIER = NULL,
	@JobOpeningId UNIQUEIDENTIFIER = NULL,
	@CandidateId UNIQUEIDENTIFIER = NULL,
	@Order INT = NULL,
	@SortBy NVARCHAR(100) = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50)=NULL,
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

		   IF(@InterviewProcessConfigurationId = '00000000-0000-0000-0000-000000000000') SET  @InterviewProcessConfigurationId = NULL

		   IF(@JobOpeningId = '00000000-0000-0000-0000-000000000000') SET  @JobOpeningId = NULL

	       IF(@InterviewTypeId = '00000000-0000-0000-0000-000000000000') SET  @InterviewTypeId = NULL

		   IF(@InterviewProcessTypeId = '00000000-0000-0000-0000-000000000000') SET  @InterviewProcessTypeId = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'Order'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [InterviewProcessConfiguration])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [InterviewProcessConfiguration]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'
		   DECLARE @CandidateId1 UNIQUEIDENTIFIER = @CandidateId
		   IF(@CandidateId IS NOT NULL AND((@InterviewProcessTypeId <> (Select InterviewProcessId From CandidateJobOpening WHERE CandidateId=@CandidateId AND JobOpeningId = @JobOpeningId)) OR (Select InterviewProcessId From CandidateJobOpening WHERE CandidateId=@CandidateId AND JobOpeningId = @JobOpeningId) IS NULL))
		   BEGIN
		   SET @CandidateId = NULL
		   END
		   IF((Select InterviewProcessId From CandidateJobOpening WHERE CandidateId=@CandidateId AND JobOpeningId = @JobOpeningId) IS NOT NULL)
		   BEGIN
		   SET @InterviewProcessTypeId=(Select InterviewProcessId From CandidateJobOpening WHERE CandidateId=@CandidateId AND JobOpeningId = @JobOpeningId)
		   END
		   ELSE
		   SET @InterviewProcessTypeId=(Select InterviewProcessId From JobOpening WHERE Id = @JobOpeningId)
		   DECLARE @FromJob BIT
		   IF(@CandidateId IS NULL)
		   BEGIN
		   SET @FromJob = 1
		   END
		   
		 --  IF(@CandidateId IS  NOT NULL)
			--SET @JobOpeningId = NULL
		   SELECT IPC.Id AS InterviewProcessConfigurationId,
				  IPTC.InterviewTypeId,
				  IT.InterviewTypeName,
				  IPC.JobOpeningId,
				  IPTC.InterviewProcessId,
				  IPS.InterviewProcessName,
				  IT.IsPhoneCalling,
				  IT.IsVideoCalling,
				  IPC.[Order],
				  IT.[Color],
				  IPC.CreatedByUserId,
				  IPC.CreatedDateTime,
				  IPC.[TimeStamp],
				   (CASE WHEN (SELECT Count(*) FROM CandidateInterviewSchedule CIS 
				   WHERE CIS.InterviewTypeId=IT.Id AND (CIS.IsCancelled = 0 OR CIS.IsCancelled IS NULL)
				  --AND (CIS.JobOpeningId = JOP.Id OR CIS.CandidateId = IPC.[CandidateId])
				  AND CIS.InActiveDateTime IS NULL
				   AND (@JobOpeningId IS NULL OR CIS.JobOpeningId = @JobOpeningId)
				 AND (@CandidateId IS NULL OR CIS.CandidateId = @CandidateId)) 
				  >= 1 THEN 1 ELSE 0 END) AS IsActiveSchedule
				 ,(CASE WHEN (SELECT Count(*) FROM CandidateInterviewSchedule CIS  WHERE CIS.InterviewTypeId=IT.Id AND (CIS.IsCancelled = 0 OR CIS.IsCancelled IS NULL)
				  --AND (CIS.JobOpeningId = JOP.Id OR CIS.CandidateId = IPC.[CandidateId])
				  AND CIS.InActiveDateTime IS NULL
				   AND (@JobOpeningId IS NULL OR CIS.JobOpeningId = @JobOpeningId)
				 AND (@CandidateId IS NULL OR CIS.CandidateId = @CandidateId)) > 0 THEN 0 ELSE 1 END) AS IsNew
				  ,SS.[Status] AS StatusName
				   ,CIS.StatusId AS StatusId
				  ,SS.Color AS StatusColor
				  ,CIS.Id AS ScheduleId
				  ,CIS.[TimeStamp] AS ScheduleTimeStamp
				  ,STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),ITRC.RoleId))
                                FROM [InterviewTypeRoleCofiguration] ITRC
                                     INNER JOIN [Role] R ON R.Id = ITRC.RoleId 
                                                AND R.InactiveDateTime IS NULL AND ITRC.InactiveDateTime IS NULL
                                WHERE ITRC.InterviewTypeId = IT.Id
                                ORDER BY R.RoleName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleId
		   FROM [dbo].[InterviewProcessConfiguration] IPC WITH (NOLOCK)
		   INNER JOIN InterviewProcessTypeConfiguration IPTC ON IPTC.Id = IPC.InterviewProcessTypeConfigurationId
		        INNER JOIN InterviewType IT WITH (NOLOCK) ON IT.Id = IPTC.InterviewTypeId
				INNER JOIN InterviewProcess IPS WITH (NOLOCK) ON IPS.Id = IPTC.InterviewProcessId
				LEFT JOIN JobOpening JOP WITH (NOLOCK) ON JOP.Id=IPC.JobOpeningId AND IPC.JobOpeningId = @JobOpeningId
				LEFT JOIN CandidateInterviewSchedule CIS ON CIS.InterviewTypeId = IT.Id AND CIS.CandidateId = @CandidateId1 AND CIS.JobOpeningId = @JobOpeningId AND CIS.InActiveDateTime IS NULL
				LEFT JOIN ScheduleStatus SS ON SS.Id = CIS.StatusId
		   WHERE IPC.InActiveDateTime IS NULL 
				 AND (@InterviewProcessConfigurationId IS NULL OR IPC.Id = @InterviewProcessConfigurationId)
		         AND (@InterviewTypeId IS NULL OR IPTC.InterviewTypeId = @InterviewTypeId)
				 AND (@InterviewProcessTypeId IS NULL OR IPTC.InterviewProcessId = @InterviewProcessTypeId)
				 AND (@Order IS NULL OR IPC.[Order] = @Order)
				 AND (@JobOpeningId IS NULL OR JOP.Id = @JobOpeningId)
				 AND (@CandidateId IS NULL OR IPC.[CandidateId] = @CandidateId)
				 AND(@FromJob = 0 OR @FromJob IS NULL OR IPC.CandidateId IS NULL)
		   	     AND (@SearchText IS NULL OR (IT.InterviewTypeName LIKE @SearchText)
				                          OR (IPS.InterviewProcessName LIKE @SearchText)
										  OR (IPC.[Order] LIKE @SearchText)
										)
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'InterviewTypeName' THEN IT.InterviewTypeName
		   	    WHEN @SortBy = 'InterviewProcessName' THEN IPS.InterviewProcessName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,IPC.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'Order' THEN IPC.[Order]
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'InterviewTypeName' THEN IT.InterviewTypeName
		   	    WHEN @SortBy = 'InterviewProcessName' THEN IPS.InterviewProcessName
				WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,IPC.CreatedDateTime,121) AS sql_variant)
		   END
		   END DESC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'Order' THEN IPC.[Order]
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
