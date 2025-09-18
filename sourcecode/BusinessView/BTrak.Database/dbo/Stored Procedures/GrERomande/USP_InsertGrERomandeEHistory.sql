CREATE PROCEDURE [dbo].[USP_InsertGrERomandeEHistory]
  @GreRomandeId UNIQUEIDENTIFIER = NULL,
  @OldValue NVARCHAR(MAX) = NULL,
  @NewValue NVARCHAR(MAX) = NULL,
  @FieldName NVARCHAR(100) = NULL,
  @Description NVARCHAR(max) = NULL,
  @OldJson NVARCHAR(MAX) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @GreRomandeHistoryId UNIQUEIDENTIFIER = NEWID()

		
		INSERT INTO [dbo].[GreRomandeEHistory](
		            [Id],
		            [GreRomandeId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
					OldJson,
		            CreatedDateTime,
		            CreatedByUserId)
		     SELECT @GreRomandeHistoryId,
		            @GreRomandeId,
		            @OldValue,
					@NewValue,
					@FieldName,
					@Description,
					@OldJson,
		            GETDATE(),
		            @OperationsPerformedBy

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO
