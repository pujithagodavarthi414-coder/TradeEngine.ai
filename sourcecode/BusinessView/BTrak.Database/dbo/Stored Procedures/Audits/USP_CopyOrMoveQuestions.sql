-------------------------------------------------------------------------------
-- Author      Manoj Kumar Gurram
-- Created      '2020-05-05 00:00:00.000'
-- Purpose      To copy or move the questions 
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_CopyOrMoveQuestions] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@AuditId ='987FB2BC-D536-4126-A65F-3AC82BBF3C86'

CREATE PROCEDURE [dbo].[USP_CopyOrMoveQuestions]
(
    @QuestionsXml  XML  = NULL,
    @AppendToCategoryId UNIQUEIDENTIFIER = NULL,
    @QuestionId UNIQUEIDENTIFIER = NULL,
    @IsCopy BIT = NULL,
	@SelectedCategoriesXml XML = NULL,
    @IsQuestionsOnly BIT = NULL,
    @IsQuestionsWithCategories BIT = NULL,
    @IsAllParents BIT = NULL,
    @AuditId  UNIQUEIDENTIFIER = NULL,
    @ParentCategoryId  UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
     
       IF(@IsCopy IS NULL)SET @IsCopy = 0
		
       DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditId)
    
       DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
       IF(@HavePermission = '1')
       BEGIN
                        
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
            DECLARE @Currentdate DATETIME = GETDATE()

			DECLARE @CategoryId UNIQUEIDENTIFIER = NULL
			DECLARE @QuestionsCount INT
            DECLARE @OldValue NVARCHAR(250) = NULL
            DECLARE @NewValue NVARCHAR(250) = NULL            
            DECLARE @OldAuditId UNIQUEIDENTIFIER = NULL            

                     DECLARE @QuestionIdentity INT = (SELECT ISNULL((SELECT MAX(CAST((SUBSTRING(AQ.QuestionIdentity,3,LEN(AQ.QuestionIdentity))) AS INT)) 
                                                                     FROM AuditQuestions AQ 
                                                                          INNER JOIN AuditCategory ACC ON ACC.Id = AQ.AuditCategoryId
                                                                          INNER JOIN AuditCompliance AC ON AC.Id = ACC.AuditComplianceId
                                                                     WHERE AC.CompanyId = @CompanyId
                                                                     GROUP BY AC.CompanyId
                                                                     ),0))
    

					    CREATE TABLE #MoveQuestions
                        (
                            [Id] INT IDENTITY(1, 1),
                            NewQuestionId UNIQUEIDENTIFIER,
                            OriginalId UNIQUEIDENTIFIER,
                            QuestionIdentity INT,
                            AuditComplianceId UNIQUEIDENTIFIER,
                            AuditCategoryId UNIQUEIDENTIFIER,
                            NewCategoryId UNIQUEIDENTIFIER,
							UniqueId INT
                        )
                        INSERT INTO #MoveQuestions(NewQuestionId,OriginalId,AuditComplianceId,AuditCategoryId,UniqueId)
                        SELECT NEWID(),Id,@AuditId,T.AuditCategoryId,ROW_NUMBER() OVER (ORDER BY CONVERT(INT,REPLACE(AQ.QuestionIdentity,'Q-',0)) ASC) FROM AuditQuestions AQ INNER JOIN (SELECT [Table].[Column].value('QuestionId[1]', 'varchar(100)') QuestionId,
                                                                                                  [Table].[Column].value('AuditCategoryId[1]', 'varchar(100)') AuditCategoryId  
                         FROM @QuestionsXml.nodes('/ArrayOfSelectedQuestionModel/SelectedQuestionModel') AS [Table]([Column]))T ON AQ.Id = T.QuestionId
                        
                        CREATE TABLE #MoveCategories
                        (
                        AuditCategoryId UNIQUEIDENTIFIER,
                        OriginalCategoryId UNIQUEIDENTIFIER,
                        AuditCategoryName VARCHAR(250),
                        ParentAuditCategoryId UNIQUEIDENTIFIER,
						IsQuestionsOnly BIT DEFAULT 0,
						CategoryLevel INT DEFAULT 0,
						IsOriginal BIT
						
                        )
				
						INSERT INTO #MoveCategories(AuditCategoryId,OriginalCategoryId,ParentAuditCategoryId,AuditCategoryName,IsOriginal)
						SELECT NEWID(),Id,ParentAuditCategoryId,AuditCategoryName,1 FROM AuditCategory WHERE Id IN (SELECT [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') FROM @SelectedCategoriesXml.nodes('ArrayOfGuid/guid') AS [Table]([Column])) ORDER BY CreatedDateTime 
    
					    INSERT INTO #MoveQuestions(NewQuestionId,OriginalId,AuditComplianceId,AuditCategoryId,UniqueId)
					    SELECT NEWID(),AQ.Id,@AuditId,AQ.AuditCategoryId,ROW_NUMBER() OVER (ORDER BY  CONVERT(INT,REPLACE(AQ.QuestionIdentity,'Q-',0)) ASC) FROM AuditQuestions AQ INNER JOIN #MoveCategories S ON S.OriginalCategoryId = AQ.AuditCategoryId AND AQ.InActiveDateTime IS NULL
					                                                                    LEFT JOIN #MoveQuestions T ON T.OriginalId = AQ.Id
											                                            WHERE T.OriginalId IS NULL

						INSERT INTO #MoveCategories(AuditCategoryId,OriginalCategoryId,AuditCategoryName,ParentAuditCategoryId,IsQuestionsOnly)
                        SELECT NEWID(),ACC.Id,ACC.AuditCategoryName,ACC.ParentAuditCategoryId,1 FROM AuditCategory ACC INNER JOIN #MoveQuestions T ON T.AuditCategoryId = ACC.Id and ACC.InActiveDateTime IS NULL
						                                                                            LEFT JOIN #MoveCategories S ON S.OriginalCategoryId = ACC.Id
																									WHERE S.OriginalCategoryId IS NULL 
						GROUP BY ACC.Id,ACC.AuditCategoryName,ACC.ParentAuditCategoryId,ACC.CreatedDateTime 
						ORDER BY ACC.CreatedDateTime 
                        
	                    INSERT INTO #MoveCategories(AuditCategoryId,OriginalCategoryId,ParentAuditCategoryId,AuditCategoryName)
					    SELECT NEWID(),ACC.Id,ACC.ParentAuditCategoryId,ACC.AuditCategoryName FROM AuditCategory ACC LEFT JOIN #MoveCategories T ON T.OriginalCategoryId = ACC.Id AND ACC.InActiveDateTime IS NULL
					                  WHERE ACC.Id IN (SELECT T.AuditCategoryId FROM #MoveCategories S CROSS APPLY Ufn_GetMultiCategoryLevel(S.OriginalCategoryId) T) 
									  AND T.OriginalCategoryId IS NULL AND @IsAllParents = 1 

			          DECLARE @CteAuditId UNIQUEIDENTIFIER = (SELECT AuditComplianceId FROM AuditCategory WHERE Id = (SELECT TOP 1 OriginalCategoryId FROM #MoveCategories))
	                        
							IF(@IsAllParents = 1 AND @IsCopy = 0)
							BEGIN

							 ;WITH Tree AS
                             (
                                 SELECT ACC_Parent.Id, ACC_Parent.ParentAuditCategoryId, [level] = 1
                                 FROM AuditCategory ACC_Parent
                                 WHERE ACC_Parent.AuditComplianceId = @CteAuditId AND InActiveDateTime IS NULL AND ACC_Parent.ParentAuditCategoryId IS NULL
                                 UNION ALL
                                 SELECT ACC_Child.Id, ACC_Child.ParentAuditCategoryId, [level] = Tree.[level] + 1
                                 FROM AuditCategory ACC_Child INNER JOIN Tree ON Tree.Id = ACC_Child.ParentAuditCategoryId
                                 WHERE ACC_Child.InActiveDateTime IS NULL 
                             )
							UPDATE #MoveCategories SET CategoryLevel = Tree.[level] FROM Tree WHERE Tree.Id = OriginalCategoryId 

						  END  

                     CREATE TABLE #MoveOptions
					      (
					      OptionId UNIQUEIDENTIFIER,
					      NewOptionId UNIQUEIDENTIFIER
					      )
					      INSERT INTO #MoveOptions
					      SELECT AA.Id,NEWID() FROM #MoveQuestions T INNER JOIN AuditAnswers AA ON T.OriginalId = AA.AuditQuestionId AND AA.InActiveDateTime IS NULL
			
					   SET @QuestionsCount = (SELECT COUNT(1) FROM #MoveQuestions)
                    
					IF(@QuestionsCount = 0)
					 BEGIN
        
                         RAISERROR ('PleaseSelectAtLeastOneQuestion',11, 1)
        
                     END
					IF(@AppendToCategoryId IS NULL AND @IsQuestionsOnly = 1) 
					BEGIN

                     DECLARE @CategoryCount INT = ISNULL((SELECT COUNT(1) FROM AuditCategory WHERE AuditComplianceId = @AuditId 
                                                    AND ParentAuditCategoryId IS NULL AND AuditCategoryName LIKE '%Added Category%' AND InActiveDateTime IS NULL), 0)

                     DECLARE @FinalCount INT = @CategoryCount + 1

					 DECLARE @MoveCategoryName NVARCHAR(100) = 'Added Category ' + CONVERT(NVARCHAR(10), @FinalCount)
                     
                     SET @CategoryId = NEWID()
                        
                        INSERT INTO [dbo].[AuditCategory](
                                     [Id],
                                     [AuditCategoryName],
                                     [AuditComplianceId],
                                     [ParentAuditCategoryId],
                                     [CreatedDateTime],
                                     [CreatedByUserId]
                                     )
                              SELECT @CategoryId,
                                     @MoveCategoryName,
                                     @AuditId,
                                     NULL,
                                     @Currentdate,
                                     @OperationsPerformedBy
                     
					 END
				     
					 INSERT INTO [dbo].[AuditCategory](
                                     [Id],
                                     [AuditCategoryName],
                                     [AuditComplianceId],
                                     [ParentAuditCategoryId],
                                     [CreatedDateTime],
                                     [CreatedByUserId]
                                     )
                              SELECT S.AuditCategoryId,
                                     ACC.AuditCategoryName,
                                     @AuditId,
                                     CASE WHEN T.AuditCategoryId IS NOT NULL THEN T.AuditCategoryId  ELSE @AppendToCategoryId  END,
                                     @Currentdate,
                                     @OperationsPerformedBy
									 FROM AuditCategory ACC INNER JOIN #MoveCategories S ON S.OriginalCategoryId = ACC.Id AND ACC.InActiveDateTime IS NULL
									                           LEFT JOIN #MoveCategories T ON T.OriginalCategoryId = S.ParentAuditCategoryId
									 WHERE @IsAllParents = 1 OR @IsQuestionsWithCategories = 1
									 ORDER BY ACC.CreatedDateTime
                      
						UPDATE #MoveQuestions SET NewCategoryId = @AppendToCategoryId WHERE @AppendToCategoryId IS NOT NULL AND @IsQuestionsOnly = 1

				        UPDATE #MoveQuestions SET NewCategoryId = M.AuditCategoryId FROM #MoveCategories M WHERE M.OriginalCategoryId = #MoveQuestions.AuditCategoryId and (@IsAllParents =1 or @IsQuestionsWithCategories = 1)

					    UPDATE #MoveQuestions SET NewCategoryId = @CategoryId WHERE @IsQuestionsOnly = 1 AND @AppendToCategoryId IS NULL

                        UPDATE #MoveQuestions SET QuestionIdentity = (@QuestionIdentity + 0),@QuestionIdentity = @QuestionIdentity + 1
                        
                        SET @OldValue = (SELECT ACM.AuditName FROM #MoveQuestions MQ 
                                 JOIN AuditQuestions AQ ON AQ.Id = MQ.OriginalId 
                                 JOIN AuditCategory AC ON AC.Id = AQ.AuditCategoryId 
                                 JOIN AuditCompliance ACM ON ACM.Id = AC.AuditComplianceId
                        GROUP BY ACM.AuditName)
					   
                        SET @NewValue = (SELECT AuditName FROM AuditCompliance WHERE Id = @AuditId)                            
                        
				      INSERT INTO [dbo].[AuditQuestions](
                                        [Id],
                                        QuestionName,
                                        QuestionHint,
                                        QuestionDescription,
                                        QuestionTypeId,
                                        AuditCategoryId,
                                        QuestionIdentity,
                                        IsMandatory,
                                        IsOriginalQuestionTypeScore,
                                        EstimatedTime,
                                        CreatedDateTime,
                                        CreatedByUserId,
                                        QuestionResponsiblePersonId
                                        )
                                 SELECT NewQuestionId,
                                        AQ.QuestionName,
                                        AQ.QuestionHint,
                                        AQ.QuestionDescription,
                                        AQ.QuestionTypeId,
                                        NewCategoryId,
                                        ('Q-' + CAST(M.QuestionIdentity AS NVARCHAR(100))),
                                        AQ.IsMandatory,
                                        AQ.IsOriginalQuestionTypeScore,
                                        EstimatedTime,
                                        @Currentdate,
                                        @OperationsPerformedBy,
                                        AQ.QuestionResponsiblePersonId
                                  FROM #MoveQuestions M INNER JOIN AuditQuestions AQ ON AQ.Id = M.OriginalId AND AQ.InActiveDateTime IS NULL

								  INSERT INTO [dbo].[Workspace](
											[Id],
											[WorkspaceName],
											[IsCustomizedFor],
											[CreatedDateTime],
											[CreatedByUserId],
											CompanyId
                                        )
                                 SELECT M.NewQuestionId,
                                        CONCAT('AuditQuestion-', CONVERT(NVARCHAR(MAX), M.NewQuestionId)),
                                        'AuditQuestionAnalytics',
                                        @Currentdate,
                                        @OperationsPerformedBy,
										@CompanyId
                                  FROM #MoveQuestions M INNER JOIN AuditQuestions AQ ON AQ.Id = M.OriginalId AND AQ.InActiveDateTime IS NULL

								  INSERT INTO [dbo].[WorkspaceDashboards](
													[Id],
													[WorkspaceId],
													[Y],
													[Col],
													[Row],
													[MinItemCols],
													[MinItemRows],
													[Name],
													[Component],
													[PersistanceJson],
													[CustomWidgetId],
													[IsCustomWidget],
													[CreatedByUserId],
													[CreatedDateTime],
													[CompanyId], 
													[CustomAppVisualizationId], 
													[DashboardName],
													[ExtraVariableJson],
													[Order],
													[IsDraft]
												  )
											 SELECT NEWID(),
													M.NewQuestionId,
													[Y],
													[Col],
													[Row],
													[MinItemCols],
													[MinItemRows],
													[Name],
													[Component],
													[PersistanceJson],
													[CustomWidgetId],
													[IsCustomWidget],
													@OperationsPerformedBy,
													[CreatedDateTime],
													[CompanyId], 
													[CustomAppVisualizationId], 
													[DashboardName],
													[ExtraVariableJson],
													[Order],
													[IsDraft]
								FROM WorkspaceDashboards WD JOIN #MoveQuestions M ON M.OriginalId = Wd.WorkspaceId AND WD.InActiveDateTime IS NULL
        
                     INSERT INTO [dbo].[AuditQuestionHistory](
                                                      [Id],
                                                      [AuditId],
					                                  [QuestionId],
                                                      [OldValue],
                                                      [NewValue],
                                                      [Description],
                                                      CreatedDateTime,
                                                      CreatedByUserId
                                                     )
                                              SELECT  NEWID(),
                                                      @AuditId,
                                                      M.NewQuestionId,
                                                      @OldValue,
                                                      @NewValue,
                                                      IIF(@IsCopy = 1,'QuestionCopiedToAudit','QuestionMovedToAudit'),
                                                      GETDATE(),
                                                      @OperationsPerformedBy
                                                      FROM #MoveQuestions M INNER JOIN AuditQuestions AQ ON AQ.Id = M.OriginalId AND AQ.InActiveDateTime IS NULL

                     INSERT INTO AuditAnswers(
                                        [Id],
                                        QuestionTypeOptionId,
                                        Answer,
                                        AuditId,
                                        [AuditQuestionId],
                                        Score,
                                        QuestionOptionResult,
                                        CreatedDateTime,
                                        CreatedByUserId
                                        )
                                SELECT S.NewOptionId,
                                       AA.QuestionTypeOptionId, 
                                       AA.Answer,
                                       AA.AuditId,
                                       T.NewQuestionId, 
                                       AA.Score,
                                       AA.QuestionOptionResult,
                                       @Currentdate,
                                       @OperationsPerformedBy
								  FROM #MoveQuestions T INNER JOIN AuditAnswers AA ON T.OriginalId = AA.AuditQuestionId AND AA.InActiveDateTime IS NULL
								                    INNER JOIN #MoveOptions S ON S.OptionId = AA.Id

                        DECLARE @CopiedCount INT = (SELECT MAX(Id) FROM #MoveQuestions)
						DECLARE @CopiedQuestionId UNIQUEIDENTIFIER 
						DECLARE @NewQuestionId UNIQUEIDENTIFIER 
						DECLARE @ReferenceTypeId UNIQUEIDENTIFIER = '1618ea33-ace8-4838-9658-b8e713ceb9db'
						DECLARE @StoreId UNIQUEIDENTIFIER = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId )
                        DECLARE @Count1 INT = (SELECT MAX(Id) FROM #MoveQuestions)

                        DECLARE @Temp TABLE (
			            FileId UNIQUEIDENTIFIER
			            ,FolderId UNIQUEIDENTIFIER
			            ,FileSize NVARCHAR(100)
			            ,StoreId UNIQUEIDENTIFIER
			            )

						WHILE (@Count1 > 0)
						BEGIN

						SET @CopiedQuestionId = (SELECT OriginalId FROM #MoveQuestions WHERE Id = @Count1)
						SET @NewQuestionId = (SELECT NewQuestionId FROM #MoveQuestions WHERE Id = @Count1)

						IF(EXISTS(SELECT Id FROM Folder WHERE Id = @CopiedQuestionId  AND InActiveDateTime IS NULL))
						BEGIN

                            INSERT INTO @Temp (FileId,FolderId,FileSize,StoreId)
							EXEC [USP_UpsertAuditMultipleFiles] @FolderId = @NewQuestionId, @ReferenceId = @NewQuestionId, @ReferenceTypeId = @ReferenceTypeId, @OperationsPerformedBy = @OperationsPerformedBy

							INSERT INTO [dbo].[UploadFile]	([Id],[FileName],[FilePath],[FileSize],[FileExtension],[ReferenceId],[ReferenceTypeId],[FolderId],[StoreId],[CreatedDateTime],[CreatedByUserId],[CompanyId])
								SELECT NEWID(), [FileName], [FilePath], [FileSize], [FileExtension], @NewQuestionId, [ReferenceTypeId], @NewQuestionId, @StoreId, GETDATE(), @OperationsPerformedBy, @CompanyId
									FROM [UploadFile] UF INNER JOIN AuditQuestions AQ ON AQ.Id = UF.ReferenceId AND AQ.InActiveDateTime IS NULL
										WHERE AQ.Id = @CopiedQuestionId
			   
						END

						SET @Count1 = @Count1 - 1

						END
                
				 IF(@IsCopy = 0)
				 BEGIN

                      UPDATE AuditQuestions SET InActiveDateTime = @Currentdate,
                                                UpdatedByUserId = @OperationsPerformedBy,
                                                UpdatedDateTime = @Currentdate
                                                 FROM #MoveQuestions T
                                                 WHERE AuditQuestions.Id = T.OriginalId
					 UPDATE Workspace SET InActiveDateTime = @Currentdate,
												UpdatedByUserId = @OperationsPerformedBy,
                                                UpdatedDateTime = @Currentdate
                                                 FROM #MoveQuestions Q WHERE Workspace.Id = Q.OriginalId
					UPDATE WorkspaceDashboards SET InActiveDateTime = @Currentdate,
												UpdatedByUserId = @OperationsPerformedBy,
                                                UpdatedDateTime = @Currentdate
                                                 FROM #MoveQuestions M JOIN WorkspaceDashboards WD ON Wd.WorkspaceId = M.OriginalId
				
				      IF(@IsAllParents = 1)	
				      BEGIN
				      
				       UPDATE #MoveCategories SET IsQuestionsOnly = 0 WHERE IsQuestionsOnly IS NULL
				      
				        DECLARE @Count INT = (SELECT MAX(CategoryLevel) FROM #MoveCategories)
				      
				       WHILE(@Count > 0)
				       BEGIN
				      
				       --UPDATE AuditCategory SET InActiveDateTime = @Currentdate,
           --                                     UpdatedByUserId = @OperationsPerformedBy,
           --                                     UpdatedDateTime = @Currentdate
           --            WHERE Id IN (SELECT M.OriginalCategoryId 
				       --FROM #MoveCategories M LEFT JOIN AuditCategory T ON M.OriginalCategoryId = T.ParentAuditCategoryId AND T.InActiveDateTime IS NULL  
				       --WHERE T.Id IS NULL AND M.CategoryLevel = @Count AND M.IsQuestionsOnly = 0) 

                       UPDATE AuditCategory SET InActiveDateTime = @Currentdate,
                                                UpdatedByUserId = @OperationsPerformedBy,
                                                UpdatedDateTime = @Currentdate
                       WHERE Id IN (SELECT M.OriginalCategoryId 
				       FROM #MoveCategories M LEFT JOIN AuditCategory AC 
					   ON AC.ParentAuditCategoryId = M.OriginalCategoryId AND AC.InActiveDateTime IS NULL
					   where IsOriginal =  1 and AC.Id IS NULL AND CategoryLevel = @Count) 
				       
				       SET @Count = @Count - 1
				      
				       END

                       UPDATE AuditAnswers SET InActiveDateTime = @Currentdate,
                                                UpdatedByUserId = @OperationsPerformedBy,
                                                UpdatedDateTime = @Currentdate 
                                                FROM #MoveQuestions M WHERE InActiveDateTime IS NULL AND AuditQuestionId = M.OriginalId
				      
				      END
			   END

					SELECT @AuditId

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
