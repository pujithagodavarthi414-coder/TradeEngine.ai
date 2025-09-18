CREATE PROCEDURE [dbo].[USP_GetCandidateHistory]
	@CandidateHistoryId UNIQUEIDENTIFIER = NULL,
	@CandidateId UNIQUEIDENTIFIER = NULL,
	@JobOpeningId UNIQUEIDENTIFIER = NULL,
	@OldValue NVARCHAR(250) = NULL,
	@NewValue NVARCHAR(250) = NULL,
	@FieldName NVARCHAR(100) = NULL,
	@Description NVARCHAR(800) = NULL,
	--@SortBy NVARCHAR(100) = NULL,
	--@SortDirection VARCHAR(50)= NULL,
	--@PageSize INT = NULL,
	--@PageNumber INT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

       DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

       IF (@HavePermission = '1')
       BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   IF(@CandidateHistoryId = '00000000-0000-0000-0000-000000000000') SET  @CandidateHistoryId = NULL
		   
		   IF(@CandidateId = '00000000-0000-0000-0000-000000000000') SET  @CandidateId = NULL

		   IF(@JobOpeningId = '00000000-0000-0000-0000-000000000000') SET  @JobOpeningId = NULL

		   IF(@OldValue = '') SET  @OldValue = NULL

	       IF(@NewValue = '') SET  @NewValue = NULL

	       IF(@FieldName = '') SET  @FieldName = NULL

	       --IF(@SortBy IS NULL ) SET  @SortBy = 'CreatedDateTime'

	       --IF(@SortDirection IS NULL ) SET  @SortDirection = 'DESC'

	   --    IF(@PageSize IS NULL ) SET  @PageSize = (SELECT COUNT(1) FROM [dbo].[CandidateHistory])

	   --    IF(@PageNumber IS NULL ) SET  @PageNumber = 1

		  -- IF(@PageSize = 0)
		  -- BEGIN
				--SELECT @PageSize = 10, @PageNumber = 1
		  -- END

		   SELECT DISTINCT CH.Id AS CandidateHistoryId,
				  CH.[JobOpeningId],
				  CH.[CandidateId],
				  C.FirstName+' '+C.LastName AS CandidateName,
				  CH.OldValue,
				  CH.NewValue,
				  CH.FieldName,
				  CH.[Description],
				  CH.CreatedByUserId,
				  U.FirstName+' '+U.SurName AS CreatedUserName,
				  U.ProfileImage AS CreatedUserProfile,
				  CH.CreatedDateTime
		   FROM CandidateHistory CH
		   INNER JOIN Candidate C ON C.Id=CH.CandidateId
		   INNER JOIN CandidateJobOpening CJO ON CJO.CandidateId=C.Id
		   INNER JOIN [User] U ON U.Id = CH.CreatedByUserId
		   WHERE (@CandidateId IS NULL OR C.Id=@CandidateId)
		     AND (@CandidateHistoryId IS NULL OR CH.Id=@CandidateHistoryId)
			 AND (@JobOpeningId IS NULL OR CJO.JobOpeningId=@JobOpeningId)
			 AND FieldName IS NOT NULL
			ORDER BY CH.CreatedDateTime DESC


	   END
	  ELSE
           RAISERROR (@HavePermission,11, 1)
	 END TRY  
	 BEGIN CATCH 
		
		  THROW

	END CATCH

END
GO