--EXEC [USP_GetFormRecordValues] @OperationsPerformedBy = '62722219-FE37-4B8E-B9FD-B70B05FEE17C',@KeyName = 'branch',@KeyValue = 'ANA - India',
--@FieldNames =  N'<?xml version="1.0" encoding="utf-16"?><ArrayOfFormsMiniModel xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--<FormsMiniModel><FormName>Total Sales</FormName><KeyName>dateTime2</KeyName></FormsMiniModel><FormsMiniModel><FormName>Test Form</FormName><KeyName>Key2</KeyName></FormsMiniModel>
--</ArrayOfFormsMiniModel>',@PageSize = 100

CREATE PROCEDURE [dbo].[USP_GetFormRecordValues]
(
	@FormId UNIQUEIDENTIFIER = NULL,
	@CustomApplicationId UNIQUEIDENTIFIER = NULL,
	@KeyName NVARCHAR(250) = NULL,
	@KeyValue NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER ,
	@CustomApplicationName NVARCHAR(250) = NULL,
	@FormName NVARCHAR(250) = NULL,
	@PageSize INT = 1,
	@FormsXML XML = NULL,
	@FieldNames XML = NULL,
	@IsForRq BIT = NULL 
 )
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

			IF(@CustomApplicationName = '') SET @CustomApplicationName = NULL

			IF(@FormName = '') SET @FormName = NULL

			if(@PageSize IS NULL)SET @PageSize = 1
			
		    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
		    IF(@KeyName IS NOT NULL) SET @KeyName = '$.' + @KeyName

