-------------------------------------------------------------------------------
-- Author      Mahesh Musuku
-- Created      '2019-11-28 00:00:00.000'
-- Purpose      To copy or move the testcases 
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertCopyOrMoveCases] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TestSuiteId ='987FB2BC-D536-4126-A65F-3AC82BBF3C86'

CREATE PROCEDURE [dbo].[USP_UpsertCopyOrMoveCases]
(
    @TestCasesXml  XML  = NULL,
    @AppendToSectionId UNIQUEIDENTIFIER = NULL,
    @TestCaseId UNIQUEIDENTIFIER = NULL,
    @IsCopy BIT = NULL,
	@SelectedSectionsXml XML = NULL,
    @IsCasesOnly BIT = NULL,
    @IsCasesWithSections BIT = NULL,
    @IsAllParents BIT = NULL,
    @TestSuiteId  UNIQUEIDENTIFIER = NULL,
    @ParentSectionId  UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
     
       IF(@IsCopy IS NULL)SET @IsCopy = 0
    
       DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM TestSuite WHERE Id = @TestSuiteId  AND InActiveDateTime IS NULL)
      
       DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
       IF(@HavePermission = '1')
       BEGIN
                        
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
            DECLARE @Currentdate DATETIME = GETDATE()

			DECLARE @SectionId UNIQUEIDENTIFIER = NULL
			DECLARE @CasesCount INT
           
             DECLARE @TemplateId       UNIQUEIDENTIFIER  =     (SELECT Id  FROM TestCaseTemplate WHERE IsDefault = 1 AND CompanyId = @CompanyId )
             DECLARE @TestCaseTypeId   UNIQUEIDENTIFIER  =     (SELECT Id  FROM TestCaseType WHERE IsDefault = 1 AND CompanyId = @CompanyId  )
             DECLARE @PriorityId       UNIQUEIDENTIFIER  =     (SELECT Id FROM TestCasePriority WHERE IsDefault = 1 AND CompanyId = @CompanyId )
             DECLARE @AutomationTypeId UNIQUEIDENTIFIER  =     (SELECT Id FROM TestCaseAutomationType WHERE IsDefault = 1 AND CompanyId = @CompanyId )
             DECLARE @StatusId UNIQUEIDENTIFIER = (SELECT Id FROM TestCaseStatus TCS WHERE TCS.IsUntested = 1 and CompanyId = @CompanyId AND InActiveDateTime IS NULL)
                           
                     DECLARE @TestCaseIdentity INT = (SELECT ISNULL((SELECT MAX(CAST((SUBSTRING(TC.TestCaseId,2,LEN(TC.TestCaseId))) AS INT)) 
                                                                     FROM TestCase TC 
                                                                          INNER JOIN TestSuite TS ON TS.Id = TC.TestSuiteId    
                                                                          INNER JOIN Project P ON P.Id = TS.ProjectId 
                                                                     WHERE P.CompanyId = @CompanyId
                                                                     GROUP BY P.CompanyId
                                                                     ),0))
    

					    CREATE TABLE #MoveCases
                        (
                            NewTestCaseId UNIQUEIDENTIFIER,
                            OriginalId UNIQUEIDENTIFIER,
                            TestCaseIdentity INT,
                            TestSuiteId UNIQUEIDENTIFIER,
                            TestSuiteSectionId UNIQUEIDENTIFIER,
                            NewSectionId UNIQUEIDENTIFIER,
							UniuqeId INT
                        )
                        INSERT INTO #MoveCases(NewTestCaseId,OriginalId,TestSuiteId,TestSuiteSectionId,UniuqeId)
                        SELECT NEWID(),Id,@TestSuiteId,T.SectionId,ROW_NUMBER() OVER (ORDER BY  CONVERT(INT,REPLACE(TC.TestCaseId,'C',0)) ASC) FROM TestCase TC INNER JOIN  (SELECT [Table].[Column].value('TestCaseId[1]', 'varchar(100)') TestCaseId,
                                                                                                  [Table].[Column].value('SectionId[1]', 'varchar(100)') SectionId  
                         FROM @TestCasesXml.nodes('/ArrayOfSelectedTestCaseModel/SelectedTestCaseModel') AS [Table]([Column]))T ON TC.Id = T.TestCaseId
                                 
                        CREATE TABLE #MoveSections
                        (
                        SectionId UNIQUEIDENTIFIER,
                        OriginalSectionId UNIQUEIDENTIFIER,
                        SectionName NVARCHAR(500),
                        ParentSectionId UNIQUEIDENTIFIER,
						IsCasesOnly BIT DEFAULT 0,
						SectionLevel INT DEFAULT 0
						
                        )
				
						INSERT INTO #MoveSections(SectionId,OriginalSectionId,ParentSectionId,SectionName)
						SELECT NEWID(),Id,ParentSectionId,SectionName FROM TestSuiteSection WHERE Id IN (SELECT [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') FROM @SelectedSectionsXml.nodes('ArrayOfGuid/guid') AS [Table]([Column])) ORDER BY CreatedDateTime 
    
					    INSERT INTO #MoveCases(NewTestCaseId,OriginalId,TestSuiteId,TestSuiteSectionId,UniuqeId)
					    SELECT NEWID(),TC.Id,@TestSuiteId,TC.SectionId,ROW_NUMBER() OVER (ORDER BY  CONVERT(INT,REPLACE(TC.TestCaseId,'C',0)) ASC) FROM TestCase TC INNER JOIN #MoveSections S ON S.OriginalSectionId =TC.SectionId AND TC.InActiveDateTime IS NULL
					                                                                    LEFT JOIN #MoveCases T ON T.OriginalId = TC.Id
											                                            WHERE T.OriginalId IS NULL

						INSERT INTO #MoveSections(SectionId,OriginalSectionId,SectionName,ParentSectionId,IsCasesOnly)
                        SELECT NEWID(),TSS.Id,TSS.SectionName,TSS.ParentSectionId,1 FROM TestSuiteSection TSS INNER JOIN #MoveCases T ON T.TestSuiteSectionId = TSS.Id and TSS.InActiveDateTime IS NULL
						                                                                            LEFT JOIN #MoveSections S ON S.OriginalSectionId = TSS.Id
																									WHERE S.OriginalSectionId IS NULL 
						GROUP BY TSS.Id,TSS.SectionName,TSS.ParentSectionId,TSS.CreatedDateTime 
						ORDER BY TSS.CreatedDateTime 
                        
	                    INSERT INTO #MoveSections(SectionId,OriginalSectionId,ParentSectionId,SectionName)
					    SELECT NEWID(),TSS.Id,TSS.ParentSectionId,TSS.SectionName FROM TestSuiteSection TSS LEFT JOIN #MoveSections T ON T.OriginalSectionId = TSS.Id AND TSS.InActiveDateTime IS NULL
					                  WHERE TSS.Id IN (SELECT T.SectionId FROM #MoveSections S CROSS APPLY Ufn_GetMultiSectionLevel(S.OriginalSectionId) T) 
									  AND T.OriginalSectionId IS NULL  AND @IsAllParents = 1 

			          DECLARE @CteTestSuiteId UNIQUEIDENTIFIER = (SELECT TestSuiteId FROM TestSuiteSection WHERE Id = (SELECT TOP 1 OriginalSectionId FROM #MoveSections))
	                        
							IF(@IsAllParents = 1 AND @IsCopy = 0)
							BEGIN

							 ;WITH Tree AS
                             (
                                 SELECT TS_Parent.Id, TS_Parent.ParentSectionId,  [level] = 1
                                 FROM TestSuiteSection TS_Parent
                                 WHERE TS_Parent.TestSuiteId = @CteTestSuiteId AND InActiveDateTime IS NULL AND TS_Parent.ParentSectionId IS NULL
                                 UNION ALL
                                 SELECT TS_Child.Id, TS_Child.ParentSectionId, [level] = Tree.[level] + 1
                                 FROM TestSuiteSection TS_Child INNER JOIN Tree ON Tree.Id = TS_Child.ParentSectionId
                                 WHERE TS_Child.InActiveDateTime IS NULL 
                             )
							UPDATE #MoveSections SET SectionLevel = Tree.[level] FROM Tree WHERE Tree.Id = OriginalSectionId 

						  END
                        
					      CREATE  TABLE #MoveFolders
					      (
					      FolderId UNIQUEIDENTIFIER,
					      ParentFolderId UNIQUEIDENTIFIER,
					      NewFolderId UNIQUEIDENTIFIER
					      )
					      INSERT INTO #MoveFolders(FolderId)
					      SELECT F.Id FROM Folder F INNER JOIN #MoveCases T ON F.Id = T.OriginalId AND F.InActiveDateTime IS NULL
					      
					      CREATE  TABLE #MoveSteps
					      (
					      StepId UNIQUEIDENTIFIER,
					      NewStepId UNIQUEIDENTIFIER
					      )
					      INSERT INTO #MoveSteps
					      SELECT TCS.Id,NEWID() FROM #MoveCases T INNER JOIN TestCaseStep TCS ON T.OriginalId = TCS.TestCaseId AND TCS.InActiveDateTime IS NULL
					      
					      CREATE TABLE #MoveFiles
					       (
					       FileId UNIQUEIDENTIFIER,
					       ReferenceId UNIQUEIDENTIFIER,
					       FolderId UNIQUEIDENTIFIER
					       )

							 ;WITH Tree AS
                             (
                                 SELECT TS_Parent.FolderId, TS_Parent.ParentFolderId
                                 FROM #MoveFolders TS_Parent 
                                 UNION ALL
                                 SELECT TS_Child.Id AS FolderId,TS_Child.ParentFolderId  FROM Folder TS_Child INNER JOIN Tree ON Tree.FolderId = TS_Child.ParentFolderId
                                 WHERE TS_Child.InActiveDateTime IS NULL 
                             )
							 INSERT INTO #MoveFolders(FolderId,ParentFolderId,NewFolderId)
							 SELECT Tree.FolderId,Tree.ParentFolderId,NEWID() FROM Tree LEFT JOIN #MoveFolders F ON F.FolderId = Tree.FolderId WHERE F.FolderId IS NULL

						     INSERT INTO #MoveFiles(FileId,ReferenceId,FolderId)
						     SELECT UP.Id,ReferenceId,FolderId FROM UploadFile UP INNER JOIN #MoveCases T ON T.OriginalId = UP.ReferenceId WHERE UP.InActiveDateTime IS NULL
						     
						     INSERT INTO #MoveFiles(FileId,ReferenceId,FolderId)
						     SELECT UP.Id,ReferenceId,FolderId FROM UploadFile UP INNER JOIN #MoveSteps T ON T.StepId = UP.ReferenceId	WHERE UP.InActiveDateTime IS NULL	  
			
					   SET @CasesCount = (SELECT COUNT(1) FROM #MoveCases)
                    
					IF(@CasesCount = 0)
					 BEGIN
        
                         RAISERROR ('PleaseSelectAtLeastOneTestCase',11, 1)
        
                     END
					IF(@AppendToSectionId IS NULL AND @IsCasesOnly = 1) 
					BEGIN

					 DECLARE @SectionCount INT = ISNULL((SELECT COUNT(1) FROM TestSuiteSection WHERE TestSuiteId = @TestSuiteId
                                                    AND ParentSectionId IS NULL AND SectionName LIKE '%Added Section%' AND InActiveDateTime IS NULL), 0)

                     DECLARE @FinalCount INT = @SectionCount + 1

					 DECLARE @MoveSectionName NVARCHAR(100) = 'Added Section ' + CONVERT(NVARCHAR(10), @FinalCount)
                     
                     SET @SectionId = NEWID()
                        
                        INSERT INTO [dbo].[TestSuiteSection](
                                     [Id],
                                     [SectionName],
                                     [TestSuiteId],
                                     [ParentSectionId],
                                     [CreatedDateTime],
                                     [CreatedByUserId]
                                     )
                              SELECT @SectionId,
                                     @MoveSectionName,
                                     @TestSuiteId,
                                     NULL,
                                     @Currentdate,
                                     @OperationsPerformedBy
                     
					 END
				     
					 INSERT INTO [dbo].[TestSuiteSection](
                                     [Id],
                                     [SectionName],
                                     [TestSuiteId],
                                     [ParentSectionId],
                                     [CreatedDateTime],
                                     [CreatedByUserId]
                                     )
                              SELECT S.SectionId,
                                     TSS.SectionName,
                                     @TestSuiteId,
                                     CASE WHEN T.SectionId IS NOT NULL THEN T.SectionId  ELSE @AppendToSectionId  END,
                                     @Currentdate,
                                     @OperationsPerformedBy
									 FROM TestSuiteSection TSS INNER JOIN #MoveSections S ON S.OriginalSectionId = TSS.Id AND TSS.InActiveDateTime IS NULL
									                           LEFT JOIN #MoveSections T ON T.OriginalSectionId = S.ParentSectionId
									 WHERE @IsAllParents = 1 OR @IsCasesWithSections = 1
									 ORDER BY TSS.CreatedDateTime
                      
						UPDATE #MoveCases SET NewSectionId = @AppendToSectionId WHERE @AppendToSectionId IS NOT NULL AND @IsCasesOnly = 1

				        UPDATE #MoveCases SET NewSectionId = M.SectionId FROM #MoveSections M WHERE M.OriginalSectionId = #MoveCases.TestSuiteSectionId and (@IsAllParents =1 or @IsCasesWithSections = 1)

					    UPDATE #MoveCases SET NewSectionId = @SectionId WHERE @IsCasesOnly = 1 AND  @AppendToSectionId IS NULL

                        UPDATE #MoveCases SET TestCaseIdentity = (@TestCaseIdentity + 0),@TestCaseIdentity = @TestCaseIdentity + 1

				      INSERT INTO [dbo].[TestCase](
                                        [Id],
                                        [TestSuiteId],
                                        Title,
                                        SectionId,
										Steps,
										Mission,
										Goals,
										ExpectedResult,
                                        TemplateId,
                                        TypeId,
										Estimate,
                                        PriorityId,
                                        AutomationTypeId,
                                        TestCaseId,
										[References],
										PreCondition,
                                        CreatedDateTime,
                                        CreatedByUserId
                                        )
                                 SELECT NewTestCaseId,
                                        @TestSuiteId,
                                        TC.Title,
                                        NewSectionId,
										Steps,
										Mission,
										Goals,
										ExpectedResult,
                                        TC.TemplateId,
                                        TC.TypeId,
										Estimate,
                                        TC.PriorityId,
                                        TC.AutomationTypeId,
                                        ('C' + CAST(TestCaseIdentity AS NVARCHAR(100))),
										[References],
										PreCondition,
                                        @Currentdate,
                                        @OperationsPerformedBy
                                  FROM #MoveCases M INNER JOIN TestCase TC ON TC.Id = M.OriginalId AND TC.InActiveDateTime IS NULL

							DELETE TCH FROM [dbo].[TestCaseHistory] TCH 
							INNER JOIN TestCase TC ON TC.Id = TCH.TestCaseId
							INNER JOIN #MoveCases M ON TC.Id = M.OriginalId AND TC.InActiveDateTime IS NULL
								WHERE @IsCopy = 0

							INSERT INTO [dbo].[TestCaseHistory]([Id], [TestCaseId], [OldValue], [NewValue], [FieldName], [ConfigurationId], CreatedDateTime, CreatedByUserId)
							SELECT  NEWID(), NewTestCaseId, NULL, NULL, 'TestCaseMoved',
											  (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseCreatedOrUpdated' AND CompanyId = @CompanyId),
								              @Currentdate, @OperationsPerformedBy
												FROM #MoveCases M INNER JOIN TestCase TC ON TC.Id = M.OriginalId AND TC.InActiveDateTime IS NULL
												WHERE @IsCopy = 0
												
							INSERT INTO [dbo].[TestCaseHistory]([Id], [TestCaseId], [OldValue], [NewValue], [FieldName], [ConfigurationId], CreatedDateTime, CreatedByUserId)
							SELECT  NEWID(), NewTestCaseId, NULL, NULL, 'TestCaseCreated',
											  (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseCreatedOrUpdated' AND CompanyId = @CompanyId),
								              @Currentdate, @OperationsPerformedBy
												FROM #MoveCases M INNER JOIN TestCase TC ON TC.Id = M.OriginalId AND TC.InActiveDateTime IS NULL
												WHERE @IsCopy = 1
													
							--INSERT INTO [dbo].[TestCaseHistory]([Id], [TestCaseId], [TestRunId], [OldValue], [NewValue], [FieldName], [Description], [ConfigurationId], CreatedDateTime, CreatedByUserId)
							--			SELECT  NEWID(), TCT.NewCaseId, TR.Id, NULL, NULL, 'TestCase', 'AddedToTestRun',
							--								  (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseCreatedOrUpdated' AND CompanyId = @CompanyId),
							--					              @Currentdate, @OperationsPerformedBy
							--									FROM TestRun TR INNER JOIN #MoveCases TCT ON TCT.TestSuiteId  = TR.TestSuiteId 
							--									WHERE TR.IsIncludeAllCases = 1
							--									      AND TR.TestSuiteId = @TestSuiteId 
							--									      AND TR.InActiveDateTime IS NULL
							--										  AND @IsCopy = 1

							INSERT INTO TestCaseStep(
                                        [Id],
                                        [TestCaseId],
                                        Step,
                                        StepOrder,
                                        ExpectedResult,
                                        CreatedDateTime,
                                        CreatedByUserId
                                        )
                                SELECT S.NewStepId,
                                       T.NewTestCaseId, 
                                       TCS.Step,
                                       TCS.StepOrder,
                                       TCS.ExpectedResult,
                                       @Currentdate,
                                       @OperationsPerformedBy
								  FROM #MoveCases T INNER JOIN TestCaseStep TCS ON T.OriginalId = TCS.TestCaseId AND TCS.InActiveDateTime IS NULL
								                    INNER JOIN #MoveSteps S ON S.StepId = TCS.Id
                           
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
                                         TCT.NewTestCaseId,
                                         @StatusId,
                                         TR.Id,
                                         @Currentdate,
                                         @OperationsPerformedBy
                                  FROM TestRun TR INNER JOIN #MoveCases TCT ON TCT.TestSuiteId  = TR.TestSuiteId 
                                  WHERE TR.IsIncludeAllCases = 1
                                        AND TR.TestSuiteId = @TestSuiteId 
                                        AND TR.InActiveDateTime IS NULL

							INSERT INTO [TestRunSelectedStep]
                                         (
                                         [Id],
                                         [StepId],
                                         [StatusId],
                                         [TestRunId],
                                         CreatedDateTime,
                                         CreatedByUserId
                                         )
                                  SELECT NEWID(),
								         TCS.Id,
										 @StatusId,
										 TR.Id,
										 @Currentdate,
										 @OperationsPerformedBy
								   FROM TestCaseStep TCS INNER JOIN #MoveCases T ON T.NewTestCaseId = TCS.TestCaseId AND TCS.InActiveDateTime IS NULL
										                 INNER JOIN TestRun TR ON TR.TestSuiteId = T.TestSuiteId AND TR.InActiveDateTime IS NULL
								  WHERE TR.IsIncludeAllCases = 1

								  UPDATE #MoveFolders SET NewFolderId = NewTestCaseId FROM #MoveCases WHERE FolderId = OriginalId
						          UPDATE #MoveFolders SET NewFolderId = NewStepId FROM #MoveSteps WHERE StepId = FolderId
								
						DECLARE @TestSuiteFolder UNIQUEIDENTIFIER = (SELECT Id FROM Folder WHERE Id = @TestSuiteId AND InActiveDateTime IS NULL)
						DECLARE @TestrailManagementFolderId UNIQUEIDENTIFIER
					    DECLARE @StoreId UNIQUEIDENTIFIER =(SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)	
						DECLARE @TestSuiteParentFolderId UNIQUEIDENTIFIER
						
						IF(@TestSuiteFolder IS NULL)
						BEGIN
						 
						 DECLARE @TestrailManagementFolderIdCount INT = (SELECT COUNT(1) FROM Folder  WHERE FolderName = 'Test management' AND ParentFolderId = @ProjectId AND InActiveDateTime IS NULL AND StoreId = @StoreId)
						 
                         DECLARE @Temp Table ( Id UNIQUEIDENTIFIER )
                         
                         IF(@TestrailManagementFolderIdCount = 0)
                         BEGIN
                         
                         	INSERT INTO @Temp(Id) EXEC [USP_UpsertFolder] @FolderName = 'Test management',@ParentFolderId= @ProjectId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy
                         
                         	SELECT TOP(1) @TestrailManagementFolderId =  Id FROM @Temp
                         
                         	DELETE FROM @Temp
                         
                         END
                         ELSE
                         BEGIN
                         
                         	SET @TestrailManagementFolderId = (SELECT Id From Folder WHERE FolderName = 'Test management' AND ParentFolderId= @ProjectId AND InActiveDateTime IS NULL AND StoreId = @StoreId)
                         
                         END

						 DECLARE @TestSuiteParentFolderIdCount INT = (SELECT COUNT(1) FROM Folder  WHERE FolderName = 'Test suites and cases' AND ParentFolderId = @TestrailManagementFolderId AND InActiveDateTime IS NULL AND StoreId = @StoreId)
	
						IF(@TestSuiteParentFolderIdCount = 0)
						BEGIN

							INSERT INTO @Temp(Id) EXEC [USP_UpsertFolder] @FolderName = 'Test suites and cases',@ParentFolderId= @TestrailManagementFolderId,@StoreId = @StoreId,@OperationsPerformedBy = @OperationsPerformedBy

							SELECT TOP(1) @TestSuiteParentFolderId =  Id FROM @Temp
		   
							DELETE FROM @Temp

						END
						ELSE
						BEGIN

							SET @TestSuiteParentFolderId = (SELECT Id From Folder WHERE FolderName = 'Test suites and cases' AND ParentFolderId= @TestrailManagementFolderId AND InActiveDateTime IS NULL AND StoreId = @StoreId)

						END


								 INSERT INTO [Folder]
								              (
											   [Id],
											   [FolderName],
											   [ParentFolderId],
											   [CreatedDateTime],
											   [CreatedByUserId],
											   [StoreId]
											  )
										SELECT TS.Id,
										       CONVERT(NVARCHAR(50),TS.TestSuiteName),
											   @TestSuiteParentFolderId,
											   @Currentdate,
											   @OperationsPerformedBy,
											   (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)
											   FROM   TestSuite TS 
											   WHERE  TS.Id = @TestSuiteId
								
								END

								 INSERT INTO [Folder]
								              (
											   [Id],
											   [FolderName],
											   [ParentFolderId],
											   [CreatedDateTime],
											   [CreatedByUserId],
											   [StoreId]
											  )
										SELECT FF.NewFolderId,
										       CASE WHEN M.NewTestCaseId IS NULL THEN CONVERT(NVARCHAR(50),F.FolderName) ELSE ('C' + CAST(M.TestCaseIdentity AS NVARCHAR(100))) END,
											   CASE WHEN FP.NewFolderId IS NULL THEN @TestSuiteId ELSE FP.NewFolderId END,
											   @Currentdate,
											   @OperationsPerformedBy,
											   F.StoreId
										    FROM Folder F INNER JOIN #MoveFolders FF ON FF.FolderId = F.Id AND F.InActiveDateTime IS NULL
											              LEFT JOIN #MoveFolders FP ON FP.FolderId = FF.ParentFolderId
														  LEFT JOIN #MoveCases M ON M.NewTestCaseId = FF.NewFolderId

								UPDATE #MoveFiles SET ReferenceId = NewStepId FROM #MoveSteps WHERE StepId = ReferenceId
								UPDATE #MoveFiles SET ReferenceId = NewTestCaseId FROM #MoveCases WHERE OriginalId = ReferenceId
									
									INSERT INTO [UploadFile]
								               (
											   Id,
											   FileName,
											   FilePath,
											   FileSize,
											   FileExtension,
											   ReferenceId,
											   ReferenceTypeId,
											   FolderId,
											   StoreId,
											   CompanyId,
											   CreatedDateTime,
											   CreatedByUserId
											   )
										SELECT NEWID(),
										       UP.FileName,
											   UP.FilePath,
											   UP.FileSize,
											   UP.FileExtension,
											   fl.ReferenceId,
											   UP.ReferenceTypeId,
											   F.NewFolderId,
											   UP.StoreId,
											   @CompanyId,
											   @Currentdate,
											   @OperationsPerformedBy
										       FROM [UploadFile] UP INNER JOIN #MoveFolders F ON F.FolderId = UP.FolderId AND UP.InActiveDateTime IS NULL
											                        INNER JOIN #MoveFiles FL ON FL.FileId = UP.Id
                
				 IF(@IsCopy = 0)
				 BEGIN

                      UPDATE TestCase SET InActiveDateTime = @Currentdate FROM #MoveCases WHERE Id = OriginalId
				
				      IF(@IsAllParents = 1)	
				      BEGIN
				      
				       UPDATE #MoveSections SET IsCasesOnly = 0 WHERE IsCasesOnly IS NULL
				      
				        DECLARE @Count INT = (SELECT MAX(SectionLevel) FROM #MoveSections)
				      
				       WHILE(@Count > 0)
				       BEGIN
				      
				       UPDATE TestSuiteSection SET InActiveDateTime = @Currentdate WHERE Id IN (SELECT M.OriginalSectionId 
				       FROM #MoveSections M LEFT JOIN TestSuiteSection T ON M.OriginalSectionId = T.ParentSectionId AND T.InActiveDateTime IS NULL  
				       WHERE T.Id IS  NULL AND M.SectionLevel = @Count AND M.IsCasesOnly = 0) 
				       
				       SET @Count = @Count - 1
				      
				       END
				      
				      	UPDATE TestCaseStep SET InActiveDateTime = @Currentdate from #MoveCases M WHERE InActiveDateTime IS NULL AND TestCaseId = M.OriginalId
				      
				      END
			   END

					SELECT @TestSuiteId

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