CREATE PROCEDURE [dbo].[Marker92]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

  MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES 
	(NEWID(), N'Employee over time report', N'This report gives the information about amount of overtime people are doing in the office'
	   , N'SELECT ROW_NUMBER() OVER(ORDER BY TotalTimeInHr DESC) AS [RowNumber],UserName AS [Name],TotalTimeInHr,[Month],UserId,[MonthEnd]
		FROM
		(
			SELECT UM.Id AS UserId
			,UM.FirstName + CONCAT('' '',UM.SurName) As UserName
			 ,ROUND(SUM(SpentTime * 1.0 /60.0),0) AS TotalTimeInHr
			  ,DATENAME(MONTH,UAT.CreatedDateTime) + '' - '' + DATENAME(YEAR,UAT.CreatedDateTime) AS [Month]
			  ,EOMONTH(UAT.CreatedDateTime) AS [MonthEnd]
			  FROM [User] AS UM
			  	  INNER JOIN (SELECT UserId,SpentTime - 480 AS SpentTime,CreatedDateTime
				              FROM(
				                    SELECT UserId,SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) AS SpentTime,CreatedDateTime
			                        FROM UserActivityTime AS UA 
			                        WHERE UA.CreatedDateTime BETWEEN IIF((SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId'') > ISNULL(@DateFrom,DATEADD(DAY,1,EOMONTH(GETDATE(),-1)))
								                                         ,DATEADD(DAY,1,(SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId''))
								    									 ,ISNULL(@DateFrom,DATEADD(DAY,1,EOMONTH(GETDATE(),-1)))) AND ISNULL(@DateTo,EOMONTH(GETDATE()))
			                              AND UA.InActiveDateTime IS NULL
								    	  AND (''@UserId'' = '''' OR ''@UserId'' = UA.UserId)
									GROUP BY UserId,CreatedDateTime
								 ) T
								WHERE SpentTime > 480
			                  UNION ALL
					          SELECT UserId,SpentTime - 480 AS SpentTime,CreatedDateTime
							  FROM (
							         SELECT UserId,SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) AS SpentTime,CreatedDateTime
					                 FROM UserActivityHistoricalData UAH
					                 WHERE UAH.CreatedDateTime BETWEEN IIF((SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId'') > ISNULL(@DateFrom,DATEADD(DAY,1,EOMONTH(GETDATE(),-1)))
							                                              ,ISNULL(@DateFrom,DATEADD(DAY,1,EOMONTH(GETDATE(),-1))),NULL) 
							         					    AND IIF((SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId'') > ISNULL(@DateFrom,DATEADD(DAY,1,EOMONTH(GETDATE(),-1)))
							                                              ,(SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId''),NULL)
					                       AND UAH.CompanyId = ''@CompanyId''
							         	  AND (''@UserId'' = '''' OR ''@UserId'' = UAH.UserId)
									GROUP BY UserId,CreatedDateTime
								   ) T
								WHERE SpentTime > 480
			                  ) UAT ON UAT.UserId = UM.Id
			   GROUP BY UM.Id
			  ,UM.FirstName + CONCAT('' '',UM.SurName),DATENAME(MONTH,UAT.CreatedDateTime) + '' - '' + DATENAME(YEAR,UAT.CreatedDateTime)
			  ,EOMONTH(UAT.CreatedDateTime)
		) MainQ', @CompanyId, @UserId, CAST(N'2020-08-28T09:39:22.493' AS DateTime), NULL, 0, NULL, 0, NULL, NULL, NULL)
	)
	AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime], [InActiveDateTime], [IsEditable], [ProcName], [IsProc], [SubQueryType], [SubQuery], [Filters])
	ON TARGET.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
   WHEN NOT MATCHED THEN
  INSERT ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime], [InActiveDateTime], [IsEditable], [ProcName], [IsProc], [SubQueryType], [SubQuery], [Filters])
  VALUES  ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime], [InActiveDateTime], [IsEditable], [ProcName], [IsProc], [SubQueryType], [SubQuery], [Filters]);

  MERGE INTO [dbo].[CustomAppDetails] AS Target 
  USING ( VALUES 
   (NEWID(), (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Employee over time report'), 1, N'Overt-Time By Month', N'table', NULL, NULL, NULL, NULL, CAST(N'2020-08-28T09:39:22.493' AS DateTime), @UserId)
   )
  AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName], [VisualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedDateTime], [CreatedByUserId])
  ON Target.[CustomApplicationId] = Source.[CustomApplicationId] AND Target.[VisualizationName] = Source.[VisualizationName] 
  WHEN NOT MATCHED BY TARGET AND Source.CustomApplicationId IS NOT NULL THEN 
  INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName], [VisualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedDateTime], [CreatedByUserId])  
  VALUES  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName], [VisualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedDateTime], [CreatedByUserId]);
	
   MERGE INTO [dbo].[CustomAppColumns] AS Target
   USING ( VALUES
   	(NEWID(), (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Employee over time report'), N'TotalTimeInHr', N'numeric'
   	 , N'SELECT TOP 31 UM.FirstName + CONCAT('' '',UM.SurName) As [Name] 	 ,ROUND((SpentTime * 1.0 /60.0),0) AS TotalTimeInHr 	   
   	     ,CONVERT(VARCHAR,UAT.CreatedDateTime,106) AS [Date] 	   
   	     FROM [User] AS UM 	  	   INNER JOIN (SELECT UserId,SpentTime - 480 AS SpentTime,CreatedDateTime 		              
   		 FROM( 		                     
   		 SELECT UserId,SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) AS SpentTime,CreatedDateTime 	                        
   		 FROM UserActivityTime AS UA  	                        
   		 WHERE UA.CreatedDateTime BETWEEN IIF((SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId'') > DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)) 						                                          
   		 ,DATEADD(DAY,1,(SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId''))  
   		 ,DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1))) AND ''##MonthEnd##'' 	                              
   		 AND UA.InActiveDateTime IS NULL 		 AND (''##UserId##'' = UA.UserId) 							
   		 GROUP BY UserId,CreatedDateTime 						 
   		 ) T 				 
   		 WHERE SpentTime > 480 	                  
   		 UNION ALL 			          
   		 SELECT UserId,SpentTime - 480 AS SpentTime,CreatedDateTime 					 
   		 FROM ( 					         
   		       SELECT UserId,SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) AS SpentTime,CreatedDateTime 		 
   			   FROM UserActivityHistoricalData UAH 			                 
   			   WHERE UAH.CreatedDateTime BETWEEN IIF((SELECT MAX(CreatedDateTime) 
   			   FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId'') > DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)) 	 
   			   ,DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)),NULL)  					         					  
   			   AND IIF((SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId'') > DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)) 
   			   ,(SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId''),NULL) 			                      
   			   AND UAH.CompanyId = ''@CompanyId'' 					         	  
   			   AND (''##UserId##'' = UAH.UserId) 							 
   			   GROUP BY UserId,CreatedDateTime 						   
   			   ) T 						
   			   WHERE SpentTime > 480 	                 
   			   ) UAT ON UAT.UserId = UM.Id ORDER BY UAT.CreatedDateTime'
   	   , (SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery'), @CompanyId, @UserId, CAST(N'2020-08-28T10:26:50.310' AS DateTime), N'38', 1, N'17', 0, NULL)
   	 ,(NEWID(), (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Employee over time report'), N'UserId', N'uniqueidentifier', NULL, NULL
   	   ,@CompanyId, @UserId, CAST(N'2020-08-28T10:26:50.310' AS DateTime), N'0', 0, N'16', 1, NULL)
   	 ,(NEWID(), (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Employee over time report'), N'RowNumber', N'bigint', NULL, NULL
   	   ,@CompanyId, @UserId, CAST(N'2020-08-28T10:26:50.310' AS DateTime), N'19', 1, N'8', 1, NULL)
   	 ,(NEWID(), (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Employee over time report'), N'MonthEnd', N'date', NULL, NULL
   	   ,@CompanyId, @UserId, CAST(N'2020-08-28T10:26:50.310' AS DateTime), N'10', 1, N'3', 1, NULL)
   	 ,(NEWID(), (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Employee over time report'), N'Name', N'nvarchar'
   	    , N'SELECT TOP 31 UM.FirstName + CONCAT('' '',UM.SurName) As [Name] 	 ,ROUND((SpentTime * 1.0 /60.0),0) AS TotalTimeInHr 	   
   	     ,CONVERT(VARCHAR,UAT.CreatedDateTime,106) AS [Date] 	   
   	     FROM [User] AS UM 	  	   INNER JOIN (SELECT UserId,SpentTime - 480 AS SpentTime,CreatedDateTime 		              
   		 FROM( 		                     
   		 SELECT UserId,SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) AS SpentTime,CreatedDateTime 	                        
   		 FROM UserActivityTime AS UA  	                        
   		 WHERE UA.CreatedDateTime BETWEEN IIF((SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId'') > DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)) 						                                          
   		 ,DATEADD(DAY,1,(SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId''))  
   		 ,DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1))) AND ''##MonthEnd##'' 	                              
   		 AND UA.InActiveDateTime IS NULL 		 AND (''##UserId##'' = UA.UserId) 							
   		 GROUP BY UserId,CreatedDateTime 						 
   		 ) T 				 
   		 WHERE SpentTime > 480 	                  
   		 UNION ALL 			          
   		 SELECT UserId,SpentTime - 480 AS SpentTime,CreatedDateTime 					 
   		 FROM ( 					         
   		       SELECT UserId,SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) AS SpentTime,CreatedDateTime 		 
   			   FROM UserActivityHistoricalData UAH 			                 
   			   WHERE UAH.CreatedDateTime BETWEEN IIF((SELECT MAX(CreatedDateTime) 
   			   FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId'') > DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)) 	 
   			   ,DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)),NULL)  					         					  
   			   AND IIF((SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId'') > DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)) 
   			   ,(SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId''),NULL) 			                      
   			   AND UAH.CompanyId = ''@CompanyId'' 					         	  
   			   AND (''##UserId##'' = UAH.UserId) 							 
   			   GROUP BY UserId,CreatedDateTime 						   
   			   ) T 						
   			   WHERE SpentTime > 480 	                 
   			   ) UAT ON UAT.UserId = UM.Id ORDER BY UAT.CreatedDateTime'
   	   , (SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery'), @CompanyId, @UserId, CAST(N'2020-08-28T10:26:50.310' AS DateTime),  N'0', 0, N'1002', 0, NULL)
   	   ,(NEWID(), (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Employee over time report'), N'Month', N'nvarchar'
   	    , N'SELECT TOP 31 UM.FirstName + CONCAT('' '',UM.SurName) As [Name] 	 ,ROUND((SpentTime * 1.0 /60.0),0) AS TotalTimeInHr 	   
   	     ,CONVERT(VARCHAR,UAT.CreatedDateTime,106) AS [Date] 	   
   	     FROM [User] AS UM 	  	   INNER JOIN (SELECT UserId,SpentTime - 480 AS SpentTime,CreatedDateTime 		              
   		 FROM( 		                     
   		 SELECT UserId,SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) AS SpentTime,CreatedDateTime 	                        
   		 FROM UserActivityTime AS UA  	                        
   		 WHERE UA.CreatedDateTime BETWEEN IIF((SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId'') > DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)) 						                                          
   		 ,DATEADD(DAY,1,(SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId''))  
   		 ,DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1))) AND ''##MonthEnd##'' 	                              
   		 AND UA.InActiveDateTime IS NULL 		 AND (''##UserId##'' = UA.UserId) 							
   		 GROUP BY UserId,CreatedDateTime 						 
   		 ) T 				 
   		 WHERE SpentTime > 480 	                  
   		 UNION ALL 			          
   		 SELECT UserId,SpentTime - 480 AS SpentTime,CreatedDateTime 					 
   		 FROM ( 					         
   		       SELECT UserId,SUM(DATEDIFF(MI, ''00:00:00.000'', SpentTime)) AS SpentTime,CreatedDateTime 		 
   			   FROM UserActivityHistoricalData UAH 			                 
   			   WHERE UAH.CreatedDateTime BETWEEN IIF((SELECT MAX(CreatedDateTime) 
   			   FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId'') > DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)) 	 
   			   ,DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)),NULL)  					         					  
   			   AND IIF((SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId'') > DATEADD(DAY,1,EOMONTH(''##MonthEnd##'',-1)) 
   			   ,(SELECT MAX(CreatedDateTime) FROM UserActivityHistoricalData WHERE CompanyId = ''@CompanyId''),NULL) 			                      
   			   AND UAH.CompanyId = ''@CompanyId'' 					         	  
   			   AND (''##UserId##'' = UAH.UserId) 							 
   			   GROUP BY UserId,CreatedDateTime 						   
   			   ) T 						
   			   WHERE SpentTime > 480 	                 
   			   ) UAT ON UAT.UserId = UM.Id ORDER BY UAT.CreatedDateTime'
   	   , (SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery'), @CompanyId, @UserId, CAST(N'2020-08-28T10:26:50.310' AS DateTime),  N'0', 1, N'126', 0, NULL)
   	)
     AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery], [SubQueryTypeId], [CompanyId], [CreatedByUserId], [CreatedDateTime], [Precision], [IsNullable], [MaxLength], [Hidden], [Width])
     ON Target.CustomWidgetId = Source.CustomWidgetId AND Target.ColumnName = Source.ColumnName
     WHEN NOT MATCHED BY TARGET AND SOURCE.[CustomWidgetId] IS NOT NULL    THEN 
     INSERT ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery], [SubQueryTypeId], [CompanyId], [CreatedByUserId], [CreatedDateTime], [Precision], [IsNullable], [MaxLength], [Hidden], [Width])
     VALUES ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery], [SubQueryTypeId], [CompanyId], [CreatedByUserId], [CreatedDateTime], [Precision], [IsNullable], [MaxLength], [Hidden], [Width]);

END
GO