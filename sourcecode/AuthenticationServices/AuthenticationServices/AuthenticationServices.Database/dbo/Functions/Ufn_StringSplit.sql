CREATE FUNCTION [dbo].[Ufn_StringSplit]
(
    @String NVARCHAR(MAX),
    @Seperator NVARCHAR(10)
)
RETURNS @ParsedString TABLE
(
    [Value] NVARCHAR(MAX)
)
AS
BEGIN

  DECLARE @separator NCHAR(1)
  SET @separator = @Seperator
  DECLARE @position INT
  SET @position = 1
  SET @string = @string + @separator
  WHILE CHARINDEX(@separator,@string,@position) <> 0
  BEGIN

     INSERT INTO @ParsedString([Value])
     SELECT SUBSTRING(@string, @position, CHARINDEX(@separator,@string,@position) - @position)
     SET @position = CHARINDEX(@separator,@string,@position) + 1

  END

RETURN

END
GO