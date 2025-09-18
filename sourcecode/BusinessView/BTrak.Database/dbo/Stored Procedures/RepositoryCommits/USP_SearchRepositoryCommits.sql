-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-11-12 00:00:00.000'
-- Purpose      To Get Repository commits based on search criteria
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_SearchRepositoryCommits] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SearchRepositoryCommits]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@DateFrom DateTime = NULL,	
	@DateTo DateTime = NULL,	
	@OnDate DateTime = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@UserId UNIQUEIDENTIFIER = NULL	
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText = '') SET @SearchText = NULL

		   IF(@DateFrom = '') SET @DateFrom = NULL

		   IF(@DateTo = '') SET @DateTo = NULL

		   IF(@OnDate = '') SET @OnDate = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   DECLARE @CurrentUserName NVARCHAR(250) = NULL

		   IF(@UserId IS NOT NULL) SET @CurrentUserName = (SELECT UserName FROM [User] WHERE Id = @UserId)

           SELECT RC.Id AS CommitId,
                  CASE WHEN U.UserName IS NULL THEN RC.CommiterEmail ELSE U.UserName END AS CommiterEmail,
                  CASE WHEN RC.CommitedByUserId IS NULL THEN RC.CommiterName ELSE U.FirstName + ' ' + ISNULL(U.SurName,'') END AS CommiterName,
				  [CommitMessage],
				  [CommitReferenceUrl],
				  RC.[CreatedDateTime],
				  [FiledAdded] AS FiledAddedXml,
				  [FilesModified] AS FilesModifiedXml,
				  [FilesRemoved] AS FilesRemovedXml,
				  [FromSource],
				  [RepositoryName],
				  [CommitedByUserId],
		   	      TotalCount = COUNT(*) OVER()
           FROM [RepositoryCommits] RC
				LEFT JOIN [User] U ON U.Id = RC.CommitedByUserId
           WHERE RC.CompanyId = @CompanyId 
		       AND (@SearchText IS NULL OR (RC.CommitMessage LIKE @SearchText))
		       AND (@UserId IS NULL OR (RC.CommitedByUserId = @UserId OR (@CurrentUserName IS NULL OR (RC.CommiterEmail = @CurrentUserName))))
			   AND (@OnDate IS NULL OR (CONVERT(DATE,RC.CreatedDateTime) = CONVERT(DATE,@OnDate)))
			   AND (@DateFrom IS NULL OR @DateTo IS NULL OR (RC.CreatedDateTime BETWEEN @DateFrom AND @DateTo))
           ORDER BY RC.CreatedDateTime DESC

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