SELECT [Table].[Column].value('FormName[1]', 'nvarchar(Max)') FormName,
				                            [Table].[Column].value('Jsons[1]', 'nvarchar(Max)')FormJson,
				                            CAST([Table].[Column].value('CreatedAt[1]', 'nvarchar(Max)') AS DATE) CreatedAt
											INTO #Forms
                               FROM @FormsXML.nodes('/ArrayOfFormsMiniModel/FormsMiniModel') AS [Table]([Column])

   SELECT T.FormName, 'JSON_VALUE(GFS.FormJson, ''$.' +ISNULL(T.FieldName,'')+''') '+' AS ['+ISNULL(T.FieldName,'')+ ']' FieldName ,
   +''''+ISNULL(T.FieldType,'')+''' '+' AS ['+ISNULL(T.FieldName+'-Type','')+ ']' FieldType,
   +''''+ISNULL(T.Format,'')+''' '+' AS ['+ISNULL(T.FieldName+'-Format','')+ ']' Format,
   +''''+ISNULL(T.Delimiter,'')+''' '+' AS ['+ISNULL(T.FieldName+'-Delimiter','')+ ']' Delimiter,
   +''''+ISNULL(T.RequireDecimal,'')+''' '+' AS ['+ISNULL(T.FieldName+'-RequireDecimal','')+ ']' RequireDecimal,
   +''''+ISNULL(T.DecimalLimit,'')+''' '+' AS ['+ISNULL(T.FieldName+'-DecimalLimit','')+ ']' DecimalLimit
			     INTO #Fields  FROM(SELECT  [Table].[Column].value('KeyName[1]', 'nvarchar(Max)') FieldName,
				                            [Table].[Column].value('KeyType[1]', 'nvarchar(Max)')FieldType,
				                            [Table].[Column].value('FormName[1]', 'nvarchar(Max)') FormName,
											[Table].[Column].value('Format[1]', 'nvarchar(Max)') Format,
											[Table].[Column].value('Delimiter[1]', 'nvarchar(Max)') Delimiter,
											[Table].[Column].value('RequireDecimal[1]', 'nvarchar(Max)') RequireDecimal,
											[Table].[Column].value('DecimalLimit[1]', 'nvarchar(Max)') DecimalLimit
                               FROM @FieldNames.nodes('/ArrayOfFormsMiniModel/FormsMiniModel') AS [Table]([Column]))T

			 SELECT Stuff((SELECT ',' + F1.FieldName  FROM #Fields F1 WHERE F1.FormName = F.FormName
                            FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'')List_Out ,
							+ ' ,' +Stuff((SELECT ',' + F1.FieldType  FROM #Fields F1 WHERE F1.FormName = F.FormName
                            FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'')FieldTypes,
							+ ' ,' +Stuff((SELECT ',' + F1.Format  FROM #Fields F1 WHERE F1.FormName = F.FormName
                            FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'')Formats,
							+ ' ,' +Stuff((SELECT ',' + F1.Delimiter  FROM #Fields F1 WHERE F1.FormName = F.FormName
                            FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'')Delimiters,
							+ ' ,' +Stuff((SELECT ',' + F1.RequireDecimal  FROM #Fields F1 WHERE F1.FormName = F.FormName
                            FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'')RequireDecimals,
							+ ' ,' +Stuff((SELECT ',' + F1.DecimalLimit  FROM #Fields F1 WHERE F1.FormName = F.FormName
                            FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'')DecimalLimits,
							F.FormName INTO #Script
							FROM (SELECT FormName FROM #Fields GROUP BY FormName) F

		    
UPDATE #Forms SET FormJson = CASE WHEN JSON_VALUE(FormJson, '$.commodity2') IS NOT  NULL THEN   JSON_MODIFY(FormJson, '$.commodity2', CASE WHEN  EXISTS(SELECT TOP 1 Name 
FROM MasterProduct WHERE CAST(Id AS nvarchar(100)) = JSON_VALUE(FormJson, '$.commodity2'))  THEN (SELECT TOP 1 Name 
FROM MasterProduct WHERE CAST(Id AS nvarchar(100)) = JSON_VALUE(FormJson, '$.commodity2')) ELSE JSON_VALUE(FormJson, '$.commodity2')  END )  
             
WHEN  JSON_VALUE(FormJson, '$.commodityName') IS NOT  NULL    THEN   JSON_MODIFY(FormJson, '$.commodityName', CASE WHEN  EXISTS(SELECT TOP 1 Name 
    FROM MasterProduct WHERE CAST(Id AS nvarchar(100)) = JSON_VALUE(FormJson, '$.commodityName'))  THEN (SELECT TOP 1 Name 
    FROM MasterProduct WHERE CAST(Id AS nvarchar(100)) = JSON_VALUE(FormJson, '$.commodityName')) ELSE JSON_VALUE(FormJson, '$.commodityName')  END ) 

  ELSE FormJson END 

			       DECLARE @SqlQuery NVARCHAR(MAX) = ''
 
							 SET @SqlQuery =  ( SELECT 'SELECT '+ STUFF((SELECT ', [' +FormName+'] = (SELECT (SELECT '+ IIF(@IsForRq = 1, 'ALL', ' TOP '+CAST(@PageSize AS NVARCHAR(100))) +'  ' + List_Out+ ISNULL(FieldTypes,'')+ ' ' + ISNULL(Formats,'')+' ' + ISNULL(Delimiters,'')+' ' + ISNULL(RequireDecimals,'')+' ' + ISNULL(DecimalLimits,'')+'  ,
							 ROW_NUMBER() OVER(ORDER BY CreatedAt DESC)RowNo
							 FROM #Forms GFS
							 
                              WHERE  GFS.FormName = '''+FormName+''' AND JSON_VALUE(GFS.FormJson, ''' +@KeyName +''') = '''+@KeyValue+'''
                              FOR JSON PATH))' FROM #Script
                             				   GROUP BY List_Out,FormName,ISNULL(FieldTypes,''),ISNULL(Formats,''),
											   ISNULL(Delimiters,''),ISNULL(RequireDecimals,''),ISNULL(DecimalLimits,'')
                                              FOR XML PATH(''), TYPE)
                                             .value('.','NVARCHAR(MAX)'),1,2,' ') List_Output ) 
                  
		 SET @SqlQuery = 'SELECT ('+@SqlQuery+' FOR JSON PATH) Text '
		 EXEC SP_EXECUTESQL @SqlQuery
             	      
					
		
DROP TABLE #Fields
DROP TABLE #Forms
DROP TABLE #Script
			 	
     END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END     

