CREATE FUNCTION [dbo].[Ufn_GetStatusConfigurationAssignedNames]
(
    @string NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @Names NVARCHAR(MAX) = ''
  DECLARE @separator NCHAR(1)
  SET @separator=','
  DECLARE @position INT
  SET @position = 1
  SET @string = @string + @separator
  WHILE CHARINDEX(@separator,@string,@position) <> 0
  BEGIN
     SET @Names = @Names + @separator + (SELECT U.[FirstName] FROM [User] U WHERE U.Id = (SELECT SUBSTRING(@string, @position, CHARINDEX(@separator,@string,@position) - @position) AS Id))
     SET @position = CHARINDEX(@separator,@string,@position) + 1
  END
RETURN SUBSTRING(@Names, 2, 0+0x7fffffff) 
END
GO