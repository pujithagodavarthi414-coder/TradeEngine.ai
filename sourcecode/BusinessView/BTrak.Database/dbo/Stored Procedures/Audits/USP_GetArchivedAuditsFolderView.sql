CREATE PROCEDURE [dbo].[USP_GetArchivedAuditsFolderView]
(
   @AuditComplianceId UNIQUEIDENTIFIER = NULL,
   @MultipleAuditIdsXml XML = NULL,
   @AuditComplianceName NVARCHAR(150) = NULL,
   @AuditDescription NVARCHAR(800) = NULL,
   @SearchText NVARCHAR(250)  = NULL,
   @IsArchived BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @UserId UNIQUEIDENTIFIER = NULL,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @ResponsibleUserId UNIQUEIDENTIFIER = NULL,
   @PeriodValue NVARCHAR(250) = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @ProjectId UNIQUEIDENTIFIER = NULL,
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
          
		  IF(@IsArchived IS NULL)SET @IsArchived = 0

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		IF(@BusinessUnitIds = '') SET @BusinessUnitIds = NULL

		  DECLARE @AccessAllFeaturePermit BIT = (CASE WHEN EXISTS(SELECT 1 FROM [EntityRoleFeature] WHERE InActiveDateTime IS NULL 
														AND EntityRoleId IN (SELECT EntityRoleId FROM UserProject 
														                      WHERE ProjectId = @ProjectId 
																			        AND UserId = @OperationsPerformedBy
																					AND InActiveDateTime IS NULL
																			)
														AND EntityFeatureId = 'DDF63B16-43F7-46DD-895C-4A88657EB37E' ) THEN 1 ELSE 0 END)

		  CREATE TABLE #AuditIds
          (
            AuditId UNIQUEIDENTIFIER
          )
          IF(@MultipleAuditIdsXml IS NOT NULL)
          BEGIN
            
            INSERT INTO #AuditIds
            SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM  @MultipleAuditIdsXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
          
          END
          
		  DECLARE @FROMDATE DATE, @TODATE DATE
		  
		  IF(@PeriodValue = '' OR @PeriodValue = 'Select period') SET @PeriodValue = NULL

		  IF(@PeriodValue IS NOT NULL)
		  BEGIN

		  	SELECT @FROMDATE = (CASE @PeriodValue WHEN 'Current month' THEN DATEFROMPARTS(DATEPART(YEAR,GETUTCDATE()), DATEPART(MONTH,GETUTCDATE()), 1)
		  											WHEN 'Last month' THEN DATEFROMPARTS(DATEPART(YEAR,GETUTCDATE()), DATEPART(MONTH,GETUTCDATE())-1, 1) 
		  											WHEN 'Last 3 months' THEN DATEADD(MONTH, -3, GETUTCDATE())
		  											WHEN 'Last 6 months' THEN DATEADD(MONTH, -6, GETUTCDATE())
		  											WHEN 'Last 12 months' THEN  DATEADD(MONTH, -12, GETUTCDATE())
		  						END),
		  			@TODATE = (CASE @PeriodValue WHEN 'Current month' THEN EOMONTH(GETUTCDATE())
		  											WHEN 'Last month' THEN EOMONTH(DATEADD(MONTH, -1, GETUTCDATE()))
		  											WHEN 'Last 3 months' THEN GETUTCDATE()
		  											WHEN 'Last 6 months' THEN GETUTCDATE()
		  											WHEN 'Last 12 months' THEN GETUTCDATE()
		  											END)
		  END

		  CREATE TABLE #AuditComplianceWithFolders
		  (
				AuditId UNIQUEIDENTIFIER,
				AuditName NVARCHAR(250),
				AuditDescription NVARCHAR(800),
				[IsRAG] BIT,
				[CanLogTime] BIT,
				InBoundPercent FLOAT,
				OutBoundPercent FLOAT,
				CreatedByUserId UNIQUEIDENTIFIER,
				CreatedDateTime DATETIME,
				UpdatedDateTime DATETIME,
				[TimeStamp] VARBINARY(50),
				SpanInYears INT,
				SpanInMonths INT,
				SpanInDays INT,
				[SchedulingDetailsString] NVARCHAR(MAX),
				TotalEstimatedTime NVARCHAR(250),
				IsArchived BIT,
				CreatedByUserName NVARCHAR(250),
				CreatedByProfileImage NVARCHAR(800),
				ResponsibleUserName NVARCHAR(250),
				ResponsibleProfileImage NVARCHAR(800),
				ResponsibleUserId UNIQUEIDENTIFIER,
				AuditCategoriesCount INT,
                AuditQuestionsCount INT,
                ConductsCount INT,
				AuditTagsModelXml XML,
				EnableQuestionLevelWorkFlow BIT,
				ParentAuditId UNIQUEIDENTIFIER,
				ParentAuditName NVARCHAR(250),
				Lvl INT,
				FolderTimeStamp VARBINARY(50),
				ProjectId UNIQUEIDENTIFIER,
				IsAudit BIT,
				EnableWorkFlowForAudit BIT,
				EnableWorkFlowForAuditConduct BIT,
				[Status] NVARCHAR(250),
				HaveAuditVersions BIT,
				HaveCustomFields BIT
		  )

		  INSERT INTO #AuditComplianceWithFolders
		  SELECT AC.Id AS AuditId,
				 AC.AuditName,
				 AC.[Description] AS AuditDescription,
				 AC.[IsRAG],
				 AC.[CanLogTime],
				 AC.[InboundPercent] AS InBoundPercent,
				 AC.[OutboundPercent] AS OutBoundPercent,
				 AC.CreatedByUserId,
				 AC.CreatedDateTime,
				 AC.UpdatedDateTime,
				 AC.[TimeStamp],
				 AC.SpanInYears,
				 AC.SpanInMonths,
				 AC.SpanInDays,
				 (SELECT CE.CronExpression,
				 CE.JobId,
				 CE.Id AS CronExpressionId,
				 CE.IsPaused,
				 CE.EndDate AS ScheduleEndDate,
				 CE.ConductStartDate,
				 CE.ConductEndDate,
				 CE.[TimeStamp] AS CronExpressionTimeStamp,
				 ACSD.SpanInYears,
				 ACSD.SpanInMonths,
				 ACSD.SpanInDays,
				 CE.ResponsibleUserId,
				 (	SELECT DISTINCT ASQ.AuditQuestionId [QuestionId], AC.Id [AuditCategoryId] from AuditSelectedQuestion ASQ
					INNER JOIN AuditQuestions AQ ON ASQ.AuditQuestionId = AQ.Id 
					INNER JOIN AuditCategory AC ON AQ.AuditCategoryId = AC.Id AND ASQ.AuditComplianceId = AC.AuditComplianceId WHERE AuditSchedulingDetailsId = ACSD.Id FOR JSON PATH) [SelectedQuestions]
				 FROM  CronExpression CE
				 INNER JOIN [AuditComplianceSchedulingDetails] ACSD ON ACSD.AuditComplianceId = AC.Id AND ACSD.CronExpressionId = CE.Id AND ACSD.InActiveDateTime IS NULL
				  WHERE CE.CustomWidgetId = AC.Id AND CE.InActiveDateTime IS NULL FOR JSON PATH) [SchedulingDetailsString],
				  (SELECT CAST(CAST(SUM(ISNULL(AQ.EstimatedTime,0)) AS FLOAT) AS NVARCHAR(250)) Estimate 
                    FROM AuditQuestions AQ INNER JOIN AuditCategory ACC ON ACC.Id = AQ.AuditCategoryId AND ACC.InActiveDateTime IS NULL AND AQ.InActiveDateTime IS NULL
	                WHERE ACC.AuditComplianceId = AC.Id) AS TotalEstimatedTime,
				 (CASE WHEN AC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,
				 U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedByUserName,
				 U.ProfileImage AS CreatedByProfileImage,
				 UUU.FirstName + ' ' + ISNULL(UUU.SurName,'') AS ResponsibleUserName,
				 UUU.ProfileImage AS ResponsibleProfileImage,
				 AC.ResposibleUserId  ResponsibleUserId,
				 ISNULL((SELECT COUNT(1) FROM AuditCategory AC1 WHERE AC1.AuditComplianceId = AC.Id AND AC1.InActiveDateTime IS NULL),0) AS AuditCategoriesCount,
                 ISNULL((SELECT COUNT(1) FROM AuditQuestions AQ1 INNER JOIN AuditCategory AC1 ON AC1.Id = AQ1.AuditCategoryId AND AC1.InActiveDateTime IS NULL
									                      INNER JOIN QuestionTypes QT ON QT.Id = AQ1.QuestionTypeId AND QT.InActiveDateTime IS NULL
                                                            WHERE AC1.AuditComplianceId = AC.Id AND AQ1.InActiveDateTime IS NULL),0) AS AuditQuestionsCount
                ,ISNULL((SELECT COUNT(1) FROM AuditConduct WHERE [AuditComplianceId] = AC.Id AND InactiveDateTime IS NULL),0) AS ConductsCount
				,(SELECT AG.TagId,AG.TagName FROM AuditTags AG WHERE AG.AuditId = AC.Id AND AG.AuditConductId IS NULL AND AG.InActiveDateTime IS NULL FOR XML PATH('AuditTagsModel'), ROOT('AuditTagsModel'), TYPE) AS AuditTagsModelXml
				,AC.EnableQuestionLevelWorkFlow
				,AC.AuditFolderId ParentAuditId
				,AF.AuditFolderName ParentAuditName
				,0 Lvl
				,CAST(0 AS VARBINARY) AS FolderTimeStamp
				,AC.ProjectId
				,1 IsAudit
				,AC.EnableWorkFlowForAudit
				,AC.EnableWorkFlowForAuditConduct
				,GS.[Status]
				,CASE WHEN EXISTS(SELECT 1 FROM AuditComplianceVersions WHERE AuditId = AC.Id AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END AS HaveAuditVersions
				,CASE WHEN EXISTS(SELECT Id FROM CustomField F WHERE ReferenceId = AC.Id AND  F.InactiveDateTime IS NULL) THEN 1 ELSE 0 END HaveCustomFields
		  FROM AuditCompliance AC
		  JOIN [User] U ON AC.CreatedByUserId = U.Id
		  JOIN [User] UUU ON AC.ResposibleUserId = UUU.Id
		  LEFT JOIN Employee E ON E.UserId = U.Id
		  LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id 
		  LEFT JOIN [GenericStatus] GS ON GS.ReferenceId = AC.Id AND GS.CompanyId = @CompanyId AND GS.ReferenceTypeId = '1618EA33-ACE8-4838-9658-B8E713CEB9DB' AND GS.IsArchived IS NULL
		  LEFT JOIN (SELECT A.Id AS AuditId,ISNULL(T.Permission,1) Permission FROM AuditCompliance A 
			       LEFT JOIN(
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
			                 	    WHERE A.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy) 
			                 	    AND (T.AuditId IS NULL OR T.Permission = 1 OR AG.TotalCount = AG.AGsCount)
									AND (@BusinessUnitIds IS NULL OR T.Permission = 1) 
			                 	    GROUP BY A.Id,ISNULL(T.Permission,1)) AG ON AG.AuditId = AC.Id
          LEFT JOIN #AuditIds T ON T.AuditId = AC.Id
		  LEFT JOIN AuditFolder AF ON AF.Id = AC.AuditFolderId AND AF.InActiveDateTime IS NULL
		  WHERE AC.CompanyId = @CompanyId
		        AND (@AuditComplianceId IS NULL OR AC.Id = @AuditComplianceId)
				AND (@UserId IS NULL OR U.Id = @UserId)
				AND (@ResponsibleUserId IS NULL OR UUU.Id = @ResponsibleUserId)
		        AND (@AuditComplianceName IS NULL OR AuditName = @AuditComplianceName)
				AND (@AuditDescription IS NULL OR AC.[Description] = @AuditDescription)
				AND (@BusinessUnitIds IS NULL OR AG.AuditId IS NOT NULL) 
				AND (@AccessAllFeaturePermit = 1 OR AG.AuditId IS NOT NULL)
				AND (@SearchText IS NULL OR AuditName LIKE  '%'+ @SearchText +'%' OR AC.[Description] LIKE '%'+ @SearchText +'%')
				AND ((@IsArchived = 1 AND AC.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND AC.InActiveDateTime IS NULL))
                AND (@MultipleAuditIdsXml IS NULL OR T.AuditId IS NOT NULL)
				AND ((AC.CreatedDateTime BETWEEN @DateFrom AND @DateTo) OR (@DateFrom IS NULL AND @DateTo IS NULL))
				AND (@PeriodValue IS NULL OR (AC.CreatedDateTime BETWEEN @FROMDATE AND @TODATE))	
				AND (@BranchId IS NULL OR EB.BranchId = @BranchId)
				AND (@ProjectId IS NULL OR AC.ProjectId = @ProjectId)
				AND AC.InActiveDateTime IS NOT NULL
		 ORDER BY AuditName ASC
       	  
		 CREATE TABLE #AuditFolder
		 (
			Id INT IDENTITY(1,1),
			AuditFolderId UNIQUEIDENTIFIER
		 )
		 INSERT INTO #AuditFolder(AuditFolderId)
		 SELECT DISTINCT ParentAuditId FROM #AuditComplianceWithFolders

		 DECLARE @AuditFolderCounter INT = 1, @AuditFolderCount INT, @AuditFolderId UNIQUEIDENTIFIER

		 SELECT @AuditFolderCount = COUNT(1) FROM #AuditFolder

		 WHILE(@AuditFolderCounter <= @AuditFolderCount)
		 BEGIN

			SELECT @AuditFolderId = AuditFolderId FROM #AuditFolder WHERE Id = @AuditFolderCounter

			INSERT INTO #AuditComplianceWithFolders(ProjectId,AuditId,AuditName,ParentAuditId,ParentAuditName,[FolderTimeStamp],Lvl,IsAudit, CreatedDateTime, UpdatedDateTime)
			SELECT APF.ProjectId,APF.Id,APF.AuditFolderName,APF.ParentAuditFolderId,AF.AuditFolderName,APF.[TimeStamp],lvl,0, APF.CreatedDateTime, APF.UpdatedDateTime
			FROM dbo.Ufn_GetAuditParentFolders(@AuditFolderId) APF
			     LEFT JOIN AuditFolder AF ON AF.Id = APF.ParentAuditFolderId
			WHERE APF.Id NOT IN (SELECT AuditId FROM #AuditComplianceWithFolders)
			 AND APF.CompanyId = @CompanyId

			SET @AuditFolderCounter = @AuditFolderCounter + 1

		 END

		 SELECT * FROM #AuditComplianceWithFolders ORDER BY UpdatedDateTime, AuditName

		END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END

