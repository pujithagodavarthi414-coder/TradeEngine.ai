CREATE PROCEDURE[dbo].[Marker175]
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
(NEWID(),'Company level productivity','SELECT  TOP 100 PERCENT ROW_NUMBER() OVER(ORDER BY MonthDate ASC) Id, 
	FORMAT(Zouter.DateFrom,''MMM-yy'') Month, SUM(ROuter.EstimatedTime) Productivity,MonthDate 
	FROM   (SELECT cast(DATEADD(MONTH, DATEDIFF(MONTH, 0, T.[Date]), 0) as date) DateFrom,     
	cast(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, T.[Date]) + 1, 0)) as date) DateTo      
	,cast(DATEADD(s,0,DATEADD(mm, DATEDIFF(m,0,[Date]),0)) as date) MonthDate        
	FROM   (SELECT   CAST(DATEADD( MONTH,-(number-1),GETDATE()) AS date) [Date]  
	FROM master..spt_values   WHERE Type = ''P'' and number between 1 and 12    )T)Zouter 
	CROSS APPLY (SELECT ProductivityIndex AS EstimatedTime,ProjectId 
	             FROM [ProductivityIndex] 
	             WHERE [Date] BETWEEN Zouter.DateFrom AND Zouter.DateTo 
				       AND [CompanyId] = ''@CompanyId''
			    ) ROuter
	WHERE (''@ProjectId'' = '''' OR ROuter.ProjectId = ''@ProjectId'')    
	GROUP BY Zouter.DateFrom,Zouter.DateTo,MonthDate     ORDER BY [MonthDate] ASC',@CompanyId)
,(NEWID(),'Productivity Indexes by project for this month'
,'SELECT P.ProjectName,P.Id , ISNULL(SUM(ISNULL(PID.ProductivityIndex,0)),0)[Productiviy Index by project]      
  FROM [ProductivityIndex] PID
  INNER JOIN Project P ON P.Id = PID.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')  
  AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)      
  WHERE P.CompanyId = ''@CompanyId''          
  AND PID.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
  AND ((''@IsReportingOnly'' = 1 AND PID.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]  
  (''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))                            
  OR (''@IsMyself''= 1 AND PID.UserId = ''@OperationsPerformedBy'' )                            
  OR (''@IsAll'' = 1))                        
  GROUP BY ProjectName,P.Id',@CompanyId)
,(NEWID(),'This week productivity'
,'SELECT ISNULL(T.[This week productivity],0)[This week productivity] 
   FROM (SELECT SUM(Z.ProductivityIndex) [This week productivity]    
   FROM [ProductivityIndex] Z
   WHERE Z.CompanyId = ''@CompanyId''
         AND Z.[Date] BETWEEN DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), DATEADD(dd, -(DATEPART(DW, GETDATE())-1), CAST(GETDATE() AS DATE))) AND EOMONTH(GETDATE())
   AND (''@ProjectId'' = '''' OR Z.ProjectId = ''@ProjectId''))T',@CompanyId)
,(NEWID(),'Productivity indexes for this month'
,'SELECT T.Id,T.[Employee name]
   ,CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0
   ,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time] ,T.Productivity 
   FROM   
   	(SELECT U.Id, U.FirstName+'' ''+U.SurName [Employee name]
   	,ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) 
   	         FROM UserStorySpentTime UST   INNER JOIN UserStory US ON US.Id = UST.UserStoryId  
   	         AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
   	         WHERE UST.CreatedByUserId = U.Id AND FORMAT(UST.CreatedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy''))
   	       ,0)  [Spent time],  
   	ISNULL(SUM(Zinner.ProductivityIndex),0)Productivity       
   	FROM [User]U LEFT JOIN [ProductivityIndex] Zinner ON U.Id = Zinner.UserId 
   	AND U.InActiveDateTime IS NULL             
   	WHERE U.CompanyId = ''@CompanyId''
    AND Zinner.[Date] BETWEEN CONVERT(DATE,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) 
                         AND DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)) 
   	AND U.InActiveDateTime IS NULL      
   	AND ((''@IsReportingOnly'' = 1
   	AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers] (''@OperationsPerformedBy'',''@CompanyId'')
   	             WHERE ChildId <>  ''@OperationsPerformedBy''))
   	      OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )           
   		  OR (''@IsAll'' = 1))           
   	GROUP BY U.FirstName,U.SurName,U.Id)T',@CompanyId)
