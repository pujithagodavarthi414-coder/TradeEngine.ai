---------------------------------------------------------------------------------
---- Author       Mahesh Musuku
---- Created      '2019-07-05 00:00:00.000'
---- Purpose      To Upload the testrun data
---- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved select * from TestRun
---------------------------------------------------------------------------------

----EXEC [dbo].[USP_UploadTestRunData]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TestSuiteName='Test',@ProjectName='Testproject',@TestCaseTitle='CaseTest'

--CREATE PROCEDURE [dbo].[USP_UploadTestRunData]
--(
--    @TestSuiteName NVARCHAR(250) = NULL,
--    @ProjectName NVARCHAR(250) = NULL,
--    @TestCaseTitle NVARCHAR(250) = NULL,
--    @AssignToName NVARCHAR(250) = NULL,
--    @TestCaseStatus NVARCHAR(250) = NULL,
--    @TestCaseComment NVARCHAR(500) = NULL,
--    @Version INT = NULL,
--    @Elapsed DATETIME= NULL,
--	@SectionHierarchy NVARCHAR(MAX) = NULL,
--    @StepStatusXml XML = NULL,
--    @TestRunName NVARCHAR(250) = NULL,
--    @OperationsPerformedBy UNIQUEIDENTIFIER,
--	@CreatedDateTime NVARCHAR(100) = NULL
--)
--AS
--BEGIN
    
--    SET NOCOUNT ON
--    BEGIN TRY
--     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
        
--               	DECLARE @Currentdate DATETIME = GETDATE()

--			   SET @CreatedDateTime = ISNULL(@CreatedDateTime,@Currentdate)
               
--			   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                
--               DECLARE @projectId UNIQUEIDENTIFIER = (SELECT OriginalId FROM [Project] WHERE ProjectName = RTRIM(LTRIM(@projectname))  AND InActiveDateTime IS NULL)
              
--			   DECLARE @TestSuiteId UNIQUEIDENTIFIER = (SELECT Id FROM [TestSuite] WHERE TestSuiteName = RTRIM(LTRIM(@TestSuiteName)) AND ProjectId = @ProjectId  AND InActiveDateTime IS NULL)
               
--			   DECLARE @AssignToId UNIQUEIDENTIFIER = (SELECT OriginalId FROM [User] WHERE FirstName = (Select TOP 1 * From string_split(@AssignToName,' ')))
               
--			   DECLARE @TestCaseStatusId UNIQUEIDENTIFIER  = (SELECT OriginalId FROM [TestCaseStatus] WHERE [Status] = RTRIM(LTRIM(@TestCaseStatus))  AND InActiveDateTime IS NULL)
               
--			   DECLARE @TestRunId UNIQUEIDENTIFIER = (SELECT OriginalId FROM [TestRun] WHERE [Name] = RTRIM(LTRIM(@TestRunName))  AND InActiveDateTime IS NULL AND TestSuiteId = @TestSuiteId AND ProjectId = @projectId) 
                
--				DECLARE @SectionId UNIQUEIDENTIFIER 

--				  DECLARE @Temp TABLE  -- Table for storing sctions and id's
--			        (
--			           Id INT IDENTITY(1,1),
--			           TestSectionName NVARCHAR(250),
--			           TestSectionId UNIQUEIDENTIFIER,
--			           ParentSectionId UNIQUEIDENTIFIER
--			        )

--				INSERT INTO @Temp(TestSectionName)
--				SELECT LTRIM(RTRIM(Value)) FROM Ufn_StringSplit(@SectionHierarchy,'>')

--				 DECLARE @Count INT = 1

--				 WHILE @Count <= (SELECT MAX(Id) FROM @Temp) -- Inserting Sections into [TestSuiteSection] if section is not exist
--			         BEGIN
			               
						    
--			               UPDATE @Temp SET TestSectionId = TS.OriginalId FROM [dbo].[TestSuiteSection] TS LEFT JOIN @Temp T ON T.TestSectionName = TS.SectionName AND TestSuiteId = @TestSuiteId  AND InActiveDateTime IS NULL WHERE T.Id = @Count AND ((T.ParentSectionId IS NULL AND TS.ParentSectionId IS NULL)  OR TS.ParentSectionId = T.ParentSectionId ) 
			         
--			               SET @SectionId = (SELECT TestSectionId FROM @Temp WHERE Id = @Count) 
			               
--			               UPDATE @Temp SET ParentSectionId = @SectionId WHERE Id = @Count+1
			              
--						   SET @Count = @Count + 1
--			   END
	

--			--	SET @SectionId  = (SELECT OriginalId FROM TestSuiteSection WHERE SectionName = (SELECT SectionName FROM @Temp WHERE Id = (SELECT MAX(Id) FROM @Temp)) AND TestSuiteId = @TestSuiteId AND AsAtInactiveDateTime IS NULL AND  InactiveDateTime IS NULL)

--			    DECLARE @TestCaseId UNIQUEIDENTIFIER = (SELECT  Id FROM TestCase WHERE Title = RTRIM(LTRIM(@TestCaseTitle)) AND TestSuiteId = @TestSuiteId  AND InActiveDateTime IS NULL AND TestSuiteId = @TestSuiteId AND SectionId = @SectionId)
                

