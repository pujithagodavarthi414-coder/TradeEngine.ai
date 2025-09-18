CREATE PROCEDURE [dbo].[USP_UpsertCustomApplicationTag]
	@Id UNIQUEIDENTIFIER = NULL,
	@GenericFormSubmittedId UNIQUEIDENTIFIER = NULL,
	@CustomApplicationId UNIQUEIDENTIFIER = NULL,
	@GenericFormKeyId UNIQUEIDENTIFIER = NULL,
	@KeyValue NVARCHAR(MAX) = NULL,
	@IsTag BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	               DECLARE @Currentdate DATETIME = GETDATE()
				   IF(@IsTag = 1)
				   BEGIN
				     INSERT INTO [dbo].[CustomApplicationTag]([Id],GenericFormSubmittedId,GenericFormKeyId,TagValue,[CreatedDateTime],[CreatedByUserId])
				     SELECT NEWID(),@GenericFormSubmittedId,@GenericFormKeyId,@KeyValue,@Currentdate,@OperationsPerformedBy
				   END

				IF(@IsTag = 0)
				BEGIN
				  INSERT INTO [Trend](Id,GenericFormSubmittedId,GenericFormKeyId,TrendValue,CreatedByUserId,CreatedDateTime)
				  SELECT NEWID(),@GenericFormSubmittedId,@GenericFormKeyId,@KeyValue,@OperationsPerformedBy,@Currentdate
				END

				SELECT @GenericFormSubmittedId
				
	END TRY
    BEGIN CATCH

         THROW

    END CATCH
END
GO