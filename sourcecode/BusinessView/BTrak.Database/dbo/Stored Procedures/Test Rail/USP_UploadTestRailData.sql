---------------------------------------------------------------------------------
---- Author       Geetha Ch
---- Created      '2019-03-18 00:00:00.000'
---- Purpose      To Save Test Rail Data
---- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----EXEC [dbo].[USP_UploadTestRailData] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
----	                                @Suite  = 'QA site regression pack',
----                                    @projectname  = 'Btrak',
----                                    @Section  = 'Dashboard',
----                                    @SectionHierarchy  = 'Assets dashboard > Dashboard',
----                                    @Title  = 'user should able to see the "Assets dashboard" module at the side bar',
----                                    @Template  = 'Test Case (Steps)',
----                                    @AutomationType  = 'None',
----                                    @Priority  = 'High',
----                                    @Type  = 'Other',
----                                    @Estimate  = '20',
----                                    @References  = NULL,
----                                    @Steps  = '1.Click on "Locations Management" displayed under Assets.
----	                                		     2.Click on Next button displayed below table.
----	                                		     3.Click on Previous button displayed below table.',
----                                    @ExpectedResult  = '1. The user should log in to the account successfully.
----	                                					  2. The user should see the Assets dashboard at the sidebar',
----                                    @Forecast  = NULL,
----                                    @Mission  = NULL,
----                                    @Goals  = NULL,
----                                    @Preconditions  = 'The user should able to see the "Assets dashboard" at the sidebar',
----                                    @CreatedDateTime  = '3/20/2019 3:51 AM',
----                                    @UpdatedDateTime  = NULL
----									  @TestCaseStepsXml = '<ArrayOfTestCaseStepMiniModel xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
----                                                          <TestCaseStepMiniModel>
----                                                          <StepId xsi:nil="true" />
----                                                          <StepText>1. Execute Test Case C27179</StepText>
----                                                          <StepExpectedResult>Test Case C27179 should get passed</StepExpectedResult>
----                                                          <StepStatusId xsi:nil="true" />
----                                                          </TestCaseStepMiniModel>
----                                                          <TestCaseStepMiniModel>
----                                                          <StepId xsi:nil="true" />
----                                                          <StepText>2. Click on icon on the right side of the Starters and Leavers lists</StepText>
----                                                          <StepExpectedResult>A popup appears with contact details of the employees as recorded on PeoplePlanner
----                                                          </StepExpectedResult><StepStatusId xsi:nil="true" />
----                                                          </TestCaseStepMiniModel>
----                                                          </ArrayOfTestCaseStepMiniModel>'
-----------------------------------------------------------------------------------

--CREATE PROCEDURE [dbo].[USP_UploadTestRailData]
--(
--    @Suite NVARCHAR(250) = NULL,
--    @ProjectName NVARCHAR(250) = NULL,
--    @Section NVARCHAR(250) = NULL,
--    @SectionHierarchy NVARCHAR(MAX) = NULL,
--    @Title NVARCHAR(500) = NULL,
--    @Template NVARCHAR(250) = NULL,
--    @AutomationType NVARCHAR(250) = NULL,
--    @Priority NVARCHAR(250) = NULL,
--    @Type NVARCHAR(250) = NULL,
--    @Estimate NVARCHAR(100) = NULL,
--    @References NVARCHAR(250) = NULL,
--    @Steps NVARCHAR(MAX) = NULL,
--    @ExpectedResult NVARCHAR(250) = NULL,
--    @Forecast NVARCHAR(50) = NULL,
--    @Mission NVARCHAR(250) = NULL,
--    @Goals NVARCHAR(250) = NULL,
--    @Preconditions NVARCHAR(250) = NULL,
--    @CreatedDateTime NVARCHAR(100) = NULL,
--    @UpdatedDateTime NVARCHAR(100) = NULL,
--	@TestCaseStepsXml XML = NULL,
--    @OperationsPerformedBy UNIQUEIDENTIFIER 
--)
--AS
--BEGIN
    
--    SET NOCOUNT ON
--    BEGIN TRY
--    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
--		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
--			IF (@HavePermission = '1')
--			BEGIN

--			   SET @Suite = RTRIM(LTRIM(@Suite))

