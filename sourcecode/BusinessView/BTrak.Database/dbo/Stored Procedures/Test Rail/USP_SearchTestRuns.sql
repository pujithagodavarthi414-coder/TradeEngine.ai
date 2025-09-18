-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the TestRuns By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_SearchTestRuns] @OperationsPerformedBy='50E77AB2-44AC-4A7A-B4A5-EE11503A44AA'

CREATE PROCEDURE [dbo].[USP_SearchTestRuns]
(
    @TestRunId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @TestSuiteId UNIQUEIDENTIFIER = NULL,
    @Name NVARCHAR(250) = NULL,
    @MilestoneId UNIQUEIDENTIFIER = NULL,
    @AssignToId UNIQUEIDENTIFIER = NULL,
    @Description NVARCHAR(999) = NULL,
    @IsIncludeAllCAses BIT = NULL,
    @IsArchived  BIT = 0,
    @IsCompleted BIT = 0,
    @DateFrom DATETIME = NULL,
    @DateTo DATETIME = NULL,
	@SortBy NVARCHAR(100) = NULL,
    @SortDirection VARCHAR(50)= NULL,
	@SearchText NVARCHAR(250)  =NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@TestRunIdsXml XML = NULL
)
AS
BEGIN 
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	   DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
		IF (@HavePermission = '1')
        BEGIN

                IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL
              
                 SET @SearchText = '%'+@SearchText+'%'

                IF(@Name = '') SET @Name = NULL

				IF(@IsCompleted IS NULL)SET @IsCompleted = 0

				 CREATE TABLE #TestRunIds
				  (
						Id UNIQUEIDENTIFIER
				  )
				  IF(@TestRunIdsXml IS NOT NULL) 
				  BEGIN
            
					SET @ProjectId = NULL
					INSERT INTO #TestRunIds(Id)
					SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
					FROM @TestRunIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
				  END

                DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                
                SELECT TR.[Id] AS TestRunId
                      ,TR.[ProjectId]
                      ,TR.[Name] AS TestRunName
                      ,TR.[MilestoneId]
                      ,M.Title AS MilestoneName
                      ,TR.[AssignToId]
					  ,T.NoEstimateCasesCount
					  ,T.Estimate TotalEstimate
					  ,U.FirstName + ' ' + U.SurName AS AssignToName
                      ,U.ProfileImage AS AssigneeProfileImage
                      ,TR.[Description]
                      ,CU.FirstName + ' ' + CU.SurName CreatedBy
                      ,CU.ProfileImage CreatedByProfileImage
                      ,TR.[IsIncludeAllCases]
                      ,TR.[CreatedDateTime] 
                      ,TR.[CreatedByUserId]
                      ,ISNULL(TR.[IsCompleted],0) [IsCompleted]
                      ,TR.[TestSuiteId]
                      ,TR.[TimeStamp]
                      ,TS.TestSuiteName
					 ,T.BlockedCount,
                      T.FailedCount,
                      T.PassedCount,
                      T.RetestCount,
                      T.UntestedCount,
                      (T.BlockedCount*100/(CASE WHEN  ISNULL(T.TotalCount,0) = 0 THEN 1 ELSE T.TotalCount END)) BlockedPercent, 
                      (T.FailedCount*100/(CASE WHEN   ISNULL(T.TotalCount,0) = 0 THEN 1 ELSE T.TotalCount END)) FailedPercent,
                      (T.PassedCount*100/(CASE WHEN   ISNULL(T.TotalCount,0) = 0 THEN 1 ELSE T.TotalCount END)) PassedPercent,
                      (T.RetestCount*100/(CASE WHEN   ISNULL(T.TotalCount,0) = 0 THEN 1 ELSE T.TotalCount END)) RetestPercent,
                      (T.UntestedCount*100/(CASE WHEN ISNULL(T.TotalCount,0) = 0 THEN 1 ELSE T.TotalCount END)) UntestedPercent,
					  T.TotalCount CasesCount
                      ,TotalCount = COUNT(1) OVER() 
                 FROM TestRun TR WITH (NOLOCK)
                      INNER JOIN  Project P WITH (NOLOCK) ON  TR.ProjectId = P.Id  AND TR.InActiveDateTime IS NULL
                      INNER JOIN TestSuite TS WITH(NOLOCK) ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL 
                      INNER JOIN [User]CU WITH(NOLOCK) ON CU.Id = TR.CreatedByUserId AND CU.InActiveDateTime IS NULL 
					  LEFT JOIN #TestRunIds TInner ON TInner.Id = TR.Id
                      LEFT JOIN (SELECT COUNT(CASE WHEN IsPassed = 1THEN 1 END) AS PassedCount
                                      ,COUNT(CASE WHEN IsBlocked =1THEN 1  END) AS BlockedCount
                                      ,COUNT(CASE WHEN IsReTest = 1THEN 1 END) AS RetestCount
                                      ,COUNT(CASE WHEN IsFailed = 1THEN 1 END) AS FailedCount
                                      ,COUNT(CASE WHEN IsUntested = 1 THEN 1 END) AS UntestedCount
                                      ,COUNT(1) AS TotalCount
									  ,TestRunId
									  ,SUM(ISNULL(TC.Estimate,0)) Estimate
									  ,COUNT(CASE WHEN ISNULL(Estimate,0) = 0 THEN 1 END) AS NoEstimateCasesCount
                               FROM TestRunSelectedCase TRSC INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId AND TC.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
			                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
                                    INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId AND TCS.InActiveDateTime IS NULL
									WHERE TC.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
								GROUP BY TestRunId)T ON T.TestRunId = TR.Id  
					  LEFT JOIN Milestone M WITH(NOLOCK) ON M.Id = TR.MilestoneId  AND M.InActiveDateTime IS NULL
                      LEFT JOIN [User]U WITH(NOLOCK) ON U.Id=TR.AssignToId  AND U.InActiveDateTime IS NULL
               WHERE (@TestRunId IS NULL OR TR.Id = @TestRunId) 
			           AND (P.CompanyId = @CompanyId)
                      AND (@ProjectId IS NULL OR TR.ProjectId = @ProjectId)
					  AND (@TestRunIdsXml IS NULL OR TInner.Id IS NOT NULL)
                      AND (@Name IS NULL OR TR.[Name] = @Name)  
					  AND (@SearchText IS NULL OR TR.[Name] LIKE @SearchText)
                      AND TR.InActiveDateTime IS NULL 
                      AND (@MilestoneId IS NOT NULL OR (TR.IsCompleted IS NULL OR TR.IsCompleted = 0) OR (@IsCompleted = 1 AND TR.IsCompleted = 1))
					  AND ((@DateFrom IS NULL OR TR.CreatedDateTime >= @DateFrom) AND (@DateTo IS NULL OR TR.CreatedDateTime <= @DateTo))
					  AND (@MilestoneId IS NULL OR TR.MilestoneId = @MilestoneId)
             ORDER BY 
                    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE  
						       WHEN(@SortBy = 'CreatedDate') THEN  CONVERT(DATETIME,TR.CreatedDateTime,121)
						       WHEN(@SortBy = 'AssignToName') THEN U.FirstName
                               WHEN @SortBy = 'TestRunName' THEN TR.[Name]
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                          CASE WHEN(@SortBy = 'CreatedDate') THEN  CONVERT(DATETIME,TR.CreatedDateTime,121)
						       WHEN(@SortBy = 'AssignToName') THEN U.FirstName
                               WHEN @SortBy = 'TestRunName' THEN TR.[Name]
                          END
                      END DESC
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
