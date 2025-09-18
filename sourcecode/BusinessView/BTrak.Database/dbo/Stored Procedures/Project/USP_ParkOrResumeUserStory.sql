CREATE PROCEDURE [dbo].[USP_ParkOrResumeUserStory]
   @Id UNIQUEIDENTIFIER,
   @IsUserStoryPark BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
AS
   SET NOCOUNT ON
   SET XACT_ABORT ON  

   BEGIN TRAN

	    DECLARE @ParkedDateTime DATETIME = (SELECT ParkedDateTime FROM UserStory WHERE Id = @Id)
		
		DECLARE @OldValue NVARCHAR(100),@NewValue NVARCHAR(100),@FieldName NVARCHAR(200),@HistoryDescription NVARCHAR(800)

        IF((@IsUserStoryPark = 1 AND @ParkedDateTime IS NULL) OR (@IsUserStoryPark = 0 AND @ParkedDateTime IS NOT NULL))
		BEGIN
		
		     SET @OldValue = CASE WHEN @IsUserStoryPark = 1 THEN 'Un parked' WHEN @IsUserStoryPark = 0 THEN 'Parked' END
		     SET @NewValue = CASE WHEN @IsUserStoryPark = 1 THEN 'Parked' WHEN @IsUserStoryPark = 0 THEN 'Un parked' END
		
			 DECLARE @OldParkedDateTime NVARCHAR(250) = CASE WHEN @IsUserStoryPark = 1 THEN NULL WHEN @IsUserStoryPark = 0 THEN @ParkedDateTime END
		     DECLARE @NewParkedDateTime NVARCHAR(250) = CASE WHEN @IsUserStoryPark = 1 THEN GETDATE() WHEN @IsUserStoryPark = 0 THEN NULL END
		
		     SET @FieldName = 'ParkedDateTime'	
		     SET @HistoryDescription = 'User story Changed from <em><b>' + ISNULL(@OldValue,'null') +'</b></em> to <em><b>'+
		     ISNULL(@NewValue,'null') + '</b></em> by '+ ISNULL((SELECT [dbo].[Ufn_GetUsernameBasedOnUserId] (@OperationsPerformedBy)),'null') + '</br>'	
		     
		     EXEC USP_InsertUserStoryHistory @UserStoryId = @Id, @OldValue = @OldParkedDateTime,@NewValue=@NewParkedDateTime,@FieldName  = @FieldName,
		     @Description = @HistoryDescription,@OperationsPerformedBy = @OperationsPerformedBy
		
		END

   IF(@isUserStoryPark IS NULL OR @isUserStoryPark = 0) 
   BEGIN
      UPDATE [dbo].[UserStory] SET ParkedDateTime = NULL WHERE  [Id] = @Id 
   END
   ELSE
   BEGIN
      UPDATE [dbo].[UserStory] SET ParkedDateTime = SYSDATETIMEOFFSET() WHERE  [Id] = @Id 
   END
  
   COMMIT