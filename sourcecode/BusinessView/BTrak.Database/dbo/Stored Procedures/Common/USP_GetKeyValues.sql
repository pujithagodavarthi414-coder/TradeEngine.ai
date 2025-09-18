CREATE PROCEDURE [USP_GetKeyValues]
(
    @CustomAPplicationId UNIQUEIDENTIFIER,
    @Key NVARCHAR(MAX)
)
AS
BEGIN
    SET @Key = '$' + '.' + ISNULL(NULLIF(@Key,''),'a')
    
    SELECT DISTINCT JSON_VALUE(GFS.FormJson,@Key) AS [Value]
    FROM GenericFormSubmitted GFS 
    WHERE CustomAPplicationId = @CustomAPplicationId
          AND JSON_VALUE(GFS.FormJson,@Key) IS NOT NULL
    
END
GO