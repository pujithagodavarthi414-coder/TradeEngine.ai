-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2018-02-07 00:00:00.000'
-- Purpose      To Get status reports by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  --EXEC [dbo].[USP_GetStatusReports_New] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetStatusReports_New]
(  
   @StatusReportId  UNIQUEIDENTIFIER = NULL, 
   @StatusReportingConfigurationOptionId UNIQUEIDENTIFIER = NULL, 
   @FilePath NVARCHAR(250) = NULL,
   @FileName NVARCHAR(250) = NULL,
   @Description NVARCHAR(max) = NULL,
   @PageSize INT = NULL,
   @PageNumber INT = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER = NULL,
   @CreatedOn DATETIME = NULL,
   @UserIds NVARCHAR(MAX) = NULL,
   @SearchText NVARCHAR(250) = NULL,
   @IsUnread BIT = NULL
)
AS
BEGIN

	SET NOCOUNT ON
		
	BEGIN TRY
	
     DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	
	 IF (@HavePermission = '1')
	 BEGIN
        
	 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	 
	 IF(@StatusReportId = '00000000-0000-0000-0000-000000000000') SET @StatusReportId = NULL
	
	 IF(@StatusReportingConfigurationOptionId = '00000000-0000-0000-0000-000000000000') SET @StatusReportingConfigurationOptionId = NULL

	 IF(@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [StatusReporting_New])

	 IF(@SearchText = '') SET @SearchText = NULL

	 IF(@UserIds = '') SET @UserIds = NULL

	 IF(@PageNumber IS NULL) SET @PageNumber = 1
	 
	 IF(@PageSize = 0) SELECT @PageSize = 10,@PageNumber = 1

	 CREATE TABLE #UserIds
                           (
                           UserId UNIQUEIDENTIFIER
                           )
                           IF(@UserIds IS NOT NULL)
                           BEGIN
                             INSERT INTO #UserIds
                             SELECT Id FROM UfnSplit (@UserIds)
                           END
	  
	 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT  CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)  

	      SELECT   SR.Id,
                   SR.StatusReportingConfigurationOptionId,
				   SR.FilePath,
				   SR.[FileName],
				   GF.FormName,
				   SR.FormJson,
				   SR.FormDataJson,
				   SR.[Description],				   
                   SR.CreatedDateTime,
                   SR.CreatedByUserId,
				   U.FirstName AS CreatedByUserName,
                   SR.UpdatedDateTime,
				   ISNULL(SRSH.Seen,0) AS Seen,
                   SR.UpdatedByUserId,
				   TotalCount = COUNT(1) OVER()
		          FROM  [StatusReporting_New]SR WITH (NOLOCK) INNER JOIN StatusReportingConfigurationOption SRCO ON SRCO.Id=SR.StatusReportingConfigurationOptionId --AND SRCO.InActiveDateTime IS NULL
				                                 INNER JOIN StatusReportingOption_New SRO ON SRO.Id = SRCO.StatusReportingOptionId AND SRO.InActiveDateTime IS NULL
				                                 INNER JOIN StatusReportingConfiguration_New SRC ON SRCO.StatusReportingConfigurationId = SRC.Id
										         INNER JOIN GenericForm GF ON SRC.GenericFormId = GF.Id AND GF.InActiveDateTime IS NULL
												 INNER JOIN [User] U ON U.Id = SR.CreatedByUserId AND U.InActiveDateTime IS NULL
												 LEFT JOIN #UserIds UI ON UI.UserId = SR.CreatedByUserId
												 LEFT JOIN StatusReportSeenHistory SRSH ON SR.Id = SRSH.StatusReportId AND Sr.CreatedByUserId = SRSH.CreatedByUserId
		         WHERE SRO.CompanyId = @CompanyId
											AND SR.InActiveDateTime IS NULL
		                                    AND (@StatusReportId IS NULL OR SR.Id = @StatusReportId)
		                                    AND (@StatusReportingConfigurationOptionId IS NULL OR SR.StatusReportingConfigurationOptionId = @StatusReportingConfigurationOptionId)
		                                    AND (@FilePath IS NULL OR SR.FilePath = @FilePath)
										    AND (@FileName IS NULL OR SR.[FileName] = @FileName)
										    AND (@Description IS NULL OR SR.[Description] = @Description)
										    AND (U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId)))
											AND (@CreatedOn IS NULL OR CONVERT(DATE,@CreatedOn) = CONVERT(DATE,SR.CreatedDateTime))
										    AND (@UserIds IS NULL OR UI.UserId IS NOT NULL)
											AND (@SearchText IS NULL OR GF.FormName LIKE '%' + @SearchText + '%')
											AND (@IsUnread IS NULL OR @IsUnread = 0 OR (@IsUnread = 1 AND (SRSH.Seen = 0 OR SRSH.Seen IS NULL)))
	       ORDER BY SR.CreatedDateTime DESC
					  
					   OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                    
                      FETCH NEXT @PageSize ROWS ONLY 
	END
	END TRY  
	 BEGIN CATCH 
		
		THROW

	END CATCH
END
GO