CREATE PROCEDURE [dbo].[USP_IdleTime] (
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @Date DATETIME = NULL
)
AS

IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
DECLARE @HavePermission NVARCHAR(250)  = 1

IF @Date IS NULL SET @Date = GETDATE()

IF(@HavePermission='1')
BEGIN
DECLARE @CompanyId UNIQUEIDENTIFIER = (select CompanyId from [User] where Id= @OperationsPerformedBy)
BEGIN TRY
SELECT CASE WHEN NOT EXISTS(SELECT T.TotalIdleTIme) THEN '0h 0m' ELSE  IIF(T.TotalIdleTIme < 60,
				CAST(T.TotalIdleTIme AS NVARCHAR(50)) + 'm', CAST(CAST(ISNULL(T.TotalIdleTIme,0)/60.0 AS int) AS varchar(100))+'h'+IIF(CAST(ISNULL(T.TotalIdleTIme,0)%60 AS INT) = 0 ,'',CAST(CAST(ISNULL(T.TotalIdleTIme,0)%60 AS INT) AS VARCHAR(100))+'m')) END [IdleTime] 
                          FROM [User] U 
						  LEFT JOIN (SELECT * FROM [dbo].[Ufn_GetUserIdleTimeForMultipleDates](CONVERT(DATE,@Date),CONVERT(DATE,@Date),@CompanyId)) T ON T.[UserId] = U.Id  AND T.TrackedDateTime = CONVERT(DATE,@Date)
                           where U.Id = @OperationsPerformedBy

END TRY
BEGIN CATCH
THROW
END CATCH
END 
