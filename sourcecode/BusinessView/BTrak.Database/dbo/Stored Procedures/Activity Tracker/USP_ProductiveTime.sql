--EXEC USP_ProductiveTime @OperationsPerformedBy = '239A3A2B-50D1-41B9-97C6-0FA534933942'


CREATE PROCEDURE [dbo].[USP_ProductiveTime](
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
	SELECT IIF(T.TotalTIme < 60,CAST(T.TotalTime AS NVARCHAR(50)) + 'm', CAST(CAST(ISNULL(T.TotalTime,0)/60.0 AS int) AS varchar(100))+'h'+IIF(CAST(ISNULL(T.TotalTime,0)%60 AS INT) = 0 ,'',CAST(CAST(ISNULL(T.TotalTime,0)%60 AS INT) AS VARCHAR(100))+'m')) [ProductiveTime] 
	from [User] UDD 
	LEFT JOIN 
	(SELECT UM.Id AS UserId,UAT.CreatedDateTime AS CreatedDateTime
                        ,FLOOR(Productive * 1.0 / 60000 * 1.0) AS TotalTime
						FROM [User] AS UM
                           INNER JOIN (
                  SELECT UserId,CAST(CreatedDateTime AS date)  CreatedDateTime,SUM(Productive)Productive
                  FROM UserActivityTimeSummary UATS
                  WHERE UATS.CreatedDateTime BETWEEN CONVERT(DATE,@Date) AND CONVERT(DATE,@Date)
                        AND UATS.CompanyId = @CompanyId 
                        GROUP BY UserId,CAST(CreatedDateTime AS date) ) UAT ON UAT.UserId = UM.Id
                        ) T ON UDD.Id = T.UserId WHERE UDD.Id=@OperationsPerformedBy

END TRY
BEGIN CATCH
THROW
END CATCH
END 