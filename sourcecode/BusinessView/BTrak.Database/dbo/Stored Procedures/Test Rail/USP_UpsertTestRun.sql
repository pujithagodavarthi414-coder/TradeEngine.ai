-------------------------------------------------------------------------------
-- Author       Harika Pabbisetty
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or update the TestRun
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified      Geetha Ch
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Save or update the TestRun
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTestRun] 
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--,@ProjectId='A483A084-7232-4101-9579-4662243D184A'
--,@Name='Sprint12'
--,@Description='Pm'
--,@TestSuiteId='D8352F75-1152-4BCB-A896-7DFBD66FA803'
--,@SelectedCasesXml = '<ArrayOfGuid>
--                          <guid>990F04C3-DEE6-4921-B0E6-1044FB5E39C2</guid>
--                          <guid>156BDE91-32C9-4583-AD13-28B6F032D1DF</guid>
--                          <guid>5D356CFB-BDCF-44A3-B27B-2AE116D6E498</guid>
--                          <guid>2AE9C998-29F3-4FC9-B215-470CCB602C8A</guid>
--                          <guid>748B510C-4B84-44A9-9258-496D7876B2D2</guid>
--                     </ArrayOfGuid>'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTestRun]
(
    @TestRunId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @TestSuiteId UNIQUEIDENTIFIER = NULL,
    @Name NVARCHAR(100) = NULL,
    @MilestoneId UNIQUEIDENTIFIER = NULL,
    @AssignToId UNIQUEIDENTIFIER = NULL,
    @Description NVARCHAR(999) = NULL, 
    @IsIncludeAllCases BIT = NULL,
    @SelectedCasesXml XML = NULL,
    @IsArchived BIT = NULL,
    @IsCompleted BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @SelectedSectionsXml XML = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @IsFromUpload    BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
            
        IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL
        
       DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
       
       DECLARE @CasesCount INT  = (SELECT COUNT(1) FROM TestCase TC INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
                                WHERE TSS.TestSuiteId = @TestSuiteId AND TC.InActiveDateTime IS NULL)
       
       DECLARE @SectionCasesCount INT 

	   IF(@IsIncludeAllCases IS NULL)SET  @IsIncludeAllCases = 0
       
       IF(@SelectedCasesXml IS NULL)
       BEGIN      
       
      SET @SectionCasesCount = ISNULL((SELECT COUNT(TC.Id) FROM 
                              (SELECT [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') TestSuiteSectionId FROM @SelectedSectionsXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column]))T INNER JOIN TestCase TC ON TC.SectionId = T.TestSuiteSectionId  AND TC.InActiveDateTime IS NULL),0)
      
       END
       IF(@HavePermission = '1')
       BEGIN
       IF(@Name = '') SET @Name = NULL
       
       IF(@ProjectId IS NULL)
        BEGIN
            
            RAISERROR(50011,16, 2, 'Project')
        
        END
        ELSE IF(@Name IS NULL)
        BEGIN
            
            RAISERROR(50011,16, 2, 'TestRunName')
        
        END
        ELSE IF(@IsIncludeAllCases = 1 AND @CasesCount = 0)
        BEGIN
            
            RAISERROR ('ThereAreNoTestCasesPresentPleaseAddATestCaseInTheTestSuite',11, 1)
        
        END
        ELSE IF(((@IsIncludeAllCases IS NULL OR @IsIncludeAllCases = 0) AND @SelectedCasesXml IS NULL AND @CasesCount = 0) AND (@IsFromUpload IS NULL OR @IsFromUpload = 0) AND (@IsCompleted IS NULL OR @IsCompleted =0))
        BEGIN
        
         RAISERROR ('ThereAreNoTestCasesPresentPleaseAddATestCaseInTheTestSuite',11, 1)
        
        END
        ELSE IF((@IsIncludeAllCases IS NULL OR @IsIncludeAllCases = 0) AND (@SelectedCasesXml IS NULL AND @SectionCasesCount = 0) AND (@IsFromUpload IS NULL OR @IsFromUpload = 0) AND (@IsCompleted IS NULL OR @IsCompleted =0))
        BEGIN
        
         RAISERROR ('PleaseSelectAtLeastOneTestCase',11, 1)
        
        END
        ELSE
        BEGIN
            
            DECLARE @TestRunIdCount INT = (SELECT COUNT(1) FROM TestRun WHERE Id = @TestRunId)
              
            DECLARE @TestRunNamesCount INT = (SELECT COUNT(1) FROM [dbo].[TestRun] WHERE [Name] = @Name AND TestSuiteId = @TestSuiteId AND ProjectId = @ProjectId AND (Id <> @TestRunId OR @TestRunId IS NULL)  AND  InactiveDateTime IS NULL)
            
            IF(@TestRunIdCount = 0 AND @TestRunId IS NOT NULL)
            BEGIN
              
              RAISERROR(50002,16, 1,'TestRun')
           
           END
            ELSE IF(@TestRunNamesCount > 0)
            BEGIN
           
             RAISERROR(50001,16,1,'TestRun')
           
           END 
            ELSE
            BEGIN
                
                    DECLARE @IsLatest BIT = (CASE WHEN @TestRunId IS NULL 
                                                  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                         FROM [TestRun] WHERE Id = @TestRunId ) = @TimeStamp
                                                                   THEN 1 ELSE 0 END END)
                    IF(@IsLatest = 1)
                    BEGIN
                    
			       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))


                         DECLARE @Currentdate DATETIME = GETDATE()
                         
						 DECLARE @FieldName NVARCHAR(250)
                         
						 DECLARE @ConfigurationId UNIQUEIDENTIFIER = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestRunCreatedOrUpdated' AND CompanyId = @CompanyId )

        --                  IF(@TestRunId IS NULL)
        --                  BEGIN
                           
						  -- SET @FieldName = 'TestRunCreated' SET @TestRunId = @TestRunId
                          
						  --END
        --                  ELSE
						  --SET @FieldName = 'TestRunUpdated'
                         
						 IF(@TestRunId IS NULL)
                         BEGIN
                      
					     SET @TestRunId = NEWID()
                                
								INSERT INTO [dbo].[TestRun](
                                             [Id],
                                             [ProjectId],
                                             [TestSuiteId],
                                             [Name],
                                             [MilestoneId],
                                             [AssignToId],
                                             [Description],
                                             [IsIncludeAllCases],
                                             [InActiveDateTime],
                                             [IsCompleted],
                                             [CreatedDateTime],
                                             [CreatedByUserId]
                                             )
                                      SELECT @TestRunId,
                                             @ProjectId,
                                             @TestSuiteId,
                                             @Name,
                                             @MilestoneId,
                                             @AssignToId,
                                             @Description,
                                             @IsIncludeAllCases,
                                             CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                             @IsCompleted,
                                             @Currentdate,
                                             @OperationsPerformedBy

							    SET @FieldName = 'TestRunCreated'

								EXEC [dbo].[USP_InsertTestCaseHistory]@TestRunId = @TestRunId, @OperationsPerformedBy=@OperationsPerformedBy,@FieldName= @FieldName ,@NewValue= @Name,@ConfigurationId=@ConfigurationId,@Description = 'TestRunAdded'                          

                               END
                               ELSE
                               BEGIN
                               
					   DECLARE @OldTestRunName NVARCHAR(50) = (SELECT [Name] FROM TestRun WHERE Id = @TestRunId and InActiveDateTime IS NULL)

						EXEC [dbo].[USP_InsertTestRailAuditHistory] @ConfigurationId = @ConfigurationId, 
																	@TestRunId = @TestRunId,
																	@TestRunProjectId = @ProjectId,
																	@TestRunTestSuiteId = @TestSuiteId,
																	@TestRunName = @Name,
																	@TestRunMilestoneId = @MilestoneId,
																	@TestRunAssignToId = @AssignToId,
																	@TestRunDescription = @Description, 
																	@TestRunIsIncludeAllCases = @IsIncludeAllCases,
																	@TestRunIsArchived = @IsArchived,
																	@TestRunIsCompleted = @IsCompleted,
																	@OperationsPerformedBy = @OperationsPerformedBy

							   UPDATE [dbo].[TestRun]
                                         SET [ProjectId] = @ProjectId,
                                             [TestSuiteId] = @TestSuiteId,
                                             [Name] = @Name,
                                             [MilestoneId] = @MilestoneId,
                                             [AssignToId] = @AssignToId,
                                             [Description] = @Description,
                                             [IsIncludeAllCases] = @IsIncludeAllCases,
                                             [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                             [IsCompleted] = @IsCompleted,
                                             [UpdatedDateTime] = @Currentdate,
                                             [UpdatedByUserId] = @OperationsPerformedBy
                                             WHERE Id = @TestRunId

								 IF(@OldTestRunName <> @Name)
						         BEGIN

						            UPDATE Folder SET FolderName = @Name,
						                   UpdatedDateTime = @Currentdate,
										   UpdatedByUserId = @OperationsPerformedBy
										   WHERE Id = @TestRunId AND InActiveDateTime IS NULL

						        END
                               
							   END
                           
						   

                          
                            
                            IF(@IsCompleted IS NULL OR @IsCompleted = 0) 
                              BEGIN
                                
                                 CREATE TABLE #TestRunDependency
                                (
                                    Id UNIQUEIDENTIFIER,
                                    TestCaseId UNIQUEIDENTIFIER,
                                    IsArchived BIT
                                )
                              CREATE NONCLUSTERED INDEX #TestRunDependency ON #TestRunDependency ([Id],[TestCaseId],[IsArchived]);

							  IF(@IsIncludeAllCases = 0)
							  BEGIN

                               INSERT INTO #TestRunDependency(
                                                            Id,
                                                            TestCaseId
                                                            )
                                                   SELECT TRSC.Id,T.TestCaseId FROM(SELECT [Table].[Column].value('TestCaseId[1]', 'varchar(2000)')TestCaseId
                                                  FROM @SelectedCasesXml.nodes('/ArrayOfSelectedTestCaseModel/SelectedTestCaseModel') AS [Table]([Column]))T 
												  INNER JOIN TestCase TC ON TC.Id = t.TestCaseId AND TC.InActiveDateTime IS NULL
												  LEFT JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = T.TestCaseId AND TRSC.InActiveDateTime IS NULL AND TRSC.TestRunId = @TestRunId

                                 INSERT INTO #TestRunDependency(
                                                              Id,
                                                              TestCaseId
                                                              )
                                                      SELECT TRSC.Id,
                                                              trsc.TestCaseId
                                                     FROM TestRunSelectedCase TRSC INNER JOIN TestCase TC ON TC.Id = TRSC.TestCaseId 
                                                                                                       AND TC.InActiveDateTime IS NULL
                                                      WHERE TC.SectionId IN (SELECT [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') FROM @SelectedSectionsXml.nodes('ArrayOfGuid/guid') AS [Table]([Column])) 
                                                                                AND TRSC.TestCaseId NOT IN (SELECT TestCaseId FROM #TestRunDependency) 
                                                                                AND TRSC.TestRunId = @TestRunId AND TRSC.InActiveDateTime IS NULL 
                                                                                AND (@IsIncludeAllCases IS NULL OR @IsIncludeAllCases = 0)
                    
											INSERT INTO #TestRunDependency(
                                                                          TestCaseId
                                                                          )
												            	SELECT Id FROM  TestCase 
																WHERE SectionId IN (SELECT [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') FROM @SelectedSectionsXml.nodes('ArrayOfGuid/guid') AS [Table]([Column]))
																               AND Id NOT IN (SELECT TestCaseId FROM #TestRunDependency) AND InActiveDateTime IS NULL
                               END
                                              
                            IF(@IsIncludeAllCases = 1)
                            BEGIN
                          
						          INSERT INTO #TestRunDependency(
                                                              Id,
                                                              TestCaseId
                                                              )
                                                      SELECT TRSC.Id,
                                                              trsc.TestCaseId
                                                     FROM TestRunSelectedCase TRSC INNER JOIN TestCase TC ON TC.Id = TRSC.TestCaseId 
                                                                                                       AND TC.InActiveDateTime IS NULL
																	               INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
																				   WHERE TRSC.TestRunId = @TestRunId AND TRSC.InActiveDateTime IS NULL

                               INSERT INTO #TestRunDependency(TestCaseId)
                                SELECT TC.Id
                                FROM TestCase TC INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL AND TC.InActiveDateTime IS NULL
                                WHERE TSS.TestSuiteId = @TestSuiteId AND  TC.Id NOT IN (SELECT TestCaseId FROM #TestRunDependency)   
                              
                              END

							  UPDATE Folder SET InActiveDateTime = @Currentdate,
						                  UpdatedByUserId = @OperationsPerformedBy,
										  UpdatedDateTime = @Currentdate
										  WHERE Id IN (SELECT TRSS.Id FROM TestRunSelectedCase TRSS LEFT JOIN #TestRunDependency T ON TRSS.TestCaseId = T.TestCaseId
                                          WHERE T.TestCaseId IS NULL AND TRSS.TestRunId = @TestRunId 
										           AND TRSS.InActiveDateTime IS NULL)

									UPDATE UploadFile SET InActiveDateTime = @Currentdate,
														  UpdatedByUserId = @OperationsPerformedBy,
														  UpdatedDateTime = @Currentdate
														  WHERE ReferenceId IN (SELECT TRSS.Id FROM TestRunSelectedCase TRSS LEFT JOIN #TestRunDependency T ON TRSS.TestCaseId = T.TestCaseId
														  WHERE T.TestCaseId IS NULL AND TRSS.TestRunId = @TestRunId 
														  AND TRSS.InActiveDateTime IS NULL)

                                   UPDATE TestRunSelectedCase
                                      SET InActiveDateTime = @Currentdate,
                                          UpdatedDateTime  = @Currentdate,
                                          UpdatedByUserId  = @OperationsPerformedBy
										  FROM TestRunSelectedCase TRSS LEFT JOIN #TestRunDependency T ON TRSS.TestCaseId = T.TestCaseId
                                          WHERE T.TestCaseId IS NULL AND TRSS.TestRunId = @TestRunId 
										           AND InActiveDateTime IS NULL  

						  DECLARE @StatusId UNIQUEIDENTIFIER =  (SELECT Id FROM TestCaseStatus WHERE IsUntested = 1 AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)

                                INSERT INTO [dbo].[TestRunSelectedCase](
                                            Id,
                                            TestRunId,
                                            TestCaseId,
                                            StatusId,
                                            CreatedDateTime,
                                            CreatedByUserId
                                            )
                                     SELECT NEWID(),           
                                            @TestRunId,
                                            TestCaseId,
                                            @StatusId,
                                            @Currentdate, 
                                            @OperationsPerformedBy
                                       FROM #TestRunDependency T WHERE T.Id IS NULL


								CREATE TABLE #Steps  
								(
								TestRunSelectedStepId UNIQUEIDENTIFIER,
								StepId UNIQUEIDENTIFIER
								)
								INSERT INTO #Steps(TestRunSelectedStepId,StepId)
								SELECT TRSS.Id,TRSS.StepId FROM TestRunSelectedStep TRSS INNER JOIN TestCaseStep TCS ON TCS.Id = TRSS.StepId AND TCS.InActiveDateTime IS NULL
								                                                         INNER JOIN #TestRunDependency T ON T.TestCaseId = TCS.TestCaseId 
								                             WHERE TRSS.InActiveDateTime IS NULL AND TRSS.TestRunId = @TestRunId                        
								 
								INSERT INTO #Steps(StepId)
								SELECT TCS.Id FROM  TestCaseStep TCS INNER JOIN #TestRunDependency T ON T.TestCaseId = TCS.TestCaseId AND TCS.InActiveDateTime IS NULL
								                                     LEFT JOIN #Steps S ON S.StepId = TCS.Id
								                             WHERE S.StepId IS NULL

								INSERT INTO [TestRunSelectedStep](
                                            Id,
                                            TestRunId,
                                            StepId,
                                            StatusId,
                                            CreatedDateTime,
                                            CreatedByUserId
                                            )
                                     SELECT NEWID(),           
                                            @TestRunId,
                                            S.StepId,
                                            @StatusId,
                                            @Currentdate, 
                                            @OperationsPerformedBy
                                       FROM #Steps S
									   WHERE S.TestRunSelectedStepId IS NULL
									    
								UPDATE UploadFile SET InActiveDateTime = @Currentdate,
													UpdatedDateTime = @Currentdate,
													UpdatedByUserId = @OperationsPerformedBy
													WHERE ReferenceId IN (SELECT Id FROM TestRunSelectedStep WHERE TestRunId = @TestRunId 
													AND InActiveDateTime IS NULL AND StepId NOT IN (SELECT StepId FROM #Steps))

                                UPDATE [TestRunSelectedStep]
								    SET InActiveDateTime = @Currentdate,
									    UpdatedDateTime = @Currentdate,
										UpdatedByUserId = @OperationsPerformedBy
										WHERE StepId NOT IN (SELECT StepId FROM #Steps) AND TestRunId = @TestRunId AND InActiveDateTime IS NULL
                              
							   END
                              SELECT Id FROM [dbo].[TestRun] where Id = @TestRunId
                       
                    END
                    ELSE
                    RAISERROR (50008,11, 1)
                END
          
         END
    END
    ELSE
    BEGIN
                      
         RAISERROR (@HavePermission,10, 1)
                   
    END           
    END TRY
    BEGIN CATCH
        
        THROW
    END CATCH
END
GO