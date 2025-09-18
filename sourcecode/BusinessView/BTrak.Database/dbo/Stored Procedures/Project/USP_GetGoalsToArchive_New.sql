-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-06 00:00:00.000'
-- Purpose      To Get Goals To Archive By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetGoalsToArchive_New] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetGoalsToArchive_New]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
  @SortBy NVARCHAR(100) = NULL,
  @EntityId UNIQUEIDENTIFIER = NULL,
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @SortDirection NVARCHAR(100)=NULL,
  @SearchText  NVARCHAR(100)=NULL,
  @PageNumber INT = 1,
  @PageSize INT = 10
)
AS
BEGIN
SET NOCOUNT ON
BEGIN TRY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       
    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
			IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

    IF (@HavePermission = '1')
    BEGIN

		 SELECT  P.ProjectName, 
                  G.GoalShortName GoalName,
                  G.Id GoalId,
                  P.Id ProjectId,
                  TotalCount = COUNT(1) OVER()
          FROM Project P WITH (NOLOCK) 
               JOIN Goal G WITH (NOLOCK) ON P.Id = G.ProjectId AND G.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
			                                                           AND P.InActiveDateTime IS NULL 
																	   AND G.ParkedDateTime IS NULL 
									AND P.Id IN (SELECT UP.ProjectId FROM USerProject UP WHERE UP.InActiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)												       
	           JOIN [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) EM ON EM.ChildId =  G.GoalResponsibleUserId
               JOIN UserStory US WITH (NOLOCK) ON US.GoalId = G.Id AND US.InActiveDateTime IS NULL AND US.ArchivedDateTime IS NULL
               JOIN UserStoryStatus USS WITH (NOLOCK) ON USS.Id = US.UserStoryStatusId
               INNER JOIN GoalStatus GS WITH (NOLOCK) ON GS.Id = G.GoalStatusId AND GS.IsActive = 1 
               JOIN BoardType BT WITH (NOLOCK) ON BT.Id = G.BoardTypeId
               JOIN [User] U WITH (NOLOCK)
                ON G.GoalResponsibleUserId = U.Id
                   AND U.CompanyId = @CompanyId
                   AND U.IsActive = 1
                   AND U.InActiveDateTime IS NULL
               INNER JOIN [Employee] E ON E.UserId = U.Id 
               INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	               AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
				   AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
         WHERE NOT EXISTS (SELECT 1
                           FROM Project P WITH (NOLOCK) 
                           INNER JOIN Goal G1 WITH (NOLOCK) ON P.Id = G1.ProjectId AND G1.InActiveDateTime IS NULL
									                                                       AND P.InActiveDateTime IS NULL
																					       AND G1.InActiveDateTime IS NULL
									AND P.Id IN (SELECT UP.ProjectId FROM USerProject UP WHERE UP.InActiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)												       
                           INNER JOIN UserStory US WITH (NOLOCK) ON US.GoalId = G1.Id 
								  AND US.InActiveDateTime IS NULL
                           INNER JOIN UserStoryStatus USS WITH (NOLOCK) ON USS.Id = US.UserStoryStatusId 
							      AND USS.InActiveDateTime IS NULL
								  AND USS.TaskStatusId IN('F2B40370-D558-438A-8982-55C052226581','6BE79737-CE7C-4454-9DA1-C3ED3516C7F0','5C561B7F-80CB-4822-BE18-C65560C15F5B','166DC7C2-2935-4A97-B630-406D53EB14BC')
								  --AND USS.IsQaApproved IS NULL AND USS.IsSignedOff IS NULL 
                                  --AND USS.IsVerified IS NULL AND USS.IsCompleted IS NULL
						  INNER JOIN GoalStatus GS WITH (NOLOCK) ON GS.Id = G1.GoalStatusId
									                                                            AND GS.InActiveDateTime IS NULL 
																						  AND GS.IsActive = 1
                                       INNER JOIN BoardType BT WITH (NOLOCK) ON BT.Id = G1.BoardTypeId
								     WHERE (G1.Id = G.Id)
                                        )
              AND P.CompanyId = @CompanyId
			  AND (@ProjectId IS NULL OR G.ProjectId = @ProjectId)
              AND (@SearchText IS NULL 
                   OR P.ProjectName LIKE '%'+ @SearchText+'%'
                   OR G.GoalName LIKE '%'+ @SearchText+'%')
          GROUP BY P.Id,P.ProjectName,G.Id,G.GoalShortName,G.GoalName
          ORDER BY 
          CASE WHEN (@SortDirection IS NULL OR @SortDirection= 'ASC') THEN 
               (CASE WHEN @SortBy='ProjectName' THEN P.ProjectName
                     WHEN @SortBy='GoalName' THEN G.GoalName
                END)
          END ASC,
          CASE WHEN @SortDirection = 'DESC' THEN
               (CASE WHEN @SortBy='ProjectName' THEN P.ProjectName
                     WHEN @SortBy='GoalName' THEN G.GoalName
               END)              
          END DESC
          OFFSET ((@PageNumber - 1) * @PageSize) ROWS
          FETCH NEXT @PageSize ROWS ONLY

	 END				
	 ELSE 
	 BEGIN
	 
			RAISERROR(@HavePermission,11,1)
     
	 END
	 END TRY  
     BEGIN CATCH 
        
        THROW
    END CATCH
END