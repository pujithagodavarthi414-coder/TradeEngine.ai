CREATE PROCEDURE [dbo].[USP_UpsertAuditComplianceSchedulingDetails]
(
	@AuditComplianceId UNIQUEIDENTIFIER,
	@CronExpressionId UNIQUEIDENTIFIER,
	@SchedulingDetails NVARCHAR(MAX),
	@SelectedQuestions NVARCHAR(MAX),
	@IsIncludeAllQuestions BIT,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

 SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   DECLARE @HavePermission NVARCHAR(250)  = '1'-- (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
	
			CREATE TABLE #AuditScheduleDetails
			(
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

			CREATE TABLE #AuditSelectedQuestions
			(
				AuditId UNIQUEIDENTIFIER,
				QuestionId UNIQUEIDENTIFIER,
				AuditCategoryId UNIQUEIDENTIFIER
			)


			IF(@SchedulingDetails IS NOT NULL)
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

			IF(@IsIncludeAllQuestions = 1)
			BEGIN
				INSERT INTO #AuditSelectedQuestions
				SELECT @AuditComplianceId, AQ.Id, AQ.AuditCategoryId
                FROM AuditQuestions AQ INNER JOIN AuditCategory ACC ON ACC.Id = AQ.AuditCategoryId AND ACC.InActiveDateTime IS NULL AND AQ.InActiveDateTime IS NULL
                WHERE ACC.AuditComplianceId = @AuditComplianceId
			END
			ELSE
			BEGIN
				IF(@SelectedQuestions IS NOT NULL AND @SelectedQuestions != 'NULL')
				BEGIN
					
					INSERT INTO #AuditSelectedQuestions
					SELECT *FROM OPENJSON(@SelectedQuestions)
					WITH (
						AuditId UNIQUEIDENTIFIER,
						QuestionId UNIQUEIDENTIFIER,
						AuditCategoryId UNIQUEIDENTIFIER
					)
				END
			END
			DECLARE @NEWID UNIQUEIDENTIFIER = NEWID()
			DECLARE @OldScheduleEndDate DATETIME, @ScheduleEndDate DATETIME, @OldScheduleStartDate DATETIME, @ScheduleStartDate DATETIME

			selecT @OldScheduleEndDate = ConductEndDate,@OldScheduleStartDate = ConductStartDate from AuditComplianceSchedulingDetails where AuditComplianceId = @AuditComplianceId and CronExpressionId in (select CronExpressionId from #AuditScheduleDetails)
			select  @ScheduleStartDate = ConductStartDate, @ScheduleEndDate = ConductEndDate from #AuditScheduleDetails
							
			IF(ISNULL(@OldScheduleEndDate,'') <> ISNULL(@ScheduleEndDate,''))
			BEGIN
	
				DECLARE @Temp NVARCHAR(300)
				DECLARE @Temp2 NVARCHAR(300)

				IF(@OldScheduleEndDate IS NULL)
					SET @Temp2 = NULL

				IF(@OldScheduleEndDate IS NOT NULL)
					SET @Temp2 = CONVERT(NVARCHAR(250),@OldScheduleEndDate,107)

				IF(@ScheduleEndDate IS NULL)
					SET @Temp = NULL

				IF(@ScheduleEndDate IS NOT NULL)
					SET @Temp = CONVERT(NVARCHAR(250),@ScheduleEndDate,107)

				IF(@OldScheduleEndDate <>  @ScheduleEndDate)
				INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
					SELECT NEWID(), @AuditComplianceId, NULL, NULL, @Temp2, @Temp, 'AuditScheduleEndDateUpdated', GETDATE(), @OperationsPerformedBy
			END


			UPDATE ACSD 
			SET ACSD.InActiveDateTime = (CASE WHEN ASD.IsArchived = 1 THEN GETUTCDATE() ELSE NULL END),
				ACSD.ConductStartDate = ASD.ConductStartDate,
				ACSD.ConductEndDate = ASD.ConductEndDate,
				ACSD.SpanInYears = ASD.SpanInYears,
				ACSD.SpanInMonths = ASD.SpanInMonths,
				ACSD.SpanInDays = ASD.SpanInDays,
				ACSD.IsPaused = ASD.IsPaused,
				ACSD.UpdatedDateTime = GETUTCDATE(),
				ACSD.UpdatedByUserId = @OperationsPerformedBy,
				ACSD.ResponsibleUserId = ASD.ResponsibleUserId
			FROM #AuditScheduleDetails ASD
			INNER JOIN [AuditComplianceSchedulingDetails]  ACSD ON ASD.CronExpressionId = ACSD.CronExpressionId  AND ACSD.AuditComplianceId = @AuditComplianceId

			IF(@@ROWCOUNT > 0 )
			BEGIN
				SELECT @NEWID = ACSD.Id
				FROM #AuditScheduleDetails ASD
				INNER JOIN [AuditComplianceSchedulingDetails]  ACSD ON ASD.CronExpressionId = ACSD.CronExpressionId  AND ACSD.AuditComplianceId = @AuditComplianceId
			END
			

			INSERT INTO [AuditComplianceSchedulingDetails](Id,AuditComplianceId,CronExpressionId,ConductStartDate,ConductEndDate,SpanInYears,SpanInMonths,SpanInDays,CreatedDateTime,CreatedByUserId,ResponsibleUserId)
			SELECT @NEWID, @AuditComplianceId, @CronExpressionId, ASD.ConductStartDate, ASD.ConductEndDate, ASD.SpanInYears, ASD.SpanInMonths, ASD.SpanInDays, GETUTCDATE(), @OperationsPerformedBy, ASD.ResponsibleUserId  FROM #AuditScheduleDetails ASD
			LEFT JOIN [AuditComplianceSchedulingDetails]  ACSD ON COALESCE(ASD.CronExpressionId, @CronExpressionId) = ACSD.CronExpressionId AND ACSD.AuditComplianceId = @AuditComplianceId 
			WHERE ACSD.ID IS NULL

			INSERT INTO [dbo].[AuditSelectedQuestion](Id, [AuditComplianceId], [AuditSchedulingDetailsId], AuditQuestionId, CreatedDateTime, CreatedByUserId)
			SELECT NEWID(), @AuditComplianceId, @NEWID, QuestionId, GETUTCDATE(), @OperationsPerformedBy   FROM #AuditSelectedQuestions T
			LEFT JOIN AuditSelectedQuestion ASQ ON ASQ.AuditComplianceId = @AuditComplianceId AND ASQ.AuditQuestionId = T.QuestionId AND InActiveDateTime IS NULL
			LEFT JOIN AuditComplianceSchedulingDetails ACSD ON ACSD.AuditComplianceId = ASQ.AuditComplianceId AND ASQ.AuditSchedulingDetailsId = ACSD.Id AND ASQ.AuditComplianceId = @AuditComplianceId
			WHERE ASQ.ID IS NULL

			UPDATE ASQ SET InActiveDateTime = GETUTCDATE() FROM AuditSelectedQuestion ASQ
			INNER JOIN AuditComplianceSchedulingDetails ACSD ON ACSD.AuditComplianceId = ASQ.AuditComplianceId AND ASQ.AuditSchedulingDetailsId = ACSD.Id AND ASQ.AuditComplianceId = @AuditComplianceId
			LEFT JOIN #AuditSelectedQuestions T ON  ASQ.AuditQuestionId = T.QuestionId
			WHERE T.QuestionId IS NULL AND ASQ.InActiveDateTime IS NULL


			--INSERT INTO [dbo].[AuditSelectedQuestion](Id, [AuditComplianceId], [AuditSchedulingDetailsId], AuditQuestionId, CreatedDateTime, CreatedByUserId)
			--SELECT NEWID(), @AuditComplianceId, @NEWID, QuestionId, GETUTCDATE(), @OperationsPerformedBy   FROM #AuditSelectedQuestions T
			--LEFT JOIN AuditSelectedQuestion ASQ ON ASQ.AuditComplianceId = @AuditComplianceId AND ASQ.AuditQuestionId = T.QuestionId AND ASQ.AuditSchedulingDetailsId = @NEWID
			--WHERE ASQ.ID IS NULL

			SELECT @NEWID Id
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