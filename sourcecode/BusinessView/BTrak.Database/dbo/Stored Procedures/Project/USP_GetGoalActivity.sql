-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-07-30 00:00:00.000'
-- Purpose      To get spent time status of user stories
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------
--EXEC USP_GetGoalActivity @GoalId = 'FF4047B8-39B1-42D2-8910-4E60ED38AAC7'
-----------------------------------------------------------------
CREATE PROCEDURE USP_GetGoalActivity
(
 @GoalId UNIQUEIDENTIFIER = NULL,
 @ProjectId UNIQUEIDENTIFIER = NULL,
 @OperationPerformedByUserId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
    
	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationPerformedByUserId,(SELECT OBJECT_NAME(@@PROCID))))
            
    IF (@HavePermission = '1')
    BEGIN
	DECLARE @DateFrom DATETIME = NULL
	DECLARE @DateTo DATETIME = NULL

    IF (@DateFrom IS NULL) SET @DateFrom = (SELECT CONVERT(DATETIME,MIN(US.CreatedDateTime)) FROM UserStory US WHERE US.GoalId = @GoalId GROUP BY GoalId)

    IF (@DateTo IS NULL) SET @DateTo = (CASE WHEN (SELECT InactiveDateTime FROM Goal WHERE Id = @GoalId) IS NOT NULL THEN
		                                                (SELECT CONVERT(DATETIME,MAX(US.DeadLineDate)) FROM UserStory US WHERE US.GoalId = @GoalId GROUP BY GoalId)
												ELSE GETDATE() END)

	SELECT ISNULL(T.CreatedDateTime,D.[Date]) AS [Date],
       T.UserId,
	   T.UserName,
	   T.UserStoryId,
	   T.UserStoryName,
	   T.OldValue,
	   T.NewValue,
	   T.[Description],
	   T.ProfileImage
       FROM 	    
		(SELECT
        DATEADD(DAY, NUMBER,@DateFrom) AS [Date]
        FROM MASTER..SPT_VALUES
        WHERE TYPE='p'
        AND NUMBER<=DATEDIFF(DAY,@DateFrom,@DateTo)) D
       LEFT JOIN (SELECT USH.[CreatedDateTime],
                         U.Id AS UserId,
	                     U.FirstName + ' ' + ISNULL(U.SurName,'') AS UserName,
	                     US.Id AS UserStoryId,
	                     US.UserStoryName,
	                     USH.OldValue,
	                     USH.NewValue,
	                     USH.[Description],
	                     U.ProfileImage	   
	                     FROM UserStoryHistory USH 
	                     INNER JOIN UserStory US ON US.Id = USH.UserStoryId AND US.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL
	                     INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL --AND G.ArchivedDateTime IS NULL
						 INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL
	                     INNER JOIN [User] U ON U.Id = USH.CreatedByUserId AND U.InActiveDateTime IS NULL
	                     WHERE (@GoalId IS NULL OR G.Id = @GoalId)
						 AND (@ProjectId IS NULL OR P.Id = @ProjectId)
						 AND (@OperationPerformedByUserId IS NULL OR U.Id = @OperationPerformedByUserId)) T ON CONVERT(DATE,T.CreatedDateTime) = CONVERT(DATE,D.[Date])
ORDER BY D.[Date] DESC
 
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