CREATE PROCEDURE [dbo].[USP_SubmitFeedbackForm]
	@FeedbackId UNIQUEIDENTIFIER = NULL,
	@Description NVARCHAR(MAX) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL 

AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN

	                 DECLARE @NewFeedbackId UNIQUEIDENTIFIER = NEWID()

					 DECLARE @CurrentDate DATETIME = SYSDATETIMEOFFSET() 
					 
					   INSERT INTO [dbo].[Feedback](
					        [Id],
							[Description],
							[SenderUserId],
							[CreatedDateTime],
							[CreatedByUserId]
					        )
						SELECT @NewFeedbackId,
						       @Description,
							   @OperationsPerformedBy,
							   @CurrentDate,
							   @OperationsPerformedBy

				SELECT @NewFeedbackId

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