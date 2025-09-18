--EXEC [dbo].[USP_GetRemainingWorkAllocatedForAnEmployee] @OperationsPerformedBy='9DB68192-202F-42B0-8358-6800F6C0C900'
--select * from [Ufn_GetEmployeeRemainingUserStories] ('00000000-0000-0000-0000-000000000000','EECA74F9-ABE1-4F6C-994D-70289802A3D8')		  
--select * from UserStoryStatus where CompanyId='EECA74F9-ABE1-4F6C-994D-70289802A3D8'
CREATE PROCEDURE [dbo].[USP_GetRemainingWorkAllocatedForAnEmployee]
(
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
         DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
         
         SELECT Z.UserName AS [Employee name],
				Z.WorkAllocated AS [Work allocated],
				Z.MaxDeadLineDate AS [Max deadline]
         FROM 
		      (SELECT T.*
               FROM 
			        (SELECT E.Id AS EmployeeId,U.Id UserId,U.FirstName + ' ' + ISNULL(U.Surname,'') UserName,ISNULL(SUM(GEU.EstimatedTime),0) WorkAllocated,Max(GEU.DeadLineDate) MaxDeadLineDate
                     FROM [Ufn_GetEmployeeRemainingUserStories]('00000000-0000-0000-0000-000000000000',@CompanyId) GEU
					      INNER JOIN UserStoryStatus USS WITH (NOLOCK) ON USS.Id = GEU.UserStoryStatusId
						  AND (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0' OR USS.TaskStatusId = '166DC7C2-2935-4A97-B630-406D53EB14BC')
						  --AND (USS.IsNew = 1 OR USS.IsBlocked = 1 OR USS.IsInprogress = 1 OR USS.IsAnalysisCompleted = 1 OR IsDevInprogress = 1 OR USS.IsNotStarted = 1) 
                          LEFT JOIN [User] U WITH (NOLOCK) ON U.Id = GEU.UserId AND U.InActiveDateTime IS NULL
                          LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
                          LEFT JOIN EmployeeBranch EB WITH (NOLOCK) ON E.Id = EB.EmployeeId
                          INNER JOIN UserStory US WITH (NOLOCK) ON US.Id=GEU.UserStoryId AND US.InActiveDateTime IS NULL
						  INNER JOIN Project P WITH (NOLOCK) ON US.ProjectId = P.Id AND P.InActiveDateTime IS NULL
                          LEFT JOIN Goal G WITH (NOLOCK) ON G.Id=US.GoalId AND G.InActiveDateTime IS NULL AND (G.IsApproved IS NULL)
							AND (G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL) --AND G.ArchivedDateTime IS NULL
                          LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
                      WHERE U.IsActive = 1
							AND (US.ArchivedDateTime IS NULL AND US.InActiveDateTime IS NULL)
							AND (US.ParkedDateTime IS NULL)
                            AND U.CompanyId = @CompanyId
                            AND U.Id = @OperationsPerformedBy
                      GROUP BY E.Id,U.Id,U.FirstName,U.Surname) T 
		        LEFT JOIN EmployeeWorkConfiguration EWC ON T.EmployeeId = EWC.EmployeeId AND EWC.ActiveTo IS NULL) Z
       END
       END TRY  
       BEGIN CATCH 

           EXEC USP_GetErrorInformation

       END CATCH
END