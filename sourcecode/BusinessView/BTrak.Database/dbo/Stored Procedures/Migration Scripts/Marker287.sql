CREATE PROCEDURE [dbo].[Marker287]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

 UPDATE dbo.[CustomAppDetails] SET HeatMapMeasure = '{"legend":[{"legendName":"Working day","value":"0","legendColor":"#13e91e"},{"legendName":"Half day leave","value":"0.5","legendColor":"#da8d17"},{"legendName":"Full  day leave","value":"1","legendColor":"#d82323"}],"cellSize":null,"showDataInCell":null}' where CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Monday Leave Report')
 UPDATE dbo.[CustomAppDetails] SET HeatMapMeasure = '{"legend":[{"legendName":"Working day","value":"0","legendColor":"#13e91e"},{"legendName":"Half day leave","value":"0.5","legendColor":"#da8d17"},{"legendName":"Full  day leave","value":"1","legendColor":"#d82323"}],"cellSize":null,"showDataInCell":null}' where CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Sick Leave Report')

 UPDATE CustomWidgets SET WidgetQuery ='
   SELECT FORMAT(Da.[Date],''dd-MMM-yyyy'') AS Date,ISNULL(P.Productive,0)Productive,ISNULL(P.UnProductive,0)UnProductive,ISNULL(P.Neutral,0)Neutral 
    FROM  (SELECT CONVERT(DATE,DATEADD(DAY,NUMBER+1,DATEADD(DAY,-7,IIF(@Date IS NULL,GETDATE(),@Date)))) AS [Date]     
           FROM Master..SPT_VALUES
           WHERE number < DATEDIFF(DAY,DATEADD(DAY,-7,IIF(@Date IS NULL,GETDATE(),@Date)),IIF(@Date IS NULL,GETDATE(),@Date)) AND [type] = ''p''
    ) Da 
    LEFT JOIN  (SELECT CONVERT(DATE,CreatedDateTime) AS [Date]  ,productive AS Productivemin  
    ,IIF(Productive/60 > 0,CONVERT(DECIMAl(10,2),Productive/60),0) Productive  
    ,IIF(UnProductive/60 > 0,CONVERT(DECIMAl(10,2),UnProductive/60),0) UnProductive 
    ,IIF(Neutral/60 > 0,CONVERT(DECIMAl(10,2),Neutral/60),0) Neutral 
    FROM  (SELECT CreatedDateTime,ApplicationTypeName 
       ,CONVERT(DECIMAL,ISNULL(T.TotalTime,0)) AS TotalTime  
    from (SELECT UM.Id AS UserId,UAT.CreatedDateTime AS CreatedDateTime,ApplicationTypeName  
    ,FLOOR(SUM(( DATEPART(HH, UAT.SpentTime) * 3600000 ) + (DATEPART(MI, UAT.SpentTime) * 60000 )
    + DATEPART(SS, UAT.SpentTime)*1000  + DATEPART(MS, UAT.SpentTime)) * 1.0 / 60000 * 1.0) AS TotalTime
    FROM [User] AS UM                           
    INNER JOIN (SELECT UserId,UA.CreatedDateTime,SpentTime,ApplicationTypeName
    FROM UserActivityTime AS UA              
    JOIN ApplicationType [AT] ON [AT].Id = UA.ApplicationTypeId 
    WHERE UA.CreatedDateTime BETWEEN CONVERT(DATE,DATEADD(DAY,-7,IIF(@Date IS NULL,GETDATE(),@Date))) AND CONVERT(DATE,IIF(@Date IS NULL,GETDATE(),@Date)) 
    AND UA.InActiveDateTime IS NULL                             
    UNION ALL                 
    SELECT UserId,CreatedDateTime,SpentTime,ApplicationTypeName 
    FROM UserActivityHistoricalData UAH                 
    WHERE UAH.CreatedDateTime BETWEEN CONVERT(DATE,DATEADD(DAY,-7,IIF(@Date IS NULL,GETDATE(),@Date))) AND CONVERT(DATE,IIF(@Date IS NULL,GETDATE(),@Date))   
    AND UAH.CompanyId = ''@CompanyId''                                          
    ) UAT ON UAT.UserId = UM.Id                
    GROUP BY UM.Id,UAT.CreatedDateTime,ApplicationTypeName) T WHERE T.UserId=''@OperationsPerformedBy''     
    ) Pvt        PIVOT( SUM([TotalTime])              
    FOR ApplicationTypeName IN ([Neutral],[Productive],[UnProductive]))PivotTab) P ON P.[Date] = Da.[Date]'
 WHERE CompanyId = @CompanyId
 AND Customwidgetname = 'Weekly activity'


END
GO

