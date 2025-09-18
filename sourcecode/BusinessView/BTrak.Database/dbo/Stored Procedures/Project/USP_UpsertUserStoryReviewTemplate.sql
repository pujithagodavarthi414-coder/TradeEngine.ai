-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-26 00:00:00.000'
-- Purpose      To Save or Update the UserStoryReviewTemplate
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertUserStoryReviewTemplate]@UserStoryId='D06D0B85-BA72-47D7-AE0E-01EC75E11373',
--@ReviewerId='B3A4E6FA-9F71-441D-BBB6-AD1155243D64', @ReviewTemplateId='9011A54B-2946-4094-A58F-3493B169C57C', 
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertUserStoryReviewTemplate]
(
    @UserStoryReviewTemplateId UNIQUEIDENTIFIER = NULL,
    @ReviewTemplateId UNIQUEIDENTIFIER = NULL,
	@UserStoryId UNIQUEIDENTIFIER = NULL,
	@ReviewerId   UNIQUEIDENTIFIER = NULL,
	@ReviewComments NVARCHAR(500)  = NULL,
	@IsArchived BIT = NULL,
	@IsAccepted BIT = NULL,
	@TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
    --DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByUserStoryId](@UserStoryId))
		     
	--DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

   -- IF(@HavePermission = '1')
    --BEGIN

    DECLARE @CurrentDate DATETIME = GETDATE()

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
     
		DECLARE @IsLatest BIT = (CASE WHEN @UserStoryReviewTemplateId IS NULL 
		                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
	                                                           FROM UserStoryReviewTemplate WHERE Id = @UserStoryReviewTemplateId) = @TimeStamp
														THEN 1 ELSE 0 END END)
	
	    IF(@IsLatest = 1)
		BEGIN
			
			IF(@ReviewTemplateId IS NULL)
			BEGIN

			SET @ReviewTemplateId = NEWID()

			INSERT INTO [dbo].[UserStoryReviewTemplate](
                        [Id],
                        [ReviewTemplateId],
						[UserStoryId],
						[ReviewerId],
						[ReviewComments],
						[IsAccepted],
                        [CreatedDateTime],
                        [CreatedByUserId],
						[InActiveDateTime])
                 SELECT @ReviewTemplateId,
                        @ReviewTemplateId,
						@UserStoryId,
						@ReviewerId,
						@ReviewComments,
						@IsAccepted,
                        @Currentdate,
                        @OperationsPerformedBy,
						CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

				END
				ELSE
				BEGIN

				UPDATE [dbo].[UserStoryReviewTemplate]
                  SET   [ReviewTemplateId] = @ReviewTemplateId,
						[UserStoryId] = @UserStoryId,
						[ReviewerId] = @ReviewerId,
						[ReviewComments] = @ReviewComments,
						[IsAccepted] = @IsAccepted,
                        [UpdatedDateTime] = @CurrentDate,
                        [UpdatedByUserId] = @OperationsPerformedBy,
						[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						WHERE Id = @ReviewTemplateId

				END
                 
			 SELECT Id FROM [dbo].[UserStoryReviewTemplate] WHERE Id = @UserStoryReviewTemplateId

		END
		ELSE

		RAISERROR (50008,11, 1)
	--END
	END TRY
    BEGIN CATCH

        THROW

    END CATCH
END