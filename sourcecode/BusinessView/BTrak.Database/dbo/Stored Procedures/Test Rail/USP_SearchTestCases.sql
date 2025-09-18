-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-30 00:00:00.000'
-- Purpose      To Get TestCases with different filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_SearchTestCases] @OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308',@IsHierarchical=0,@SectionId='48d10fd5-688f-42b6-864e-19d49578927c'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_SearchTestCases]
(
    @TestCaseId UNIQUEIDENTIFIER = NULL,
    @SectionId UNIQUEIDENTIFIER = NULL,
    @TestSuiteId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @SortDirection NVARCHAR(100) = NULL,
    @SortBy NVARCHAR(100) = NULL,
    @Title NVARCHAR(500) = NULL,
    @CreatedOn VARCHAR(100) = NULL,
    @UpdatedOn VARCHAR(100) = NULL,
    @DateFrom DATETIME = NULL,
    @DateTo DATETIME = NULL,
    @CreatedByFilterXml XML = NULL,
    @UpdatedByFilterXml XML  = NULL,
    @AutomationTypeFilterXml XML = NULL,
    @EstimateFilterXml XML = NULL,
    @TypeFilterXml XML = NULL,
    @TemplateFilterXml XML = NULL,
    @PriorityFilterXml XML = NULL,
    @IsFromUpload BIT = NULL,
    @IsHierarchical BIT = NULL,
    @SearchText NVARCHAR(250) = NULL,
    @TestCaseIdsXml XML = NULL
)       
AS
BEGIN
    
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
	   DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
		IF (@HavePermission = '1')
        BEGIN
               DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
               IF(@TestCaseId = '00000000-0000-0000-0000-000000000000') SET @TestCaseId = NULL
               
               IF(@SectionId = '00000000-0000-0000-0000-000000000000') SET @SectionId = NULL

               IF(@SearchText = '') SET @SearchText = NULL
               
               SET @SearchText = '%'+ @SearchText +'%'
               
               IF(@Title = '') SET @Title = NULL
               
               IF(@IsHierarchical IS NULL) SET @IsHierarchical = 0
             
               DECLARE @StartDate DATETIME
               DECLARE @EndDate DATETIME
               DECLARE @UpdateStartDate DATETIME
               DECLARE @UpdateEndDate DATETIME
               
               IF(@CreatedOn = 'None')SET @CreatedOn = NULL
              
               IF(@UpdatedOn = 'None') SET @UpdatedOn = NULL
                
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
                            CREATE TABLE #TestCaseIds
                            (
                            TestCaseId UNIQUEIDENTIFIER
                            )
                            IF(@TestCaseIdsXml IS NOT NULL)
                            BEGIN
                              
                              INSERT INTO #TestCaseIds
                              SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM  @TestCaseIdsXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
                           
                            END
              SELECT TestCaseId,Title,[SectionId],[TestCaseIdentity],[TimeStamp] ,TestSuiteId,Estimate
                    ,TotalCount = COUNT(1) OVER()
			  FROM (
			  SELECT TOP 30000 /* Top is used for inner order by clause*/
                     TC.Id AS TestCaseId 
                    ,TC.Title 
                    ,TC.[SectionId]
                    ,TC.[TestCaseId] AS TestCaseIdentity     
                    ,TC.[TimeStamp]
                    ,TC.TestSuiteId
					,TC.Estimate
                    FROM TestCase TC WITH (NOLOCK)
                       INNER JOIN TestSuite TS WITH (NOLOCK) ON TS.Id = TC.TestSuiteId  AND TS.InActiveDateTime IS NULL AND TC.InActiveDateTime IS NULL 
                       INNER JOIN Project P WITH (NOLOCK) ON P.Id = TS.ProjectId AND P.InActiveDateTime IS NULL
                       LEFT JOIN #CreatedByFilter CF ON CF.CreatedBy = TC.CreatedByUserId
                       LEFT JOIN #UpdatedByFilter UF ON UF.UpdatedBy = TC.UpdatedByUserId
                       LEFT JOIN #AutomationTypeFilter AF ON AF.AutomationTypeId = TC.AutomationTypeId
                       LEFT JOIN #EstimateFilter EF ON EF.EstimateFilter = TC.Estimate
                       LEFT JOIN #PriorityFilter PF ON PF.PriorityFilterId = TC.PriorityId
                       LEFT JOIN #TemplateFilter TF ON TF.TemplateFilterId = TC.TemplateId
                       LEFT JOIN #TypeFilter TFF ON TFF.TypeId = TC.TypeId
                       LEFT JOIN #TestCaseIds TCI ON TCI.TestCaseId = TC.Id
               WHERE P.CompanyId = @CompanyId
                     AND (@TestCaseId IS NULL OR TC.Id = @TestCaseId)
                     AND (@SectionId IS NULL OR (@IsHierarchical = 0 AND TC.SectionId = @SectionId) 
                           OR (@IsHierarchical = 1 AND TC.SectionId IN (SELECT Id FROM Ufn_GetMultiSubSections(@SectionId)) ))
                     AND TC.InActiveDateTime IS NULL 
                     AND (@TestSuiteId IS NULL OR TC.TestSuiteId = @TestSuiteId)
                     AND (@TestCaseIdsXml IS NULL OR TCI.TestCaseId IS NOT NULL)
                     AND (@Title IS NULL OR TC.Title = @Title)
                     AND (@SearchText IS NULL OR TC.Title LIKE @SearchText OR TC.TestCaseId LIKE @SearchText)
                     AND (@CreatedByFilterXml IS NULL OR  CF.CreatedBy IS NOT NULL)
                     AND (@UpdatedByFilterXml IS NULL OR UF.UpdatedBy IS NOT NULL)
                     AND (@AutomationTypeFilterXml IS NULL OR AF.AutomationTypeId IS NOT NULL)
                     AND (@EstimateFilterXml IS NULL OR EF.EstimateFilter IS NOT NULL)
                     AND (@PriorityFilterXml IS NULL OR PF.PriorityFilterId IS NOT NULL)
                     AND (@TemplateFilterXml IS NULL OR TF.TemplateFilterId IS NOT NULL)
                     AND (@TypeFilterXml IS NULL OR TFF.TypeId IS NOT NULL)
                     AND (@PriorityFilterXml IS NULL OR PF.PriorityFilterId IS NOT NULL)
                     AND (@CreatedOn IS NULL OR (CONVERT(DATE,TC.CreatedDateTime) BETWEEN CONVERT(DATE,@StartDate) AND CONVERT(DATE,@EndDate)))
                     AND (@UpdatedOn IS NULL OR (CONVERT(DATE,TC.UpdatedDateTime) BETWEEN CONVERT(DATE,@UpdateStartDate)  AND CONVERT(DATE,@UpdateEndDate)))
                     AND ((@DateFrom IS NULL OR TC.CreatedDateTime >= @DateFrom ) AND (@DateTo IS NULL OR TC.CreatedDateTime <= @DateTo))
			 ORDER BY 
                       CASE WHEN( @SortDirection= 'ASC' OR @SortDirection IS NULL ) THEN
                               CASE 
                                    WHEN (@SortBy = 'CreatedOn') THEN  CONVERT(NVARCHAR(250),TC.CreatedDateTime,121) 
                                    WHEN (@SortBy IS NULL) THEN  CAST(TC.[Order] AS sql_variant)
                                    WHEN  @SortBy = 'CreatedBy' THEN  (SELECT U.FirstName FROM [User]U where U.Id = TC.CreatedByUserId )--U.FirstName
                                    WHEN  @SortBy = 'UpdatedBy' THEN  (SELECT U.FirstName FROM [User]U WHERE U.Id = TC.UpdatedByUserId )
                                    WHEN  @SortBy = 'UpdatedOn' THEN  CONVERT(NVARCHAR(250),TC.CreatedDateTime,121)
                                    WHEN  @SortBy = 'Estimate'  THEN  CAST(TC.[Estimate] AS sql_variant)
                                    WHEN  @SortBy = 'Priority'  THEN  (SELECT PriorityType FROM TestCasePriority WHERE Id = TC.PriorityId )
                                    WHEN  @SortBy = 'Title'     THEN  TC.Title
                                    WHEN  @SortBy = 'TestCaseId' THEN TC.TestCaseId
                                END 
                            END  ASC ,
                            CASE WHEN @SortDirection = 'DESC' THEN
                                  CASE
                                    WHEN (@SortBy = 'CreatedOn') THEN  CONVERT(NVARCHAR(250),TC.CreatedDateTime,121)
                                    WHEN (@SortBy IS NULL) THEN  CAST(TC.[Order] AS sql_variant)
                                    WHEN  @SortBy = 'CreatedBy' THEN  (SELECT U.FirstName FROM [User]U where U.Id = TC.CreatedByUserId )--U.FirstName
                                    WHEN  @SortBy = 'UpdatedBy' THEN  (SELECT U.FirstName FROM [User]U WHERE U.Id = TC.UpdatedByUserId )
                                    WHEN  @SortBy = 'UpdatedOn' THEN  CONVERT(NVARCHAR(250),TC.CreatedDateTime,121)
                                    WHEN  @SortBy = 'Estimate'  THEN  CAST(TC.[Estimate] AS sql_variant)
                                    WHEN  @SortBy = 'Priority'  THEN  (SELECT PriorityType FROM TestCasePriority WHERE Id = TC.PriorityId )
                                    WHEN  @SortBy = 'Title'     THEN  TC.Title
                                    WHEN  @SortBy = 'TestCaseId' THEN TC.TestCaseId
                                   END
                             END DESC,CONVERT(INT,REPLACE(TC.TestCaseId,'C',0))
							 ) MainQ 
             GROUP BY TestCaseId,Title,[SectionId],[TestCaseIdentity],[TimeStamp] ,TestSuiteId,Estimate


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