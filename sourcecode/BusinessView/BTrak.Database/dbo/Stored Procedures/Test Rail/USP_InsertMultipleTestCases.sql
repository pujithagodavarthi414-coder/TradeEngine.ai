-------------------------------------------------------------------------------
-- Modified      Geetha Ch
-- Created      '2019-06-03 00:00:00.000'
-- Purpose      To Save the Multiple TestCases
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC[USP_InsertMultipleTestCases]
-- @SectionId = '0EFDF1ED-8561-4D24-8E65-0213F80FB9EE'
-- ,@TestSuiteId = '655EBD4A-4584-46C7-815A-D3C2ACC94EE2'
-- ,@TitleXml = '<ArrayOfString>
-- <string>
-- Title Test 1
-- </string>
-- <string>
--  Title Test 2
-- </string>
-- </ArrayOfString>'
-- ,@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-- ,@FeatureId = '64d7b42f-1b71-49bb-9c58-d9d5cc10760d'

CREATE PROCEDURE [dbo].[USP_InsertMultipleTestCases]
(
    @TitleXml  XML  = NULL,
    @SectionId UNIQUEIDENTIFIER = NULL,
    @TestSuiteId  UNIQUEIDENTIFIER = NULL,
	@UserStoryId  UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
       DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM TestSuite WHERE Id = @TestSuiteId AND InActiveDateTime IS NULL)
      
	   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

       DECLARE @RecordExist INT = (SELECT CASE WHEN InactiveDateTime IS NULL THEN 0 ELSE 1 END FROM TestSuiteSection WHERE Id = @SectionId)
            
       IF(@HavePermission = '1')
       BEGIN

       IF @RecordExist > 0
	   BEGIN 

	   RAISERROR(50026,16,1,'TestSuiteSection')

	   END
        
		ELSE IF(@TitleXml IS NULL)
        BEGIN
            
            RAISERROR(50011,16,1,'TestCases')
        
		END
		 ELSE IF ((SELECT TestSuiteSectionId FROM UserStory WHERE Id = @UserStoryId) IS NULL AND @UserStoryId IS NOT NULL)
        BEGIN
            
                RAISERROR('PleaseSelectValidTestsuiteSectionForTheUserStory',11,1)
            
        END
        ELSE
        BEGIN

            DECLARE @MaxOrderId INT = 0

            SELECT @MaxOrderId = ISNULL(Max([Order]),0) FROM TestCase WHERE SectionId = @SectionId
           
		    CREATE TABLE #TestCasetitle
            (
                Id UNIQUEIDENTIFIER,
                Title NVARCHAR(500),
                TestCaseId INT,
				TestSuiteId UNIQUEIDENTIFIER,
                OrderValue INT
            )
            INSERT INTO #TestCasetitle(Id,Title,TestSuiteId)
            SELECT T.Id,
			       T.Title,
				   @TestSuiteId 
				FROM
                (SELECT NEWID() Id,RTRIM(LTRIM([Table].[Column].value('(text())[1]', 'NVARCHAR(500)'))) Title
                   FROM @TitleXml.nodes('/ArrayOfString/string') AS [Table]([Column]))T WHERE T.Title <> '' AND T.Title IS NOT NULL
            
    --            IF((SELECT COUNT(1) FROM [dbo].[TestCase] TC  WHERE [Title] IN (SELECT Title FROM #TestCasetitle)  AND TestSuiteId = @TestSuiteId 
				--AND SectionId = @SectionId AND InactiveDateTime IS NULL)  > 0 OR (SELECT COUNT(1) AS Duplicates FROM (SELECT COUNT(1) DuplicateCount,Title FROM #TestCasetitle GROUP BY Title)T WHERE DuplicateCount>1)>0)
    --            BEGIN
                    
    --                RAISERROR('OneOfTheTestCaseInGivenTestCasesIsAlreadyExists',11,1)
                
    --            END

                UPDATE #TestCasetitle SET OrderValue = @MaxOrderId + 0, @MaxOrderId = @MaxOrderId + 1
                
                DECLARE @Currentdate DATETIME = GETDATE()
                
                DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
			   DECLARE @TestCaseId INT = (SELECT ISNULL((SELECT MAX(CAST((SUBSTRING(TC.TestCaseId,2,LEN(TC.TestCaseId))) AS INT)) 
                                                               FROM TestCase TC 
                                                                    INNER JOIN TestSuite TS ON TS.Id = TC.TestSuiteId 
                                                                    INNER JOIN Project P ON P.Id = TS.ProjectId 
                                                               WHERE P.CompanyId = @CompanyId
                                                               GROUP BY P.CompanyId
                                                               ),0))

				DECLARE @TemplateId       UNIQUEIDENTIFIER  =	  (SELECT Id  FROM TestCaseTemplate WHERE IsDefault = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)
                DECLARE @TestCaseTypeId   UNIQUEIDENTIFIER  =     (SELECT Id  FROM TestCaseType WHERE IsDefault = 1 AND CompanyId = @CompanyId  AND InActiveDateTime IS NULL )
                DECLARE @PriorityId       UNIQUEIDENTIFIER  =     (SELECT Id FROM TestCasePriority WHERE IsDefault = 1 AND CompanyId = @CompanyId  AND InActiveDateTime IS NULL)
                DECLARE @AutomationTypeId UNIQUEIDENTIFIER  =     (SELECT Id FROM TestCaseAutomationType WHERE IsDefault = 1 AND CompanyId = @CompanyId  AND InActiveDateTime IS NULL)
                DECLARE @StatusId UNIQUEIDENTIFIER  =     (SELECT Id FROM TestCaseStatus TCS WHERE TCS.IsUntested = 1 AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)
       

               UPDATE #TestCasetitle SET TestCaseId = (@TestCaseId + 0),@TestCaseId = @TestCaseId + 1
               
                  INSERT INTO [dbo].[TestCase](
                                    [Id],
                                    [TestSuiteId],
                                    Title,
                                    SectionId,
                                    TemplateId,
                                    TypeId,
                                    PriorityId,
                                    AutomationTypeId,
                                    TestCaseId,
                                    [Order],
                                    CreatedDateTime,
                                    CreatedByUserId
									)
                              SELECT Id,
                                    @TestSuiteId,
                                    Title,
                                    @SectionId,
                                    @TemplateId,
									@TestCaseTypeId,
                                    @PriorityId,
                                    @AutomationTypeId,
                                    ('C' + CAST(TestCaseId AS NVARCHAR(100))),
                                    OrderValue,
                                    @Currentdate,
                                    @OperationsPerformedBy
                                FROM #TestCasetitle
   
						     INSERT INTO [TestRunSelectedCase]
                                         (
                                         [Id],
                                         [TestCaseId],
                                         [StatusId],
                                         [TestRunId],
                                         CreatedDateTime,
                                         CreatedByUserId
                                         )
                               SELECT    NEWID(),
                                         TCT.Id,
                                         @StatusId,
                                         TR.Id,
                                         @Currentdate,
                                         @OperationsPerformedBy
                                  FROM TestRun TR INNER JOIN #TestCasetitle TCT ON TCT.TestSuiteId = TR.TestSuiteId 
								               
						          WHERE TR.IsIncludeAllCases = 1
						            	AND TR.TestSuiteId = @TestSuiteId 
						            	AND TR.InActiveDateTime IS NULL
                       
                             INSERT INTO [UserStoryScenario]
                                         (
                                         [Id],
                                         [TestCaseId],
                                         [StatusId],
                                         [UserStoryId],
                                         CreatedDateTime,
                                         CreatedByUserId
                                         )
                               SELECT    NEWID(),
                                         TCT.Id,
                                         @StatusId,
                                         @UserStoryId,
                                         @Currentdate,
                                         @OperationsPerformedBy
                                  FROM  #TestCasetitle TCT 
						          WHERE @UserStoryId IS NOT NULL

								  INSERT INTO [dbo].[TestCaseHistory](
								              [Id],
								              [TestCaseId],
								              [TestRunId],
								              [StepId],
								              [OldValue],
								              [NewValue],
								              [FieldName],
											  [ConfigurationId],
								              [FilePath],
								              [Description],
								              CreatedDateTime,
								              CreatedByUserId)
								     SELECT   NEWID(),
								              T.Id,
								              NULL,
								              NULL,
								              NULL,
								              T.Title,
								              'TestCaseCreated',
											  (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseCreatedOrUpdated' AND CompanyId = @CompanyId),
								              NULL,
								              'TestCaseAdded',
								              @Currentdate,
								              @OperationsPerformedBy
								              FROM #TestCasetitle T

									   INSERT INTO [dbo].[TestCaseHistory](
                                                   [Id],
                                                   [TestCaseId],
                                                   [TestRunId],
                                                   [OldValue],
                                                   [NewValue],
                                                   [FieldName],
                                                   [Description],
                                                   CreatedDateTime,
                                                   CreatedByUserId)
                                            SELECT NEWID(),
                                                   T.Id,
                                                   TR.Id,
                                                   NULL,
                                                   NULL,
                                                   'TestCase',
                                                   'AddedToTestRun',
                                                   @Currentdate,
                                                   @OperationsPerformedBy
											 FROM #TestCasetitle T INNER JOIN TestRun TR ON TR.TestSuiteId = T.TestSuiteId AND TR.InActiveDateTime IS NULL
											 WHERE TR.IsIncludeAllCases = 1
								  
                    
                    SELECT Id FROM #TestCasetitle
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