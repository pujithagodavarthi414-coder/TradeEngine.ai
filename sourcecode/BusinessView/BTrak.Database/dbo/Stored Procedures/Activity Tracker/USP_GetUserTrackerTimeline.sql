---------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-12-01 00:00:00.000'
-- Purpose      To Get User Tracker Timeline
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserTrackerTimeline] @OperationsPerformedBy='ebbaf194-5893-430c-b648-4e4c9e8ac2b7'
--,@UserId ='<ListItems>
--<ListRecords>
--<ListItem>
--<ListItemId>ec8efd4f-c47f-4b78-a3bf-6ed8f1649ad1</ListItemId>
--</ListItem>
--</ListRecords>
--</ListItems>'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserTrackerTimeline]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @OnDate DATETIME = NULL,
    @UserId XML = NULL,
    @DateFrom DATETIME = NULL,
    @DateTo DATETIME = NULL
)
AS
BEGIN

   SET NOCOUNT ON
   BEGIN TRY

 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

  DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
  
  IF (@HavePermission = '1')
     BEGIN

   DECLARE @UserIdList TABLE
   (
    UsId UNIQUEIDENTIFIER NULL
   )

   DECLARE @FeatureCount INT = (SELECT COUNT(1) FROM Feature AS F
	JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
	JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
	JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
	WHERE FeatureName = 'View activity reports for all employee' AND U.Id = @OperationsPerformedBy)

   IF(@UserId IS NOT NULL)
   BEGIN
     INSERT INTO @UserIdList (UsId)
     SELECT x.value('ListItemId[1]','UNIQUEIDENTIFIER')
     FROM  @UserId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
   END
    
   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
   
   DECLARE @Pagesize INT

   IF(@OnDate IS NULL AND @DateFrom IS NULL AND @DateTo IS NULL) SET @Pagesize = 50
   ELSE SET @Pagesize = 90000

   SELECT T.* FROM
   (select CONVERT(DATETIME,SWITCHOFFSET(USST.StartTime, '+00:00')) AS StartedTime,
       CONVERT(DATETIME,SWITCHOFFSET(USST.StartTime, '+00:00')) AS CreatedDate,
       USST.CreatedByUserId AS UserId,
       U.FirstName + ' ' + ISNULL(U.SurName, '') AS FullName,
       U.ProfileImage,
       US.UserStoryUniqueName + ' - ' + US.UserStoryName AS Title,
       CategoryType = 'WorkItemStart',
       CONVERT(NVARCHAR(50),US.Id) AS Reference
   FROM UserStorySpentTime USST
    INNER JOIN [User] U ON U.Id = USST.CreatedByUserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId
    INNER JOIN [UserStory] US ON US.Id = USST.UserStoryId AND USST.StartTime IS NOT NULL
   UNION ALL
   select CONVERT(DATETIME,SWITCHOFFSET(USST.EndTime, '+00:00')) AS StartedTime,
       CONVERT(DATETIME,SWITCHOFFSET(USST.StartTime, '+00:00')) AS CreatedDate,
       USST.CreatedByUserId AS UserId,
       U.FirstName + ' ' + ISNULL(U.SurName, '') AS FullName,
       U.ProfileImage,
       US.UserStoryUniqueName + ' - ' + US.UserStoryName AS Title,
       CategoryType = 'WorkItemEnd',
       CONVERT(NVARCHAR(50),US.Id) AS Reference
   FROM UserStorySpentTime USST
    INNER JOIN [User] U ON U.Id = USST.CreatedByUserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId
    INNER JOIN [UserStory] US ON US.Id = USST.UserStoryId AND USST.StartTime IS NOT NULL AND USST.EndTime IS NOT NULL
   UNION ALL
   SELECT RS.CreatedDateTime AS StartedTime,
       CONVERT(DATE,RS.CreatedDateTime) AS CreatedDate,
       RS.CommitedByUserId AS UserId,
       U.FirstName + ' ' + ISNULL(U.SurName, '') AS FullName,
       U.ProfileImage,
       RS.CommitMessage AS Title,
       CategoryType = 'Commit',
       CommitReferenceUrl AS Reference
   FROM RepositoryCommits RS
    INNER JOIN [User] U ON U.Id = RS.CommitedByUserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId
   UNION ALL 
   SELECT CONVERT(DATETIME,SWITCHOFFSET(TS.InTime, '+00:00')) AS StartedTime,
       CONVERT(DATE,SWITCHOFFSET(TS.InTime, '+00:00')) AS CreatedDate,
       TS.UserId AS UserId,
       U.FirstName + ' ' + ISNULL(U.SurName, '') AS FullName,
       U.ProfileImage,
       Title ='TimesheetStart',
       CategoryType = 'TimesheetStart',
       NULL AS Reference
   FROM TimeSheet TS
    INNER JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId
   UNION ALL
   SELECT CONVERT(DATETIME,SWITCHOFFSET(TS.OutTime, '+00:00')) AS StartedTime,
       CONVERT(DATE,SWITCHOFFSET(TS.OutTime, '+00:00')) AS CreatedDate,
       TS.UserId AS UserId,
       U.FirstName + ' ' + ISNULL(U.SurName, '') AS FullName,
       U.ProfileImage,
       Title ='TimesheetFinish',
       CategoryType = 'TimesheetFinish',
       NULL AS Reference
   FROM TimeSheet TS
    INNER JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId AND TS.OutTime IS NOT NULL
   UNION ALL
   SELECT CONVERT(DATETIME,SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00')) AS StartedTime,
       CONVERT(DATE,SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00')) AS CreatedDate,
       TS.UserId AS UserId,
       U.FirstName + ' ' + ISNULL(U.SurName, '') AS FullName,
       U.ProfileImage,
       Title ='TimesheetLunchStart',
       CategoryType = 'LunchStart',
       NULL AS Reference
   FROM TimeSheet TS
    INNER JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId AND TS.LunchBreakStartTime IS NOT NULL
   UNION ALL
   SELECT CONVERT(DATETIME,SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')) AS StartedTime,
       CONVERT(DATE,SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')) AS CreatedDate,
       TS.UserId AS UserId,
       U.FirstName + ' ' + ISNULL(U.SurName, '') AS FullName,
       U.ProfileImage,
       Title ='TimesheetLunchEnd',
       CategoryType = 'LunchEnd',
       NULL AS Reference
   FROM TimeSheet TS
    INNER JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId AND TS.LunchBreakEndTime IS NOT NULL
   UNION ALL
   SELECT CONVERT(DATETIME,SWITCHOFFSET(UB.BreakIn, '+00:00')) AS StartedTime,
       CONVERT(DATE,SWITCHOFFSET(UB.BreakIn, '+00:00')) AS CreatedDate,
       UB.UserId AS UserId,
       U.FirstName + ' ' + ISNULL(U.SurName, '') AS FullName,
       U.ProfileImage,
       Title ='BreakStart',
       CategoryType = 'BreakStart',
       NULL AS Reference
   FROM UserBreak UB
    INNER JOIN [User] U ON U.Id = UB.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId
   UNION ALL
   SELECT CONVERT(DATETIME,SWITCHOFFSET(UB.BreakOut, '+00:00')) AS StartedTime,
       CONVERT(DATE,SWITCHOFFSET(UB.BreakOut, '+00:00')) AS CreatedDate,
       UB.UserId AS UserId,
       U.FirstName + ' ' + ISNULL(U.SurName, '') AS FullName,
       U.ProfileImage,
       Title ='BreakEnd',
       CategoryType = 'BreakEnd',
       NULL AS Reference
   FROM UserBreak UB
    INNER JOIN [User] U ON U.Id = UB.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId AND UB.BreakOut IS NOT NULL
   ) T
   WHERE (@OnDate IS NULL OR (CONVERT(DATE,StartedTime) = CONVERT(DATE,@OnDate)))
      AND (@DateFrom IS NULL OR @DateTo IS NULL OR (StartedTime BETWEEN @DateFrom AND @DateTo))
      AND ((@UserId IS NULL 
             AND (@FeatureCount > 0 OR T.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId)) ))
            OR (T.UserId IN (SELECT UsId FROM @UserIdList)))
   ORDER BY T.UserId,T.StartedTime DESC
   OFFSET (0) ROWS
   FETCH NEXT @PageSize ROWS ONLY

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
GO