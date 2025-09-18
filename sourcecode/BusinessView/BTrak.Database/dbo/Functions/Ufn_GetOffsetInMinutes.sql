CREATE FUNCTION [dbo].[Ufn_GetOffsetInMinutes]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
RETURNS FLOAT
AS
BEGIN
	
	DECLARE @TimeZoneName NVARCHAR(150)

	SELECT @TimeZoneName = TimeZoneName 
	FROM TimeZone
	WHERE Id = (SELECT TimeZoneId FROM [User] WHERE Id = @OperationsPerformedBy)
	
	DECLARE @OffSet NVARCHAR(100) = RIGHT(GETUTCDATE() AT TIME ZONE @TimeZoneName,6)
	DECLARE @OffSetSign NVARCHAR(10) = LEFT(@OffSet,1)
	SELECT @OffSet  = REPLACE(@OffSet,'+','')
	DECLARE @OffSetInMin FLOAT = (LEFT(@OffSet,2) * 60) + RIGHT(@OffSet,2)
	DECLARE @OffSetInMinWithSign FLOAT= CASE WHEN @OffSetSign = '+' THEN @OffSetInMin ELSE -1 * @OffSetInMin END
	SELECT @OffSetInMinWithSign = CASE WHEN @OffSetInMinWithSign IS NULL THEN 0 ELSE @OffSetInMinWithSign END

	RETURN @OffSetInMinWithSign

END
