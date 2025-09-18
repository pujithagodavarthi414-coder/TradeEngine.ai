-------------------------------------------------------------------------------
-- Modified      Manoj Kumar Gurram
-- Created      '2020-07-27 00:00:00.000'
-- Purpose      To Search the testcases in selected testrun
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetTestRunCasesByFilters]@OperationsPerformedBy='249F25D7-F8B1-4BC6-863F-A17AE9B32A47'

CREATE PROCEDURE [dbo].[USP_GetTestRunCasesByFilters]
(
  @TestRunId UNIQUEIDENTIFIER = NULL,
  @TestCaseId UNIQUEIDENTIFIER = NULL,
  @IsArchived  BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @SectionId UNIQUEIDENTIFIER = NULL,
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
  @StatusFilterXml XML = NULL,
  @StatusId NVARCHAR(50) = NULL
)
AS
BEGIN
  SET NOCOUNT ON
  BEGIN TRY
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
  
     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       
        DECLARE @HavePermission NVARCHAR(250) = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
		IF (@HavePermission = '1')
        BEGIN

			IF(@TestRunId = '00000000-0000-0000-0000-000000000000') SET @TestRunId = NULL
        	   
               IF(@TestCaseId = '00000000-0000-0000-0000-000000000000') SET @TestCaseId = NULL
         	   
               IF(@Title = '') SET @Title = NULL
         	   
               SET @Title = '%'+ @Title +'%'
          
               DECLARE @StartDate DATETIME
               DECLARE @EndDate DATETIME
               DECLARE @UpdateStartDate DATETIME
               DECLARE @UpdateEndDate DATETIME
              
			   IF(@CreatedOn = 'None')SET @CreatedOn = NULL
              
               IF(@UpdatedOn = 'None') SET @UpdatedOn = NULL
             
               IF(@CreatedOn IS NOT NULL)
               BEGIN
              
                SELECT @StartDate = T.StartDate,@EndDate = T.EndDate  FROM [Ufn_GetDatesWithText](@CreatedOn) T
              
               END
              
               IF(@UpdatedOn IS NOT NULL)
               BEGIN
               
               SELECT @UpdateStartDate = T.StartDate,@UpdateEndDate = T.EndDate FROM [Ufn_GetDatesWithText](@UpdatedOn) T
               
               END
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
                            
                            CREATE TABLE #StatusFilter
                            (
                             StatusFilterId UNIQUEIDENTIFIER
                            )
                            IF(@StatusFilterXml IS NOT NULL)
                            BEGIN
                             
                              INSERT INTO #StatusFilter
                              SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM @StatusFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
                             
                            END
      
                            SELECT TC.SectionId
                                   ,COUNT(1) OVER(PARTITION BY TC.SectionId) AS TestCasesCount
                              FROM TestRunSelectedCase TSC WITH (NOLOCK)
                                    INNER JOIN TestCase TC WITH (NOLOCK) ON TC.Id = TSC.TestCaseId AND TC.INActiveDateTime IS NULL AND TSC.InactiveDateTime IS NULL
                                    INNER JOIN TestSuiteSection TSS WITH (NOLOCK) ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
                                    INNER JOIN TestCaseStatus TCS WITH (NOLOCK) ON TSC.StatusId = TCS.Id 
                                    LEFT JOIN #CreatedByFilter CF ON CF.CreatedBy = TC.CreatedByUserId
                                    LEFT JOIN #UpdatedByFilter UF ON UF.UpdatedBy = TC.UpdatedByUserId
                                    LEFT JOIN #AutomationTypeFilter AF ON AF.AutomationTypeId = TC.AutomationTypeId
                                    LEFT JOIN #EstimateFilter EF ON EF.EstimateFilter = TC.Estimate
                                    LEFT JOIN #PriorityFilter PF ON PF.PriorityFilterId = TC.PriorityId
                                    LEFT JOIN #TemplateFilter TF ON TF.TemplateFilterId = TC.TemplateId
                                    LEFT JOIN #TypeFilter TFF ON TFF.TypeId = TC.TypeId 
                                    LEFT JOIN #StatusFilter SF ON SF.StatusFilterId = TSC.StatusId
                              WHERE TCS.CompanyId = @CompanyId
                                    AND (@TestRunId IS NULL OR TSC.TestRunId = @TestRunId)
									AND (@StatusId IS NULL OR TCS.Id = @StatusId)
                                    AND (@Title IS NULL OR TC.Title LIKE @Title OR TC.TestCaseId LIKE @Title)
                                    AND (@TestCaseId IS NULL OR TSC.TestCaseId = @TestCaseId)
                                    AND (@CreatedByFilterXml IS NULL OR  CF.CreatedBy IS NOT NULL)
                                    AND (@UpdatedByFilterXml IS NULL OR UF.UpdatedBy IS NOT NULL)
                                    AND (@AutomationTypeFilterXml IS NULL OR AF.AutomationTypeId IS NOT NULL)
                                    AND (@EstimateFilterXml IS NULL OR EF.EstimateFilter IS NOT NULL)
                                    AND (@PriorityFilterXml IS NULL OR PF.PriorityFilterId IS NOT NULL)
                                    AND (@TemplateFilterXml IS NULL OR TF.TemplateFilterId IS NOT NULL)
                                    AND (@TypeFilterXml IS NULL OR TFF.TypeId IS NOT NULL)
                                    AND (@StatusFilterXml IS NULL OR SF.StatusFilterId IS NOT NULL )
                                    AND (@CreatedOn IS NULL OR (CONVERT(DATE,TC.CreatedDateTime) >= CONVERT(DATE,@StartDate) AND  CONVERT(DATE,TC.CreatedDateTime) <=  CONVERT(DATE,@EndDate)))
                                    AND (@UpdatedOn IS NULL OR (CONVERT(DATE,TC.CreatedDateTime) >= CONVERT(DATE,@UpdateStartDate)  AND CONVERT(DATE,TC.CreatedDateTime) <= CONVERT(DATE,@UpdateEndDate)))
                                    AND ((@DateFrom IS NULL OR TC.CreatedDateTime >= @DateFrom ) AND (@DateTo IS NULL OR TC.CreatedDateTime <= @DateTo))
                                    AND TSC.InActiveDateTime IS NULL AND TC.InActiveDateTime IS NULL
                                 ORDER BY --TSC.CreatedDateTime
                                        CASE WHEN(@SortDirection= 'ASC' OR @SortDirection IS NULL) THEN
                                                  CASE 
                                                       WHEN (@SortBy = 'CreatedOn') THEN  CONVERT(NVARCHAR(250),TC.CreatedDateTime,121) 
                                                       WHEN (@SortBy IS NULL) THEN  CAST(TC.[Order] AS sql_variant)
                                                       WHEN @SortBy = 'CreatedBy'      THEN (SELECT FirstName FROM [User] WHERE Id = TC.CreatedByUserId)
                                                       WHEN @SortBy = 'UpdatedBy'      THEN (SELECT FirstName FROM [User] WHERE Id = TC.UpdatedByUserId)
                                                       WHEN @SortBy = 'UpdatedOn'      THEN CONVERT(NVARCHAR(250),TC.CreatedDateTime,121)
                                                       WHEN @SortBy = 'Estimate'       THEN CONVERT(NVARCHAR(250),TC.Estimate ,121)
                                                       WHEN @SortBy = 'Priority'       THEN (SELECT PriorityType FROM TestCasePriority WHERE Id = TC.PriorityId)
                                                       WHEN @SortBy = 'Title'          THEN TC.Title
                                                       WHEN @SortBy = 'TestCaseId'     THEN TC.TestCaseId
                                                   END
                                               END ASC,
                                               CASE WHEN @SortDirection = 'DESC' THEN
                                                     CASE 
                                                       WHEN (@SortBy = 'CreatedOn') THEN  CONVERT(NVARCHAR(250),TC.CreatedDateTime,121) 
                                                       WHEN (@SortBy IS NULL) THEN  CAST(TC.[Order] AS sql_variant)
                                                       WHEN @SortBy = 'CreatedBy'      THEN (SELECT FirstName FROM [User] WHERE Id = TC.CreatedByUserId)
                                                       WHEN @SortBy = 'UpdatedBy'      THEN (SELECT FirstName FROM [User] WHERE Id = TC.UpdatedByUserId)
                                                       WHEN @SortBy = 'UpdatedOn'      THEN CONVERT(NVARCHAR(250),TC.CreatedDateTime,121)
                                                       WHEN @SortBy = 'Estimate'       THEN CONVERT(NVARCHAR(250),TC.Estimate ,121)
                                                       WHEN @SortBy = 'Priority'       THEN (SELECT PriorityType FROM TestCasePriority WHERE Id = TC.PriorityId)
                                                       WHEN @SortBy = 'Title'          THEN TC.Title
                                                       WHEN @SortBy = 'TestCaseId'     THEN TC.TestCaseId
                                                      END
                                                END DESC,CONVERT(INT,REPLACE(TC.TestCaseId,'C',0))
                                                
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
