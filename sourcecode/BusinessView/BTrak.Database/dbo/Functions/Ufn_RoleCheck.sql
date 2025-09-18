CREATE FUNCTION Ufn_RoleCheck
(
    @RolesString NVARCHAR(MAX),
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN

  DECLARE @ParsedRoleId TABLE
  (
      Id UNIQUEIDENTIFIER
  )

  DECLARE @separator NCHAR(1)
  SET @separator=','
  DECLARE @position INT
  SET @position = 1
  SET @RolesString = @RolesString + @separator
  WHILE CHARINDEX(@separator,@RolesString,@position) <> 0
  BEGIN
     INSERT INTO @ParsedRoleId
     SELECT CONVERT(UNIQUEIDENTIFIER,SUBSTRING(@RolesString, @position, CHARINDEX(@separator,@RolesString,@position) - @position))
     SET @position = CHARINDEX(@separator,@RolesString,@position) + 1
  END

  DECLARE @Output BIT = CASE WHEN EXISTS(
  SELECT 1
  FROM @ParsedRoleId PR
       INNER JOIN UserRole UR ON UR.RoleId = PR.Id
   WHERE UR.UserId = @OperationsPerformedBy AND UR.InactiveDateTime IS NULL) THEN 1 ELSE 0 END

RETURN @Output
END
GO