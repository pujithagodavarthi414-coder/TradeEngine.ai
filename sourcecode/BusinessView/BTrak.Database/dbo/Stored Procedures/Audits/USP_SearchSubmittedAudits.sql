CREATE PROCEDURE [dbo].[USP_SearchSubmittedAudits]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

   DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
          
		  IF (@DateTo IS NULL) SET @DateTo = EOMONTH(GETDATE())

    		IF (@DateFrom IS NULL) SET @DateFrom = DATEADD(DAY,1,EOMONTH(GETDATE(),-1))

			IF (@DateTo IS NOT NULL) SET @DateTo = CONVERT(DATE,@DateTo)

    		IF (@DateFrom IS NOT NULL) SET @DateFrom = CONVERT(DATE,@DateFrom)

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  --TODO
		  DECLARE @AccessAllFeaturePermit BIT = (CASE WHEN EXISTS(SELECT 1 FROM [RoleFeature] WHERE InActiveDateTime IS NULL 
																	AND RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy))
																	AND FeatureId = 'DDF63B16-43F7-46DD-895C-4A88657EB37E' ) THEN 1 ELSE 0 END)
           
		   SELECT   B.Id AS BranchId,
					B.BranchName,
					AC.AuditConductName,
					AC.Id AS AuditConductId,
					ACC.AuditName,
					AC.IsCompleted,
					U.[FirstName] + ' ' +ISNULL(U.SurName,'') SubmittedBy,
					U1.[FirstName] + ' ' +ISNULL(U1.SurName,'') CreatedBy,
					AC.UpdatedDateTime,
					AC.CreatedDateTime,
					AC.ProjectId
					--COUNT(1) AS SubmittedAudit
		   FROM AuditConduct AC 
		   INNER JOIN [User] U ON AC.UpdatedByUserId = U.Id AND U.InActiveDateTime IS NULL AND AC.IsCompleted = 1 AND AC.InActiveDateTime IS NULL
		   AND CONVERT(DATE,AC.UpdatedDateTime) BETWEEN @DateFrom AND @DateTo
		   INNER JOIN [User] U1 ON AC.CreatedByUserId = U1.Id AND U1.InActiveDateTime IS NULL
		   INNER JOIN AuditCompliance ACC ON ACC.Id = AC.AuditComplianceId AND ACC.InActiveDateTime IS NULL AND ACC.CompanyId = @CompanyId
		   INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
		   INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.ActiveTo IS NULL
		   INNER JOIN Branch B ON EB.BranchId = B.Id AND B.InActiveDateTime IS NULL
		   LEFT JOIN (SELECT A.Id AS AuditId,ISNULL(T.Permission,1) Permission FROM AuditCompliance A 
							   LEFT JOIN(
										 SELECT AG.AuditId,IIF(AG.TagId = @OperationsPerformedBy OR UR.Id IS NOT NULL OR EB.Id IS NOT NULL,1,0) AS Permission
												FROM AuditTags AG
			                 					JOIN Employee E ON E.UserId = @OperationsPerformedBy AND AG.InActiveDateTime IS NULL
			                 					LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.BranchId = AG.TagId 
													  AND (EB.ActiveFrom < GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo > GETDATE()))
													
			                 					LEFT JOIN [UserRole] UR ON UR.UserId = E.UserId AND UR.RoleId = AG.TagId AND UR.InactiveDateTime IS NULL
												--WHERE (@BranchId IS NULL OR @BranchId = EB.BranchId)
			                 					) T ON T.AuditId = A.Id
								LEFT JOIN ( SELECT AuditId,COUNT(CASE WHEN A.Id IS NOT NULL OR GFK.Id IS NOT NULL THEN 1 ELSE NULL END ) AGsCount,COUNT(1) TotalCount
	                                               FROM AuditTags AT
												        INNER JOIN [User] U On U.Id = AT.CreatedByUserId AND U.CompanyId = @CompanyId
	                                                    LEFT JOIN Asset A ON A.Id = AT.TagId
	  	                                              LEFT JOIN CustomApplicationTag GFK ON GFK.Id = AT.TagId
	                                                WHERE AT.InActiveDateTime IS NULL
													--A.Id IS NOT NULL OR GFK.Id IS NOT NULL
	                                               GROUP BY AuditId) AG ON AG.AuditId = A.Id
			                 					WHERE A.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy) 
			                 					AND (T.AuditId IS NULL OR T.Permission = 1 OR AG.TotalCount = AG.AGsCount)
												
			                 					GROUP BY A.Id,ISNULL(T.Permission,1)) AG ON AG.AuditId = ACC.Id
						WHERE (@AccessAllFeaturePermit = 1 OR AG.AuditId IS NOT NULL)

		END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO
