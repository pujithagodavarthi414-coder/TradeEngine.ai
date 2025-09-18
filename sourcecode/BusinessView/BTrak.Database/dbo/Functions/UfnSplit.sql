CREATE FUNCTION [dbo].[UfnSplit]
(
    @string NVARCHAR(MAX)
)
RETURNS @ParsedString TABLE
(
    Id NVARCHAR(MAX)
)
AS
BEGIN
  DECLARE @separator NCHAR(1)
  SET @separator=','
  DECLARE @position INT
  SET @position = 1
  SET @string = @string + @separator
  WHILE CHARINDEX(@separator,@string,@position) <> 0
  BEGIN
     INSERT INTO @ParsedString
     SELECT SUBSTRING(@string, @position, CHARINDEX(@separator,@string,@position) - @position)
     SET @position = CHARINDEX(@separator,@string,@position) + 1
  END
RETURN
END