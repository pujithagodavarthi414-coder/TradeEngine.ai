CREATE PROCEDURE [dbo].[USP_UpsertAuditQuestion]
(
 @QuestionId UNIQUEIDENTIFIER = NULL,
 @AuditCategoryId UNIQUEIDENTIFIER = NULL,
 @QuestionTypeId UNIQUEIDENTIFIER = NULL,
 @QuestionName NVARCHAR(800) = NULL,
 @QuestionDescription NVARCHAR(MAX) = NULL,
 @IsArchived BIT = 0,
 @IsOriginalQuestionTypeScore BIT = 0,
 @IsQuestionMandatory BIT = 0,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @QuestionHint NVARCHAR(MAX) = NULL,
 @EstimatedTime DECIMAL(18,2) = NULL,
 @AuditAnswersModel XML = NULL,
 @ImpactId UNIQUEIDENTIFIER = NULL,
 @PriorityId UNIQUEIDENTIFIER = NULL,
 @RoleIds NVARCHAR(MAX) = NULL,
 @CanEdit BIT = 0,
 @CanView BIT = 0,
 @CanAddAction BIT = 0,
 @NoPermission BIT = 0,
 @SelectedEmployees NVARCHAR(MAX) = NULL,
 @RiskId UNIQUEIDENTIFIER = NULL,
 @QuestionResponsiblePersonId UNIQUEIDENTIFIER = NULL,
 @DocumentsModel XML = NULL
 )
