-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or update the Conduct
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertAuditConduct]
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--,@AuditConductName='Sprint12'
--,@AuditConductDescription='Pm'
--,@AuditComplianceId='D8352F75-1152-4BCB-A896-7DFBD66FA803'
--,@SelectedQuestionsXml = '<ArrayOfGuid>
--                          <guid>990F04C3-DEE6-4921-B0E6-1044FB5E39C2</guid>
--                          <guid>156BDE91-32C9-4583-AD13-28B6F032D1DF</guid>
--                          <guid>5D356CFB-BDCF-44A3-B27B-2AE116D6E498</guid>
--                          <guid>2AE9C998-29F3-4FC9-B215-470CCB602C8A</guid>
--                          <guid>748B510C-4B84-44A9-9258-496D7876B2D2</guid>
--                     </ArrayOfGuid>'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertAuditConduct]
(
 @AuditConductId UNIQUEIDENTIFIER = NULL,
 @AuditConductName NVARCHAR(800) = NULL,
 @IsIncludeAllQuestions BIT = NULL,
 @SelectedQuestionsXml XML = NULL,
 @SelectedCategoriesXml XML = NULL,
 @IsArchived BIT = NULL,
 @IsCompleted BIT = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @AuditComplianceId UNIQUEIDENTIFIER = NULL,
 @AuditConductDescription NVARCHAR(800) = NULL,
 @DeadlineDate DATETIME = NULL,
 @CronStartDate DATETIME = NULL,
 @CronEndDate DATETIME = NULL,
 @CronExpression nvarchar(50),
 @ResponsibleUserId UNIQUEIDENTIFIER = NULL
 )
