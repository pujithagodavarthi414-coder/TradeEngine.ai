--EXEC [USP_GetUsersSpentTimedetails] @OperationsPerformedBy = '7de8b63e-2e79-4d0a-a313-9daf2f3e8fe9',@DateFrom = '2020-08-25',
CREATE  PROCEDURE [dbo].[USP_GetUsersSpentTimedetails]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @DateFrom DATE,
 @ProjectId UNIQUEIDENTIFIER = NULL,
 @DateTo DATE,
 @PageSize INT = 20,
 @PageNumber INT = 1,
 @SortBy NVARCHAR(40) = NULL,
 @SortDirection NVARCHAR(40) = NULL,
 @TimeZone NVARCHAR(250) = NULL,
 @LineManagerId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	IF(@SortBy IS NULL)SET @SortBy ='Developer'

	IF(@SortDirection IS NULL)SET @SortDirection = 'ASC'

	   DECLARE @Offset NVARCHAR(100) = NULL
					  				
		SELECT @Offset = STUFF(TimeZoneOffset,4,0,':') FROM TimeZone WHERE TimeZone = @TimeZone

		IF(@Offset IS NULL)SET @Offset = '+05:30'
		
	IF(@LineManagerId IS NULL) SET @LinemanagerId = @OperationsPerformedBy

    DECLARE @ColumnName01 VARCHAR(50)
           , @ColumnName02 VARCHAR(50)
		   , @ColumnName03 VARCHAR(50)
		   , @ColumnName04 VARCHAR(50)
    
    SELECT @ColumnName01 = '[UserStoryOwnerId]'
          , @ColumnName02 = '[Developer]'
		  , @ColumnName03 = '[OwnerProfileImage]'
    
    CREATE TABLE #P ( UserStoryOwnerId UNIQUEIDENTIFIER,
					  OwnerProfileImage NVARCHAR(2000),
					  Developer NVARCHAR(250));
    
    DECLARE @SQL NVARCHAR(MAX)
    DECLARE @Date DATE
        
    INSERT INTO #P(UserStoryOwnerId,Developer,OwnerProfileImage)
    SELECT U.Id,U.FirstName +' '+ISNULL(U.SurName,'') Developer,U.ProfileImage
    FROM [User] U
	     LEFT JOIN UserStorySpentTime UST ON U.Id = UST.UserId AND (@ProjectId IS NULL OR UST.UserStoryId IN (SELECT Id FROM UserStory WHERE ProjectId = @ProjectId))
         --AND @DateFrom <= CONVERT(DATE,UST.DateFrom) AND @DateTo >= CONVERT(DATE,UST.DateFrom)
          AND CONVERT(DATE,SWITCHOFFSET(UST.DateFrom,@Offset)) BETWEEN @DateFrom AND @DateTo
          AND CONVERT(DATE,SWITCHOFFSET(UST.DateTo,@Offset)) BETWEEN @DateFrom AND @DateTo
         LEFT JOIN UserStory US ON US.Id = UST.UserStoryId
		 WHERE U.CompanyId = @CompanyId
           AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](ISNULL(@LineManagerId,@OperationsPerformedBy),@CompanyId))
	GROUP BY U.Id,U.FirstName +' '+ISNULL(U.SurName,''),U.ProfileImage

    DECLARE @MaxDays INT = DATEDIFF(DAY,@DateFrom,@DateTo) + 1
    DECLARE @DaysCounter INT = 0

	
	
    WHILE @DaysCounter < @MaxDays
    BEGIN
    
        SELECT @Date = DATEADD(DAY,@DaysCounter,@DateFrom)
    
        SELECT @ColumnName04 = '[' + CAST(@Date AS NVARCHAR(25)) + ']'
    
        SELECT @SQL = 'ALTER TABLE #P ADD ';
    
        SELECT @SQL += @ColumnName04 + ' NVARCHAR(MAX) NULL '
    
        EXEC sys.sp_executesql @SQL

		
	CREATE TABLE #US ( 
	RowNo INT IDENTITY(1,1),
	UserStoryId UNIQUEIDENTIFIER 
	); 


		 INSERT INTO #US(UserStoryId)
         SELECT US.Id
         FROM UserStorySpentTime UST 
         INNER JOIN UserStory US ON US.Id = UST.UserStoryId AND (@ProjectId IS NULL OR US.ProjectId = @ProjectId)
                    AND @Date = CONVERT(DATE,SWITCHOFFSET(UST.DateTo,@Offset))
                     --AND CONVERT(DATE,UST.DateFrom) BETWEEN @DateFrom AND @DateTo
                     --AND CONVERT(DATE,UST.DateTo) BETWEEN @DateFrom AND @DateTo
		 INNER JOIN Project P ON P.Id = US.ProjectId AND P.CompanyId = @CompanyId
         INNER JOIN (SELECT ProjectId FROM [UserProject] UP 
		               WHERE UP.UserId = @OperationsPerformedBy
					      AND UP.InActiveDateTime IS NULL GROUP BY UP.ProjectId) UP ON US.ProjectId = UP.ProjectId
		 INNER JOIN [User] U ON U.Id = UST.UserId AND U.CompanyId = @CompanyId
         AND UST.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](ISNULL(@LineManagerId,@OperationsPerformedBy),@CompanyId))
         
		 GROUP BY US.Id

		 DECLARE @UserStoriesCount INT = (SELECT COUNT(1) FROM #US)

		 DECLARE @UserStoryId UNIQUEIDENTIFIER

		 WHILE (@UserStoriesCount > 0 )
         BEGIN

		 SET @UserStoryId = (SELECT UserStoryId FROM #US WHERE RowNo = @UserStoriesCount)


		 SELECT @SQL = 'UPDATE #P SET ' + @ColumnName04 + ' = CASE WHEN SpentTimeInMin IS NOT NULL THEN  CONCAT('+@ColumnName04+',CONCAT(CONCAT (UserStoryUniqueName ,''(''),SpentTimeInMin,''h'',''|'',ISNULL(UST.EstimatedTime,0))) END
                    FROM #P P 
                         INNER JOIN (SELECT UST.UserId, SUM(SpentTimeInMin)/60 SpentTimeInMin, US.UserStoryUniqueName,US.EstimatedTime  
                                    FROM UserStorySpentTime UST 
                                         INNER JOIN UserStory US ON US.Id = UST.UserStoryId AND US.Id = @UserStoryId
                                           				        AND CONVERT(DATE,SWITCHOFFSET(UST.DateTo,@Offset)) = @Date
                                    GROUP BY UST.UserId,US.UserStoryUniqueName,US.EstimatedTime) UST ON P.UserStoryOwnerId = UST.UserId'
									
		 EXEC sys.sp_executesql @SQL,
          N'@Date DATE,
		  @Offset NVARCHAR(100),
		  @UserStoryId UNIQUEIDENTIFIER',
         @Date,
		 @Offset,
		 @UserStoryId

		 SELECT @SQL = 'UPDATE #P SET ' + @ColumnName04 + ' = CONCAT('+@ColumnName04+',CONCAT(''h |'', SpentTimeInMin,''h'','')''),'':&'',UserStoryId,'':&'',CONVERT(CHAR(1),IIF(US.InactiveDateTime IS NOT NULL,1,0)),'':&'',CONVERT(CHAR(1),IIF(US.ParkedDateTime IS NOT NULL,1,0)),'':&'',CONVERT(CHAR(1),IIF(S.Id IS NOT NULL,1,0)),'':&'',CONVERT(CHAR(1),IIF(S.InactiveDateTime IS NOT NULL,1,0)),'':&'',CONVERT(CHAR(1),IIF(Pr.InactiveDateTime IS NOT NULL,1,0)),'':&'',CONVERT(CHAR(1),IIF(G.InactiveDateTime IS NOT NULL,1,0)),'':&'',CONVERT(CHAR(1),IIF(G.ParkedDateTime IS NOT NULL,1,0)))
                    FROM #P P 
                         INNER JOIN (SELECT UST.UserId, SUM(SpentTimeInMin)/60 SpentTimeInMin,UST.UserStoryId
                                    FROM UserStorySpentTime UST 
                                         INNER JOIN UserStory US ON US.Id = UST.UserStoryId AND US.Id = @UserStoryId
                                                                AND @Date >= CAST(SWITCHOFFSET(UST.DateTo,@Offset) AS DATE) 
                                    GROUP BY UST.UserId,UST.UserStoryId) UST ON P.UserStoryOwnerId = UST.UserId
						 LEFT JOIN UserStory US ON US.Id = UST.UserStoryId
                         LEFT JOIN Sprints S ON S.Id = US.SprintId
						 LEFT JOIN Project Pr ON Pr.Id = US.ProjectId
						 LEFT JOIN Goal G ON G.Id = US.GoalId

         WHERE ' + @ColumnName04 + ' IS NOT NULL'

		 EXEC sys.sp_executesql @SQL,
          N'@Date DATE,
		  @Offset NVARCHAR(100),
		  @UserStoryId UNIQUEIDENTIFIER',
         @Date,
		 @Offset,
		 @UserStoryId

		 SELECT @UserStoriesCount = @UserStoriesCount - 1

		IF(@UserStoriesCount > 0)
		 BEGIN
		 SELECT @SQL = 'UPDATE #P SET ' + @ColumnName04 + ' = CONCAT('+@ColumnName04+','','')   FROM #P P 
                         INNER JOIN (SELECT UST.UserId, SUM(SpentTimeInMin)/60 SpentTimeInMin, US.UserStoryUniqueName,US.EstimatedTime  
                                    FROM UserStorySpentTime UST 
                                         INNER JOIN UserStory US ON US.Id = UST.UserStoryId AND US.Id = @UserStoryId
                                           				        AND CONVERT(DATE,SWITCHOFFSET(UST.DateTo,@Offset)) = @Date
                                    GROUP BY UST.UserId,US.UserStoryUniqueName,US.EstimatedTime) UST ON P.UserStoryOwnerId = UST.UserId'

		
		 EXEC sys.sp_executesql @SQL,
         N'@Date DATE,
		 @Offset NVARCHAR(100),
		 @UserStoryId UNIQUEIDENTIFIER',
         @Date,
		 @Offset,
		 @UserStoryId

		 END
		
	     END

		 SET @UserStoriesCount = 0
		 DELETE FROM #US
		 DROP TABLE #US 

         SELECT @DaysCounter = @DaysCounter + 1
    
  END

   declare @msql varchar(3000)
  
set @msql = 'SELECT * FROM #p T ORDER BY [' + @SortBy + '] ' + @SortDirection

EXEC(@msql)

  DROP TABLE [dbo].#P

END TRY
	BEGIN CATCH

		THROW

    END CATCH
END