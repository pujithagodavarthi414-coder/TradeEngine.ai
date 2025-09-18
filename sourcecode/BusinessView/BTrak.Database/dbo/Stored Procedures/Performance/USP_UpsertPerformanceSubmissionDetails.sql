-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-05-02 00:00:00.000'
-- Purpose      To Save or update the performance details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertPerformanceSubmissionDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPerformanceSubmissionDetails]
(
	@PerformanceDetailsId UNIQUEIDENTIFIER = NULL,
	@PerformanceId UNIQUEIDENTIFIER = NULL,
	@IsCompleted BIT = NULL,
	@SubmissionFrom INT = NULL,
	@FormData NVARCHAR(MAX) = NULL,
	@SubmittedBy UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@IsCompleted IS NULL) SET @IsCompleted = 0
			
			IF (@PerformanceDetailsId =  '00000000-0000-0000-0000-000000000000') SET @PerformanceDetailsId = NULL

			IF (@PerformanceId =  '00000000-0000-0000-0000-000000000000') SET @PerformanceId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @PerformanceIdCount INT = (SELECT COUNT(1) FROM PerformanceSubmission WHERE Id = @PerformanceId)

			DECLARE @InviteeCount INT = (SELECT COUNT(1) FROM PerformanceSubmissionDetails WHERE PerformanceSubmissionId = @PerformanceId AND SubmissionFrom = 2 AND SubmittedBy = @SubmittedBy)
			
			IF (@PerformanceIdCount = 0 AND @PerformanceId IS NOT NULL)
			BEGIN
				    
					RAISERROR(50002,16,1,'Performance')

			END
			IF (@PerformanceDetailsId IS NULL AND @InviteeCount > 0 AND @SubmissionFrom = 2)
			BEGIN
				   
	          RAISERROR('ThisUserIsAlreadyInvited',11,1)

			END
			ELSE
			BEGIN
				DECLARE @CurrentDate DATETIME = GETDATE()

				IF(@PerformanceDetailsId IS NULL)
				BEGIN

					  SET @PerformanceDetailsId = NEWID()

						  INSERT INTO PerformanceSubmissionDetails(Id,
							    			PerformanceSubmissionId,
											SubmissionFrom,
											IsCompleted,
											FormData,
											SubmittedBy,
							    			CreatedDateTime,
							    			CreatedByUserId
							    		   )
							    	SELECT  @PerformanceDetailsId,
											@PerformanceId,
											@SubmissionFrom,
											@IsCompleted,
											@FormData,
											@SubmittedBy,
							    			@CurrentDate,
							    			@OperationsPerformedBy
		              
					   END
					   ELSE
					   BEGIN

					   UPDATE PerformanceSubmissionDetails
					     SET  SubmissionFrom = @SubmissionFrom,
							  FormData = @FormData,
							  IsCompleted = @IsCompleted,
							  SubmittedBy = @SubmittedBy,
							  UpdatedByUserId = @OperationsPerformedBy,
							  UpdatedDateTime = @CurrentDate
							 WHERE Id = @PerformanceDetailsId

					   END

				SELECT Id FROM PerformanceSubmissionDetails WHERE Id = @PerformanceDetailsId
					
			END
		
		END
		ELSE
			   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO