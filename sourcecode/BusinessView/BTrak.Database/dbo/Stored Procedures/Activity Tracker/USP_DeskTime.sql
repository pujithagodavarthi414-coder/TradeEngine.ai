CREATE PROCEDURE [dbo].[USP_DeskTime]
(
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
    
    SELECT ISNULL((SELECT IIF(Main.SpentTime < 60,CAST(Main.SpentTime AS NVARCHAR(50)) + 'm', CAST(CAST(ISNULL(Main.SpentTime,0)/60.0 AS int) AS varchar(100))+'h'+IIF(CAST(ISNULL(Main.SpentTime,0)%60 AS INT) = 0 ,'',CAST(CAST(ISNULL(Main.SpentTime,0)%60 AS INT) AS VARCHAR(100))+'m')) [Systemusagetime]  
      FROM (
           SELECT FLOOR(SUM(UTS.Neutral + UTS.Productive + UTS.UnProductive) / 60000 * 1.0) AS SpentTime
           FROM [User] AS U WITH (NOLOCK) 
             INNER JOIN TimeSheet AS TS WITH (NOLOCK) ON U.Id = TS.UserId 
                        AND (TS.Date = CONVERT(DATE, @Date))
             INNER JOIN UserActivityTimeSummary UTS ON UTS.UserId = U.Id
                        AND CONVERT(DATE,UTS.CreatedDateTime) = CONVERT(DATE, @Date)
            WHERE U.IsActive = 1
                 AND U.InActiveDateTime IS NULL
                 AND U.Id = @OperationsPerformedBy
                 AND U.CompanyId = @CompanyId
           )Main) ,'0h') [Systemusagetime] 
    
END TRY
BEGIN CATCH
THROW
END CATCH
END 
