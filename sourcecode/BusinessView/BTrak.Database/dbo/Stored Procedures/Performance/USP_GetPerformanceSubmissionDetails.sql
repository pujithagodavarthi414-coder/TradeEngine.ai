-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To Get Performance submissions
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetPerformanceSubmissionDetails] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPerformanceSubmissionDetails]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @PerformanceId UNIQUEIDENTIFIER = NULL,
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
            
              SELECT  PS.Id AS PerformanceId,
					  PS.ConfigurationId,
					  PC.[Name] AS ConfigurationName,
					  PC.FormJson,
					  PS.IsOpen,
					  PS.IsShare,
					  PS.OfUserId,
					  PS.PdfUrl,
					  PSD.FormData,
					  PSD.Id AS PerformanceDetailsId,
					  ISNULL(PSD.IsCompleted,0) IsCompleted,
					  PSD.SubmissionFrom,
					  PSD.SubmittedBy,
					  U.FirstName + ' ' + ISNULL(U.SurName,NULL) AS SubmittedByName,
					  U.ProfileImage AS SubmittedByProfileImage,
					  PS.CreatedByUserId,
					  PSD.CreatedDateTime AS SubmittedOn,
                      TotalCount = COUNT(1) OVER()
            FROM PerformanceSubmissionDetails PSD
				JOIN PerformanceSubmission PS ON PS.Id = PSD.PerformanceSubmissionId
				JOIN [User] U ON U.Id = PSD.SubmittedBy
				JOIN PerformanceConfiguration PC ON PS.ConfigurationId = PC.Id AND PC.InActiveDateTime IS NULL
			WHERE (@PerformanceId IS NULL OR (PSD.PerformanceSubmissionId = @PerformanceId))
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
