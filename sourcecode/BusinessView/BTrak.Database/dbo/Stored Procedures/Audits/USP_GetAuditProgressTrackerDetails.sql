CREATE PROCEDURE [dbo].[USP_GetAuditProgressTrackerDetails]
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

		DECLARE @CurrentMonthStartDate DATE = DATEADD(month, DATEDIFF(month, 0, @CurrentDate), 0), @CurrentMonthEndDate DATE = EOMONTH(@CurrentDate),
		        @PrevMonthStartDate DATE = DATEADD(month, DATEDIFF(month, 0, DATEADD(MONTH,-1,@CurrentDate)), 0), @PrevMonthEndDate DATE = EOMONTH(DATEADD(MONTH,-1,@CurrentDate))

		SELECT *,
			   CASE WHEN SubmittedDateTime IS NOT NULL AND SubmittedDateTime <= DeadlineDate THEN 1 ELSE 0 END IsCompleted
		INTO #AuditDetails
		FROM (
				SELECT EB.BranchId, ACT.Id AuditConductId, AC.Id AuditId, AC.AuditName, IIF(ACT.IsCompleted = 1,ACT.UpdatedDateTime,NULL) SubmittedDateTime, ACTInner.[Count], ACT.DeadlineDate, ACT.CreatedDateTime
				FROM AuditConduct ACT
				     INNER JOIN AuditCompliance AC ON AC.Id = ACT.AuditComplianceId AND ACT.InActiveDateTime IS NULL AND AC.InActiveDateTime IS NULL
					 INNER JOIN Employee E ON E.UserId = ACT.CreatedByUserId
					 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND CAST(ACT.CreatedDateTime AS DATE) BETWEEN CAST(EB.ActiveFrom AS DATE) AND ISNULL(EB.ActiveTo,CAST(GETDATE() AS DATE))
					 INNER JOIN Branch B ON B.Id = EB.BranchId
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
					 LEFT JOIN (SELECT ConductId, COUNT(1) [Count] FROM AuditConductSubmittedAnswer GROUP BY ConductId) ACTInner ON ACTInner.ConductId = ACT.Id
					 LEFT JOIN (SELECT AuditConductId FROM AuditTags ATT WHERE ATT.TagId = @BranchId AND ATT.InActiveDateTime IS NULL 
						GROUP BY ATT.AuditConductId) ATT ON ATT.AuditConductId = ACT.Id
				WHERE AC.CompanyId = @CompanyId
					  AND (@ProjectId IS NULL OR AC.ProjectId = @ProjectId)
					   AND (@AuditId IS NULL OR AC.Id = @AuditId)
				      AND (@BranchId IS NULL OR (EB.BranchId = @BranchId OR ATT.AuditConductId IS NOT NULL))
				AND (@BusinessUnitIds IS NULL OR AG.AuditId IS NOT NULL) 
					  AND (@AccessAllFeaturePermit = 1 OR AG.AuditId IS NOT NULL)
					  AND CAST(ACT.CreatedDateTime AS DATE) BETWEEN @PrevMonthStartDate AND @CurrentMonthEndDate
		) T

		SELECT AuditName [Audit Name], 
		       CAST(ISNULL(PrevMonthCompleted,0) AS NVARCHAR(100)) + ' of ' + CAST(ISNULL(PrevMonthTotal,0) AS NVARCHAR(100)) [Branches submitted in last month], 
			   CAST(ISNULL(CurrentMonthCompleted,0) AS NVARCHAR(100)) + ' of ' + CAST(ISNULL(CurrentMonthTotal,0) AS NVARCHAR(100)) [Branches submitted in this month]
		FROM #AuditDetails AD LEFT JOIN (SELECT AuditConductId FROM AuditTags ATT WHERE ATT.TagId = @BranchId AND ATT.InActiveDateTime IS NULL 
						GROUP BY ATT.AuditConductId) ATT ON ATT.AuditConductId = AD.AuditConductId

		     LEFT JOIN (SELECT AuditId, COUNT(DISTINCT BranchId) CurrentMonthTotal FROM #AuditDetails AD LEFT JOIN (SELECT AuditConductId FROM AuditTags ATT WHERE ATT.TagId = @BranchId AND ATT.InActiveDateTime IS NULL 
						GROUP BY ATT.AuditConductId) ATT ON ATT.AuditConductId = AD.AuditConductId
						WHERE (@BranchId IS NULL OR (BranchId = @BranchId OR ATT.AuditConductId IS NOT NULL)) AND CAST(CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentMonthEndDate GROUP BY AuditId) CurrentMonth ON CurrentMonth.AuditId = AD.AuditId

			 LEFT JOIN (SELECT AuditId, COUNT(DISTINCT BranchId) PrevMonthTotal FROM #AuditDetails AD LEFT JOIN (SELECT AuditConductId FROM AuditTags ATT WHERE ATT.TagId = @BranchId AND ATT.InActiveDateTime IS NULL 
						GROUP BY ATT.AuditConductId) ATT ON ATT.AuditConductId = AD.AuditConductId
						    WHERE (@BranchId IS NULL OR (BranchId = @BranchId OR ATT.AuditConductId IS NOT NULL)) AND CAST(CreatedDateTime AS DATE) BETWEEN @PrevMonthStartDate AND @PrevMonthEndDate GROUP BY AuditId) PrevMonth ON PrevMonth.AuditId = AD.AuditId
			 
			 LEFT JOIN (SELECT AuditId, COUNT(DISTINCT BranchId) CurrentMonthCompleted
			            FROM (SELECT AuditId, BranchId, COUNT(1) [Count], SUM(IsCompleted) [Completed] FROM #AuditDetails AD LEFT JOIN (SELECT AuditConductId FROM AuditTags ATT WHERE ATT.TagId = @BranchId AND ATT.InActiveDateTime IS NULL 
						GROUP BY ATT.AuditConductId) ATT ON ATT.AuditConductId = AD.AuditConductId
						WHERE  (@BranchId IS NULL OR (BranchId = @BranchId OR ATT.AuditConductId IS NOT NULL)) AND CAST(CreatedDateTime AS DATE) BETWEEN @CurrentMonthStartDate AND @CurrentMonthEndDate GROUP BY AuditId, BranchId) T
						WHERE [Count] = [Completed]
						GROUP BY AuditId) CurrentMonth1 ON CurrentMonth1.AuditId = AD.AuditId
			 
			 LEFT JOIN (SELECT AuditId, COUNT(DISTINCT BranchId) PrevMonthCompleted
			            FROM (SELECT AuditId, BranchId, COUNT(1) [Count], SUM(IsCompleted) [Completed] FROM #AuditDetails AD LEFT JOIN (SELECT AuditConductId FROM AuditTags ATT WHERE ATT.TagId = @BranchId AND ATT.InActiveDateTime IS NULL 
						GROUP BY ATT.AuditConductId) ATT ON ATT.AuditConductId = AD.AuditConductId WHERE  (@BranchId IS NULL OR (BranchId = @BranchId OR ATT.AuditConductId IS NOT NULL)) AND CAST(CreatedDateTime AS DATE) BETWEEN @PrevMonthStartDate AND @PrevMonthEndDate GROUP BY AuditId, BranchId) T
						WHERE [Count] = [Completed]
						GROUP BY AuditId) PrevMonth1 ON PrevMonth1.AuditId = AD.AuditId
		
		WHERE  (@BranchId IS NULL OR (BranchId = @BranchId OR ATT.AuditConductId IS NOT NULL))
		GROUP BY AuditName, PrevMonthCompleted, PrevMonthTotal, CurrentMonthCompleted, CurrentMonthTotal

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