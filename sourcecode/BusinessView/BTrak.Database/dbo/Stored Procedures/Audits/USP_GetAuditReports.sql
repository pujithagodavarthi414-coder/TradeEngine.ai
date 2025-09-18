CREATE PROCEDURE [dbo].[USP_GetAuditReports]
(
   @AuditReportId UNIQUEIDENTIFIER = NULL,
   @AuditReportName NVARCHAR(250) = NULL,
   @SearchText NVARCHAR(250)  = NULL,
   @IsArchived BIT = NULL,
   @IsForMail BIT = NULL,
   @IsForPdf BIT = NULL,
   @AuditConductId UNIQUEIDENTIFIER = NULL,
   @ProjectId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
          
		  IF(@IsArchived IS NULL) SET @IsArchived = 0
		  
		  IF(@IsForMail IS NULL) SET @IsForMail = 0
		  		  
		  IF(@IsForPdf IS NULL) SET @IsForPdf = 0

		  IF(@SearchText IS NULL) SET @SearchText = ''

		  SET @SearchText = '%' + @SearchText + '%'

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  DECLARE @AccessAllFeaturePermit BIT = (CASE WHEN EXISTS(SELECT 1 FROM [EntityRoleFeature] WHERE InActiveDateTime IS NULL 
														AND EntityRoleId IN (SELECT EntityRoleId FROM UserProject 
														                      WHERE ProjectId = @ProjectId 
																			        AND UserId = @OperationsPerformedBy
																					AND InActiveDateTime IS NULL
																			)
														AND EntityFeatureId = 'DDF63B16-43F7-46DD-895C-4A88657EB37E' ) THEN 1 ELSE 0 END)

		  IF(@AuditReportId IS NOT NULL AND @IsForPdf = 1)
			INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), (SELECT AuditComplianceId From AuditConduct WHERE Id = @AuditConductId GROUP BY AuditComplianceId), @AuditConductId, NULL, NULL, @AuditReportName, 'AuditReportPdfDownloaded', GETDATE(), @OperationsPerformedBy

		  IF(@AuditReportId IS NOT NULL AND @IsForMail = 1)
			INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), (SELECT AuditComplianceId From AuditConduct WHERE Id = @AuditConductId GROUP BY AuditComplianceId), @AuditConductId, NULL, NULL, @AuditReportName, 'AuditReportPdfShared', GETDATE(), @OperationsPerformedBy

		  SELECT AR.Id AS AuditReportId,
				 AC.AuditConductName,
				 AC.Id AS ConductId,
				 AR.AuditReportName,
				 AR.[AuditReportDescription],
				 AR.CreatedByUserId,
				 AR.CreatedDateTime,
				 AR.[TimeStamp],
				 (CASE WHEN AR.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,
				 U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedByUserName,
				 U.ProfileImage CreatedByProfileImage,
				 ISNULL(Q.QuestionsCount,0) AS QuestionsCount,
				 ISNULL(A.AnsweredCount,0) AS AnsweredCount,
				 ISNULL(Q.QuestionsCount,0) - ISNULL(A.AnsweredCount,0) AS UnAnsweredCount,
				 ISNULL(A.ConductScore,0) AS ConductScore,
				 AC.ProjectId,
				 AC.AuditRatingId,
				 ART.AuditRatingName
		  FROM AuditReport AR 
		  INNER JOIN AuditConduct AC ON AC.Id = AR.AuditConductId 
					 AND (@ProjectId IS NULL OR AC.ProjectId = @ProjectId)
		  INNER JOIN AuditCompliance ACC ON ACC.Id = AC.AuditComplianceId
		  INNER JOIN [User] U ON U.Id = AR.CreatedByUserId
		  LEFT JOIN AuditRating ART ON ART.Id = AC.AuditRatingId
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
									  AND (@ProjectId IS NULL OR @ProjectId = A.ProjectId)
				                AND (T.AuditId IS NULL OR T.Permission = 1 OR AG.TotalCount = AG.AGsCount)
				                GROUP BY A.Id,ISNULL(T.Permission,1)) AG ON AG.AuditId = ACC.Id 
		  LEFT JOIN(SELECT AC.AuditConductId,COUNT(DISTINCT AC.Id) AS QuestionsCount FROM AuditConductQuestions AC
							 INNER JOIN AuditConduct ACD ON ACD.Id = AC.AuditConductId
		                     INNER JOIN AuditCompliance ACM ON ACM.Id = ACD.AuditComplianceId AND ACM.CompanyId = @CompanyId
							 INNER JOIN AuditReport AR ON AR.AuditConductId = AC.AuditConductId AND AC.InActiveDateTime IS NULL 
													  AND AR.InActiveDateTime IS NULL 
							                          AND (@AuditReportId IS NULL OR AR.Id = @AuditReportId)
													  AND (@ProjectId IS NULL OR @ProjectId = ACM.ProjectId)
													  AND (@AuditConductId IS NULL OR AR.AuditConductId = @AuditConductId)
							 GROUP BY AC.AuditConductId) Q ON Q.AuditConductId = AR.AuditConductId
		  --LEFT JOIN(SELECT AC.AuditConductId,SUM(AQC.Score) AS ConductScore,COUNT(1) AS AnsweredCount FROM AuditConductSubmittedAnswer AQC
		  --                   INNER JOIN AuditConductQuestions AC ON AC.QuestionId = AQC.QuestionId AND AC.AuditConductId = AQC.ConductId AND AQC.InActiveDateTime IS NULL
				--			 INNER JOIN AuditConduct ACD ON ACD.Id = AC.AuditConductId
		  --                   INNER JOIN AuditCompliance ACM ON ACM.Id = ACD.AuditComplianceId AND ACM.CompanyId = @CompanyId
				--			 INNER JOIN AuditReport AR ON AR.AuditConductId = AC.AuditConductId AND AC.InActiveDateTime IS NULL 
				--			                          AND (@AuditReportId IS NULL OR AR.Id = @AuditReportId)
				--									  AND (@AuditConductId IS NULL OR AR.AuditConductId = @AuditConductId)
				--		     GROUP BY AC.AuditConductId) A ON A.AuditConductId = AR.AuditConductId
		  LEFT JOIN(SELECT AuditConductId,SUM(Score) AS ConductScore,COUNT(Answered) AS AnsweredCount FROM
		                     (SELECT AC.AuditConductId,AQC.Score,AQC.Id AS Answered
							  FROM AuditConductSubmittedAnswer AQC
							 INNER JOIN AuditConductQuestions AC ON AC.QuestionId = AQC.QuestionId AND AC.AuditConductId = AQC.ConductId AND AQC.InActiveDateTime IS NULL
							 INNER JOIN AuditConduct ACD ON ACD.Id = AC.AuditConductId
		                     INNER JOIN AuditCompliance ACM ON ACM.Id = ACD.AuditComplianceId AND ACM.CompanyId = @CompanyId
							 INNER JOIN AuditReport AR ON AR.AuditConductId = AC.AuditConductId AND AC.InActiveDateTime IS NULL 
							                          AND AR.InActiveDateTime IS NULL 
							                          AND (@AuditReportId IS NULL OR AR.Id = @AuditReportId)
													  AND (@AuditConductId IS NULL OR AR.AuditConductId = @AuditConductId)
													  AND (@ProjectId IS NULL OR @ProjectId = ACM.ProjectId)
						     GROUP BY AC.AuditConductId,AQC.Score,AQC.Id ) T
							 GROUP BY AuditConductId) A ON A.AuditConductId = AR.AuditConductId
		  WHERE  ACC.CompanyId = @CompanyId
		        AND (@AuditConductId IS NULL OR AR.AuditConductId = @AuditConductId)
		        AND (@AuditReportId IS NULL OR AR.Id = @AuditReportId)
		        AND (@AuditReportName IS NULL OR AR.AuditReportName = @AuditReportName)
				AND (@AccessAllFeaturePermit = 1 OR AG.AuditId IS NOT NULL)
				AND (@SearchText IS NULL OR (AR.AuditReportName LIKE @SearchText
				  OR  AR.AuditReportDescription LIKE  @SearchText))
				AND ((@IsArchived = 1 AND AR.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND AR.InActiveDateTime IS NULL))
		 ORDER BY AR.AuditReportName ASC

		END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO