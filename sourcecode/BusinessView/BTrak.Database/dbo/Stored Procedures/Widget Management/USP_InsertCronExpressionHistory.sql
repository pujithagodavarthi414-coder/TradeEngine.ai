-- EXEC [USP_InsertCronExpressionHistory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--                                @CronExpressionId  = '06F47320-6E13-4C77-B067-E62B4F6B8B69',
--                                @OldValue  = 'CronExpression1',
--                                @NewValue  = 'CronExpression2',
--                                @FieldName  = 'CronExpressionName',
--                                @Description  = 'CronExpressionNameChanged'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_InsertCronExpressionHistory]
(
	@CronExpressionId UNIQUEIDENTIFIER = NULL,
	@CustomWidgetId UNIQUEIDENTIFIER = NULL,
	@OldValue NVARCHAR(250) = NULL,
	@NewValue NVARCHAR(250) = NULL,
	@FieldName NVARCHAR(100) = NULL,
	@Description NVARCHAR(800) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeZoneId UNIQUEIDENTIFIER = NULL
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @CronExpressionHistoryId UNIQUEIDENTIFIER = NEWID()

		 DECLARE @Offset NVARCHAR(100) = NULL
			
	     SELECT @Offset = TimeZoneOffset FROM TimeZone WHERE Id = @TimeZoneId
		
		INSERT INTO [dbo].[CronExpressionHistory](
		            [Id],
					CronExpressionId,
		            [CustomWidgetId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
		            CreatedByUserId,
					CreatedDateTimeZoneId)
		     SELECT @CronExpressionHistoryId,
			        @CronExpressionId,
		            @CustomWidgetId,
		            @OldValue,
					@NewValue,
					@FieldName,
					@Description,
		            SYSDATETIMEOFFSET(),
		            @OperationsPerformedBy,
					@TimeZoneId

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO
