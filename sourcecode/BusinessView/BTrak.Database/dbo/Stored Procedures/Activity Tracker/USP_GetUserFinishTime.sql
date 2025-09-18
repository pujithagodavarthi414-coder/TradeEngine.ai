CREATE PROCEDURE [dbo].[USP_GetUserFinishTime](
@OperationsPerformedBy UNIQUEIDENTIFIER,
@Date DATETIME = NULL
)
AS
SET NOCOUNT ON

	DECLARE @HavePermission NVARCHAR(250)  ='1'-- (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) 

	IF @Date IS NULL SET @Date = GETDATE()

	IF(@HavePermission='1')
	BEGIN
	DECLARE @CompanyId UNIQUEIDENTIFIER = (select CompanyId from [User] where Id= @OperationsPerformedBy)
	BEGIN TRY
			SELECT CASE 
				WHEN T.OutTime IS NULL THEN 'Online'
				ELSE CAST(CONVERT(char(5), T.OutTime, 108) AS NVARCHAR) +' '+ TZ.TimeZoneAbbreviation  END[FinishTime]
									from timesheet T 
									LEFT JOIN TimeZone TZ ON TZ.Id = T.OutTimeTimeZone
									where userid=@OperationsPerformedBy and [date] = CONVERT(date,@Date)
	END TRY
	BEGIN CATCH
	THROW
	END CATCH
END 
