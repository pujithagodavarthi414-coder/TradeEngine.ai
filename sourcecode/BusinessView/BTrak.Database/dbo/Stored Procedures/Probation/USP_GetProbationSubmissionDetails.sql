CREATE PROCEDURE [dbo].[USP_GetProbationSubmissionDetails]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @ProbationId UNIQUEIDENTIFIER = NULL,
	 @SubmissionFrom INT = NULL
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
            
              SELECT  PS.Id AS ProbationId,
					  PS.ConfigurationId,
					  PC.[Name] AS ConfigurationName,
					  PC.FormJson,
					  PS.IsOpen,
					  PS.IsShare,
					  PS.OfUserId,
					  PS.PdfUrl,
					  PSD.FormData,
					  PSD.Id AS ProbationDetailsId,
					  ISNULL(PSD.IsCompleted,0) IsCompleted,
					  PSD.SubmissionFrom,
					  PSD.SubmittedBy,
					  U.FirstName + ' ' + ISNULL(U.SurName,NULL) AS SubmittedByName,
					  U.ProfileImage AS SubmittedByProfileImage,
					  PS.CreatedByUserId,
					  PSD.CreatedDateTime AS SubmittedOn,
                      TotalCount = COUNT(1) OVER()
            FROM ProbationSubmissionDetails PSD
				JOIN ProbationSubmission PS ON PS.Id = PSD.ProbationSubmissionId
				JOIN [User] U ON U.Id = PSD.SubmittedBy
				JOIN ProbationConfiguration PC ON PS.ConfigurationId = PC.Id AND PC.InActiveDateTime IS NULL
			WHERE (@ProbationId IS NULL OR (PSD.ProbationSubmissionId = @ProbationId))
				AND (@SubmissionFrom IS NULL OR (PSD.SubmissionFrom = @SubmissionFrom))
            ORDER BY PC.CreatedDatetime DESC
 
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
