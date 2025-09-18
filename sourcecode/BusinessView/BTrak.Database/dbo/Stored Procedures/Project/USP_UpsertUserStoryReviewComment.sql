-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-20 00:00:00.000'
-- Purpose      To Save or Update the Module
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved 
-------------------------------------------------------------------------------

----EXEC [dbo].[USP_UpsertUserStoryReviewComment] @OperationsPerformedBy='00000000-0000-0000-0000-000000000000',@Comment ='Test',
----  @UserStoryId='5DE9E4F6-C7CA-4390-9D68-17DB10155D71',@UserStoryReviewStatusId='84AE2B86-7D34-4DC2-89C9-C62E38E3311A'

CREATE PROCEDURE [dbo].[USP_UpsertUserStoryReviewComment]
(
    @UserStoryReviewCommentId UNIQUEIDENTIFIER = NULL,
    @UserStoryId NVARCHAR(250) = NULL,
	@Comment NVARCHAR(500) = NULL,
	@UserStoryReviewStatusId UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
		 --DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByUserStoryId](@UserStoryId))
		     
	     DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

         IF(@HavePermission = '1')
         BEGIN
		 /* When Permission validation is removed from comments then remove user validations*/
		  
		 DECLARE @UserCount INT = (SELECT COUNT(1) FROM [User] WHERE Id = @OperationsPerformedBy)

		 IF (@UserCount > 0)
		 BEGIN
						  
			  DECLARE @IsLatest BIT = (CASE WHEN @UserStoryReviewCommentId IS NULL
                                            THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                   FROM [UserStoryReviewComment] WHERE Id = (SELECT Id FROM [UserStoryReviewComment] WHERE Id = @UserStoryReviewCommentId) AND InActiveDateTime IS NULL) = @TimeStamp
                                                              THEN 1 ELSE 0 END END)
			  IF(@IsLatest = 1)
			  BEGIN

                DECLARE @CurrentDate DATETIME = GETDATE()
	            
	            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	           
                IF(@UserStoryReviewCommentId IS NULL)
				BEGIN

				SET @UserStoryReviewCommentId = NEWID()

	             INSERT INTO [dbo].[UserStoryReviewComment](
                                   [Id],
                                   [UserStoryId],
	           					   [Comment],
								   [UserStoryReviewStatusId],
                                   [CreatedDateTime],
                                   [CreatedByUserId],
								   InActiveDateTime)
                            SELECT @UserStoryReviewCommentId,
                                   @UserStoryId,
								   @Comment,
	           					   @UserStoryReviewStatusId,
                                   @Currentdate,
                                   @OperationsPerformedBy,
								   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

					END
					ELSE
					BEGIN

				           UPDATE  [dbo].[UserStoryReviewComment]
                            SET    [UserStoryId] = @UserStoryId,
	           					   [Comment] = @Comment,
								   [UserStoryReviewStatusId] = @UserStoryReviewStatusId,
                                   [UpdatedDateTime] = @CurrentDate,
                                   [UpdatedByUserId] = @OperationsPerformedBy,
								   InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
								   WHERE Id = @UserStoryReviewCommentId

					END
                            
	            SELECT Id FROM [dbo].[UserStoryReviewComment] WHERE Id = @UserStoryReviewCommentId

            END
		    ELSE
		  	   BEGIN
		    
		  	       RAISERROR (50008,11, 1)

			   END
		    
		  	END
			ELSE
				
				RAISERROR ('InvalidUser',11,1)
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