-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-29 00:00:00.000'
-- Purpose      To Get QA Performance By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_TimeOfTesting_New] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@Type='Month',
-- @Date='2019-03-01',@SortBy = 'Age'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_TimeOfTesting_New]
(
  @Type VARCHAR(100),
  @Date DATETIME,
  @TimeZone NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @PageNumber INT = 1,
  @PageSize INT = 10,
  @SearchText VARCHAR(500) = NULL,
  @SortBy NVARCHAR(250) = NULL,
  @EntityId UNIQUEIDENTIFIER = NULL,
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @SortDirection NVARCHAR(50) = NULL,
  @IsReportingOnly BIT = NULL,
  @IsMyself BIT = NULL,
  @IsAll BIT = 1
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		IF(@Type = '') SET @Type = NULL

		IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

		IF(@Type IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Date period')

		END
		ELSE IF(@Date IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Date')

		END
		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN

			DECLARE @TimeZoneId UNIQUEIDENTIFIER = (SELECT Id FROM TimeZone WHERE TimeZone = @TimeZone)

			DECLARE @DateFrom DATETIME
			DECLARE @DateTo DATETIME

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

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
			IF(@SortDirection IS NULL )
			BEGIN				
				SET @SortDirection = 'DESC'				
			END
				
			DECLARE @OrderByColumn NVARCHAR(250) 
				
			IF(@SortBy IS NULL)
			BEGIN				
				SET @SortBy = 'Latest Deployed Date'				
			END
			ELSE
			BEGIN				
				SET @SortBy = @SortBy				
			END

			SET @SearchText = '%'+ @SearchText +'%'

			SELECT T.UserStoryId,
				    T.UserStoryName,
				    T.ProjectName,
				    T.GoalName,
					T.SprintName,
				    T.TesterName,
					T.UserId,
					T.ProfileImage,
				    T.StatusId,
				    T.StatusName,
				    T.OriginalDeployedDate,
					T.OriginalDeployedDateTimeZoneAbbreviation,
				    T.ActionDate,
					T.ActionDateTimeZoneAbbreviation,
				    T.LatestDeployedDate,
					T.LatestDeployedDateTimeZoneAbbreviation,
					T.OriginalDeployedDateTimeZoneName,
					T.LatestDeployedDateTimeZoneName,
					T.ActionDateTimeZoneName,
				    T.Age,
					T.TotalCount,
					T.IsFromSprint
			FROM(

				SELECT US.Id UserStoryId,
				       US.UserStoryName,
				       P.ProjectName,
				       G.GoalName, 
					   S.SprintName,
				       U.FirstName+' ' +ISNULL(U.SurName,'') TesterName,
					   U.Id UserId,
					   U.ProfileImage,
				       US.UserStoryStatusId StatusId,
				       USS.[Status] StatusName,
				       WST1.OldDeployedDate OriginalDeployedDate,
					   TZD2.TimeZoneAbbreviation OriginalDeployedDateTimeZoneAbbreviation,
				       TZD2.TimeZoneName OriginalDeployedDateTimeZoneName,
				       WST1.DeployedDate ActionDate,
					   TZ1.TimeZoneAbbreviation ActionDateTimeZoneAbbreviation,
				       TZ1.TimeZoneName ActionDateTimeZoneName ,
				       WST1.DeployedDate LatestDeployedDate,
					   TZD1.TimeZoneAbbreviation LatestDeployedDateTimeZoneAbbreviation,
				       TZD1.TimeZoneName LatestDeployedDateTimeZoneName,
				       DATEDIFF(DAY,OldDeployedDate,DeployedDate) Age,
					   TotalCount = COUNT(1) OVER(),
					   CASE WHEN US.SprintId IS NOT NULL THEN 1 ELSE 0 END AS IsFromSprint
				      FROM UserStory US 
				     --      INNER JOIN UserStoryWorkflowStatusTransition USW ON USW.UserStoryId = US.Id
				     --      INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USW.WorkflowEligibleStatusTransitionId 
						   --INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId
						   --      AND FUSS.InactiveDateTime IS NULL AND FUSS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B'
				     --      INNER JOIN UserStoryWorkflowStatusTransition USW1 ON USW1.UserStoryId = US.Id
					    --   INNER JOIN WorkflowEligibleStatusTransition WFEST1 ON WFEST1.Id = USW1.WorkflowEligibleStatusTransitionId 
						   --INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST1.ToWorkflowUserStoryStatusId 
					    --              AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B'
					       LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
						   LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId  AND GS.IsActive = 1 
						   LEFT JOIN Sprints S ON S.Id = US.SprintId AND  S.InActiveDateTime IS NULL AND (S.IsReplan = 0 OR S.IsReplan IS NULL AND S.SprintStartDate IS NOT NULL AND (S.IsComplete = 0 AND S.IsComplete = 1))
				           INNER JOIN Project P ON (P.Id = G.ProjectId OR S.ProjectId = P.Id) AND P.CompanyId = @CompanyId
						   AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL)
				          INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id

						    LEFT JOIN(SELECT US.Id,MAX(USWTD.CreatedDateTime) AS DeployedDate,MIN(USWTD.CreatedDateTime)OldDeployedDate
		                    FROM Project P
		                      JOIN UserStory US ON US.ProjectId = P.Id 
							      --AND (@UserId IS NULL OR US.OwnerUserId = @UserId)
		                          --AND (@LineManagerId IS NULL OR (US.OwnerUserId IN (SELECT ChildId FROM #EmployeeReportedMembers)))
							      AND (@DateFrom IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom))
								  AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,US.DeadLineDate) <= @DateTo))
								  --AND (@CreateDateFrom IS NULL OR (CONVERT(DATE,US.CreatedDateTime) >= @CreateDateFrom))
								  --AND (@CreateDateTo IS NULL OR (CONVERT(DATE,US.CreatedDateTime) <= @CreateDateTo))  --AND US.DeadLineDate IS NOT NULL
							  JOIN UserStoryWorkflowStatusTransition USWTD ON USWTD.UserStoryId = US.Id AND USWTD.InActiveDateTime IS NULL
		                          AND (@DateFrom IS NULL OR (USWTD.CreatedDateTime  IS NOT NULL AND CONVERT(DATE,USWTD.CreatedDateTime) >= @DateFrom))
								  AND (@DateTo IS NULL OR (US.DeadLineDate IS NOT NULL AND CONVERT(DATE,USWTD.CreatedDateTime) <= @DateTo))
		                      JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWTD.WorkflowEligibleStatusTransitionId AND WEST.InActiveDateTime IS NULL 
							  JOIN UserStoryStatus USS ON USS.Id = WEST.ToWorkflowUserStoryStatusId AND USS.CompanyId = @CompanyId AND USS.TaskStatusId ='5C561B7F-80CB-4822-BE18-C65560C15F5B'
							--  JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] = 3                                                                    
							  GROUP BY US.Id) WST1 ON WST1.Id = US.Id
		              INNER JOIN UserStoryWorkflowStatusTransition USWTD ON USWTD.CreatedDateTime = WST1.DeployedDate AND USWTD.UserStoryId = WST1.Id
		              INNER JOIN TimeZone TZD1 ON TZD1.Id = USWTD.TransitionTimeZone
					  INNER JOIN UserStoryWorkflowStatusTransition USWTD1 ON USWTD.CreatedDateTime = WST1.OldDeployedDate AND USWTD.UserStoryId = WST1.Id
		              INNER JOIN TimeZone TZD2 ON TZD2.Id = USWTD1.TransitionTimeZone
					  INNER JOIN [User] U ON U.Id = USWTD1.CreatedByUserId AND U.InActiveDateTime IS NULL
						   INNER JOIN [Employee] E ON E.UserId = U.Id 
						   INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
						              AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
						              AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
				           
					  INNER JOIN UserStoryWorkflowStatusTransition USWTD2 ON USWTD.CreatedDateTime = WST1.DeployedDate AND USWTD.UserStoryId = WST1.Id
		              INNER JOIN TimeZone TZ1 ON TZ1.Id = USWTD2.TransitionTimeZone
					    
						
					  WHERE CAST(USWTD.TransitionDateTime AS DATE) <= @DateTo 
					       AND CAST(USWTD.TransitionDateTime AS DATE) >= @DateFrom 
						   AND U.IsActive = 1 
						   AND (@ProjectId IS NULL OR US.ProjectId = @ProjectId)
					       AND CAST(USWTD1.TransitionDateTime AS DATE) <= USWTD.TransitionDateTime
						   AND (US.ArchiveddateTime IS NULL AND US.InActiveDateTime IS NULL)
						   AND (US.ParkedDateTime IS NULL)
						   AND (@SearchText IS NULL 
					            OR ProjectName LIKE @SearchText
					            OR GoalShortName LIKE @SearchText
					            OR GoalName LIKE @SearchText
							    OR SprintName LIKE @SearchText
					            OR UserStoryName LIKE @SearchText
					            OR FirstName LIKE @SearchText
					            OR Surname LIKE @SearchText
							    OR U.FirstName+' ' +ISNULL(U.SurName,'') LIKE @SearchText
					            OR USS.[Status] LIKE @SearchText
					            OR DATEDIFF(DD,(USWTD1.TransitionDateTime),(USWTD.TransitionDateTime)) LIKE @SearchText
								OR FORMAT(US.DeadLineDate,'dd-MMM-yyyy') LIKE @SearchText
							    OR FORMAT(USWTD.TransitionDateTime,'dd-MMM-yyyy') LIKE @SearchText
							    OR FORMAT(USWTD1.TransitionDateTime,'dd-MMM-yyyy') LIKE @SearchText
							    OR FORMAT(US.DeadLineDate,'d-MMM-yyyy') LIKE @SearchText
							    OR FORMAT(USWTD.TransitionDateTime,'d-MMM-yyyy') LIKE @SearchText
							    OR FORMAT(USWTD1.TransitionDateTime,'d-MMM-yyyy') LIKE @SearchText)
					     AND ((@IsReportingOnly = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) WHERE ChildId <>  @OperationsPerformedBy) OR (@IsMyself = 1 AND U.Id = @OperationsPerformedBy) OR @IsAll = 1 ))
				    GROUP BY US.Id,US.UserStoryName,US.UserStoryStatusId,USS.[Status],P.ProjectName,G.GoalName,S.SprintName,US.DeadLineDate, WST1.OldDeployedDate, WST1.DeployedDate,TZ1.TimeZoneAbbreviation,TZ1.TimeZoneName,TZD1.TimeZoneAbbreviation,TZD1.TimeZoneName,TZD2.TimeZoneAbbreviation,TZD2.TimeZoneName,U.FirstName+' ' +ISNULL(U.SurName,'') ,US.SprintId, U.Id, U.ProfileImage

					 ) T
					 ORDER BY 
					 CASE WHEN @SortDirection = 'ASC' THEN
					      CASE WHEN @SortBy = 'ProjectName' THEN T.ProjectName
					           WHEN @SortBy = 'GoalName' THEN T.GoalName
							   WHEN @SortBy = 'SprintName' THEN T.SprintName
					           WHEN @SortBy = 'UserStory' THEN T.UserStoryName 
					           WHEN @SortBy = 'CurrentStatus' THEN T.StatusName
							   WHEN @SortBy = 'TesterName' THEN T.TesterName
							   WHEN @SortBy = 'OriginalDeployedDate' THEN CAST(T.OriginalDeployedDate AS SQL_VARIANT)
							   WHEN @SortBy = 'LatestDeployedDate' THEN CAST(T.LatestDeployedDate AS SQL_VARIANT)
							   WHEN @SortBy = 'QAActiondate' THEN CAST(T.ActionDate AS SQL_VARIANT)
							   WHEN @SortBy = 'Age' THEN CAST(T.Age AS SQL_VARIANT)
					      END   
					 END ASC,
					 CASE WHEN @SortDirection = 'DESC' THEN
					      CASE WHEN @SortBy = 'ProjectName' THEN T.ProjectName
					           WHEN @SortBy = 'GoalName' THEN T.GoalName
							   WHEN @SortBy = 'SprintName' THEN T.SprintName
					           WHEN @SortBy = 'UserStory' THEN T.UserStoryName 
					           WHEN @SortBy = 'CurrentStatus' THEN T.StatusName
							   WHEN @SortBy = 'TesterName' THEN T.TesterName
							   WHEN @SortBy = 'OriginalDeployedDate' THEN CAST(T.OriginalDeployedDate AS SQL_VARIANT)
							   WHEN @SortBy = 'LatestDeployedDate' THEN CAST(T.LatestDeployedDate AS SQL_VARIANT)
							   WHEN @SortBy = 'QAActiondate' THEN CAST(T.ActionDate AS SQL_VARIANT)
							   WHEN @SortBy = 'Age' THEN CAST(T.Age AS SQL_VARIANT)
					      END 
	 				 END DESC

					 OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
					     
					 FETCH NEXT @PageSize ROWS ONLY
			END
			ELSE
			RAISERROR (@HavePermission,11, 1)

	END        

	END TRY  
	BEGIN CATCH
		THROW
	END CATCH
END
GO