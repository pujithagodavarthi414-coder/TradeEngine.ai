--EXEC [dbo].[USP_GetAuditsRelatedCounts] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetAuditsRelatedCounts]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER
 ,@ProjectId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

        IF(@HavePermission = '1')
        BEGIN

            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

            DECLARE @AccessAllFeaturePermit BIT = (CASE WHEN EXISTS(SELECT 1 FROM [EntityRoleFeature] WHERE InActiveDateTime IS NULL 
														AND EntityRoleId IN (SELECT EntityRoleId FROM UserProject 
														                      WHERE ProjectId = @ProjectId 
																			        AND UserId = @OperationsPerformedBy
																					AND InActiveDateTime IS NULL
																			)
														AND EntityFeatureId = 'DDF63B16-43F7-46DD-895C-4A88657EB37E' ) THEN 1 ELSE 0 END)

            CREATE TABLE #Temp(AuditId UNIQUEIDENTIFIER,Permission BIT)

            INSERT INTO #Temp
            SELECT A.Id,ISNULL(T.Permission,1) Permission FROM AuditCompliance A 
			       LEFT JOIN(
                             SELECT AG.AuditId,IIF(AG.TagId = @OperationsPerformedBy OR UR.Id IS NOT NULL OR EB.Id IS NOT NULL OR BU.BusinessUnitId IS NOT NULL,1,0) AS Permission
		                            FROM AuditTags AG
			                 	    JOIN Employee E ON E.UserId = @OperationsPerformedBy AND AG.InActiveDateTime IS NULL
			                 	    LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.BranchId = AG.TagId 
                                          AND (EB.ActiveFrom < GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo > GETDATE()))
			                 	    LEFT JOIN [UserRole] UR ON UR.UserId = E.UserId AND UR.RoleId = AG.TagId AND UR.InactiveDateTime IS NULL
									LEFT JOIN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](@OperationsPerformedBy,@CompanyId,NULL)) BU ON BU.BusinessUnitId = AG.TagId
			                 	    ) T ON T.AuditId = A.Id
                    LEFT JOIN (SELECT AuditId,COUNT(CASE WHEN A.Id IS NOT NULL OR GFK.Id IS NOT NULL THEN 1 ELSE NULL END ) AGsCount,COUNT(1) TotalCount
	                                               FROM AuditTags AT
												        INNER JOIN [User] U On U.Id = AT.CreatedByUserId AND U.CompanyId = @CompanyId
	                                                    LEFT JOIN Asset A ON A.Id = AT.TagId
	  	                                              LEFT JOIN CustomApplicationTag GFK ON GFK.Id = AT.TagId
	                                                WHERE AT.InActiveDateTime IS NULL
													--A.Id IS NOT NULL OR GFK.Id IS NOT NULL
	                                               GROUP BY AuditId) AG ON AG.AuditId = A.Id
			                 	    WHERE A.CompanyId = @CompanyId
                                          AND (@ProjectId IS NULL OR A.ProjectId = @ProjectId)
			                 	    AND (T.AuditId IS NULL OR T.Permission = 1 OR AG.TotalCount = AG.AGsCount)
			                 	    GROUP BY A.Id,ISNULL(T.Permission,1)

            SELECT @ProjectId AS ProjectId,
                    ISNULL((SELECT COUNT(1) FROM AuditCompliance AC1 LEFT JOIN #Temp T ON T.AuditId = AC1.Id  WHERE InactiveDateTime IS NULL AND CompanyId = @CompanyId AND (@ProjectId IS NULL OR AC1.ProjectId = @ProjectId) AND (@AccessAllFeaturePermit = 1 OR T.AuditId IS NOT NULL)),0) AS ActiveAuditsCount,
					ISNULL((SELECT COUNT(1) FROM AuditCompliance AC1 LEFT JOIN #Temp T ON T.AuditId = AC1.Id  WHERE InactiveDateTime IS NOT NULL AND CompanyId = @CompanyId AND (@ProjectId IS NULL OR AC1.ProjectId = @ProjectId) AND (@AccessAllFeaturePermit = 1 OR T.AuditId IS NOT NULL)),0) AS ArchivedAuditsCount,
					ISNULL((SELECT COUNT(1) FROM AuditConduct AC1 JOIN AuditCompliance AC2 ON AC2.Id = AC1.AuditComplianceId LEFT JOIN #Temp T ON T.AuditId = AC2.Id AND AC2.InactiveDateTime IS NULL AND AC2.CompanyId = @CompanyId WHERE AC1.InActiveDateTime IS NULL AND (@ProjectId IS NULL OR AC1.ProjectId = @ProjectId) AND (@AccessAllFeaturePermit = 1 OR T.AuditId IS NOT NULL) AND AC2.InactiveDateTime IS NULL AND AC2.CompanyId = @CompanyId),0) AS ActiveAuditConductsCount,
					ISNULL((SELECT COUNT(1) FROM AuditConduct AC1 JOIN AuditCompliance AC2 ON AC2.Id = AC1.AuditComplianceId LEFT JOIN #Temp T ON T.AuditId = AC2.Id  AND AC2.InactiveDateTime IS NULL AND AC2.CompanyId = @CompanyId WHERE AC1.InActiveDateTime IS NOT NULL AND (@ProjectId IS NULL OR AC1.ProjectId = @ProjectId) AND (@AccessAllFeaturePermit = 1 OR T.AuditId IS NOT NULL) AND AC2.InactiveDateTime IS NULL AND AC2.CompanyId = @CompanyId),0) AS ArchivedAuditConductsCount,
					ISNULL((SELECT COUNT(1) FROM AuditReport AC1 JOIN AuditConduct AC2 ON AC2.Id = AC1.AuditConductId AND AC2.InactiveDateTime IS NULL 
                                                                 JOIN AuditCompliance AC3 ON AC3.Id = AC2.AuditComplianceId AND AC3.InactiveDateTime IS NULL AND AC3.CompanyId = @CompanyId
																 LEFT JOIN #Temp T ON T.AuditId = AC3.Id 
                             WHERE AC1.InActiveDateTime IS NULL AND (@ProjectId IS NULL OR AC3.ProjectId = @ProjectId) AND (@AccessAllFeaturePermit = 1 OR T.AuditId IS NOT NULL)),0) AS ActiveAuditReportsCount,
					ISNULL((SELECT COUNT(1) FROM AuditReport AC1 JOIN AuditConduct AC2 ON AC2.Id = AC1.AuditConductId AND AC2.InactiveDateTime IS NULL 
                                                                 JOIN AuditCompliance AC3 ON AC3.Id = AC2.AuditComplianceId AND AC3.InactiveDateTime IS NULL AND AC3.CompanyId = @CompanyId
																 LEFT JOIN #Temp T ON T.AuditId = AC3.Id 
                             WHERE AC1.InActiveDateTime IS NOT NULL AND (@ProjectId IS NULL OR AC3.ProjectId = @ProjectId) AND (@AccessAllFeaturePermit = 1 OR T.AuditId IS NOT NULL)),0) AS ArchivedAuditReportsCount,
                    ISNULL((SELECT DISTINCT COUNT(1) FROM UserStory US
                                LEFT JOIN [AuditConductQuestions] ACQ ON ACQ.Id = US.AuditConductQuestionId
								LEFT JOIN AuditConduct AC2 ON AC2.Id = ACQ.AuditConductId AND AC2.InactiveDateTime IS NULL 
                                LEFT JOIN AuditCompliance AC3 ON AC3.Id = AC2.AuditComplianceId AND AC3.InactiveDateTime IS NULL AND AC3.CompanyId = @CompanyId
								LEFT JOIN #Temp T ON T.AuditId = AC3.Id 
				                INNER JOIN UserStoryType UST WITH(NOLOCK) ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL 
                                                                          AND US.ParkedDateTime IS NULL AND US.ArchivedDateTime IS NULL AND US.OwnerUserId IS NOT NULL
                                                                          AND UST.IsAction = 1 AND US.InActiveDateTime IS NULL AND UST.CompanyId = @CompanyId
					            INNER JOIN [UserStoryStatus] USSS ON USSS.Id = US.UserStoryStatusId AND USSS.InactiveDateTime IS NULL
				                INNER JOIN [TaskStatus] TS ON TS.Id = USSS.TaskStatusId
                                INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
                                INNER JOIN Project PR ON PR.Id = US.ProjectId AND PR.InActiveDateTime IS NULL AND PR.CompanyId = @CompanyId
                             WHERE (@ProjectId IS NULL OR US.ProjectId = @ProjectId)), 0) AS ActionsCount,
                  
                  ISNULL((SELECT COUNT(1) FROM AuditFolder WHERE CompanyId = @CompanyId AND (@ProjectId IS NULL OR ProjectId = @ProjectId) AND InActiveDateTime IS NULL),0) ActiveAuditFoldersCount, 
                  ISNULL((SELECT COUNT(1) FROM AuditFolder WHERE CompanyId = @CompanyId AND (@ProjectId IS NULL OR ProjectId = @ProjectId) AND InActiveDateTime IS NOT NULL),0) ArchivedAuditFoldersCount
        
        END
        ELSE
            
            RAISERROR(50008,11,1)

    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO
