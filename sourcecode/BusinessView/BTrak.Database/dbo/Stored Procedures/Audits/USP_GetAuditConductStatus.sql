CREATE PROCEDURE [dbo].[USP_GetAuditConductStatus]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@BranchId UNIQUEIDENTIFIER = NULL,
	@Date DATETIME = NULL,
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@AuditId UNIQUEIDENTIFIER = NULL
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
		SELECT BranchName [Branch Name],
		       AuditConductName [Audit Conduct Name],
			   CASE WHEN SubmittedDateTime IS NULL AND CAST(GETDATE() AS DATE) > DeadlineDate THEN 'Overdue'
			        WHEN SubmittedDateTime IS NOT NULL AND SubmittedDateTime <= DeadlineDate THEN 'Completed'
			        WHEN SubmittedDateTime IS NULL AND [Count] > 0 THEN 'In Progress'
					ELSE 'Not Started' END [Status]
		FROM (
				SELECT ISNULL(STUFF((SELECT ',' + B.BranchName
                          FROM Branch B INNER JOIN AuditTags AG ON AG.TagId = B.Id AND B.CompanyId = @CompanyId  AND B.InActiveDateTime IS NULL AND AG.InActiveDateTime IS NULL
						               WHERE AG.AuditConductId = ACT.Id
										GROUP BY B.BranchName
                    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),B1.BranchName) BranchName, ACT.Id AuditConductId, ACT.AuditConductName, IIF(ACT.IsCompleted = 1,ACT.UpdatedDateTime,NULL) SubmittedDateTime, ACTInner.[Count], ACT.DeadlineDate
				FROM AuditConduct ACT
				     INNER JOIN AuditCompliance AC ON AC.Id = ACT.AuditComplianceId AND ACT.InActiveDateTime IS NULL AND AC.InActiveDateTime IS NULL
					 INNER JOIN  Employee E ON E.UserId = ACT.CreatedByUserId
					 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id  AND E.UserId = ACT.CreatedByUserId AND CAST(ACT.CreatedDateTime AS datetime) 
							 BETWEEN CAST(EB.ActiveFrom AS datetime) AND ISNULL(EB.ActiveTo,CAST(GETDATE() AS datetime))
                     INNER JOIN Branch B1 ON B1.Id = EB.BranchId
					 LEFT JOIN AuditTags ATT ON ATT.AuditConductId = ACT.Id AND ATT.InActiveDateTime IS NULL 
					 LEFT JOIN Branch B ON B.Id = ATT.TagId AND B.CompanyId = @CompanyId
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
				WHERE AC.CompanyId = @CompanyId
					  AND (@ProjectId IS NULL OR AC.ProjectId = @ProjectId)
				      AND (@BranchId IS NULL OR B.Id = @BranchId OR B1.Id = @BranchId)
					  AND (@AuditId IS NULL OR AC.Id = @AuditId)
				AND (@BusinessUnitIds IS NULL OR AG.AuditId IS NOT NULL) 
					  AND (@AccessAllFeaturePermit = 1 OR AG.AuditId IS NOT NULL)
					  AND (@Date IS NULL OR CAST(ACT.DeadlineDate AS DATE) <= @Date OR CAST(ACT.CreatedDateTime AS DATE) <= @Date)
					  AND ((@DateFrom IS NULL AND @DateTo IS NULL) OR CAST(ACT.DeadlineDate AS DATE) BETWEEN @DateFrom AND @DateTo OR CAST(ACT.CreatedDateTime AS DATE) BETWEEN @DateFrom AND @DateTo OR CAST(ACT.DeadlineDate AS DATE) >= @DateTo)
		 GROUP BY  ACT.Id , ACT.AuditConductName,ACT.IsCompleted ,ACT.UpdatedDateTime, ACTInner.[Count], ACT.DeadlineDate,B1.BranchName
		) T
		ORDER BY AuditConductName

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