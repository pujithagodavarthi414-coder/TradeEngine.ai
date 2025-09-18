CREATE PROCEDURE [dbo].[USP_GetBrytumViewJobDetails]
(	
	@JobOpeningId UNIQUEIDENTIFIER = NULL,
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

       DECLARE @HavePermission NVARCHAR(250) = 1--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

       IF (@HavePermission = '1')
       BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   IF(@JobOpeningId = '00000000-0000-0000-0000-000000000000') SET  @JobOpeningId = NULL

        	SELECT JO.JobOpeningTitle,
                   JO.JobOpeningUniqueName,
        		   JO.Id JobOpeningId,
				   CAST(CIS.StartTime AS DATETIME) DateFrom,
				   CAST(CIS.EndTime AS DATETIME) DateTo,
				   JO.JobDescription,
				   JO.NoOfOpenings,
                   CIS.CandidateId,
				   C.FirstName +''+C.LastName CandidateName,
				   C.ProfileImage CandidateProfileImage,
				   CIS.CandidateId,
				   IT.InterviewTypeName,
				   U.FirstName+' '+U.SurName InterviewerName,
				   U.Id InterviewerId,
				   U.ProfileImage InterviewerProfileImage,
        		            C.CandidateUniqueName,
        		    		C.FirstName +''+C.LastName CandidateName,
				   CIS.InterviewDate,
        		    		CIS.CandidateId,
				   CIS.StartTime,
				   CIS.EndTime,
				  DENSE_RANK() OVER (ORDER BY  C.FirstName+' '+C.LastName,U.Id) ResourceId 
         FROM JobOpening JO INNER JOIN JobOpeningStatus JOS ON JOS.Id =JO.JobOpeningStatusId AND JOS.InActiveDateTime IS NULL AND JOS.[Status] = 'Active'
		                    INNER JOIN CandidateInterviewSchedule CIS ON JO.Id = CIS.JobOpeningId AND CIS.InActiveDateTime IS NULL AND ISNULL(CIS.IsCancelled,0) = 0
							INNER JOIN CandidateInterviewScheduleAssignee CISA  ON CIS.Id = CISA.CandidateInterviewScheduleId AND CIS.InActiveDateTime IS NULL  --AND CISA.IsApproved = 1 AND CIS.IsConfirmed= 1
                            INNER  JOIN [User] U ON U.Id = CISA.AssignToUserId AND U.InActiveDateTime IS NULL
        		            INNER JOIN Candidate C ON C.Id = CIS.CandidateId AND C.InActiveDateTime IS NULL
				            INNER JOIN InterviewType IT ON IT.Id = CIS.InterviewTypeId AND IT.InActiveDateTime IS NULL
		 WHERE JO.CompanyId = @CompanyId AND JO.InActiveDateTime IS NULL
		      AND (@DateFrom IS NULL OR CAST(CIS.InterviewDate AS date)  >= CAST(@DateFrom AS DATE))
		      AND (@DateTo IS NULL OR CAST(CIS.InterviewDate AS date) <= CAST(@DateTo AS DATE))
         ORDER BY CIS.InterviewDate

	   END
	  ELSE
           RAISERROR (@HavePermission,11, 1)

	 END TRY  
	 BEGIN CATCH 
		
		  THROW

	END CATCH

END
GO