CREATE PROCEDURE [dbo].[USP_GetTimeSheet]
	 @UserId uniqueidentifier,
	 @Date DateTime
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT * FROM TimeSheet WITH (NOLOCK)
	WHERE UserId = @UserId AND [Date] = @Date 
 
END