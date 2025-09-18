-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-18 00:00:00.000'
-- Purpose      To Get The Each Employee WorkAllocation By Applying different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployeeWorkAllocationForIndividual_New] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeWorkAllocationForIndividual_New]
(
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
	@IsReportingOnly BIT = NULL,
    @IsMyself BIT = NULL,
    @IsAll BIT = 1,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

       DECLARE @FeatureId UNIQUEIDENTIFIER = (SELECT FeatureId
                                                    FROM CompanyModule CM 
                                                         INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL
                                                         INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = 'B424B603-1997-4E6F-8E32-82AD90097950' --Manage app filters
                                                                    AND CM.CompanyId = @CompanyId
												 GROUP BY FeatureId)
       
       DECLARE @HaveAdvancedPermission BIT = (CASE WHEN  EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)


       IF(@HaveAdvancedPermission = 0)
       BEGIN
        
     
        SET @IsReportingOnly = 1 
		SET @IsAll = 0
		SET @IsMyself = 0

       END
	   IF(@UserId IS NOT NULL)
	   BEGIN
        
     
        SET @IsReportingOnly = 0
		SET @IsAll = 0
		SET @IsMyself = 1

       END

       DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
       IF (@HavePermission = '1')
       BEGIN

        IF (@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

        IF (@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL

        IF (@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL

        IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

        SET @SearchText = '%' + @SearchText + '%'

		

        DECLARE @SortDirection NVARCHAR(50) 

        IF (@SortBy IS NULL)
        BEGIN
            SET @SortBy = 'UserName'
        END



		SELECT *
		INTO #EmployeeReportedMembers
		FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId)


	
        SELECT Z.UserId,
               Z.UserName,
               Z.[MaxDeadLineDate] AS [Date],
               Z.WorkAllocated,
               Z.MinWork,
               Z.MaxWork,
               Z.MaxDeadLineDate,
               CASE WHEN Z.WorkAllocated < Z.MinWork THEN '#ff0000'
                    WHEN Z.WorkAllocated >= Z.MinWork AND Z.WorkAllocated < Z.MaxWork THEN '#e8bd43'
                    WHEN Z.WorkAllocated >= (Z.MaxWork + 10) THEN '#008000'
                    WHEN Z.WorkAllocated >= Z.MaxWork THEN '#04fe02'
               END AS Color
        FROM
        (
            SELECT T.*,
                   CASE WHEN EWC.EmployeeId IS NULL THEN 20 ELSE EWC.MinAllocatedHours END AS MinWork,
                   CASE WHEN EWC.EmployeeId IS NULL THEN 40 ELSE EWC.MaxAllocatedHours END AS MaxWork
            FROM
            (
                SELECT E.Id AS EmployeeId,
                       U.Id UserId,
                       U.FirstName + ' ' + ISNULL(U.Surname, '') UserName,
                       ISNULL(SUM(CASE WHEN USS.Status IS NOT NULL THEN GEU.EstimatedTime ELSE 0 END),0) WorkAllocated,
                       MAX(CASE WHEN USS.Status IS NOT NULL THEN GEU.DeadLineDate ELSE NULL END) MaxDeadLineDate
                FROM [User] U WITH (NOLOCK)
                     LEFT JOIN [Ufn_GetEmployeeUserStories](NULL, NULL, @DateFrom, @DateTo, @CompanyId) GEU ON U.Id = GEU.UserId AND U.InactiveDateTime IS NULL  AND (@ProjectId IS NULL OR GEU.ProjectId = @ProjectId)
                     LEFT JOIN UserStory US WITH (NOLOCK) ON US.Id = GEU.UserStoryId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                     LEFT JOIN UserStoryStatus USS WITH (NOLOCK) ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
                               AND (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = '166DC7C2-2935-4A97-B630-406D53EB14BC' OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0')
                     LEFT JOIN Goal G ON G.Id = US.GoalId AND (G.InActiveDateTime IS NULL) AND G.ParkedDateTime IS NULL
					 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
                     LEFT JOIN Project P WITH (NOLOCK) ON P.Id = US.ProjectId AND (@ProjectId IS NULL OR P.Id = @ProjectId)
                     LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id AND E.InactiveDateTime IS NULL
                     LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                     --INNER JOIN #EmployeeReportedMembers ret ON ret.ChildId = U.Id AND U.InactiveDateTime IS NULL
                WHERE U.IsActive = 1 AND U.InactiveDateTime IS NULL AND U.CompanyId = @CompanyId
                      AND (@UserId IS NULL OR U.Id = @UserId)
					  AND (@BranchId IS NULL OR EB.BranchId = @BranchId)
                     AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
					  AND ((@IsReportingOnly = 1 AND U.Id IN (SELECT ChildId FROM #EmployeeReportedMembers WHERE (ChildId <>  @OperationsPerformedBy) OR @HaveAdvancedPermission = 0 ) OR @UserId IS  NOT NULL)
				   OR (@IsMyself = 1 AND U.Id = @OperationsPerformedBy) 
					  OR @IsAll = 1 )
                GROUP BY E.Id,U.Id,U.FirstName,U.Surname
            ) T
            LEFT JOIN EmployeeWorkConfiguration EWC ON T.EmployeeId = EWC.EmployeeId AND EWC.ActiveTo IS NULL
        ) Z
        WHERE (@SearchText IS NULL
               OR (Z.UserName LIKE @SearchText)
               OR (CONVERT(NVARCHAR(250), Z.MaxDeadLineDate) LIKE @SearchText)
               OR (CONVERT(NVARCHAR(250), Z.WorkAllocated) LIKE @SearchText)
              )
        ORDER BY (CASE WHEN @SortBy = 'UserName' THEN Z.UserName
                       WHEN @SortBy = 'MaxAllocatedDate' THEN CAST(Z.MaxDeadLineDate AS sql_variant)
                       WHEN @SortBy = 'WorkAllocate' THEN CAST(Z.WorkAllocated AS sql_variant)
                  END
                 ) ASC 
				 
		OFFSET ((@Pagenumber - 1) * @Pagesize) ROWS FETCH NEXT @Pagesize ROWS ONLY
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