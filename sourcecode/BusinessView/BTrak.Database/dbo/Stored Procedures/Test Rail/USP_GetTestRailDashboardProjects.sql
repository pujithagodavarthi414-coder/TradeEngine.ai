-------------------------------------------------------------------------------
-- Author       Harika Pabbisetty
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Get the TestRailDashboardProjects
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modified      Geetha Ch
-- Created      '2019-05-16 00:00:00.000'
-- Purpose      To Get the TestRailDashboardProjects
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetTestRailDashboardProjects]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetTestRailDashboardProjects]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @IsArchived BIT = NULL  
)
AS 
BEGIN
SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			IF(@IsArchived IS NULL)SET @IsArchived = 0
           
            SELECT  P.Id AS ProjectId
                  , P.ProjectName 
                  , P.ProjectResponsiblePersonId
                  , U.ProfileImage ProjectResponsiblePersonProfileImage
                  , ISNULL(FirstName,'') + ' ' + ISNULL(SurName,'') AS ProjectResponsiblePersonName
                  , (SELECT COUNT(1) FROM TestRun TR INNER JOIN TestSuite TS ON TS.Id = TR.TestSuiteId 
                           AND TS.InActiveDateTime IS NULL AND TR.InActiveDateTime IS NULL
                           WHERE TR.ProjectId= P.Id  AND TR.InActiveDateTime IS NULL)AS TestRunCount 
                  , (SELECT COUNT(1) FROM TestSuite TS WHERE TS.ProjectId=P.Id  AND InActiveDateTime IS NULL)AS TestSuiteCount
                  , (SELECT COUNT(1) FROM Milestone M WHERE M.ProjectId=P.Id AND M.InActiveDateTime IS NULL)AS MilestoneCount
                  , ReportsInner.Counts ReportsCount
                  , ReportsInner.Counts  ReportCount
                  , (SELECT COUNT(1) FROM TestCase TC WITH(NOLOCK)
                                     INNER JOIN [dbo].[TestSuiteSection] TSS WITH(NOLOCK) ON TSS.Id = TC.SectionId AND TSS.InactiveDateTime IS NULL AND TC.InActiveDateTime IS NULL
                                     INNER JOIN [dbo].[TestSuite] TS WITH(NOLOCK) ON TS.Id = TC.TestSuiteId AND TS.InactiveDateTime IS NULL  WHERE TS.ProjectId = P.Id AND TC.InactiveDateTime IS NULL) AS CasesCount                 
                  , TotalCount = COUNT(1) OVER() 
            FROM Project P WITH (NOLOCK) 
                 LEFT JOIN [User] U WITH(NOLOCK) ON U.Id = P.ProjectResponsiblePersonId
				 LEFT JOIN (SELECT COUNT(1)Counts,ProjectId FROM TestRailReport WHERE ProjectId = @ProjectId AND InActiveDateTime IS NULL GROUP BY ProjectId
				   )ReportsInner ON ReportsInner.ProjectId = P.Id
            WHERE (@ProjectId IS NULL OR P.Id = @ProjectId)
			      AND P.ProjectName <> 'Adhoc project'
                  AND (P.CompanyId = @CompanyId)
                  AND ((@IsArchived = 0 AND P.InactiveDateTime IS NULL) OR (@IsArchived = 1 AND P.InactiveDateTime IS NOT NULL))
                  AND P.Id IN (SELECT UP.ProjectId FROM Userproject UP WHERE UP.UserId = @OperationsPerformedBy AND UP.InActiveDateTime IS NULL)
            ORDER BY P.CreatedDateTime DESC

    END TRY
    BEGIN CATCH
        
          THROW

    END CATCH
END
GO
