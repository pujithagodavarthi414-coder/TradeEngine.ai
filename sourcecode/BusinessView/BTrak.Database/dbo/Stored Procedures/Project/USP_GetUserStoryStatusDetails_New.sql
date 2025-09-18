-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-09 00:00:00.000'
-- Purpose      To Get the UserStory Status Details By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStoryStatusDetails_New] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@Date='2019-07-01',@Type='Month',@PageSize=100
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserStoryStatusDetails_New]
(
  @Type VARCHAR(50),
  @Date DATETIME,
  @IsReportingOnly BIT = NULL,
  @IsMyself BIT = NULL,
  @IsAll BIT = 1,
  @SortDirection NVARCHAR(250) = NULL,
  @SearchText NVARCHAR(250 )= NULL,
  @SortBy NVARCHAR(200) = NULL,
  @PageNumber INT = 1,
  @PageSize INT = 10,
  @EntityId UNIQUEIDENTIFIER = NULL,
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
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
                DECLARE @DateFrom DATETIME
                DECLARE @DateTo DATETIME
                DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
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
				IF(@SortDirection IS NULL )
	            BEGIN
	    	        SET @SortDirection = 'DESC'
	            END
				IF(@SortBy IS NULL )
	            BEGIN
	    	        SET @SortBy = 'ReOpen'
	            END
				SET @SearchText = '%'+ @SearchText +'%'
				SELECT UD.UserId,
					   UD.UserName,
					   UD.UserProfileImage,
				       UD.ProjectName,
					   UD.GoalShortName,
					   UD.SprintName,
				       UD.UserStoryId,
				       UD.UserStoryName,
				       UD.CurrentStatus,
					   UD.ReOpen,
					   UD.IsFromSprint  IsFromSprint,
					   TotalCount = COUNT(1) OVER(),
					   UD.ProjectId
				       FROM
				       (
							SELECT COUNT(UW.UserStoryId) ReOpen
							       ,UW.UserStoryId
								   ,P.ProjectName
								   ,G.GoalShortName 
								   ,S.SprintName
								   ,US.UserStoryName
								   ,U.FirstName + ' ' + ISNULL(U.SurName,'') UserName
								   ,U.Id UserId
								   ,U.ProfileImage UserProfileImage
								   ,USS.[Status] CurrentStatus
								  ,CASE WHEN US.SprintId IS NOT NULL THEN 1 ELSE 0 END AS IsFromSprint
								  ,P.Id AS ProjectId
							FROM UserStory US
							      INNER JOIN Project P ON P.Id = US.ProjectId
							                AND P.InactiveDateTime IS NULL AND P.CompanyId = @CompanyId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
							      LEFT JOIN Goal G ON G.Id = US.GoalId
							                AND US.InactiveDateTime IS NULL AND US.ParkedDateTime IS NULL
							                AND G.InactiveDateTime IS NULL
											AND CONVERT(DATE,US.DeadLineDate) >= @DateFrom AND CONVERT(DATE,US.DeadLineDate) <= @DateTo
								  LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
								            AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
								  LEFT JOIN Sprints S ON S.Id = US.SprintId
								            AND (S.IsReplan = 0  OR S.IsReplan IS NULL) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete = 0 OR S.IsComplete IS NULL)
											AND CONVERT(DATE,S.SprintStartDate) >= @DateFrom AND CONVERT(DATE,S.SprintEndDate) <= @DateTo
								  INNER JOIN [User] U ON U.Id = US.OwnerUserId 
								            AND U.InActiveDateTime IS NULL AND U.IsActive = 1
								  INNER JOIN [Employee] E ON E.UserId = U.Id 
								  INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
										AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
										AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
										AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
                                  INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
								            AND USS.InActiveDateTime IS NULL
							      INNER JOIN UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId
							      INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId
								  INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId
								             AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B' --PendingVerification
								  INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
								             AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0' --Inprogress
							     WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								      AND ((@IsReportingOnly = 1 AND
									   US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (@OperationsPerformedBy,@CompanyId) WHERE ChildId <>  @OperationsPerformedBy) OR (@IsMyself = 1 AND US.OwnerUserId = @OperationsPerformedBy) OR @IsAll = 1 ))
							GROUP BY UW.UserStoryId,P.ProjectName,G.GoalShortName,S.SprintName,US.UserStoryName,U.FirstName,P.Id,
							 U.SurName,USS.[Status],U.Id,U.ProfileImage,US.SprintId
						) UD
				        WHERE (@SearchText IS NULL
								  OR(UD.UserName LIKE @SearchText)
				                  OR(UD.ProjectName LIKE @SearchText)
				                  OR(UD.GoalShortName LIKE @SearchText)
								  OR(UD.SprintName LIKE @SearchText)
				                  OR(UD.UserStoryName LIKE @SearchText)
				                  OR(UD.CurrentStatus LIKE @SearchText)
								  OR(CONVERT(NVARCHAR(250),ISNULL(UD.ReOpen,0)) LIKE @SearchText)
				                  )
						AND UD.ReOpen > 0
				           ORDER BY
							 CASE WHEN (@SortDirection IS NULL OR  @SortDirection = 'DESC') THEN
				                CASE WHEN(@SortBy IS NULL OR @SortBy = 'userName') THEN UD.UserName
				                     WHEN @SortBy = 'projectName' THEN UD.ProjectName
				                     WHEN @SortBy = 'goal' THEN UD.GoalShortName
									 WHEN @SortBy = 'sprint' THEN UD.SprintName
				                     WHEN @SortBy = 'userStory' THEN UD.UserStoryName
				                     WHEN @SortBy = 'currentStatus' THEN UD.CurrentStatus
									 WHEN @SortBy = 'reOpen' THEN  CAST(UD.ReOpen as sql_variant)
				                END
				           END DESC,
				           CASE WHEN @SortDirection = 'ASC' THEN
				                CASE WHEN(@SortBy IS NULL OR @SortBy = 'userName') THEN UD.UserName
				                     WHEN @SortBy = 'projectName' THEN UD.ProjectName
				                     WHEN @SortBy = 'goal' THEN UD.GoalShortName
									 WHEN @SortBy = 'sprint' THEN UD.SprintName
				                     WHEN @SortBy = 'userStory' THEN UD.UserStoryName
				                     WHEN @SortBy = 'currentStatus' THEN UD.CurrentStatus
									 WHEN @SortBy = 'reOpen' THEN  CAST(UD.ReOpen as sql_variant)
				                END
				           END ASC
						  OFFSET ((@PageNumber - 1) * @PageSize) ROWS
				          FETCH NEXT @PageSize ROWS ONLY
		END
		--ELSE
		--BEGIN

	 --   	RAISERROR (@HavePermission,11, 1)
		
		--END
		END
     END TRY
     BEGIN CATCH
           THROW
    END CATCH
END
GO