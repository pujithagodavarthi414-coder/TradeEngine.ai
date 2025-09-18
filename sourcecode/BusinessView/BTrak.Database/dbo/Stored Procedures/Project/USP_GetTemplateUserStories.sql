-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2020-01-01 00:00:00.000'
-- Purpose      To Get the UserStories By Using Templates
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTemplateUserStories] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@SearchText = 'CEO'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTemplateUserStories]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @TemplateId UNIQUEIDENTIFIER = NULL,
   @UserStoryId UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @SearchText NVARCHAR(250) = NULL,
   @UserStoryIdsXml XML = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
     IF (@HavePermission = '1')
     BEGIN
     IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
     IF(@SearchText = '') SET @SearchText = NULL
        CREATE TABLE #UserStory
            (
                Id UNIQUEIDENTIFIER
            )
      IF (@UserStoryIdsXml IS NOT NULL)
          BEGIN
            INSERT INTO #UserStory(Id)
            SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
            FROM @UserStoryIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
     END
          SELECT US.OwnerUserId
                 ,OU.FirstName + ' ' + ISNULL(OU.SurName,'') AS OwnerName
                 ,OU.ProfileImage AS OwnerProfileImage
                 ,DU.ProfileImage AS DependencyProfileImage
                 ,DU.FirstName + ' ' + ISNULL(DU.SurName,'') AS DependencyName
                 ,US.[EstimatedTime]
                 ,US.[UserStoryName]
                 ,US.[DependencyUserId]
                 ,US.[Order]
                 ,US.[UserStoryStatusId]
                 ,US.Id AS UserStoryId
                 ,US.UserStoryTypeId
                 ,US.TimeStamp
                 ,P.Id AS ProjectId
                 ,T.Id AS TemplateId
                 ,T.TemplateName
                 ,T.[BoardTypeId]
                 ,BW.WorkFlowId
                 ,W.Workflow
				 ,US.[Description]
				 ,UST.UserStoryTypeName
				 ,UST.Color AS UserStoryTypeColor
          FROM  UserStory US
                INNER JOIN Templates T ON T.Id = US.TemplateId AND T.InActiveDateTime IS NULL
                INNER JOIN Project P ON P.Id = T.ProjectId AND P.CompanyId = @CompanyId AND P.InActiveDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
                LEFT JOIN [User] OU ON OU.Id = US.OwnerUserId AND OU.InActiveDateTime IS NULL
                LEFT JOIN [User] DU ON DU.Id = US.OwnerUserId AND DU.InActiveDateTime IS NULL
                LEFT JOIN BoardType BT ON BT.Id = T.BoardTypeId AND BT.InActiveDateTime IS NULL
                LEFT JOIN BoardTypeWorkFlow BW ON BW.Id = BT.Id AND BW.InActiveDateTime IS NULL
                LEFT JOIN WorkFlow W ON W.Id = BW.Id AND W.InActiveDateTime IS NULL
                LEFT JOIN #UserStory UsInner ON UsInner.Id = US.Id
        WHERE (@TemplateId IS NULL OR @TemplateId = T.Id)
              AND (@UserStoryId IS NULL OR @UserStoryId = US.Id)
              AND (@UserStoryIdsXml IS NULL OR UsInner.Id IS NOT NULL)
              AND (@IsArchived IS NULL OR (@IsArchived = 1 AND US.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND US.InActiveDateTime IS NULL))
              AND (@SearchText IS NULL OR UserStoryName LIKE @SearchText
                                       OR OU.FirstName + ' ' + ISNULL(OU.SurName,'') LIKE @SearchText
                                       OR TemplateName LIKE @SearchText)
    END
     ELSE
        RAISERROR(@HavePermission,11,1)
     END TRY
     BEGIN CATCH
           THROW
    END CATCH
END