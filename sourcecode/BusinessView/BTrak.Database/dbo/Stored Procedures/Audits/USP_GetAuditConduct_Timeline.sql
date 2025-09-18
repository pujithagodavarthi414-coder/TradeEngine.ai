CREATE PROCEDURE [dbo].[USP_GetAuditConduct_Timeline]
(
	@StartDate Datetime,
	@EndDate Datetime,
	@MultipleBranchIds VARCHAR(MAX) =  NULL,
	@MultipleAuditIds VARCHAR(MAX) =  NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
    @BusinessUnitIds NVARCHAR(MAX) = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
          
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @AccessAllFeaturePermit BIT = (CASE WHEN EXISTS(SELECT 1 FROM [EntityRoleFeature] WHERE InActiveDateTime IS NULL 
														AND EntityRoleId IN (SELECT EntityRoleId FROM UserProject 
														                      WHERE ProjectId = @ProjectId 
																			        AND UserId = @OperationsPerformedBy
																					AND InActiveDateTime IS NULL
																			)
														AND EntityFeatureId = 'DDF63B16-43F7-46DD-895C-4A88657EB37E' ) THEN 1 ELSE 0 END)
		IF(@BusinessUnitIds = '') SET @BusinessUnitIds = NULL

			CREATE TABLE #AuditIds
			(
				AuditId UNIQUEIDENTIFIER
			)
			IF(@MultipleAuditIds IS NOT NULL)
			BEGIN
            
				INSERT INTO #AuditIds
				SELECT VALUE FROM OPENJSON(@MultipleAuditIds)
          
			END
          
			CREATE TABLE #BranchIds
			(
				BranchId UNIQUEIDENTIFIER
			)
			IF(@MultipleBranchIds IS NOT NULL)
			BEGIN
				INSERT INTO #BranchIds
				SELECT VALUE FROM OPENJSON(@MultipleBranchIds)
			END

			SELECT distinct
				AC.Id AuditId,
				AC.AuditName,
				NULL AuditConductName,
				NULL AuditConductId,
				NULL  StartDate,
				NULL EndDate,
				0 ConductScore,
				0 [TotalQuestions],
				0 [TotalAnswers],
				0 [TotalValidAnswers],
				NULL AS FirstAnswerdDateTime,
				NULL AS LastAnswerdDateTime,
				0 IsCompleted,
				NULL Deadline,
				ac.CreatedDateTime,
				ACSD.ConductStartDate AS ScheduleStartDate,
				ACSD.ConductEndDate AS ScheduleEndDate,
				IsRecurring = (case when CE.Id is null then 0 else 1 end), 
				CE.CronExpression,
				InboundPercent,
				OutboundPercent,
				U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedByUserName,
				NULL AS CronStartDate,
				NULL AS CronEndDate,
				ACSD.SpanInYears,
				ACSD.SpanInMonths,
				ACSD.SpanInDays,
				AC.ProjectId
			FROM AuditCompliance AC
			LEFT JOIN (SELECT A.Id AS AuditId,ISNULL(T.Permission,1) Permission FROM AuditCompliance A 
			       LEFT JOIN (
                             SELECT AG.AuditId,IIF(AG.TagId = @OperationsPerformedBy OR UR.Id IS NOT NULL OR EB.Id IS NOT NULL,1,0) AS Permission
		                            FROM AuditTags AG
			                 	    JOIN Employee E ON E.UserId = @OperationsPerformedBy AND AG.InActiveDateTime IS NULL
			                 	    LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.BranchId = AG.TagId 
                                          AND (EB.ActiveFrom < GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo > GETDATE()))
			                 	    LEFT JOIN [UserRole] UR ON UR.UserId = E.UserId AND UR.RoleId = AG.TagId AND UR.InactiveDateTime IS NULL
			        ) T ON T.AuditId = A.Id
			LEFT JOIN ( SELECT AuditId,COUNT(CASE WHEN A.Id IS NOT NULL OR GFK.Id IS NOT NULL THEN 1 ELSE NULL END ) AGsCount,COUNT(1) TotalCount
	                                               FROM AuditTags AT
												        INNER JOIN [User] U On U.Id = AT.CreatedByUserId AND U.CompanyId = @CompanyId
	                                                    LEFT JOIN Asset A ON A.Id = AT.TagId
	  	                                              LEFT JOIN CustomApplicationTag GFK ON GFK.Id = AT.TagId
	                                                WHERE AT.InActiveDateTime IS NULL
													--A.Id IS NOT NULL OR GFK.Id IS NOT NULL
	                                               GROUP BY AuditId) AG ON AG.AuditId = A.Id
			        WHERE A.CompanyId = @CompanyId 
			        AND (T.AuditId IS NULL OR T.Permission = 1 OR AG.TotalCount = AG.AGsCount)
			        GROUP BY A.Id,ISNULL(T.Permission,1)
			) AG ON AG.AuditId = AC.Id
			JOIN [User] U ON AC.CreatedByUserId = U.Id AND U.IsActive = 1 
			INNER JOIN AuditComplianceSchedulingDetails ACSD ON ACSD.AuditComplianceId = AC.Id AND ACSD.InActiveDateTime IS NULL
			INNER JOIN CronExpression CE ON CE.CustomWidgetId = AC.Id AND CE.InActiveDateTime IS NULL AND ACSD.CronExpressionId =  CE.Id and (CE.ispaused is null or CE.ispaused = 0)
			INNER JOIN #AuditIds T ON T.AuditId = AC.Id
			WHERE (@AccessAllFeaturePermit = 1 OR AG.AuditId IS NOT NULL)
			      AND (@ProjectId IS NULL OR AC.ProjectId = @ProjectId)
			      AND AC.ProjectId IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                                      WHERE 
					                  UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)
			UNION
		  
			SELECT distinct
				AC.Id AuditId,
				AC.AuditName,
				ACT.AuditConductName,
				ACT.Id AuditConductId,
				CONDUCT.*,
				ACT.IsCompleted,
				case when ACT.IsCompleted  = 1 then ACT.UpdatedDateTime else act.DeadlineDate end Deadline,
				case when ACT.IsCompleted  = 1 then StartDate else act.CreatedDateTime  end CreatedDateTime,
				NULL AS ScheduleStartDate,
				NULL AS ScheduleEndDate,
				IsRecurring = (case when CE.Id is null then 0 else 1 end),
				CE.CronExpression,
				InboundPercent,
				OutboundPercent,
				U1.FirstName + ' ' + ISNULL(U1.SurName,'') AS CreatedByUserName,
				--case when ACT.IsCompleted  = 1 then StartDate else ACT.CronStartDate end CronStartDate,
				ACT.CronStartDate AS CronStartDate,
				ACT.CronEndDate,
				ACSD.SpanInYears,
				ACSD.SpanInMonths,
				ACSD.SpanInDays,
				AC.ProjectId
			FROM AuditCompliance AC
			INNER JOIN AuditConduct ACT ON AC.Id = ACT.AuditComplianceId
			OUTER APPLY (
				SELECT 
					MIN(ASA.CreatedDateTime) StartDate,
					MAX(ASA.CreatedDateTime) EndDate,
					SUM(ASA.Score)ConductScore,
					COUNT(DISTINCT ASQ.AuditQuestionId) [TotalQuestions],
					COUNT(distinct ASA.QuestionId) [TotalAnswers],
					SUM(CASE WHEN ASA.QuestionId IS NOT NULL AND ACS.QuestionOptionResult = 1 THEN 1 ELSE 0 END) [TotalValidAnswers],
					MIN(ASA.CreatedDateTime) AS FirstAnswerdDateTime,
					MAX(ASA.CreatedDateTime) AS LastAnswerdDateTime
				FROM AuditConductQuestions ACQ
				INNER JOIN AuditConductSelectedQuestion ASQ ON ACQ.QuestionId = ASQ.AuditQuestionId and ACQ.AuditConductId = ASQ.AuditConductId
				LEFT JOIN AuditConductSubmittedAnswer ASA ON ASQ.AuditQuestionId = ASA.QuestionId AND ACQ.AuditConductId = ASA.ConductId AND ASA.CreatedDateTime is not null
				LEFT JOIN AuditConductAnswers ACS ON ASA.AuditAnswerId = ACS.Id AND ACS.AuditConductId = ASQ.AuditConductId
											AND ACS.QuestionOptionResult = 1 
											AND ASA.InActiveDateTime IS NULL AND ACS.InActiveDateTime IS NULL
				WHERE ACT.Id = ACQ.AuditConductId
					--AND (ASA.CreatedDateTime BETWEEN @StartDate AND @EndDate)
				GROUP BY ACQ.AuditConductId
				--HAVING MIN(ASA.CreatedDateTime) IS NOT NULL
			) AS CONDUCT
			INNER JOIN [User] U1 ON U1.Id = ACT.CreatedByUserId AND U1.isActive = 1 
			LEFT JOIN (SELECT A.Id AS AuditId,ISNULL(T.Permission,1) Permission FROM AuditCompliance A 
			       LEFT JOIN (
                             SELECT AG.AuditId,IIF(AG.TagId = @OperationsPerformedBy OR UR.Id IS NOT NULL OR EB.Id IS NOT NULL OR BU.BusinessUnitId IS NOT NULL,1,0) AS Permission
		                            FROM AuditTags AG
			                 	    JOIN Employee E ON E.UserId = @OperationsPerformedBy AND AG.InActiveDateTime IS NULL
			                 	    LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.BranchId = AG.TagId 
                                          AND (EB.ActiveFrom < GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo > GETDATE()))
			                 	    LEFT JOIN [UserRole] UR ON UR.UserId = E.UserId AND UR.RoleId = AG.TagId AND UR.InactiveDateTime IS NULL
									LEFT JOIN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](@OperationsPerformedBy,@CompanyId,@BusinessUnitIds)) BU ON BU.BusinessUnitId = AG.TagId
			        ) T ON T.AuditId = A.Id
					LEFT JOIN ( SELECT AuditId,COUNT(CASE WHEN A.Id IS NOT NULL OR GFK.Id IS NOT NULL THEN 1 ELSE NULL END ) AGsCount,COUNT(1) TotalCount
	                                               FROM AuditTags AT
												        INNER JOIN [User] U On U.Id = AT.CreatedByUserId AND U.CompanyId = @CompanyId
	                                                    LEFT JOIN Asset A ON A.Id = AT.TagId
	  	                                              LEFT JOIN CustomApplicationTag GFK ON GFK.Id = AT.TagId
	                                                WHERE AT.InActiveDateTime IS NULL
													--A.Id IS NOT NULL OR GFK.Id IS NOT NULL
	                                               GROUP BY AuditId) AG ON AG.AuditId = A.Id
			        WHERE A.CompanyId = @CompanyId 
			        AND (T.AuditId IS NULL OR T.Permission = 1 OR AG.TotalCount = AG.AGsCount)
									AND (@BusinessUnitIds IS NULL OR T.Permission = 1) 
			        GROUP BY A.Id,ISNULL(T.Permission,1)
			) AG ON AG.AuditId = AC.Id
			JOIN [User] U ON AC.CreatedByUserId = U.Id AND U.IsActive = 1 
			LEFT JOIN #AuditIds T ON T.AuditId = AC.Id
			LEFT JOIN Employee E ON E.UserId = U.Id
			LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
			LEFT JOIN #BranchIds B ON B.BranchId = EB.BranchId
			LEFT JOIN CronExpression CE ON CE.CustomWidgetId = AC.Id AND CE.CompanyId = @CompanyId  AND CE.InActiveDateTime IS NULL and (CE.ispaused is null or CE.ispaused = 0)
								AND ACT.CronExpression = replace( CE.CronExpression, '?', '*')
			LEFT JOIN AuditComplianceSchedulingDetails ACSD ON ACSD.AuditComplianceId = AC.Id AND ACSD.InActiveDateTime IS NULL AND ACSD.CronExpressionId = CE.Id
			WHERE AC.CompanyId = @CompanyId
			    AND (@ProjectId IS NULL OR AC.ProjectId = @ProjectId)
				AND (@MultipleBranchIds IS NULL OR B.BranchId IS NOT NULL)
				AND (@MultipleAuditIds IS NULL OR T.AuditId IS NOT NULL)
				AND (@BusinessUnitIds IS NULL OR AG.AuditId IS NOT NULL) 
				AND (@AccessAllFeaturePermit = 1 OR AG.AuditId IS NOT NULL)
				AND ((ACT.CreatedDateTime BETWEEN @StartDate AND @EndDate AND DeadlineDate BETWEEN @StartDate AND @EndDate )
						OR (@StartDate BETWEEN ACT.CreatedDateTime AND DeadlineDate OR @EndDate BETWEEN ACT.CreatedDateTime AND DeadlineDate)
					)
				AND ACT.InActiveDateTime IS NULL
				AND AC.ProjectId IN (SELECT UP.ProjectId FROM [Userproject] UP WITH (NOLOCK) 
                                      WHERE 
					                  UP.InactiveDateTime IS NULL AND UP.UserId = @OperationsPerformedBy)

			ORDER BY CreatedDateTime
       	   
		END
      END TRY
   BEGIN CATCH
       THROW
   END CATCH 
END