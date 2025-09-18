------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-06-01 00:00:00.000'
-- Purpose      To Get the Audit Overall Activity History 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetOverallAuditActivity] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetOverallAuditActivity]
(
  @QuestionId UNIQUEIDENTIFIER = NULL,
  @AuditId UNIQUEIDENTIFIER = NULL,
  @ConductId UNIQUEIDENTIFIER = NULL,
  @UserIdsXml XML = NULL,
  @BranchIdsXml XML = NULL,
  @AuditsXml XML = NULL,
  @DateFrom DATE = NULL,
  @DateTo DATE = NULL,
  @PageNo INT = 1,
  @PageSize INT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsActionInculde BIT = NULL,
  @ProjectId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
      
	   DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
       
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
           
           IF(@QuestionId = '00000000-0000-0000-0000-000000000000') SET  @QuestionId = NULL
           
           IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET  @ProjectId = NULL
           
           IF(@AuditId = '00000000-0000-0000-0000-000000000000') SET  @AuditId = NULL
                      
           IF(@ConductId = '00000000-0000-0000-0000-000000000000') SET  @ConductId = NULL

           IF(@IsActionInculde = NULL) SET  @IsActionInculde = 0
           
           --IF(@DateFrom IS NULL) SET  @DateFrom = EOMONTH(GETDATE(),-1)

           IF(@PageNo IS NULL OR @PageNo = 0) SET @PageNo = 1

           IF(@PageSize IS NULL OR @PageSize = 0) SET @PageSize = 30000 --2147483647 -- INTEGER MAX NUMBER 

           IF(@ConductId = '00000000-0000-0000-0000-000000000000') SET  @ConductId = NULL

            CREATE TABLE #UserIds
		    (
		    	Id UNIQUEIDENTIFIER 
		    )

            CREATE TABLE #BranchIds
		    (
		    	Id UNIQUEIDENTIFIER 
		    )

           CREATE TABLE #AuditIds
		    (
		    	Id UNIQUEIDENTIFIER 
		    )

        IF(@UserIdsXml IS NOT NULL)
		BEGIN
			
			INSERT INTO #UserIds(Id)
			SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
			FROM @UserIdsXml.nodes('/GenericListOfGuid/ListItems/guid') AS X(Y)

		END
		
		IF(@BranchIdsXml IS NOT NULL)
		BEGIN
			
			INSERT INTO #BranchIds(Id)
			SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
			FROM @BranchIdsXml.nodes('/GenericListOfGuid/ListItems/guid') AS X(Y)

		END

		IF(@AuditsXml IS NOT NULL)
		BEGIN
			
			INSERT INTO #AuditIds(Id)
			SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
			FROM @AuditsXml.nodes('/GenericListOfGuid/ListItems/guid') AS X(Y)

		END
		   SELECT *,TotalCount = COUNT(1) OVER() FROM (
		   SELECT AQH.Id AS AuditQuestionHistoryId,
                  AQH.ConductId,
                  AQH.OldValue,
                  AQH.NewValue,
                  AQH.Field,
                  --AC.AuditName,
                  CASE WHEN AQH.ConductId IS NULL THEN (SELECT AuditName FROM AuditCompliance WHERE Id = AQH.AuditId)
                        WHEN AQH.ConductId IS NOT NULL THEN (SELECT AuditConductName FROM AuditConduct WHERE Id = AQH.ConductId) END AS AuditName,
                  CASE WHEN AQH.ConductId IS NULL AND AQH.QuestionId IS NOT NULL THEN (SELECT QuestionName FROM AuditQuestions WHERE Id = AQH.QuestionId)
                        WHEN AQH.ConductId IS NOT NULL AND AQH.QuestionId IS NOT NULL THEN (SELECT QuestionName FROM AuditConductQuestions WHERE QuestionId = AQH.QuestionId AND AuditConductId = AQH.ConductId) END AS QuestionName,
				  CASE WHEN AQH.UserStoryId IS NOT NULL THEN (SELECT UserStoryName FROM UserStory WHERE Id = AQH.UserStoryId)END AS UserStoryName,
                  AQH.[Description],
                  AQH.CreatedByUserId,
                  AQH.CreatedDateTime,
                  U.FirstName +' '+ISNULL(U.SurName,'') as PerformedByUserName,
                  U.ProfileImage AS PerformedByUserProfileImage
           FROM  [dbo].[AuditQuestionHistory] AQH WITH (NOLOCK)
                 INNER JOIN [dbo].[User] U ON U.Id = AQH.CreatedByUserId
                 INNER JOIN [Employee] E ON E.UserId = U.Id
                 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
                 LEFT JOIN AuditCompliance AC ON AC.Id = AQH.AuditId
                 LEFT JOIN AuditConduct ACC ON ACC.Id = AQH.ConductId
                 LEFT JOIN (SELECT A.Id AS AuditId,ISNULL(T.Permission,1) Permission FROM AuditCompliance A 
			       LEFT JOIN(
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
			                 	    AND (@ProjectId IS NULL OR A.ProjectId = @ProjectId)
                                    AND (T.AuditId IS NULL OR T.Permission = 1 OR AG.TotalCount = AG.AGsCount)
                                    AND A.InActiveDateTime IS NULL
			                 	    GROUP BY A.Id,ISNULL(T.Permission,1)) AG ON AG.AuditId = AQH.AuditId
                 --LEFT JOIN AuditReport AR ON AR.AuditConductId = ACC.Id
                 LEFT JOIN UserStory US ON US.Id = AQH.UserStoryId
                 LEFT JOIN AuditFolder AF ON AF.Id= AQH.FolderId
                 LEFT JOIN #UserIds UI ON UI.Id = U.Id
                 LEFT JOIN #BranchIds BI ON BI.Id = EB.BranchId
                 LEFT JOIN #AuditIds AI ON (AI.Id = AC.Id OR AI.Id = ACC.AuditComplianceId)
           WHERE U.CompanyId = @CompanyId 
                 AND (@ProjectId IS NULL OR AQH.Id IN (SELECT AQH.Id
                                                           FROM [AuditQuestionHistory] AQH 
                                                                INNER JOIN AuditCompliance AC ON AC.Id = AQH.AuditId
																           AND @ProjectId = AC.ProjectId
                                                           UNION
                                                           SELECT AQH.Id 
                                                           FROM [AuditQuestionHistory] AQH 
                                                                INNER JOIN AuditFolder AC ON AC.Id = AQH.FolderId
																           AND @ProjectId = AC.ProjectId
                                                           UNION 
                                                           SELECT AQH.Id 
                                                           FROM [AuditQuestionHistory] AQH 
                                                                INNER JOIN UserStory AC ON AC.Id = AQH.UserStoryId
																           AND @ProjectId = AC.ProjectId
                                                           )
                      )
			     AND (@IsActionInculde = 1 OR AQH.IsAction = 0)
                 --AND (@ProjectId IS NULL OR AC.ProjectId = @ProjectId)
                 --AND (ACC.Id IS NULL OR (@AccessAllFeaturePermit = 1 OR AG.AuditId IS NOT NULL))
                 AND (@AccessAllFeaturePermit = 1 
                       OR (AQH.AuditId IS NULL AND AQH.UserStoryId IS NOT NULL AND (@ProjectId IS NULL OR US.ProjectId = @ProjectId)) 
                       OR AG.AuditId IS NOT NULL 
                       OR (AQH.FolderId IS NOT NULL AND (@ProjectId IS NULL OR US.ProjectId = @ProjectId)))
                 AND ((AQH.AuditId IS NULL AND AQH.UserStoryId IS NOT NULL AND (@ProjectId IS NULL OR US.ProjectId = @ProjectId)) 
                       OR ((@QuestionId IS NULL OR AQH.QuestionId = @QuestionId)
				 AND (@AuditId IS NULL OR AQH.AuditId = @AuditId)
				 AND (@ConductId IS NULL OR AQH.ConductId = @ConductId)
                 AND (@UserIdsXml IS NULL OR UI.Id IS NOT NULL)
                 AND (@BranchIdsXml IS NULL OR BI.Id IS NOT NULL)
                 AND (@AuditsXml IS NULL OR AI.Id IS NOT NULL)) )
                 AND (@DateFrom IS NULL OR CONVERT(DATE,AQH.CreatedDateTime) >= @DateFrom)
                 AND (@DateTo IS NULL OR CONVERT(DATE,AQH.CreatedDateTime) <= @DateTo)
		) T
           ORDER BY CreatedDateTime DESC
            OFFSET ((@PageNo - 1) * @PageSize) ROWS
                FETCH NEXT @PageSize ROWS ONLY
           
        
        END
        ELSE
           RAISERROR (@HavePermission,11, 1)

     END TRY  
     BEGIN CATCH 
        
          THROW

    END CATCH
END
GO