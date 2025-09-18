CREATE PROCEDURE [dbo].[USP_ApproveCandidateInterviewSchedule]
(
   @CandidateInterviewScheduleId UNIQUEIDENTIFIER,
   @CandidateId UNIQUEIDENTIFIER = NULL,
   @IsApproved BIT,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				  DECLARE @Currentdate DATETIME = GETDATE()
					UPDATE [CandidateInterviewScheduleAssignee] 
										SET IsApproved = @IsApproved
                                           ,UpdatedByUserId = @OperationsPerformedBy
                                           ,UpdatedDateTime = @Currentdate
                                       WHERE [CandidateInterviewScheduleId] = @CandidateInterviewScheduleId 
									   AND AssignToUserId = @OperationsPerformedBy
									 
				    SELECT Id FROM [dbo].[CandidateInterviewSchedule] WHERE Id = @CandidateInterviewScheduleId
				                   
				  
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