AS
 BEGIN
         SET NOCOUNT ON
         BEGIN TRY
		 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		 IF(@OperationsperformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		 IF(@AuditCategoryId = '00000000-0000-0000-0000-000000000000') SET @AuditCategoryId = NULL

		 IF(@QuestionName = '') SET @QuestionName = NULL

		  IF(@RoleIds = '') SET @RoleIds = NULL

		 IF(@SelectedEmployees = '') SET @SelectedEmployees = NULL
		
		 IF(@IsArchived IS NULL) SET @IsArchived = 0

		 DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditConduct WHERE Id = @AuditCategoryId)

		 IF(@ProjectId IS NULL) SET @ProjectId = (SELECT ProjectId FROM AuditCompliance 
		                                          WHERE Id = (SELECT [AuditComplianceId] FROM AuditCategory 
		                                                      WHERE Id = (SELECT [AuditCategoryId] FROM AuditQuestions 
															              WHERE Id = @QuestionId))
												 )

		 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		  
		IF (@HavePermission = '1')
		BEGIN

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		 DECLARE @IsLatest BIT = (CASE WHEN @QuestionId  IS NULL 
                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                      FROM [AuditQuestions] WHERE Id = @QuestionId ) = @TimeStamp
                                                         THEN 1 ELSE 0 END END)
          IF(@QuestionName IS NULL)
		  BEGIN
			    
				RAISERROR(50011,16, 2, 'Question')
			
		  END
		  ELSE IF(@QuestionTypeId IS NULL)
		  BEGIN

				RAISERROR(50011,16,2,'QuestionType')

		  END
          ELSE IF(@IsLatest = 1)
          BEGIN
		  
		  DECLARE @Currentdate DATETIME = GETDATE()

		  DECLARE @OldValue NVARCHAR(MAX) = NULL
		  DECLARE @NewValue NVARCHAR(MAX) = NULL
		  DECLARE @Inactive DATETIME  = NULL
		  DECLARE @AuditId UNIQUEIDENTIFIER = (SELECT AuditComplianceId FROM AuditCategory WHERE Id = @AuditCategoryId)
		  DECLARE @New BIT = 0
		  DECLARE @MaxOrderId INT = 0
		  
		  DECLARE @MaxOrderQuestionId INT = 0

          SELECT @MaxOrderId = ISNULL(Max([Order]),0) FROM AuditQuestions WHERE AuditCategoryId = @AuditCategoryId

		  SET @MaxOrderQuestionId = @MaxOrderId + 1
		  
		  IF(@QuestionId IS NULL)
		  BEGIN
		  
		  SET @QuestionId = NEWID()
		  SET @New = 1
			
        
				INSERT INTO AuditQuestions(
										   Id,
										   QuestionName,
										   AuditCategoryId,
										   QuestionDescription,
										   QuestionTypeId,
										   CreatedByUserId,
										   CreatedDateTime,
										   IsMandatory,
										   IsOriginalQuestionTypeScore,
										   CompanyId,
										   QuestionIdentity,
										   QuestionHint,
										   [Order],
										   [EstimatedTime],
										   ImpactId,
										   PriorityId,
										   RiskId,
										   QuestionResponsiblePersonId
				                          )
								    SELECT @QuestionId,
								           @QuestionName,
								    	   @AuditCategoryId,
								    	   @QuestionDescription,
								    	   @QuestionTypeId,
								    	   @OperationsPerformedBy,
								    	   GETDATE(),
								    	   @IsQuestionMandatory,
										   @IsOriginalQuestionTypeScore,
										   @CompanyId,
										   (SELECT 'Q-' + CAST(ISNULL(MAX(CAST(SUBSTRING(QuestionIdentity,3,len(QuestionIdentity)) AS INT)),0) + 1 AS NVARCHAR(20)) FROM AuditQuestions WHERE CompanyId = @CompanyId),
										   @QuestionHint,
										   @MaxOrderQuestionId,
										   CASE WHEN @EstimatedTime = 0 THEN NULL ELSE @EstimatedTime END,
										   @ImpactId,
										   @PriorityId,
										   @RiskId,
										   @QuestionResponsiblePersonId

				DECLARE @QuestionHistoryId UNIQUEIDENTIFIER = NEWID()
				DECLARE @QuestionAuditId UNIQUEIDENTIFIER

				SET @QuestionAuditId = (SELECT ACC.Id FROM AuditQuestions AQ INNER JOIN AuditCategory AC ON AC.Id = AQ.AuditCategoryId
                                                    INNER JOIN AuditCompliance ACC ON ACC.Id = AC.AuditComplianceId WHERE AQ.Id = @QuestionId)
            
				INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @QuestionHistoryId, @QuestionAuditId, NULL, @QuestionId, NULL, NULL, 'QuestionCreated', GETDATE(), @OperationsPerformedBy

				----Inserting into workspace
			--DECLARE @CanHide BIT = (CASE WHEN EXISTS(SELECT Id FROM RoleFeature WHERE FeatureId = '9E47F20C-73BF-43DE-B044-B8FB48CF3B33' AND 
			--								 RoleId IN (SELECT RoleId FROM [UserRole] WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL) AND InActiveDateTime IS NULL)
			--									THEN 1 ELSE 0 END)
			--DECLARE @WorkspaceId UNIQUEIDENTIFIER = NULL
			--DECLARE @DashboardPermission NVARCHAR(250) = (SELECT CASE WHEN (@WorkspaceId IS NULL OR @CanHide = 1 OR ((SELECT [dbo].[Ufn_GetWidgetPermissionBasedOnUserId]((SELECT EditRoles FROM DashboardConfiguration WHERE DashboardId = @WorkspaceId),@OperationsPerformedBy)) > 0))  AND @HavePermission = '1' THEN '1' ELSE '0' END)
			
			--IF (@DashboardPermission = '1')
			--BEGIN
			DECLARE @DashboardConfigurationId UNIQUEIDENTIFIER = NEWID()
			INSERT INTO [dbo].[AuditConductQuestionRoleConfiguration](
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
										[Users]
										)
							SELECT @DashboardConfigurationId,
									@QuestionId,
									@RoleIds,
									IIF(@RoleIds IS NOT NULL AND @SelectedEmployees IS NOT NULL,@CanView, NULL),
									IIF(@RoleIds IS NOT NULL AND @SelectedEmployees IS NOT NULL,@CanEdit, NULL),
									IIF(@RoleIds IS NOT NULL AND @SelectedEmployees IS NOT NULL,@CanAddAction, NULL),
									IIF(@RoleIds IS NOT NULL AND @SelectedEmployees IS NOT NULL,@NoPermission, NULL),
									@CompanyId,
									@Currentdate,
									@OperationsPerformedBy,
									@SelectedEmployees

			INSERT INTO [dbo].Workspace(
			                    [Id],
			                    [WorkspaceName],
								[IsCustomizedFor],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId
								)
			             SELECT @QuestionId,
			                    CONCAT('AuditQuestion-', CONVERT(NVARCHAR(MAX), @QuestionId)),
								'AuditQuestionAnalytics',
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			--END

		END
		ELSE
		BEGIN
						
						DECLARE @OldQuestionId UNIQUEIDENTIFIER = NULL
                        DECLARE @OldAuditCategoryId UNIQUEIDENTIFIER = NULL
                        DECLARE @OldQuestionTypeId UNIQUEIDENTIFIER = NULL
                        DECLARE @OldQuestionName NVARCHAR(800) = NULL
                        DECLARE @OldQuestionDescription NVARCHAR(800) = NULL
                        DECLARE @OldIsArchived BIT = 0
                        DECLARE @OldIsOriginalQuestionTypeScore BIT = 0
                        DECLARE @OldIsQuestionMandatory BIT = 0
						DECLARE @OldEstimatedTime DECIMAL(18,2) = NULL
                        DECLARE @OldTimeStamp TIMESTAMP = NULL
                        DECLARE @OldOperationsPerformedBy UNIQUEIDENTIFIER
                        DECLARE @OldQuestionHint NVARCHAR(MAX) = NULL
                        DECLARE @OldAuditAnswersModel XML = NULL
						DECLARE @OldOptions NVARCHAR(MAX) = NULL
						DECLARE @OldAnswer NVARCHAR(MAX) = NULL
						DECLARE @OldPriority UNIQUEIDENTIFIER = NULL
						DECLARE @OldImpact UNIQUEIDENTIFIER = NULL
						DECLARE @OldRisk UNIQUEIDENTIFIER = NULL
						DECLARE @OldQuestionResponsiblePersonId UNIQUEIDENTIFIER = NULL

				     SELECT @OldQuestionId                 = Id,
							@OldQuestionName               = QuestionName,
							@OldAuditCategoryId            = AuditCategoryId,
							@OldQuestionDescription        = QuestionDescription,
							@OldQuestionTypeId             = QuestionTypeId,   
							@OldIsQuestionMandatory        = IsMandatory,
							@OldIsOriginalQuestionTypeScore= IsOriginalQuestionTypeScore,
							@OldQuestionHint               = QuestionHint,
							@Inactive                      = InactiveDateTime,
							@OldEstimatedTime			   = EstimatedTime,
							@OldImpact					   = ImpactId,
							@OldPriority				   = PriorityId,
							@OldRisk					   = RiskId,
							@OldQuestionResponsiblePersonId= QuestionResponsiblePersonId
							FROM AuditQuestions WHERE Id = @QuestionId
					
					 SET @OldOptions = (SELECT ',' + ISNULL(QTO.QuestionTypeOptionName,MQT.MasterQuestionTypeName)
					                           + '(' + CONVERT(NVARCHAR(10),IIF(AQ.IsOriginalQuestionTypeScore = 1,QTO.QuestionTypeOptionScore,AA.Score)) + ')' 
			                        FROM AuditAnswers AA 
									JOIN AuditQuestions AQ ON AQ.Id = AA.AuditQuestionId AND AA.AuditQuestionId = @QuestionId AND AA.InactiveDateTime IS NULL
									JOIN QuestionTypeOptions QTO ON QTO.Id = AA.QuestionTypeOptionId
									JOIN QuestionTypes QT ON QTO.QuestionTypeId = QT.Id
                                    JOIN MasterQuestionType MQT ON MQT.Id = QT.MasterQuestionTypeId
									ORDER BY QTO.QuestionTypeOptionOrder
									FOR XML PATH('')
									)

					 SET @OldAnswer = (SELECT ',' + QTO.QuestionTypeOptionName FROM AuditAnswers AA 
										JOIN QuestionTypeOptions QTO ON AA.QuestionTypeOptionId = QTO.Id 
											WHERE AA.AuditQuestionId = @QuestionId AND AA.QuestionOptionResult = 1 AND AA.InactiveDateTime IS NULL
											ORDER BY QTO.QuestionTypeOptionOrder
											FOR XML PATH(''))

					 DECLARE @OldAuditId UNIQUEIDENTIFIER = (SELECT AuditComplianceId FROM AuditCategory WHERE Id = @OldAuditCategoryId)
                    
						UPDATE AuditQuestions SET Id                          = @QuestionId,
										          QuestionName                = @QuestionName,
										          AuditCategoryId             = @AuditCategoryId,
										          QuestionDescription         = @QuestionDescription,
										          QuestionTypeId              = @QuestionTypeId,
										          UpdatedByUserId             = @OperationsPerformedBy,
										          UpdatedDateTime             = GETDATE(),
										          IsMandatory                 = @IsQuestionMandatory,
										          IsOriginalQuestionTypeScore =	@IsOriginalQuestionTypeScore,
												  QuestionHint                = @QuestionHint,
										          InActiveDateTime			  =	CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
												  [EstimatedTime]			  = @EstimatedTime,
												  ImpactId					  = @ImpactId,
												  PriorityId				  = @PriorityId,
												  RiskId					  = @RiskId,
												  QuestionResponsiblePersonId = @QuestionResponsiblePersonId
												  WHERE Id = @QuestionId

						DECLARE @DashboardRecords INT = (SELECT COUNT(1) FROM AuditConductQuestionRoleConfiguration WHERE AuditQuestionId = @QuestionId AND CompanyId = @CompanyId)
			       
					IF(@DashboardRecords = 0)
					BEGIN

						INSERT INTO [dbo].AuditConductQuestionRoleConfiguration(
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
										[Users]
										)
							SELECT NEWID(),
									@QuestionId,
									@RoleIds,
									IIF(@RoleIds IS NOT NULL AND @SelectedEmployees IS NOT NULL,@CanView, NULL),
									IIF(@RoleIds IS NOT NULL AND @SelectedEmployees IS NOT NULL,@CanEdit, NULL),
									IIF(@RoleIds IS NOT NULL AND @SelectedEmployees IS NOT NULL,@CanAddAction, NULL),
									IIF(@RoleIds IS NOT NULL AND @SelectedEmployees IS NOT NULL,@NoPermission, NULL),
									@CompanyId,
									@Currentdate,
									@OperationsPerformedBy,
									@SelectedEmployees
					END

					ELSE
					BEGIN
						UPDATE [dbo].AuditConductQuestionRoleConfiguration SET Roles = @RoleIds,
																CanView = IIF(@RoleIds IS NOT NULL AND @SelectedEmployees IS NOT NULL,@CanView, NULL),
																CanEdit = IIF(@RoleIds IS NOT NULL AND @SelectedEmployees IS NOT NULL,@CanEdit, NULL),
																CanAddAction = IIF(@RoleIds IS NOT NULL AND @SelectedEmployees IS NOT NULL,@CanAddAction, NULL),
																NoPermission = IIF(@RoleIds IS NOT NULL AND @SelectedEmployees IS NOT NULL,@NoPermission, NULL),
																UpdatedDateTime = @Currentdate,
																UpdatedByUserId = @OperationsPerformedBy,
																Users = @SelectedEmployees
						WHERE AuditQuestionId = @QuestionId AND CompanyId = @CompanyId
                   END

						IF(@IsArchived = 1)
							INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @AuditId, NULL, @QuestionId, NULL, @QuestionName, 'QuestionDeleted', GETDATE(), @OperationsPerformedBy

						IF(@IsArchived = 1)
						BEGIN

							IF(EXISTS(SELECT Id FROM Folder WHERE Id = @QuestionId  AND InActiveDateTime IS NULL))
								BEGIN

								DECLARE @FolderTimeStamp TIMESTAMP = (SELECT [TimeStamp] FROM [Folder] WHERE Id = @QuestionId AND InActiveDateTime IS NULL)
								
								EXEC [USP_DeleteFolder] @FolderId = @QuestionId,@TimeStamp = @FolderTimeStamp,@OperationsPerformedBy = @OperationsPerformedBy,@IsToReturn = 1
			   
								END

						END
					
					SET @OldValue = (SELECT AuditCategoryName FROM AuditCategory WHERE Id = @OldAuditCategoryId)
					SET @NewValue = (SELECT AuditCategoryName FROM AuditCategory WHERE Id = @AuditCategoryId)

					IF(@OldAuditCategoryId <> @AuditCategoryId)
					EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldValue,
					@NewValue = @NewValue,@Description = 'QuestionMovedToCategory',@Field = 'AuditCategory',@QuestionId = @QuestionId,
					@AuditId = @AuditId,@ConductId = NULL

					SET @OldValue = (SELECT ImpactName FROM AuditImpact WHERE Id = @OldImpact)
					SET @NewValue = (SELECT ImpactName FROM AuditImpact WHERE Id = @ImpactId)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldValue,
					@NewValue = @NewValue,@Description = 'QuestionAuditImpactUpdated',@Field = 'AuditQuestion',@QuestionId = @QuestionId,
					@AuditId = @AuditId,@ConductId = NULL

					SET @OldValue = (SELECT PriorityName FROM AuditPriority WHERE Id = @OldPriority)
					SET @NewValue = (SELECT PriorityName FROM AuditPriority WHERE Id = @PriorityId)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldValue,
					@NewValue = @NewValue,@Description = 'QuestionAuditPriorityUpdated',@Field = 'AuditQuestion',@QuestionId = @QuestionId,
					@AuditId = @AuditId,@ConductId = NULL

					SET @OldValue = (SELECT RiskName FROM AuditRisk WHERE Id = @OldRisk)
					SET @NewValue = (SELECT RiskName FROM AuditRisk WHERE Id = @RiskId)

					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldValue,
					@NewValue = @NewValue,@Description = 'QuestionAuditRiskUpdated',@Field = 'AuditQuestion',@QuestionId = @QuestionId,
					@AuditId = @AuditId,@ConductId = NULL

					SET @OldValue = (SELECT QuestionTypeName FROM QuestionTypes WHERE Id = @OldQuestionTypeId)
					SET @NewValue = (SELECT QuestionTypeName FROM QuestionTypes WHERE Id = @QuestionTypeId)

					IF(@OldQuestionTypeId <> @QuestionTypeId)
					EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldValue,
					@NewValue = @NewValue,@Description = 'QuestionTypeUpdated',@Field = 'AuditCategory',@QuestionId = @QuestionId,
					@AuditId = @AuditId,@ConductId = NULL

					SET @OldValue = (SELECT AuditName FROM AuditCompliance WHERE Id = @OldAuditId)
					SET @NewValue = (SELECT AuditName FROM AuditCompliance WHERE Id = @AuditId)

					IF(@OldAuditId <> @AuditId)
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldValue,
					@NewValue = @NewValue,@Description = 'QuestionMovedToAudit',@Field = 'AuditCategory',@QuestionId = @QuestionId,
					@AuditId = @AuditId,@ConductId = NULL

					SET @OldValue = IIF(ISNULL(@OldIsQuestionMandatory,0) = 0,'unmarked','marked')
					SET @NewValue = IIF(ISNULL(@IsQuestionMandatory,0) = 0,'unmarked','marked')

					IF(@OldValue <> @NewValue)
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldValue,
					@NewValue = @NewValue,@Description = 'QuestionMandatoryMarked',@Field = 'AuditCategory',@QuestionId = @QuestionId,
					@AuditId = @AuditId,@ConductId = NULL

					SET @OldValue = IIF(ISNULL(@OldIsOriginalQuestionTypeScore,0) = 0,'unmarked','marked')
					SET @NewValue = IIF(ISNULL(@IsOriginalQuestionTypeScore,0) = 0,'unmarked','marked')

					IF(@OldValue <> @NewValue)
					IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldValue,
					@NewValue = @NewValue,@Description = 'QuestionOriginalScoreMarked',@Field = 'AuditCategory',@QuestionId = @QuestionId,
					@AuditId = @AuditId,@ConductId = NULL

					IF(ISNULL(@OldQuestionName,'') <> @QuestionName)
					EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldQuestionName,
					@NewValue = @QuestionName,@Description = 'QuestionTitleUpdated',@Field = 'AuditCategory',@QuestionId = @QuestionId,
					@AuditId = @AuditId,@ConductId = NULL

					IF(ISNULL(@OldQuestionDescription,'') <> @QuestionDescription)
					EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldQuestionDescription,
					@NewValue = @QuestionDescription,@Description = 'QuestionDescriptionUpdated',@Field = 'AuditCategory',@QuestionId = @QuestionId,
					@AuditId = @AuditId,@ConductId = NULL

					IF(ISNULL(@OldQuestionHint,'') <> @QuestionHint)
					EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldQuestionHint,
					@NewValue = @QuestionHint,@Description = 'QuestionHintUpdated',@Field = 'AuditCategory',@QuestionId = @QuestionId,
					@AuditId = @AuditId,@ConductId = NULL
					
					DECLARE @Temp5 UNIQUEIDENTIFIER = NEWID()

					IF(ISNULL(@OldQuestionResponsiblePersonId, @Temp5) <> ISNULL(@QuestionResponsiblePersonId, @Temp5))
					BEGIN

						DECLARE @OldName NVARCHAR(250), @NewName NVARCHAR(250)

						IF(@OldQuestionResponsiblePersonId IS NOT NULL) SET @OldName = (SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') FROM [User] U WHERE U.Id = @OldQuestionResponsiblePersonId)

						IF(@QuestionResponsiblePersonId IS NOT NULL) SET @NewName = (SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') FROM [User] U WHERE U.Id = @QuestionResponsiblePersonId)
						
						EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldName,
						@NewValue = @NewName,@Description = 'QuestionResponsiblePersonUpdated',@Field = 'AuditQuestion',@QuestionId = @QuestionId,
						@AuditId = @AuditId,@ConductId = NULL

					END

					IF((@OldEstimatedTime <> @EstimatedTime OR (@OldEstimatedTime IS NULL AND @EstimatedTime IS NOT NULL)))
					BEGIN
						IF(@OldEstimatedTime = 0.00)
						BEGIN
						  SET @OldValue = NULL
						END
					    ELSE IF(@OldEstimatedTime IS NOT NULL)
						BEGIN
						  SET @OldValue = CONVERT(NVARCHAR(50), @OldEstimatedTime) + 'h'
						END
						ELSE
						BEGIN
						  SET @OldValue = CONVERT(NVARCHAR(50), @OldEstimatedTime)
						END

						IF(@EstimatedTime = 0.00)
						BEGIN
						   SET @NewValue = NULL
						END
						ELSE IF(@EstimatedTime IS NOT NULL)
						BEGIN
						   SET @NewValue = CONVERT(NVARCHAR(50), @EstimatedTime) + 'h'
						END
						ELSE
						BEGIN
						   SET @NewValue = CONVERT(NVARCHAR(50), @EstimatedTime)
						END
					   
					    IF(@OldValue IS NOT NULL OR @NewValue IS NOT NULL)
						EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldValue,
						@NewValue = @NewValue,@Description = 'QuestionEstimateUpdated',@Field = 'AuditCategory',@QuestionId = @QuestionId,
						@AuditId = @AuditId,@ConductId = NULL
					
					END

		END 
			
			CREATE TABLE #Temp(
								QuestionOptionId UNIQUEIDENTIFIER,
								QuestionTypeOptionId UNIQUEIDENTIFIER,
								QuestionOptionScore FLOAT,
								QuestionOptionDate DATETIME,
								QuestionOptionTime DATETIME,
								QuestionOptionNumeric FLOAT,
								QuestionOptionBoolean BIT,
								QuestionOptionResult BIT,
								QuestionOptionText NVARCHAR(250)
			                  )

			CREATE TABLE #DTemp (
								DocumentId UNIQUEIDENTIFIER,
								DocumentName NVARCHAR(MAX),
								DocumentOrder INT,
								IsDocumentMandatory BIT,
								AuditQUestionId UNIQUEIDENTIFIER
								)
			
			INSERT INTO #Temp (
							   QuestionOptionId
							  ,QuestionTypeOptionId
							  ,QuestionOptionScore    
							  ,QuestionOptionDate
							  ,QuestionOptionTime
							  ,QuestionOptionNumeric
							  ,QuestionOptionBoolean
							  ,QuestionOptionText
							  ,QuestionOptionResult
			                  )
					   SELECT x.y.value('(QuestionOptionId/text())[1]','uniqueidentifier'),
					          x.y.value('(QuestionTypeOptionId/text())[1]','uniqueidentifier'),
					   	      x.y.value('(QuestionOptionScore)[1]','float'),
					   	      x.y.value('(QuestionOptionDate/text())[1]','datetime'),
					   	      x.y.value('(QuestionOptionTime/text())[1]','datetime'),
					   	      x.y.value('(QuestionOptionNumeric/text())[1]','float'),
					   	      x.y.value('(QuestionOptionBoolean)[1]','bit'),
					   	      x.y.value('(QuestionOptionText/text())[1]','nvarchar(250)'),
							  ISNULL(x.y.value('(QuestionOptionResult)[1]','bit'),0)
					          FROM @AuditAnswersModel.nodes('/GenericListOfAuditQuestionOptions/ListItems/AuditQuestionOptions') AS x(y)

							  INSERT INTO #DTemp (
											DocumentId,
											DocumentName,
											DocumentOrder,
											IsDocumentMandatory,
											AuditQUestionId
										) SELECT x.y.value('(DocumentId/text())[1]','uniqueidentifier'),
					   					  x.y.value('(DocumentName/text())[1]','nvarchar(max)'),
					   					  x.y.value('(DocumentOrder)[1]','int'),
					   					  x.y.value('(IsDocumentMandatory)[1]','bit'),
										  @QuestionId
										  FROM @DocumentsModel.nodes('/GenericListOfDocumentModel/ListItems/DocumentModel') AS x(y)

					UPDATE AuditQuestionDocuments SET InactiveDateTime = GETDATE()
			                       ,UpdatedDateTime = GETDATE()
								   ,UpdatedByUserId = @OperationsPerformedBy 
								    WHERE AuditQuestionId = @QuestionId 
								    AND Id NOT IN (SELECT ISNULL(DocumentId,NEWID()) FROM #DTemp)
								    AND InactiveDateTime IS NULL

									UPDATE AuditQuestionDocuments SET DocumentName = T.DocumentName,
																	  DocumentOrder = T.DocumentOrder,
																	  IsDocumentMandatory = T.IsDocumentMandatory,
																	  UpdatedByUserId = @OperationsPerformedBy,
																	  UpdatedDateTime = GETDATE()
																		FROM #DTemp T 
																		JOIN AuditQuestionDocuments AA ON AA.Id = T.DocumentId AND AA.AuditQuestionId = @QuestionId AND AA.InActiveDateTime IS NULL
								INSERT INTO AuditQuestionDocuments (
																	Id,
																	DocumentName,
																	DocumentOrder,
																	IsDocumentMandatory,
																	AuditQuestionId,
																	CreatedByUserId,
																	CreatedDateTime
																	)
																	SELECT NEWID(),
																	T.DocumentName,
																	T.DocumentOrder,
																	T.IsDocumentMandatory,
																	@QuestionId,
																	 @OperationsPerformedBy,
																	 GETDATE()
																	 FROM #DTemp T
																	 WHERE T.DocumentId IS NULL


			UPDATE AuditAnswers SET InactiveDateTime = GETDATE()
			                       ,UpdatedDateTime = GETDATE()
								   ,UpdatedByUserId = @OperationsPerformedBy 
								    WHERE AuditQuestionId = @QuestionId 
								    AND Id NOT IN (SELECT ISNULL(QuestionOptionId,NEWID()) FROM #Temp)
								    AND InactiveDateTime IS NULL
			
			UPDATE AuditAnswers SET QuestionTypeOptionId   = T.QuestionTypeOptionId,
			                        Score                  = T.QuestionOptionScore, 
			                        QuestionOptionDate     = T.QuestionOptionDate,
			                        QuestionOptionTime     = T.QuestionOptionTime,
									QuestionOptionNumeric  = T.QuestionOptionNumeric,
									QuestionOptionBoolean  = T.QuestionOptionBoolean,
									QuestionOptionText     = T.QuestionOptionText,
									UpdatedByUserId        = @OperationsPerformedBy,
									UpdatedDateTime        = GETDATE(),
									InactiveDateTime       = NULL,
									QuestionOptionResult   = T.QuestionOptionResult
									FROM #Temp T
									JOIN AuditAnswers AA ON AA.Id = T.QuestionOptionId AND AA.AuditQuestionId = @QuestionId AND AA.InactiveDateTime IS NULL

			INSERT INTO AuditAnswers(
									 Id,
									 AuditQuestionId,
									 AuditId,
									 QuestionTypeOptionId,
									 Score,
									 QuestionOptionResult,
									 QuestionOptionDate,
									 QuestionOptionTime,
									 QuestionOptionNumeric,
									 QuestionOptionBoolean,
									 QuestionOptionText,
									 CreatedByUserId,
									 CreatedDateTime
			                        )
							  SELECT NEWID(),
							         @QuestionId,
									 (SELECT AuditComplianceId FROM AuditCategory WHERE Id = @AuditCategoryId),
				                     T.QuestionTypeOptionId,
				                     T.QuestionOptionScore,
									 T.QuestionOptionResult,
				                     T.QuestionOptionDate,
				                     T.QuestionOptionTime,
				                     T.QuestionOptionNumeric,
				                     T.QuestionOptionBoolean,
				                     T.QuestionOptionText,
									 @OperationsPerformedBy,
									 GETDATE()
				                     FROM #Temp T
                                     WHERE T.QuestionOptionId IS NULL
		
		IF(@New = 0 AND @IsArchived = 0)
		BEGIN
		SET @NewValue = (SELECT ',' + ISNULL(QTO.QuestionTypeOptionName,MQT.MasterQuestionTypeName)
					                           + '(' + CONVERT(NVARCHAR(10),IIF(AQ.IsOriginalQuestionTypeScore = 1,QTO.QuestionTypeOptionScore,AA.Score)) + ')' 
			                        FROM AuditAnswers AA 
									JOIN AuditQuestions AQ ON AQ.Id = AA.AuditQuestionId AND AA.AuditQuestionId = @QuestionId AND AA.InactiveDateTime IS NULL
									JOIN QuestionTypeOptions QTO ON QTO.Id = AA.QuestionTypeOptionId
									JOIN QuestionTypes QT ON QTO.QuestionTypeId = QT.Id
                                    JOIN MasterQuestionType MQT ON MQT.Id = QT.MasterQuestionTypeId
                                    ORDER BY QTO.QuestionTypeOptionOrder
									FOR XML PATH('')
									)
		
		SET @OldValue = SUBSTRING(@OldOptions,2,LEN(@OldOptions))
		SET @NewValue = SUBSTRING(@NewValue,2,LEN(@NewValue))

		IF(ISNULL(@OldValue,'') <> ISNULL(@NewValue,''))
		EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldValue,
		@NewValue = @NewValue,@Description = 'QuestionOptionScoreUpdated',@Field = 'QuestionOptions',@QuestionId = @QuestionId,
		@AuditId = @AuditId,@ConductId = NULL

		SET @NewValue = (SELECT ',' + QTO.QuestionTypeOptionName FROM AuditAnswers AA 
							JOIN QuestionTypeOptions QTO ON AA.QuestionTypeOptionId = QTO.Id 
							WHERE AA.AuditQuestionId = @QuestionId AND AA.QuestionOptionResult = 1 AND AA.InactiveDateTime IS NULL
							ORDER BY QTO.QuestionTypeOptionOrder
							FOR XML PATH(''))

		SET @OldValue = SUBSTRING(@OldAnswer,2,LEN(@OldAnswer))
		DECLARE @TEMP1 NVARCHAR(MAX)
		SET @TEMP1 = SUBSTRING(@NewValue,2,LEN(@NewValue))

		IF(ISNULL(@OldValue,'') <> ISNULL(@TEMP1,''))
		EXEC [dbo].[USP_UpsertAuditQuestionHistory] @OperationsPerformedBy = @OperationsPerformedBy,@OldValue = @OldValue,
		@NewValue = @TEMP1,@Description = 'QuestionOptionResultUpdated',@Field = 'QuestionOptions',@QuestionId = @QuestionId,
		@AuditId = @AuditId,@ConductId = NULL
		END
		SELECT Id  FROM [dbo].[AuditQuestions] WHERE Id = @QuestionId

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