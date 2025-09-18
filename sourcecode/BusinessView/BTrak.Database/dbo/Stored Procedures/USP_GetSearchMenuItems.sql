-------------------------------------------------------------------------------
-- Author       Surya Kadiyam
-- Created      '2020-08-24 00:00:00.000'
-- Purpose      To Get Search items
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetSearchMenuItems] @OperationsPerformedBy='A9C216B9-9268-47F7-B823-BD8159949E3A',@SearchText='Test'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetSearchMenuItems]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(MAX) =NULL,
   @IsArchived bit = 0,
   @IsActive BIT=1,
   @SearchUniqueId NVARCHAR(MAX) =NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    
	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		SET @SearchText = CASE WHEN @SearchText LIKE 'tag:%' THEN   ('%' + (SELECT SUBSTRING(@SearchText,5,LEN(@SearchText))) + '%') ELSE   ('%'+ @SearchText+'%') END 

		SET @SearchUniqueId = CASE WHEN @SearchUniqueId = 'null' THEN NULL ELSE @SearchUniqueId END

		SET @SearchText = CASE WHEN @SearchText = 'null' THEN NULL ELSE @SearchText END

DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

CREATE TABLE #SearchItem_Temp
(
ItemId UNIQUEIDENTIFIER NOT NULL,
ItemName Nvarchar(MAX),
ItemUniqueName Nvarchar(MAX),
ItemType INT
)

-- Project Records insertion ...
INSERT INTO #SearchItem_Temp
SELECT P.Id AS ItemId, P.ProjectName [ItemName],P.ProjectUniqueName [ItemUniqueName],5 AS ItemType
        FROM [dbo].[Project] P WITH(NOLOCK) 
	    WHERE  P.Id IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                      WHERE UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
			  AND P.ProjectName <> 'Adhoc project'
			  AND (P.ProjectName LIKE @SearchText)
			  AND (@IsArchived IS NULL OR (@IsArchived = 0 AND P.InactiveDateTime IS NULL) OR (@IsArchived = 1 AND P.InactiveDateTime IS NOT NULL))
			  AND P.CompanyId = @CompanyId AND P.InActiveDateTime IS NULL

-- Goals Records insertion ....
INSERT INTO #SearchItem_Temp
			  SELECT G.Id AS [ItemId],G.GoalName [ItemName],G.GoalUniqueName [ItemUniqueName],1 AS ItemType
				FROM [dbo].[Goal] G
               INNER JOIN [dbo].[BoardType] BT ON BT.Id = G.BoardTypeId AND BT.CompanyId = @CompanyId AND G.GoalName <> 'Adhoc Goal'
			   INNER JOIN [dbo].[BoardTypeUi] BTU ON BTU.Id = BT.BoardTypeUiID
	           INNER JOIN [dbo].[Project] P ON P.Id = G.ProjectId AND P.InactiveDateTime IS NULL
               LEFT JOIN [dbo].[GoalStatus] GS ON GS.Id = G.GoalStatusId
          WHERE  P.Id IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                      WHERE UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
                 AND (@IsArchived IS NULL OR (@IsArchived = 0 AND (GS.IsArchived = 0 AND (G.InActiveDateTime IS NULL))) 
                 OR (@IsArchived = 1 AND GS.IsArchived = 1 AND (G.InActiveDateTime IS NOT NULL)))
                 AND (P.CompanyId = @CompanyId) 
                 AND (@SearchUniqueId IS NOT NULL OR G.GoalName LIKE @SearchText)
				 AND (@SearchUniqueId IS NULL OR G.GoalUniqueName = @SearchUniqueId)
				 --AND G.InActiveDateTime IS NULL
				 AND P.CompanyId = @CompanyId AND P.InActiveDateTime IS NULL

INSERT INTO #SearchItem_Temp
				 SELECT S.Id [ItemId],S.SprintName [ItemName], S.SprintUniqueName [ItemUniqueName],3 [ItemType] FROM [dbo].[Sprints] S
					INNER JOIN [dbo].[Project]P ON P.Id = S.ProjectId 
					INNER JOIN [dbo].[BoardType] BT ON BT.Id = S.BoardTypeId AND BT.CompanyId = @CompanyId 
					INNER JOIN [dbo].[BoardTypeUi] BTU ON BTU.Id = BT.BoardTypeUiID
					WHERE P.Id IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                      WHERE UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
					AND S.InActiveDateTime IS NULL AND P.InactiveDateTime IS NULL 
					AND (@SearchUniqueId IS NOT NULL OR S.SprintName LIKE @SearchText)
					 AND (@SearchUniqueId IS NULL OR S.SprintUniqueName = @SearchUniqueId)
					AND P.CompanyId = @CompanyId AND P.InActiveDateTime IS NULL
					-- Employee Records insertion ....

INSERT INTO #SearchItem_Temp
					SELECT E.UserId [ItemId],U.FirstName + ' ' + ISNULL(U.SurName,'') [ItemName],E.EmployeeNumber [ItemUniqueName],6 AS [ItemType]
				FROM [dbo].[Employee] AS E WITH (NOLOCK)
	                INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                    INNER JOIN [User] U ON U.Id = E.UserId AND (@IsActive IS NULL OR (@IsActive= 1 AND U.IsActive = 1) OR (@IsActive = 0 AND U.IsActive = 0))
               WHERE U.CompanyId = @CompanyId AND (@SearchUniqueId IS NOT NULL OR (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText)) AND  (@SearchUniqueId IS NULL OR E.EmployeeNumber = @SearchUniqueId)
                        AND (@IsArchived IS NULL OR (@IsArchived = 1 AND E.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND E.InActiveDateTime IS NULL))
							 
--- User Story Insertion ....
INSERT INTO #SearchItem_Temp
SELECT US.Id [ItemId],US.UserStoryName [ItemName], US.UserStoryUniqueName [ItemUniqueName],2 [ItemType] FROM [dbo].[UserStory] US
				INNER JOIN [dbo].[Project] P ON P.Id = US.ProjectId
				LEFT JOIN [dbo].[Goal] G ON G.Id = US.GoalId 
				LEFT JOIN [dbo].[Sprints] S ON S.Id = US.SprintId
				WHERE P.Id IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                      WHERE UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
				AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
				AND G.ParkedDateTime IS NULL  AND S.InActiveDateTime IS NULL AND P.ProjectName <> 'Adhoc project'
				AND P.InactiveDateTime IS NULL 
				AND (@SearchUniqueId IS NOT NULL OR US.UserStoryName LIKE @SearchText)
				AND  (@SearchUniqueId IS NULL OR US.UserStoryUniqueName = @SearchUniqueId)
				AND P.CompanyId = @CompanyId AND P.InActiveDateTime IS NULL
				AND US.ParkedDateTime IS NULL

				DECLARE @FeatureId UNIQUEIDENTIFIER = (SELECT FeatureId FROM CompanyModule CM 
                                                            INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId
                                                            INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = '02CCA450-E08F-4871-9DA0-E6DA4285C382'
                                                            AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL AND CM.CompanyId = @CompanyId GROUP BY FeatureId)
               DECLARE @HaveAdhocPermission BIT = (CASE WHEN  EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)

			   IF(@HaveAdhocPermission =1)
			   BEGIN
			   INSERT INTO #SearchItem_Temp
			   SELECT US.Id [ItemId],US.UserStoryName [ItemName], US.UserStoryUniqueName [ItemUniqueName],4 [ItemType] FROM [dbo].[UserStory] US
				INNER JOIN [dbo].[Project] P ON P.Id = US.ProjectId
				LEFT JOIN [dbo].[Goal] G ON G.Id = US.GoalId 
				LEFT JOIN [dbo].[Sprints] S ON S.Id = US.SprintId
				WHERE P.Id IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                      WHERE UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
				AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
				AND G.ParkedDateTime IS NULL  AND S.InActiveDateTime IS NULL AND P.ProjectName = 'Adhoc project' AND P.CompanyId = @CompanyId
				AND P.InactiveDateTime IS NULL AND (@SearchUniqueId IS NOT NULL OR US.UserStoryName LIKE @SearchText) AND  (@SearchUniqueId IS NULL OR US.UserStoryUniqueName = @SearchUniqueId)
				AND P.CompanyId = @CompanyId AND P.InActiveDateTime IS NULL
				AND US.ParkedDateTime IS NULL

				END
SELECT * FROM #SearchItem_Temp
DROP TABLE #SearchItem_Temp
		
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO