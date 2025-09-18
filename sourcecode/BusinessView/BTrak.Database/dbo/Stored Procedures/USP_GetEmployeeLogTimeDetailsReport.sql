--EXEC [USP_GetEmployeeLogTimeDetailsReport] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@DateFrom = '2020-01-13',@DateTo = '2020-01-18'
CREATE PROCEDURE [dbo].[USP_GetEmployeeLogTimeDetailsReport]
(
    @DateFrom DATE,
    @DateTo DATE,
    @UserId UNIQUEIDENTIFIER = NULL,
	@PageSize INT = 20,
    @PageNumber INT = 1,
    @SortBy NVARCHAR(40) = NULL,
    @SortDirection NVARCHAR(40) = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @BoardTypeId UNIQUEIDENTIFIER = NULL,
	@ShowComments BIT = 0, 
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	IF(@SortBy IS NULL)
	BEGIN
	SET @SortBy='UserStoryName'
	END
    DECLARE @ColumnName01 VARCHAR(50)
           , @ColumnName02 VARCHAR(50)
           , @ColumnName03 VARCHAR(50)
		   , @ColumnName04 VARCHAR(50)
		   , @ColumnName05 VARCHAR(50)
		   , @ColumnName06 VARCHAR(50)
		   , @ColumnName07 VARCHAR(50)
		   , @ColumnName08 VARCHAR(50)
		   , @ColumnName09 VARCHAR(50)
		   , @ColumnName10 VARCHAR(50)
		   , @ColumnName11 VARCHAR(50)
    
    SELECT @ColumnName01 = '[UserStoryId]'
          , @ColumnName02 = '[UserStoryName]'
		  , @ColumnName03 = '[OwnerUserId]'
		  , @ColumnName05 = '[ProjectName]'
		  , @ColumnName06 = '[GoalName]'
		  , @ColumnName07 = '[BoardTypeName]'
		  , @ColumnName08 = '[IsProductive]'
		  , @ColumnName09 = '[EstimatedTime]'
		  , @ColumnName10 = '[ProjectId]'
		  , @ColumnName11 = '[GoalId]'
    
    CREATE TABLE #P ( TempColumn INT );
    
    DECLARE @SQL NVARCHAR(MAX)
    DECLARE @Date DATE
    
    SELECT @SQL = 'ALTER TABLE #P ADD ';
    SELECT @SQL += @ColumnName01 + ' UNIQUEIDENTIFIER, ';
    SELECT @SQL += @ColumnName02 + ' NVARCHAR(MAX), ';
    SELECT @SQL += @ColumnName03 + ' UNIQUEIDENTIFIER, ';
	SELECT @SQL += @ColumnName05 + ' NVARCHAR(250), ';
	SELECT @SQL += @ColumnName06 + ' NVARCHAR(250), ';
	SELECT @SQL += @ColumnName07 + ' NVARCHAR(250), ';
	SELECT @SQL += @ColumnName08 + ' NVARCHAR(50), ';
	SELECT @SQL += @ColumnName09 + ' NVARCHAR(50), ';
	SELECT @SQL += @ColumnName10 + ' UNIQUEIDENTIFIER, ';
	SELECT @SQL += @ColumnName11 + ' UNIQUEIDENTIFIER ';
    
    EXEC sys.sp_executesql @SQL;
    
    ALTER TABLE #P DROP COLUMN TempColumn;

    ALTER TABLE #P ADD InactiveDateTime DATETIME,ParkedDateTime DATETIME,GoalInactiveDateTime DATETIME,GoalParkedDateTime DATETIME,ProjectInactiveDateTime DATETIME,SprintName NVARCHAR(MAX),SprintId UNIQUEIDENTIFIER,SprintInactiveDateTime DATETIME
    
    INSERT  INTO #P(UserStoryId,UserStoryName,InActiveDateTime,ParkedDateTime,GoalInactiveDateTime,GoalParkedDateTime,ProjectInactiveDateTime)
    SELECT UserStoryId,'('+ US.UserStoryUniqueName + ')' +' '+ US.UserStoryName,US.InActiveDateTime,US.ParkedDateTime,G.InActiveDateTime,G.ParkedDateTime,P.InActiveDateTime
    FROM UserStorySpentTime UST 
         INNER JOIN UserStory US ON US.Id = UST.UserStoryId
		 INNER JOIN Project P ON P.Id = US.ProjectId
         INNER  JOIN (SELECT ProjectId FROM [UserProject] UP 
		               WHERE UP.UserId = @OperationsPerformedBy 
					      AND UP.InActiveDateTime IS NULL GROUP BY UP.ProjectId) UP ON UP.ProjectId = P.Id
         LEFT JOIN Goal G ON G.ProjectId = P.Id AND G.Id = US.GoalId
         LEFT JOIN Sprints SP ON SP.ProjectId = P.Id AND SP.Id = US.SprintId
		 LEFT JOIN BoardType BT ON (BT.Id = G.BoardTypeId OR BT.Id = Sp.BoardTypeApiId)
	    WHERE P.CompanyId = @CompanyId
	      AND UST.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](ISNULL(@UserId,@OperationsPerformedBy),@CompanyId))
		  AND (@ProjectId IS NULL OR P.Id = @ProjectId)
	      AND (@BoardTypeId IS NULL OR BT.Id = @BoardTypeId)
          AND ((CONVERT(DATE,UST.DateFrom) BETWEEN @DateFrom AND @DateTo AND CONVERT(DATE,UST.DateTo) BETWEEN @DateFrom AND @DateTo) OR
			(CONVERT(DATE,UST.StartTime) BETWEEN @DateFrom AND @DateTo AND CONVERT(DATE,UST.EndTime) BETWEEN @DateFrom AND @DateTo))
       GROUP BY UserStoryId,US.UserStoryName,US.UserStoryUniqueName, US.InActiveDateTime,US.ParkedDateTime,G.InActiveDateTime,G.ParkedDateTime,P.InActiveDateTime
       
    DECLARE @MaxDays INT = DATEDIFF(DAY,@DateFrom,@DateTo) + 1
    DECLARE @DaysCounter INT = 0

	UPDATE #P
	SET OwnerUserId = US.OwnerUserId , ProjectName = PR.ProjectName,GoalName = '('+ G.GoalUniqueName + ')' + ' ' + ISNULL(G.GoalShortName,G.GoalName),
	BoardTypeName = BT.BoardTypeName , IsProductive = (CASE WHEN G.IsProductiveBoard = 1 THEN 'Yes' ELSE 'No' END),
	EstimatedTime = IIF(US.SprintEstimatedTime IS NULL,IIF(FLOOR(ISNULL(US.EstimatedTime,0)) = 0,IIF(CAST((ISNULL(US.EstimatedTime,0) *60)AS int)%60 = 0,'0h',''),CONVERT(NVARCHAR,FLOOR(US.EstimatedTime)) + 'h' )  +' '+ IIF(CAST((ISNULL(US.EstimatedTime,0) *60)AS int)%60 = 0,'',CONVERT(NVARCHAR,CAST((ISNULL(US.EstimatedTime,0) *60)AS int)%60) + 'm'),CONVERT(NVARCHAR(25),US.SprintEstimatedTime) + 'Story points')
    ,ProjectId = PR.Id,GoalId = G.Id
	FROM #P P
	INNER JOIN UserStory US ON US.Id = P.UserStoryId AND (@ProjectId IS NULL OR US.ProjectId = @ProjectId)
	LEFT JOIN Goal G ON G.Id = US.GoalId
	LEFT JOIN Sprints S ON S.Id = US.SprintId
	LEFT JOIN BoardType BT ON (BT.Id = G.BoardTypeId OR BT.Id = S.BoardTypeId)
    INNER JOIN Project PR ON PR.Id = US.ProjectId
	WHERE PR.CompanyId = @CompanyId

    UPDATE #P SET ProjectName = Pr.ProjectName,SprintName = S.SprintName,SprintId = S.Id,BoardTypeName = BT.BoardTypeName,SprintInactiveDatetime = S.InActiveDateTime FROM #P P INNER JOIN UserStory US ON P.UserStoryId = US.Id
                                                      INNER JOIN Sprints S ON S.ProjectId = US.ProjectId AND US.SprintId = S.Id
                                                      INNER JOIN BoardType BT ON BT.Id = S.BoardTypeId
                                                      INNER JOIN Project Pr ON Pr.Id = S.ProjectId AND( Pr.Id = @ProjectId OR @ProjectId IS NULL)

    WHILE @DaysCounter < @MaxDays
    BEGIN
    
        SELECT @Date = DATEADD(DAY,@DaysCounter,@DateFrom)
    
        SELECT @ColumnName04 = '[' + CAST(@Date AS NVARCHAR(25)) + ']'
    
        SELECT @SQL = 'ALTER TABLE #P ADD ';
    
        SELECT @SQL += @ColumnName04 + ' NVARCHAR(MAX) NULL '
    
        EXEC sys.sp_executesql @SQL
    
        SELECT @SQL = 'UPDATE #P SET ' + @ColumnName04 + ' = CASE WHEN SpentTimeInMin IS NOT NULL THEN  SpentTimeInMin END
                    FROM #P P 
                         LEFT JOIN (SELECT UST.UserStoryId, (ISNULL(SUM(SpentTimeInMin)/60,0)) + (ISNULL(
						 ROUND((SUM(DATEDIFF(MINUTE, UST.StartTime, ISNULL(UST.EndTime,GETDATE())))/60.0),2),0)) SpentTimeInMin, US.EstimatedTime 
                                    FROM UserStorySpentTime UST INNER JOIN #P P ON P.UserStoryId = UST.UserStoryId
                                         INNER JOIN UserStory US ON US.Id = UST.UserStoryId
                                    WHERE (@UserId IS NULL OR UST.UserId = @UserId)
									      AND (CONVERT(DATE,UST.DateTo) = @Date OR CONVERT(DATE,UST.EndTime) = @Date)
										 
                                    GROUP BY UST.UserStoryId,US.EstimatedTime) UST ON P.UserStoryId = UST.UserStoryId'
    
        EXEC sys.sp_executesql @SQL,
        N'@UserId UNIQUEIDENTIFIER,
          @Date DATE',
        @UserId,
        @Date
    
        SELECT @SQL = 'UPDATE #P SET ' + @ColumnName04 + ' = CONCAT('+@ColumnName04+',CONCAT(''h |'', SpentTimeInMin,''h''))
                    FROM #P P 
                         LEFT JOIN (SELECT UST.UserStoryId, (ISNULL(SUM(SpentTimeInMin)/60,0)) + (ISNULL(
						 ROUND((SUM(DATEDIFF(MINUTE, UST.StartTime, ISNULL(UST.EndTime,GETDATE())))/60.0),2),0)) SpentTimeInMin
                                    FROM UserStorySpentTime UST INNER JOIN UserStory US ON US.Id = UST.UserStoryId   
                                         INNER JOIN #P P ON P.UserStoryId = UST.UserStoryId 
                                    WHERE (@UserId IS NULL OR UST.UserId = @UserId)
                                          AND (@Date >= CAST( UST.DateTo AS DATE) OR @Date >= CAST( UST.EndTime AS DATE))
                                    GROUP BY UST.UserStoryId) UST ON P.UserStoryId = UST.UserStoryId
        WHERE ' + @ColumnName04 + ' IS NOT NULL'
    
        EXEC sys.sp_executesql @SQL,
        N'@UserId UNIQUEIDENTIFIER,
          @Date DATE',
        @UserId,
        @Date

        SELECT @SQL = 'UPDATE #P SET ' + @ColumnName04 + ' = CASE WHEN (@ShowComments = 1) THEN  (select [dbo].[usp_ClearHTMLTags](CONCAT('+@ColumnName04+',CONCAT('' | Description : '', SpentTimeInMin))))  ELSE CONCAT('+@ColumnName04+','''') END 
                    FROM #P P 
                         LEFT JOIN (SELECT UST.UserStoryId, STUFF((SELECT '', '' + CAST(Comment AS VARCHAR(MAX)) [text()] 
                                                                           FROM UserStorySpentTime 
                                                                           WHERE UserStoryId = UST.UserStoryId 
                                                                                 AND UserId = UST.UserId 
                                                                    FOR XML PATH(''''),  TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '' '') SpentTimeInMin
                                    FROM UserStorySpentTime UST INNER JOIN UserStory US ON US.Id = UST.UserStoryId  
                                         INNER JOIN #P P ON P.UserStoryId = UST.UserStoryId 
                                    WHERE (@UserId IS NULL OR UST.UserId = @UserId)
                                          AND (@Date = CAST( UST.DateTo AS DATE ) OR @Date = CAST(UST.EndTime AS DATE))
                                    GROUP BY UST.UserStoryId,UST.UserId) UST ON P.UserStoryId = UST.UserStoryId
        WHERE ' + @ColumnName04 + ' IS NOT NULL'
    
        EXEC sys.sp_executesql @SQL,
        N'@UserId UNIQUEIDENTIFIER,
          @Date DATE,
		  @ShowComments BIT',
        @UserId,
        @Date,
		@ShowComments
    
        SELECT @DaysCounter = @DaysCounter + 1
    
    END
    
	IF((SELECT ISDATE(@SortBy)) = 1)
	BEGIN
		
		SET @SQL = ''

		SELECT @SQL = @SQL + 'SELECT *,TotalCount=COUNT(1) OVER() FROM #P P ORDER BY  [' + @SortBy + '] ' + @SortDirection + ' OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
			        
		            FETCH NEXT @PageSize ROWS ONLY'
		
		PRINT @SQL

		EXEC SP_EXECUTESQL @SQL,
        N'@SortBy NVARCHAR(40) ,
          @SortDirection NVARCHAR(40) ,
          @PageNumber INT ,
		  @PageSize INT ',
        @SortBy,
        @SortDirection,
		@PageNumber,
		@PageSize

	END
	ELSE
	BEGIN

		SELECT *,TotalCount=COUNT(1) OVER() FROM #P P
		  ORDER BY 
			          CASE WHEN @SortDirection = 'ASC' OR @SortDirection IS NULL THEN
			             CASE WHEN @SortBy = 'GoalName' THEN P.GoalName
						      WHEN @SortBy = 'ProjectName' THEN P.ProjectName 
						      WHEN @SortBy = 'UserStoryName' THEN P.UserStoryName
							  WHEN @SortBy = 'EstimatedTime' THEN P.EstimatedTime
							  WHEN @SortBy = 'IsProductive' THEN P.IsProductive
							  WHEN @SortBy = 'SprintName' THEN P.SprintName
							  WHEN @SortBy = 'boardTypeName' THEN P.BoardTypeName
			             END
					  END ASC,
					  CASE WHEN @SortDirection = 'DESC'THEN
			              CASE WHEN @SortBy = 'GoalName' THEN P.GoalName
						      WHEN @SortBy = 'ProjectName' THEN P.ProjectName 
						      WHEN @SortBy = 'UserStoryName' THEN P.UserStoryName
							  WHEN @SortBy = 'EstimatedTime' THEN P.EstimatedTime
							  WHEN @SortBy = 'IsProductive' THEN P.IsProductive
                              WHEN @SortBy = 'SprintName' THEN P.SprintName
							  WHEN @SortBy = 'boardTypeName' THEN P.BoardTypeName
			             END
					  END DESC

				    OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
			        
		            FETCH NEXT @PageSize ROWS ONLY

    END

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[#P]'))
    DROP TABLE [dbo].#P
    
END
GO