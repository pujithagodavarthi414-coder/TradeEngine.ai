CREATE PROCEDURE [dbo].[USP_GetAuditsByBranch]
(
	@StartDate Datetime,
	@EndDate Datetime,
	@MultipleBranchIds VARCHAR(MAX) =  NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
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

		  DECLARE @AccessAllFeaturePermit BIT = (CASE WHEN EXISTS(SELECT 1 FROM [EntityRoleFeature] WHERE InActiveDateTime IS NULL 
														AND EntityRoleId IN (SELECT EntityRoleId FROM UserProject 
														                      WHERE ProjectId = @ProjectId 
																			        AND UserId = @OperationsPerformedBy
																					AND InActiveDateTime IS NULL
																			)
														AND EntityFeatureId = 'DDF63B16-43F7-46DD-895C-4A88657EB37E' ) THEN 1 ELSE 0 END)
          
		  CREATE TABLE #BranchIds
          (
            BranchId UNIQUEIDENTIFIER
          )
          IF(@MultipleBranchIds IS NOT NULL)
          BEGIN
            
            INSERT INTO #BranchIds
			SELECT VALUE FROM OPENJSON(@MultipleBranchIds)

          END

		  SELECT * FROM (
		  SELECT DISTINCT AC.Id AS AuditId,
				 AC.AuditName,
				 AC.[Description] AS AuditDescription,
				 B.Id BranchId,
				 B.BranchName,
				 (SELECT COUNT(1) FROM AuditConduct ACN WHERE ACN.AuditComplianceId = AC.Id AND ACN.InActiveDateTime IS NULL AND (ACN.CreatedDateTime BETWEEN @StartDate AND @EndDate)) AS ConductsCount,
				 IsRecurring = (case when CE.Id is null then 0 else 1 end)
		  FROM AuditCompliance AC
		  --JOIN AuditConduct ACN ON ACN.AuditComplianceId = AC.Id AND ACN.InActiveDateTime IS NULL
		  JOIN [User] U ON AC.CreatedByUserId = U.Id
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
		  LEFT JOIN Employee E ON E.UserId = U.Id
		  LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
		  LEFT JOIN Branch B ON B.ID = EB.BranchId AND B.InActiveDateTime IS NULL
		  LEFT JOIN #BranchIds BI ON BI.BranchId = EB.BranchId
		  --LEFT JOIN AuditComplianceSchedulingDetails ACSD ON ACSD.AuditComplianceId = AC.Id AND ACSD.InActiveDateTime IS NULL
		  LEFT JOIN CronExpression CE ON CE.CustomWidgetId = AC.Id AND CE.InActiveDateTime IS NULL and (CE.ispaused is null or CE.ispaused = 0)
		  WHERE AC.CompanyId = @CompanyId
		        AND (@MultipleBranchIds IS NULL OR BI.BranchId IS NOT NULL)
				AND (@AccessAllFeaturePermit = 1 OR AG.AuditId IS NOT NULL)
				--AND (AC.CreatedDateTime BETWEEN @StartDate AND @EndDate)
				AND AC.InActiveDateTime IS NULL
				AND (@ProjectId IS NULL OR AC.ProjectId = @ProjectId)
		 ) AS T 
		 WHERE T.ConductsCount > 0 OR T.IsRecurring = 1
		 ORDER BY AuditName ASC

		 IF(@@ROWCOUNT = 0)
		 BEGIN
			DECLARE @TOT INT, @DATEWISE INT
			SELECT @TOT = COUNT(*), @DATEWISE = SUM(CASE WHEN AC.CreatedDateTime BETWEEN @StartDate AND @EndDate THEN 1 ELSE 0 END) FROM AuditCompliance AC WHERE AC.CompanyId = @CompanyId
			IF(@TOT > 0)
			BEGIN
				IF(@DATEWISE > 0)
					RAISERROR(50027,11,1,'NoBranchMappedtoAudits')
				ELSE
					RAISERROR(50027,11,1,'NoAuditsInSelectedDates')
			END
			ELSE
			BEGIN
				RAISERROR(50027,11,1,'NoAuditsToShow')
			END
		 END
       	   
		END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END