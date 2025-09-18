-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-09-18 00:00:00.000'
-- Purpose      To Get Audit Question spent time by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_SearchUserStorySpentTimes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@PageNo=1,@PageSize=10
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SearchAuditQuestionSpentTime]
(
    @UserStorySpentTimeId  UNIQUEIDENTIFIER = NULL,
    @UserStoryId  UNIQUEIDENTIFIER,
    @UserId  UNIQUEIDENTIFIER = NULL,
    @SpentTime  DECIMAL(8,2) = NULL,
    @Comment NVARCHAR(800) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @PageNo INT,
    @PageSize INT
)
AS
BEGIN
        SET NOCOUNT ON
       
        BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
    
	    IF (@HavePermission = '1')
	    BEGIN

            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
            IF (@UserStorySpentTimeId = '00000000-0000-0000-0000-000000000000') SET @UserStorySpentTimeId = NULL

            --IF (@UserStoryId = '00000000-0000-0000-0000-000000000000') SET @UserStoryId = NULL

            IF (@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

            IF (@Comment = '') SET @Comment = NULL

            DECLARE @RemainingSpentTime INT = (SELECT RemainingTimeInMin * 1.000 /60.000 
			                                   FROM UserStorySpentTime 
			                                   WHERE UserStoryId = @UserStoryId 
											   AND CreatedDateTime = (SELECT MAX(CreatedDateTime) FROM UserStorySpentTime WHERE UserStoryId = @UserStoryId GROUP BY UserStoryId)
											   AND InActiveDateTime IS NULL)

            SELECT USS.Id AS UserStorySpentTimeId,
                   USS.UserStoryId,
                   CASE WHEN USS.SpentTimeInMin IS NOT NULL THEN (USS.SpentTimeInMin/60) 
						ELSE DATEDIFF(SECOND, USS.StartTime, USS.EndTime)/3600.0 END AS SpentTimeInMin,
				   CASE WHEN USS.SpentTimeInMIn IS NOT NULL THEN USS.SpentTimeInMin 
						ELSE DATEDIFF(MINUTE, USS.StartTime, USS.EndTime) END AS SpentTime,
                   USS.Comment,
                   USS.RemainingTimeInMin,
                   CASE WHEN USS.DateFrom IS NOT NULL THEN USS.DateFrom  
				        ELSE USS.StartTime END AS DateFrom,
                    CASE WHEN USS.DateTo IS NOT NULL THEN USS.DateTo  
				        ELSE USS.StartTime END AS DateTo,
                   USS.LogTimeOptionId,
                   USS.UserInput,
                   USS.UserId,
                   U.FirstName + ' ' + ISNULL(U.SurName,'') AS FullName,
                   U.ProfileImage,
                   USS.CreatedByUserId,
                   USS.CreatedDateTime,
				   USS.UpdatedByUserId,
                   USS.UpdatedDateTime,
                   EstimatedTime,
                   USInner.TotalSpentTime,
                   @RemainingSpentTime AS RemainingSpentTime
              FROM [dbo].[UserStorySpentTime] USS
                   INNER JOIN [dbo].[User] U ON U.Id = USS.UserId 
                   INNER JOIN [AuditConductQuestions] US ON US.Id = USS.UserStoryId 
                   --LEFT JOIN [Goal] G ON G.Id = US.GoalId
				   --LEFT JOIN [Sprints]S ON S.Id = US.SprintId 
                   --LEFT JOIN [Project]P ON P.Id = G.ProjectId 
				   --LEFT JOIN [Project]PS ON PS.Id = S.ProjectId
                   --LEFT JOIN [UserProject]UP ON UP.ProjectId = P.Id 
                   LEFT JOIN ( SELECT SUM(TotalSpentTime) TotalSpentTime, UserStoryId FROM (SELECT SUM(SpentTimeInMin)*1.00/60.00 TotalSpentTime,UserStoryId 
                              FROM UserStorySpentTime 
                              WHERE InActiveDateTime IS NULL
							  AND UserStoryId = @UserStoryId AND StartTime IS NULL AND EndTime IS NULL
                              GROUP BY UserStoryId 
							  UNION ALL
							  SELECT SUM(DATEDIFF(SECOND,StartTime,EndTime)/3600.0)*1.00/60.00 TotalSpentTime,UserStoryId 
                              FROM UserStorySpentTime 
                              WHERE InActiveDateTime IS NULL
							  AND UserStoryId = @UserStoryId AND StartTime IS NOT NULL AND EndTime IS NOT NULL
                              GROUP BY UserStoryId 
                                ) A GROUP BY UserStoryId)USInner ON USInner.UserStoryId = USS.UserStoryId
              WHERE U.CompanyId = @CompanyId
                   AND (@UserStorySpentTimeId IS NULL OR USS.Id = @UserStorySpentTimeId)
                   AND (USS.UserStoryId = @UserStoryId)
                   --AND ((PS.Id IN (SELECT UP.ProjectId FROM UserProject UP WHERE UP.InActiveDateTime IS NULL AND (@UserId IS NULL OR UP.UserId = @UserId))) OR (P.Id IN (SELECT UP.ProjectId FROM UserProject UP WHERE UP.InActiveDateTime IS NULL AND (@UserId IS NULL OR UP.UserId = @UserId))) OR P.ProjectName = 'Adhoc project') 
                   AND (@SpentTime IS NULL OR (USS.SpentTimeInMin/60.0) = @SpentTime)
                   AND (@Comment IS NULL OR USS.Comment = @Comment) AND ((USS.StartTime IS NULL AND USS.EndTime IS NULL) OR (USS.StartTime IS NOT NULL AND USS.EndTime IS NOT NULL))
             GROUP BY USS.Id,
                   USS.UserStoryId,
                   USS.SpentTimeInMin,
                   USS.SpentTimeInMin,
                   USS.Comment,
                   USS.RemainingTimeInMin,
                   USS.DateFrom,
                   USS.DateTo,
                   USS.LogTimeOptionId,
                   USS.UserInput,
                   USS.UserId,
                   US.EstimatedTime,
                   U.FirstName, U.SurName,
                   U.ProfileImage,
                   USS.CreatedByUserId,
                   USS.CreatedDateTime,
				   USS.UpdatedByUserId,
				   USS.UpdatedDateTime,
                   USInner.TotalSpentTime,
                   USS.RemainingTimeInMin,
				   USS.StartTime,
				   USS.EndTime
                   ORDER BY USS.CreatedDateTime DESC
                  
                   OFFSET ((@PageNo - 1) * @PageSize) ROWS
                   FETCH NEXT @PageSize ROWS ONLY
        
	  END
      ELSE
      BEGIN
	  
	    RAISERROR (@HavePermission,11, 1)
	  
      END​
       END TRY  
       BEGIN CATCH 
        
           THROW
      END CATCH
END
