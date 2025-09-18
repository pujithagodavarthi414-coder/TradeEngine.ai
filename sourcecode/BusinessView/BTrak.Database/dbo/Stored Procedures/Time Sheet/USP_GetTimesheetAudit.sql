CREATE PROCEDURE [dbo].[USP_GetTimesheetAudit]
(
   @UserId uniqueidentifier,
   @FeatureId uniqueidentifier,
   @UserStoryId uniqueidentifier,
   @DateFrom DATETIME,
   @DateTo DATETIME
)
AS 
BEGIN
DECLARE @Activity TABLE
(
   UserId uniqueidentifier,
   FeatureId uniqueidentifier,
   UserStoryId uniqueidentifier,
   ViewedDate DATETIME,
   UserName VARCHAR(800),
   FeatureName VARCHAR(800),
   CreatedDateTime Datetime,
   AuditDescription VARCHAR(800)
)

IF(@UserId = '00000000-0000-0000-0000-000000000000')
BEGIN
SET @UserId = NULL
END
IF(@UserStoryId = '00000000-0000-0000-0000-000000000000')
BEGIN
SET @UserStoryId = NULL
END
IF(@FeatureId = '00000000-0000-0000-0000-000000000000')
BEGIN
SET @FeatureId = NULL
END

--INSERT INTO @Activity (UserId,AuditDescription,FeatureId,UserStoryId,ViewedDate,UserName,FeatureName,CreatedDateTime)

--SELECT JSON_VALUE(AuditJSON,'$.UserId'),JSON_VALUE(AuditJSON,'$.Description'),JSON_VALUE(AuditJSON,'$.FeatureId'),JSON_VALUE(AuditJSON,'$.UserStoryId'),CONVERT(DATETIME2(7),JSON_VALUE(AuditJSON,'$.Date')),
--       ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,''),F.FeatureName,CA.CreatedDateTime
--FROM [Audit] CA WITH (NOLOCK) JOIN [User] U WITH (NOLOCK) ON U.Id = JSON_VALUE(AuditJSON,'$.UserId') JOIN Feature F ON F.Id = JSON_VALUE(AuditJSON,'$.FeatureId')
--                                                                         LEFT JOIN UserStory US ON US.Id = JSON_VALUE(AuditJSON,'$.UserStoryId')
--WHERE ((CONVERT(DATE,JSON_VALUE(AuditJSON,'$.Date')) >= CONVERT(DATE,@DateFrom) AND CONVERT(DATE,JSON_VALUE(AuditJSON,'$.Date')) <= CONVERT(DATE,@DateTo)))
--  AND (U.Id = @UserId OR @UserId IS NULL) AND (F.Id = @FeatureId OR @FeatureId IS NULL) AND (US.Id = @UserStoryId OR @UserStoryId IS NULL) AND CA.IsOldAudit IS NULL

 SELECT * FROM @Activity

END