CREATE PROCEDURE [dbo].[USP_SubmitFeedBack]
    @FeedBackId UNIQUEIDENTIFIER = NULL,
	@Description NVARCHAR(1000) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	 IF (@HavePermission = '1')
            BEGIN
	             DECLARE @Currentdate DATETIME = GETDATE()
				 DECLARE @NewFeedBackId UNIQUEIDENTIFIER = NEWID()
				   INSERT INTO [dbo].[Feedback] (
				              [Id],
							  [Description],
							  [SenderUserId],
							  [CreatedByUserId],
							  [CreatedDateTime]
				               )
				  SELECT @NewFeedBackId,
				         @Description,
						 @OperationsPerformedBy,
						 @OperationsPerformedBy,
						 @Currentdate

				SELECT Id FROM [dbo].[Feedback] WHERE Id = @NewFeedBackId

  END
  END TRY  
    BEGIN CATCH 
          
        THROW
    END CATCH
END
GO