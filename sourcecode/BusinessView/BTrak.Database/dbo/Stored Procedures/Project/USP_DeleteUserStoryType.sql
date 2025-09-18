CREATE PROCEDURE [dbo].[USP_DeleteUserStoryType]
(
	@UserStoryTypeId UNIQUEIDENTIFIER = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @IsArchived BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
       SET NOCOUNT ON
       BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	   
	     DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		 DECLARE @UserStoryIdCount INT = (SELECT COUNT(1) FROM [dbo].[UserStory] WHERE UserStoryTypeId = @UserStoryTypeId)
		
		DECLARE @IsLatest BIT = (CASE WHEN ( SELECT [TimeStamp] FROM [UserStoryType] WHERE Id = @UserStoryTypeId ) = @TimeStamp THEN 1 ELSE 0 END )

		 IF(@HavePermission = '1')
          BEGIN  
		   IF(@UserStoryIdCount > 0 AND @UserStoryIdCount IS NOT NULL)
		   BEGIN
		       RAISERROR('WorkItemsAreAlreadyCreated',11,1)
		   END
		   ELSE
		   BEGIN
		      IF (@IsLatest = 1)
			   BEGIN
			  
			    DECLARE @CurrentDate DATETIME = SYSDATETIMEOFFSET()

                UPDATE [UserStoryType]
                SET InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
                WHERE Id = @UserStoryTypeId
                SELECT @UserStoryTypeId

			END
			ELSE
			BEGIN
			   RAISERROR(50015, 11, 1)
			END
		  END
		  END
		 ELSE
		 BEGIN
		    RAISERROR(@HavePermission, 11, 1)
		 END 
		    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO