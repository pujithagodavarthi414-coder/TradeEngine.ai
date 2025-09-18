CREATE PROCEDURE [dbo].[USP_GetCumulativeWorkReport]
(
	@UserId NVARCHAR(MAX),
	@ProjectId NVARCHAR(MAX) = NULL,
	@DateFrom DATE = NULL,
	@DateTo DATE = NULL,
	@Date DATE = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
	 IF (@HavePermission = '1')
	 BEGIN

SELECT  FORMAT(T.dates,'dd MMM yyyy') [Date], ISNULL([ToDo],0) [ToDoStatusWorkitemsCount],ISNULL([Inprogress],0) [InprogressStatusWorkitemsCount],  ISNULL([Done],0) [DoneStatusWorkitemsCount], ISNULL([Pending verification],0)[PendingVerificationStatusWorkitemsCount],
      ISNULL([Verification completed],0) [VerificationCompletedStatusWorkitemsCount], ISNULL([Blocked],0) [BlockedStatusWorkitemsCount] FROM		
	(SELECT  CAST(DATEADD( day,(number-1),CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))  AS date)) AS date) [Dates]
	FROM master..spt_values
	WHERE Type = 'P' and number between 1 and DATEDIFF(DAY,CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))  AS date) ,CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, -1)) AS date))+ 1) AS T 
	LEFT JOIN (
select FORMAT(UserStory.CreatedDateTime,'dd MMM yyyy') As Date,
 COUNT(CASE WHEN TaskStatusName = 'Done' THEN 1 END) [Done],
	   COUNT(CASE WHEN TaskStatusName = 'Pending verification' THEN 1 END) [Pending verification],
	   COUNT(CASE WHEN TaskStatusName = 'Inprogress' THEN 1 END) [Inprogress],
	   COUNT(CASE WHEN TaskStatusName = 'ToDo' THEN 1 END) [ToDo],
	   COUNT(CASE WHEN TaskStatusName = 'Blocked' THEN 1 END) [Blocked],
	   COUNT(CASE WHEN TaskStatusName = 'Verification completed' THEN 1 END) [Verification completed]
	   from UserStory INNER JOIN userstorystatus ON UserStory.UserStoryStatusId = userstorystatus.Id 
                             INNER JOIN taskstatus On userstorystatus.TaskStatusId = taskstatus.Id
						 AND userstorystatus.InActiveDateTime IS NULL 
AND UserStory.InActiveDateTime IS NULL AND UserStory.ParkedDateTime IS NULL WHERE UserStory.OwnerUserId = @UserId and (UserStory.ProjectId = @ProjectId OR @ProjectId IS NULL)
GROUP BY  FORMAT(UserStory.CreatedDateTime,'dd MMM yyyy'))Linner on FORMAT(T.[dates],'dd MMM yyyy')  = Linner.[date]

     END
	 ELSE
	 RAISERROR(@HavePermission,11,1)
	
	END TRY  
	BEGIN CATCH 
		
		 THROW

	END CATCH


END