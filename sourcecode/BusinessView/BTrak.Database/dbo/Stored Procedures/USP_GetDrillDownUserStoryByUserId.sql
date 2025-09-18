-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE USP_GetDrillDownUserStoryByUserId
	
	@DateFrom DATETIME = NULL,
    @DateTo DATETIME = NULL,
    @BranchId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @TeamLeadId UNIQUEIDENTIFIER = NULL,
    @UserId UNIQUEIDENTIFIER = NULL,
    @SearchText NVARCHAR(500) = NULL,
    @SortBy VARCHAR(500) = NULL,
    @EntityId UNIQUEIDENTIFIER = NULL,
    @PageSize INT = 10,
    @PageNumber INT = 1,
    @OperationsPerformedBy UNIQUEIDENTIFIER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @CompanyId UNIQUEIDENTIFIER = (
                                                  SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)
                                              )

    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF(@HavePermission = '1')
		BEGIN 
			SELECT U.Id UserId,
				GEU.UserStoryId,
				GEU.ProjectId,
                GEU.UserStoryName,
				GEU.UserStoryUniqueName,
				ISNULL(GEU.GoalName,'N/A') AS GoalName,
				GEU.ProjectName,
				GEU.EstimatedTime,
                GEU.SprintId,
				ISNULL(GEU.SprintName,'N/A') AS SprintName

                FROM [User] U WITH (NOLOCK) LEFT JOIN (SELECT GEU.*  FROM  [Ufn_GetEmployeeUserStories](@UserId, NULL, @DateFrom, @DateTo, @CompanyId) GEU
                    INNER JOIN UserStory US WITH (NOLOCK)
                        ON US.Id = GEU.UserStoryId
                           AND US.InActiveDateTime IS NULL
                           AND US.ParkedDateTime IS NULL
					 INNER JOIN Project P WITH (NOLOCK)
                        ON P.Id = US.ProjectId
                           AND (
                                   @ProjectId IS NULL
                                   OR P.Id = @ProjectId
                               )         
                    INNER JOIN UserStoryStatus USS WITH (NOLOCK)
                        ON USS.Id = US.UserStoryStatusId
                           AND USS.InActiveDateTime IS NULL
                         AND (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '166DC7C2-2935-4A97-B630-406D53EB14BC'
                             OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0')
                    LEFT JOIN Goal G
                        ON G.Id = US.GoalId
                           AND (G.InActiveDateTime IS NULL)
                           AND G.ParkedDateTime IS NULL
                      LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
					  WHERE ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL)
					   OR (US.GoalId IS NOT NULL AND G.Id IS NOT NULL)))GEU ON GEU.UserId = U.Id
                     
                WHERE U.IsActive = 1 AND U.Id = @UserId
                      AND U.InactiveDateTime IS NULL
                      AND U.CompanyId = @CompanyId
                     -- AND GEU.Status = 'New' OR GEU.Status='Inprogress'
                      
                GROUP BY U.Id,
                         U.FirstName,
                         U.Surname,
						 GEU.UserStoryName,
						 GEU.GoalName,
						 GEU.ProjectName,
						 GEU.UserStoryId,
						 GEU.ProjectId,
						 GEU.EstimatedTime,
						 GEU.UserStoryUniqueName,
                         GEU.SprintId,
				         GEU.SprintName

				 OPTION(RECOMPILE)
    	
		END


	END TRY
	    BEGIN CATCH
        THROW
    END CATCH
END
GO