--				IF(@TestRunId IS NULL)
--                BEGIN
              
--			    SET @TestRunId = NEWID()
                 
--				 INSERT INTO [dbo].[TestRun](
--                                             [Id],
--                                             [ProjectId],
--                                             [TestSuiteId],
--                                             [Name],
--                                             [AssignToId],
--                                             [Description],
--                                             [IsIncludeAllCases],
--                                             [InActiveDateTime],
--                                             [IsCompleted],
--                                             [CreatedDateTime],
--                                             [OriginalCreatedDateTime],
--                                             [CreatedByUserId],
--                                             VersionNumber,
--                                             OriginalId)
--                                      SELECT @TestRunId,
--                                             @ProjectId,
--                                             @TestSuiteId,
--                                             RTRIM(LTRIM(@TestRunName)),
--                                             @AssignToId,
--                                             NULL,
--                                             NULL,
--                                             NULL,
--                                             NULL,
--                                             @Currentdate,
--                                             @CreatedDateTime,
--                                             @OperationsPerformedBy,
--                                             1,
--                                             @TestRunId
--                        END
            
                    
				
					   
--					   DECLARE @TestRunSelectedCaseId UNIQUEIDENTIFIER = (SELECT OriginalId FROM TestRunSelectedCase WHERE TestCaseId = @TestCaseId  AND TestRunId = @TestRunId  AND InActiveDateTime IS NULL)
					   
--					   IF(@TestRunSelectedCaseId IS NULL)
--					   BEGIN

--					        SET @TestRunSelectedCaseId = NEWID()

--					      INSERT INTO [dbo].[TestRunSelectedCase]
--                                     (
--                                     [Id],
--                                     [TestRunId],
--                                     [TestCaseId],
--                                     [StatusId],
--                                     [StatusComment],
--                                     [AssignToComment],
--                                     [AssignToId],
--                                     [Version],
--                                     [Elapsed],
--                                     [InActiveDateTime],
--                                     [CreatedDateTime],
--                                     [CreatedByUserId],
--                                     VersionNumber,
--                                     OriginalId)
--                              SELECT @TestRunSelectedCaseId,
--                                     @TestRunId,
--                                     @TestCaseId,
--                                     @TestCaseStatusId,
--                                     @TestCaseComment,
--                                     NULL,
--                                     @AssignToId,
--                                     @Version,
--                                     @Elapsed,
--                                     NULL,
--                                     @CreatedDateTime,
--                                     @OperationsPerformedBy,
--                                     1,
--                                     @TestRunSelectedCaseId
                        
--						   END
--                               DECLARE @TestCaseDependency TABLE
--                               (
--							       RowNo INT IDENTITY(1,1),
--                                   Id UNIQUEIDENTIFIER,
--                                   StepText NVARCHAR(MAX),
--                                   [Status]  NVARCHAR(250) ,
--								   StepId  UNIQUEIDENTIFIER,
--                                   ActualResult NVARCHAR(2000)
--                               )
--                                    INSERT INTO @TestCaseDependency(Id,StepText,ActualResult,[Status])
--                                    SELECT  NEWID(), 
--                                             RTRIM(LTRIM([Table].[Column].value('StepText[1]', 'varchar(MAX)'))),
--                                             [Table].[Column].value('StepActualResult[1]', 'varchar(1000)'),
--                                             [Table].[Column].value('StepStatusId[1]', 'Nvarchar(50)') 
--                                    FROM @StepStatusXml.nodes('/ArrayOfTestCaseStepMiniModel/TestCaseStepMiniModel') AS [Table]([Column])
               
--			               UPDATE TestRunSelectedStep SET AsAtInactiveDateTime = GETDATE() WHERE TestRunId = @TestRunId  AND StepId IN (SELECT StepId FROM @TestCaseDependency )

--                                    INSERT INTO TestRunSelectedStep(
--                                                [Id],
--                                                [TestRunId],
--                                                [StepId],
--                                                [StatusId],
--                                                [ActualResult],
--                                                InActiveDateTime,
--                                                CreatedDateTime,
--                                                CreatedByUserId,
--                                                VersionNumber,
--                                                OriginalId)
--                                         SELECT Id,
--                                                @TestRunId, 
--                                                (SELECT OriginalId FROM TestCaseStep WHERE Step = T.StepText AND TestCaseId = @TestCaseId  AND InActiveDateTime IS NULL),
--                                                (SELECT  OriginalId FROM TestCaseStatus WHERE [Status] = T.[Status]  AND InActiveDateTime IS NULL ),
--                                                ActualResult,
--                                                NULL,
--                                                @Currentdate,
--                                                @OperationsPerformedBy,
--                                                 1,
--                                                Id
--                                           FROM @TestCaseDependency T 
               
--                   SELECT OriginalId FROM TestRunSelectedCase WHERE OriginalId = @TestRunSelectedCaseId 
            
--    END TRY
--    BEGIN CATCH
        
--        EXEC [dbo].[USP_GetErrorInformation]

--    END CATCH
    
--END