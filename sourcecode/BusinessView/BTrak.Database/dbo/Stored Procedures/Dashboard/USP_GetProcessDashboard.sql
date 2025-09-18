-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-24 00:00:00.000'
-- Purpose      To Get ProcessDashboard By DashboardId Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetProcessDashboard]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@DashboardId='253'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetProcessDashboard]
(
	@DashboardId INT = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @EntityId UNIQUEIDENTIFIER = NULL,
	@TimeZone NVARCHAR(250) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

 SET NOCOUNT ON

	 BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @TimeZoneId UNIQUEIDENTIFIER = (SELECT Id FROM TimeZone WHERE TimeZone = @TimeZone)
        
		IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

		IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL

		DECLARE @Users TABLE
		(
		   UserId UNIQUEIDENTIFIER
        )

		INSERT INTO @Users(UserId)
		SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId)

        SELECT PD.Id AS ProcessDashBoardId,
			   PD.GoalId,
			   PD.MileStone,
			   CASE WHEN PD.[Delay] < 0 THEN 0 ELSE PD.[Delay] END AS [Delay],
			   PD.DashboardId,
			   PD.GeneratedDateTime,
			   TZ.TimeZoneAbbreviation GeneratedDateTimeZoneAbbreviation,
			   TZ.TimeZoneName GeneratedDateTimeZoneName,
			   CASE WHEN PD.GoalStatusColor IS NULL THEN '#b7b7b7' ELSE PD.GoalStatusColor END AS GoalStatusColor,
			   PD.CreatedByUserId AS ProcessDashBoardCreatedByUserId,
			   G.GoalResponsibleUserId,
		       U.FirstName + ' ' + ISNULL(U.SurName,'') AS GoalResponsibleUserName,
			   G.GoalName,
			   G.OnboardProcessDate,
			   TZ1.TimeZoneAbbreviation OnboardProcessDateTimeZoneAbbreviation,
			   TZ1.TimeZoneName OnboardProcessDateTimeZoneName
	    FROM [ProcessDashboard] PD WITH (NOLOCK)
			 INNER JOIN [Goal] G WITH (NOLOCK) ON G.Id = PD.GoalId
			 INNER JOIN [Project] P WITH (NOLOCK) ON P.Id = G.ProjectId
			 INNER JOIN [User] U WITH (NOLOCK) ON U.Id = G.GoalResponsibleUserId
			 INNER JOIN [Employee] E ON E.UserId = U.Id
	         INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                    AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                        AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
		     LEFT JOIN TimeZone TZ ON TZ.Id = PD.GeneratedDateTimeZoneId AND TZ.InActiveDateTime IS NULL
		     LEFT JOIN TimeZone TZ1 ON TZ1.Id = G.OnboardProcessDateTimeZoneId AND TZ1.InActiveDateTime IS NULL
	    WHERE U.CompanyId = @CompanyId
		      AND (@DashboardId IS NULL OR PD.DashboardId = @DashboardId)
			  AND (G.GoalResponsibleUserId IN (SELECT UserId FROM @Users))
		      AND (@ProjectId IS NULL OR P.Id = @ProjectId)
		ORDER BY U.FirstName

	END TRY  
	BEGIN CATCH 
		
		 THROW

	END CATCH

END
GO