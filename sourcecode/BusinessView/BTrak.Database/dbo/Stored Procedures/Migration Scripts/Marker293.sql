CREATE PROCEDURE [dbo].[Marker293]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN

	UPDATE CustomAppDetails SET VisualizationType = 'table' WHERE VisualizationType = 'table' 
	AND CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName IN ('Employees with 0 keystrokes','Employees with keystrokes more than 200') 
	AND CompanyId =  @CompanyId) AND InActiveDateTime IS NULL

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT CONVERT(VARCHAR(5),TimeofUser,114) AS [Time],[Name],FORMAT([Date],''dd MMM yyyy'') AS [Date],KeyStroke AS KeyStrokesCount 
          FROM (
          SELECT UAS.UserId,CONVERT(DATE,TrackedDateTime) AS [Date]
          	   ,KeyStroke
          	   ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name]
          	   ,U.TimeZoneId
          	   ,TrackedDateTime
                 ,DATEADD(MINUTE,ISNULL(TZ.OffsetMinutes,330) ,TrackedDateTime) AS TimeofUser
          FROM UserActivityTrackerStatus UAS
               INNER JOIN [User] U ON U.Id = UAS.UserId
          	 INNER JOIN Employee E ON E.UserId = U.Id
          	 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
          	            AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                 LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId
          WHERE KeyStroke = 0
                AND U.[InActiveDateTime ] IS NULL AND U.IsActive = 1
                AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
                AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
          	    AND ((@DateFrom IS NULL AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,GETDATE())) OR (@DateFrom IS NOT NULL AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,@DateFrom)))
          	    AND ((@DateTo IS NULL AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,GETDATE())) OR (@DateTo  IS NOT NULL AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,@DateTo)))) T'
				WHERE CustomWidgetName = 'Employees with 0 keystrokes' AND CompanyId = @CompanyId
		
				
	UPDATE CustomWidgets SET WidgetQuery = 'SELECT CONVERT(VARCHAR(5),TimeofUser,114) AS [Time],[Name],FORMAT([Date],''dd MMM yyyy'') AS [Date],KeyStroke AS KeyStrokesCount 
           FROM (
           SELECT UAS.UserId,CONVERT(DATE,TrackedDateTime) AS [Date]
           	   ,KeyStroke
           	   ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name]
           	   ,U.TimeZoneId
           	   ,TrackedDateTime
               ,DATEADD(MINUTE,ISNULL(TZ.OffsetMinutes,330) ,TrackedDateTime) AS TimeofUser
           FROM UserActivityTrackerStatus UAS
                INNER JOIN [User] U ON U.Id = UAS.UserId
           	 INNER JOIN Employee E ON E.UserId = U.Id
           	 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
           	            AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                  LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId
           WHERE KeyStroke > 200
                 AND U.[InActiveDateTime ] IS NULL AND U.IsActive = 1
                 AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
                AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
          	    AND ((@DateFrom IS NULL AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,GETDATE())) OR (@DateFrom IS NOT NULL AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,@DateFrom)))
          	    AND ((@DateTo IS NULL AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,GETDATE())) OR (@DateTo  IS NOT NULL AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,@DateTo)))
           ) T'
				WHERE CustomWidgetName = 'Employees with keystrokes more than 200' AND CompanyId = @CompanyId

				
  UPDATE CustomWidgets SET WidgetQuery = 'SELECT T.Id,T.[Goal name],CAST(CAST(T.[Estimated time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time],
	CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time]
	 FROM (SELECT G.Id,GoalName [Goal name],SUM(US.EstimatedTime) [Estimated time],ISNULL(CAST(SUM(UST.SpentTimeInMin/60.0) AS decimal(10,2)),0)[Spent time] 
	                    FROM  UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
									INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND  G.ParkedDateTime IS NULL
						            INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	                                LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
									 AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
	                           								   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
	                           								    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
	                           									OR (''@IsAll'' = 1)) 
								   GROUP BY GoalName,G.Id)T' WHERE CustomWidgetName = 'Goal wise spent time VS productive hrs list' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET WidgetQuery = 'SELECT StatusCount ,StatusCounts
	                          FROM
							  (SELECT CAST((T.[Damaged assets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END *1.0))*100 AS decimal(10,2)) [Damaged assets],
	       CAST(([Unassigned assets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END*1.0))*100 AS decimal(10,2)) [Unassigned assets],
		   CAST(([Assigned assets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END*1.0))*100 AS decimal(10,2)) [Assigned assets] 
	   FROM(SELECT COUNT(CASE WHEN A.IsWriteOff = 1 THEN 1 END )[Damaged assets]
	   ,COUNT(CASE WHEN (A.IsWriteOff = 0 OR A.IsWriteOff IS NULL  ) AND A.IsEmpty = 1 THEN 1 END )[Unassigned assets],
	    COUNT(CASE WHEN AE.AssetId IS NOT NULL AND (A.IsWriteOff = 0 OR A.IsWriteOff IS NULL) AND  ISNULL(A.IsEmpty,0) = 0 THEN 1 END )[Assigned assets],
		COUNT(1) [Total assets]
			 FROM Asset A INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL 
						  INNER JOIN Supplier S ON S.Id = PD.SupplierId AND S.InactiveDateTime IS NULL
			              LEFT JOIN AssetAssignedToEmployee AE ON AE.AssetId = A.Id AND AE.AssignedDateTo IS NULL
	                   WHERE S.CompanyId = ''@CompanyId''
						   )T
		
								) as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN ([Damaged assets],[Unassigned assets],[Assigned assets]) 
	                                    )p' WHERE CustomWidgetName = 'Assigned, UnAssigned, Damaged Assets %' AND CompanyId = @CompanyId

END
GO