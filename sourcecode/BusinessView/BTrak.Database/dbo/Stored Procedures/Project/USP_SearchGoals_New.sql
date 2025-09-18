--  EXEC [dbo].[USP_SearchGoals_New] @OperationsPerformedBy='50E77AB2-44AC-4A7A-B4A5-EE11503A44AA',@PageSize = 100
--------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_SearchGoals_New]
(
  @GoalId UNIQUEIDENTIFIER = NULL,
  @GoalName   NVARCHAR(500) = NULL,
  @GoalShortName NVARCHAR(500) = NULL,
  @IsArchived BIT = NULL,
  @ArchivedDateTime DATETIMEOFFSET = NULL,
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @BoardTypeId UNIQUEIDENTIFIER = NULL,
  @BoardTypeApiId UNIQUEIDENTIFIER = NULL,
  @OnboardDate DATETIMEOFFSET = NULL,
  @GoalResponsiblePersonId UNIQUEIDENTIFIER = NULL,
  @ConfigurationId UNIQUEIDENTIFIER = NULL,
  @TobeTracked BIT = NULL,
  @IsProductiveBoard BIT = NULL,
  @ConsideredHoursId UNIQUEIDENTIFIER = NULL,
  @IsParked BIT = NULL,
  @ParkedDateTime DATETIMEOFFSET = NULL,
  @IsApproved BIT = NULL,
  @IsLocked BIT = NULL,
  @IsCompleted BIT = NULL,
  @GoalBudget MONEY = NULL,
  @GoalStatusId UNIQUEIDENTIFIER = NULL,
  @GoalStatus NVARCHAR(MAX) = NULL,
  @GoalStatusColor NVARCHAR(30) = NULL,
  @Version NVARCHAR(50)= NULL,
  @PageSize INT = 10,
  @PageNumber INT = 1,
  @GoalUniqueNumber NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsGoalsBasedOnGrp BIT = 0,
  @IsGoalsBasedOnProject BIT = 0,
  @SearchText NVARCHAR(100) = NULL,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection VARCHAR(50)=NULL,
  @GoalIdsXml XML = NULL,
  @IsBugBoard BIT = NULL,
  @IsUnique BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
		  IF(@ProjectId IS NULL)
		  BEGIN
		  IF(@IsUnique = 1)
		  BEGIN
		  SET @ProjectId = (SELECT DISTINCT ProjectId FROM Goal G INNEr JOIN Project P ON P.Id = G.ProjectId WHERE GoalUniqueName = 'G-9' AND P.CompanyId = '950C54FF-D0CF-47F4-994E-4408DB957C08')
		  END
		  ELSE
		  BEGIN
		  SET @ProjectId = (SELECT ProjectId FROM Goal WHERE Id = @GoalId)
		  END

		  END

          DECLARE @HavePermission NVARCHAR(250) =   (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

          IF (@HavePermission = '1')
          BEGIN

		  DECLARE @IsWarningLatest DECIMAL = (SELECT [value]  FROM [dbo].[CompanySettings] WHERE Id = '0418D622-7489-4BA3-8D7A-A72A2C1B800D')
          
          

		  DECLARE @EnableSprints BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableSprints%')
		  DECLARE @EnableTestRepo BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')
		  DECLARE @EnableBugBoards BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')

          
          SET @SearchText = CASE WHEN @SearchText LIKE 'tag:%' THEN   ('%' + (SELECT SUBSTRING(@SearchText,5,LEN(@SearchText))) + '%') ELSE   ('%'+ @SearchText+'%') END     
          
          IF(@SortDirection IS NULL )
          BEGIN
              SET @SortDirection = 'DESC'
          END
          
          DECLARE @OrderByColumn NVARCHAR(250) 
          
          IF(@SortBy IS NULL AND @IsGoalsBasedOnGrp = 1)
          BEGIN
        
              SET @SortBy = 'GoalResponsibleUserName'
        
          END
          IF(@SortBy IS NULL AND @IsGoalsBasedOnProject = 1)
          BEGIN
        
              SET @SortBy = 'ProjectName'
        
          END
          ELSE IF(@SortBy IS NULL)
          BEGIN
             SET @SortBy = 'CreatedDateTime'
          END
          ELSE
          BEGIN
          
               SET @SortBy = @SortBy
          
          END
          
          IF(@IsGoalsBasedOnGrp = 1)
          BEGIN
               SELECT G.GoalResponsibleUserId,
                      U.FirstName + ' ' + ISNULL(U.SurName,'') AS GoalResponsibleUserName,
                      U.ProfileImage AS GoalResponsibleProfileImage,
                      G1.CreatedDateTime AS OriginalCreatedDateTime,
                      (SELECT (SELECT G1.Id GoalId, 
                                      CASE WHEN (G1.GoalShortName IS NULL OR G1.GoalShortName = '') THEN G1.GoalName ELSE G1.GoalShortName END GoalName 
                       FROM [Goal] G1 
                            LEFT JOIN UserStory US ON US.GoalId = G1.Id 
                       WHERE G1.GoalResponsibleUserId = G.GoalResponsibleUserId 
                       GROUP BY G1.Id,G1.GoalName,G1.GoalShortName
                       FOR XML PATH('GoalApiReturnModel'), TYPE)FOR XML PATH('Goals'), TYPE) AS GoalsXml
               FROM Goal G
                    JOIN Goal G1 ON G1.Id = G.Id
                    INNER JOIN Project P ON G.ProjectId = P.Id
                    INNER JOIN [User] U ON G.GoalResponsibleUserId = U.Id AND U.[InActiveDateTime] IS NULL
               WHERE P.Id IN (SELECT UP.ProjectId FROM Userproject UP WHERE UP.UserId = @OperationsPerformedBy)
                     AND CONVERT(DATE,GETUTCDATE()) >= G.OnboardProcessDate 
                     AND (P.InActiveDateTime IS NULL) 
                     AND (G.InActiveDateTime IS NULL)
                     AND (G.ParkedDateTime IS NULL)
                     AND (P.CompanyId = @CompanyId) 
                     AND (@SearchText IS NULL 
                          OR (G.GoalName LIKE @SearchText) 
                          OR (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText)
                         ) 
               GROUP BY G.GoalResponsibleUserId, U.FirstName + ' ' + ISNULL(U.SurName,''),U.ProfileImage,G1.CreatedDateTime
               ORDER BY 
                    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'GoalResponsibleUserName') THEN  U.FirstName + ' ' + ISNULL(U.SurName,'')
                         END
                    END ASC,
                    CASE WHEN @SortDirection = 'DESC' THEN
                         CASE WHEN(@SortBy = 'GoalResponsibleUserName') THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
                         END
                    END DESC
                OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                
                FETCH NEXT @PageSize ROWS ONLY
          END
          ELSE IF(@IsGoalsBasedOnProject = 1)
          BEGIN
               SELECT G.ProjectId AS ProjectId,
                      P.ProjectName,
                     (SELECT (SELECT G1.Id GoalId, 
                                     CASE WHEN (G1.GoalShortName IS NULL OR G1.GoalShortName = '') THEN G1.GoalName ELSE G1.GoalShortName END GoalName 
                      FROM [Goal] G1 
                           LEFT JOIN UserStory US ON US.GoalId = G1.Id
                      WHERE G1.ProjectId = G.ProjectId
                      GROUP BY G1.Id,G1.GoalName,G1.GoalShortName
                      FOR XML PATH('GoalApiReturnModel'), TYPE)FOR XML PATH('Goals'), TYPE) AS GoalsXml
               FROM Goal G
                    INNER JOIN Project P ON G.ProjectId = P.Id AND GoalName <> 'Adhoc Goal' AND P.ProjectName <> 'Adhoc project'
               WHERE P.Id IN (SELECT UP.ProjectId FROM Userproject UP WHERE UP.UserId = @OperationsPerformedBy)
                     AND CONVERT(DATE,GETUTCDATE()) >= OnboardProcessDate 
                     AND (G.InActiveDateTime IS NULL)
                     AND (G.ParkedDateTime IS NULL)
                     AND (P.CompanyId = @CompanyId) 
                     AND (@SearchText IS NULL 
                          OR (G.GoalName LIKE @SearchText)
                          OR (P.ProjectName LIKE @SearchText)
                         ) 
               GROUP BY G.ProjectId,P.ProjectName
               ORDER BY 
                    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'ProjectName') THEN ProjectName
                         END
                    END ASC,
                    CASE WHEN @SortDirection = 'DESC' THEN
                         CASE WHEN(@SortBy = 'ProjectName') THEN ProjectName
                         END
                    END DESC
          END
          ELSE
          BEGIN
          IF(@GoalName = '') SET @GoalName = NULL
          
          IF(@GoalShortName = '') SET @GoalShortName = NULL
          
          IF(@GoalId = '00000000-0000-0000-0000-000000000000') SET @GoalId = NULL
          
          IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL
          
          IF(@BoardTypeApiId = '00000000-0000-0000-0000-000000000000') SET @BoardTypeApiId = NULL
          
          IF(@GoalResponsiblePersonId = '00000000-0000-0000-0000-000000000000') SET @GoalResponsiblePersonId = NULL
          
          IF(@BoardTypeId = '00000000-0000-0000-0000-000000000000') SET @BoardTypeId = NULL
          
          IF(@ConfigurationId = '00000000-0000-0000-0000-000000000000') SET @ConfigurationId = NULL
          
          IF(@ConsideredHoursId = '00000000-0000-0000-0000-000000000000') SET @ConsideredHoursId = NULL
          
          IF(@GoalBudget = '') SET @GoalBudget = NULL
          
          IF(@GoalStatusId = '00000000-0000-0000-0000-000000000000') SET @GoalStatusId = NULL
          
          IF(@GoalStatusColor = '') SET @GoalStatusColor = NULL
          
          IF(@Version = '') SET @Version = NULL
        
          CREATE TABLE #GoalIds
          (
                Id UNIQUEIDENTIFIER
          )
          IF(@GoalIdsXml IS NOT NULL) 
          BEGIN
            
            SET @GoalId = NULL
            INSERT INTO #GoalIds(Id)
            SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
            FROM @GoalIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
          END
          SELECT G.Id AS GoalId,
                 G.ProjectId,
                 G.BoardTypeId,
                 G.BoardTypeApiId,
                 G.GoalBudget,
                 G.GoalName,
                 G.GoalStatusId,
                 G.GoalShortName,
                 CASE WHEN G.GoalStatusColor IS NULL THEN '#ffffff'
                    ELSE G.GoalStatusColor
                END AS GoalStatusColor,
                 G.IsLocked,
                 G.IsProductiveBoard,
                 G.IsToBeTracked,
                 G.OnboardProcessDate,
                 G.IsApproved,
                 G.IsCompleted,
                 G.ParkedDateTime,
                 G.InActiveDateTime,
                 G.[Version],
                 G.GoalResponsibleUserId,
                 TS.Id TestSuiteId,
                 TS.TestSuiteName,
                 GRU.FirstName + ' ' + GRU.SurName GoalResponsibleUserName,
                 GRU.ProfileImage AS GoalResponsibleProfileImage,
                 G.ConfigurationId,
                 --CT.ConfigurationTypeName,
                 G.ConsiderEstimatedHoursId,
                 CH.ConsiderHourName,
                 G.CreatedByUserId,
                 G.CreatedDateTime,
                 G.UpdatedByUserId,
                 G.UpdatedDateTime,
                 GS.GoalStatusName,
                 G.[Description],
                 G.Tag,
                 GS.IsParked GoalStatusIsParked,
                 CASE WHEN GS.InactiveDateTime IS NULL THEN 0 ELSE 1 END AS GoalStatusIsarchived,
                 BT.IsBugBoard,
                 BT.IsSuperAgileBoard,
                 BT.IsDefault,
                 BT.BoardTypeName,
                 CASE WHEN BT.InactiveDateTime IS NULL THEN 0 ELSE 1 END AS BoardTypeIsArchived,
                -- CASE WHEN CT.InactiveDateTime IS NULL THEN 0 ELSE 1 END AS ConfigurationIsArchived,
                 P.ProjectName,
                 CASE WHEN P.InactiveDateTime IS NULL THEN 0 ELSE 1 END AS ProjectIsArchived,
                 P.ProjectStatusColor,
                 P.IsDateTimeConfiguration,
				 @EnableSprints AS IsSprintsConfiguration,
				 @EnableTestRepo AS IsEnableTestRepo,
                 P.ProjectResponsiblePersonId,
                 U.UserName,
                 U.SurName,
                 U.Firstname,
                 U.IsActive UserIsActive,
                 U.IsAdmin,
                 U.ProfileImage,
                 U.CompanyId,
                 G.GoalUniqueName,
				 G.[Description],
				 G.GoalUniqueName,
				 G.EndDate,
				 G.GoalEstimatedTime GoalEstimateTime,
				 --(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStory US1 ON US.ParentUserStoryId = US1.Id
				 --                                                       AND US.InActiveDateTime IS NULL
					--								INNER JOIN UserStoryStatus USSS ON USSS.Id = US.UserStoryStatusId AND USSS.InactiveDateTime IS NULL
					--								INNER JOIN [TaskStatus] TS ON TS.Id = USSS.TaskStatusId AND TS.[Order] NOT IN (4,6)
					--								INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InactiveDateTime IS NULL
					--								INNER JOIN [Goal]G1 ON G1.Id = US.GoalId AND G1.InActiveDateTime IS NULL AND G1.ParkedDateTime IS NULL
					--								LEFT JOIN [UserStoryScenario]USS ON USS.TestCaseId = US.TestCaseId AND USS.InactiveDateTime IS NULL
					--								LEFT JOIN [TestCase]TC ON TC.Id = USS.TestCaseId  AND TC.InactiveDateTime IS NULL
					--								LEFT JOIN [TestSuiteSection]TSS ON TSS.Id = TC.SectionId  AND TSS.InactiveDateTime IS NULL AND TSS.TestSuiteId = g.TestSuiteId
					--													WHERE US1.GoalId = G.Id AND US.ParkedDateTime IS NULL AND US.ArchivedDateTime IS NULL  AND US1.ArchivedDateTime IS NULL
					--													       AND UST.IsBug = 1 AND (US.TestCaseId IS NULL OR (USS.TestCaseId IS NOT NULL AND TSS.Id IS NOT NULL))
					--														   --AND (USSS.IsVerified <> 1 OR USSS.IsVerified IS NULL)
					--													)BugsCount,
				 BugsCount =(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStory US1 ON /*US1.ParentUserStoryId =US.Id*/US1.GoalId =G.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				                AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL AND (@IsArchived = 0 OR @IsArchived IS NULL)
				 			 INNER JOIN UserStoryStatus USS ON US1.UserStoryStatusId = USS.Id AND USS.InactiveDateTime IS NULL AND USS.Companyid = @CompanyId
                                AND USS.TaskStatusId NOT IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76')
				 			 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1
				 			 INNER JOIN Goal G1 ON G1.Id = US1.GoalId AND G1.InActiveDateTime IS NULL AND G1.ParkedDateTime IS NULL AND (@IsArchived = 0 OR @IsArchived IS NULL)
				 			 INNER JOIN BoardType BT1 ON BT1.Id = G1.BoardTypeId AND BT1.CompanyId =  @CompanyId
				 			 WHERE G.Id <> G1.Id AND (@ProjectId IS NULL OR G1.ProjectId =  @ProjectId) AND (@IsArchived = 0 OR @IsArchived IS NULL)),
                 G.[TimeStamp],
     --            (SELECT MAX (DeadLineDate) FROM UserStory US WHERE US.GoalId = G.Id AND ParkedDateTime IS NULL AND (InActiveDateTime IS NULL) GROUP BY GoalId) AS GoalDeadLine ,
     --            (SELECT SUM (US.EstimatedTime) FROM UserStory US WHERE US.GoalId = G.Id AND ParkedDateTime IS NULL AND (InActiveDateTime IS NULL)  GROUP BY GoalId)  AS GoalEstimatedTime,     
				 --CASE WHEN EXISTS(SELECT 1 FROM UserStory US WHERE US.GoalId = G.Id AND US.ArchivedDateTime IS NULL 
				 --                 AND  ParkedDateTime IS NULL AND US.EstimatedTime>@IsWarningLatest --(US.EstimatedTime IS NULL OR US.DeadLineDate IS NULL OR US.EstimatedTime>@IsWarningLatest) 
					--			  AND US.InActiveDateTime IS NULL
					--			  AND ISNULL(BT.IsBugBoard,0) <> 1) 
     --                 THEN 1 ELSE 0 END IsWarning,
	             CASE WHEN ISNULL( GDetails.WarningCount,0) >0 AND  ISNULL(BT.IsBugBoard,0) <> 1 THEN 1 ELSE 0 END IsWarning,                
				 GDetails.GoalDeadLine,
				 GDetails.GoalEstimatedTime,
                 WF.Id AS WorkFlowId,
                 WF.WorkFlow AS WorkFlowName,
                 BT.BoardTypeUIId AS BoardTypeUiId,
                 CASE WHEN G.ParkedDateTime IS NULL THEN NULL
                      ELSE 1
                 END AS IsParked,
                 --(SELECT COUNT(1) FROM UserStory US 
                 --                 JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND USS.InactiveDateTime IS NULL AND USS.Companyid = @CompanyId
                 --                 JOIN TaskStatus TS ON USS.TaskStatusId = TS.Id AND (TS.[Order] NOT IN (4,6))
                 --                 WHERE ((US.GoalId = G.Id AND BT.IsBugBoard = 1) OR (US.GoalId = G.Id  AND US.ParentUserStoryId IS NULL AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))
                 --                  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                 --                  AND US.ArchivedDateTime IS NULL) ActiveUserStoryCount,
				 ISNULL(ActiveUserStoryCount,0) ActiveUserStoryCount,
                 TotalCount = COUNT(1) OVER()
          FROM [dbo].[Goal] G
               INNER JOIN [dbo].[BoardType] BT ON BT.Id = G.BoardTypeId AND BT.CompanyId = @CompanyId AND G.GoalName <> 'Adhoc Goal' AND (@IsBugBoard IS NULL OR BT.IsBugBoard = @IsBugBoard)
			INNER JOIN [dbo].[BoardTypeUi] BTU ON BTU.Id = BT.BoardTypeUiID
               INNER JOIN [dbo].[Project] P ON P.Id = G.ProjectId AND P.InactiveDateTime IS NULL
			   LEFT JOIN (SELECT MAX (US.DeadLineDate)GoalDeadLine,
			                     SUM (US.EstimatedTime)GoalEstimatedTime,US.GoalId,
								 COUNT(CASE WHEN ((US.EstimatedTime IS NULL OR US.EstimatedTime = 0.00) OR US.DeadLineDate IS NULL OR US.OwnerUserId IS NULL
			                          ) THEN 1 END) WarningCount
			                      FROM UserStory US JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id 
								  AND USS.InactiveDateTime IS NULL AND USS.Companyid = @CompanyId        
			             WHERE  US.ParkedDateTime IS NULL AND (US.InActiveDateTime IS NULL ) GROUP BY US.GoalId)GDetails ON GDetails.GoalId= G.Id             
               LEFT JOIN  [dbo].[TestSuite]TS ON TS.Id = G.TestSuiteId AND TS.InactiveDateTime IS NULL
               LEFT JOIN [dbo].[User] U ON U.Id = G.CreatedByUserId AND U.[InActiveDateTime] IS NULL
               LEFT JOIN [dbo].[GoalStatus] GS ON GS.Id = G.GoalStatusId
               LEFT JOIN [User] GRU ON G.GoalResponsibleUserId = GRU.Id AND GRU.[InActiveDateTime] IS NULL
               --LEFT JOIN [dbo].[ConfigurationType] CT ON CT.Id = G.ConfigurationId
               LEFT JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
               LEFT JOIN [dbo].[BoardTypeWorkFlow] BTW ON BTW.BoardTypeId = BT.Id
               LEFT JOIN [dbo].[WorkFlow] WF ON WF.Id = BTW.WorkflowId
               LEFT JOIN #GoalIds GInner ON GInner.Id = G.Id

			   LEFT JOIN (SELECT US1.GoalId,COUNT(1) ActiveUserStoryCount
			              FROM UserStory US1 
                               INNER JOIN [dbo].[Goal] G1 on G1.Id = US1.GoalId
                               INNER JOIN [dbo].[BoardType] BT ON BT.Id = G1.BoardTypeId AND BT.CompanyId = @CompanyId AND G1.GoalName <> 'Adhoc Goal'
                               INNER JOIN UserStoryStatus USS ON US1.UserStoryStatusId = USS.Id AND USS.InactiveDateTime IS NULL AND USS.Companyid = @CompanyId
                               INNER JOIN TaskStatus TS ON USS.TaskStatusId = TS.Id AND (TS.[Order] NOT IN (4,6))
                          WHERE (( BT.IsBugBoard = 1) OR ( US1.ParentUserStoryId IS NULL AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))
                                 AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
                                 AND US1.ArchivedDateTime IS NULL
						  GROUP BY US1.GoalId) ASInner ON ASInner.GoalId = G.Id

               --LEFT JOIN (SELECT GoalId , Count(1) NoEstmatesCountVal FROM UserStory WHERE (EstimatedTime IS NULL OR DeadLineDate IS NULL)
                        --                      AND ArchivedDateTime IS NULL AND ParkedDateTime IS NULL GROUP BY GoalId) FTInner ON FTInner.GoalId = G.Id
          WHERE  P.Id IN (SELECT UP.ProjectId FROM Userproject UP WHERE UP.UserId = @OperationsPerformedBy)
                 AND (@GoalName IS NULL OR G.GoalName = @GoalName) 
                 AND (@GoalShortName IS NULL OR G.GoalShortName = @GoalShortName)
     --            AND ((@IsUnique IS NOT NULL AND @GoalId IS NULL) OR G.Id = @GoalId) 
				 --AND ((@IsUnique IS NULL AND @GoalId IS NULL)  OR G.GoalUniqueName = @GoalId) 
				 AND (@GoalId IS NULL OR G.Id = @GoalId) 
                 AND (@GoalIdsXml IS NULL OR GInner.Id IS NOT NULL)
                 AND (@IsArchived IS NULL OR (@IsArchived = 0 AND (GS.IsArchived = 0 AND (G.InActiveDateTime IS NULL))) 
                                               OR (@IsArchived = 1 AND GS.IsArchived = 1 AND (G.InActiveDateTime IS NOT NULL)))
                 AND (@ArchivedDateTime IS NULL OR G.InActiveDateTime = @ArchivedDateTime)
                 AND (P.CompanyId = @CompanyId) 
                 AND (@ProjectId IS NULL OR G.ProjectId = @ProjectId) 
                 AND (@BoardTypeApiId IS NULL OR G.BoardTypeApiId = @BoardTypeApiId) 
                 AND (@OnboardDate IS NULL OR CONVERT(DATE,G.OnboardProcessDate) = @OnboardDate)
                 AND (@GoalResponsiblePersonId IS NULL OR G.GoalResponsibleUserId = @GoalResponsiblePersonId)
                 AND (@BoardTypeId IS NULL OR G.BoardTypeId = @BoardTypeId) 
                 AND (@ConfigurationId IS NULL OR G.ConfigurationId = @ConfigurationId)
                 AND (@TobeTracked IS NULL OR G.IsToBeTracked = @TobeTracked) 
                 AND (@IsProductiveBoard IS NULL OR G.IsProductiveBoard = @IsProductiveBoard)
                 AND (@ConsideredHoursId IS NULL OR G.ConsiderEstimatedHoursId = @ConsideredHoursId) 
                 AND (@GoalUniqueNumber IS NULL OR G.GoalUniqueName = @GoalUniqueNumber)
                 AND (@IsApproved IS NULL OR G.IsApproved = @IsApproved)
                 AND (@GoalBudget IS NULL OR G.GoalBudget = @GoalBudget)
                 AND (@GoalStatusId IS NULL OR G.GoalStatusId = @GoalStatusId)
                 AND (@GoalStatusColor IS NULL OR G.GoalStatusColor = @GoalStatusColor)
                 AND (@IsLocked IS NULL OR G.IsLocked = @IsLocked)
                 AND (@IsParked IS NULL OR (@IsParked = 0 AND (GS.IsParked IS NULL OR GS.IsParked = 0)) OR (@IsParked = 1 AND GS.IsParked = 1))
                 AND (@IsCompleted IS NULL OR G.IsCompleted = @IsCompleted)
                 AND (@ParkedDateTime IS NULL OR G.ParkedDateTime = @ParkedDateTime)
                 AND (@Version IS NULL OR G.[Version] = @Version)
				 AND (@EnableBugBoards = 1 OR ((@EnableBugBoards = 0 OR @EnableBugBoards IS NULL) AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULl)))
                 AND (@SearchText IS NULL 
                      OR (G.GoalName LIKE @SearchText)
                      OR (G.GoalShortName LIKE @SearchText)
                      OR (G.Tag LIKE  @SearchText)
                      OR (GRU.FirstName + ' ' + GRU.SurName LIKE @SearchText)
                      OR (P.ProjectName LIKE @SearchText)
                      --OR (CT.ConfigurationTypeName LIKE @SearchText)
                      OR (GS.GoalStatusName LIKE @SearchText)
                      OR (U.Firstname LIKE @SearchText)
                      OR (U.SurName LIKE @SearchText)
                      OR (WF.WorkFlow LIKE @SearchText)
                    )
                AND (@GoalStatus IS NULL OR ( LTRIM(RTRIM(GS.GoalStatusName)) IN (SELECT LTRIM(RTRIM(Id)) FROM UfnSplit(@GoalStatus)) ))
               ORDER BY G.GoalName ,
                    
					CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'GoalName') THEN GoalName
                              WHEN(@SortBy = 'GoalShortName') THEN GoalShortName
                              WHEN @SortBy = 'ProjectName' THEN ProjectName
                              WHEN @SortBy = 'GoalResponsibleUserName' THEN GRU.FirstName + ' ' + GRU.SurName
                              --WHEN @SortBy = 'ConfigurationTypeName' THEN ConfigurationTypeName
                              WHEN @SortBy = 'WorkFlow' THEN WorkFlow
                              WHEN @SortBy = 'CreatedDateTime' THEN Cast(G.CreatedDateTime as sql_variant)
                              WHEN @SortBy = 'OnBoardProcessDate' THEN Cast(G.OnboardProcessDate as sql_variant)
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                          CASE WHEN(@SortBy = 'GoalName') THEN GoalName
                              WHEN(@SortBy = 'GoalShortName') THEN GoalShortName
                              WHEN @SortBy = 'ProjectName' THEN ProjectName
                              WHEN @SortBy = 'GoalResponsibleUserName' THEN GRU.FirstName + ' ' + GRU.SurName
                              --WHEN @SortBy = 'ConfigurationTypeName' THEN ConfigurationTypeName
                              WHEN @SortBy = 'WorkFlow' THEN WorkFlow
                              WHEN @SortBy = 'CreatedDateTime' THEN Cast(G.CreatedDateTime as sql_variant)   
                              WHEN @SortBy = 'OnBoardProcessDate' THEN Cast(G.OnboardProcessDate as sql_variant)
                          END
                      END DESC
                OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                
                FETCH NEXT @PageSize ROWS ONLY
        END
       
	   END
       ELSE
       BEGIN
       
              RAISERROR (@HavePermission,11, 1)
              
       END 
    END TRY  
    BEGIN CATCH 
    
          THROW
        
    END CATCH
END