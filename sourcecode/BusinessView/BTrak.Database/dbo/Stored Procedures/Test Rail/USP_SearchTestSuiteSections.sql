-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the TestSuiteSections By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_SearchTestSuiteSections] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TestSuiteId='19cb92ae-b4a3-4aae-85e4-c148bad6aadb'

CREATE PROCEDURE [dbo].[USP_SearchTestSuiteSections] 
(
    @TestSuiteSectionId UNIQUEIDENTIFIER = NULL,
    @SectionName nvarchar(250) = NULL,
    @TestSuiteId UNIQUEIDENTIFIER = NULL,
    @IsFromTestRunUplaods BIT  =NULL,
    @TestRunId  UNIQUEIDENTIFIER = NULL,
    @IsSectionsRequired BIT = NULL,
    @ParentSectionId UNIQUEIDENTIFIER = NULL,
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

		 IF (@TestSuiteSectionId = '00000000-0000-0000-0000-000000000000') SET @TestSuiteSectionId = NULL
                 
                 IF (@SectionName = '') SET @SectionName = NULL
                 
                 IF(@IsSectionsRequired IS NULL ) SET @IsSectionsRequired = 0
                 
                 IF (@TestSuiteId = '00000000-0000-0000-0000-000000000000') SET @TestSuiteId = NULL
                 
                 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
         
                 DECLARE @Count INT  = (SELECT COUNT(1) FROM TestRunSelectedCase WHERE TestRunId = @TestRunId  AND InActiveDateTime IS NULL)
         
                 CREATE TABLE #Temp 
                 (
                 SectionId UNIQUEIDENTIFIER
                 )     
		        IF(@IsSectionsRequired =  1 )
                BEGIN
                 
                ;WITH Tree AS
                (
                
                SELECT TS_Parent.Id AS TestSuiteSectionId,TS_Parent.ParentSectionId
                FROM TestSuiteSection TS_Parent
                WHERE TS_Parent.Id IN (SELECT SectionId FROM TestCase TC INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id
                                                                                                  AND TC.InActiveDateTime IS NULL  AND TRSC.InActiveDateTime IS NULL
																				 INNER JOIN TestSuiteSection TSS ON TC.SectionId = TSS.Id AND TSS.InactiveDateTime IS NULL
                WHERE  TSS.TestSuiteId = @TestSuiteId AND TRSC.TestRunId = @TestRunId AND TC.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL) AND InActiveDateTime IS NULL 
                UNION ALL
                SELECT TS_Child.Id TestSuiteSectionId,TS_Child.ParentSectionId
                FROM TestSuiteSection TS_Child INNER JOIN Tree ON Tree.ParentSectionId = TS_Child.Id  AND TS_Child.InActiveDateTime IS NULL
                WHERE TS_Child.InActiveDateTime IS NULL 
     	        
                )
                INSERT INTO #Temp(SectionId)
                SELECT TestSuiteSectionId FROM Tree  GROUP BY TestSuiteSectionId
                UNION ALL
                SELECT Id TestSuiteSectionId FROM TestSuiteSection TSS INNER JOIN Tree ON TREE.ParentSectionId = TSS.Id  AND TSS.InActiveDateTime IS NULL 
                END        
    
                 SELECT TSS.Id AS TestSuiteSectionId
                       ,TSS.[TestSuiteId]
                       ,TS.[TestSuiteName]
                       ,TSS.[SectionName]
					   ,TS.[Description] TestSuiteDescription
                       ,TSS.[Description]
					   ,(SELECT CAST(ISNULL(T.Estimate,0)/(60.0*60.0) AS decimal(10,2)) FROM(SELECT SUM(ISNULL(Estimate,0))Estimate FROM TestCase WHERE SectionId = TSS.Id AND InActiveDateTime IS NULL)T) SectionEstimate
                       ,TSS.[CreatedDateTime]
                       ,TSS.[CreatedByUserId]
                      ,(CASE WHEN @TestSuiteSectionId IS NULL THEN 1 ELSE (SELECT MAX(T.[level]) FROM Ufn_GetMultiSectionLevel(@TestSuiteSectionId)T ) END) SectionLevel
                       ,TSS.[ParentSectionId]
					   ,TSS1.SectionName ParentSectionName
                       ,CASE WHEN (SELECT COUNT(1)FROM TestSuiteSection TSS INNER JOIN TestCase TC ON TC.SectionId = TSS.Id  AND TSS.InActiveDateTime IS NULL AND TC.InActiveDateTime IS NULL
                                                                            INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id  AND TRSC.InActiveDateTime IS NULL
                                                                            WHERE TRSC.TestRunId = @TestRunId
                                                                             )>0 THEN 1 ELSE 0 END AS IsSelectedSection
                       ,(SELECT COUNT(1) FROM TestCase TC WHERE TC.SectionId = TSS.Id AND TC.InActiveDateTime IS NULL) CasesCount
                       ,TSS.[TimeStamp]
                       ,TotalCount = COUNT(1) OVER()
                 FROM TestSuiteSection TSS WITH (NOLOCK)
                       INNER JOIN TestSuite TS WITH (NOLOCK) ON TSS.TestSuiteId = TS.Id 
                       INNER JOIN Project P WITH (NOLOCK) ON TS.ProjectId = P.Id 
					   LEFT JOIN #Temp T ON T.SectionId = TSS.Id
					   LEFT JOIN TestSuiteSection TSS1 ON TSS1.Id = TSS.ParentSectionId AND TSS1.InActiveDateTime IS NULL
                 WHERE (P.CompanyId = @CompanyId)
                       AND (@SectionName IS NULL OR TSS.SectionName = @SectionName)
                       AND ((@IsFromTestRunUplaods IS NULL OR @IsFromTestRunUplaods = 0) OR (@ParentSectionId IS NULL AND TSS.ParentSectionId IS NULL) OR TSS.ParentSectionId = @ParentSectionId)
                       AND (@TestSuiteId IS NULL OR TS.Id = @TestSuiteId)
                       AND TSS.InActiveDateTime IS NULL
                       AND (@TestSuiteSectionId IS NULL OR TSS.Id = @TestSuiteSectionId) 
                       AND (@IsSectionsRequired = 0 OR T.SectionId IS NOT NULL )
					 GROUP BY TSS.Id ,TSS.[TestSuiteId],TS.[TestSuiteName],TSS.[SectionName],TS.[Description],
					 TSS.[Description],TSS.[CreatedDateTime],TSS.[CreatedByUserId],TSS.[TimeStamp],TSS.ParentSectionId,TSS1.[SectionName]
                 ORDER BY TSS.CreatedDateTime
            
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