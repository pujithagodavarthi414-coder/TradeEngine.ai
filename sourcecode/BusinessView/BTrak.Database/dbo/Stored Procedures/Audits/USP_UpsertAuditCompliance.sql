CREATE PROCEDURE [dbo].[USP_UpsertAuditCompliance]
(
 @AuditComplianceId UNIQUEIDENTIFIER = NULL,
 @AuditComplianceName NVARCHAR(250) = NULL,
 @IsArchived BIT = 0,
 @TimeStamp TIMESTAMP = NULL,
 @AuditDescription NVARCHAR(800) = NULL,
 @IsRAG BIT = NULL,
 @InboundPercent FLOAT = NULL,
 @OutboundPercent FLOAT = NULL,
 @RecurringAudit BIT = NULL,
 @CanLogTime BIT = NULL,
 @CronExpression NVARCHAR(MAX) = NULL,
 @ScheduleEndDate DATETIME = NULL,
 @IsPaused BIT = NULL,
 @ConductEndDate DATETIME = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @SchedulingDetails NVARCHAR(MAX),
 @ResponsibleUserId UNIQUEIDENTIFIER = NULL,
 @ParentAuditId UNIQUEIDENTIFIER = NULL,
 @ProjectId UNIQUEIDENTIFIER = NULL,
 @EnableQuestionLevelWorkFlow BIT = NULL,
 @EnableWorkFlowForAudit BIT = NULL,
 @EnableWorkFlowForAuditConduct BIT = NULL
)
AS
 BEGIN
         SET NOCOUNT ON
         BEGIN TRY
		 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		 IF(@OperationsperformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		 IF(@AuditComplianceId = '00000000-0000-0000-0000-000000000000') SET @AuditComplianceId = NULL
		 
		 IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL

		 IF(@AuditComplianceName = '') SET @AuditComplianceName = NULL
		
		 IF(@IsArchived IS NULL) SET @IsArchived = 0

		 IF(@RecurringAudit IS NULL) SET @RecurringAudit = 0

		 IF(@IsPaused IS NULL) SET @IsPaused = 0

		 IF(@CanLogTime IS NULL) SET @CanLogTime = 0
		
		 CREATE TABLE #AuditScheduleDetails
			(
				Id int IDENTITY(1,1),
				CronExpressionId UNIQUEIDENTIFIER,
				JobId int,
				CronExpression varchar(max),
				ConductStartDate datetime,
				ConductEndDate datetime,
				SpanInYears int,
				SpanInMonths int,
				SpanInDays int,
				IsPaused bit,
				IsArchived bit,
				ResponsibleUserId UNIQUEIDENTIFIER
			)

			IF(@SchedulingDetails IS NOT NULL AND @SchedulingDetails != 'null')
			BEGIN
				INSERT INTO #AuditScheduleDetails
				SELECT *FROM OPENJSON(@SchedulingDetails)
				WITH (CronExpressionId UNIQUEIDENTIFIER,
					JobId int,
					CronExpression varchar(max),
					ConductStartDate datetime,
					ConductEndDate datetime,
					SpanInYears int,
					SpanInMonths int,
					SpanInDays int,
					IsPaused bit,
					IsArchived bit,
					ResponsibleUserId UNIQUEIDENTIFIER)
			END

		 DECLARE @OldCronExpression NVARCHAR(MAX) = NULL
		 DECLARE @OldScheduleEndDate DATETIME = NULL
		 DECLARE @OldIsPaused BIT = 0
		 DECLARE @OldConductEndDate DATETIME = NULL

		 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		  
		IF (@HavePermission = '1')
		BEGIN

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		 DECLARE @CustomAuditFolderId UNIQUEIDENTIFIER
			DECLARE @DeafultAuditFolderId UNIQUEIDENTIFIER

		

		 DECLARE @AuditComplianceNameCount INT = (SELECT COUNT(1) FROM AuditCompliance WHERE AuditName = @AuditComplianceName AND (@AuditComplianceId IS NULL OR Id <> @AuditComplianceId) AND CompanyId = @CompanyId AND ProjectId = @ProjectId)

		 DECLARE @AuditIdCount INT = (SELECT COUNT(1) FROM AuditCompliance WHERE Id = @AuditComplianceId)

		 DECLARE @IsLatest BIT = 1 --(CASE WHEN @AuditComplianceId  IS NULL 
                                      --THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                      --FROM [AuditCompliance] WHERE Id = @AuditComplianceId ) = @TimeStamp
                                                         --THEN 1 ELSE 0 END END)
          IF(@AuditComplianceName IS NULL)
		  BEGIN
			    
				RAISERROR(50011,16, 2, 'AuditName')
			
		  END
		  ELSE IF(@AuditComplianceNameCount >0)
		  BEGIN

				RAISERROR(50001,16, 2, 'AuditName')

		  END
		  ELSE IF(@AuditIdCount = 0 AND @AuditComplianceId IS NOT NULL)
		  BEGIN

				RAISERROR(50002,16,2,'Audit')

		  END
		  ELSE IF(@ProjectId IS NULL)
		  BEGIN

				RAISERROR(50011,16,1,'Project')

		  END
         ELSE IF(@IsLatest = 1)
         BEGIN
			
				IF(@ParentAuditId IS NULL)
				BEGIN
	
					SELECT @DeafultAuditFolderId = Id 
					FROM AuditFolder 
					WHERE AuditFolderName = 'Audits'
					      AND InActiveDateTime IS NULL 
						  AND CompanyId = @CompanyId 
						  AND ProjectId = @ProjectId
						  AND ParentAuditFolderId IS NULL

					IF(@DeafultAuditFolderId IS NULL)
					BEGIN

						SET @CustomAuditFolderId = NEWID()

						INSERT INTO [dbo].[AuditFolder](
												[Id],
												[AuditFolderName],
												[Description],
												CompanyId,
												[ProjectId],
												[CreatedDateTime],
												[CreatedByUserId]                   
											)
										 SELECT @CustomAuditFolderId,
												'Audits',
												'Root Folder',
												@CompanyId,
												@ProjectId,
												GETDATE(),
											@OperationsPerformedBy

							SET @ParentAuditId = @CustomAuditFolderId

				END
				ELSE
				BEGIN 
			
					SET @ParentAuditId = @DeafultAuditFolderId

				END
			
			END

		 DECLARE @Currentdate DATETIME = GETDATE()
		 DECLARE @OldValue NVARCHAR(MAX) = NULL
		 DECLARE @NewValue NVARCHAR(MAX) = NULL

		 IF(@AuditComplianceId IS NULL)
		 BEGIN

		 SET @AuditComplianceId = NEWID()

		 INSERT INTO [dbo].[AuditCompliance](
                     [Id],
                     [CompanyId],
                     [AuditName],
                     [InActiveDateTime],
                     [CreatedDateTime],
                     [CreatedByUserId],
					 [UpdatedDateTime],
					 [Description],
					 [IsRAG],
					 [InboundPercent],
					 [OutboundPercent],
					 [ResposibleUserId],
					 [CanLogTime],
					 [EnableQuestionLevelWorkFlow],
					 [EnableWorkFlowForAudit],
					 [EnableWorkFlowForAuditConduct],
					 AuditFolderId,
					 ProjectId
					 )
              SELECT @AuditComplianceId,
                     @CompanyId,
                     @AuditComplianceName,
                     CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                     @Currentdate,
                     @OperationsPerformedBy,
					 @Currentdate,
		  	   	     @AuditDescription,
		  	   	     @IsRAG,
		  	   	     @InboundPercent,
		  	   	     @OutboundPercent,
					 @ResponsibleUserId,
					 @CanLogTime,
					 @EnableQuestionLevelWorkFlow,
					 @EnableWorkFlowForAudit,
					 @EnableWorkFlowForAuditConduct,
					 @ParentAuditId,
					 @ProjectId
		
			  INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @AuditComplianceId, NULL, NULL, NULL, @AuditComplianceName, 'AuditCreated', GETDATE(), @OperationsPerformedBy
		      
		END
		ELSE
		BEGIN

						DECLARE @OldAuditName NVARCHAR(800) = NULL
                        DECLARE @OldAuditDescription NVARCHAR(800) = NULL
                        DECLARE @OldAuditArchived DATETIME = NULL
                        DECLARE @OldIsRAG BIT = NULL
                        DECLARE @OldCanLogTime BIT = NULL
                        DECLARE @OldInboundPercent FLOAT = NULL
                        DECLARE @OldOutboundPercent FLOAT = NULL
						DECLARE @OldResponsibleUser UNIQUEIDENTIFIER = NULL
						DECLARE @IsDeleted BIT

						SELECT @IsDeleted = IIF(InActiveDateTime IS NOT NULL,1,0) FROM AuditCompliance WHERE Id = @AuditComplianceId

						SELECT @OldAuditName = AuditName,
							   @OldAuditDescription = [Description],
							   @OldAuditArchived = InActiveDateTime,
							   @OldIsRAG = IsRAG,
							   @OldCanLogTime = CanLogTime,
							   @OldInboundPercent = InboundPercent,
							   @OldOutboundPercent = OutboundPercent,
							   @OldResponsibleUser = ResposibleUserId
							   FROM AuditCompliance WHERE Id = @AuditComplianceId

						UPDATE [AuditCompliance]
					     SET [CompanyId] = @CompanyId,
						     [AuditName] = @AuditComplianceName,
							 [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							 [UpdatedDateTime] = @Currentdate,
							 [UpdatedByUserId] = @OperationsPerformedBy,
							 [Description] = @AuditDescription,
							 [IsRAG] = @IsRAG,
							 [InboundPercent] = @InboundPercent,
							 [OutboundPercent] = @OutboundPercent,
							 ResposibleUserId = @ResponsibleUserId,
							 [CanLogTime] = @CanLogTime,
							 [ProjectId] = @ProjectId,
							 AuditFolderId = @ParentAuditId,
							 [EnableQuestionLevelWorkFlow] = @EnableQuestionLevelWorkFlow,
							 [EnableWorkFlowForAudit] = @EnableWorkFlowForAudit,
							 [EnableWorkFlowForAuditConduct] = @EnableWorkFlowForAuditConduct
							 WHERE Id = @AuditComplianceId

						IF(@IsDeleted = ~@IsArchived)
						BEGIN

							SELECT @ParentAuditId = AuditFolderId FROM AuditCompliance WHERE Id = @AuditComplianceId

							IF((SELECT Id FROM AuditFolder WHERE Id = @ParentAuditId AND InActiveDateTime IS NULL) = @ParentAuditId)
							BEGIN

								UPDATE [AuditCompliance] SET AuditFolderId = @ParentAuditId WHERE Id = @AuditComplianceId

							END
							ELSE
							BEGIN

								UPDATE [AuditCompliance] SET AuditFolderId = (SELECT Id FROM AuditFolder WHERE AuditFolderName = 'Audits' AND InActiveDateTime IS NULL AND CompanyId = @CompanyId AND ParentAuditFolderId IS NULL) WHERE Id = @AuditComplianceId

							END

						END

						IF(ISNULL(@OldAuditName,'') <> @AuditComplianceName)
						 INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @AuditComplianceId, NULL, NULL, @OldAuditName, @AuditComplianceName, 'AuditNameUpdated', GETDATE(), @OperationsPerformedBy

						IF(ISNULL(@OldAuditDescription,'') <> @AuditDescription)
						 INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @AuditComplianceId, NULL, NULL, @OldAuditDescription, @AuditDescription, 'AuditDescriptionUpdated', GETDATE(), @OperationsPerformedBy

						IF(ISNULL(@OldResponsibleUser,'') <> @ResponsibleUserId)
						BEGIN
						DECLARE @OldResponsibleUserName NVARCHAR(50) = ISNULL((SELECT FirstName+' ' + ISNULL(SurName,'') from [User] WHERE Id = @OldResponsibleUser),'')
						DECLARE @ResponsibleUserName NVARCHAR(50) = (SELECT FirstName+' ' + ISNULL(SurName,'') from [User] WHERE Id = @ResponsibleUserId)
						 INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @AuditComplianceId, NULL, NULL, @OldResponsibleUserName, @ResponsibleUserName, 'AuditUserUpdated', GETDATE(), @OperationsPerformedBy
						END
	
						SET @OldValue = IIF(ISNULL(@OldIsRAG,0) = 0,'unmarked','marked')
						SET @NewValue = IIF(ISNULL(@IsRAG,0) = 0,'unmarked','marked')

						IF(@OldValue <> @NewValue)
							IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
							INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
								SELECT NEWID(), @AuditComplianceId, NULL, NULL, @OldValue, @NewValue, 'AuditRAGUpdated', GETDATE(), @OperationsPerformedBy

						SET @OldValue = IIF(ISNULL(@OldCanLogTime,0) = 0,'unmarked','marked')
						SET @NewValue = IIF(ISNULL(@CanLogTime,0) = 0,'unmarked','marked')

						IF(@OldValue <> @NewValue)
							IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
							INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
								SELECT NEWID(), @AuditComplianceId, NULL, NULL, @OldValue, @NewValue, 'AuditLogTimeUpdated', GETDATE(), @OperationsPerformedBy

						IF((@OldInboundPercent IS NULL AND @InboundPercent IS NOT NULL) OR (@OldInboundPercent <> @InboundPercent) OR (@OldInboundPercent IS NOT NULL AND @InboundPercent IS NULL))
						INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @AuditComplianceId, NULL, NULL, @OldInboundPercent, @InboundPercent, 'AuditInboundUpated', GETDATE(), @OperationsPerformedBy

						IF((@OldOutboundPercent IS NULL AND @OutboundPercent IS NOT NULL) OR (@OldOutboundPercent <> @OutboundPercent) OR (@OldOutboundPercent IS NOT NULL AND @OutboundPercent IS NULL))
						INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @AuditComplianceId, NULL, NULL, @OldOutboundPercent, @OutboundPercent, 'AuditOutboundUpated', GETDATE(), @OperationsPerformedBy

						IF(@IsArchived = 1)
						 INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @AuditComplianceId, NULL, NULL, NULL, @AuditComplianceName, 'AuditArchived', GETDATE(), @OperationsPerformedBy

						IF(@IsArchived = 0 AND @OldAuditArchived IS NOT NULL)
						 INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @AuditComplianceId, NULL, NULL, NULL, @AuditComplianceName, 'AuditUnArchived', GETDATE(), @OperationsPerformedBy

						IF(@IsArchived = 0)
						BEGIN
							

							DECLARE @MAX INT, @COUNTER INT = 1, @IsArchivedSchedule bit, @CronExpressionId uniqueidentifier

							SELECT @MAX = COUNT(*) FROM #AuditScheduleDetails
							WHILE(@COUNTER <= @MAX)
							BEGIN
								SELECT @CronExpression = CronExpression, @ScheduleEndDate = ConductEndDate, @IsPaused = IsPaused, @IsArchivedSchedule = IsArchived, @CronExpressionId = CronExpressionId , @ResponsibleUserId = ResponsibleUserId FROM #AuditScheduleDetails WHERE ID = @COUNTER

								SELECT @OldCronExpression       = CronExpression,
								@OldScheduleEndDate				= EndDate,
								@OldIsPaused					= IsPaused,
								@OldConductEndDate				= ConductEndDate
								--@IsArchivedSchedule				= case when InActiveDateTime is null then 0 else 1 end
								FROM CronExpression WHERE CustomWidgetId = @AuditComplianceId and id=@CronExpressionId
								
								IF(ISNULL(@OldCronExpression,'') <> ISNULL(@CronExpression,'') AND @CronExpression IS NOT NULL)
								INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
									SELECT NEWID(), @AuditComplianceId, NULL, NULL, @OldCronExpression, @CronExpression, 'AuditCronUpdated', GETDATE(), @OperationsPerformedBy

								IF(@IsArchivedSchedule = 1)
								INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
									SELECT NEWID(), @AuditComplianceId, NULL, NULL, @OldCronExpression, NULL, 'AuditCronRemoved', GETDATE(), @OperationsPerformedBy

								SET @OldValue = IIF(ISNULL(@OldIsPaused,0) = 0,'unmarked','marked')
								SET @NewValue = IIF(ISNULL(@IsPaused,0) = 0,'unmarked','marked')

								IF(@OldValue <> @NewValue)
								IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
								INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
									SELECT NEWID(), @AuditComplianceId, NULL, NULL, @OldValue, @NewValue, 'AuditPauseUpdated', GETDATE(), @OperationsPerformedBy
								
								SET @COUNTER = @COUNTER + 1
							END

						END

			END
		
			SELECT Id  FROM [dbo].[AuditCompliance] WHERE Id = @AuditComplianceId

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