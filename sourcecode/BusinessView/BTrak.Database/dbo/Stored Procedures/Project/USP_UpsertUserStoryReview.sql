-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-26 00:00:00.000'
-- Purpose      To Save or Update the UserStoryReviewTemplate
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertUserStoryReview] @UserStoryReviewTemplateId='A7D3CDB7-417F-4127-A73E-E0BE987EDD9A',
-- @AnswerJson='TEST',@SubmittedDateTime='2019-03-26',@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertUserStoryReview]
(
    @UserStoryReviewId UNIQUEIDENTIFIER = NULL,
    @UserStoryReviewTemplateId UNIQUEIDENTIFIER = NULL,
	@AnswerJson NVARCHAR(500) = NULL,
	@SubmittedDateTime DATETIME = NULL,
	@IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
	DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
     
	DECLARE @HavePermission NVARCHAR(250) = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) -- Not in excel
				
	IF (@HavePermission = '1')
	BEGIN
	        
			DECLARE @IsLatest BIT = (CASE WHEN @UserStoryReviewId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM UserStoryReview WHERE Id = @UserStoryReviewId) = @TimeStamp
																THEN 1 ELSE 0 END END)

			IF(@IsLatest = 1)
		    BEGIN

			   IF(@UserStoryReviewId IS NULL)
			   BEGIN

			   SET @UserStoryReviewId = NEWID()

			INSERT INTO [dbo].[UserStoryReview](
                        [Id],
                        [UserStoryReviewTemplateId],
						[AnswerJson],
						[SubmittedDateTime],
                        [CreatedDateTime],
                        [CreatedByUserId],
						InActiveDateTime)
                 SELECT @UserStoryReviewId,
                        @UserStoryReviewTemplateId,
						@AnswerJson,
						@SubmittedDateTime,
                        @Currentdate,
                        @OperationsPerformedBy,
						CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END   

				 END
				 ELSE
				 BEGIN

				 UPDATE [dbo].[UserStoryReview]
                    SET [UserStoryReviewTemplateId] = @UserStoryReviewTemplateId,
						[AnswerJson] = @AnswerJson,
						[SubmittedDateTime] = @SubmittedDateTime,
                        [UpdatedDateTime]  = @Currentdate,
                        [UpdatedByUserId] = @OperationsPerformedBy,
						InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END   
						WHERE Id = @UserStoryReviewId

				 END
                 
				SELECT Id FROM [dbo].[UserStoryReview] WHERE Id = @UserStoryReviewId
			END

			ELSE
			  RAISERROR (50008,11, 1)
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