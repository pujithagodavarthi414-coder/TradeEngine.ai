CREATE PROCEDURE [dbo].[USP_SearchSprints]
@SprintId UNIQUEIDENTIFIER = NULL,
@ProjectId  UNIQUEIDENTIFIER = NULL,
@SprintName NVARCHAR(1000) = NULL,
@SprintUniqueNumber nvarchar(50) = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
@SearchText NVARCHAR(100) = NULL,
@PageSize INT = 1000,
@PageNumber INT = 1,
@IsBacklog BIT = NULL,
@IsComplete BIT = NULL,
@AllSprints BIT = NULL,
@SprintIdsXml XML = NULL
AS
BEGIN

SET NOCOUNT ON

BEGIN TRY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
         
DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

DECLARE @EnableSprints BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableSprints%')
DECLARE @EnableTestRepo BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')

IF(@SearchText = '') SET @SearchText = NULL

IF(@SprintName = '') SET @SprintName = NULL

IF (@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL

        CREATE TABLE #SprintIds
        (
           Id UNIQUEIDENTIFIER
        )

        IF(@SprintIdsXml IS NOT NULL)
        BEGIN
              SET @SprintId = NULL

              INSERT INTO #SprintIds(Id)
              SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
              FROM @SprintIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
        END

SET @SearchText = ('%'+ @SearchText+'%')

IF(@AllSprints = 1)
BEGIN

    SELECT S.Id AS SprintId,
      S.SprintName,
      S.ProjectId,
      S.SprintStartDate,
      S.SprintEndDate,
      S.CreatedByUserId,
      S.CreatedDateTime,
      S.InActiveDateTime,
      S.IsReplan,
      S.Description,
      P.ProjectName,
      P.ProjectResponsiblePersonId,
      @EnableSprints AS IsEnableSprints,
      @EnableTestRepo AS IsEnableTestRepo,
      S.BoardTypeId,
      S.BoardTypeApiId,
      S.TestSuiteId,
      S.IsComplete,
      CAST(S.SprintCompletedDate AS DATETIME) AS CompletedSprintDate,
      S.Version,
      BT.IsBugBoard,
      BT.IsSuperAgileBoard,
      BT.IsDefault,
      BT.BoardTypeName,
      BT.BoardTypeUIId AS BoardTypeUiId,
      WF.Id AS WorkFlowId,
                   WF.WorkFlow AS WorkFlowName,
      S.TimeStamp,
      S.SprintUniqueName,
      S.SprintResponsiblePersonId,
      U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedUserName,
      SRU.FirstName + ' ' + ISNULL(SRU.SurName,'') AS SprintResponsiblePersonName,
      SRU.ProfileImage,
      PRU.UserName,
      PRU.FirstName + ' ' + ISNULL(PRU.SurName, '') AS ProjectResponsiblePersonName,
      TotalCount = COUNT(1) OVER(),

      CASE WHEN EXISTS (SELECT 1 FROM UserStory US
                        WHERE US.SprintId = S.Id AND US.ArchivedDateTime IS NULL
                              AND ParkedDateTime IS NULL AND (US.EstimatedTime IS NULL AND US.SprintEstimatedTime IS NULL)
              AND US.InActiveDateTime IS NULL
              AND ISNULL(BT.IsBugBoard,0) <> 1)
      THEN 1 ELSE 0 END IsWarning,

    (SELECT COUNT(1)
    FROM UserStory US
                          INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND USS.InactiveDateTime IS NULL AND USS.CompanyId = @CompanyId
                          INNER JOIN TaskStatus TS ON USS.TaskStatusId = TS.Id
                     WHERE ((US.SprintId = S.Id AND BT.IsBugBoard = 1) OR (US.SprintId = S.Id AND US.ParentUserStoryId IS NULL AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))
                             AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                             AND US.ArchivedDateTime IS NULL) UserStoriesCount,

    (SELECT COUNT(1)
    FROM UserStory US
                          INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND USS.InactiveDateTime IS NULL AND USS.Companyid = @CompanyId
                          INNER JOIN TaskStatus TS ON USS.TaskStatusId = TS.Id AND (TS.[Order] IN (4,6))
                     WHERE ((US.SprintId = S.Id AND BT.IsBugBoard = 1) OR (US.SprintId = S.Id AND US.ParentUserStoryId IS NULL AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))
                             AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                             AND US.ArchivedDateTime IS NULL) CompletedUserStoriesCount

    FROM [dbo].[Sprints]S
    INNER JOIN [dbo].[Project]P ON P.Id = S.ProjectId AND P.CompanyId = @CompanyId
    INNER JOIN [dbo].[User]U ON U.Id = S.CreatedByUserId
    INNER JOIN [dbo].[BoardType]BT ON S.BoardTypeId = BT.Id
    LEFT JOIN [dbo].[BoardTypeWorkFlow] BTW ON BTW.BoardTypeId = BT.Id
                 LEFT JOIN [dbo].[WorkFlow] WF ON WF.Id = BTW.WorkflowId
    LEFT JOIN #SprintIds SInner ON SInner.Id = S.Id
    LEFT JOIN [dbo].[User]SRU ON SRU.Id = S.SprintResponsiblePersonId
    LEFT JOIN [dbo].[User]PRU ON PRU.Id = P.ProjectResponsiblePersonId
    WHERE (@SprintId IS NULL OR S.Id = @SprintId)
     AND (@ProjectId IS NULL OR S.ProjectId = @ProjectId)
     AND (@SprintName IS NULL OR S.SprintName = @SprintName)
     AND (@SearchText IS NULL OR S.SprintName LIKE @SearchText)
     AND (@SprintUniqueNumber IS NULL OR S.SprintUniqueName = @SprintUniqueNumber)
     AND ((@SprintId IS NULL AND S.InActiveDateTime IS NULL AND @SprintUniqueNumber IS NULL AND (@IsBacklog IS NULL AND S.IsReplan = 1 AND S.InActiveDateTime IS NULL) OR (@IsBacklog = 1 AND S.SprintStartDate IS NULL AND S.InActiveDateTime IS NULL) OR (@IsBacklog = 0 AND S.SprintStartDate IS NOT NULL AND S.InActiveDateTime IS NULL AND (S.IsReplan = 0 OR S.IsReplan IS NULL))) OR @SprintId IS NOT NULL OR @SprintUniqueNumber IS NOT NULL)
 
    ORDER BY S.CreatedDateTime ASC

    OFFSET ((@PageNumber - 1) * @PageSize) ROWS
    FETCH NEXT @PageSize ROWS ONLY

END
ELSE
    BEGIN

    SELECT S.Id AS SprintId,
      S.SprintName,
      S.ProjectId,
      S.SprintStartDate,
      S.SprintEndDate,
      S.CreatedByUserId,
      S.CreatedDateTime,
      S.InActiveDateTime,
      S.IsReplan,
      S.Description,
      P.ProjectName,
      P.ProjectResponsiblePersonId,
      @EnableSprints AS IsEnableSprints,
      @EnableTestRepo AS IsEnableTestRepo,
      S.BoardTypeId,
      S.BoardTypeApiId,
      S.TestSuiteId,
      S.IsComplete,
      CAST(S.SprintCompletedDate AS DATETIME) AS CompletedSprintDate,
      S.Version,
      BT.IsBugBoard,
      BT.IsSuperAgileBoard,
      BT.IsDefault,
      BT.BoardTypeName,
      BT.BoardTypeUIId AS BoardTypeUiId,
      WF.Id AS WorkFlowId,
                   WF.WorkFlow AS WorkFlowName,
      S.TimeStamp,
      S.SprintUniqueName,
      S.SprintResponsiblePersonId,
      U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedUserName,
      SRU.FirstName + ' ' + ISNULL(SRU.SurName,'') AS SprintResponsiblePersonName,
      SRU.ProfileImage,
      PRU.UserName,
      PRU.FirstName + ' ' + ISNULL(PRU.SurName, '') AS ProjectResponsiblePersonName,
      TotalCount = COUNT(1) OVER(),

      CASE WHEN EXISTS (SELECT 1 FROM UserStory US
                        WHERE US.SprintId = S.Id AND US.ArchivedDateTime IS NULL
                              AND ParkedDateTime IS NULL AND (US.EstimatedTime IS NULL AND US.SprintEstimatedTime IS NULL)
              AND US.InActiveDateTime IS NULL
              AND ISNULL(BT.IsBugBoard,0) <> 1)
      THEN 1 ELSE 0 END IsWarning,

    (SELECT COUNT(1)
    FROM UserStory US
                          INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND USS.InactiveDateTime IS NULL AND USS.CompanyId = @CompanyId
                          INNER JOIN TaskStatus TS ON USS.TaskStatusId = TS.Id
                     WHERE ((US.SprintId = S.Id AND BT.IsBugBoard = 1) OR (US.SprintId = S.Id AND US.ParentUserStoryId IS NULL AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))
                             AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                             AND US.ArchivedDateTime IS NULL) UserStoriesCount,

    (SELECT COUNT(1)
    FROM UserStory US
                          INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND USS.InactiveDateTime IS NULL AND USS.Companyid = @CompanyId
                          INNER JOIN TaskStatus TS ON USS.TaskStatusId = TS.Id AND (TS.[Order] IN (4,6))
                     WHERE ((US.SprintId = S.Id AND BT.IsBugBoard = 1) OR (US.SprintId = S.Id AND US.ParentUserStoryId IS NULL AND (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL)))
                             AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                             AND US.ArchivedDateTime IS NULL) CompletedUserStoriesCount

    FROM [dbo].[Sprints]S
    INNER JOIN [dbo].[Project]P ON P.Id = S.ProjectId AND P.CompanyId = @CompanyId
    INNER JOIN [dbo].[User]U ON U.Id = S.CreatedByUserId
    INNER JOIN [dbo].[BoardType]BT ON S.BoardTypeId = BT.Id
    LEFT JOIN [dbo].[BoardTypeWorkFlow] BTW ON BTW.BoardTypeId = BT.Id
                 LEFT JOIN [dbo].[WorkFlow] WF ON WF.Id = BTW.WorkflowId
    LEFT JOIN #SprintIds SInner ON SInner.Id = S.Id
    LEFT JOIN [dbo].[User]SRU ON SRU.Id = S.SprintResponsiblePersonId
    LEFT JOIN [dbo].[User]PRU ON PRU.Id = P.ProjectResponsiblePersonId
    WHERE (@SprintId IS NULL OR S.Id = @SprintId)
     AND (@ProjectId IS NULL OR S.ProjectId = @ProjectId)
     AND (@SprintName IS NULL OR S.SprintName = @SprintName)
     AND (@SearchText IS NULL OR S.SprintName LIKE @SearchText)
     AND (@SprintUniqueNumber IS NULL OR S.SprintUniqueName = @SprintUniqueNumber)
     AND ((@SprintId IS NULL AND S.InActiveDateTime IS NULL AND @SprintUniqueNumber IS NULL AND @IsComplete IS NULL AND   (S.IsComplete IS NULL OR S.IsComplete = 0) AND (@IsBacklog IS NULL AND S.IsReplan = 1 AND S.InActiveDateTime IS NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)) OR (@IsBacklog = 1 AND S.SprintStartDate IS NULL AND S.InActiveDateTime IS NULL) OR (@IsBacklog = 0 AND S.SprintStartDate IS NOT NULL AND S.InActiveDateTime IS NULL AND (S.IsReplan = 0 OR S.IsReplan IS NULL) AND (S.IsComplete IS NULL OR S.IsComplete = 0))) OR @SprintId IS NOT NULL OR @SprintUniqueNumber IS NOT NULL OR @IsComplete = 0 OR @IsComplete = 1)
     AND (@IsComplete IS NULL OR S.IsComplete = @IsComplete)
 
    ORDER BY S.CreatedDateTime ASC

    OFFSET ((@PageNumber - 1) * @PageSize) ROWS
    FETCH NEXT @PageSize ROWS ONLY

END 

END TRY  
    BEGIN CATCH
   
       THROW
       
    END CATCH

END
GO