AS
 BEGIN
         SET NOCOUNT ON
         BEGIN TRY
		 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		 IF(@OperationsperformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		 
		 IF(@AuditConductId = '00000000-0000-0000-0000-000000000000') SET @AuditConductId = NULL
		 
		 IF(@AuditComplianceId = '00000000-0000-0000-0000-000000000000') SET @AuditComplianceId = NULL

		 IF(@AuditConductName = '') SET @AuditConductName = NULL
	
		 DECLARE @QuestionsCount INT = (SELECT COUNT(1) FROM AuditQuestions AQ1 INNER JOIN AuditCategory AC1 ON AC1.Id = AQ1.AuditCategoryId AND AC1.InActiveDateTime IS NULL
									                      INNER JOIN QuestionTypes QT ON QT.Id = AQ1.QuestionTypeId AND QT.InActiveDateTime IS NULL
                                                            WHERE AC1.AuditComplianceId = @AuditComplianceId AND AQ1.InActiveDateTime IS NULL)
       
         DECLARE @CategoryQuestionsCount INT 

	     IF(@IsIncludeAllQuestions IS NULL) SET @IsIncludeAllQuestions = 0
       
          IF(@SelectedQuestionsXml IS NULL)
          BEGIN      
       
          SET @CategoryQuestionsCount =ISNULL((SELECT COUNT(AQ.Id) FROM 
                              (SELECT [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') AuditCategoryId FROM @SelectedCategoriesXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column]))T INNER JOIN AuditQuestions AQ ON AQ.AuditCategoryId = T.AuditCategoryId AND AQ.InActiveDateTime IS NULL),0)
      
          END

          DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditComplianceId)

		 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		  
		IF (@HavePermission = '1')
		BEGIN

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		 DECLARE @IsLatest BIT = (CASE WHEN @AuditConductId  IS NULL 
                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                      FROM [AuditConduct] WHERE Id = @AuditConductId ) = @TimeStamp
                                                         THEN 1 ELSE 0 END END)
          IF(@AuditConductName IS NULL)
		  BEGIN
			    
				RAISERROR(50011,16, 2, 'AuditConductName')
			
		  END
          ELSE IF(@IsArchived IS NULL)
          BEGIN
		  IF(((@IsIncludeAllQuestions IS NULL OR @IsIncludeAllQuestions = 0) AND @SelectedQuestionsXml IS NULL AND @QuestionsCount = 0) AND (@IsCompleted IS NULL OR @IsCompleted =0))
          BEGIN
          
           RAISERROR ('ThereAreNoQuestionsPresentPleaseAddAQuestionInTheAudit',11, 1)
          
          END
          ELSE IF((@IsIncludeAllQuestions IS NULL OR @IsIncludeAllQuestions = 0) AND (@SelectedQuestionsXml IS NULL AND @CategoryQuestionsCount = 0) AND (@IsCompleted IS NULL OR @IsCompleted =0))
          BEGIN
          
           RAISERROR ('PleaseSelectAtLeastOneQuestion',11, 1)
          
          END
          END
		  ELSE IF(@AuditComplianceId IS NULL)
		  BEGIN

		  RAISERROR(50011,16,2,'AuditCompliance')

		  END
		  
		 IF(@IsArchived IS NULL) SET @IsArchived = 0

         IF(@IsLatest = 1)
         BEGIN

		 DECLARE @Currentdate DATETIME = GETDATE()

          /* checking wether any audit is inserted based on recurring schedules */
         DECLARE @AuditExists BIT = 1
         IF(@CronStartDate IS NULL AND @CronEndDate IS NULL)
         BEGIN
            SET @AuditExists = 0
         END
         ELSE IF((SELECT TOP 1 Id FROM AuditConduct WHERE CronStartDate = @CronStartDate AND CronEndDate = @CronEndDate AND CronExpression = @CronExpression) IS NULL)
         BEGIN
            SET @AuditExists = 0
         END

		 IF(@AuditConductId IS NULL)
        BEGIN
            IF(@AuditExists = 0)
            BEGIN
                 SET @AuditConductId = NEWID()

		         INSERT INTO [dbo].[AuditConduct](
                             [Id],
                             [AuditConductName],
                             [InActiveDateTime],
                             [CreatedDateTime],
                             [CreatedByUserId],
					         [AuditComplianceId],
					         [Description],
					         [IsCompleted],
					         [IsIncludeAllQuestions],
					         [DeadlineDate],
                             [CronStartDate],
                             [CronEndDate],
                             [CronExpression],
                             [ProjectId],
							 [ResponsibleUserId]
					         )
                     SELECT  @AuditConductId,
                             @AuditConductName,
                             CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                             @Currentdate,
                             @OperationsPerformedBy,
				             @AuditComplianceId,
				             @AuditConductDescription,
				             @IsCompleted,
				             @IsIncludeAllQuestions,
					         @DeadlineDate,
                             @CronStartDate,
                             @CronEndDate,
                             @CronExpression,
                             (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditComplianceId),
							 @ResponsibleUserId

                     INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				        SELECT NEWID(), @AuditComplianceId, @AuditConductId, NULL, NULL, @AuditConductName, 'AuditConductCreated', GETDATE(), @OperationsPerformedBy       

					
					IF(@ResponsibleUserId <> NULL)
						BEGIN
						DECLARE @ResponsibleUserName NVARCHAR(50) = (SELECT FirstName+' ' + ISNULL(SurName,'') from [User] WHERE Id = @ResponsibleUserId)
						 INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @AuditComplianceId, @AuditConductId, NULL, null, @ResponsibleUserName, 'AuditConductUser', GETDATE(), @OperationsPerformedBy
						END

            END
			ELSE
			BEGIN
					RAISERROR(50027,16,1,'ConductAlreadyCreated')
			END
        END
		        ELSE
		        BEGIN
						UPDATE [AuditConduct]
					     SET 
						     [AuditConductName] = @AuditConductName,
							 [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							 [UpdatedDateTime] = @Currentdate,
							 [AuditComplianceId] = @AuditComplianceId,
							 [UpdatedByUserId] = @OperationsPerformedBy,
							 [Description] = @AuditConductDescription,
							 [IsIncludeAllQuestions] = @IsIncludeAllQuestions,
							 [IsCompleted] = @IsCompleted,
							 [DeadlineDate] = @DeadlineDate,
                             [ProjectId] = (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditComplianceId),
							 [ResponsibleUserId] = @ResponsibleUserId
							 WHERE Id = @AuditConductId

                        IF(@IsArchived = 1)
							INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), NULL, @AuditConductId, NULL, NULL, @AuditConductName, 'AuditConductArchived', GETDATE(), @OperationsPerformedBy
        
                END
				
				--TO insert Audit fields into the Audit conduct
				INSERT INTO CustomField(Id,
										 FieldName,
										 FormJson,
										 FormKeys,
										 ModuleTypeId,
										 ReferenceTypeId,
										 ReferenceId,
										 CreatedDateTime,
										 CreatedByUserId,
										 CompanyId)
								  SELECT NEWID(),
										  FieldName,
										  FormJson,
										  FormKeys,
										  ModuleTypeId,
										  @ProjectId,
										  @AuditConductId,
										  GETDATE(),
										  @OperationsPerformedBy,
										  @CompanyId
									 FROM CustomField CF INNER JOIN [AuditCompliance] AC ON AC.Id = CF.ReferenceId AND CF.ReferencetypeId = @ProjectId
									    AND CF.InactiveDateTime IS NULL AND AC.Id = @AuditComplianceId 
			 
			 IF(@IsArchived IS NULL OR @IsArchived = 0) 
                              BEGIN
                                
                                 CREATE TABLE #ConductDependency
                                (
                                    Id UNIQUEIDENTIFIER,
                                    QuestionId UNIQUEIDENTIFIER,
                                    AuditCategoryId UNIQUEIDENTIFIER,
                                    IsArchived BIT
                                )
                              CREATE NONCLUSTERED INDEX #ConductDependency ON #ConductDependency ([Id],[QuestionId],[IsArchived]);

							  IF(@IsIncludeAllQuestions = 0)
							  BEGIN

                               INSERT INTO #ConductDependency(
                                                            QuestionId,
                                                            AuditCategoryId
                                                            )
                                                            SELECT  [Table].[Column].value('QuestionId[1]', 'varchar(2000)')QuestionId,
                                                                    [Table].[Column].value('AuditCategoryId[1]', 'uniqueidentifier')QuestionId
                                                                   FROM @SelectedQuestionsXml.nodes('/ArrayOfSelectedQuestionModel/SelectedQuestionModel') AS [Table]([Column])
				                                            UNION

												            SELECT Id,
                                                                   AQ.AuditCategoryId
                                                                   FROM AuditQuestions AQ 
                                                                   JOIN (SELECT [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') AS AuditCategoryId 
                                                                                FROM @SelectedCategoriesXml.nodes('ArrayOfGuid/guid') AS [Table]([Column])) AC ON AC.AuditCategoryId = AQ.AuditCategoryId AND AQ.InactiveDateTime IS NULL
                               END
                                              
                            IF(@IsIncludeAllQuestions = 1)
                            BEGIN

                               INSERT INTO #ConductDependency(QuestionId,AuditCategoryId)
                                SELECT AQ.Id,AQ.AuditCategoryId
                                FROM AuditQuestions AQ INNER JOIN AuditCategory ACC ON ACC.Id = AQ.AuditCategoryId AND ACC.InActiveDateTime IS NULL AND AQ.InActiveDateTime IS NULL
                                WHERE ACC.AuditComplianceId = @AuditComplianceId
                              
                              END

                              ;With CategoriesTree AS (
                                    SELECT AuditCategoryId FROM #ConductDependency 
                                    
                                    UNION ALL

                                    SELECT ParentAuditCategoryId AS AuditCategoryId
                                           FROM AuditCategory AC
                                           JOIN CategoriesTree CT ON CT.AuditCategoryId = AC.Id AND AC.InActiveDateTime IS NULL
                                           WHERE CT.AuditCategoryId IS NOT NULL
                              )

                              INSERT INTO AuditConductSelectedCategory(
                                                                       [Id],
                                                                       [AuditCategoryId],
                                                                       [ParentAuditCategoryId],
                                                                       [AuditConductId],
                                                                       [AuditCategoryName],
                                                                       [AuditCategoryDescription],
                                                                       [AuditComplianceId],
                                                                       [CreatedDateTime],
                                                                       [CreatedByUserId],
                                                                       [Order]
                                                                      )
                                                                SELECT NEWID(),
                                                                       AC.Id,
                                                                       AC.ParentAuditCategoryId,
                                                                       @AuditConductId,
                                                                       AC.AuditCategoryName,
                                                                       AC.AuditCategoryDescription,
                                                                       AC.AuditComplianceId,
                                                                       GETDATE(),
                                                                       @OperationsPerformedBy,
                                                                       --ROW_NUMBER() OVER (ORDER BY AC.CreatedDateTime ASC)
																	   --ROW_NUMBER() OVER (ORDER BY AC.[Order] ASC)
																	   AC.[Order]
                                                                       FROM AuditCategory AC
                                                                       INNER JOIN (SELECT AuditCategoryId FROM CategoriesTree GROUP BY AuditCategoryId) CT ON CT.AuditCategoryId = AC.Id 
																	   LEFT JOIN AuditConductSelectedCategory ACSC ON AC.AuditComplianceId =  ACSC.AuditComplianceId AND ACSC.AuditCategoryId = AC.Id AND ACSC.AuditConductId = @AuditConductId
																	   WHERE ACSC.ID IS NULL

                                   UPDATE AuditConductSelectedQuestion
                                      SET InActiveDateTime = @Currentdate,
                                          UpdatedDateTime  = @Currentdate,
                                          UpdatedByUserId  = @OperationsPerformedBy
										  FROM AuditConductSelectedQuestion ACSQ
                                          LEFT JOIN #ConductDependency T ON ACSQ.AuditQuestionId = T.QuestionId
                                          WHERE T.QuestionId IS NULL AND ACSQ.AuditConductId = @AuditConductId 
										           AND InActiveDateTime IS NULL  

                                INSERT INTO [dbo].[AuditConductSelectedQuestion](
                                            Id,
                                            AuditConductId,
                                            AuditQuestionId,
                                            CreatedDateTime,
                                            CreatedByUserId
                                            )
                                     SELECT NEWID(),           
                                            @AuditConductId,
                                            QuestionId,
                                            @Currentdate, 
                                            @OperationsPerformedBy
                                       FROM #ConductDependency T
									   LEFT JOIN [AuditConductSelectedQuestion] ACSC ON ACSC.AuditConductId = @AuditConductId AND ACSC.AuditQuestionId = T.QuestionId
									   WHERE T.Id IS NULL AND ACSC.ID IS NULL
                                
                                UPDATE [AuditConductQuestions] SET InActiveDateTime = @Currentdate,
                                                                   UpdatedDateTime  = @Currentdate,
                                                                   UpdatedByUserId  = @OperationsPerformedBy
                                                                   FROM [AuditConductQuestions] ACQ
                                                                   LEFT JOIN #ConductDependency T ON ACQ.QuestionId = T.QuestionId
                                                                    WHERE T.QuestionId IS NULL AND ACQ.AuditConductId = @AuditConductId 
										                           AND InActiveDateTime IS NULL  
                                
                                UPDATE [AuditConductAnswers] SET InActiveDateTime = @Currentdate,
                                                                 UpdatedDateTime  = @Currentdate,
                                                                 UpdatedByUserId  = @OperationsPerformedBy
                                                                 FROM [AuditConductAnswers] ACA
                                                                  LEFT JOIN #ConductDependency T ON ACA.AuditQuestionId = T.QuestionId
                                                                            WHERE T.QuestionId IS NULL AND ACA.AuditConductId = @AuditConductId 
										                                    AND InActiveDateTime IS NULL  

                                INSERT INTO [AuditConductQuestions](
                                                                    [Id],
																	[QuestionId],
	                                                                [AuditConductId],
	                                                                [QuestionName],
	                                                                [QuestionDescription],
	                                                                [QuestionTypeId],
	                                                                [AuditCategoryId],
	                                                                [QuestionResult],
	                                                                [Order],
	                                                                [CreatedDateTime],
                                                                    [CreatedByUserId],
                                                                    [InActiveDateTime],
	                                                                [CompanyId],
	                                                                [IsMandatory],
                                                                    QuestionTypeName,
                                                                    MasterQuestionTypeId,
                                                                    QuestionIdentity,
                                                                    QuestionHint,
                                                                    EstimatedTime,
                                                                    ImpactId,
                                                                    PriorityId,
                                                                    RiskId,
                                                                    QuestionResponsiblePersonId
                                                                   )
                                                             SELECT NEWID(),
															        CD.QuestionId,
                                                                    @AuditConductId,
                                                                    AQ.[QuestionName],
                                                                    AQ.[QuestionDescription],
                                                                    AQ.[QuestionTypeId],
                                                                    AQ.[AuditCategoryId],
                                                                    AQ.[QuestionResult],
                                                                    AQ.[Order],
                                                                    AQ.[CreatedDateTime],
                                                                    AQ.[CreatedByUserId],
                                                                    AQ.[InActiveDateTime],
                                                                    AQ.[CompanyId],
                                                                    AQ.[IsMandatory],
                                                                    QT.QuestionTypeName,
                                                                    QT.MasterQuestionTypeId,
                                                                    AQ.QuestionIdentity,
                                                                    AQ.QuestionHint,
                                                                    AQ.EstimatedTime,
                                                                    AQ.ImpactId,
                                                                    AQ.PriorityId,
                                                                    AQ.RiskId,
                                                                    AQ.QuestionResponsiblePersonId
                                                                    FROM #ConductDependency CD
                                                                    JOIN AuditQuestions AQ ON AQ.Id = CD.QuestionId AND AQ.InActiveDateTime IS NULL
                                                                    JOIN QuestionTypes QT ON QT.Id = AQ.QuestionTypeId
                                                                    LEFT JOIN [AuditConductQuestions] ACQ ON ACQ.QuestionId = ACQ.QuestionId AND ACQ.AuditConductId = @AuditConductId
                                                                    WHERE ACQ.Id IS NULL

			 DECLARE @QuestionDefaultWorkflowId UNIQUEIDENTIFIER = (SELECT QuestionDefaultWorkflowId FROM DefaultWorkFlowForReferenceTypes WHERE CompanyId = @CompanyId)
			 DECLARE @EnableQuestionLevelWorkFlow BIT = (SELECT EnableQuestionLevelWorkFlow FROM AuditCompliance WHERE Id = @AuditComplianceId)
			 IF(@QuestionDefaultWorkflowId IS NOT NULL AND @EnableQuestionLevelWorkFlow = 1)
			 BEGIN
			 INSERT INTO [dbo].[GenericStatus](
									      Id,
									      WorkflowId,
									      ReferenceId,
										  ReferenceTypeId,
										  [Status],
										  CompanyId,
									      CreatedDateTime,
									      CreatedByUserId
									      )
								  SELECT  NEWID(),
										  @QuestionDefaultWorkflowId,
										  A.Id,
										  'A9F71842-E4EB-4410-A1C2-69D7BE4BCDBD',
										  'DRAFT',
										  @CompanyId,
										  @CurrentDate,
										  @OperationsPerformedBy
										  FROM  (SELECT * from AuditConductQuestions A WHERE A.QuestionId NOT IN (
											select ACQ.QUestionId  FROM  [AuditConductQuestions] ACQ 
											JOIN AuditQuestions AQ ON AQ.Id = ACQ.QuestionId AND AQ.InActiveDateTime IS NULL
											 JOIN GenericStatus GS ON GS.ReferenceId = AQ.Id WHERE AuditConductId = @AuditConductId) 
											 AND AuditConductId =  @AuditConductId) A

				END
																	INSERT INTO [dbo].[ConductQuestionRoleConfiguration](
																								[Id],
																								[AuditQuestionId],
																								[Roles],
																								[CanView],
																								[CanEdit],
																								[CanAddAction],
																								[NoPermission],
																								[CompanyId],
																								[CreatedDateTime],
																								[CreatedByUserId],
																								[Users],	
																								[ConductQuestionId]
																								)
																					SELECT NEWID(),
																							A.AuditQuestionId,
																							A.[Roles],
																							A.[CanView],
																							A.[CanEdit],
																							A.[CanAddAction],
																							A.[NoPermission],
																							A.[CompanyId],
																							GETDATE(),
																							@OperationsPerformedBy,
																							A.[Users],
																							ACQ.Id FROM AuditConductQuestionRoleConfiguration  A 
																							--INNER JOIN  #ConductDependency CD ON CD.QuestionID = A.AuditQuestionId
																							--INNER JOIN [AuditConductQuestions] ACQ ON ACQ.QuestionId = A.AuditQuestionId AND ACQ.AuditConductId = @AuditConductId
																							--JOIN AuditQuestions AQ ON AQ.Id = CD.QuestionId AND AQ.InActiveDateTime IS NULL
																							JOIN [AuditConductQuestions] ACQ ON ACQ.QuestionId = A.AuditQuestionId AND ACQ.AuditConductId = @AuditConductId
																							JOIN AuditQuestions AQ ON AQ.Id = A.AuditQuestionId AND AQ.InActiveDateTime IS NULL
									 INSERT INTO CustomField(Id,
															FieldName,
															FormJson,
															FormKeys,
															ModuleTypeId,
															ReferenceTypeId,
															ReferenceId,
															CreatedDateTime,
															CreatedByUserId,
															CompanyId)
													SELECT NEWID(),
														  FieldName,
														  FormJson,
														  FormKeys,
														  ModuleTypeId,
														  @AuditConductId,
														  ReferenceId,
														  GETDATE(),
														  @OperationsPerformedBy,
														  @CompanyId
													 FROM CustomField CF INNER JOIN #ConductDependency CD ON CD.QuestionId = CF.ReferenceId AND CF.ReferencetypeId = @AuditComplianceId AND CF.InactiveDateTime IS NULL

                                     INSERT INTO AuditConductAnswers(
                                                                      Id
                                                                     ,AuditConductId
                                                                     ,QuestionTypeOptionId
                                                                     ,QuestionTypeOptionName
                                                                     ,Answer
                                                                     ,AuditQuestionId
                                                                     ,Score
                                                                     ,CreatedByUserId
                                                                     ,CreatedDateTime
                                                                     ,[QuestionOptionResult]
                                                                     ,[Order]
                                                                    )
                                                               SELECT NEWID()
                                                                     ,@AuditConductId
                                                                     ,QTO.Id
                                                                     ,QTO.QuestionTypeOptionName
                                                                     ,AA.Answer
                                                                     ,AA.AuditQuestionId
                                                                     ,IIF(AQ.IsOriginalQuestionTypeScore = 1,QTO.QuestionTypeOptionScore,AA.Score)
                                                                     ,AA.CreatedByUserId
                                                                     ,AA.CreatedDateTime
                                                                     ,AA.[QuestionOptionResult]
                                                                     ,QTO.QuestionTypeOptionOrder
                                                                      FROM AuditAnswers AA
                                                                      JOIN AuditQuestions AQ ON AQ.Id = AA.AuditQuestionId AND AA.InactiveDateTime IS NULL AND AQ.InActiveDateTime IS NULL
                                                                      JOIN #ConductDependency CD ON CD.QuestionId = AQ.Id
                                                                      JOIN QuestionTypeOptions QTO ON QTO.Id = AA.QuestionTypeOptionId AND QTO.InactiveDateTime IS NULL
                                                                      LEFT JOIN [AuditConductAnswers] ACA ON ACA.AuditQuestionId = AQ.Id AND ACA.AuditConductId = @AuditConductId
                                                                      WHERE ACA.Id IS NULL

											INSERT INTO ConductQuestionDocuments
													(
													Id,
													DocumentName,
													DocumentOrder,
													IsDocumentMandatory,
													ConductQuestionId,
													CreatedByUserId,
													CreatedDateTime
													)
													SELECT NEWID(),AD.DocumentName, AD.DocumentOrder, AD.IsDocumentMandatory, ACQ.Id, @OperationsPerformedBy,
													GETDATE() FROM AuditQuestionDocuments AD JOIN AuditQuestions AQ ON AD.AuditQuestionId = AQ.Id AND AD.InActiveDateTime IS NULL AND AQ.InActiveDateTime IS NULL
													JOIN #ConductDependency CD ON CD.QuestionId = AQ.Id
													JOIN AuditConductQuestions ACQ ON ACQ.QuestionId = AQ.Id
													LEFT JOIN ConductQuestionDocuments C ON C.ConductQuestionId = ACQ.Id WHERE C.Id IS NULL

                               INSERT INTO [dbo].[AuditQuestionHistory]([Id], 
                                                                        [AuditId],  
                                                                        [ConductId], 
                                                                        [QuestionId], 
                                                                        [OldValue], 
                                                                        [NewValue], 
                                                                        [Description], 
                                                                        [Field],
                                                                        [CreatedDateTime], 
                                                                        [CreatedByUserId]
                                                                       )
                                                                SELECT  NEWID(),
                                                                        @AuditComplianceId,
                                                                        @AuditConductId,
                                                                        QuestionId,
                                                                        NULL,
                                                                        NULL,
                                                                        'QuestionConductCreated',
                                                                        'QuestionConductCreated',
                                                                        GETDATE(),
                                                                        @OperationsPerformedBy
                                                                        FROM #ConductDependency 

                              
							   END	
		
                SELECT Id  FROM [dbo].[AuditConduct] WHERE Id = @AuditConductId

		END
		ELSE
                        RAISERROR (50008,11, 1)

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