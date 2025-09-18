CREATE PROCEDURE [dbo].[USP_GetInterviewProcess]
(
	@InterviewProcessId UNIQUEIDENTIFIER = NULL,
	@InterviewProcessName NVARCHAR(250) = NULL,
	@InterviewTypeId UNIQUEIDENTIFIER = NULL,
	@SortBy NVARCHAR(100) = NULL,
	@SearchText NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50)=NULL,
    @PageSize INT = NULL,
    @PageNumber INT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT= NULL

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

	       IF(@InterviewProcessId = '00000000-0000-0000-0000-000000000000') SET  @InterviewProcessId = NULL

		   IF(@InterviewTypeId = '00000000-0000-0000-0000-000000000000') SET  @InterviewTypeId = NULL

		   IF(@InterviewProcessName = '') SET  @InterviewProcessName = NULL

	       IF(@SearchText = '') SET  @SearchText = NULL

		   IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		   IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

		   IF(@PageSize IS NULL) SET @PageSize = (CASE WHEN (SELECT COUNT(1) FROM [InterviewProcess])=0 THEN 10 ELSE (SELECT COUNT(1) FROM [InterviewProcess]) END)

		   IF(@PageNumber IS NULL) SET @PageNumber = 1

		   SET @SearchText = '%' + @SearchText + '%'

		   SELECT IPS.Id AS InterviewProcessId,
				  IPS.InterviewProcessName,
				  
				 -- (SELECT  LOWER(CONVERT(NVARCHAR(50),IPC.Id))+
					--			 LOWER(CONVERT(NVARCHAR(50),IPC.JobOpeningId))+
					--			 LOWER(CONVERT(NVARCHAR(50),IPC.InterviewProcessId))+
					--			 LOWER(CONVERT(NVARCHAR(50),IPC.InterviewTypeId))+
					--			 LOWER(CONVERT(NVARCHAR(50),IPC.[IsPhoneCalling]))+
					--			 LOWER(CONVERT(NVARCHAR(50),IPC.[IsVideoCalling]))+
					--			 IPC.[Order]
     --                     FROM InterviewProcessConfiguration IPC 
					--	  INNER JOIN JobOpening JO ON JO.Id = IPC.JobOpeningId
     --                     WHERE IPC.InterviewProcessId = IPS.Id AND IPC.InactiveDateTime IS NULL
     --               FOR XML PATH('InterviewProcessTypes')) AS InterviewProcessTypeIds,
					--(SELECT IT.InterviewTypeName+
					--			  IT.Color+
					--			  LOWER(CONVERT(NVARCHAR(50),IPC.InterviewTypeId))
     --                     FROM InterviewProcessConfiguration IPC 
					--	       INNER JOIN InterviewType IT ON IT.Id = IPC.InterviewTypeId
     --                     WHERE IPC.InterviewProcessId = IPS.Id AND IPC.InactiveDateTime IS NULL
     --               FOR XML PATH('InterviewTypes')) AS InterviewTypes,
				  IPS.CreatedByUserId,
				  IPS.CreatedDateTime,
				   InterviewTypeNames =  (STUFF((SELECT ',' + IT.InterviewTypeName [text()]
			  				  FROM  InterviewProcessTypeConfiguration ITC  
			  						INNER JOIN InterviewType IT ON ITC.InterviewTypeId = IT.Id AND IT.InActiveDateTime IS NULL AND ITC.InActiveDateTime IS NULL
			   				  WHERE  ITC.InterviewProcessId = IPS.Id
							  ORDER BY IT.InterviewTypeName,IT.TimeStamp
			  				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
						InterviewTypeIds =  (STUFF((SELECT ',' + CAST(IT.Id AS NVARCHAR(100)) [text()]
			  				  FROM  InterviewProcessTypeConfiguration ITC  
			  						INNER JOIN InterviewType IT ON ITC.InterviewTypeId = IT.Id AND IT.InActiveDateTime IS NULL AND ITC.InActiveDateTime IS NULL
			   				  WHERE  ITC.InterviewProcessId = IPS.Id
							  ORDER BY IT.InterviewTypeName,IT.TimeStamp
			  				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
				  IPS.[TimeStamp]
		   FROM [dbo].[InterviewProcess] IPS WITH (NOLOCK)
		  
		   WHERE (@InterviewProcessId IS NULL OR IPS.Id = @InterviewProcessId)
		   	     AND (@InterviewProcessName IS NULL OR IPS.InterviewProcessName = @InterviewProcessName)
		   	     AND (@SearchText IS NULL OR (IPS.InterviewProcessName LIKE @SearchText))
				 AND IPS.CompanyId = @CompanyId 
				 AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND IPS.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND IPS.InActiveDateTime IS NULL))	
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		   CASE WHEN @SortBy = 'InterviewProcessName' THEN IPS.InterviewProcessName
		   	    WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,IPS.CreatedDateTime,121) AS sql_variant)
		   END
		   END ASC,
		   CASE WHEN @SortDirection = 'DESC' THEN
		   CASE WHEN @SortBy = 'InterviewProcessName' THEN IPS.InterviewProcessName
		   	 	WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,IPS.CreatedDateTime,121) AS sql_variant)
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