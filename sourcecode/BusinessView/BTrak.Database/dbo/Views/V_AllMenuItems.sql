CREATE VIEW [dbo].[V_AllMenuItems] AS 
WITH RCTE AS
(
    SELECT MI.[Id],
	   MC.[Name] AS [MenuCategory], 
	   ISNULL((CAST([MI].OrderNumber AS NVARCHAR(100)) + '_' + CAST([MI].OrderNumber AS NVARCHAR(100))), CAST([MI].OrderNumber AS NVARCHAR(100)) + '_0') AS ProcessedOrderNumber, 
	   MI.[Name] AS [ParentMenu], 
	   MI.[Name] [Menu], 
	   MI.[Type], 
	   MI.[ToolTip], 
	  convert(varchar(max), MI.[State]) [State],
	   MI.Icon,
	   MI.ParentMenuItemId,
	   MI.OrderNumber
FROM [dbo].[MenuItem] MI 
	 INNER JOIN [dbo].[MenuCategory] MC ON MI.MenuCategoryId = MC.Id WHERE ParentMenuItemId IS NULL

    UNION ALL

   SELECT p.[Id],
	   MC.[Name] AS [MenuCategory], 
	   ISNULL((CAST(p.OrderNumber AS NVARCHAR(100)) + '_' + CAST(p.OrderNumber AS NVARCHAR(100))), CAST(p.OrderNumber AS NVARCHAR(100)) + '_0') AS ProcessedOrderNumber, 
	   p.[Name] AS [ParentMenu], 
	   p.[Name] [Menu], 
	   p.[Type], 
	   p.[ToolTip], 
	   [State] = convert(varchar(max), c.[State]) +'/'+ convert(varchar(max),p.[State]),
	   p.Icon,
	   p.ParentMenuItemId,
	   p.OrderNumber
FROM [dbo].[MenuItem] p 
	 INNER JOIN [dbo].[MenuCategory] MC ON p.MenuCategoryId = MC.Id 
     INNER JOIN RCTE c ON c.Id = p.ParentMenuItemId 
)
select  * from RCTE

--SELECT [MenuCategory], ProcessedOrderNumber, [ParentMenu], [Menu], [Type], [ToolTip], [State]
--FROM [dbo].[V_AllMenuItems]
--ORDER BY MenuCategory ASC, ProcessedOrderNumber ASC, ParentMenu ASC, Menu ASC
GO