-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-08-20'
-- Purpose      To Get actively running goals under projects
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetActivelyRunningGoalsUnderProjects_New] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetActivelyRunningGoalsUnderProjects_New] 
(
    @EntityId UNIQUEIDENTIFIER = NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        
        IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

        DECLARE @CompanyId UNIQUEIDENTIFIER = ( SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	    DECLARE @EnableBugs BIT = (SELECT CAST([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')
		 
		IF (@HavePermission = '1')
		BEGIN

        SELECT G.Id GoalId,
               CASE
                   WHEN
                   (
                       GoalShortName IS NULL
                       OR GoalShortName = ''
                   ) THEN
                       GoalName
                   ELSE
                       GoalShortName
               END Goal,
               P.ProjectName
        FROM Goal G WITH (NOLOCK)
            JOIN Project P WITH (NOLOCK)
                ON G.ProjectId = P.Id
                   AND P.InActiveDateTime IS NULL
                   AND G.InActiveDateTime IS NULL
                   AND G.ParkedDateTime IS NULL
                   AND CONVERT(DATE, GETUTCDATE()) >= CONVERT(DATE, G.OnboardProcessDate)
				   AND (@ProjectId IS NULL OR G.ProjectId = @ProjectId)
            JOIN GoalStatus GS
                ON GS.Id = G.GoalStatusId
                   AND (GS.IsActive = 1)
            JOIN [User] U WITH (NOLOCK)
                ON G.GoalResponsibleUserId = U.Id
                   AND U.CompanyId = @CompanyId
                   AND U.IsActive = 1
                   AND U.InActiveDateTime IS NULL
			INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId
            INNER JOIN [Employee] E ON E.UserId = U.Id 
            INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
					AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
					AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
            JOIN [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy, @CompanyId) EM
                ON EM.ChildId = U.Id
		WHERE ((ISNULL(BT.IsBugBoard,0) = 0) OR (BT.IsBugBoard = 1 AND @EnableBugs = 1))	
        ORDER BY ProjectName
		
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
GO