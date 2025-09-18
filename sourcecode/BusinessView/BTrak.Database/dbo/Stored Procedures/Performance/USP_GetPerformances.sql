	-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-05-05 00:00:00.000'
-- Purpose      To Get Performances
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetPerformances] @OperationsPerformedBy = '6D6C3BC3-DECA-4BC6-8D27-67911CE36129',@WaitingForApproval = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPerformances]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @WaitingForApproval BIT = NULL,
	 @PerformanceId UNIQUEIDENTIFIER = NULL,
	 @PageNumber INT = 1,
	 @PageSize INT = 30,
	 @IncludeApproved BIT = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
		 IF (@IncludeApproved IS NULL) SET @IncludeApproved = 0

         IF (@HavePermission = '1')
         BEGIN
 
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
              SELECT PC.[Name] AS ConfigurationName,
					 PC.Id AS ConfigurationId,				
					 PC.FormJson,
					 PC.CreatedByUserId AS AssignedByUserId,
					 PC.CreatedDatetime AS AssignedOn,
					 ASU.FirstName + ' ' + ISNULL(ASU.SurName,'') AS AssignedByUser,
					 P.Id AS PerformanceId,
					 P.FormData,
					 ISNULL(P.IsDraft,0) AS IsDraft,
					 ISNULL(P.IsSubmitted,0) AS IsSubmitted,
					 ISNULL(P.IsApproved,0) AS IsApproved,
					 P.ApprovedBy,
					 AU.FirstName + ' ' + ISNULL(AU.SurName,'') AS ApprovedByUser,
					 P.CreatedByUserId AS SubmittedBy,
					 AA.FirstName + ' ' + ISNULL(AA.SurName,'') AS SubmittedByUser,
					 P.SubmitedDatetime AS SubmittedOn,
					 P.ApprovedDatetime AS ApprovedOn,
					 TotalNumber = COUNT(1) OVER()
            FROM PerformanceConfiguration PC
			JOIN [User] ASU ON ASU.Id = PC.CreatedByUserId AND PC.CompanyId = @CompanyId AND PC.InActiveDatetime IS NULL AND (PC.IsDraft IS NULL OR PC.IsDraft = 0) 
			JOIN Performance P ON P.ConfigurationId = PC.Id AND (@PerformanceId IS NULL OR P.Id = @PerformanceId)
			LEFT JOIN [User] AU ON AU.Id = P.ApprovedBy
			LEFT JOIN [User] AA ON AA.Id = P.CreatedByUserId
			WHERE ((ISNULL(@WaitingForApproval,0) = 0 AND (P.Id IS NULL OR (P.Id IS NOT NULL AND P.CreatedByUserId = @OperationsPerformedBy)))
			       OR (@WaitingForApproval = 1 AND P.IsSubmitted = 1))
				   AND ((@IncludeApproved = 0 AND ISNULL(P.IsApproved,0) = 0) OR @IncludeApproved = 1)
			ORDER BY P.CreatedDatetime DESC
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