,(NEWID(),'Spent time VS productive time'
,'SELECT T.Id,T.[Employee name]
           ,CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0
		   ,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time]
		   ,T.Productivity 
  FROM   (SELECT U.FirstName+'' ''+U.SurName [Employee name],U.Id,          
  ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) 
  FROM UserStorySpentTime UST 
  INNER JOIN UserStory US ON US.Id = UST.UserStoryId  AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')    
  WHERE UST.CreatedByUserId = U.Id 
  AND (FORMAT(DateFrom,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 
  AND FORMAT(DateTo,''MM-yy'') = FORMAT(GETDATE(),''MM-yy''))),0)  [Spent time],
  ISNULL(SUM(Zinner.Productivity),0)Productivity        
  FROM [User]U 
  LEFT JOIN (SELECT Cast(ISNULL(SUM(ISNULL(Z.ProductivityIndex,0)),0) as int) 
                    Productivity,UserId 
			 FROM [ProductivityIndex] Z 
	WHERE  Z.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
	 AND (''@ProjectId'' = '''' OR Z.ProjectId = ''@ProjectId'')
	 AND Z.CompanyId = ''@CompanyId''
	GROUP BY UserId)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL 
	WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	AND InActiveDateTime IS NULL) AND U.InActiveDateTime IS NULL              
	AND ((''@IsReportingOnly'' = 1 
	AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'')
	WHERE ChildId <>  ''@OperationsPerformedBy''))           
	     OR (''@IsMyself''= 1 AND U.Id = ''@OperationsPerformedBy'' )      
		 OR (''@IsAll'' = 1))      
	GROUP BY U.FirstName,U.SurName,U.Id)T',@CompanyId)
,(NEWID(),'Productivity of this month'
,'SELECT ISNULL(SUM(Z.ProductivityIndex),0) Productivity 
  FROM dbo.[ProductivityIndex] Z 
  WHERE Z.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
        AND Z.CompanyId = ''@CompanyId''
        AND (''@ProjectId'' = '''' OR Z.ProjectId = ''@ProjectId'')',@CompanyId)
,(NEWID(),'This month company productivity'
,'SELECT Cast(ISNULL(SUM(ISNULL(Z.ProductivityIndex,0)),0) as int) [ This month company productivity ]    
 FROM dbo.[ProductivityIndex] Z 
  WHERE Z.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
        AND Z.CompanyId = ''@CompanyId''
        AND (''@ProjectId'' = '''' OR Z.ProjectId = ''@ProjectId'')',@CompanyId)
,(NEWID(),'Company productivity'
,'SELECT Cast(ISNULL(SUM(ISNULL(Z.ProductivityIndex,0)),0) as int) [ This month company productivity ]    
 FROM dbo.[ProductivityIndex] Z 
  WHERE Z.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
        AND Z.CompanyId = ''@CompanyId''
        AND (''@ProjectId'' = '''' OR Z.ProjectId = ''@ProjectId'')',@CompanyId)
,(NEWID(),'Goal wise spent time VS productive hrs list'
,'SELECT Cast(ISNULL(SUM(ISNULL(Z.ProductivityIndex,0)),0) as int) [ This month company productivity ]    
 FROM dbo.[ProductivityIndex] Z 
  WHERE Z.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
        AND Z.CompanyId = ''@CompanyId''
        AND (''@ProjectId'' = '''' OR Z.ProjectId = ''@ProjectId'')',@CompanyId)
,(NEWID(),'Branch wise monthly productivity report'
,'SELECT B.Id, B.BranchName,ISNULL(T.BranchProductivity,0) [Branch productivity] 
FROM [Branch]B 
LEFT JOIN (SELECT B.Id BranchId, B.BranchName,SUM(PID.ProductivityIndex) BranchProductivity 
FROM  (SELECT PIN.UserId,SUM(ISNULL(PIN.ProductivityIndex,0)) ProductivityIndex 
	              FROM ProductivityIndex PIN
				  WHERE PIN.CompanyId = ''@CompanyId''
						AND (''@ProjectId'' = '''' OR PIN.ProjectId = ''@ProjectId'') 
				        AND PIN.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
				  GROUP BY UserId) PID
		INNER JOIN Employee E ON E.UserId = PID.UserId AND E.InActiveDateTime IS NULL
		INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
		    AND EB.[ActiveFrom] <= GETDATE() AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
		INNER JOIN Branch B ON B.Id = EB.BranchId AND B.InActiveDateTime IS NULL
GROUP BY BranchName,B.Id)T ON B.Id = T.BranchId        
WHERE B.CompanyId = ''@CompanyId''     
GROUP BY B.BranchName,BranchProductivity,B.Id',@CompanyId)
)
AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
WHEN MATCHED THEN
UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
		   	[CompanyId] =  SOURCE.CompanyId,
            [WidgetQuery] = SOURCE.[WidgetQuery];

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Company level productivity')
        ,'Productivity'
        ,' SELECT * FROM   (
	 SELECT ProjectName,ISNULL(SUM(PID.ProductivityIndex),0)Productivity     
	 FROM dbo.[ProductivityIndex] PID
	 INNER JOIN Project P ON P.Id = PID.ProjectId 
	 WHERE PID.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(''##MonthDate##'',-1)) AND EOMONTH(''##MonthDate##'')
	       AND PID.[CompanyId] = ''@CompanyId''
	 AND (''@ProjectId'' = '''' OR PID.ProjectId = ''@ProjectId'')
	 group by ProjectName)t',@CompanyId)
	 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Company level productivity')
        ,'Month'
        ,' SELECT * FROM   (
	 SELECT ProjectName,ISNULL(SUM(PID.ProductivityIndex),0)Productivity     
	 FROM dbo.[ProductivityIndex] PID
	 INNER JOIN Project P ON P.Id = PID.ProjectId 
	 WHERE PID.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(''##MonthDate##'',-1)) AND EOMONTH(''##MonthDate##'')
	       AND PID.[CompanyId] = ''@CompanyId''
	group by ProjectName)t',@CompanyId)
   ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Productivity Indexes by project for this month')
        ,'ProjectName'
        ,'SELECT US.Id,US.UserStoryName 
  FROM dbo.[ProductivityIndex] PID   
  INNER JOIN UserStory US ON US.Id = PID.UserStoryId          
  INNER JOIN Project P ON P.Id = US.ProjectId 
  AND P.InActiveDateTime IS NULL         
  WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  
  AND P.Id = ''##Id##''           
  AND ((''@IsReportingOnly'' = 1 
        AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'')
		WHERE ChildId <>  ''@OperationsPerformedBy''))               
	  OR (''@IsMyself''= 1 AND US.OwnerUserId = ''@OperationsPerformedBy'' )        
	  OR (''@IsAll'' = 1))',@CompanyId)
  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Productivity Indexes by project for this month')
        ,'Productiviy Index by project'
        ,'SELECT US.Id,US.UserStoryName 
  FROM dbo.[ProductivityIndex] PID   
  INNER JOIN UserStory US ON US.Id = PID.UserStoryId          
  INNER JOIN Project P ON P.Id = US.ProjectId 
  AND P.InActiveDateTime IS NULL         
  WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  
  AND P.Id = ''##Id##''           
  AND ((''@IsReportingOnly'' = 1 
        AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'')
		WHERE ChildId <>  ''@OperationsPerformedBy''))               
	  OR (''@IsMyself''= 1 AND US.OwnerUserId = ''@OperationsPerformedBy'' )        
	  OR (''@IsAll'' = 1))',@CompanyId)

  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'This week productivity')
        ,'This week productivity'
        ,' SELECT * 
   FROM   (SELECT ProjectName,ISNULL(SUM(Z.ProductivityIndex),0)Productivity    
   FROM [ProductivityIndex] Z
   INNER JOIN Project P ON P.Id = Z.ProjectId            
   WHERE Z.CompanyId = ''@CompanyId''
         AND Z.[Date] BETWEEN DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), DATEADD(dd, -(DATEPART(DW, GETDATE())-1), CAST(GETDATE() AS DATE))) 
		                      AND EOMONTH(GETDATE())
   AND   (''@ProjectId'' = '''' OR Z.ProjectId = ''@ProjectId'')          
   group by ProjectName    )T',@CompanyId)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Productivity indexes for this month')
        ,'Productivity'
        ,' SELECT PID.UserStoryId 
           FROM dbo.[ProductivityIndex] PID 
           WHERE PID.UserId = ''##Id##''
                 AND PID.UserStoryId IS NOT NULL
                 AND PID.CompanyId = ''@CompanyId''
                 AND PID.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
                 AND (''@ProjectId'' = '''' OR PID.ProjectId = ''@ProjectId'')',@CompanyId)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Spent time VS productive time')
        ,'Productivity'
        ,'  SELECT US.Id,US.UserStoryName 
            FROM dbo.[ProductivityIndex] PID 
                INNER JOIN UserStory US ON US.Id = PID.UserStoryId          
            WHERE PID.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
            AND  (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
            AND PID.UserId = ''##Id##''
            AND PID.CompanyId = ''@CompanyId''',@CompanyId)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Productivity of this month')
        ,'Productivity'
        ,'SELECT Z.UserStoryId AS Id
  FROM dbo.[ProductivityIndex] Z 
  WHERE Z.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
        AND Z.UserStoryId IS NOT NULL
        AND Z.CompanyId = ''@CompanyId''
        AND (''@ProjectId'' = '''' OR Z.ProjectId = ''@ProjectId'')',@CompanyId)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'This month company productivity')
        ,' This month company productivity '
        ,'SELECT * 
  FROM (SELECT ProjectName,ISNULL(SUM(Z.ProductivityIndex),0)Productivity     
         FROM dbo.[ProductivityIndex] Z 
		      INNER JOIN Project P ON P.Id = Z.ProjectId 
        WHERE Z.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
             AND Z.CompanyId = ''@CompanyId''
		     AND   (''@ProjectId'' = '''' OR Z.ProjectId = ''@ProjectId'') 
 group by ProjectName)T',@CompanyId)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Company productivity')
        ,' This month company productivity '
        ,'SELECT * 
  FROM (SELECT ProjectName,ISNULL(SUM(Z.ProductivityIndex),0)Productivity     
         FROM dbo.[ProductivityIndex] Z 
		      INNER JOIN Project P ON P.Id = Z.ProjectId 
        WHERE Z.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
             AND Z.CompanyId = ''@CompanyId''
		     AND   (''@ProjectId'' = '''' OR Z.ProjectId = ''@ProjectId'') 
 group by ProjectName)T',@CompanyId)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Branch wise monthly productivity report')
        ,'BranchName'
        ,'SELECT P.ProjectName, SUM(ISNULL(PID.ProductivityIndex,0)) Productivit
            FROM
             (SELECT PIN.UserId,SUM(ISNULL(PIN.ProductivityIndex,0)) ProductivityIndex,ProjectId 
            	              FROM ProductivityIndex PIN
            				  WHERE PIN.CompanyId = ''@CompanyId''
            						AND (''@ProjectId'' = '''' OR PIN.ProjectId = ''@ProjectId'') 
            				        AND PIN.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
            				  GROUP BY UserId,ProjectId) PID
            		INNER JOIN Project P ON P.Id = PID.ProjectId  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
            		INNER JOIN Employee E ON E.UserId = PID.UserId AND E.InActiveDateTime IS NULL
            		INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
            		    AND EB.[ActiveFrom] <= GETDATE() AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
            WHERE P.CompanyId = ''@CompanyId'' 
            AND EB.BranchId = ''##Id##''        
            GROUP BY P.ProjectName ',@CompanyId)
)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName],[SubQuery],[CompanyId])
  ON Target.[CustomWidgetId] = Source.[CustomWidgetId] 
      AND Target.CompanyId = Source.CompanyId 
	  AND Target.[ColumnName] = Source.[ColumnName]
  WHEN MATCHED THEN
  UPDATE SET  [SubQuery]  = SOURCE.[SubQuery],
              [CompanyId]   = SOURCE.[CompanyId];

END
GO