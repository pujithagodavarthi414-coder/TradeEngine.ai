-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-08-30
-- Purpose      To Get the Testsuite sections for Sectionshierarichal dropdown in testsuites view by applying differnt filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTestSuiteSections] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetTestSuiteSections]
(
    @TestCaseId UNIQUEIDENTIFIER = NULL,
    @TestRunId UNIQUEIDENTIFIER = NULL,
    @SectionId UNIQUEIDENTIFIER = NULL,
    @TemplateId UNIQUEIDENTIFIER = NULL,
    @TypeId UNIQUEIDENTIFIER = NULL,
    @Estimate INT = NULL,
    @IsArchived BIT = NULL,
    @PriorityId UNIQUEIDENTIFIER = NULL,
    @AutomationTypeId UNIQUEIDENTIFIER = NULL,
    @TestCaseIdentity NVARCHAR(10) = NULL,
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
    @IsFiltersRequiered BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
          
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
        IF (@HavePermission = '1')
        BEGIN

            IF (@TestSuiteId = '00000000-0000-0000-0000-000000000000') SET @TestSuiteId = NULL
             
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
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
            
            SELECT TSS.Id SectionsId
              FROM  [dbo].[TestSuiteSection] TSS WITH (NOLOCK) 
              WHERE ((@IsFiltersRequiered IS NULL OR @IsFiltersRequiered = 0) OR (@SectionId IS NOT NULL AND (TSS.Id IN (SELECT SectionId FROM Ufn_GetMultiSectionLevel(@SectionId)))) OR TSS.Id IN 
                 (SELECT M.Id SectionId 
				         FROM 
				        (SELECT TC.SectionId 
					            FROM TestCase TC  WITH (NOLOCK) --ON TC.SectionId = TSS.Id AND TC.InActiveDateTime IS NULL
                                INNER JOIN [User]U1 WITH(NOLOCK) ON TC.CreatedByUserId = U1.Id 
                                INNER JOIN TestCaseTemplate TT WITH (NOLOCK)ON TT.Id = TC.TemplateId
                                INNER JOIN TestCaseType TCT WITH(NOLOCK) ON TCT.Id=TC.TypeId 
                                INNER JOIN TestCaseAutomationType TCAT WITH(NOLOCK) ON TCAT.Id=TC.AutomationTypeId 
                                INNER JOIN TestCasePriority TP WITH(NOLOCK) ON TP.Id = TC.PriorityId
                                INNER JOIN TestCase TC1 ON TC1.Id = TC.Id
                                INNER JOIN [User]U WITH(NOLOCK) ON TC1.CreatedByUserId = U.Id
                            WHERE  TCT.CompanyId = @CompanyId
                               AND   (@TestCaseId IS NULL OR TC.Id = @TestCaseId)
                               AND (@SectionId IS NULL OR TC.SectionId = @SectionId)
                               AND (@TemplateId IS NULL OR TC.TemplateId = @TemplateId)
                               AND (@TypeId IS NULL OR TC.TypeId = @TypeId)
                               AND (@Estimate IS NULL OR TC.Estimate = @Estimate)
                               AND TC.InActiveDateTime IS NULL
                               AND (@PriorityId IS NULL OR TC.PriorityId = @PriorityId)
                               AND (@AutomationTypeId IS NULL OR TC.AutomationTypeId = @AutomationTypeId)
                               AND (@TestCaseIdentity IS NULL OR TC.TestCaseId = @TestCaseIdentity)
                               AND (@TestSuiteId IS NULL OR TC.TestSuiteId = @TestSuiteId)
                               AND (@Title IS NULL OR TC.Title LIKE '%'+ @Title +'%')
                               AND (@CreatedByFilterXml IS NULL OR  TC1.CreatedByUserId IN (SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(800)') FROM @CreatedByFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])))
                               AND (@UpdatedByFilterXml IS NULL OR TC.CreatedByUserId IN (SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(800)') FROM @UpdatedByFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])))
                               AND (@AutomationTypeFilterXml IS NULL OR TC.AutomationTypeId IN (SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(800)') FROM @AutomationTypeFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])))
                               AND (@EstimateFilterXml IS NULL OR TC.Estimate IN (SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(800)') FROM @EstimateFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])))
                               AND (@TypeFilterXml IS NULL OR TC.PriorityId IN (SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(800)') FROM @TypeFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])))
                               AND (@TemplateFilterXml IS NULL OR TC.TemplateId IN (SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(800)')  FROM @TemplateFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])))
                               AND (@TypeFilterXml IS NULL OR TC.TypeId IN (SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(800)') FROM @TypeFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])))
                               AND (@PriorityFilterXml IS NULL OR TC.PriorityId IN (SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(800)') FROM @PriorityFilterXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])))
                               AND (@CreatedOn IS NULL OR (CONVERT(DATE,TC.CreatedDateTime) >= CONVERT(DATE,@StartDate) AND  CONVERT(DATE,TC.CreatedDateTime) <=  CONVERT(DATE,@EndDate)))
                               AND (@UpdatedOn IS NULL OR (CONVERT(DATE,TC.UpdatedDateTime) >= CONVERT(DATE,@UpdateStartDate)  AND CONVERT(DATE,TC.UpdatedDateTime) <= CONVERT(DATE,@UpdateEndDate)))
                               AND ((@DateFrom IS NULL OR TC.CreatedDateTime >= @DateFrom ) AND (@DateTo IS NULL OR TC.CreatedDateTime <= @DateTo))
                               GROUP BY TC.SectionId
                               )T CROSS APPLY Ufn_GetMultiSubSections(T.SectionId)M
                               ))
                          GROUP BY TSS.Id

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