--			   IF(@Suite  = '')SET @Suite = NULL 

--			   SET @projectname = RTRIM(LTRIM(@projectname))

--			   SET @Template = RTRIM(LTRIM(@Template))

--			   IF(@Template = '') SET @Template = NULL
			   
--			   SET @Type = RTRIM(LTRIM(@Type))

--			   IF(@Type = '') SET @Type = NULL

--			   SET @Priority = RTRIM(LTRIM(@Priority))

--			   IF(@Priority = '') SET @Priority = NULL

--			   SET @AutomationType = RTRIM(LTRIM(@AutomationType))

--			   IF(@AutomationType = '') SET @AutomationType = NULL

--			   SET @CreatedDateTime = CONVERT(DATETIME,@CreatedDateTime,121)

--			   DECLARE @Currentdate DATETIME = GETDATE()

--			   SET @CreatedDateTime = ISNULL(@CreatedDateTime,@Currentdate)

--			   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
--			   DECLARE @TestCaseStepTypeTemplateId UNIQUEIDENTIFIER = (SELECT Id  FROM TestCaseTemplate WHERE IsDefault = 1 AND CompanyId = @CompanyId AND AsAtInactiveDateTime IS NULL AND InActiveDateTime IS NULL)

--			   DECLARE @projectId UNIQUEIDENTIFIER = (SELECT Id FROM [Project] WHERE ProjectName = @projectname AND AsAtInactiveDateTime IS NULL AND InActiveDateTime IS NULL)

--			   DECLARE @SuiteId UNIQUEIDENTIFIER = (SELECT Id FROM [TestSuite] WHERE TestSuiteName = @Suite AND ProjectId = @ProjectId  AND InActiveDateTime IS NULL)

--			   DECLARE @SectionId UNIQUEIDENTIFIER 
			   			  
--			   DECLARE @TemplateId UNIQUEIDENTIFIER = CASE WHEN @Template IS NULL THEN (SELECT Id FROM TestCaseTemplate WHERE IsDefault = 1) ELSE (SELECT Id FROM [TestCaseTemplate] WHERE TemplateType = @Template AND CompanyId = @CompanyId AND AsAtInactiveDateTime IS NULL AND InActiveDateTime IS NULL) END

--			   DECLARE @TypeId UNIQUEIDENTIFIER = CASE WHEN @Type IS NULL THEN (SELECT Id FROM TestCaseType WHERE IsDefault = 1) ELSE (SELECT Id FROM [TestCaseType] WHERE TypeName = @Type AND CompanyId = @CompanyId AND AsAtInactiveDateTime IS NULL AND InActiveDateTime IS NULL) END

--			   DECLARE @PriorityId UNIQUEIDENTIFIER = CASE WHEN @Priority IS NULL THEN (SELECT Id FROM TestCasePriority WHERE IsDefault = 1) ELSE (SELECT Id FROM [TestCasePriority] WHERE PriorityType = @Priority AND CompanyId = @CompanyId AND AsAtInactiveDateTime IS NULL AND InActiveDateTime IS NULL) END

--			   DECLARE @AutomationTypeId UNIQUEIDENTIFIER = CASE WHEN @AutomationType IS NULL THEN (SELECT Id FROM TestCaseAutomationType WHERE IsDefault = 1) ELSE (SELECT Id FROM [TestCaseAutomationType] WHERE AutomationType = @AutomationType AND CompanyId = @CompanyId AND AsAtInactiveDateTime IS NULL AND InActiveDateTime IS NULL) END

--			   DECLARE @TestCaseId UNIQUEIDENTIFIER

--			   IF (@projectId IS NULL)
--			   BEGIN
			       
--			       SET @projectId = NEWID()

--			       INSERT INTO [dbo].[Project](
--			                   [Id],
--			                   [CompanyId],
--			                   [ProjectName],
--							   [ProjectResponsiblePersonId],
--			                   [CreatedByUserId],
--			                   [CreatedDateTime],
--							   Id,
--							   VersionNumber)
--			            SELECT @projectId,
--			                   @CompanyId,
--			                   @projectname,
--							   @OperationsPerformedBy,
--			                   @OperationsPerformedBy,
--			                   @Currentdate,
--							   @projectId,
--							   1
			                   
--							   DECLARE @UserProjectId UNIQUEIDENTIFIER =  NEWID()
							        
--								      INSERT INTO [dbo].[UserProject](
--                                             [Id],
--                                             [ProjectId],
--                                             [EntityRoleId],
--                                             [UserId],
--                                             [CreatedDateTime],
--                                             [CreatedByUserId]
--                                             )
--                                      SELECT @UserProjectId,
--                                             @ProjectId,
--                                             (SELECT Id FROM [dbo].[EntityRole] WHERE EntityRoleName = 'Project manager'),
--                                             @OperationsPerformedBy,
--                                             @Currentdate,
--                                             @OperationsPerformedBy,
--                                             1,
--                                             @UserProjectId
--			   END
			   
--			   IF (@SuiteId IS NULL)
--			   BEGIN
			       
--			       SET @SuiteId = NEWID()

--			       INSERT INTO [dbo].[TestSuite](
--			                   [Id],
--			                   [ProjectId],
--			                   [TestSuiteName],
--			                   [CreatedByUserId],
--			                   [CreatedDateTime]
--							   )
--			            SELECT @SuiteId,
--			                   @projectId,
--			                   @Suite,
--			                   @OperationsPerformedBy,
--			                   @Currentdate
--							   WHERE @Suite IS NOT NULL
			                   
--			   END
			   
--			   IF (@SectionHierarchy IS NOT NULL)
--			   BEGIN
			         
--			         DECLARE @Temp TABLE  -- Table for storing sctions and id's
--			        (
--			           Id INT,
--			           TestSectionName NVARCHAR(250),
--			           TestSectionId UNIQUEIDENTIFIER,
--			           ParentSectionId UNIQUEIDENTIFIER
--			        )
--			         DECLARE @separator NCHAR(1)
    
--			         SET @separator='>'
			         
--			         DECLARE @Position INT = 1,@Count INT = 1
			         
--			         SET @SectionHierarchy = @SectionHierarchy + @separator
			         
--			         WHILE CHARINDEX(@separator,@SectionHierarchy,@Position) <> 0 -- Seperating SectionHierarchy into sections
--			         BEGIN
			         
--			             INSERT INTO @Temp(Id,TestSectionName) 
--			             SELECT @Count,RTRIM(LTRIM(SUBSTRING(@SectionHierarchy, @Position, CHARINDEX(@separator,@SectionHierarchy,@Position) - @Position)))
			         
--			             SELECT @Position = CHARINDEX(@separator,@SectionHierarchy,@Position) + 1,@Count = @Count +1
			         
--			          END
--					  SET @Count = 1
					 
--					  --WHILE(@Count <= (SELECT MAX(Id) FROM @Temp))
--					  --BEGIN
			         
					  
--			    --      SET @Count = @Count+1
					
--					  --END

--			         WHILE @Count <= (SELECT MAX(Id) FROM @Temp) -- Inserting Sections into [TestSuiteSection] if section is not exist
--			         BEGIN
			               
						    
--			               UPDATE @Temp SET TestSectionId = TS.OriginalId FROM [dbo].[TestSuiteSection] TS LEFT JOIN @Temp T ON T.TestSectionName = TS.SectionName AND TestSuiteId = @SuiteId AND AsAtInactiveDateTime IS NULL AND InActiveDateTime IS NULL WHERE T.Id = @Count AND ((T.ParentSectionId IS NULL AND TS.ParentSectionId IS NULL)  OR TS.ParentSectionId = T.ParentSectionId ) 
			         
--			               SET @SectionId = (SELECT TestSectionId FROM @Temp WHERE Id = @Count) 
			               
--						   IF(@SectionId IS NULL)
--			               BEGIN
			                
--			                   SET @SectionId = NEWID()
			                   
--			                   INSERT INTO [dbo].[TestSuiteSection](
--			                               [Id],
--			                               [TestSuiteId],
--			                               [SectionName],
--			                               [CreatedByUserId],
--			                               [CreatedDateTime],
--			                               [ParentSectionId]
--										   )
--			                        SELECT @SectionId,
--			                               @SuiteId,
--			                               TestSectionName,
--			                               @OperationsPerformedBy,
--			                               @Currentdate,
--			                               ParentSectionId
--			                          FROM @Temp WHERE Id = @Count AND @SuiteId IS NOT NULL
			                   
--			                   UPDATE @Temp SET TestSectionId = @SectionId WHERE Id = @Count
			         
--			               END

--			               UPDATE @Temp SET ParentSectionId = (SELECT TestSectionId FROM @Temp WHERE Id = @Count ) WHERE Id = @Count+1
			              
--						   SET @Count = @Count + 1
			         
--			          END
			         
--			         UPDATE [TestSuiteSection] SET ParentSectionId = T.ParentSectionId FROM @Temp T INNER JOIN [TestSuiteSection] TS ON TS.OriginalId = T.TestSectionId WHERE T.Id = @Count
			       
--			        --SET @SectionId = (SELECT OriginalId FROM [TestSuiteSection] WHERE SectionName = RTRIM(LTRIM(@Section)) AND TestSuiteId = @SuiteId AND (@Count = 1 OR (SELECT TestSectionId FROM @Temp WHERE Id = @Count-1) IS NULL OR  ParentSectionId = (SELECT TestSectionId FROM @Temp WHERE Id = @Count-1)))
			                   
--			   END

--			   IF (@TemplateId IS NULL)
--			   BEGIN
			       
--			       SET @TemplateId = NEWID()

--			       INSERT INTO [dbo].[TestCaseTemplate](
--			                   [Id],
--			                   [TemplateType],
--			                   [CreatedByUserId],
--			                   [CreatedDateTime],
--			                   [CompanyId],
--							   OriginalId,
--							   VersionNumber)
--			            SELECT @TemplateId,
--			                   @Template,
--			                   @OperationsPerformedBy,
--			                   @Currentdate,
--			                   @CompanyId,
--							   @TemplateId,
--							   1
			                   
--			   END
--			   IF (@TypeId IS NULL)
--			   BEGIN
			       
--			       SET @TypeId = NEWID()

--			       INSERT INTO [dbo].[TestCaseType](
--			                   [Id],
--			                   [TypeName],
--			                   [CreatedByUserId],
--			                   [CreatedDateTime],
--			                   [CompanyId],
--							   OriginalId,
--							   VersionNumber)
--			            SELECT @TypeId,
--			                   @Type,
--			                   @OperationsPerformedBy,
--			                   @Currentdate,
--			                   @CompanyId,
--							   @TypeId,
--							   1
			                   
--			   END
--			   IF (@PriorityId IS NULL)
--			   BEGIN
			       
--			       SET @PriorityId = NEWID()

--			       INSERT INTO [dbo].[TestCasePriority](
--			                   [Id],
--			                   [PriorityType],
--			                   [CreatedByUserId],
--			                   [CreatedDateTime],
--			                   [CompanyId],
--							   OriginalId,
--							   VersionNumber)
--			            SELECT @PriorityId,
--			                   @Priority,
--			                   @OperationsPerformedBy,
--			                   @Currentdate,
--			                   @CompanyId,
--							   @PriorityId,
--							   1
			                   
--			   END
--			   IF (@AutomationTypeId IS NULL)
--			   BEGIN
			       
--			       SET @AutomationTypeId = NEWID()

--			       INSERT INTO [dbo].[TestCaseAutomationType](
--			                   [Id],
--			                   [AutomationType],
--			                   [CreatedByUserId],
--			                   [CreatedDateTime],
--			                   [CompanyId],
--							   OriginalId,
--							   VersionNumber)
--			            SELECT @AutomationTypeId,
--			                   @AutomationType,
--			                   @OperationsPerformedBy,
--			                   @Currentdate,
--			                   @CompanyId,
--							   @AutomationTypeId,
--							   1
			                   
--			   END

--			   SET @TestCaseId = (SELECT Id FROM [TestCase] WHERE [Title] = RTRIM(LTRIM(@Title)) AND TestSuiteId = @SuiteId AND SectionId = @SectionId  AND InActiveDateTime IS NULL)
			

--			   IF(@TestCaseId IS NULL)
--			   BEGIN

--					SET @TestCaseId = NEWID()
		
--					INSERT INTO [dbo].[TestCase](
--					            [Id],
--					            [Title],
--					            [SectionId],
--					            [TemplateId],
--					            [TypeId],
--					            [Estimate],
--					            [References],
--					            [Steps],
--					            [ExpectedResult],
--					            [CreatedByUserId],
--					            [CreatedDateTime],
--					            [Mission],
--					            [Goals],
--					            [PriorityId],
--					            [AutomationTypeId],
--					            [TestSuiteId],
--					            [PreCondition],
--								[TestCaseId]
--								)
--					     SELECT @TestCaseId,
--					            rtrim(LTRIM(@Title)),
--					            @SectionId,
--					            @TemplateId,
--					            @TypeId,
--					            @Estimate,
--					            @References,
--					            @Steps,
--					            @ExpectedResult,
--					            @OperationsPerformedBy,
--								@Currentdate,
--					            @Mission,
--					            @Goals,
--					            @PriorityId,
--					            @AutomationTypeId,
--					            @SuiteId,
--					            @Preconditions,
--					            ('C' + CAST(ISNULL((SELECT MAX(CAST((SUBSTRING(TC.TestCaseId,2,LEN(TC.TestCaseId))) AS INT)) 
--                                                            FROM TestCase TC 
--                                                                 INNER JOIN TestSuite TS ON TS.Id = TC.TestSuiteId  
--                                                                 INNER JOIN Project P ON P.OriginalId = TS.ProjectId
--                                                            WHERE P.CompanyId = @CompanyId
--                                                            GROUP BY P.CompanyId
--                                                            ),0) + 1
--                                                 AS NVARCHAR(100)))
--									WHERE @SectionId IS NOT NULL AND @SuiteId IS NOT NULL

--					IF(@TemplateId = @TestCaseStepTypeTemplateId)
--					BEGIN

						
--						INSERT INTO TestCaseStep(
--						            [Id],
--									[TestCaseId],
--									Step,
--									StepOrder,
--									ExpectedResult,
--									CreatedDateTime,
--									CreatedByUserId
--									)
--						    SELECT  NEWID(),
--						    		@TestCaseId, 
--						    		RTRIM(LTRIM([Table].[Column].value('StepText[1]', 'varchar(MAX)'))),
--									RTRIM(LTRIM([Table].[Column].value('StepOrder[1]', 'varchar(100)'))),
--						    		[Table].[Column].value('StepExpectedResult[1]', 'Nvarchar(500)'),
--						    	    GETDATE(), 
--									@OperationsPerformedBy
--					           FROM @TestCaseStepsXml.nodes('/ArrayOfTestCaseStepMiniModel/TestCaseStepMiniModel') AS [Table]([Column])
						
--						UPDATE TestCaseStep SET Id = Id FROM TestCaseStep WHERE TestCaseId = @TestCaseId

--					END

--				END
--				ELSE
--				BEGIN

				

--					IF(@TemplateId = @TestCaseStepTypeTemplateId)
--					BEGIN

--						INSERT INTO TestCaseStep(
--						            [Id],
--									[TestCaseId],
--									Step,
--									StepOrder,
--									ExpectedResult,
--									CreatedDateTime,
--									CreatedByUserId
--									)
--						    SELECT  NEWID(),
--						    		@TestCaseId, 
--						    		RTRIM(LTRIM([Table].[Column].value('StepText[1]', 'Nvarchar(500)'))),
--									RTRIM(LTRIM([Table].[Column].value('StepOrder[1]', 'varchar(100)'))),
--						    		[Table].[Column].value('StepExpectedResult[1]', 'Nvarchar(500)'),
--						    		@Currentdate, 
--									@OperationsPerformedBy
--					           FROM @TestCaseStepsXml.nodes('/ArrayOfTestCaseStepMiniModel/TestCaseStepMiniModel') AS [Table]([Column])
						
--							UPDATE TestCaseStep SET Id = Id FROM TestCaseStep WHERE TestCaseId = @TestCaseId

--					END

--				END

--			   SELECT Id FROM [dbo].[TestCase] WHERE Id = @TestCaseId

--			END
--			ELSE
--            RAISERROR (@HavePermission,11, 1)

--    END TRY
--    BEGIN CATCH
        
--        THROW

--    END CATCH
    
--END
--GO