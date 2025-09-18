CREATE PROCEDURE [dbo].[USP_UpdateFieldValue]
(
  	@FormId UNIQUEIDENTIFIER = NULL,
    @DataSetId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy  UNIQUEIDENTIFIER = NULL,
    @FieldName VARCHAR(50),
	@FieldValue VARCHAR(50)
)
AS
BEGIN
--DECLARE @SqlQuery NVARCHAR(MAX) = 'Update GenericFormSubmitted set FormJson = JSON_MODIFY(FormJson, ''$.'+ @FieldValue +''') where DataSourceId = @FormId'
--DECLARE @variable nvarchar(max) = (select CONCAT('$.', @FieldName))
--SELECT @variable
DECLARE @sqll nvarchar(max) = N'Update GenericFormSubmitted set FormJson = JSON_MODIFY(FormJson, ''$.'+ @FieldName +''', @FieldValue) where DataSourceId = @FormId AND DataSetId = @DataSetId'
EXEC sp_executesql @sqll, N'@FieldValue nvarchar(max), @FormId UNIQUEIDENTIFIER, @DataSetId UNIQUEIDENTIFIER', @FieldValue, @FormId, @DataSetId
END
GO
