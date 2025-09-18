-------------------------------------------------------------------------------
-- Author       Surya
-- Created      '2020-04-13 00:00:00.000'
-- Purpose      To Get the Productivity Index user stories For Developers
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--exec USP_GetEmployeeIndexUserStoriesForDevelopers @Type='Month',@OperationsPerformedBy='E4A64ABB-4198-4F0A-A639-9C6EE06FF07E'
--,@UserId='4BD71148-F06F-4F55-8FAF-46E95092E114',@IndexType='Replan',@Date='2020-04-13'

CREATE PROCEDURE [dbo].[USP_GetEmployeeIndexUserStoriesForDevelopers]
(
   @Type VARCHAR(100),
   @Date DATETIME,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @UserId UNIQUEIDENTIFIER,
   @IndexType VARCHAR(100),
   @IsAll BIT = 1,
   @IsReportingOnly BIT = NULL,
   @IsMyself BIT = NULL,
   @ProjectId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	DECLARE @DateFrom DATETIME,@DateTo DATETIME

			IF(@Type = 'Month')
				BEGIN

				   SELECT @DateFrom = DATEADD(MONTH, DATEDIFF(MONTH, 0, @Date), 0)

				   SELECT @DateTo = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @Date) + 1, 0))

				END
				ELSE IF(@Type = 'Week')
				BEGIN

				   SELECT @DateTo = DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Date), CAST(@Date AS DATE))

				   SELECT @DateFrom = DATEADD(dd, -(DATEPART(dw, @DateTo)-1), CAST(@DateTo AS DATE))

				END
				IF(@DateTo >= CONVERT(DATE,GETUTCDATE()))
				BEGIN

				   SELECT @DateTo = CONVERT(DATE,GETUTCDATE())

				END

			CREATE TABLE #ProductiveHours 
			   (
			   		UserId UNIQUEIDENTIFIER,
					UserName NVARCHAR(500),
			   		UserStoryId UNIQUEIDENTIFIER,
			   		EstimatedTime NUMERIC(10,2),
			   		GoalId UNIQUEIDENTIFIER,
			   		UserStoryReplanCount NUMERIC(10,2),
			   		GRPIndex FLOAT,
			   		ReopenedCount INT,
			   		CompletedUserStoresCountByUserId INT,
			   		QAApprovedUserStoriesCountByUserId INT,
			   		ReopenedUserStoresCountByUserId INT,
			   		UserStoriesBouncedBackOnceCountByUserId INT,
			   		UserStoriesBouncedBackMoreThanOnceCountByUserId INT,
			   		ISForQA INT
			   )
			
			INSERT INTO #ProductiveHours(UserName,UserId,UserStoryId,EstimatedTime,ISForQA)
			SELECT U.FirstName + ' ' + ISNULL(U.SurName,''),PIN.UserId,PIN.UserStoryId,SUM(PIN.ProductivityIndex),0
			FROM ProductivityIndex PIN 
				 INNER JOIN [User] U ON U.Id = PIN.UserId
			WHERE PIN.CompanyId = @CompanyId
			     AND PIN.[Date] BETWEEN @DateFrom AND @DateTo
				 AND PIN.UserStoryId IS NOT NULL 
			GROUP BY U.FirstName,U.SurName,PIN.UserId,PIN.UserStoryId --,PIN.ProductivityIndex

			UPDATE #ProductiveHours SET GoalId = US.GoalId
			FROM #ProductiveHours PH 
			     INNER JOIN UserStory US ON US.Id = PH.UserStoryId

			UPDATE #ProductiveHours SET ReopenedCount = PHInner.ReopenedCount
			FROM #ProductiveHours PH
			     LEFT JOIN (SELECT COUNT(UW.UserStoryId) ReopenedCount,UW.UserStoryId FROM #ProductiveHours PH 
			     INNER JOIN UserStoryWorkflowStatusTransition UW ON PH.UserStoryId = UW.UserStoryId 
			     INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId 
			     INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId 
			                AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B'
			     INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId 
			                AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'
			GROUP BY UW.UserStoryId) PHInner ON PH.UserStoryId = PHInner.UserStoryId 
			
			UPDATE #ProductiveHours SET CompletedUserStoresCountByUserId = CompletedUserStorycount,
			                            QAApprovedUserStoriesCountByUserId = QAApprovedUserStories,
			                            ReopenedUserStoresCountByUserId = ISNULL(ReopenedUserStoresCount,0),
			                            UserStoriesBouncedBackOnceCountByUserId = UserStoriesBouncedBackOnceCount,
			                            UserStoriesBouncedBackMoreThanOnceCountByUserId = ISNULL(ReopenedUserStoresCount,0) - UserStoriesBouncedBackOnceCount
			FROM #ProductiveHours PH
			     INNER JOIN (SELECT UserId,
			                        COUNT(UserStoryId) CompletedUserStorycount,
			                        SUM(ISForQA) AS QAApprovedUserStories,
								    COUNT(CASE WHEN ReopenedCount > 0 THEN 1 ELSE NULL END) AS ReopenedUserStoresCount,
								    COUNT(CASE WHEN ReopenedCount = 1 THEN 1 ELSE NULL END) AS UserStoriesBouncedBackOnceCount
			                 FROM #ProductiveHours
			                 GROUP BY UserId) PHInner ON PHInner.UserId = PH.UserId
				  
			UPDATE #ProductiveHours SET UserStoryReplanCount = ISNULL(ReplanCount,0)
			FROM #ProductiveHours PH
			     INNER JOIN (SELECT COUNT(USR.UserStoryId) AS ReplanCount,USR.UserStoryId
			                 FROM #ProductiveHours PH
			                      LEFT JOIN UserStoryReplan USR ON USR.UserStoryId = PH.UserStoryId
			                 GROUP BY USR.UserStoryId) PHInner ON PHInner.UserStoryId = PH.UserStoryId 
							  
			INSERT INTO #ProductiveHours(UserName,UserId)
			SELECT  U.FirstName + ' ' + ISNULL(U.SurName,''),U.Id 
			FROM [User] U  
			WHERE U.InactiveDateTime IS NULL AND U.IsActive = 1
			AND NOT EXISTS(SELECT 1 FROM #ProductiveHours WHERE UserId = U.Id)

			UPDATE #ProductiveHours SET GRPIndex = ISNULL(PIDInner.GRPIndex,0)
			FROM #ProductiveHours PID
			     LEFT JOIN (SELECT GoalResponsibleUserId, SUM(PUS.EstimatedTime) GRPIndex
			                FROM #ProductiveHours PUS
			                     INNER JOIN Goal G ON G.Id = PUS.GoalId AND G.GoalResponsibleUserId <> PUS.UserId
			                GROUP BY GoalResponsibleUserId) PIDInner ON PIDInner.GoalResponsibleUserId = PID.UserId

		IF(@IndexType = 'ProductivityIndex')
			BEGIN
					SELECT p.ProjectName,p.Id AS ProjectId,g.GoalName,us.Id UserStoryId ,us.UserStoryName,us.UserStoryUniqueName,us.EstimatedTime
					,s.Id SprintId,S.SprintName SprintName
					FROM #ProductiveHours ph
					INNER JOIN UserStory us ON us.Id=ph.UserStoryId
					INNER JOIN Project p ON p.Id = us.ProjectId
					LEFT JOIN Goal g ON g.Id=us.GoalId
					LEFT JOIN Sprints S on S.Id = US.SprintId
					
					WHERE UserId=@UserId
					AND (@ProjectId IS NULL OR @ProjectId = p.Id)
			END

			IF(@IndexType = 'GrpIndex')
			BEGIN

				
					SELECT g.Id GoalId,p.Id AS ProjectId,g.GoalName,SUM(us.EstimatedTime) GoalGrpTotal
					FROM #ProductiveHours ph
					INNER JOIN UserStory us ON us.Id=ph.UserStoryId
					INNER JOIN Goal g ON g.Id=ph.GoalId
					LEFT JOIN Sprints S on S.Id = US.SprintId
					INNER JOIN Project p ON p.Id = g.ProjectId
					WHERE g.GoalResponsibleUserId =@UserId AND us.OwnerUserId  <> @UserId
					AND (@ProjectId IS NULL OR @ProjectId = p.Id)
					group by g.Id,g.GoalName,p.Id
			END

			IF(@IndexType = 'Completed')
			BEGIN
					SELECT p.ProjectName,p.Id AS ProjectId,g.GoalName,us.Id UserStoryId ,us.UserStoryName,us.UserStoryUniqueName,us.EstimatedTime
					,s.Id SprintId,S.SprintName SprintName
					FROM #ProductiveHours ph
					INNER JOIN UserStory us ON us.Id=ph.UserStoryId
					INNER JOIN Project p ON p.Id = us.ProjectId
					LEFT JOIN Goal g ON g.Id=us.GoalId
					LEFT JOIN Sprints S on S.Id = US.SprintId
					WHERE UserId=@UserId
					AND (@ProjectId IS NULL OR @ProjectId = p.Id)
			END

			IF(@IndexType ='BouncedStories')
			BEGIN
					SELECT p.ProjectName,p.Id AS ProjectId,g.GoalName,us.Id UserStoryId ,us.UserStoryName,us.UserStoryUniqueName,us.EstimatedTime
					,s.Id SprintId,S.SprintName SprintName
					FROM #ProductiveHours ph
					INNER JOIN UserStory us ON us.Id=ph.UserStoryId
					INNER JOIN Project p ON p.Id = us.ProjectId
					LEFT JOIN Goal g ON g.Id=us.GoalId
					LEFT JOIN Sprints S on S.Id = US.SprintId
					WHERE UserId=@UserId AND ReopenedCount > 0
					AND (@ProjectId IS NULL OR @ProjectId = p.Id)
			END

			IF(@IndexType ='QaApproved')
			BEGIN
					SELECT p.ProjectName,p.Id AS ProjectId,g.GoalName,us.Id UserStoryId ,us.UserStoryName,us.UserStoryUniqueName,us.EstimatedTime
					,s.Id SprintId,S.SprintName SprintName
					FROM #ProductiveHours ph
					INNER JOIN UserStory us ON us.Id=ph.UserStoryId
					INNER JOIN Project p ON p.Id = us.ProjectId
					LEFT JOIN Goal g ON g.Id=us.GoalId
					LEFT JOIN Sprints S on S.Id = US.SprintId
					WHERE UserId=@UserId
					AND (@ProjectId IS NULL OR @ProjectId = p.Id)
			END

			IF(@IndexType ='BouncedOnce')
			BEGIN
					SELECT p.ProjectName,p.Id AS ProjectId,g.GoalName,us.Id UserStoryId ,us.UserStoryName,us.UserStoryUniqueName,us.EstimatedTime
					,s.Id SprintId,S.SprintName SprintName
					FROM #ProductiveHours ph
					INNER JOIN UserStory us ON us.Id=ph.UserStoryId
					INNER JOIN Project p ON p.Id = us.ProjectId
					LEFT JOIN Goal g ON g.Id=us.GoalId
					LEFT JOIN Sprints S on S.Id = US.SprintId
					WHERE UserId=@UserId AND ReopenedCount = 1
					AND (@ProjectId IS NULL OR @ProjectId = p.Id)
			END

			IF(@IndexType ='BouncedMoreThenOnce')
			BEGIN
					SELECT p.ProjectName,p.Id AS ProjectId,g.GoalName,us.Id UserStoryId ,us.UserStoryName,us.UserStoryUniqueName,us.EstimatedTime
					,s.Id SprintId,S.SprintName SprintName
					FROM #ProductiveHours ph
					INNER JOIN UserStory us ON us.Id=ph.UserStoryId
					INNER JOIN Project p ON p.Id = us.ProjectId
					LEFT JOIN Goal g ON g.Id=us.GoalId
					LEFT JOIN Sprints S on S.Id = US.SprintId
					WHERE UserId=@UserId AND ReopenedCount > 1
					AND (@ProjectId IS NULL OR @ProjectId = p.Id)
			END

			IF(@IndexType ='Replan')
			BEGIN
					SELECT p.ProjectName,p.Id AS ProjectId,g.GoalName,us.Id UserStoryId ,us.UserStoryName,us.UserStoryUniqueName,us.EstimatedTime
					,s.Id SprintId,S.SprintName SprintName
					FROM #ProductiveHours PH
					INNER JOIN UserStory us ON us.Id=ph.UserStoryId
					INNER JOIN Project p ON p.Id = us.ProjectId
					LEFT JOIN Goal g ON g.Id=us.GoalId
					LEFT JOIN Sprints S on S.Id = US.SprintId
					INNER JOIN UserStoryReplan USR ON USR.USERSTORYID = PH.USERSTORYID
					WHERE USERID=@UserId
					AND (@ProjectId IS NULL OR @ProjectId = p.Id)
			END
			DROP TABLE #ProductiveHours

	END TRY 
	BEGIN CATCH 
		
		 THROW

	END CATCH

END