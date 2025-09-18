CREATE PROCEDURE [dbo].[Marker118]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 


 MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
 (NEWID(),'Company level productivity','SELECT  TOP 100 PERCENT ROW_NUMBER() OVER(ORDER BY MonthDate ASC) Id, FORMAT(Zouter.DateFrom,''MMM-yy'') Month, SUM(ROuter.EstimatedTime) Productivity,MonthDate FROM
 (SELECT cast(DATEADD(MONTH, DATEDIFF(MONTH, 0, T.[Date]), 0) as date) DateFrom,
        cast(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, T.[Date]) + 1, 0)) as date) DateTo
     ,cast(DATEADD(s,0,DATEADD(mm, DATEDIFF(m,0,[Date]),0)) as date) MonthDate
      FROM
 (SELECT   CAST(DATEADD( MONTH,-(number-1),GETDATE()) AS date) [Date]
 FROM master..spt_values
 WHERE Type = ''P'' and number between 1 and 12
  )T)Zouter CROSS APPLY [Ufn_ProductivityIndexBasedOnuserId](Zouter.DateFrom,Zouter.DateTo,Null,''@CompanyId'' )ROuter 
  INNER JOIN UserStory US ON US.Id = ROuter.UserStoryId AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
  GROUP BY Zouter.DateFrom,Zouter.DateTo,MonthDate 
  ORDER BY [MonthDate] ASC',@CompanyId)
 )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];
		

END




    