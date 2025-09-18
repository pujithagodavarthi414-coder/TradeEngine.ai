-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-23 00:00:00.000'
-- Purpose      To Get UserStories By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStoriesByGoals] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@GoalIds='<GenericListOfGuid><ListItems><guid>E3ADACA0-B8C9-41B4-B0D5-09EE60B12F20</guid><guid>4B34D328-9401-43B6-BE50-0B1916A3865C</guid><guid>FF4047B8-39B1-42D2-8910-4E60ED38AAC7</guid></ListItems></GenericListOfGuid>'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetUserStoriesByGoals]
(
    @GoalIds XML,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000')
            SET @OperationsPerformedBy = NULL

        DECLARE @CompanyId UNIQUEIDENTIFIER = (
                                                  SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)
                                              )

        SELECT G.Id GoalId,
               G.ProjectId,
               P.ProjectName,
               G.BoardTypeId,
               BT.BoardTypeName,
               G.GoalName,
               G.GoalBudget,
               G.OnboardProcessDate,
               G.IsLocked,
               G.GoalShortName,
               CASE
                   WHEN P.InactiveDateTime IS NULL THEN
                       0
                   ELSE
                       1
               END IsArchived,
               P.InactiveDateTime AS ArchivedDateTime,
               G.GoalResponsibleUserId,
               U2.FirstName + ' ' + U2.SurName GoalResponsibleUserName,
               G.CreatedDateTime,
               G.CreatedByUserId,
               U.FirstName + ' ' + U.SurName CreatedUserName,
               G.UpdatedDateTime,
               G.UpdatedByUserId,
               U1.FirstName + ' ' + U1.SurName UpdateUserName,
               G.GoalStatusId,
               G.GoalStatusColor,
               G.IsProductiveBoard,
               G.ConsiderEstimatedHoursId,
               CH.ConsiderHourName,
               G.IsToBeTracked,
               G.BoardTypeApiId,
               BTA.ApiName BoardTypeApiName,
               G.ConfigurationId,
               CT.ConfigurationTypeName,
               G.Version,
               G.ParkedDateTime,
               (
                   SELECT
                       (
                           SELECT US.Id AS UserStoryId,
                                  US.GoalId,
                                  US.UserStoryName,
                                  US.EstimatedTime,
                                  US.DeadLineDate,
                                  US.OwnerUserId,
                                  US.DependencyUserId,
                                  US.[Order],
                                  US.UserStoryStatusId,
                                  US.CreatedDateTime,
                                  US.CreatedByUserId,
                                  US.UpdatedDateTime,
                                  US.UpdatedByUserId,
                                  US.ActualDeadLineDate,
                                  US.ArchivedDateTime,
                                  US.BugPriorityId,
                                  US.UserStoryTypeId,
                                  US.ParkedDateTime,
                                  US.ProjectFeatureId
                           FROM UserStory AS US WITH (NOLOCK)
                               INNER JOIN Goal G1 WITH (NOLOCK)
                                   ON US.GoalId = G1.Id
                           WHERE (G.Id = G1.Id)
                           FOR XML PATH('UserStoryApiReturnModel'), TYPE
                       )
                   FOR XML PATH('UserStories'), TYPE
               ) AS UserStoriesXML
        FROM [dbo].[Goal] AS G WITH (NOLOCK)
            INNER JOIN Project AS P WITH (NOLOCK)
                ON P.Id = G.ProjectId
            LEFT JOIN BoardType AS BT
                ON G.BoardTypeId = BT.Id
            LEFT JOIN BoardTypeApi AS BTA
                ON G.BoardTypeApiId = BTA.Id
            LEFT JOIN [User] AS U WITH (NOLOCK)
                ON G.CreatedByUserId = U.Id
            LEFT JOIN [User] AS U1 WITH (NOLOCK)
                ON G.UpdatedByUserId = U1.Id
            LEFT JOIN [User] AS U2 WITH (NOLOCK)
                ON G.GoalResponsibleUserId = U2.Id
            LEFT JOIN ConsiderHours AS CH
                ON G.ConsiderEstimatedHoursId = CH.Id
            LEFT JOIN ConfigurationType AS CT
                ON CT.Id = G.ConfigurationId
        WHERE (
            (
                @GoalIds IS NULL
                OR G.Id IN (
                               SELECT x.y.value('(text())[1]', 'varchar(100)')
                               FROM @GoalIds.nodes('/GenericListOfGuid/ListItems/guid') AS x(y)
                           )
            )
              )

    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO