CREATE PROCEDURE [dbo].[USP_ArchiveCronExpression]
	@CustomWidgetId UNIQUEIDENTIFIER = NULL,
	@CronExpressionId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL

AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF (@HavePermission = '1')
			BEGIN
			   DECLARE @Currentdate DATETIME = GETDATE()
			   DECLARE @OldIsArchived BIT 
			   DECLARE @InActiveDateTime DATETIME = (SELECT InActiveDateTime FROM [dbo].[CronExpression] WHERE Id = @CronExpressionId AND @CustomWidgetId = @CustomWidgetId)

			   IF(@InActiveDateTime IS NOT NULL)
			   BEGIN
			      SET @OldIsArchived = NULL
			   END

			    

			     	UPDATE [dbo].[CronExpression]
					  SET [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
					  WHERE CustomWidgetId = @CustomWidgetId AND Id = @CronExpressionId

					  IF(@OldIsArchived <> @IsArchived)
		    BEGIN

			DECLARE @OldValue NVARCHAR(MAX)

			DECLARE @NewValue NVARCHAR(MAX)

			DECLARE @FieldName NVARCHAR(250)

			DECLARE @HistoryDescription NVARCHAR(MAX)

		        SET @OldValue = IIF(@OldIsArchived IS NULL,'',IIF(@OldIsArchived = 0,'No','Yes'))

		        SET @NewValue = IIF(@IsArchived IS NULL,'',IIF(@IsArchived = 0,'No','Yes'))

		        SET @FieldName = 'CronExpressionDeleted'	

		        SET @HistoryDescription = 'CronExpressionDeleted'
		        
		        EXEC USP_InsertCronExpressionHistory @CustomWidgetId = @CustomWidgetId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                             @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @CronExpressionId = @CronExpressionId
		    
		    END
			END

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
