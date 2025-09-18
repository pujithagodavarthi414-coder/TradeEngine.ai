-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetProbationSubmissions] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetProbationSubmissions]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @IsArchived BIT = NULL,
	 @IsOpen BIT = NULL,
	 @OfUserId UNIQUEIDENTIFIER = NULL,
	 @SearchText NVARCHAR(100) = NULL,
	 @SortBy NVARCHAR(100) = NULL,
	 @SortDirection NVARCHAR(50)=NULL,
	 @PageNumber INT = 1,
	 @PageSize INT = 30
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		 
		 IF(@SearchText = '') SET  @SearchText = NULL
		     
	     SET @SearchText = '%'+ @SearchText +'%'

		 IF (@IsOpen IS NULL) SET @IsOpen = 0

	     IF(@SortBy IS NULL) SET @SortBy = 'latestModificationOn'
         
		 IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'

         IF (@HavePermission = '1')
         BEGIN
 
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
              SELECT  PS.Id AS ProbationId,
					  PS.ConfigurationId,
					  PC.[Name] AS ConfigurationName,
					  PC.FormJson,
					  PS.IsOpen,
					  PS.IsShare,
					  PS.OfUserId,
					  PS.PdfUrl,
					  PS.CreatedByUserId,
					  PS.ClosedByUserId,
					  PS.CreatedDateTime,
					  CU.FirstName + ' ' + ISNULL(CU.SurName,'') AS CreatedByUserName,
					  CLU.FirstName + ' ' + ISNULL(CLU.SurName,'') AS ClosedByUserName,
					  CU.ProfileImage AS CreatedByUserImage,
					  CLU.ProfileImage AS ClosedByUserImage,
					  ISNULL(PS.UpdatedDateTime,PS.CreatedDateTime) AS LatestModificationOn,
					  E.Id AS EmployeeId,
					  OFU.FirstName + ' ' + ISNULL(OFU.SurName,'') AS OfUserName,
                      TotalCount = COUNT(1) OVER()
            FROM ProbationSubmission PS
				JOIN ProbationConfiguration PC ON PS.ConfigurationId = PC.Id AND PC.InActiveDateTime IS NULL
				JOIN [User] CU ON CU.Id = PS.CreatedByUserId
				LEFT JOIN [User] CLU ON CLU.Id = PS.ClosedByUserId
				LEFT JOIN [Employee] E ON E.UserId = @OfUserId
				LEFT JOIN [User] OFU ON OFU.Id = @OfUserId
			WHERE PS.OfUserId = @OfUserId
				AND (PS.IsOpen = @IsOpen)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND PS.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND PS.InactiveDateTime IS NULL))
				AND  (@SearchText IS NULL 
							  OR (PC.[Name] LIKE @SearchText)
							  OR (CU.FirstName + ' ' + ISNULL(CU.SurName,'') LIKE @SearchText)
							  OR (CLU.FirstName + ' ' + ISNULL(CLU.SurName,'') LIKE @SearchText)
							  )
		   ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
		  	  			CASE WHEN @SortBy = 'latestModificationOn' THEN CAST(ISNULL(PS.UpdatedDateTime,PS.CreatedDateTime) AS sql_variant)
		  	  			     WHEN @SortBy = 'configurationName' THEN  PC.[Name]
		  	  			     WHEN @SortBy = 'createdOn' THEN  PS.CreatedDateTime
		  	  			     WHEN @SortBy = 'closedBy' THEN  CLU.FirstName + ' ' + ISNULL(CLU.SurName,'')
		  	  			     WHEN @SortBy = 'createdBy' THEN  CU.FirstName + ' ' + ISNULL(CU.SurName,'')
		  	  			END
		  	  	  END ASC,
		  	  	  CASE WHEN @SortDirection = 'DESC' THEN
		  	  			CASE WHEN @SortBy = 'latestModificationOn' THEN CAST(ISNULL(PS.UpdatedDateTime,PS.CreatedDateTime) AS sql_variant)
		  	  			     WHEN @SortBy = 'configurationName' THEN  PC.[Name]
		  	  			     WHEN @SortBy = 'createdOn' THEN  PS.CreatedDateTime
		  	  			     WHEN @SortBy = 'closedBy' THEN  CLU.FirstName + ' ' + ISNULL(CLU.SurName,'')
		  	  			     WHEN @SortBy = 'createdBy' THEN  CU.FirstName + ' ' + ISNULL(CU.SurName,'')
		  	  			END
		  	  	  END DESC
				 OFFSET ((@PageNumber - 1) * @PageSize) ROWS		        
                FETCH NEXT @PageSize ROWS ONLY
 
         END
         ELSE
         BEGIN
         
                 RAISERROR (@HavePermission,11, 1)
                 
         END
    END TRY
    BEGIN CATCH
        
        THROW
 
    END CATCH 
 END
GO
