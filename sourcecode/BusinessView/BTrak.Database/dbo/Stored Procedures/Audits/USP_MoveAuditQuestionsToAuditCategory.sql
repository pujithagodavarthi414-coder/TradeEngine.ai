CREATE PROCEDURE [dbo].[USP_MoveAuditQuestionsToAuditCategory]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @AuditCategoryId UNIQUEIDENTIFIER = NULL,
 @ProjectId UNIQUEIDENTIFIER = NULL,
 @AuditQuestionIds XML = NULL,
 @IsCopy BIT = NULL,
 @IsArchived BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
        IF(@HavePermission = '1')			 
        BEGIN

        IF (@IsCopy = NULL) SET @IsCopy = 0

        IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF (@AuditCategoryId = '00000000-0000-0000-0000-000000000000') SET @AuditCategoryId = NULL
		
		IF (@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL

        IF(@AuditCategoryId IS NULL AND @IsArchived = 0)
		BEGIN
		
			RAISERROR(50011,16,1,'AuditCategoryId')
		
		END
        ELSE
        BEGIN

            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

            DECLARE @Currentdate DATETIME = GETDATE()

            DECLARE @MaxOrderId INT

            SELECT @MaxOrderId = ISNULL(Max([Order]),0) FROM AuditQuestions WHERE AuditCategoryId = @AuditCategoryId

            CREATE TABLE #Temp
            (
            [Id] INT IDENTITY(1, 1),
			NewQuestionId UNIQUEIDENTIFIER,
            AuditQuestionId UNIQUEIDENTIFIER,
            AuditCategoryId UNIQUEIDENTIFIER,
            AuditComplianceId UNIQUEIDENTIFIER,
			UniqueId NVARCHAR(20),
            )

            INSERT INTO #Temp
            (
            AuditQuestionId
            )
            SELECT x.y.value('(text())[1]', 'UNIQUEIDENTIFIER') AS TestCaseId
            FROM @AuditQuestionIds.nodes('ArrayOfGuid/guid') AS x(y)

			DECLARE @Value INT =  ( SELECT ISNULL(MAX(CAST(SUBSTRING(QuestionIdentity,3,len(QuestionIdentity)) AS INT)),0) FROM AuditQuestions WHERE CompanyId = @CompanyId)


            UPDATE #Temp SET NewQuestionId = NEWID(), AuditCategoryId = AQ.AuditCategoryId,AuditComplianceId = AC.AuditComplianceId
						 ,UniqueId = T.Id + @Value
                         FROM #Temp T 
                         JOIN AuditQuestions AQ ON AQ.Id = T.AuditQuestionId
                         JOIN AuditCategory AC ON AC.Id = AQ.AuditCategoryId


			IF(@IsArchived = 1)
			BEGIN 
						UPDATE AuditQuestions
						SET InActiveDateTime = @Currentdate,
							[UpdatedDateTime] = @Currentdate,
							[UpdatedByUserId] = @OperationsPerformedBy
						FROM AuditQuestions AQ INNER JOIN #Temp T ON T.AuditQuestionId = AQ.Id 


						DECLARE @Count INT = (SELECT MAX(Id) FROM #Temp)
						DECLARE @DeleteId UNIQUEIDENTIFIER 

						WHILE (@Count > 0)
						BEGIN

						SET @DeleteId = (SELECT AuditQuestionId FROM #Temp WHERE Id = @Count)

						IF(EXISTS(SELECT Id FROM Folder WHERE Id = @DeleteId  AND InActiveDateTime IS NULL))
						BEGIN

							DECLARE @FolderTimeStamp TIMESTAMP = (SELECT [TimeStamp] FROM [Folder] WHERE Id = @DeleteId AND InActiveDateTime IS NULL)
						
							EXEC [USP_DeleteFolder] @FolderId = @DeleteId,@TimeStamp = @FolderTimeStamp,@OperationsPerformedBy = @OperationsPerformedBy,@IsToReturn = 1
			   
						END

						SET @Count = @Count - 1

						END

			END
			ELSE
			BEGIN
					IF(@IsCopy = 0)
					BEGIN
						UPDATE AuditQuestions
						SET [AuditCategoryId] = @AuditCategoryId,
							[Order] = T.[Id] + @MaxOrderId,
							[UpdatedDateTime] = @Currentdate,
							[UpdatedByUserId] = @OperationsPerformedBy
						FROM AuditQuestions AQ INNER JOIN #Temp T ON T.AuditQuestionId = AQ.Id AND AQ.AuditCategoryId <> @AuditCategoryId
					END
					ELSE
					BEGIN
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
												CompanyId,
												QuestionResponsiblePersonId
					                            )
					                     SELECT NewQuestionId,
					                            AQ.QuestionName,
					                            AQ.QuestionHint,
					                            AQ.QuestionDescription,
					                            AQ.QuestionTypeId,
					                            @AuditCategoryId,
												'Q-' + CAST(M.UniqueId AS NVARCHAR (10)),
					                            AQ.IsMandatory,
					                            AQ.IsOriginalQuestionTypeScore,
												AQ.EstimatedTime,
					                            @Currentdate,
					                            @OperationsPerformedBy,
												@CompanyId,
												AQ.QuestionResponsiblePersonId
					                      FROM #Temp M INNER JOIN AuditQuestions AQ ON AQ.Id = M.AuditQuestionId AND AQ.InActiveDateTime IS NULL
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
                                  FROM #Temp M INNER JOIN AuditQuestions AQ ON AQ.Id = M.AuditQuestionId AND AQ.InActiveDateTime IS NULL

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
								FROM WorkspaceDashboards WD JOIN #Temp M ON M.AuditQuestionId = Wd.WorkspaceId AND WD.InActiveDateTime IS NULL

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
													  FieldName + '-Q-' + CAST(T.UniqueId AS NVARCHAR (10)),
													  FormJson,
													  FormKeys,
													  ModuleTypeId,
													  ReferenceTypeId,
													  T.NewQuestionId,
													  GETDATE(),
													  @OperationsPerformedBy,
													  @CompanyId
												 FROM CustomField CF 
												       INNER JOIN #Temp T ON T.AuditQuestionId = CF.ReferenceId 
													              AND CF.ReferencetypeId = T.AuditComplianceId 
																  AND CF.InActiveDateTime IS NULL
								 
		
						INSERT INTO [dbo].[AuditAnswers](
												Id,	
												QuestionTypeOptionId,
												Answer,
												AuditId,
												AuditQuestionId,	
												Score,	
												QuestionOptionDate,	
												QuestionOptionNumeric,	
												QuestionOptionBoolean,	
												QuestionOptionTime,	
												QuestionOptionText,	
												CreatedByUserId,
												CreatedDateTime,	
												QuestionOptionResult
												 ) 
												SELECT 
												NEWID(),
												AA.QuestionTypeOptionId,
												AA.Answer,	
												AA.AuditId,	
												T.NewQuestionId,
												AA.Score,	
												AA.QuestionOptionDate,	
												AA.QuestionOptionNumeric,	
												AA.QuestionOptionBoolean,	
												AA.QuestionOptionTime,	
												AA.QuestionOptionText,	
												@OperationsPerformedBy,	
												@Currentdate,		
												AA.QuestionOptionResult
												FROM #TEMP T INNER JOIN AuditAnswers AA ON AA.AuditQuestionId = T.AuditQuestionId AND AA.InActiveDateTime IS NULL

						DECLARE @CopiedCount INT = (SELECT MAX(Id) FROM #Temp)
						DECLARE @CopiedQuestionId UNIQUEIDENTIFIER 
						DECLARE @NewQuestionId UNIQUEIDENTIFIER 
						DECLARE @ReferenceTypeId UNIQUEIDENTIFIER = '1618ea33-ace8-4838-9658-b8e713ceb9db'
						DECLARE @StoreId UNIQUEIDENTIFIER = (SELECT Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId )
						DECLARE @Count1 INT = (SELECT MAX(Id) FROM #Temp)

						DECLARE @Temp TABLE (
			            FileId UNIQUEIDENTIFIER
			            ,FolderId UNIQUEIDENTIFIER
			            ,FileSize NVARCHAR(100)
			            ,StoreId UNIQUEIDENTIFIER
			            )

						WHILE (@Count1 > 0)
						BEGIN

						SET @CopiedQuestionId = (SELECT AuditQuestionId FROM #Temp WHERE Id = @Count1)
						SET @NewQuestionId = (SELECT NewQuestionId FROM #Temp WHERE Id = @Count1)

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
									
						END
			END
					

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
                                                      T.AuditComplianceId,
                                                      T.AuditQuestionId,
                                                      (SELECT AuditCategoryName FROM AuditCategory WHERE Id = T.AuditCategoryId),
                                                      (SELECT AuditCategoryName FROM AuditCategory WHERE Id = @AuditCategoryId),
                                                      IIF(@IsCopy = 1,'QuestionCopiedToCategory','QuestionMovedToCategory'),
                                                      GETDATE(),
                                                      @OperationsPerformedBy
                                                      FROM #Temp T

            SELECT Id FROM AuditCategory WHERE Id = @AuditCategoryId

            END
        END			
		ELSE
		BEGIN

			RAISERROR (@HavePermission,11, 1)
				
		END

    END TRY
    BEGIN CATCH

    END CATCH

END