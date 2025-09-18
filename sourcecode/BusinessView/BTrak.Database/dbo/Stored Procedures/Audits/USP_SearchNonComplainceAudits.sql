--EXEC [USP_SearchNonComplainceAudits] @OperationsPerformedBy='E9650A77-5E9B-4CD7-872D-C149F549D0A4'
CREATE PROCEDURE [dbo].[USP_SearchNonComplainceAudits]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @AuditId UNIQUEIDENTIFIER = NULL,
   @ProjectId UNIQUEIDENTIFIER = NULL
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

		  --TODO
		  --DECLARE @AccessAllFeaturePermit BIT = (CASE WHEN EXISTS(SELECT 1 FROM [RoleFeature] WHERE InActiveDateTime IS NULL 
				--													AND RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy))
				--													AND FeatureId = 'DDF63B16-43F7-46DD-895C-4A88657EB37E' ) THEN 1 ELSE 0 END)
				DECLARE @AccessAllFeaturePermit BIT = (CASE WHEN EXISTS(SELECT 1 FROM [EntityRoleFeature] WHERE InActiveDateTime IS NULL 
														AND EntityRoleId IN (SELECT EntityRoleId FROM UserProject 
														                      WHERE ProjectId = @ProjectId 
																			        AND UserId = @OperationsPerformedBy
																					AND InActiveDateTime IS NULL
																			)
														AND EntityFeatureId = 'DDF63B16-43F7-46DD-895C-4A88657EB37E' ) THEN 1 ELSE 0 END)
           
		   IF (@DateTo IS NULL) SET @DateTo = EOMONTH(GETDATE())

    		IF (@DateFrom IS NULL) SET @DateFrom = DATEADD(DAY,1,EOMONTH(GETDATE(),-1))

			IF (@DateTo IS NOT NULL) SET @DateTo = CONVERT(DATE,@DateTo)

    		IF (@DateFrom IS NOT NULL) SET @DateFrom = CONVERT(DATE,@DateFrom)

		   SELECT AQ.Id  AS QuestionId,
		   AQ.QuestionName AS QuestionName,
		   ACC.AuditName,
		   ACC.Id AS AuditId,
		   AC.Id AS AuditConductId,
		   AC.AuditConductName,
		   U.[FirstName] + ' ' +ISNULL(U.SurName,'') SubmittedBy,
		   B.Id AS BranchId,
		   B.BranchName,
		   ACQ.CreatedDateTime,
		   AC.ProjectId,
		   ACS.CreatedDateTime AS UpdatedDateTime,
		   ISNULL(ACA.QuestionOptionResult,0) AS QuestionOptionResult
		   FROM AuditConductQuestions ACQ 
               JOIN AuditConductAnswers ACA ON ACA.AuditQuestionId = ACQ.QuestionId
                AND ACA.AuditConductId = ACQ.AuditConductId AND ACQ.InActiveDateTime IS NULL AND ACA.InactiveDateTime IS NULL
               JOIN AuditConductSubmittedAnswer ACS ON ACS.QuestionId = ACQ.QuestionId AND CONVERT(DATE,ISNULL(ACS.UpdatedDateTime,ACS.CreatedDateTime)) BETWEEN @DateFrom AND @DateTo
                AND ACS.AuditAnswerId = ACA.Id AND ACS.ConductId = ACQ.AuditConductId
			   JOIN AuditConduct AC ON AC.Id = ACQ.AuditConductId AND AC.InActiveDateTime IS NULL
			    JOIN AuditQuestions AQ ON AQ.Id = ACQ.QuestionId AND AQ.InactiveDateTime IS NULL
			   JOIN AuditCategory ACT  ON ACT.Id = AQ.AuditCategoryId AND ACT.InactiveDateTime IS NULL
			   JOIN AuditCompliance ACC ON ACC.Id = ACT.AuditComplianceId AND ACC.InActiveDateTime IS NULL AND (ACC.Id = @AuditId OR @AuditId IS NULL) AND ACC.CompanyId = @CompanyId
			   JOIN [User] U ON ISNULL(ACS.UpdatedByUserId,ACS.CreatedByUserId) = U.Id AND U.InActiveDateTime IS NULL
			   INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
				INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.ActiveTo IS NULL
				INNER JOIN Branch B ON EB.BranchId = B.Id AND B.InActiveDateTime IS NULL AND (B.Id = @BranchId OR @BranchId IS NULL)
				LEFT JOIN (SELECT A.Id AS AuditId,ISNULL(T.Permission,1) Permission FROM AuditCompliance A 
							   LEFT JOIN(
										 SELECT AG.AuditId,IIF(AG.TagId = @OperationsPerformedBy OR UR.Id IS NOT NULL OR EB.Id IS NOT NULL,1,0) AS Permission
												FROM AuditTags AG
			                 					JOIN Employee E ON E.UserId = @OperationsPerformedBy AND AG.InActiveDateTime IS NULL AND AG.AuditConductId IS NULL
			                 					LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.BranchId = AG.TagId 
													  AND (EB.ActiveFrom < GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo > GETDATE()))
													
			                 					LEFT JOIN [UserRole] UR ON UR.UserId = E.UserId AND UR.RoleId = AG.TagId AND UR.InactiveDateTime IS NULL
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
												
			                 					GROUP BY A.Id,ISNULL(T.Permission,1)) AG ON AG.AuditId = ACC.Id
					WHERE (@AccessAllFeaturePermit = 1 OR AG.AuditId IS NOT NULL)
					AND (@ProjectId IS NULL OR ACC.ProjectId = @ProjectId)
		END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO