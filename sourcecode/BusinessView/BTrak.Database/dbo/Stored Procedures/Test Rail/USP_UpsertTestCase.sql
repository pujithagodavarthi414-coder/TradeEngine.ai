-------------------------------------------------------------------------------
-- Author       Harika Pabbisetty
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or update the TestCase
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified      Geetha Ch
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Save or update the TestCase
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTestCase]
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--,@Title ='Sprint12'
--,@SectionId = '5C3B1F5F-FC57-468C-9F26-E4A2D70B32C9'
--,@TestSuiteId='49CC0E9C-BFA4-45AB-B1B2-5C3616707BEE'
   --,@TestCaseStepsXml=N'<?xml version="1.0" encoding="utf-16"?>
   --<ArrayOfTestCaseStepMiniModel xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
   --<TestCaseStepMiniModel>
   --    <StepText>Step1</StepText>
   --    <StepExpectedResult>Step Result 1</StepExpectedResult>
   --    <StepStatusId>451b7f11-818c-421e-a770-57cbcabe6273</StepStatusId>
   --</TestCaseStepMiniModel>
   --<TestCaseStepMiniModel>
   --    <StepText>Step2</StepText>
   --    <StepExpectedResult>Step Result 2</StepExpectedResult>
   --    <StepStatusId>63d3d282-76db-4e95-96d6-0c368681e3db</StepStatusId>
   --</TestCaseStepMiniModel>
   --</ArrayOfTestCaseStepMiniModel>'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTestCase]
