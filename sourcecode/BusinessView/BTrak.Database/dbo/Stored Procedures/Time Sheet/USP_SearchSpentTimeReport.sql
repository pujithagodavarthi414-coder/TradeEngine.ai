-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Search Userstory Spent Time
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC USP_SearchSpentTimeReport @ProjectId = NULL , @DateDescription = 'any', @DateFrom = NULL, @DateTo = NULL, @Days = NULL, @UserDescription = 'any', @UserStoryTypeId = NULL, @HoursDescription = 'any', @HoursFrom = NULL, @HoursTo = NULL,  @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308', @PageNumber = 1, @PageSize = 1000,@UserStoryTypeDescription= null

CREATE PROCEDURE [dbo].[USP_SearchSpentTimeReport]
(
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @DateDescription VARCHAR(100) = NULL,
    @DateFrom DATETIME = NULL,
    @DateTo DATETIME = NULL,
    @Days INT = NULL,
    @UserDescription VARCHAR(100) = NULL,
    @UserId UNIQUEIDENTIFIER = NULL,
    @HoursDescription VARCHAR(100) = NULL,
    @HoursFrom INT = NULL,
    @HoursTo INT = NULL,
	@UserStoryTypeDescription VARCHAR(100) = NULL,
	@UserStoryTypeId  UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER ,
    @PageNumber INT = NULL,
    @PageSize INT = NULL,
	@SortBy NVARCHAR(200) = NULL,
	@SortDirection NVARCHAR(250) = NULL,
    @SearchText NVARCHAR(250 )= NULL
  
)
AS
BEGIN
SET NOCOUNT ON
BEGIN TRY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
    BEGIN

    DECLARE @MaxDate DATETIME = (SELECT MAX(CONVERT(DATE,StartDateTime)) FROM UserStoryLogTime)

    DECLARE @MinDate DATETIME = (SELECT MIN(CONVERT(DATE,StartDateTime)) FROM UserStoryLogTime)

    DECLARE @CurrentDate DATETIME = (SELECT CONVERT(DATE,GETUTCDATE()))

    DECLARE @WeekStart DATETIME =(SELECT  DATEADD(dd, -(DATEPART(dw, @CurrentDate)-1), @CurrentDate) )

    DECLARE @WeekEnd DATETIME = (SELECT DATEADD(dd, 7-(DATEPART(dw, @CurrentDate)), @CurrentDate))

    DECLARE @MonthStart DATETIME = (SELECT DATEADD(MONTH, DATEDIFF(month, 0,  @CurrentDate), 0) )

    DECLARE @MonthEnd DATETIME = (SELECT DATEADD(SECOND, -1, DATEADD(MONTH, 1,  DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentDate) , 0) ) ))

    DECLARE @StartOfYear DATETIME = (SELECT DATEADD(yy, DATEDIFF(yy, 0, @CurrentDate), 0))

    DECLARE @EndOfYear DATETIME = (SELECT DATEADD(yy, DATEDIFF(yy, 0, @CurrentDate) + 1, -1))

    DECLARE @MaxHours INT =  (SELECT MAX(DATEDIFF(HOUR, StartDateTime, EndDateTime)) FROM UserStoryLogTime)

    DECLARE @MinHours INT =  (SELECT MIN(DATEDIFF(HOUR, StartDateTime, EndDateTime)) FROM UserStoryLogTime)

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	IF(@PageSize IS NULL ) SET @PageSize = (SELECT COUNT(1) FROM [User])
           
    IF(@PageNumber IS NULL ) SET @PageNumber = 1

    IF (@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL

	IF (@UserStoryTypeId = '00000000-0000-0000-0000-000000000000') SET @UserStoryTypeId = NULL

	IF (@UserStoryTypeDescription = '') SET @UserStoryTypeDescription = NULL

    IF(@DateDescription = 'any')
    BEGIN
        SET @DateFrom = NULL
        SET @DateTo = NULL
    END
    ELSE IF(@DateDescription = 'is')
    BEGIN
        SET @DateFrom = @DateFrom
        SET @DateTo = @DateFrom
    END
    ELSE IF(@DateDescription = '>=')
    BEGIN
        SET @DateFrom = @DateFrom
        SET @DateTo = @MaxDate
    END
    ELSE IF(@DateDescription = '<=')
    BEGIN
        SET @DateFrom = @MinDate
        SET @DateTo = @DateFrom
    END
    ELSE IF(@DateDescription = 'between')
    BEGIN
        SET @DateFrom = @DateFrom
        SET @DateTo = @DateTo
    END
    ELSE IF(@DateDescription = 'lessthandaysago')
    BEGIN
        SET @DateFrom = DATEADD(DAY,-@Days,@CurrentDate)
        SET @DateTo = @CurrentDate
    END
    ELSE IF(@DateDescription = 'morethandaysago')
    BEGIN
        SET @DateFrom = @DateFrom
        SET @DateTo = DATEADD(DAY,@Days,@CurrentDate)
    END
    ELSE IF(@DateDescription = 'daysago')
    BEGIN
        SET @DateFrom = DATEADD(DAY,-@Days,@CurrentDate)
        SET @DateTo = NULL
    END
    ELSE IF(@DateDescription = 'today')
    BEGIN
        SET @DateFrom = @CurrentDate
        SET @DateTo = NULL
    END
    ELSE IF(@DateDescription = 'yesterday')
    BEGIN
        SET @DateFrom = DATEADD(DAY,-1,@CurrentDate)
        SET @DateTo = NULL
    END
    ELSE IF(@DateDescription = 'thisweek')
    BEGIN
        SET @DateFrom = DATEADD(dd, -(DATEPART(dw, @CurrentDate)-1), @CurrentDate)
        SET @DateTo = @CurrentDate
    END
    ELSE IF(@DateDescription = 'lastweek')
    BEGIN
        SET @DateFrom = DATEADD(DAY,-7,@WeekStart)
        SET @DateTo = DATEADD(DAY,-7,@WeekEnd)
    END
    ELSE IF(@DateDescription = 'last2weeks')
    BEGIN
        SET @DateFrom = DATEADD(DAY,-14,@WeekStart)
        SET @DateTo = DATEADD(DAY,-14,@WeekEnd)
    END
    ELSE IF(@DateDescription = 'thismonth')
    BEGIN
        SET @DateFrom = @MonthStart
        SET @DateTo = @MonthEnd
    END
    ELSE IF(@DateDescription = 'lastmonth')
    BEGIN
        SET @DateFrom = DATEADD(MONTH,-1,@MonthStart)
        SET @DateTo = DATEADD(MONTH,-1,@MonthEnd)
    END
    ELSE IF(@DateDescription = 'thisyear')
    BEGIN
        SET @DateFrom = @StartOfYear
        SET @DateTo = @EndOfYear
    END
    ELSE IF(@DateDescription = 'none')
    BEGIN
        SET @DateFrom = '1800-01-01'
        SET @DateTo = '1800-01-01'
    END
    DECLARE @Users TABLE
    (
        UserId UNIQUEIDENTIFIER
    )
    IF(@UserDescription = 'is')
    BEGIN
        INSERT INTO @Users(UserId)
        SELECT Id FROM [User] WHERE Id = @UserId
    END
    ELSE IF(@UserDescription = 'isnot')
    BEGIN
        INSERT INTO @Users(UserId)
        SELECT Id FROM [User] WHERE Id NOT IN (@UserId)
    END
    ELSE IF(@UserDescription = 'any')
    BEGIN
        INSERT INTO @Users(UserId)
        SELECT Id FROM [User]
    END
    IF(@HoursDescription = 'any')
    BEGIN
        SET @HoursFrom = NULL
        SET @HoursTo = NULL
    END
    ELSE IF(@HoursDescription = 'is')
    BEGIN
        SET @HoursFrom = @HoursFrom
        SET @HoursTo = @HoursFrom
    END
    ELSE IF(@HoursDescription = '>=')
    BEGIN
        SET @HoursFrom = @HoursFrom
        SET @HoursTo = @MaxHours
    END
    ELSE IF(@HoursDescription = '<=')
    BEGIN
        SET @HoursTo = @HoursFrom
        SET @HoursFrom = @MinHours
    END
    ELSE IF(@HoursDescription = 'between')
    BEGIN
        SET @HoursFrom = @HoursFrom
        SET @HoursTo = @HoursTo
    END
    ELSE IF(@HoursDescription = 'none')
    BEGIN
        SET @HoursFrom = -999999
        SET @HoursTo = -999999
    END

	DECLARE @TotalLoggedHours INT = (SELECT SUM(DATEDIFF(HOUR,UT.StartDateTime,UT.EndDateTime)) FROM UserStoryLogTime UT)

	SELECT Z.ProjectId,
		   Z.ProjectName,
	       Z.LoggedDate,
		   Z.UserId,
		   Z.UserName,
		   Z.UserStoryTypeId,
		   Z.UserStoryTypeName,
		   Z.UserStoryId,
		   Z.UserStoryName,
		   T.LoggedHours,
		   @TotalLoggedHours TotalLoggedHours,
		   TotalCount = COUNT(1) OVER() 
	      FROM
	      ((SELECT P.Id ProjectId,
		           P.ProjectName, 
				   ULT.StartDateTime LoggedDate,
		           U.Id UserId,
                   ISNULL(U.FirstName,'') +' ' + ISNULL(U.SurName,'') UserName,
				   UST.Id UserStoryTypeId,
				   UST.UserStoryTypeName,
				   US.Id AS UserStoryId,
                   US.UserStoryName 
		    FROM [User] U WITH (NOLOCK)
               INNER JOIN UserStoryLogTime ULT WITH (NOLOCK) ON ULT.UserId = U.Id 
			   JOIN UserStory US WITH (NOLOCK) ON US.Id = ULT.UserStoryId
			   JOIN Project P ON P.Id = US.ProjectId 
			   JOIN UserStoryType UST WITH (NOLOCK) ON UST.Id = US.UserStoryTypeId
               LEFT JOIN Goal G WITH (NOLOCK) ON G.Id = US.GoalId 
			   LEFT JOIN Sprints S ON S.Id = US.SprintId 
          WHERE (@ProjectId IS NULL OR @ProjectId = G.ProjectId) 
				AND (G.InactiveDateTime IS NULL) AND (G.ParkedDateTime IS NULL) 
				AND US.ArchivedDateTime IS NULL AND US.ParkedDateTime IS NULL
	            AND(@UserStoryTypeId IS NULL OR UST.Id = @UserStoryTypeId)
				AND(@UserStoryTypeDescription IS NULL OR UST.UserStoryTyPeName = @UserStoryTypeDescription)
                AND (CONVERT(DATE,ULT.StartDateTime) >= @DateFrom OR @DateFrom IS NULL) 
                AND (CONVERT(DATE,ULT.StartDateTime) <= @DateTo OR @DateTo IS NULL)
                AND ULT.UserId IN (SELECT UserId FROM @Users)
                AND (DATEDIFF(HOUR, StartDateTime, EndDateTime) >= @HoursFrom OR @HoursFrom IS NULL) 
                AND (DATEDIFF(HOUR, StartDateTime, EndDateTime) <= @HoursTo OR @HoursTo IS NULL) 
                AND (P.CompanyId = @CompanyId))Z INNER JOIN 
	      	  (SELECT UT.UserStoryId,UT.UserId,
			          SUM(DATEDIFF(HOUR,UT.StartDateTime,UT.EndDateTime))LoggedHours
			   FROM UserStoryLogTime UT GROUP BY UT.UserStoryId,UT.UserId)T ON T.UserStoryId=Z.UserStoryId)

			   WHERE (@SearchText IS NULL 
				                  OR(Z.UserName LIKE @SearchText)
				                  OR(Z.UserStoryName  LIKE @SearchText)
								  OR(CONVERT(DATE,Z.LoggedDate) LIKE @SearchText)
								  OR(CONVERT(NVARCHAR(250),T.LoggedHours) LIKE @SearchText)
				                  )
	      	   GROUP BY Z.ProjectId, Z.ProjectName, Z.LoggedDate,Z.UserId,Z.UserName,Z.UserStoryTypeId,Z.UserStoryTypeName,Z.UserStoryId,Z.UserStoryName,T.LoggedHours
             
				           ORDER BY 
							 CASE WHEN (@SortDirection IS NULL OR  @SortDirection = 'DESC') THEN
				                CASE WHEN (@SortBy IS NULL OR @SortBy = 'loggedHours') THEN CAST(T.LoggedHours as sql_variant)
								     WHEN @SortBy = 'userName' THEN Z.UserName
				                     WHEN @SortBy = 'userStoryName' THEN Z.UserStoryName
				                     WHEN @SortBy = 'loggedDate' THEN CAST(Z.LoggedDate as sql_variant)
				                END
				           END DESC,

        				     CASE WHEN @SortDirection = 'ASC' THEN
				                CASE WHEN (@SortBy IS NULL OR @SortBy = 'loggedHours') THEN CAST(T.LoggedHours as sql_variant)
								     WHEN @SortBy = 'userName' THEN Z.UserName
				                     WHEN @SortBy = 'userStoryName' THEN Z.UserStoryName
				                     WHEN @SortBy = 'loggedDate' THEN CAST(Z.LoggedDate as sql_variant)
				                     
				                END
				           END ASC
			   
			    OFFSET ((@PageNumber - 1) * @PageSize) ROWS
               FETCH NEXT @PageSize ROWS ONLY
				
		END    
		ELSE
				RAISERROR (@HavePermission,11, 1)
                                                                                                                
     END TRY  
     BEGIN CATCH 
        
           THROW

    END CATCH
    END