CREATE FUNCTION [dbo].[Ufn_ToString]
(
	@Xml XML,
	@Seperator NVARCHAR(15)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @StuffedString NVARCHAR(MAX) = (SELECT STUFF(( SELECT @Seperator + x.y.value('(text())[1]', 'nvarchar(MAX)')
						   FROM @Xml.nodes('row') AS x(y) FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,LEN(@Seperator),''))

	RETURN @StuffedString
END
