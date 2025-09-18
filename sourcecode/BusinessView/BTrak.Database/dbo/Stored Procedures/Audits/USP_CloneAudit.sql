CREATE PROCEDURE [dbo].[USP_CloneAudit]
(
 @AuditComplianceId UNIQUEIDENTIFIER = NULL,
 @AuditComplianceName NVARCHAR(250) = NULL,
 @IsArchived BIT = 0,
 @OperationsPerformedBy UNIQUEIDENTIFIER
 )
AS
 BEGIN
         SET NOCOUNT ON
         BEGIN TRY
		 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		 IF(@OperationsperformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		 IF(@AuditComplianceName = '') SET @AuditComplianceName = NULL

		 IF(@IsArchived IS NULL) SET @IsArchived = 0

		 DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditComplianceId)

		 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		  
		IF (@HavePermission = '1')
		BEGIN

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		 DECLARE @Currentdate DATETIME = GETDATE()

		 DECLARE @AuditComplianceNameCount INT

		 DECLARE @TempAuditName NVARCHAR(300)
		 
		 DECLARE @CloneAuditName NVARCHAR(300)

		 DECLARE @MaxOrderId INT = 0
		 
		 DECLARE @MaxOrderQuestionId INT = 0

         --SELECT @MaxOrderId = ISNULL(Max([Order]),0) FROM AuditQuestions WHERE AuditCategoryId = @AuditCategoryId

		 SET @MaxOrderQuestionId = (SELECT ISNULL(MAX(CAST(SUBSTRING(QuestionIdentity,3,len(QuestionIdentity)) AS INT)),0) + 1 FROM AuditQuestions WHERE CompanyId = @CompanyId)

		 IF(@AuditComplianceName IS NULL)
		 BEGIN
			    
			RAISERROR(50011,16, 2, 'AuditName')
			
		 END
         ELSE
		 BEGIN

		 SET @TempAuditName = @AuditComplianceName + '- copy '

		 SET @AuditComplianceNameCount = (SELECT COUNT(1) FROM AuditCompliance WHERE AuditName LIKE '%' + @TempAuditName + '%' AND CompanyId = @CompanyId)

		 SET @CloneAuditName = @TempAuditName + CONVERT(NVARCHAR(20), @AuditComplianceNameCount + 1)

		 DECLARE @CloneAuditId UNIQUEIDENTIFIER = NEWID()

		 INSERT INTO [dbo].[AuditCompliance]([Id], [CompanyId], [AuditName], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId], [Description], [IsRAG], [InboundPercent], [OutboundPercent], [CanLogTime],[ResposibleUserId],AuditFolderId, ProjectId)
			SELECT @CloneAuditId, @CompanyId, @CloneAuditName, NULL, GETDATE(), @OperationsPerformedBy, [Description], IsRAG, InboundPercent, OutboundPercent, CanLogTime , ResposibleUserId, AuditFolderId, ProjectId
				FROM AuditCompliance WHERE Id = @AuditComplianceId

		 INSERT INTO [dbo].[CustomField]([Id], [FieldName], [FormJson], [FormKeys], [ModuleTypeId], [ReferenceId], [ReferenceTypeId], [CreatedDateTime], [CreatedByUserId], [CompanyId])
			SELECT NEWID(), [FieldName], [FormJson], [FormKeys], [ModuleTypeId], @CloneAuditId, [ReferenceTypeId], GETDATE(), @OperationsPerformedBy, [CompanyId]
				FROM CustomField WHERE ReferenceId = @AuditComplianceId AND CompanyId = @CompanyId AND InactiveDateTime IS NULL

		 INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @CloneAuditId, NULL, NULL, @AuditComplianceName, @CloneAuditName, 'AuditCloned', GETDATE(), @OperationsPerformedBy

		 INSERT INTO AuditTags(Id, AuditId, TagId, TagName, CreatedByUserId, CreatedDateTime)
			SELECT NEWID(), @CloneAuditId, TagId, TagName, @OperationsPerformedBy, GETDATE()
				FROM AuditTags WHERE AuditId = @AuditComplianceId AND InActiveDateTime IS NULL

		 --INSERT INTO [dbo].[CronExpression]([Id], [CronExpressionName], [CronExpression], [CustomWidgetId], [EndDate], [ConductEndDate], [IsPaused], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId], CompanyId, JobId)
			--SELECT NEWID(), CronExpressionName, CronExpression, @CloneAuditId, EndDate, ConductEndDate, IsPaused, NULL, GETDATE(), @OperationsPerformedBy, @CompanyId, JobId
			--	FROM CronExpression WHERE CustomWidgetId = @AuditComplianceId AND InActiveDateTime IS NULL

		 CREATE TABLE #Temp  
         (
         	    AuditCategoryId UNIQUEIDENTIFIER,
         	    ParentAuditCategoryId UNIQUEIDENTIFIER,
         	    MainAuditCategoryId UNIQUEIDENTIFIER,
         	    MainParentAuditCategoryId UNIQUEIDENTIFIER
         )

         INSERT INTO #Temp(AuditCategoryId, ParentAuditCategoryId, MainAuditCategoryId)
         SELECT Id,ParentAuditCategoryId,NEWID()
         FROM AuditCategory 
         WHERE AuditComplianceId = @AuditComplianceId
         AND InActiveDateTime IS NULL
         
         UPDATE #Temp SET MainParentAuditCategoryId = T.Parent
         FROM #Temp AC 
         INNER JOIN (
         SELECT AC.AuditCategoryId,AC.MainAuditCategoryId,AC.ParentAuditCategoryId,ACC.MainAuditCategoryId AS Parent
         FROM #Temp AC INNER JOIN #Temp ACC ON AC.ParentAuditCategoryId = ACC.AuditCategoryId
         ) T ON T.AuditCategoryId = AC.AuditCategoryId
         
	     INSERT INTO [dbo].[AuditCategory]([Id], [ParentAuditCategoryId], [AuditCategoryName]
            , [CreatedDateTime], [CreatedByUserId], [AuditComplianceId], [AuditCategoryDescription])
		  SELECT AC.MainAuditCategoryId, AC.MainParentAuditCategoryId, ACMain.AuditCategoryName, ACMain.CreatedDateTime, @OperationsPerformedBy
                  , @CloneAuditId, ACMain.AuditCategoryDescription 
          FROM #Temp AC
          INNER JOIN AuditCategory ACMain ON ACMain.Id = AC.AuditCategoryId
         
          SELECT NEWID() AS NewQuestionId, AQ.Id AS OldQuesionId, AC.AuditCategoryId AS OldAuditCategoryId, AC.MainAuditCategoryId AS NewAuditCategoryId
          INTO #AuditQuestionTable
          FROM AuditQuestions AQ 
			   INNER JOIN #Temp AC ON AC.AuditCategoryId = AQ.AuditCategoryId AND AQ.InActiveDateTime IS NULL

		  INSERT INTO AuditQuestions (Id, QuestionName, AuditCategoryId, QuestionDescription, QuestionTypeId, CreatedByUserId, CreatedDateTime,
										   IsMandatory, IsOriginalQuestionTypeScore, CompanyId, QuestionIdentity, QuestionHint, [Order], [EstimatedTime], QuestionResponsiblePersonId)
			SELECT NewQuestionId, AQ.QuestionName, AC.NewAuditCategoryId, AQ.QuestionDescription, AQ.QuestionTypeId, @OperationsPerformedBy, AQ.CreatedDateTime,
								AQ.IsMandatory, AQ.IsOriginalQuestionTypeScore, @CompanyId, NULL, AQ.QuestionHint, AQ.[Order], AQ.EstimatedTime, AQ.QuestionResponsiblePersonId
			FROM AuditQuestions AQ
			INNER JOIN #AuditQuestionTable AC ON AC.OldQuesionId = AQ.Id

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
							 CF.FieldName,
							 CF.FormJson,
							 CF.FormKeys,
							 CF.ModuleTypeId,
							  @CloneAuditId,
							  AC.NewQuestionId,
							  GETDATE(),
							  @OperationsPerformedBy,
							  CF.CompanyId
						 FROM CustomField CF 
						      INNER JOIN #AuditQuestionTable AC ON AC.OldQuesionId = CF.ReferenceId 
												                  AND CF.ReferencetypeId = @AuditComplianceId
																  AND CF.InActiveDateTime IS NULL
								 

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
                                  FROM #AuditQuestionTable M INNER JOIN AuditQuestions AQ ON AQ.Id = M.OldQuesionId AND AQ.InActiveDateTime IS NULL

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
								FROM WorkspaceDashboards WD JOIN #AuditQuestionTable M ON M.OldQuesionId = Wd.WorkspaceId AND WD.InActiveDateTime IS NULL

		 INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
		 SELECT NEWID(), @CloneAuditId, NULL, AQ.Id, NULL, NULL, 'QuestionCreated', GETDATE(), @OperationsPerformedBy
		 	FROM AuditQuestions AQ
		           INNER JOIN AuditCategory AC ON AC.Id = AQ.AuditCategoryId
		 		  INNER JOIN AuditCompliance ACM ON ACM.Id = AC.AuditComplianceId AND ACM.Id = @CloneAuditId

		 UPDATE AuditQuestions SET QuestionIdentity = 'Q-' + CONVERT(NVARCHAR(10),T.QNumber + @MaxOrderQuestionId)
		 FROM AuditQuestions AQ
		 INNER JOIN (SELECT Id, ROW_NUMBER() OVER(ORDER BY CreatedDateTime) AS QNumber FROM AuditQuestions AQ
            INNER JOIN #AuditQuestionTable AC ON AC.NewQuestionId = AQ.Id) T ON T.Id = AQ.Id

		 INSERT INTO AuditAnswers(Id, AuditQuestionId, AuditId, QuestionTypeOptionId, Score, QuestionOptionResult, CreatedByUserId, CreatedDateTime)
			SELECT NEWID(), AQT.NewQuestionId, @CloneAuditId, ANS.QuestionTypeOptionId, ANS.Score, ANS.QuestionOptionResult, @OperationsPerformedBy, ANS.CreatedDateTime 
				FROM AuditAnswers ANS --ON ANS.AuditQuestionId = AQ.Id AND ANS.InactiveDateTime IS NULL
				INNER JOIN #AuditQuestionTable AQT ON AQT.OldQuesionId = ANS.AuditQuestionId AND ANS.InactiveDateTime IS NULL
			
			DECLARE @CopiedQuestionId UNIQUEIDENTIFIER,@NewQuestionId UNIQUEIDENTIFIER
			DECLARE @ReferenceTypeId UNIQUEIDENTIFIER = '1618ea33-ace8-4838-9658-b8e713ceb9db'
			DECLARE @StoreId UNIQUEIDENTIFIER = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId )

			DECLARE @Temp TABLE (
			FileId UNIQUEIDENTIFIER
			,FolderId UNIQUEIDENTIFIER
			,FileSize NVARCHAR(100)
			,StoreId UNIQUEIDENTIFIER
			)

			 DECLARE Cursor_Script CURSOR
			 FOR SELECT OldQuesionId,NewQuestionId
			     FROM #AuditQuestionTable
			  
			 OPEN Cursor_Script
			  
			     FETCH NEXT FROM Cursor_Script INTO 
			         @CopiedQuestionId,@NewQuestionId
			      
			     WHILE @@FETCH_STATUS = 0
			     BEGIN
					
					IF(EXISTS(SELECT Id FROM Folder WHERE Id = @CopiedQuestionId  AND InActiveDateTime IS NULL))
					BEGIN
					
						INSERT INTO @Temp (FileId,FolderId,FileSize,StoreId)
						EXEC [USP_UpsertAuditMultipleFiles] @FolderId = @NewQuestionId, @ReferenceId = @NewQuestionId, @ReferenceTypeId = @ReferenceTypeId, @OperationsPerformedBy = @OperationsPerformedBy
					
						INSERT INTO [dbo].[UploadFile]	([Id],[FileName],[FilePath],[FileSize],[FileExtension],[ReferenceId],[ReferenceTypeId],[FolderId],[StoreId],[CreatedDateTime],[CreatedByUserId],[CompanyId])
							SELECT NEWID(), [FileName], [FilePath], [FileSize], [FileExtension], @NewQuestionId, [ReferenceTypeId], @NewQuestionId, @StoreId, GETDATE(), @OperationsPerformedBy, @CompanyId
								FROM [UploadFile] UF INNER JOIN AuditQuestions AQ ON AQ.Id = UF.ReferenceId AND AQ.InActiveDateTime IS NULL
									WHERE AQ.Id = @CopiedQuestionId
					   
					END

					FETCH NEXT FROM Cursor_Script INTO 
			         @CopiedQuestionId,@NewQuestionId

					 END
             
			CLOSE Cursor_Script
			 
			DEALLOCATE Cursor_Script

		 SELECT Id  FROM [dbo].[AuditCompliance] WHERE Id = @CloneAuditId

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