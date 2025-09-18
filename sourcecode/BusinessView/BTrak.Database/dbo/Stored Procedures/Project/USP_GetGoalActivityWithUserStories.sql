--------------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetGoalActivityWithUserStories] @GoalId = 'A4DAD321-6C68-4790-9D19-C7B3198CD397',
-- @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsIncludeUserStoryView = 1,@IsIncludeLogTime = 1		
--------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetGoalActivityWithUserStories] 
( 
    @GoalId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @IsIncludeUserStoryView BIT = NULL,
    @IsIncludeLogTime BIT = NULL,
	@UserId UNIQUEIDENTIFIER = NULL,
	@IsFromActivity BIT = NULL,
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL,
	@PageNo INT = 1,
	@PageSize INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@UserId IS NOT NULL)
		BEGIN
		  DECLARE @UserStoryCount INT
		   SET @UserStoryCount = (SELECT COUNT(1) FROM [dbo].[User] WHERE Id = @UserId)
		   IF(@UserStoryCount = 0)
		   BEGIN
		     SET @UserId = NULL
		   END
		END
          
		IF(@PageNo IS NULL OR @PageNo = 0) SET @PageNo = 1

       IF(@PageSize IS NULL OR @PageSize = 0) SET @PageSize = 30000
		            
        IF (@HavePermission = '1')
        BEGIN
            
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SELECT DISTINCT ProjectId
		              INTO #Projects
			   FROM UserProject WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL

            CREATE TABLE #GoalActivityList 
            (
                ProjectId UNIQUEIDENTIFIER,
                ProjectName NVARCHAR(MAX),
            	UserStoryOrGoalId UNIQUEIDENTIFIER,
            	UserStoryOrGoalName NVARCHAR(800),
            	OldValue NVARCHAR(MAX),
            	NewValue NVARCHAR(MAX),
            	FieldName NVARCHAR(250),
            	[Description] NVARCHAR(MAX),
            	[KeyValue] NVARCHAR(250),
            	UserName NVARCHAR(800),
				ProfileImage NVARCHAR(800),
				UserId UNIQUEIDENTIFIER,
				[UniqueName] NVARCHAR(20),
				CreatedDateTime DATETIMEOFFSET,
				IsGoal BIT,
				IsSprint BIT,
				ConsiderEstimatedHours BIT,
                GoalId UNIQUEIDENTIFIER,
            	GoalName NVARCHAR(800),
                SprintId UNIQUEIDENTIFIER,
            	SprintName NVARCHAR(800),
                TestSuiteId UNIQUEIDENTIFIER,
            	TestSuiteName NVARCHAR(800),
                TemplateId UNIQUEIDENTIFIER,
            	TemplateName NVARCHAR(800),
                TestRunId UNIQUEIDENTIFIER,
            	TestRunName NVARCHAR(800),
                TimeZoneAbbreviation NVARCHAR(800),
				TimeZoneName NVARCHAR(800),
            )
            
            INSERT INTO #GoalActivityList(ProjectId,ProjectName,UserStoryOrGoalId,UserStoryOrGoalName,OldValue,NewValue,FieldName,[Description],[KeyValue],UserName,ProfileImage,UserId,[UniqueName],CreatedDateTime,IsGoal,ConsiderEstimatedHours,
                                          GoalId,GoalName,SprintId,SprintName,TestSuiteId,TestSuiteName,TemplateId,TemplateName,TestRunId,TestRunName,TimeZoneAbbreviation,
				TimeZoneName)
			SELECT P.Id,
                   P.ProjectName,
                   G.Id,
                   ISNULL(G.GoalName,G.GoalShortName),
            	   GH.OldValue,
            	   GH.NewValue,
            	   GH.FieldName,
            	   null,
            	   GH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   G.GoalUniqueName,
				   GH.CreatedDateTime,
				   1,
                   ISNULL(CH.IsEsimatedHours,0),
				   G.Id,
				   G.GoalName,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
				   TZ.TimeZoneName
            	   FROM GoalHistory GH
				   JOIN Goal G ON G.Id = GH.GoalId AND ProjectId IN (SELECT ProjectId FROM #Projects)
				   JOIN #Projects PP ON PP.ProjectId  = G.ProjectId
                   JOIN Project P ON G.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
                                                        AND (@GoalId IS NULL OR G.Id = @GoalId)
            	   JOIN [User] U ON U.Id = GH.CreatedByUserId AND U.InActiveDateTime IS NULL
                   LEFT JOIN ConsiderHours CH ON CH.Id = G.ConsiderEstimatedHoursId
                   LEFT JOIN TimeZone TZ ON TZ.Id = GH.CreatedDateTimeZoneId
            	   WHERE (@UserId IS NULL OR GH.CreatedByUserId = @UserId)
				       AND (@DateFrom IS NULL OR  CAST(GH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
				       AND (@DateTo IS NULL OR  CAST(GH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))
                         
				   UNION ALL 
            SELECT P.Id,
                   P.ProjectName,
                   US.Id,
                   US.UserStoryName,
            	   ISNULL(USH.OldValue,'null'),
            	   USH.NewValue,
            	   USH.FieldName,
            	   null,
            	   USH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   US.UserStoryUniqueName,
				   USH.CreatedDateTime,
				   0,
                   ISNULL(G.ConsiderEstimatedHours,0),
				   G.Id,
				   G.GoalName,
                   S.Id,
                   S.SprintName,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
				   TZ.TimeZoneName
            	   FROM UserStoryHistory USH
                   
                   JOIN UserStory US ON US.Id = USH.UserStoryId AND (@DateFrom IS NULL OR  CAST(USH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
						 AND (@DateTo IS NULL   OR  CAST(USH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date)) AND USH.[Description] != 'UserStoryViewed'  AND US.ProjectId IN (SELECT ProjectId FROM #Projects)  
				   JOIN Project P ON US.ProjectId = P.Id AND (@ProjectId IS NULL OR P.Id = @ProjectId)
            	    JOIN [User] U ON U.Id = USH.CreatedByUserId AND U.InActiveDateTime IS NULL  AND (@UserId IS NULL OR USH.CreatedByUserId = @UserId)
				   LEFT JOIN Goal G ON G.Id = US.GoalId
            	   LEFT JOIN Sprints S ON S.Id = US.SprintId AND ((@GoalId IS NULL AND @ProjectId IS NOT NULL) OR @IsFromActivity = 1)
                   LEFT JOIN TimeZone TZ ON TZ.Id = USH.CreatedDateTimeZoneId
                   WHERE  (@GoalId IS NULL OR G.Id = @GoalId) AND (S.Id IS NOT NULL OR G.Id IS NOT NULL)
				         

				   UNION ALL 
            SELECT P.Id,
                   P.ProjectName,
                   US.Id,
                   US.UserStoryName,
            	   null,
            	   null,
            	   null,
            	   C.[Comment],
            	   'Comment',
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   US.UserStoryUniqueName,
				   C.CreatedDateTime,
				   0
                   ,ISNULL(G.ConsiderEstimatedHours,0),
				   G.Id,
				   G.GoalName,
                   S.Id,
                   S.SprintName,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
				   TZ.TimeZoneName
            	   FROM Comment C
                   
                   JOIN UserStory US ON US.Id = C.ReceiverId  AND C.CompanyId = @CompanyId  AND US.ProjectId IN (SELECT ProjectId FROM #Projects)
				   JOIN Project P ON US.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
            	   JOIN [User] U ON U.Id = C.CreatedByUserId AND U.InActiveDateTime IS NULL
            	   AND (@UserId IS NULL OR C.CreatedByUserId = @UserId)
				   LEFT JOIN Goal G ON G.Id = US.GoalId 
                   LEFT JOIN TimeZone TZ ON TZ.Id = C.CreatedDateTimeZoneId
				   LEFT JOIN Sprints S ON S.Id = US.SprintId AND ((@GoalId IS NULL AND @ProjectId IS NOT NULL) OR @IsFromActivity = 1)
                   WHERE   (@GoalId IS NULL OR G.Id = @GoalId) AND (S.Id IS NOT NULL OR G.Id IS NOT NULL)
				           AND (@DateFrom IS NULL OR  CAST(C.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
						   AND (@DateTo IS NULL   OR  CAST(C.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))

			 UNION ALL 
            SELECT P.Id,
                   P.ProjectName,
                   G.Id,
                   G.GoalName,
            	   null,
            	   null,
            	   null,
            	   C.[Comment],
            	   'Comment',
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   G.GoalUniqueName,
				   C.CreatedDateTime,
				   0
                   ,ISNULL(G.ConsiderEstimatedHours,0),
				   G.Id,
				   G.GoalName,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
			       TZ.TimeZoneName
            	   FROM Comment C
                   JOIN Goal G ON G.Id = C.ReceiverId AND C.CompanyId = @CompanyId AND G.ProjectId IN (SELECT ProjectId FROM #Projects)
                   JOIN Project P ON G.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
                                                        AND (@GoalId IS NULL OR G.Id = @GoalId)
            	   JOIN [User] U ON U.Id = C.CreatedByUserId AND U.InActiveDateTime IS NULL
                   LEFT JOIN TimeZone TZ ON TZ.Id = C.CreatedDateTimeZoneId
            	   AND (@UserId IS NULL OR C.CreatedByUserId = @UserId)
				   AND (@DateFrom IS NULL OR  CAST(C.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
				   AND (@DateTo IS NULL   OR  CAST(C.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))
                   
			UNION ALL 
            SELECT P.Id,
                   P.ProjectName,
                   US.Id,
                   US.UserStoryName,
            	   CASE WHEN USH.OldValue LIKE '%{%:%' THEN (SELECT STUFF((SELECT ', ' + CAST([Key] + ' : ' + [Value] AS VARCHAR(MAX)) [text()]
				   FROM OPENJSON(USH.OldValue)
				   FOR XML PATH(''), TYPE)
				   .value('.','NVARCHAR(MAX)'),1,2,' ')) ELSE USH.OldValue END,
            	   CASE WHEN USH.NewValue LIKE '%{%:%' THEN (SELECT STUFF((SELECT ', ' + CAST([Key] + ' : ' + [Value] AS VARCHAR(MAX)) [text()]
				   FROM OPENJSON(USH.NewValue)
				   FOR XML PATH(''), TYPE)
				   .value('.','NVARCHAR(MAX)'),1,2,' ')) ELSE USH.NewValue END,
            	   NULL,
            	   null,
            	   USH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   US.UserStoryUniqueName,
				   USH.CreatedDateTime,
				   0,
                   ISNULL(G.ConsiderEstimatedHours,0),
				   G.Id,
				   G.GoalName,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
				   TZ.TimeZoneName
            FROM [CustomFieldHistory] USH
                 INNER JOIN UserStory US ON US.Id = USH.ReferenceId AND US.SprintId IS NULL 
				 JOIN #Projects PP ON PP.ProjectId = US.ProjectId
            	 INNER JOIN Goal G ON G.Id = US.GoalId
                 INNER JOIN Project P ON G.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
                                                      AND (@GoalId IS NULL OR G.Id = @GoalId)
                 LEFT JOIN TimeZone TZ ON TZ.Id = USH.CreatedDateTimeZoneId
            	 INNER JOIN [User] U ON U.Id = USH.CreatedByUserId AND U.InActiveDateTime IS NULL
            	   AND (@GoalId IS NULL OR G.Id = @GoalId) AND (@UserId IS NULL OR USH.CreatedByUserId = @UserId)
                   
                   AND (@DateFrom IS NULL OR  CAST(USH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
				   AND (@DateTo IS NULL   OR  CAST(USH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))
		UNION ALL
		SELECT P.Id,
               P.ProjectName,
               US.Id,
               US.UserStoryName,
               ISNULL(USH.OldValue,'null'),
               USH.NewValue,
               USH.FieldName,
               null,
               USH.[Description],
               U.FirstName + ' ' + ISNULL(U.SurName,''),
			   U.ProfileImage,
			   U.Id,
			   US.UserStoryUniqueName,
			   USH.CreatedDateTime,
			   0,
               ISNULL(G.ConsiderEstimatedHours,0),
			   G.Id,
			   G.GoalName,
               S.Id,
               S.SprintName,
               NULL,
               NULL,
               NULL,
               NULL,
               NULL,
               NULL,
               TZ.TimeZoneAbbreviation,
			   TZ.TimeZoneName
        FROM CronExpressionHistory USH 
               JOIN UserStory US ON US.Id = USH.CustomWidgetId AND US.SprintId IS NULL AND USH.[Description] != 'CronExpressionChanged' AND (@UserId IS NULL OR USH.CreatedByUserId = @UserId)
			           JOIN #Projects PP ON PP.ProjectId = US.ProjectId 
               JOIN Project P ON US.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
               JOIN [User] U ON U.Id = USH.CreatedByUserId AND U.InActiveDateTime IS NULL
                LEFT JOIN Goal G ON G.Id = US.GoalId
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND ((@GoalId IS NULL AND @ProjectId IS NOT NULL) OR @IsFromActivity = 1)
                LEFT JOIN TimeZone TZ ON TZ.Id = USH.CreatedDateTimeZoneId
				WHERE  (@GoalId IS NULL OR G.Id = @GoalId) AND (G.Id IS NOT NULL OR S.Id IS NOT NULL)
				    AND (@DateFrom IS NULL OR  CAST(USH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
				    AND (@DateTo IS NULL   OR  CAST(USH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))

            IF(@IsIncludeUserStoryView = 1)
            BEGIN
            
            INSERT INTO #GoalActivityList(ProjectId,ProjectName,UserStoryOrGoalId,UserStoryOrGoalName,OldValue,NewValue,FieldName,[Description],[KeyValue],UserName,ProfileImage,UserId,[UniqueName],CreatedDateTime,
                                          GoalId,GoalName,SprintId,SprintName,TestSuiteId,TestSuiteName,TemplateId,TemplateName,TestRunId,TestRunName,TimeZoneAbbreviation,TimeZoneName)
            SELECT P.Id,
                   P.ProjectName,
                   US.Id UserStoryId,
                   US.UserStoryName,
            	   USH.OldValue,
            	   USH.NewValue,
            	   USH.FieldName,
            	   null,
            	   USH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   US.UserStoryUniqueName,
				   USH.CreatedDateTime,
				   G.Id,
				   G.GoalName,
                   S.Id,
                   S.SprintName,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
			       TZ.TimeZoneName
            	   FROM UserStoryHistory USH
                   JOIN UserStory US ON US.Id = USH.UserStoryId AND (@DateFrom IS NULL OR  CAST(USH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
						 AND (@DateTo IS NULL   OR  CAST(USH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date)) AND US.SprintId IS NULL  AND USH.[Description] = 'UserStoryViewed' 
				   JOIN #Projects PP ON PP.ProjectId = US.ProjectId
            	   JOIN Project P ON US.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
				   JOIN [User] U ON U.Id = USH.CreatedByUserId AND U.InActiveDateTime IS NULL
            	            AND (@UserId IS NULL OR USH.CreatedByUserId = @UserId)
				   LEFT JOIN Goal G ON G.Id = US.GoalId
                   LEFT JOIN Sprints S ON S.Id = US.SprintId AND ((@GoalId IS NULL AND @ProjectId IS NOT NULL) OR @IsFromActivity = 1)
                   LEFT JOIN TimeZone TZ ON TZ.Id = USH.CreatedDateTimeZoneId
				   WHERE  (@GoalId IS NULL OR G.Id = @GoalId)
				         
            END
            
            IF(@IsIncludeLogTime = 1)
            BEGIN
            
            INSERT INTO #GoalActivityList(ProjectId,ProjectName,UserStoryOrGoalId,UserStoryOrGoalName,OldValue,NewValue,FieldName,[Description],[KeyValue],UserName,ProfileImage,UserId,[UniqueName],CreatedDateTime,
                                          GoalId,GoalName,SprintId,SprintName,TestSuiteId,TestSuiteName,TemplateId,TemplateName,TestRunId,TestRunName,TimeZoneAbbreviation,TimeZoneName)		
            SELECT P.Id,
                   P.ProjectName,
                   US.Id,
                   US.UserStoryName,
            	   null OldValue,
            	   CASE WHEN UST.SpentTimeInMin IS NOT NULL THEN  UST.SpentTimeInMin * 1.0 /60 * 1.0 
                        ELSE ISNULL(DATEDIFF(MINUTE, UST.StartTime, UST.EndTime)  * 1.0 /60 * 1.0,0)  END AS NewValue,
            	   null FieldName,
            	   UST.Comment,
            	   'UserStorySpentTime',
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   US.UserStoryUniqueName,
				   UST.CreatedDateTime,
				   G.Id,
				   G.GoalName,
                   S.Id,
                   S.SprintName,
				   NULL,
                   NULL,
		           NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
			       TZ.TimeZoneName
            	   FROM UserStorySpentTime UST
                   JOIN UserStory US ON US.Id = UST.UserStoryId AND US.SprintId IS NULL 
				   JOIN #Projects PP ON PP.ProjectId =  US.ProjectId 
            	    JOIN Project P ON US.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
				   JOIN [User] U ON U.Id = UST.CreatedByUserId AND U.InActiveDateTime IS NULL
                   JOIN TimeZone TZ ON TZ.Id = UST.CreatedDateTimeZoneId
            	   AND (@UserId IS NULL OR UST.CreatedByUserId = @UserId)
				   LEFT JOIN Goal G ON G.Id = US.GoalId 
				   LEFT JOIN Sprints S ON S.Id = US.SprintId AND ((@GoalId IS NULL AND @ProjectId IS NOT NULL) OR @IsFromActivity = 1)
                  WHERE  (@GoalId IS NULL OR G.Id = @GoalId)
				            AND (@DateFrom IS NULL OR  CAST(UST.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
							AND (@DateTo IS NULL   OR  CAST(UST.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))

            END
-----Sprint Activity
   IF((@GoalId IS NULL AND @ProjectId IS NOT NULL) OR @IsFromActivity = 1)
   BEGIN

			 INSERT INTO #GoalActivityList(ProjectId,ProjectName,UserStoryOrGoalId,UserStoryOrGoalName,OldValue,NewValue,FieldName,[Description],[KeyValue],UserName,ProfileImage,UserId,UniqueName,CreatedDateTime,IsSprint,
                                          GoalId,GoalName,SprintId,SprintName,TestSuiteId,TestSuiteName,TemplateId,TemplateName,TestRunId,TestRunName,TimeZoneAbbreviation,TimeZoneName)
			 SELECT P.Id,
                   P.ProjectName,
                   P.Id,
                   P.ProjectName,
            	   PH.OldValue,
            	   PH.NewValue,
            	   PH.FieldName,
            	   null,
            	   PH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   P.ProjectUniqueName,
				   PH.CreatedDateTime,
				   0,
				   NULL,
				   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
			       TZ.TimeZoneName
            FROM ProjectHistory PH
                 INNER JOIN Project P ON PH.ProjectId = P.Id AND P.CompanyId = @CompanyId 
				  JOIN #Projects PP ON PP.ProjectId = P.Id 
            	 INNER JOIN [User] U ON U.Id = PH.CreatedByUserId AND U.InActiveDateTime IS NULL
                 LEFT JOIN TimeZone TZ ON TZ.Id = PH.CreatedDateTimeZoneId
            WHERE (@UserId IS NULL OR PH.CreatedByUserId = @UserId)
			     AND (@DateFrom IS NULL OR  CAST(PH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
				 AND (@DateTo IS NULL   OR  CAST(PH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))
           
			UNION ALL 
			 SELECT P.Id,
                   P.ProjectName,
                   S.Id,
                   S.SprintName,
            	   SH.OldValue,
            	   SH.NewValue,
            	   SH.FieldName,
            	   null,
            	   SH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   NULL,
				   SH.CreatedDateTime,
				   1,
				   NULL,
				   NULL,
                   S.Id,
				   S.SprintName,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
			       TZ.TimeZoneName
            	   FROM SprintHistory SH
				   JOIN Sprints S ON S.Id = SH.SprintId 
				   JOIN #Projects PP ON PP.ProjectId = S.ProjectId
                   JOIN Project P ON P.Id = S.ProjectId AND (@ProjectId IS NULL OR P.Id = @ProjectId) AND P.CompanyId = @CompanyId
                                                 --  AND (@SprintId IS NULL OR SH.SprintId = @SprintId)
            	   JOIN [User] U ON U.Id = SH.CreatedByUserId AND U.InActiveDateTime IS NULL
                   LEFT JOIN TimeZone TZ ON TZ.Id = SH.CreatedDateTimeZoneId
            	   WHERE (@UserId IS NULL OR SH.CreatedByUserId = @UserId)
                      AND (@DateFrom IS NULL OR  CAST(SH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
					  AND (@DateTo IS NULL   OR  CAST(SH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))
				      
				   --UNION ALL 
       --     SELECT P.Id,
       --            P.ProjectName,
       --            US.Id,
       --            US.UserStoryName,
       --     	   ISNULL(USH.OldValue,'null'),
       --     	   USH.NewValue,
       --     	   USH.FieldName,
       --     	   null,
       --     	   USH.[Description],
       --     	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   --U.ProfileImage,
				   --U.Id,
				   --US.UserStoryUniqueName,
				   --USH.CreatedDateTime,
				   --0,
				   --NULL,
				   --NULL,
       --            S.Id,
				   --S.SprintName,
       --            NULL,
       --            NULL,
       --            NULL,
       --            NULL,
       --            NULL,
       --            NULL
       --     	   FROM UserStoryHistory USH
       --            JOIN UserStory US ON US.Id = USH.UserStoryId AND USH.[Description] <> 'UserStoryViewed' 
				   --JOIN #Projects PP ON PP.ProjectId = US.ProjectId 
       --     	   JOIN Sprints S ON S.Id = US.SprintId 
       --            JOIN Project P ON P.Id = S.ProjectId AND (@ProjectId IS NULL OR P.Id = @ProjectId) AND P.CompanyId = @CompanyId
       --                                           -- AND (@SprintId IS NULL OR S.Id = @SprintId)
       --     	   JOIN [User] U ON U.Id = USH.CreatedByUserId AND U.InActiveDateTime IS NULL
       --     	    AND (@UserId IS NULL OR USH.CreatedByUserId = @UserId)
                   
				 --  UNION ALL 
       --     SELECT P.Id,
       --            P.ProjectName,
       --            US.Id,
       --            US.UserStoryName,
       --     	   null,
       --     	   null,
       --     	   null,
       --     	   C.[Comment],
       --     	   'Comment',
       --     	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   --U.ProfileImage,
				   --U.Id,
				   --US.UserStoryUniqueName,
				   --C.CreatedDateTime,
				   --0,
				   --NULL,
				   --NULL,
       --            S.Id,
				   --S.SprintName,
       --            NULL,
       --            NULL,
       --            NULL,
       --            NULL,
       --            NULL,
       --            NULL
       --     	   FROM Comment C
       --            JOIN UserStory US ON US.Id = C.ReceiverId AND C.CompanyId = @CompanyId 
				   --JOIN #Projects PP ON PP.ProjectId = US.ProjectId 
       --     	   JOIN Sprints S ON S.Id = US.SprintId
       --            JOIN Project P ON P.Id = S.ProjectId AND (@ProjectId IS NULL OR P.Id = @ProjectId) AND P.CompanyId = @CompanyId
       --                                           -- AND (@SprintId IS NULL OR S.Id = @SprintId)
       --     	   JOIN [User] U ON U.Id = C.CreatedByUserId AND U.InActiveDateTime IS NULL
       --     	   AND (@UserId IS NULL OR C.CreatedByUserId = @UserId)
                   
			UNION ALL 
            SELECT P.Id,
                   P.ProjectName,
                   US.Id,
                   US.UserStoryName,
            	   CASE WHEN USH.OldValue LIKE '%{%:%' THEN (SELECT STUFF((SELECT ', ' + CAST([Key] + ' : ' + [Value] AS VARCHAR(MAX)) [text()]
				   FROM OPENJSON(USH.OldValue)
				   FOR XML PATH(''), TYPE)
				   .value('.','NVARCHAR(MAX)'),1,2,' ')) ELSE USH.OldValue END,
            	   CASE WHEN USH.NewValue LIKE '%{%:%' THEN (SELECT STUFF((SELECT ', ' + CAST([Key] + ' : ' + [Value] AS VARCHAR(MAX)) [text()]
				   FROM OPENJSON(USH.NewValue)
				   FOR XML PATH(''), TYPE)
				   .value('.','NVARCHAR(MAX)'),1,2,' ')) ELSE USH.NewValue END,
            	   NULL,
            	   null,
            	   USH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   US.UserStoryUniqueName,
				   USH.CreatedDateTime,
				   0,
				   NULL,
				   NULL,
                   S.Id,
				   S.SprintName,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
			       TZ.TimeZoneName
            FROM [CustomFieldHistory] USH
                 INNER JOIN UserStory US ON US.Id = USH.ReferenceId 
				 JOIN #Projects PP ON PP.ProjectId = US.ProjectId
            	 INNER JOIN Sprints S ON S.Id = US.SprintId 
                 INNER JOIN Project P ON P.Id = S.ProjectId AND (@ProjectId IS NULL OR P.Id = @ProjectId) AND P.CompanyId = @CompanyId
                                                -- AND (@SprintId IS NULL OR S.Id = @SprintId)
            	 INNER JOIN [User] U ON U.Id = USH.CreatedByUserId AND U.InActiveDateTime IS NULL
                 LEFT JOIN TimeZone TZ ON TZ.Id = USH.CreatedDateTimeZoneId
            	   AND (@UserId IS NULL OR USH.CreatedByUserId = @UserId)
				   AND (@DateFrom IS NULL OR  CAST(USH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
				   AND (@DateTo IS NULL   OR  CAST(USH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))
                 
			UNION ALL
			SELECT P.Id,
                   P.ProjectName,
                   TS.Id,
                   TS.TestSuiteName,
            	   PH.OldValue,
            	   PH.NewValue,
            	   PH.FieldName,
            	   null,
            	   PH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   P.ProjectUniqueName,
				   PH.CreatedDateTime,
				   0,
				   NULL,
				   NULL,
                   NULL,
                   NULL,
                   TS.Id,
                   TS.TestSuiteName,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
			       TZ.TimeZoneName
            FROM TestCaseHistory PH
			     INNER JOIN TestSuite TS ON TS.Id = PH.ReferenceId AND PH.[Description] != 'TestCaseViewed'
				 JOIN #Projects PP ON PP.ProjectId = TS.ProjectId
                 INNER JOIN Project P ON TS.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
            	 INNER JOIN [User] U ON U.Id = PH.CreatedByUserId AND U.InActiveDateTime IS NULL
                 LEFT JOIN TimeZone TZ ON TZ.Id = PH.CreatedDateTimeZoneId
			WHERE  (@UserId IS NULL OR PH.CreatedByUserId = @UserId)
			     AND (@DateFrom IS NULL OR  CAST(PH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
				 AND (@DateTo IS NULL   OR  CAST(PH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))
           
			UNION ALL
			SELECT P.Id,
                   P.ProjectName,
                   TSS.Id,
                   TSS.SectionName,
            	   PH.OldValue,
            	   PH.NewValue,
            	   PH.FieldName,
            	   null,
            	   PH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   P.ProjectUniqueName,
				   PH.CreatedDateTime,
				   0,
				   NULL,
				   NULL,
                   NULL,
                   NULL,
                   TS.Id,
                   TS.TestSuiteName,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
			       TZ.TimeZoneName
            FROM TestCaseHistory PH
			     INNER JOIN TestSuiteSection TSS ON TSS.Id = PH.ReferenceId AND  PH.[Description] != 'TestCaseViewed'
				 INNER JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId
				 JOIN #Projects PP ON PP.ProjectId = TS.ProjectId
                 INNER JOIN Project P ON TS.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
            	 INNER JOIN [User] U ON U.Id = PH.CreatedByUserId AND U.InActiveDateTime IS NULL
                 LEFT JOIN TimeZone TZ ON TZ.Id = PH.CreatedDateTimeZoneId
			WHERE  (@UserId IS NULL OR PH.CreatedByUserId = @UserId)
			    AND (@DateFrom IS NULL OR  CAST(PH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
				AND (@DateTo IS NULL   OR  CAST(PH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))
            
			UNION ALL
			SELECT P.Id,
                   P.ProjectName,
                   TS.Id,
                   TS.[Name],
            	   PH.OldValue,
            	   PH.NewValue,
            	   PH.FieldName,
            	   null,
            	   PH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   P.ProjectUniqueName,
				   PH.CreatedDateTime,
				   0,
				   NULL,
				   NULL,
                   NULL,
                   NULL,
                   TST.Id,
                   TST.TestSuiteName,
                   NULL,
                   NULL,
                   TS.Id,
                   TS.[Name],
                   TZ.TimeZoneAbbreviation,
			       TZ.TimeZoneName
            FROM TestCaseHistory PH
			     INNER JOIN TestRun TS ON TS.Id = PH.TestRunId AND PH.[Description] != 'TestCaseViewed' AND PH.[Description] != 'AddedToTestRun'
				 JOIN #Projects PP ON PP.ProjectId = TS.ProjectId
                 INNER JOIN Project P ON TS.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
				 INNER JOIN [User] U ON U.Id = PH.CreatedByUserId AND U.InActiveDateTime IS NULL
				 LEFT JOIN TestSuite TST ON TST.Id = TS.TestSuiteId
                 LEFT JOIN TimeZone TZ ON TZ.Id = PH.CreatedDateTimeZoneId
			WHERE   (@UserId IS NULL OR PH.CreatedByUserId = @UserId)
			     AND (@DateFrom IS NULL OR  CAST(PH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
				 AND (@DateTo IS NULL   OR  CAST(PH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))
            
			UNION ALL
			SELECT P.Id,
                   P.ProjectName,
                   TS.Id,
                   TS.[Name],
            	   PH.OldValue,
            	   PH.NewValue,
            	   PH.FieldName,
            	   null,
            	   PH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   P.ProjectUniqueName,
				   PH.CreatedDateTime,
				   0,
				   NULL,
				   NULL,
                   NULL,
                   NULL,
                   TST.Id,
                   TST.TestSuiteName,
                   NULL,
                   NULL,
                   TR.Id,
                   TR.[Name],
                   TZ.TimeZoneAbbreviation,
			       TZ.TimeZoneName
            FROM TestCaseHistory PH
			     INNER JOIN TestRailReport TS ON TS.Id = PH.ReferenceId AND  PH.[Description] != 'TestCaseViewed'
				 JOIN #Projects PP ON PP.ProjectId = TS.ProjectId
                 INNER JOIN Project P ON TS.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
            	 INNER JOIN [User] U ON U.Id = PH.CreatedByUserId AND U.InActiveDateTime IS NULL
				 LEFT JOIN TestRun TR ON TR.Id = TS.TestRunId
				 LEFT JOIN TestSuite TST ON TST.Id = TR.TestSuiteId
                 LEFT JOIN TimeZone TZ ON TZ.Id = PH.CreatedDateTimeZoneId
			WHERE  (@UserId IS NULL OR PH.CreatedByUserId = @UserId)
			    AND (@DateFrom IS NULL OR  CAST(PH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
				AND (@DateTo IS NULL   OR  CAST(PH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))
            
			UNION ALL
			SELECT P.Id,
                   P.ProjectName,
                   TS.Id,
                   TS.Title,
            	   PH.OldValue,
            	   PH.NewValue,
            	   PH.FieldName,
            	   null,
            	   PH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   P.ProjectUniqueName,
				   PH.CreatedDateTime,
				   0,
				   NULL,
				   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
			       TZ.TimeZoneName
            FROM TestCaseHistory PH
			     INNER JOIN Milestone TS ON TS.Id = PH.ReferenceId AND PH.[Description] != 'TestCaseViewed' 
				 JOIN #Projects PP ON PP.ProjectId  = TS.ProjectId
                 INNER JOIN Project P ON TS.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
            	 INNER JOIN [User] U ON U.Id = PH.CreatedByUserId AND U.InActiveDateTime IS NULL
                 LEFT JOIN TimeZone TZ ON TZ.Id = PH.CreatedDateTimeZoneId
			WHERE  (@UserId IS NULL OR PH.CreatedByUserId = @UserId)
			     AND (@DateFrom IS NULL OR  CAST(PH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
				 AND (@DateTo IS NULL   OR  CAST(PH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))
           
			UNION ALL
			SELECT P.Id,
                   P.ProjectName,
                   TC.Id,
                   TC.Title,
            	   PH.OldValue,
            	   PH.NewValue,
            	   PH.FieldName,
            	   null,
            	   PH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   P.ProjectUniqueName,
				   PH.CreatedDateTime,
				   0,
				   NULL,
				   NULL,
                   NULL,
                   NULL,
                   TS.Id,
                   TS.TestSuiteName,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
			       TZ.TimeZoneName
            FROM TestCaseHistory PH
			     INNER JOIN TestCase TC ON TC.Id = PH.TestCaseId AND PH.TestRunId IS NULL AND PH.FieldName <> 'TestCaseUpdated' AND PH.[Description] != 'TestCaseViewed' AND PH.[Description] != 'AddedToTestRun' 
			     INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId
				 INNER JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId 
				 JOIN #Projects PP ON PP.ProjectId = TS.ProjectId
                 INNER JOIN Project P ON TS.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
            	 INNER JOIN [User] U ON U.Id = PH.CreatedByUserId AND U.InActiveDateTime IS NULL
                 LEFT JOIN [TimeZone]TZ ON TZ.Id = PH.CreatedDateTimeZoneId
			WHERE  (@UserId IS NULL OR PH.CreatedByUserId = @UserId)
			    AND (@DateFrom IS NULL OR  CAST(PH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
				AND (@DateTo IS NULL   OR  CAST(PH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))
            
			UNION ALL 
            SELECT P.Id,
                   P.ProjectName,
                   US.Id,
                   US.UserStoryName,
            	   ISNULL(USH.OldValue,'null'),
            	   USH.NewValue,
            	   USH.FieldName,
            	   null,
            	   USH.[Description],
            	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   U.ProfileImage,
				   U.Id,
				   US.UserStoryUniqueName,
				   USH.CreatedDateTime,
				   0,
				   NULL,
				   NULL,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   G.Id,
                   G.TemplateName,
                   NULL,
                   NULL,
                   TZ.TimeZoneAbbreviation,
			       TZ.TimeZoneName
            	   FROM UserStoryHistory USH
                   JOIN UserStory US ON US.Id = USH.UserStoryId AND US.SprintId IS NULL AND (@DateFrom IS NULL OR  CAST(USH.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date))
				                                                                        AND (@DateTo IS NULL   OR  CAST(USH.CreatedDateTime AS DATE) <= CAST(@DateTo AS date))
				   JOIN #Projects PP ON PP.ProjectId = US.ProjectId
            	   JOIN Templates G ON G.Id = US.TemplateId
                   JOIN Project P ON G.ProjectId = P.Id AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
                                                        AND (@GoalId IS NULL OR G.Id = @GoalId)
            	   JOIN [User] U ON U.Id = USH.CreatedByUserId AND U.InActiveDateTime IS NULL
                   LEFT JOIN TimeZone TZ ON TZ.Id = USH.CreatedDateTimeZoneId
            	   AND USH.[Description] != 'UserStoryViewed' AND (@GoalId IS NULL OR G.Id = @GoalId) AND (@UserId IS NULL OR USH.CreatedByUserId = @UserId)
                  

			 --UNION ALL 
    --        SELECT P.Id,
    --               P.ProjectName,
    --               US.Id,
    --               US.UserStoryName,
    --        	   ISNULL(USH.OldValue,'null'),
    --        	   USH.NewValue,
    --        	   USH.FieldName,
    --        	   null,
    --        	   USH.[Description],
    --        	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				--   U.ProfileImage,
				--   U.Id,
				--   US.UserStoryUniqueName,
				--   USH.CreatedDateTime,
				--   0,
				--   NULL,
				--   NULL,
    --               S.Id,
    --               S.SprintName,
    --               NULL,
    --               NULL,
    --               NULL,
    --               NULL,
    --               NULL,
    --               NULL
    --        	   FROM CronExpressionHistory USH
    --               JOIN UserStory US ON US.Id = USH.CustomWidgetId 
				--   JOIN #Projects PP ON PP.ProjectId =US.ProjectId
    --        	   JOIN Sprints S ON S.Id = US.SprintId 
    --               JOIN Project P ON P.Id = S.ProjectId AND (@ProjectId IS NULL OR P.Id = @ProjectId) AND P.CompanyId = @CompanyId
    --                                              -- AND (@SprintId IS NULL OR S.Id = @SprintId)
    --        	   JOIN [User] U ON U.Id = USH.CreatedByUserId AND U.InActiveDateTime IS NULL
    --        	   AND USH.[Description] != 'CronExpressionChanged' AND (@UserId IS NULL OR USH.CreatedByUserId = @UserId)
                   
            
       --     IF(@IsIncludeUserStoryView = 1)
       --     BEGIN
            
       --     INSERT INTO #GoalActivityList(ProjectId,Projectname,UserStoryOrGoalId,UserStoryOrGoalName,OldValue,NewValue,FieldName,[Description],[KeyValue],UserName,ProfileImage,UserId,[UniqueName],CreatedDateTime,
       --                                   GoalId,GoalName,SprintId,SprintName,TestSuiteId,TestSuiteName,TemplateId,TemplateName,TestRunId,TestRunName)
       --     SELECT P.Id,
       --            P.ProjectName,
       --            US.Id UserStoryId,
       --            US.UserStoryName,
       --     	   USH.OldValue,
       --     	   USH.NewValue,
       --     	   USH.FieldName,
       --     	   null,
       --     	   USH.[Description],
       --     	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   --U.ProfileImage,
				   --U.Id,
				   --US.UserStoryUniqueName,
				   --USH.CreatedDateTime,
				   --NULL,
				   --NULL,
       --            S.Id,
       --            S.SprintName,
       --            NULL,
       --            NULL,
       --            NULL,
       --            NULL,
       --            NULL,
       --            NULL
       --     	   FROM UserStoryHistory USH
       --            JOIN UserStory US ON US.Id = USH.UserStoryId AND USH.[Description] = 'UserStoryViewed' AND (@ProjectId IS NULL OR US.ProjectId = @ProjectId)
       --     	   JOIN Sprints S ON S.Id = US.SprintId
       --            JOIN Project P ON P.Id = S.ProjectId  AND P.CompanyId = @CompanyId
       --                                           -- AND (@SprintId IS NULL OR S.Id = @SprintId)
       --     	   JOIN [User] U ON U.Id = USH.CreatedByUserId AND U.InActiveDateTime IS NULL
       --     	    AND (@UserId IS NULL OR USH.CreatedByUserId = @UserId)
       --            AND P.Id IN (SELECT ProjectId FROM #Projects )
       --     END
            
       --     IF(@IsIncludeLogTime = 1)
       --     BEGIN
            
       --     INSERT INTO #GoalActivityList(ProjectId,Projectname,UserStoryOrGoalId,UserStoryOrGoalName,OldValue,NewValue,FieldName,[Description],[KeyValue],UserName,ProfileImage,UserId,[UniqueName],CreatedDateTime,
       --                                   GoalId,GoalName,SprintId,SprintName,TestSuiteId,TestSuiteName,TemplateId,TemplateName,TestRunId,TestRunName)		
       --     SELECT P.Id,
       --            P.ProjectName,
       --            US.Id,
       --            US.UserStoryName,
       --     	   null OldValue,
       --     	   UST.SpentTimeInMin/60 NewValue,
       --     	   null FieldName,
       --     	   UST.Comment,
       --     	   'UserStorySpentTime',
       --     	   U.FirstName + ' ' + ISNULL(U.SurName,''),
				   --U.ProfileImage,
				   --U.Id,
				   --US.UserStoryUniqueName,
				   --UST.CreatedDateTime,
				   --NULL,
				   --NULL,
       --            S.Id,
       --            S.SprintName,
       --            NULL,
       --            NULL,
       --            NULL,
       --            NULL,
       --            NULL,
       --            NULL
       --     	   FROM UserStorySpentTime UST
       --            JOIN UserStory US ON US.Id = UST.UserStoryId 
       --     	   JOIN Sprints S ON S.Id = US.SprintId 
       --            JOIN Project P ON P.Id = S.ProjectId AND (@ProjectId IS NULL OR P.Id = @ProjectId) AND P.CompanyId = @CompanyId
       --                                           -- AND (@SprintId IS NULL OR S.Id = @SprintId)
       --     	   JOIN [User] U ON U.Id = UST.CreatedByUserId AND U.InActiveDateTime IS NULL
       --     	   AND (@UserId IS NULL OR UST.CreatedByUserId = @UserId)
       --            AND P.Id IN (SELECT ProjectId FROM #Projects )
       --     END
        
		END

            SELECT G.*,ISNULL(G.IsGoal,G.IsSprint) IsSprintOrGoal,TotalCount = COUNT(1) OVER()
			FROM #GoalActivityList G 
			ORDER BY G.CreatedDateTime DESC

			OFFSET ((@PageNo - 1) * @PageSize) ROWS
            FETCH NEXT @PageSize ROWS ONLY
            
            DROP TABLE #GoalActivityList 

	 END
	 ELSE
	    
		RAISERROR(@HavePermission,11,1)

     END TRY
     BEGIN CATCH
        
          THROW

    END CATCH
END