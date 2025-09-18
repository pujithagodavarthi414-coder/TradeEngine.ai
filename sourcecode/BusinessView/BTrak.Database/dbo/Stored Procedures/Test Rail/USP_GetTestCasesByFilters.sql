-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-10-12 00:00:00.000'
-- Purpose      To Get TestCases with different filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTestCasesByFilters] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetTestCasesByFilters]
(
    @TestCaseId UNIQUEIDENTIFIER = NULL,
    @SectionId UNIQUEIDENTIFIER = NULL,
    @TestSuiteId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @CreatedOn VARCHAR(100) = NULL,
    @UpdatedOn VARCHAR(100) = NULL,
    @CreatedByFilterXml XML = NULL,
    @UpdatedByFilterXml XML  = NULL,
    @AutomationTypeFilterXml XML = NULL,
    @EstimateFilterXml XML = NULL,
    @TypeFilterXml XML = NULL,
    @TemplateFilterXml XML = NULL,
    @PriorityFilterXml XML = NULL,
    @SearchText NVARCHAR(250) = NULL,
    @MultipleSectionIds NVARCHAR(MAX) = NULL
)       
AS
BEGIN
    
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
         DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	     IF(@HavePermission = '1')
	     BEGIN

			 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
               IF(@SearchText = '') SET @SearchText = NULL
               
               SET @SearchText = '%'+ @SearchText +'%'
               
               DECLARE @StartDate DATETIME
               DECLARE @EndDate DATETIME
               DECLARE @UpdateStartDate DATETIME
               DECLARE @UpdateEndDate DATETIME
               
               IF(@CreatedOn = 'None')SET @CreatedOn = NULL
              
               IF(@UpdatedOn = 'None') SET @UpdatedOn = NULL

               IF(@MultipleSectionIds = '') SET @MultipleSectionIds = NULL
                
               IF(@CreatedOn IS NOT NULL)
               SELECT @StartDate = T.StartDate,@EndDate = T.EndDate  FROM [Ufn_GetDatesWithText](@CreatedOn) T
             
               IF(@UpdatedOn IS NOT NULL)
               SELECT @UpdateStartDate = T.StartDate,@UpdateEndDate = T.EndDate FROM [Ufn_GetDatesWithText](@UpdatedOn) T
                              
                           CREATE TABLE #CreatedByFilter
                            (
                            CreatedBy UNIQUEIDENTIFIER
                            )
                            IF(@CreatedByFilterXml IS NOT NULL)
                            BEGIN
                              
                              INSERT INTO #CreatedByFilter
                              SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM @CreatedByFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
                            
                            END
                            CREATE TABLE #UpdatedByFilter
                            (
                            UpdatedBy UNIQUEIDENTIFIER
                            )
                            IF(@UpdatedByFilterXml IS NOT NULL)
                            BEGIN
                            
                             INSERT INTO #UpdatedByFilter
                             SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM @UpdatedByFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
                            
                            END
                            CREATE TABLE #AutomationTypeFilter
                            (
                            AutomationTypeId UNIQUEIDENTIFIER
                            )
                            IF(@AutomationTypeFilterXml IS NOT NULL)
                            BEGIN
                              
                              INSERT INTO #AutomationTypeFilter
                              SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM @AutomationTypeFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
                           
                            END
                            CREATE TABLE #EstimateFilter
                            (
                            EstimateFilter INT
                            )
                            
                            IF(@EstimateFilterXml IS NOT NULL)
                            BEGIN
                            
                             INSERT INTO #EstimateFilter
                             SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM @EstimateFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
                            
                            END
                            CREATE TABLE #TypeFilter
                            (
                            TypeId UNIQUEIDENTIFIER
                            )
                            IF(@TypeFilterXml IS NOT NULL)
                            BEGIN
                             INSERT INTO #TypeFilter
                             SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM @TypeFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
                            
                            END
                            
                            CREATE TABLE #TemplateFilter
                            (
                            TemplateFilterId UNIQUEIDENTIFIER
                            )
                            IF(@TemplateFilterXml IS NOT NULL)
                            BEGIN
                             
                             INSERT INTO #TemplateFilter
                             SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM @TemplateFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
                             
                            END
                             CREATE TABLE #PriorityFilter
                            (
                            PriorityFilterId UNIQUEIDENTIFIER
                            )
                            IF(@PriorityFilterXml IS NOT NULL)
                            BEGIN
                             
                              INSERT INTO #PriorityFilter
                              SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM @PriorityFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
                             
                            END  
          
              SELECT TC.Id AS TestCaseId 
                    ,TC.[SectionId]
                    ,CASE WHEN (COUNT(1) OVER(PARTITION BY TC.SectionId)) = CasesCount THEN 1 ELSE 0 END IsChecked
                    ,COUNT(1) OVER(PARTITION BY TC.SectionId) AS TestCasesCount
               FROM TestCase TC WITH (NOLOCK)
                       INNER JOIN TestSuite TS WITH (NOLOCK) ON TS.Id = TC.TestSuiteId  AND TS.InActiveDateTime IS NULL AND TC.InActiveDateTime IS NULL
                       INNER JOIN TestSuiteSection TSS WITH (NOLOCK) ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
                       INNER JOIN Project P WITH (NOLOCK) ON P.Id = TS.ProjectId  AND P.InActiveDateTime IS NULL
                       LEFT JOIN #CreatedByFilter CF ON CF.CreatedBy = TC.CreatedByUserId
                       LEFT JOIN #UpdatedByFilter UF ON UF.UpdatedBy = TC.UpdatedByUserId
                       LEFT JOIN #AutomationTypeFilter AF ON AF.AutomationTypeId = TC.AutomationTypeId
                       LEFT JOIN #EstimateFilter EF ON EF.EstimateFilter = TC.Estimate
                       LEFT JOIN #PriorityFilter PF ON PF.PriorityFilterId = TC.PriorityId
                       LEFT JOIN #TemplateFilter TF ON TF.TemplateFilterId = TC.TemplateId
                       LEFT JOIN #TypeFilter TFF ON TFF.TypeId = TC.TypeId
                       LEFT JOIN (SELECT SectionId,COUNT(TestCaseId) CasesCount FROM TestCase WHERE InActiveDateTime IS NULL  GROUP BY SectionId)T ON T.SectionId = TC.SectionId
               WHERE P.CompanyId = @CompanyId
                     AND (@SectionId IS NULL OR  TC.SectionId = @SectionId)
                     AND TC.InActiveDateTime IS NULL 
                     AND (@TestSuiteId IS NULL OR TC.TestSuiteId = @TestSuiteId)
                     AND (@SearchText IS NULL OR TC.Title LIKE  @SearchText OR TC.TestCaseId LIKE @SearchText)
                     AND (@CreatedByFilterXml IS NULL OR  CF.CreatedBy IS NOT NULL)
                     AND (@UpdatedByFilterXml IS NULL OR UF.UpdatedBy IS NOT NULL)
                     AND (@AutomationTypeFilterXml IS NULL OR AF.AutomationTypeId IS NOT NULL)
                     AND (@EstimateFilterXml IS NULL OR EF.EstimateFilter IS NOT NULL)
                     AND (@PriorityFilterXml IS NULL OR PF.PriorityFilterId IS NOT NULL)
                     AND (@TemplateFilterXml IS NULL OR TF.TemplateFilterId IS NOT NULL)
                     AND (@TypeFilterXml IS NULL OR TFF.TypeId IS NOT NULL)
                     AND (@PriorityFilterXml IS NULL OR PF.PriorityFilterId IS NOT NULL)
                     AND (@MultipleSectionIds IS NULL OR TC.SectionId IN (SELECT CONVERT(UNIQUEIDENTIFIER,[Value]) FROM [dbo].[Ufn_StringSplit](@MultipleSectionIds,',')))
                     AND (@CreatedOn IS NULL OR (CONVERT(DATE,TC.CreatedDateTime) >= CONVERT(DATE,@StartDate) AND  CONVERT(DATE,TC.CreatedDateTime) <=  CONVERT(DATE,@EndDate)))
                     AND (@UpdatedOn IS NULL OR (CONVERT(DATE,TC.UpdatedDateTime) >= CONVERT(DATE,@UpdateStartDate)  AND CONVERT(DATE,TC.UpdatedDateTime) <= CONVERT(DATE,@UpdateEndDate)))
           
	  END
	  ELSE
	  BEGIN
	  
	       RAISERROR (@HavePermission,16, 1)
	  
	  END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO
