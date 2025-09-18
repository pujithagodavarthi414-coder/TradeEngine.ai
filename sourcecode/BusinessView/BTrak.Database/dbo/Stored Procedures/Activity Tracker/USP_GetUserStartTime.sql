CREATE PROCEDURE [dbo].[USP_GetUserStartTime](
@OperationsPerformedBy UNIQUEIDENTIFIER,
@Date DATETIME = NULL
)
AS
SET NOCOUNT ON

DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) 

	IF @Date IS NULL SET @Date = GETDATE()

	IF(@HavePermission='1')
	BEGIN
		DECLARE @CompanyId UNIQUEIDENTIFIER = (select CompanyId from [User] where Id= @OperationsPerformedBy)
		BEGIN TRY
				select CAST(CONVERT(char(5), T.InTime, 108) AS NVARCHAR) +' '+ TZ.TimeZoneAbbreviation[StartTime] from timesheet T 
				INNER JOIN TimeZone TZ ON TZ.Id = T.InTimeTimeZone
				where userid=@OperationsPerformedBy and [date] = CONVERT(date,@Date)
		END TRY
	BEGIN CATCH
	THROW
	END CATCH
END 