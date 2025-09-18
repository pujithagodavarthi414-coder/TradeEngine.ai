-------------------------------------------------------------------------------
-- Author       Surya
-- Created      '2020-05-14 00:00:00.000'
-- Purpose      Un link the bugs
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_DeleteLinkedBug] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_DeleteLinkedBug]
(
    
    @UserStoryId UNIQUEIDENTIFIER = NULL,
    @TimeZone NVARCHAR(250) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

           
            IF(@HavePermission = '1')
            BEGIN
            
               DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			   DECLARE @UserStoryName NVARCHAR(250) = (SELECT UserStoryName FROM [dbo].[UserStory] WHERE Id = @UserStoryId)
			   DECLARE @ParentUserStoryId UNIQUEIDENTIFIER = (SELECT ParentUserStoryId FROM [dbo].[UserStory] WHERE Id = @UserStoryId)
			   
			  DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
					  
			  SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			  
			  DECLARE @Currentdate DATETIME =  dbo.Ufn_GetCurrentTime(@Offset) 

			   DECLARE @LinkId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[LinkUserStory] WHERE LinkUserStoryId = @ParentUserStoryId AND UserStoryId = @UserStoryId)
			   IF EXISTS(SELECT * FROM UserStory WHERE Id=@UserStoryId AND TestCaseId IS NOT NULL)
				BEGIN
					UPDATE UserStory SET TestCaseId=NULL,
					                     ParentUserStoryId = NULL
					                 WHERE Id=@UserStoryId

                      UPDATE [LinkUserStory] SET InActiveDateTime = @CurrentDate WHERE Id = @LinkId  

				
					 INSERT INTO UserStoryHistory(
													  Id,
													  UserStoryId,
													  FieldName,
													  NewValue,
													  [Description],
													  CreatedByUserId,
													  CreatedDateTimeZoneId,
													  CreatedDateTime
													 )
											  SELECT  NEWID(),
											          @ParentUserStoryId,
											          'UnlinkBug',
													  @UserStoryName,
													  'BugUnlink',
													  @OperationsPerformedBy,
													  @TimeZoneId,
													  GETDATE()	
					SELECT @@ROWCOUNT
				END
			   
			   ELSE
			  
			  BEGIN
				UPDATE UserStory SET ParentUserStoryId=NULL WHERE Id=@UserStoryId
				UPDATE [LinkUserStory] SET InActiveDateTime = @CurrentDate WHERE Id = @LinkId  

					 INSERT INTO UserStoryHistory(
													  Id,
													  UserStoryId,
													  FieldName,
													  NewValue,
													  [Description],
													  CreatedByUserId,
													  CreatedDateTimeZoneId,
													  CreatedDateTime
													 )
											  SELECT  NEWID(),
											          @ParentUserStoryId,
											          'UnlinkBug',
													  @UserStoryName,
													  'BugUnlink',
													  @OperationsPerformedBy,
													  @TimeZoneId,
													  GETDATE()	
				 SELECT @@ROWCOUNT
			  END
            END
      ELSE
      BEGIN
      
           RAISERROR (@HavePermission,10, 1)
      
      END
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO
