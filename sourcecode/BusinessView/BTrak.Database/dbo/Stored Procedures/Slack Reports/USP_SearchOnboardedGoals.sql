-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-01-25 00:00:00.000'
-- Purpose      To Search the On boardedGoals By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_SearchOnboardedGoals]  @OperationsPerformedBy='9DB68192-202F-42B0-8358-6800F6C0C900' ,@ProjectId ='d153c715-db09-4763-9b67-fbaf30467e2c'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SearchOnboardedGoals] 
(
  @StatusColor  NVARCHAR(250) = NULL,
  @EntityId UNIQUEIDENTIFIER = NULL,
  @ProjectId   UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
	BEGIN
		
          IF(@StatusColor = '') SET @StatusColor = NULL
          
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		  
          IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
          
          DECLARE @IsAdmin BIT = (SELECT [dbo].[Ufn_GetIsAdminBasedOnUserId] (@OperationsPerformedBy))
          
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
          DECLARE @Users TABLE
          (
            UserId UNIQUEIDENTIFIER
          )
          INSERT INTO @Users(UserId)
          SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId)
          IF(@OperationsPerformedBy IS NOT NULL)
          BEGIN
          
          
                SELECT G.Id GoalId,
                       G.GoalName,
                       P.Id AS ProjectId,
                       G.OnboardProcessDate,
                       CONVERT(NVARCHAR(30),
                       G.OnboardProcessDate, 106) AS OnboardProcessedOn,
                       TZ.TimeZoneAbbreviation  OnboardProcessDateTimeZoneAbbreviation, 
                       TZ.TimeZoneName OnboardProcessDateTimeZoneName,
                       CONVERT(NVARCHAR(30), 
                       MAX(US.DeadLineDate), 106) AS MileStoneDate,
                       GS.GoalStatusName, CASE WHEN G.GoalStatusColor IS NULL THEN '#b7b7b7' ELSE G.GoalStatusColor END AS GoalStatusColor,
                       G.GoalResponsibleUserId, (U.FirstName + ' ' + ISNULL(U.SurName,'')) AS GoalResponsibleUserName,
                       MAX(US.DeadLineDate) AS MileStone, 
                       CASE WHEN (DATEDIFF(DAY,MAX(US.ActualDeadLineDate),MAX(US.DeadLineDate))) < 0 THEN 0 ELSE DATEDIFF(DAY,MAX(US.ActualDeadLineDate),MAX(US.DeadLineDate)) END AS [Delay],
                       Members = STUFF(( SELECT  ',' + CONVERT(NVARCHAR(MAX),(CASE WHEN UO.ProfileImage IS NULL THEN (SUBSTRING(UO.FirstName,1,1) + ISNULL(SUBSTRING(UO.SurName,1,1),'')) ELSE UO.ProfileImage END))[text()]
                               FROM UserStory US1
                               JOIN [User] UO ON UO.Id = US1.OwnerUserId AND UO.InactiveDateTime IS NULL
							        AND (US1.ArchivedDateTime IS NULL OR US1.InActiveDateTime IS NULL)
                               INNER JOIN Goal G1 ON G1.Id = US1.GoalId
                               WHERE (G1.Id = G.Id) AND (US1.ArchivedDateTime IS NULL OR US1.InActiveDateTime IS NULL)
                               GROUP BY UO.ProfileImage,(SUBSTRING(UO.FirstName,1,1) + ISNULL(SUBSTRING(UO.SurName,1,1),''))    
                               FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),
                     
                     Deviation = (SELECT DE.DeviationPerVal*100 DeviationPer FROM
                            (SELECT CAST((ISNULL(T.NumberOfHoursToBeCompleted,0) - ISNULL(T1.NumberOfHoursCompleted,0)) / (CASE WHEN T.NumberOfHoursToBeCompleted = 0 THEN 1 ELSE ISNULL(T.NumberOfHoursToBeCompleted,1) END) AS DECIMAL(10,2)) DeviationPerVal,T.GoalId GoalId FROM 
                            (SELECT SUM(EstimatedTime)*1.0 NumberOfHoursToBeCompleted,G2.Id GoalId 
							FROM UserStory US2
                            JOIN [dbo].[Goal] G2 ON US2.GoalId = G2.Id
							AND (US2.ArchivedDateTime IS NULL OR US2.InActiveDateTime IS NULL)
                            JOIN [dbo].[GoalStatus] GS1 ON GS1.Id = G2.GoalStatusId AND GS1.InactiveDateTime IS NULL
                            WHERE CONVERT(DATE,ActualDeadLineDate) <= CONVERT(DATE,GETDATE()) 
                            AND GS1.IsActive = 1          
							AND (US2.ArchivedDateTime IS NULL OR US2.InActiveDateTime IS NULL)
                            AND (G2.InActiveDateTime IS NULL)
                            AND (IsToBeTracked = 1)
                            AND (G2.ParkedDateTime IS NULL)
                            GROUP BY G2.Id) T
                            LEFT JOIN
                            (SELECT SUM(EstimatedTime)*1.0 NumberOfHoursCompleted,G3.Id GoalId FROM UserStory US3
                            JOIN [dbo].[Goal] G3 ON US3.GoalId = G3.Id AND (US3.ArchivedDateTime IS NULL OR US3.InActiveDateTime IS NULL)
                            JOIN [dbo].[GoalStatus] GS ON GS.Id = G3.GoalStatusId
                            LEFT JOIN UserStoryStatus USS ON USS.Id = US3.UserStoryStatusId AND USS.InactiveDateTime IS NULL
							          AND (US3.ArchivedDateTime IS NULL OR US3.InActiveDateTime IS NULL)
                            LEFT JOIN BoardType BT ON BT.Id = G3.BoardTypeId
                            WHERE CONVERT(DATE,ActualDeadLineDate) <= CONVERT(DATE,GETDATE()) 
                            AND GS.IsActive = 1
                            AND (G3.InActiveDateTime IS NULL)
                            AND (IsToBeTracked = 1)
                            AND (G3.ParkedDateTime IS NULL)
                            AND (USS.TaskStatusId = '5C561B7F-80CB-4822-BE18-C65560C15F5B' OR USS.TaskStatusId = '884947DF-579A-447A-B28B-528A29A3621D'
                            --OR (USS.IsCompleted = 1 AND BT.IsKanban = 1)
                            --OR ((USS.IsResolved = 1 OR USS.IsVerified = 1) AND BT.IsKanbanBug = 1)
							)
                            GROUP BY G3.Id)T1 ON T.GoalId = T1.GoalId) DE 
                            WHERE DE.GoalId = G.Id)
                      
                  FROM [Goal] G 
                       INNER JOIN [dbo].[Project] P ON G.ProjectId = P.Id AND (@ProjectId IS NULL OR P.Id = @ProjectId)
                       INNER JOIN [dbo].[User] U ON G.GoalResponsibleUserId = U.Id AND U.InactiveDateTime IS NULL
					   LEFT JOIN [Employee] E ON E.UserId = U.Id 
	                   LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                             AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                                 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
                       INNER JOIN  [dbo].[GoalStatus] GS ON GS.Id = G.GoalStatusId 
                       LEFT JOIN UserStory US ON US.GoalId = G.Id AND (US.ArchivedDateTime IS NULL OR US.InActiveDateTime IS NULL)
					   LEFT JOIN TimeZone TZ ON TZ.Id = G.OnboardProcessDateTimeZoneId 
                WHERE U.CompanyId = @CompanyId
                      AND (@StatusColor IS NULL OR CASE WHEN G.GoalStatusColor IS NULL THEN '#b7b7b7' ELSE G.GoalStatusColor END = @StatusColor)
                      AND (G.GoalResponsibleUserId IN (SELECT UserId FROM @Users))
                      AND (G.InActiveDateTime IS NULL)
                      AND (P.InActiveDateTime IS NULL)
                      AND (IsToBeTracked = 1)
                      AND (G.ParkedDateTime IS NULL)
                      AND CONVERT(DATE,G.OnboardProcessDate) <= CONVERT(DATE,GETDATE())
                GROUP BY G.Id,G.GoalName,G.OnboardProcessDate,GS.GoalStatusName,G.GoalStatusColor,P.Id,
                G.GoalResponsibleUserId,(U.FirstName + ' ' + ISNULL(U.SurName,'')),TZ.TimeZoneAbbreviation,TZ.TimeZoneName
                ORDER BY (U.FirstName + ' ' + ISNULL(U.SurName,'')) ASC
          
          END
	END
    END TRY  
    BEGIN CATCH 
        
         THROW
    END CATCH
END
GO