(
    @TestCaseId UNIQUEIDENTIFIER = NULL,
    @Title  NVARCHAR (500)  = NULL,
    @SectionId UNIQUEIDENTIFIER = NULL,
    @TemplateId UNIQUEIDENTIFIER = NULL,
    @TypeId UNIQUEIDENTIFIER = NULL,
    @Estimate  INT  = NULL,
    @References NVARCHAR (MAX)  = NULL,
    @Steps  NVARCHAR (MAX) = NULL,
    @ExpectedResult  NVARCHAR (MAX)  = NULL,
    @IsArchived BIT = NULL,
    @Mission NVARCHAR (Max) = NULL,
    @Goals  NVARCHAR (Max) = NULL,
    @PriorityId UNIQUEIDENTIFIER = NULL,
    @AutomationTypeId UNIQUEIDENTIFIER = NULL,
    @StatusId  UNIQUEIDENTIFIER = NULL,
    @StatusComment NVARCHAR (max)  = NULL,
    @AssignToId UNIQUEIDENTIFIER = NULL,
    @TestSuiteId  UNIQUEIDENTIFIER = NULL,
    @UserStoryId  UNIQUEIDENTIFIER = NULL,
    @PreConditions NVARCHAR (max)  = NULL,
    @Version NVARCHAR (100)  =  NULL,
    @Elapsed DATETIME = NULL,
    @AssignToComment NVARCHAR(max) = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @TestCaseStepsXml XML = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
       
        IF(@TestSuiteId = '00000000-0000-0000-0000-000000000000') SET @TestSuiteId = NULL

      DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM TestSuite WHERE Id = @TestSuiteId AND InActiveDateTime IS NULL)
      
      DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
       IF(@HavePermission = '1')
       BEGIN
       
        
        IF(@SectionId = '00000000-0000-0000-0000-000000000000') SET @SectionId = NULL
        
        IF(@Title = '') SET @Title = NULL
        
        IF(@TestSuiteId IS NULL)
        BEGIN
            
            RAISERROR(50011,16, 2, 'TestSuite')
       
       END
        ELSE IF(@SectionId IS NULL)
        BEGIN
            
            RAISERROR(50011,16, 2, 'TestSuiteSection')
       
       END
        ELSE IF(@Title IS NULL)
        BEGIN
            
            RAISERROR(50011,16, 2, 'Title')
       
       END
        ELSE
        BEGIN
            DECLARE @TestCaseIdCount INT = (SELECT COUNT(1) FROM TestCase WHERE Id = @TestCaseId )
              
           -- DECLARE @TitlesCount INT = (SELECT COUNT(1) FROM [dbo].[TestCase] WHERE [Title] = @Title AND TestSuiteId = @TestSuiteId AND SectionId = @SectionId AND (Id <> @TestCaseId OR @TestCaseId IS NULL) AND InactiveDateTime IS NULL)
            
            IF(@TestCaseIdCount = 0 AND @TestCaseId IS NOT NULL)
            BEGIN
               
			   RAISERROR(50002,16, 1,'TestCase')
            
			END
            ELSE
            BEGIN

			  DECLARE @TestCaseUniqueId NVARCHAR(250)
            
                    DECLARE @IsLatest BIT = (CASE WHEN @TestCaseId IS NULL 
                                                  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                         FROM [TestCase] WHERE Id = @TestCaseId) = @TimeStamp
                                                                   THEN 1 ELSE 0 END END)
        
                    IF(@IsLatest = 1)
                    BEGIN
                        
                        DECLARE @Currentdate DATETIME = GETDATE()

						DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

                        SELECT @TestCaseUniqueId = TestCaseId FROM [TestCase] WHERE Id = @TestCaseId 
    
                        DECLARE @IsNew BIT
                        
                        IF(@TestCaseId IS NULL)
						BEGIN

						SET @TestCaseId = NEWID()

                        SET @IsNew = 0

                        INSERT INTO [dbo].[TestCase](
                                    [Id],
                                    [TestSuiteId],
                                    Title,
                                    SectionId,
                                    TemplateId,
                                    TypeId,
                                    PriorityId,
                                    Estimate,
                                    [References],
                                    AutomationTypeId,
                                    PreCondition,
                                    Steps,
                                    Mission,
                                    Goals,
                                    ExpectedResult,
                                    InActiveDateTime,
                                    TestCaseId,
                                    CreatedDateTime,
                                    CreatedByUserId
                                    )
                             SELECT @TestCaseId,
                                    @TestSuiteId,
                                    @Title,
                                    @SectionId,
                                    IIF(@TemplateId IS NULL, (SELECT Id  FROM TestCaseTemplate WHERE IsDefault = 1 AND CompanyId = @CompanyId  AND InactiveDateTime IS NULL),     @TemplateId),
                                    IIF(@TypeId IS NULL, (SELECT Id  FROM TestCaseType WHERE IsDefault = 1 AND CompanyId = @CompanyId   AND InactiveDateTime IS NULL), @TypeId),
                                    IIF(@PriorityId IS NULL, (SELECT Id FROM TestCasePriority WHERE IsDefault = 1 AND CompanyId = @CompanyId   AND InactiveDateTime IS NULL),  @PriorityId),
                                    @Estimate,
                                    @References,
                                    IIF(@AutomationTypeId IS NULL, (SELECT Id FROM TestCaseAutomationType WHERE IsDefault = 1 AND CompanyId = @CompanyId  AND InactiveDateTime IS NULL),  @AutomationTypeId),
                                    @PreConditions,
                                    @Steps,
                                    @Mission,
                                    @Goals,
                                    @ExpectedResult,
                                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                    ISNULL(@TestCaseUniqueId,
                                           ('C' + CAST(ISNULL((SELECT MAX(CAST((SUBSTRING(TC.TestCaseId,2,LEN(TC.TestCaseId))) AS INT)) 
                                                               FROM TestCase TC 
                                                                    INNER JOIN TestSuite TS ON TS.Id = TC.TestSuiteId  
                                                                    INNER JOIN Project P ON P.Id = TS.ProjectId
                                                               WHERE P.CompanyId = @CompanyId
                                                               GROUP BY P.CompanyId
                                                               ),0) + 1
                                                    AS NVARCHAR(100)))),
                                     @Currentdate,
                                     @OperationsPerformedBy
                                
								END
								ELSE
								BEGIN

                                SET @IsNew = 1

                                DECLARE @OldTitle  NVARCHAR (500)  = NULL
								DECLARE @OldMission NVARCHAR(MAX) = NULL
								DECLARE @OldGoals NVARCHAR(MAX) = NULL
                                DECLARE @OldSectionId UNIQUEIDENTIFIER = NULL
                                DECLARE @OldTemplateId UNIQUEIDENTIFIER = NULL
                                DECLARE @OldTypeId UNIQUEIDENTIFIER = NULL
                                DECLARE @OldEstimate  INT  = NULL
                                DECLARE @OldPreConditions NVARCHAR (max)  = NULL
                                DECLARE @OldAutomationTypeId UNIQUEIDENTIFIER = NULL
                                DECLARE @OldPriorityId UNIQUEIDENTIFIER = NULL
                                DECLARE @OldReferences NVARCHAR (MAX)  = NULL
                                DECLARE @OldExpectedResult NVARCHAR (MAX)  = NULL
                                DECLARE @OldSteps NVARCHAR (MAX)  = NULL
                                DECLARE @Inactive DATETIME = NULL
                                DECLARE @OldValue NVARCHAR(MAX) = NULL
                                DECLARE @NewValue NVARCHAR(MAX) = NULL

                                SELECT @OldTitle             = Title,	
                                       @OldSectionId         = SectionId,	
                                       @OldTemplateId        = TemplateId,		
                                       @OldTypeId            = TypeId,
                                       @OldEstimate          = Estimate,
                                       @OldPreConditions     = ISNULL(PreCondition,'none'),
                                       @OldAutomationTypeId  = AutomationTypeId,
                                       @OldPriorityId        = PriorityId,
                                       @OldReferences        = ISNULL([References],'none'),
									   @Inactive             = InActiveDateTime,
									   @OldMission           = Mission,
									   @OldSteps             = Steps,
									   @OldExpectedResult    = ExpectedResult,
									   @OldGoals             = Goals
                                       FROM TestCase WHERE Id = @TestCaseId

									   IF(@OldMission IS NULL AND @Mission IS NOT NULL)SET @OldMission = 'none'
									   IF(@OldGoals IS NULL AND @Goals IS NOT NULL)SET @OldGoals = 'none'
									   IF(@OldSteps IS NULL AND @Steps IS NOT NULL)SET @OldSteps = 'none'
                                
                                SET @OldValue = ISNULL((SELECT SectionName  FROM TestSuiteSection WHERE Id = @OldSectionId),'none')
					            SET @NewValue = (SELECT SectionName  FROM TestSuiteSection WHERE Id = @SectionId)

                                IF(ISNULL(@OldSectionId,'') <> @SectionId AND @SectionId IS NOT NULL)
                                EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy
                                ,@FieldName= 'test case section',@NewValue = @NewValue,@OldValue = @OldValue,@Description = 'TestCaseSectionChanged'

                                SET @OldValue = ISNULL((SELECT TemplateType  FROM TestCaseTemplate WHERE Id = @OldTemplateId),'none')
					            SET @NewValue = (SELECT TemplateType  FROM TestCaseTemplate WHERE Id = @TemplateId)

                                IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
                                EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy
                                ,@FieldName= 'test case template',@NewValue = @NewValue,@OldValue = @OldValue,@Description = 'TestCaseTemplateChanged'

                                SET @OldValue = ISNULL((SELECT TypeName  FROM TestCaseType WHERE Id = @OldTypeId),'none')
					            SET @NewValue = (SELECT TypeName  FROM TestCaseType WHERE Id = @TypeId)

                                IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
                                EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy
                                ,@FieldName= 'test case type',@NewValue = @NewValue,@OldValue = @OldValue,@Description = 'TestCaseTypeChanged'

                                SET @OldValue = ISNULL((SELECT AutomationType  FROM TestCaseAutomationType WHERE Id = @OldAutomationTypeId),'none')
					            SET @NewValue = (SELECT AutomationType  FROM TestCaseAutomationType WHERE Id = @AutomationTypeId)

                                IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
                                EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy
                                ,@FieldName= 'automation type',@NewValue = @NewValue,@OldValue = @OldValue,@Description = 'TestCaseAutomationTypeChanged'

                                SET @OldValue = ISNULL((SELECT PriorityType  FROM TestCasePriority WHERE Id = @OldPriorityId),'none')
					            SET @NewValue = (SELECT PriorityType  FROM TestCasePriority WHERE Id = @PriorityId)

                                IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
                                EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy
                                ,@FieldName= 'test case priority',@NewValue = @NewValue,@OldValue = @OldValue,@Description = 'TestCasePriorityChanged'

                                IF(ISNULL(@OldPreConditions,'') <> @PreConditions AND @PreConditions IS NOT NULL)
                                EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy
                                ,@FieldName= 'preconditions',@NewValue = @PreConditions,@OldValue = @OldPreConditions,@Description = 'TestCasePreconditionsChanged'

                                IF(ISNULL(@OldTitle,'') <> @Title AND @Title IS NOT NULL)
                                EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy
                                ,@FieldName= 'title',@NewValue = @Title,@OldValue = @OldTitle,@Description = 'TestCaseTitleChanged'

								IF(ISNULL(@OldMission,'') <> @Mission AND @Mission IS NOT NULL)
                                EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy
                                ,@FieldName= 'mission',@NewValue = @Mission,@OldValue = @OldMission,@Description = 'TestCaseMissionChanged'

								IF(ISNULL(@OldGoals,'') <> @Goals AND @Goals IS NOT NULL)
                                EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy
                                ,@FieldName= 'goals',@NewValue = @Goals,@OldValue = @OldGoals,@Description = 'TestCaseGoalsChanged'

                                IF(ISNULL(@OldReferences,'') <> @References AND @References IS NOT NULL)
                                EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy
                                ,@FieldName= 'references',@NewValue = @References,@OldValue = @OldReferences,@Description = 'TestCaseReferencesChanged'

								IF(ISNULL(@OldSteps,'') <> @Steps AND @Steps IS NOT NULL)
                                EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy
                                ,@FieldName= 'StepDescription',@NewValue = @Steps,@OldValue = @OldSteps,@Description = 'StepDescriptionChanged'

								
								IF(ISNULL(@OldExpectedResult,'') <> @ExpectedResult AND @ExpectedResult IS NOT NULL)
                                EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy
                                ,@FieldName= 'ExpectedResult',@NewValue = @ExpectedResult,@OldValue = @OldExpectedResult,@Description = 'ExpectedResultChanged'

                                SET @OldValue = (SELECT IIF(@OldEstimate / 144000 > 0,CONVERT(NVARCHAR(20),@OldEstimate / 144000) + 'w' ,'')
                                                             + IIF((@OldEstimate % 144000) / 28800  > 0,CONVERT(NVARCHAR(20),(@OldEstimate % 144000) / 28800 ) + 'd' ,'')
                                                             + IIF(((@OldEstimate % 144000) % 28800) / 3600  > 0,CONVERT(NVARCHAR(20),((@OldEstimate % 144000) % 28800) / 3600 ) + 'h' ,'')
                                                             + IIF((((@OldEstimate % 144000) % 28800) % 3600) / 60  > 0,CONVERT(NVARCHAR(20),(((@OldEstimate % 144000) % 28800) % 3600) / 60 ) + 'm' ,'')
                                                             + IIF((((@OldEstimate % 144000) % 28800) % 3600) % 60  > 0,CONVERT(NVARCHAR(20),(((@OldEstimate % 144000) % 28800) % 3600) % 60 ) + 's' ,''))

                                SET @OldValue = IIF(@OldValue = '','none',@OldValue)
								
								SET @NewValue = (SELECT IIF(@Estimate / 144000 > 0,CONVERT(NVARCHAR(20),@Estimate / 144000) + 'w' ,'')
                                                      + IIF((@Estimate % 144000) / 28800  > 0,CONVERT(NVARCHAR(20),(@Estimate % 144000) / 28800 ) + 'd' ,'')
                                                      + IIF(((@Estimate % 144000) % 28800) / 3600  > 0,CONVERT(NVARCHAR(20),((@Estimate % 144000) % 28800) / 3600 ) + 'h' ,'')
                                                      + IIF((((@Estimate % 144000) % 28800) % 3600) / 60  > 0,CONVERT(NVARCHAR(20),(((@Estimate % 144000) % 28800) % 3600) / 60 ) + 'm' ,'')
                                                      + IIF((((@Estimate % 144000) % 28800) % 3600) % 60  > 0,CONVERT(NVARCHAR(20),(((@Estimate % 144000) % 28800) % 3600) % 60 ) + 's' ,''))

                                SET @NewValue = IIF(@NewValue = '','none',@NewValue)

                                IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
                                EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy
                                ,@FieldName= 'estimate',@NewValue = @NewValue,@OldValue = @OldValue,@Description = 'TestCaseEstimateChanged'

								UPDATE [dbo].[TestCase]
								SET [Id]                    =   @TestCaseId,
                                    [TestSuiteId]			=   @TestSuiteId,
                                    Title					=   @Title,
                                    SectionId				=   @SectionId,
                                    TemplateId				=   @TemplateId,
                                    TypeId				    =   @TypeId,
                                    PriorityId			    =   @PriorityId,
                                    Estimate			    =   @Estimate,
                                    [References]			=   @References,
                                    AutomationTypeId		=   @AutomationTypeId,
                                    PreCondition			=   @PreConditions,
                                    Steps					=   @Steps,
                                    Mission				    =   @Mission,
                                    Goals					=   @Goals,
                                    ExpectedResult			=   @ExpectedResult,
                                    InActiveDateTime		=   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                    TestCaseId				=   @TestCaseUniqueId,
                                    UpdatedDateTime		    =   @CurrentDate  ,     
                                    UpdatedByUserId			=   @OperationsPerformedBy       
									WHERE Id = @TestCaseId						           
								
								END	

                                    DECLARE @ConfigurationId UNIQUEIDENTIfier = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseCreatedOrUpdated' AND CompanyId = @CompanyId)						           
															           
                                    CREATE TABLE #TestCaseDependency        
                                    (						           
                                        Id UNIQUEIDENTIFIER, 
										TestCaseId UNIQUEIDENTIFIER, 
                                        Step NVARCHAR(max),
                                        ExpectedResult NVARCHAR(Max),
                                        StepOrder INT,
                                        StepCreated BIT,
										StepId UNIQUEIDENTIFIER
                                    )
                                    INSERT INTO #TestCaseDependency(Id,TestCaseId,StepId,Step,StepOrder,StepCreated,ExpectedResult)
                                    SELECT NEWID(),@TestCaseId,
									       IIF([Table].[Column].value('StepId[1]', 'varchar(2000)')='',NULL,[Table].[Column].value('StepId[1]', 'varchar(2000)')),
                                            [Table].[Column].value('StepText[1]', 'nvarchar(Max)'),
                                            [Table].[Column].value('StepOrder[1]', 'varchar(100)'),
                                            [Table].[Column].value('StepCreated[1]', 'bit'),
                                            [Table].[Column].value('StepExpectedResult[1]', 'nvarchar(Max)')
                                    FROM @TestCaseStepsXml.nodes('/ArrayOfTestCaseStepMiniModel/TestCaseStepMiniModel') AS [Table]([Column])

                                    IF(@IsNew = 1)
                                    BEGIN
                                    INSERT INTO TestCaseHistory ([Id], [StepId], [TestCaseId], [FieldName], [OldValue], [NewValue], [ConfigurationId]
                                        , [CreatedDateTime], [CreatedByUserId])
                                    SELECT NEWID(), TCS.Id, @TestCaseId, 'StepDeleted', NULL, NULL, @ConfigurationId, GETDATE(), @OperationsPerformedBy
                                        FROM TestCaseStep TCS WHERE TCS.TestCaseId = @TestCaseId AND TCS.Id NOT IN (SELECT StepId FROM #TestCaseDependency)
                                                                             AND InactiveDateTime IS NULL
                                    
                                    INSERT INTO TestCaseHistory ([Id], [StepId], [TestCaseId], [FieldName], [OldValue], [NewValue], [ConfigurationId]
                                        , [CreatedDateTime], [CreatedByUserId])
                                    SELECT NEWID(), TCS.Id, @TestCaseId, 'StepTextUpdated', TCS.Step, T.Step, @ConfigurationId, GETDATE(), @OperationsPerformedBy
                                        FROM TestCaseStep TCS INNER JOIN #TestCaseDependency T ON T.StepId = TCS.Id
                                        WHERE ISNULL(TCS.Step,'') <> ISNULL(T.Step,'') AND T.StepCreated = 0

                                    INSERT INTO TestCaseHistory ([Id], [StepId], [TestCaseId], [FieldName], [OldValue], [NewValue], [ConfigurationId]
                                        , [CreatedDateTime], [CreatedByUserId])
                                    SELECT NEWID(), TCS.Id, @TestCaseId, 'StepExpectedResultUpdated', TCS.ExpectedResult, T.ExpectedResult, @ConfigurationId, GETDATE(), @OperationsPerformedBy
                                        FROM TestCaseStep TCS INNER JOIN #TestCaseDependency T ON T.StepId = TCS.Id
                                        WHERE ISNULL(TCS.ExpectedResult,'') <> ISNULL(T.ExpectedResult,'') AND T.StepCreated = 0
                                    END

                                            UPDATE TestCaseStep 
									         SET UpdatedDateTime   = @Currentdate,
									             UpdatedByUserId   = @OperationsPerformedBy,
									             InActiveDateTime  = @Currentdate
									        WHERE TestCaseId = @TestCaseId AND Id NOT IN (SELECT StepId FROM #TestCaseDependency) AND InactiveDateTime IS NULL
									         
										 UPDATE TestCaseStep 
										 SET TestCaseId      = @TestCaseId,
										     Step            = T.Step,
											 ExpectedResult  = T.ExpectedResult,
											 StepOrder       = T.StepOrder,
											 UpdatedDateTime = @Currentdate,
											 UpdatedByUserId = @OperationsPerformedBy
											FROM #TestCaseDependency T
											WHERE TestCaseStep.Id  = T.StepId
  
								          INSERT INTO TestCaseStep(
                                                        [Id],
                                                        [TestCaseId],
                                                        Step,
                                                        StepOrder,
                                                        ExpectedResult,
                                                        CreatedDateTime,
                                                        CreatedByUserId
                                                        )
                                                 SELECT T.Id ,
                                                        @TestCaseId, 
                                                        T.Step,
                                                        T.StepOrder,
                                                        T.ExpectedResult,
                                                        @Currentdate,
                                                        @OperationsPerformedBy
                                                   FROM #TestCaseDependency T WHERE T.StepId IS  NULL 

                                    IF(@IsNew = 1)
                                    BEGIN

                                    INSERT INTO TestCaseHistory ([Id], [StepId], [TestCaseId], [FieldName], [OldValue], [NewValue], [ConfigurationId]
                                        , [CreatedDateTime], [CreatedByUserId])
                                    SELECT NEWID(), T.Id, @TestCaseId, 'StepCreated', T.Step, T.ExpectedResult, @ConfigurationId, GETDATE(), @OperationsPerformedBy
                                        FROM #TestCaseDependency T WHERE T.StepId IS  NULL

                                    UPDATE TestCaseHistory SET [OldValue] = T.Step,
                                                               [NewValue] = T.ExpectedResult,
                                                               [UpdatedDateTime] = @Currentdate
                                           FROM TestCaseHistory TCH JOIN #TestCaseDependency T ON T.StepId = TCH.StepId
                                           WHERE T.StepCreated = 1

                                    END
                
                                     INSERT INTO [UserStoryScenarioStep]
                                                  (
                                                  Id,
                                                  [UserStoryId],
                                                  [StepId],
                                                  [StatusId],
                                                  CreatedDateTime,
                                                  CreatedByUserId
                                                  )
                                           SELECT NEWID(),
                                                  USS.UserStoryId,
                                                  TD.Id,
                                                  (SELECT Id FROM TestCaseStatus WHERE IsUntested = 1 AND InActiveDateTime IS NULL AND CompanyId = @CompanyId),
                                                  @Currentdate,
                                                  @OperationsPerformedBy
                                            FROM #TestCaseDependency TD INNER JOIN UserStoryScenario USS ON USS.TestCaseId = TD.TestCaseId  AND USS.InactiveDateTime IS NULL
											WHERE TD.StepId IS NULL
                                     
									EXEC [dbo].[USP_InsertTestCaseHistory]@TestCaseId = @TestCaseId, @OperationsPerformedBy=@OperationsPerformedBy,@FieldName= 'TestCaseUpdated',@NewValue = @Title,@ConfigurationId= @ConfigurationId,@Description = 'TestCaseNameChanged'

                                       INSERT  INTO [TestRunSelectedStep]
                                                                 (
                                                                 Id,
                                                                 [StepId],
                                                                 [StatusId],
                                                                 [TestRunId],
                                                                 CreatedDateTime,
                                                                 CreatedByUserId
                                                                 )
                                                       SELECT   NEWID(),
                                                                T.Id,
                                                                (SELECT Id FROM TestCaseStatus WHERE IsUntested = 1 AND InActiveDateTime IS NULL AND CompanyId = @CompanyId ),
                                                                TestRunId,
                                                                @Currentdate,
                                                                @OperationsPerformedBy
                                                           FROM  #TestCaseDependency T INNER JOIN  TestCase TC ON T.TestCaseId = TC.ID AND TC.Id = @TestCaseId
														                               INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id  AND TRSC.InActiveDateTime IS NULL  AND TC.InActiveDateTime IS NULL
                                                          WHERE T.StepId IS NULL

														
                         
                         SELECT Id FROM [dbo].[TestCase] WHERE Id = @TestCaseId
                       
                        END
                        ELSE
                            RAISERROR (50008,11, 1)
                    END
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