-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To Save Test Rail Data
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UploadTestRailData] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--	                                @Suite  = 'QA site regression pack',
--                                    @projectname  = 'Btrak',
--                                    @Section  = 'Dashboard',
--                                    @SectionHierarchy  = 'Assets dashboard > Dashboard',
-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the Milestones By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_SearchMilestones] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@MilestoneId= '06e9e3e9-560c-4e7a-8f01-cb456c57affb'

CREATE PROCEDURE [dbo].[USP_SearchMilestones]
(
    @MilestoneId UNIQUEIDENTIFIER = NULL,
    @Title nvarchar(250) = NULL,
    @Description nvarchar(999) = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @ParentMilestoneId UNIQUEIDENTIFIER = NULL,
    @StartDate DATETIMEOFFSET = NULL,
    @EndDate DATETIMEOFFSET = NULL,
    @IsCompleted BIT = NULL,
    @IsForDropdown BIT = NULL,
    @IsStarted BIT = NULL,
    @IsArchived BIT = NULL,
	@DateFrom DATETIME = NULL,
    @DateTo DATETIME = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN 
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
		IF (@HavePermission = '1')
        BEGIN
           
		   IF (@MilestoneId = '00000000-0000-0000-0000-000000000000') SET @MilestoneId = NULL
            
            IF (@Title = '') SET @Title = NULL
            
			SET @Title = '%'+@Title+'%'
           
            IF (@Description = '') SET @Description = NULL
            
            IF (@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL
            
          --  IF (@IsArchived IS NULL) SET @IsArchived = 0
            
            	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
           
				  IF(@IsForDropdown IS NULL OR @IsForDropdown = 0)				
				  BEGIN

                   SELECT M.[Id] AS MilestoneId
                         ,M.[ProjectId]
                         ,M.[Title] AS MilestoneTitle
                         ,M.[Description]
                         ,M.ParentMilestoneId
                         ,M.StartDate
                         ,M.EndDate
                         ,M.IsCompleted
                         ,M.IsStarted
						 ,M.CreatedDateTime
                         ,M.[TimeStamp]
						 ,U.FirstName + ' ' + U.SurName CreatedByName
                         ,U.ProfileImage CreatedByProfileImage  
					     ,ISNULL(TRR.PassedCount,0) PassedCount
                         ,ISNULL(TRR.BlockedCount,0) BlockedCount
                         ,ISNULL(TRR.RetestCount,0)  RetestCount
                         ,ISNULL(TRR.FailedCount,0) FailedCount
                         ,ISNULL(TRR.UntestedCount,0) UntestedCount
						 ,ISNULL(ISNULL(TRR.TotalCount,0)-ISNULL(TRR.UntestedCount,0),0) TestedCount
						 ,ISNULL(((ISNULL(TRR.TotalCount,0)-ISNULL(TRR.UntestedCount,0))*100/(CASE WHEN TRR.TotalCount = 0 THEN 1 ELSE TRR.TotalCount END)),0)TestedPercent
                         ,ISNULL(TRR.TotalCount,0) TotalCasesCount
						 ,(ISNULL(TRR.BlockedCount,0)*100/ (CASE WHEN ISNULL(TRR.TotalCount,0) = 0 THEN 1 ELSE TRR.TotalCount END)) BlockedPercent
                         ,(ISNULL(TRR.FailedCount,0)*100/  (CASE WHEN ISNULL(TRR.TotalCount,0) = 0 THEN 1 ELSE TRR.TotalCount END)) FailedPercent
                         ,(ISNULL(TRR.PassedCount,0)*100/  (CASE WHEN ISNULL(TRR.TotalCount,0) = 0 THEN 1 ELSE TRR.TotalCount END)) PassedPercent
                         ,(ISNULL(TRR.RetestCount,0)*100/  (CASE WHEN ISNULL(TRR.TotalCount,0) = 0 THEN 1 ELSE TRR.TotalCount END)) RetestPercent
                         ,(ISNULL(TRR.UntestedCount,0)*100/(CASE WHEN ISNULL(TRR.TotalCount,0) = 0 THEN 1 ELSE TRR.TotalCount END)) UntestedPercent
                         ,(SELECT 
                                   TR.[Name] 
                                  ,TR.CreatedByUserId
                                  ,TR.CreatedDateTime AS CreatedDateTime 
                                  ,TR.Id
                                  ,TR.MilestoneId
                           FROM TestRun TR 
                                INNER JOIN TestSuite TS ON TS.Id = TR.TestSuiteId  AND TS.InActiveDateTime IS NULL
					      WHERE TR.InActiveDateTime IS NULL  AND  TR.MilestoneId = M.Id
                           FOR XML PATH('TestRunAndPlansOverviewModel'), ROOT('TestRuns'), TYPE) AS TestRunsXml
                         ,(SELECT COUNT(1) FROM TestRun TR INNER JOIN TestSuite TS ON TS.Id = TR.TestSuiteId WHERE TR.ProjectId = P.Id AND TR.MilestoneId = M.Id AND  TR.InActiveDateTime IS NULL AND TS.InActiveDateTime IS NULL ) AS TestRunsCount
                         ,TotalCount = COUNT(1) OVER()
                       FROM Milestone M WITH (NOLOCK)
                                         INNER JOIN Project P WITH (NOLOCK) ON M.ProjectId = P.Id  AND M.InActiveDateTime IS NULL
										 INNER JOIN [User]U ON U.Id = M.CreatedByUserId 
										LEFT JOIN (SELECT COUNT(CASE WHEN IsPassed = 1 THEN 1 END) AS PassedCount
                                      ,COUNT(CASE WHEN IsBlocked = 1 THEN 1 END) AS BlockedCount
                                      ,COUNT(CASE WHEN IsReTest = 1 THEN 1 END) AS RetestCount
                                      ,COUNT(CASE WHEN IsFailed = 1 THEN 1 END) AS FailedCount
                                      ,COUNT(CASE WHEN IsUntested = 1 THEN 1 END) AS UntestedCount
                                      ,COUNT(1) AS TotalCount
									  ,MilestoneId
                               FROM TestRunSelectedCase TRSC
                                    INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
                                    INNER JOIN TestSuite TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL
								    INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId  AND TC.InActiveDateTime IS NULL
			                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
                                    INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
									WHERE TRSC.InActiveDateTime IS NULL AND TC.InActiveDateTime IS NULL
									GROUP BY MilestoneId)TRR ON TRR.MilestoneId = M.Id
					   WHERE (@MilestoneId IS NULL OR M.Id = @MilestoneId) 
                               AND P.CompanyId = @CompanyId
							   AND  M.InActiveDateTime IS NULL
							   AND (@Title IS NULL OR M.Title LIKE @Title)   
                               AND (@ProjectId IS NULL OR M.ProjectId = @ProjectId)
                               AND (@StartDate IS NULL OR M.StartDate = @StartDate)
                               AND (@EndDate IS NULL OR M.EndDate = @EndDate)
                               AND (@IsCompleted IS NULL OR M.IsCompleted = @IsCompleted)
                               AND (@IsStarted IS NULL OR M.IsStarted = @IsStarted)
							   AND ((@DateFrom IS NULL OR M.CreatedDateTime >= @DateFrom) OR (@DateTo IS NULL OR M.CreatedDateTime <= @DateTo))
			
				  END
				  ELSE
				  BEGIN

					SELECT M.[Id]  ,
							M.[Title] AS [Value]
					FROM Milestone M WITH (NOLOCK) 
									INNER JOIN Project P WITH (NOLOCK) ON M.ProjectId = P.Id  AND M.InActiveDateTime IS NULL
					WHERE P.CompanyId = @CompanyId AND M.ProjectId = @ProjectId
				  END
				
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