-----------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-09-12 00:00:00.000'
-- Purpose      To Get Employee work report
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------------
--EXEC [dbo].[USP_EmployeeWorkLogReport] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@LineManagerId = '98BB2A6C-1192-4F16-8B5E-95A24BCA4256'
------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_EmployeeWorkLogReport]
(
 @GoalId UNIQUEIDENTIFIER = NULL,
 @ProjectId UNIQUEIDENTIFIER = NULL,
 @LineManagerId UNIQUEIDENTIFIER = NULL,
 @TimeZone NVARCHAR(250) = NULL,
 @UserId UNIQUEIDENTIFIER = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @DateFrom DATE = NULL,
 @DateTo DATE = NULL,
 @SortBy NVARCHAR(100) = NULL,
 @SortDirection NVARCHAR(100) = NULL,
 @PageSize INT = 100,
 @PageNumber INT = 1
)
AS
BEGIN
 SET NOCOUNT ON
 BEGIN TRY
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
  
  DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
  BEGIN

     IF(@TimeZone = '')SET @TimeZone = NULL

	 IF(@TimeZone IS NULL)SET @TimeZone = 'Asia/Kolkata'

     DECLARE @Offset NVARCHAR(100) = NULL
					  
	 SELECT @Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone

    IF (@DateFrom IS NULL) SET @DateFrom = DATEADD(DAY,1,EOMONTH(DATEADD(MONTH,-1,SWITCHOFFSET(SYSDATETIMEOFFSET(),STUFF(@Offset,4,0,':')))))
       
          IF (@DateTo IS NULL) SET @DateTo =  EOMONTH(SWITCHOFFSET(SYSDATETIMEOFFSET(),STUFF(@Offset,4,0,':')))
	
    DECLARE @UserIdCount INT

    IF(@UserId IS NOT NULL)
    BEGIN

       SET @UserIdCount = (SELECT Count(1) FROM [dbo].[User] WHERE Id = @UserId)

    IF (@UserIdCount = 0)
    BEGIN
     SET @UserId = NULL
    END
    END

    IF (@LineManagerId IS NULL) SET @LineManagerId = ISNULL(@UserId,@OperationsPerformedBy)

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	
	

             DECLARE @DayUserStory TABLE(
                                         [Date] DATETIME,
                                         [UserStoryId] UNIQUEIDENTIFIER,
										 [UserId] UNIQUEIDENTIFIER
									    )
					 INSERT INTO @DayUserStory
				     SELECT D.[Date]
						   ,US.Id
						   ,US.CreatedByUserId
				            FROM (SELECT DATEADD(DAY, NUMBER, @DateFrom) AS [Date]
				                         FROM MASTER..spt_values
									     WHERE TYPE='p'
											   AND NUMBER<=DATEDIFF(D,@DateFrom,@DateTo)) D
				            CROSS JOIN (SELECT U.Id,
							                   UST.CreatedByUserId 
											   FROM UserStory U
					                           JOIN UserStorySpentTime UST ON UST.UserStoryId = U.Id 
											    AND ((CONVERT(DATE,UST.DateTo) BETWEEN @DateFrom AND @DateTo AND UST.DateTo IS NOT NULL) OR (CONVERT(DATE,UST.EndTime) BETWEEN @DateFrom AND @DateTo AND UST.EndTime IS NOT NULL)) --AND U.OwnerUserId = UST.CreatedByUserId
					                           JOIN [dbo].[Ufn_GetEmployeeReportedMembers](@LineManagerId,@CompanyId) RE ON RE.ChildId = UST.CreatedByUserId    
											    AND (@GoalId IS NULL OR GoalId = @GoalId) 
												AND (@UserId IS NULL OR RE.ChildId = @UserId)
												AND (@ProjectId IS NULL OR U.ProjectId = @ProjectId)
					        GROUP BY U.Id,UST.CreatedByUserId)US

					  DECLARE @Temp TABLE(
										  [Date] DATETIME,
				                          [ProjectId] UNIQUEIDENTIFIER,
				                          [ProjectName] NVARCHAR(250),
				                          [GoalId] UNIQUEIDENTIFIER,
				                          [GoalName] NVARCHAR(250),
				                          [SprintName] NVARCHAR(250),
				                          [BoardTypeId] UNIQUEIDENTIFIER,
				                          [BoardType] NVARCHAR(250),
				                          [UserStoryId] UNIQUEIDENTIFIER,
				                          [UserStoryName] NVARCHAR(1000),
				                          CreatedDate DATETIME,
				                          LastUpdate DATETIME,
				                          [UserStoryStatus] UNIQUEIDENTIFIER,
				                          [Status] NVARCHAR(250),
				                          [UserStorySpentTime] FLOAT,
				                          [UserStoryEstimated] FLOAT,
				                          UserId UNIQUEIDENTIFIER,
										  LoggedUserName NVARCHAR(250),
										  LoggedUserId UNIQUEIDENTIFIER,
										  LoggedUserProfileImage NVARCHAR(MAX),
				                          DeveloperName NVARCHAR(250),
				                          DeveloperImage NVARCHAR(MAX),
				                          TotalSpentTimeSoFar FLOAT,
				                          RemainingTime FLOAT,
				                          Comments NVARCHAR(MAX),
				                          IsUserStoryArchived BIT,
				                          IsUserStoryParked BIT,
				                          IsGoalArchived BIT,
				                          IsGoalParked BIT,
				                          IsSprintDelete BIT,
				                          IsProjectArchived BIT,
				                          IsFromSprint BIT,
				                          UserStoryUniqueName  NVARCHAR(100)
                                         )

								   INSERT INTO @Temp(
												      [Date]
												     ,ProjectId
												     ,[ProjectName]
												     ,[GoalId]
												     ,[GoalName]
												     ,[BoardTypeId]
												     ,[BoardType]
												     ,[UserStoryId]
												     ,[UserStoryName]
												     ,UserStoryEstimated
												     ,CreatedDate
												     ,UserStoryStatus
												     ,[Status]
												     ,[UserStorySpentTime]
													 ,LoggedUserId
													 ,LoggedUserName
													 ,LoggedUserProfileImage
												     ,UserId
												     ,DeveloperName
												     ,DeveloperImage
												     ,TotalSpentTimeSoFar
												     ,RemainingTime
												     ,SprintName
												     ,IsUserStoryArchived
												     ,IsUserStoryParked
												     ,IsGoalArchived
												     ,IsGoalParked
												     ,IsSprintDelete
												     ,IsProjectArchived
												     ,IsFromSprint
												     ,UserStoryUniqueName
												     )
											   SELECT D.[Date]
											  	     ,P.Id
										             ,P.ProjectName
										             ,G.Id
										             ,G.GoalName
								                     ,G.BoardTypeId
								                     ,BT.BoardTypeName
										             ,D.UserStoryId
										             ,US.UserStoryName
										             ,ISNULL(US.EstimatedTime,0)
										             ,US.CreatedDateTime
										             ,US.UserStoryStatusId
										             ,USS.[Status]
										             ,ISNULL(SP.SpentTime,0)
													 ,SU.Id
													 ,SU.FirstName+ ' ' + SU.SurName
													 ,SU.ProfileImage
								                     ,US.OwnerUserId
										             ,U.FirstName + ' ' + ISNULL(U.SurName,'')
										             ,U.ProfileImage
										             ,ISNULL(TSP.TotalSpentTime,0)
								                     ,IIF((ISNULL(US.EstimatedTime,0) - ISNULL(TSP.TotalSpentTime,0)) > 0, ISNULL(US.EstimatedTime,0) - ISNULL(TSP.TotalSpentTime,0), 0)
											  	     ,S.SprintName
								                     ,CASE WHEN US.InActiveDateTime IS NULL THEN 0
										                   ELSE 1 END
								                     ,CASE WHEN US.ParkedDateTime IS NULL THEN 0
										                   ELSE 1 END
								                     ,CASE WHEN G.InActiveDateTime IS NULL THEN 0
										                   ELSE 1 END
								                     ,CASE WHEN G.ParkedDateTime IS NULL THEN 0
										                   ELSE 1 END
								                     ,CASE WHEN S.InActiveDateTime IS NULL THEN 0
										                   ELSE 1 END
									                 ,CASE WHEN P.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END
								                     ,CASE WHEN US.SprintId  IS NOT NULL THEN 1 ELSE 0 END
								                     ,US.UserStoryUniqueName
								                     FROM @DayUserStory D
											         JOIN [UserStory] US ON US.Id = D.UserStoryId 
									                 JOIN [Project] P ON P.Id = US.ProjectId AND (@ProjectId IS NULL OR  P.Id = @ProjectId)
										             LEFT JOIN [User] U ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL
										             JOIN [User] SU ON SU.Id = D.UserId AND U.InActiveDateTime IS NULL
										             LEFT JOIN [Goal] G ON G.Id = US.GoalId 
									                 LEFT JOIN Sprints S ON S.Id = US.SprintId
									                 LEFT JOIN [BoardType] BT ON (BT.Id = G.BoardTypeId AND ( S.BoardTypeId IS NULL OR S.BoardTypeId = BT.Id) ) AND BT.InActiveDateTime IS NULL
										             LEFT JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id 
										             JOIN (SELECT D.[Date]
											  				     ,D.[UserStoryId] 
																 ,D.UserId
																 ,SUM(D.SpentTime)/60.0 AS SpentTime
																 FROM (SELECT D.[Date]
											  				     ,D.[UserStoryId] 
																 ,D.UserId
											                     ,CASE WHEN UST.SpentTimeInMin IS NOT NULL THEN UST.SpentTimeInMin
																       ELSE  DATEDIFF(MINUTE,SWITCHOFFSET(UST.StartTime,STUFF(@Offset,4,0,':')),SWITCHOFFSET(UST.EndTime,STUFF(@Offset,4,0,':')))
																	   END AS SpentTime
											                      FROM @DayUserStory D 
										                          JOIN UserStory US ON US.Id = D.UserStoryId 
											                      LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = D.UserStoryId AND UST.CreatedByUserId = D.UserId 
																       -- AND CONVERT(DATE,UST.DateTo) = D.[Date] --AND UST.UserId = US.OwnerUserId
																		AND ((CONVERT(DATE,UST.DateTo) = D.[Date] AND UST.DateTo IS NOT NULL) OR (CONVERT(DATE,SWITCHOFFSET(UST.StartTime,STUFF(@Offset,4,0,':'))) = D.[Date] AND UST.EndTime IS NOT NULL))) D
											                GROUP BY D.[Date],D.[UserStoryId],D.UserId) SP ON SP.[Date] = D.[Date] AND SP.UserStoryId = D.UserStoryId AND SP.UserId = SU.Id
										             JOIN (SELECT D.[Date]
													             ,D.[UserStoryId]
																 ,D.UserId
																 ,SUM(D.TotalSpentTime)/60.0 AS TotalSpentTime
																 FROM (SELECT D.[Date]
													             ,D.[UserStoryId]
																 ,D.UserId
																 ,CASE WHEN UST.SpentTimeInMin IS NOT NULL THEN UST.SpentTimeInMin 
																       ELSE DATEDIFF(MINUTE,SWITCHOFFSET(UST.StartTime,STUFF(@Offset,4,0,':')),SWITCHOFFSET(UST.EndTime,STUFF(@Offset,4,0,':')))
																	   END AS TotalSpentTime
											  	                  FROM @DayUserStory D
									                              JOIN UserStory US ON US.Id = D.UserStoryId 
											  	                  LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = D.UserStoryId --AND UST.UserId = US.OwnerUserId 
											  	                       -- AND CONVERT(DATE,UST.DateTo) <= D.[Date] 
																		AND UST.CreatedByUserId = D.UserId
																		AND ((CONVERT(DATE,UST.DateTo) <= D.[Date] AND UST.DateTo IS NOT NULL) 
																		 OR (CONVERT(DATE,SWITCHOFFSET(UST.StartTime,STUFF(@Offset,4,0,':'))) <= D.[Date] AND UST.EndTime IS NOT NULL))) D
											  	                  GROUP BY D.UserId,D.[Date],D.[UserStoryId]) TSP ON TSP.[Date] = D.[Date] AND TSP.UserStoryId = D.UserStoryId

											         UPDATE @Temp SET Comments = STUFF((SELECT '`' + SUBSTRING(C.Comment,0,LEN(C.Comment)-4) +  ' ' + CONVERT(VARCHAR,CONVERT(DATETIME,C.CreatedDateTime),6) + '</p>' FROM UserStorySpentTime C
											  																		 WHERE C.UserStoryId = T.UserStoryId 
																													 AND CONVERT(DATE,SWITCHOFFSET(C.CreatedDateTime,STUFF(@Offset,4,0,':'))) = T.[Date] 
																													 --AND C.CreatedByUserId = T.UserId
																													 FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') FROM @Temp T
                 
           
									      SELECT T.[Date] 
												,T.[ProjectId]
												,T.[ProjectName]
												,T.LoggedUserId
												,T.LoggedUserName
												,T.LoggedUserProfileImage
											    ,T.UserId
											    ,T.[DeveloperName]
												,T.[DeveloperImage]
											    ,T.[GoalId]
											    ,T.[GoalName]
											    ,T.BoardTypeId
											    ,T.BoardType
											    ,T.[UserStoryId]
											    ,T.[UserStoryName]
											    ,T.[UserStoryStatus]
											    ,T.[Status]
											    ,T.[UserStoryEstimated] AS OriginalEstimate
											    ,CONVERT(DECIMAl(10,2),T.[UserStorySpentTime]) AS SpentToday
											    ,CONVERT(DECIMAl(10,2),T.[TotalSpentTimeSoFar]) AS [TotalSpentTimeSoFar]
											    ,T.RemainingTime
											    ,ISNULL(T.Comments,'') Comments
											    ,SprintName
											    ,IsUserStoryArchived
											    ,IsUserStoryParked
											    ,IsGoalArchived
											    ,IsGoalParked
											    ,IsSprintDelete
											    ,IsProjectArchived
											    ,IsFromSprint
												,T.UserStoryUniqueName
											    ,TotalCount = COUNT(1) OVER()
											 	FROM @Temp T
											 	WHERE T.UserStorySpentTime > 0
													   ORDER BY 
										   CASE WHEN @SortDirection = 'ASC'  THEN
												CASE WHEN @SortBy = 'ProjectName' THEN CAST(T.ProjectName AS SQL_VARIANT)
												     WHEN @SortBy = 'Date' OR @SortBy IS NULL THEN CAST(T.[Date] AS SQL_VARIANT)
												     WHEN @SortBy = 'DeveloperName' THEN CAST(T.DeveloperName AS SQL_VARIANT)
											         WHEN @SortBy = 'GoalName' THEN CAST(T.GoalName AS SQL_VARIANT)
											         WHEN @SortBy = 'UserStoryName' THEN CAST(T.UserStoryName AS SQL_VARIANT)
											         WHEN @SortBy = 'BoardType' THEN CAST(T.BoardType AS SQL_VARIANT)
											         WHEN @SortBy = 'OriginalEstimate' THEN T.UserStoryEstimated
											         WHEN @SortBy = 'SpentToday' THEN T.UserStorySpentTime
											         WHEN @SortBy = 'TotalSpentTimeSoFar' OR @SortBy IS NULL THEN T.TotalSpentTimeSoFar
											         WHEN @SortBy = 'RemainingTime' THEN T.RemainingTime              
										 END
										 END ASC,
										 CASE WHEN @SortDirection = 'DESC'  OR @SortDirection IS NULL THEN
												CASE WHEN @SortBy = 'ProjectName' THEN CAST(T.ProjectName AS SQL_VARIANT)
												     WHEN @SortBy = 'Date' OR @SortBy IS NULL THEN CAST(T.[Date] AS SQL_VARIANT)
												     WHEN @SortBy = 'DeveloperName' THEN CAST(T.DeveloperName AS SQL_VARIANT)
										             WHEN @SortBy = 'BoardType' THEN CAST(T.BoardType AS SQL_VARIANT)
										             WHEN @SortBy = 'UserStoryName' THEN CAST(T.UserStoryName AS SQL_VARIANT)
											         WHEN @SortBy = 'GoalName' THEN CAST(T.GoalName AS SQL_VARIANT)
											         WHEN @SortBy = 'OriginalEstimate' THEN T.UserStoryEstimated
											         WHEN @SortBy = 'SpentToday' THEN T.UserStorySpentTime
											         WHEN @SortBy = 'TotalSpentTimeSoFar'  THEN T.TotalSpentTimeSoFar 
										             WHEN @SortBy = 'RemainingTime' THEN T.RemainingTime
										END
										 END DESC

							  OFFSET ((@PageNumber - 1) * @PageSize) ROWS
          
													  FETCH NEXT @PageSize ROWS ONLY
  END
  ELSE
   
   RAISERROR(@HavePermission,11,1)

 END TRY
 BEGIN CATCH

  THROW

 END CATCH
END