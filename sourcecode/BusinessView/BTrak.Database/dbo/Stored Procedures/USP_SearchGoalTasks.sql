CREATE PROCEDURE [dbo].[USP_SearchGoalTasks]
(
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
@SearchText NVARCHAR(100) = NULL
)
AS
BEGIN
 SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		IF(@SearchText = '') SET @SearchText = NULL
		 --SET @SearchText = @SearchText+'%'
		 SET @SearchText = CASE WHEN @SearchText LIKE 'tag:%' THEN   ('%' + (SELECT SUBSTRING(@SearchText,5,LEN(@SearchText))) + '%') ELSE   ('%'+ @SearchText+'%') END 
		-- SET @SearchText = REPLACE(@SearchText, ' ', '')
		 
                DECLARE @GoalId UNIQUEIDENTIFIER = (SELECT G.Id 
                                                    FROM Goal G
                                                         INNER JOIN Project P ON P.Id = G.ProjectId 
                                                                    AND P.ProjectName = 'Adhoc Project' AND P.CompanyId = @CompanyId
                                                     WHERE GoalName = 'Adhoc Goal')
                DECLARE @FeatureId UNIQUEIDENTIFIER = (SELECT FeatureId
                                                       FROM CompanyModule CM 
                                                            INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId
                                                            INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = '02CCA450-E08F-4871-9DA0-E6DA4285C382' -- 'View all adhoc works'
                                                                       AND FM.InActiveDateTime IS NULL
                                                                       AND CM.InActiveDateTime IS NULL
                                                                       AND CM.CompanyId = @CompanyId) --View all adhoc works
               DECLARE @HaveAdhocPermission BIT = (CASE WHEN  EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)

		SELECT * INTO #tempgwibsa FROM (SELECT S.Id,S.SprintName [Name], S.SprintUniqueName [UniqueName],3 [Type] FROM [dbo].[Sprints] S
					INNER JOIN [dbo].[Project]P ON P.Id = S.ProjectId 
					WHERE  P.Id IN (SELECT UP.ProjectId FROM Userproject UP WHERE UP.UserId = @OperationsPerformedBy AND UP.InActiveDateTime IS NULL) AND S.InActiveDateTime IS NULL AND P.InactiveDateTime IS NULL 
					AND S.SprintUniqueName LIKE @SearchText

					UNION ALL

		SELECT G.Id,G.GoalName [Name], G.GoalUniqueName [UniqueName],1 [Type] FROM [dbo].[Goal] G
               INNER JOIN [dbo].[Project] P ON P.Id = G.ProjectId
			   WHERE  P.Id IN (SELECT UP.ProjectId FROM Userproject UP WHERE UP.UserId = @OperationsPerformedBy AND UP.InActiveDateTime IS NULL) AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL  AND P.InactiveDateTime IS NULL
			   AND G.GoalUniqueName LIKE @SearchText 

					UNION ALL

		SELECT US.Id,US.UserStoryName[Name], US.UserStoryUniqueName [UniqueName],2 [Type] FROM [dbo].[UserStory] US
				INNER JOIN [dbo].[Project] P ON P.Id = US.ProjectId
				LEFT JOIN [dbo].[Goal] G ON G.Id = US.GoalId 
				LEFT JOIN [dbo].[Sprints] S ON S.Id = US.SprintId
				WHERE  P.Id IN (SELECT UP.ProjectId FROM Userproject UP WHERE UP.UserId = @OperationsPerformedBy AND UP.InActiveDateTime IS NULL) AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
				AND G.ParkedDateTime IS NULL  AND S.InActiveDateTime IS NULL AND P.ProjectName <> 'Adhoc project'
				AND P.InactiveDateTime IS NULL 
					AND US.UserStoryUniqueName LIKE @SearchText ) A
					
					IF(@HaveAdhocPermission = 1)
					BEGIN
				SELECT * FROM (SELECT * FROM #tempgwibsa
					UNION ALL
					SELECT US.Id,US.UserStoryName[Name], US.UserStoryUniqueName [UniqueName],4 [Type] FROM [dbo].[UserStory] US
				INNER JOIN [dbo].[Project] P ON P.Id = US.ProjectId
				LEFT JOIN [dbo].[Goal] G ON G.Id = US.GoalId 
				LEFT JOIN [dbo].[Sprints] S ON S.Id = US.SprintId
				LEFT JOIN  [dbo].[User] OU  WITH (NOLOCK) ON OU.Id = US.OwnerUserId 
                               AND OU.InActiveDateTime IS NULL AND OU.CompanyId = @CompanyId
				WHERE  US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
				AND G.ParkedDateTime IS NULL  AND S.InActiveDateTime IS NULL AND P.ProjectName = 'Adhoc project' AND P.CompanyId = @CompanyId
				AND P.InactiveDateTime IS NULL
					AND US.UserStoryUniqueName LIKE @SearchText) A
					
					-- sorting alphanumerically
					ORDER BY LEFT(UniqueName, PATINDEX('%[0-9]%', UniqueName)-1), -- alphabetical sort
				    CONVERT(INT, SUBSTRING(UniqueName, PATINDEX('%[0-9]%', UniqueName), LEN(UniqueName))) -- numerical

				 END
				 ELSE 
				 BEGIN
				 SELECT * FROM #tempgwibsa 
				 -- sorting alphanumerically
					ORDER BY LEFT(UniqueName, PATINDEX('%[0-9]%', UniqueName)-1), -- alphabetical sort
         CONVERT(INT, SUBSTRING(UniqueName, PATINDEX('%[0-9]%', UniqueName), LEN(UniqueName))) -- numerical
				 END
				 DROP TABLE #tempgwibsa

	 END TRY  
    BEGIN CATCH 
    
          THROW
        
    END CATCH
END