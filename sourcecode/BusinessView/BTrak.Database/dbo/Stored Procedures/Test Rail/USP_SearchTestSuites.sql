-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the TestSuites By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_SearchTestSuites] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ProjectId='a2d2b024-16a1-4849-9646-148044e7813b'

CREATE PROCEDURE [dbo].[USP_SearchTestSuites]
(
    @TestSuiteId UNIQUEIDENTIFIER = NULL,
    @MultipleTestSuiteIdsXml XML = NULL,
    @TestSuiteName nvarchar(MAX) = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
	@DateFrom DATETIME = NULL,
    @DateTo DATETIME = NULL,
    @IsArchived  BIT = NULL,
	@SearchText NVARCHAR(250) = NULL,
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

			--IF (@TestSuiteId = '00000000-0000-0000-0000-000000000000') SET @TestSuiteId = NULL
            
			IF (@TestSuiteName = '') SET @TestSuiteName = NULL
            
			IF (@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL
            
			IF(@SearchText = '') SET @SearchText = NULL
		
			SET @SearchText = '%'+@SearchText+'%'

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

            CREATE TABLE #TestSuiteIds
            (
				TestSuiteId UNIQUEIDENTIFIER
            )

            IF(@MultipleTestSuiteIdsXml IS NOT NULL)
            BEGIN
              
              INSERT INTO #TestSuiteIds
              SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM  @MultipleTestSuiteIdsXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
            
            END
            
			SELECT TS.Id AS [TestSuiteId]
                  ,TS.[ProjectId]
                  ,P.ProjectName
                  ,TS.[TestSuiteName]
                  ,TS.[Description]
                  ,TS.CreatedDateTime
                  ,TS.[CreatedByUserId] AS operationsPerformedBy
				  ,U.FirstName + ' ' + U.SurName CreatedByName
                  ,U.ProfileImage CreatedByProfileImage  
                  ,(SELECT COUNT(1) FROM TestSuiteSection TSS WHERE TSS.TestSuiteId = TS.Id AND TSS.InActiveDateTime IS NULL) AS SectionsCount
                  ,(SELECT COUNT(1) FROM TestCase TC INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL AND TC.InActiveDateTime IS NULL
					WHERE TC.TestSuiteId = TS.Id  AND TC.InActiveDateTime IS NULL) AS CasesCount
                  ,(SELECT COUNT(1) FROM TestRun TR  WHERE TestSuiteId = TS.Id AND TR.InActiveDateTime IS NULL) AS RunsCount
				  ,(SELECT CAST(SUM(ISNULL(TC.Estimate,0)) AS NVARCHAR(250)) Estimate 
                    FROM TestCase TC INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL AND TC.InActiveDateTime IS NULL
	                WHERE  TC.InActiveDateTime IS NULL AND TC.TestSuiteId = TS.Id) AS TotalEstimate
				  ,(SELECT COUNT(1) FROM TestCase TC INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL  AND TC.InActiveDateTime IS NULL
					WHERE TC.TestSuiteId = TS.Id  AND TC.InActiveDateTime IS NULL AND (TC.Estimate IS NULL OR TC.Estimate = 0)) AS NoEstimateCasesCount
                  ,TS.[TimeStamp]
                  ,TotalCount = COUNT(1) OVER()
             FROM TestSuite TS WITH (NOLOCK)
                  INNER JOIN Project P WITH (NOLOCK) ON TS.ProjectId = P.Id  AND P.InActiveDateTime IS NULL
				  INNER JOIN [User] U WITH (NOLOCK) ON U.Id = TS.CreatedByUserId 
			WHERE (P.CompanyId = @CompanyId)
                   AND (@TestSuiteId IS NULL OR TS.Id = @TestSuiteId) 
                   AND (@TestSuiteName IS NULL OR  TS.TestSuiteName IN (SELECT RTRIM(LTRIM(Id)) FROM [UfnSplit](@TestSuiteName)) )
				   AND (@SearchText IS NULL OR TS.TestSuiteName LIKE @SearchText)
                   AND (@ProjectId IS NULL OR TS.ProjectId = @ProjectId)
                   AND  TS.InActiveDateTime IS NULL
				   AND ((@DateFrom IS NULL OR TS.CreatedDateTime >= @DateFrom) AND (@DateTo IS NULL OR TS.CreatedDateTime <= @DateTo))
				   AND (@MultipleTestSuiteIdsXml IS NULL OR TS.Id IN (SELECT TestSuiteId FROM #TestSuiteIds))
             ORDER BY TS.CreatedDateTime

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