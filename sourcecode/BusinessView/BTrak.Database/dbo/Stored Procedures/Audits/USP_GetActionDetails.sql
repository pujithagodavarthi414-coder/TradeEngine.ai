CREATE PROCEDURE [dbo].[USP_GetActionDetails]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@BranchId UNIQUEIDENTIFIER = NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@AuditId  UNIQUEIDENTIFIER = NULL
	,@BusinessUnitIds NVARCHAR(MAX) = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF(@BranchId IS NULL)
	BEGIN
		SET @BranchId = (SELECT EB.BranchId FROM EmployeeBranch EB INNER JOIN Employee E ON EB.EmployeeId = E.Id AND  E.UserId = @OperationsPerformedBy)
	END

	IF (@HavePermission = '1')
	BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		IF(@BusinessUnitIds = '') SET @BusinessUnitIds = NULL

		--TODO
		--DECLARE @AccessAllFeaturePermit BIT = (CASE WHEN EXISTS(SELECT 1 FROM [RoleFeature] WHERE InActiveDateTime IS NULL 
		--															AND RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy))
		--															AND FeatureId = 'DDF63B16-43F7-46DD-895C-4A88657EB37E' ) THEN 1 ELSE 0 END)
		DECLARE @AccessAllFeaturePermit BIT = (CASE WHEN EXISTS(SELECT 1 FROM [EntityRoleFeature] WHERE InActiveDateTime IS NULL 
														AND EntityRoleId IN (SELECT EntityRoleId FROM UserProject 
														                      WHERE ProjectId = @ProjectId 
																			        AND UserId = @OperationsPerformedBy
																					AND InActiveDateTime IS NULL
																			)
														AND EntityFeatureId = 'DDF63B16-43F7-46DD-895C-4A88657EB37E' ) THEN 1 ELSE 0 END)
		DECLARE @CurrentDate DATE = CAST(GETDATE() AS DATE)

		DECLARE @CurrentMonthStartDate DATE = DATEADD(month, DATEDIFF(month, 0, @CurrentDate), 0), @CurrentMonthEndDate DATE = EOMONTH(@CurrentDate)

		SELECT ISNULL(Z.BranchNames,B.BranchName) [Branch Name], AC.AuditName [Audit Name], 
		       ISNULL(SUM(CurrentMonthQuery.[Current Month]),0) [Current Month], ISNULL(SUM(LessThanThirty.[Less than 30 days]),0) [Less than 30 days], 
			   ISNULL(SUM(OlderThanThirty.[Older than 30 days]),0) [Older than 30 days], ISNULL(SUM(OlderThanSixty.[Older than 60 days]),0) [Older than 60 days]
		FROM AuditConduct ACT
		     INNER JOIN AuditCompliance AC ON AC.Id = ACT.AuditComplianceId AND ACT.InActiveDateTime IS NULL AND AC.InActiveDateTime IS NULL
			 INNER JOIN AuditCategory ACC ON ACC.AuditComplianceId = AC.Id
			 INNER JOIN AuditQuestions AQ ON AQ.AuditCategoryId = ACC.Id
			 INNER JOIN AuditConductSelectedQuestion ACSQ ON ACSQ.AuditConductId = ACT.Id AND ACSQ.AuditQuestionId = AQ.Id
			 INNER JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = ACT.Id AND ACQ.QuestionId = AQ.Id
			 INNER JOIN UserStory US ON ACQ.Id IN (SELECT [value] FROM [dbo].[Ufn_StringSplit](US.AuditConductQuestionId,','))
			 INNER JOIN Employee E ON E.UserId = US.OwnerUserId
			 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND CAST(US.CreatedDateTime AS DATE) BETWEEN CAST(EB.ActiveFrom AS DATE) AND ISNULL(EB.ActiveTo,CAST(GETDATE() AS DATE))
			 INNER JOIN Branch B ON B.Id = EB.BranchId
			 LEFT JOIN (SELECT AC.Id AuditId,STUFF((SELECT ',' + B.BranchName
                          FROM Branch B INNER JOIN AuditTags AG ON AG.TagId = B.Id AND B.CompanyId = @CompanyId WHERE AG.AuditConductId = ACT.Id AND AG.InActiveDateTime IS NULL
                    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')BranchNames	 FROM  AuditConduct ACT 
						     INNER JOIN AuditCompliance AC ON AC.Id = ACT.AuditComplianceId AND ACT.InActiveDateTime IS NULL AND AC.InActiveDateTime IS NULL
							 INNER JOIN AuditCategory ACC ON ACC.AuditComplianceId = AC.Id
							 INNER JOIN AuditQuestions AQ ON AQ.AuditCategoryId = ACC.Id
							 INNER JOIN AuditConductSelectedQuestion ACSQ ON ACSQ.AuditConductId = ACT.Id AND ACSQ.AuditQuestionId = AQ.Id
							 INNER JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = ACT.Id AND ACQ.QuestionId = AQ.Id
							 INNER JOIN UserStory US ON ACQ.Id IN (SELECT [value] FROM [dbo].[Ufn_StringSplit](US.AuditConductQuestionId,','))
							 INNER JOIN AuditTags ATT ON ATT.AuditConductId = ACT.Id
					WHERE  CAST(US.CreatedDateTime AS DATE) BETWEEN DATEADD(DAY,-60,@CurrentDate) AND @CurrentMonthEndDate
					AND ATT.TagId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId  AND (@BranchId IS NULL OR Id = @BranchId)))Z ON Z.AuditId = AC.Id
			 LEFT JOIN (SELECT A.Id AS AuditId,ISNULL(T.Permission,1) Permission FROM AuditCompliance A 
							   LEFT JOIN(
										 SELECT AG.AuditId,IIF(AG.TagId = @OperationsPerformedBy OR UR.Id IS NOT NULL OR EB.Id IS NOT NULL OR BU.BusinessUnitId IS NOT NULL,1,0) AS Permission
												FROM AuditTags AG
			                 					JOIN Employee E ON E.UserId = @OperationsPerformedBy AND AG.InActiveDateTime IS NULL AND AG.AuditConductId IS NULL
			                 					LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.BranchId = AG.TagId 
													  AND (EB.ActiveFrom < GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo > GETDATE()))
			                 					LEFT JOIN [UserRole] UR ON UR.UserId = E.UserId AND UR.RoleId = AG.TagId AND UR.InactiveDateTime IS NULL
												LEFT JOIN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](@OperationsPerformedBy,@CompanyId,@BusinessUnitIds)) BU ON BU.BusinessUnitId = AG.TagId
												WHERE (@BranchId IS NULL OR @BranchId = EB.BranchId)
			                 					) T ON T.AuditId = A.Id
								LEFT JOIN ( SELECT AuditId,COUNT(CASE WHEN A.Id IS NOT NULL OR GFK.Id IS NOT NULL THEN 1 ELSE NULL END ) AGsCount,COUNT(1) TotalCount
	                                               FROM AuditTags AT
												        INNER JOIN [User] U On U.Id = AT.CreatedByUserId AND U.CompanyId = @CompanyId AND AT.AuditConductId IS NULL
	                                                    LEFT JOIN Asset A ON A.Id = AT.TagId
	  	                                              LEFT JOIN CustomApplicationTag GFK ON GFK.Id = AT.TagId
	                                                WHERE AT.InActiveDateTime IS NULL
													--A.Id IS NOT NULL OR GFK.Id IS NOT NULL
	                                               GROUP BY AuditId) AG ON AG.AuditId = A.Id
			                 					WHERE A.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy) 
			                 					AND (T.AuditId IS NULL OR T.Permission = 1 OR AG.TotalCount = AG.AGsCount)
									AND (@BusinessUnitIds IS NULL OR T.Permission = 1) 
												AND (@ProjectId IS NULL OR A.ProjectId = @ProjectId)
			                 					GROUP BY A.Id,ISNULL(T.Permission,1)) AG ON AG.AuditId = AC.Id

			 LEFT JOIN (SELECT  ACT.Id ConductId, COUNT(1) [Current Month]
						FROM AuditConduct ACT
						     INNER JOIN AuditCompliance AC ON AC.Id = ACT.AuditComplianceId AND ACT.InActiveDateTime IS NULL AND AC.InActiveDateTime IS NULL
							 INNER JOIN AuditCategory ACC ON ACC.AuditComplianceId = AC.Id
							 INNER JOIN AuditQuestions AQ ON AQ.AuditCategoryId = ACC.Id
							 INNER JOIN AuditConductSelectedQuestion ACSQ ON ACSQ.AuditConductId = ACT.Id AND ACSQ.AuditQuestionId = AQ.Id
							 INNER JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = ACT.Id AND ACQ.QuestionId = AQ.Id
							 INNER JOIN UserStory US ON ACQ.Id IN (SELECT [value] FROM [dbo].[Ufn_StringSplit](US.AuditConductQuestionId,','))
						WHERE AC.CompanyId = @CompanyId
							  
						      AND CAST(US.CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentMonthEndDate
						GROUP BY  ACT.Id) CurrentMonthQuery ON CurrentMonthQuery.ConductId = ACT.Id

			LEFT JOIN (SELECT ACT.Id ConductId, COUNT(1) [Less than 30 days]
						FROM AuditConduct ACT
						     INNER JOIN AuditCompliance AC ON AC.Id = ACT.AuditComplianceId AND ACT.InActiveDateTime IS NULL AND AC.InActiveDateTime IS NULL
							 INNER JOIN AuditCategory ACC ON ACC.AuditComplianceId = AC.Id
							 INNER JOIN AuditQuestions AQ ON AQ.AuditCategoryId = ACC.Id
							 INNER JOIN AuditConductSelectedQuestion ACSQ ON ACSQ.AuditConductId = ACT.Id AND ACSQ.AuditQuestionId = AQ.Id
							 INNER JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = ACT.Id AND ACQ.QuestionId = AQ.Id
							 INNER JOIN UserStory US ON ACQ.Id IN (SELECT [value] FROM [dbo].[Ufn_StringSplit](US.AuditConductQuestionId,','))
						WHERE AC.CompanyId = @CompanyId
							  
						      AND DATEDIFF(DAY,CAST(US.CreatedDateTime AS DATE),@CurrentDate) <= 30
						GROUP BY  ACT.Id) LessThanThirty ON  LessThanThirty.ConductId = ACT.Id

			 LEFT JOIN (SELECT  ACT.Id ConductId, COUNT(1) [Older than 30 days]
						FROM AuditConduct ACT
						     INNER JOIN AuditCompliance AC ON AC.Id = ACT.AuditComplianceId AND ACT.InActiveDateTime IS NULL AND AC.InActiveDateTime IS NULL
							 INNER JOIN AuditCategory ACC ON ACC.AuditComplianceId = AC.Id
							 INNER JOIN AuditQuestions AQ ON AQ.AuditCategoryId = ACC.Id
							 INNER JOIN AuditConductSelectedQuestion ACSQ ON ACSQ.AuditConductId = ACT.Id AND ACSQ.AuditQuestionId = AQ.Id
							 INNER JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = ACT.Id AND ACQ.QuestionId = AQ.Id
							 INNER JOIN UserStory US ON ACQ.Id IN (SELECT [value] FROM [dbo].[Ufn_StringSplit](US.AuditConductQuestionId,','))
						WHERE AC.CompanyId = @CompanyId
						      AND DATEDIFF(DAY,CAST(US.CreatedDateTime AS DATE),@CurrentDate) > 30
						GROUP BY  ACT.Id) OlderThanThirty ON OlderThanThirty.ConductId = ACT.Id

			 LEFT JOIN (SELECT ACT.Id ConductId,   COUNT(1) [Older than 60 days]
						FROM AuditConduct ACT
						     INNER JOIN AuditCompliance AC ON AC.Id = ACT.AuditComplianceId AND ACT.InActiveDateTime IS NULL AND AC.InActiveDateTime IS NULL
							 INNER JOIN AuditCategory ACC ON ACC.AuditComplianceId = AC.Id
							 INNER JOIN AuditQuestions AQ ON AQ.AuditCategoryId = ACC.Id
							 INNER JOIN AuditConductSelectedQuestion ACSQ ON ACSQ.AuditConductId = ACT.Id AND ACSQ.AuditQuestionId = AQ.Id
							 INNER JOIN AuditConductQuestions ACQ ON ACQ.AuditConductId = ACT.Id AND ACQ.QuestionId = AQ.Id
							 INNER JOIN UserStory US ON ACQ.Id IN (SELECT [value] FROM [dbo].[Ufn_StringSplit](US.AuditConductQuestionId,','))
						WHERE AC.CompanyId = @CompanyId
						      AND DATEDIFF(DAY,CAST(US.CreatedDateTime AS DATE),@CurrentDate) > 60
					    GROUP BY  ACT.Id) OlderThanSixty ON  OlderThanSixty.ConductId = ACT.Id
			
		WHERE AC.CompanyId = @CompanyId
			  AND (@ProjectId IS NULL OR AC.ProjectId = @ProjectId)
			  AND (@BusinessUnitIds IS NULL OR AG.AuditId IS NOT NULL) 
			  AND (@AccessAllFeaturePermit = 1 OR AG.AuditId IS NOT NULL)
			  AND (@AuditId IS NULL OR AC.Id = @AuditId)
			  AND (@BranchId IS NULL OR (B.Id = @BranchId OR Z.AuditId IS NOT NULL))
		      AND CAST(US.CreatedDateTime AS DATE) BETWEEN DATEADD(DAY,-60,@CurrentDate) AND @CurrentMonthEndDate
		GROUP BY BranchNames, AC.AuditName,B.BranchName
		ORDER BY AC.AuditName
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