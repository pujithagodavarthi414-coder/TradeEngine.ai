CREATE PROCEDURE [dbo].[USP_GetArchivedConductsFolderView]
(
   @AuditConductId UNIQUEIDENTIFIER = NULL,
   @AuditConductName NVARCHAR(250) = NULL,
   @SearchText NVARCHAR(250)  = NULL,
   @IsArchived BIT = NULL,
   @AuditComplianceId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsCompleted BIT = NULL,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @UserId UNIQUEIDENTIFIER = NULL,
   @PeriodValue NVARCHAR(250) = NULL,
   @StatusFilter NVARCHAR(250) = NULL,
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
          
			IF(@IsArchived IS NULL) SET @IsArchived = 0

			IF(@IsCompleted IS NULL) SET @IsCompleted = 0
		IF(@BusinessUnitIds = '') SET @BusinessUnitIds = NULL

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

			CREATE TABLE #AuditConductWithFolders
		  (
				AuditId UNIQUEIDENTIFIER,
				AuditName NVARCHAR(250),
				AuditDescription NVARCHAR(800),
				[IsRAG] BIT,
				[CanLogTime] BIT,
				InBoundPercent FLOAT,
				OutBoundPercent FLOAT,
				ConductId UNIQUEIDENTIFIER,
				AuditConductName NVARCHAR(250),
				AuditConductDescription NVARCHAR(800),
				IsCompleted BIT,
				IsIncludeAllQuestions BIT,
				DeadlineDate DATETIME,
				IsConductEditable BIT,
				CreatedByUserId UNIQUEIDENTIFIER,
				CreatedDateTime DATETIME,
				UpdatedDateTime DATETIME,
				UpdatedByUserId UNIQUEIDENTIFIER,
				[TimeStamp] VARBINARY(50),
				IsArchived BIT,
				CreatedByUserName NVARCHAR(250),
				CreatedUserMail NVARCHAR(250),
				UpdatedByUserName NVARCHAR(250),
				UpdatedUserMail NVARCHAR(250),
				ResponsibleUserName NVARCHAR(250),
				ConductAssigneeMail NVARCHAR(250),
				AuditResponsibleUserMail NVARCHAR(250),
				ResponsibleProfileImage NVARCHAR(800),
				ResponsibleUserId UNIQUEIDENTIFIER,
				CreatedByProfileImage NVARCHAR(800),
				IsConductSubmitted BIT,
				CanConductSubmitted BIT,
				AreActionsAdded BIT,
				AreDocumentsUploaded BIT,
				TotalEstimatedTime NVARCHAR(250),
				TotalSpentTime NVARCHAR(250),
				QuestionsCount INT,
				ConductScore INT,
				AnsweredCount INT,
				ValidAnswersCount INT,
				AuditTagsModelXml XML,
				ConductTagsModelXml XML,
				ParentConductId UNIQUEIDENTIFIER,
				ParentAuditConductName NVARCHAR(250),
				Lvl INT,
				[FolderTimeStamp] VARBINARY(50),
				ProjectId UNIQUEIDENTIFIER,
				IsConduct BIT,
				[Status] NVARCHAR(250),
				AuditRatingId   UNIQUEIDENTIFIER,
				AuditRatingName NVARCHAR(250),
				HaveCustomFields BIT
		  )

			INSERT INTO #AuditConductWithFolders
			SELECT * 
			FROM (
				SELECT ACM.Id AS AuditId,
					 ACM.AuditName,
					 ACM.[Description] AS AuditDescription,
					 ACM.IsRAG,
					 ACM.CanLogTime,
					 ACM.InboundPercent AS InBoundPercent,
					 ACM.OutboundPercent AS OutBoundPercent,
					 AC.Id AS ConductId,
					 AC.AuditConductName,
					 AC.[Description] AuditConductDescription,
					 ISNULL(AC.[IsCompleted],0) AS IsCompleted,
					 ISNULL(AC.[IsIncludeAllQuestions],0) AS IsIncludeAllQuestions,
					 AC.DeadlineDate,
					 (CASE WHEN (AC.DeadlineDate IS NULL OR cast(GETDATE() as date) <= cast(AC.DeadlineDate as date)) THEN 1 ELSE 0 END) AS IsConductEditable,
					 AC.CreatedByUserId,
					 AC.CreatedDateTime,
					 AC.UpdatedDateTime,
					 AC.UpdatedByUserId,
					 AC.[TimeStamp],
					 (CASE WHEN AC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,
					 U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedByUserName,
					 U.UserName CreatedUserMail,
					 UU.FirstName + ' ' + ISNULL(UU.SurName,'') AS UpdatedByUserName,
					 UU.UserName UpdatedUserMail,
					 URR.FirstName + ' ' + ISNULL(URR.SurName,'') AS ResponsibleUserName,
					  IIF(AC.ResponsibleUserId IS NOT NULL,
					 (SELECT UserName From [User] WHERE CompanyId = @CompanyId AND Id = AC.ResponsibleUserId),NULL) AS ConductAssigneeMail,
					 IIF(ACM.ResposibleUserId IS NOT NULL,
					 (SELECT UserName From [User] WHERE CompanyId = @CompanyId AND Id = ACM.ResposibleUserId),NULL) AS AuditResponsibleUserMail,
				     URR.ProfileImage AS ResponsibleProfileImage,
					 AC.ResponsibleUserId  ResponsibleUserId,
					 U.ProfileImage CreatedByProfileImage,
					 IsCompleted AS IsConductSubmitted,
					 (SELECT [dbo].[Ufn_ValidateConductSubmit](AC.Id,1,@OperationsPerformedBy)) AS CanConductSubmitted,
					 (SELECT [dbo].[Ufn_ValidateConductSubmit](AC.Id,0,@OperationsPerformedBy)) AS AreActionsAdded,
					 (SELECT [dbo].[Ufn_ValidateConductSubmit](AC.Id,NULL,@OperationsPerformedBy)) AS AreDocumentsUploaded,
					 (SELECT CAST(CAST(SUM(ISNULL(ACQ.EstimatedTime,0)) AS FLOAT) AS NVARCHAR(250)) Estimate 
						FROM AuditConductQuestions ACQ  
						WHERE ACQ.InActiveDateTime IS NULL AND ACQ.AuditConductId = AC.Id) AS TotalEstimatedTime,
					
					(SELECT CAST(CAST(SUM(ISNULL(USST.SpentTimeInMin * 1.0,0)) / 60.0 AS FLOAT) AS NVARCHAR(250)) Estimate 
                    FROM AuditConductQuestions ACQ INNER JOIN UserStorySpentTime USST ON USST.UserStoryId = ACQ.Id AND USST.InActiveDateTime IS NULL AND ACQ.InActiveDateTime IS NULL
	                WHERE ACQ.AuditConductId = AC.Id) AS TotalSpentTime,

					 ISNULL((SELECT COUNT(1) FROM AuditConductQuestions WHERE AuditConductId = AC.Id AND InActiveDateTime IS NULL),0) AS QuestionsCount,
					 ISNULL((SELECT SUM(Score) FROM AuditConductSubmittedAnswer WHERE ConductId = AC.Id AND InActiveDateTime IS NULL),0) AS ConductScore,
					 ISNULL((SELECT COUNT(1) FROM AuditConductSubmittedAnswer ACSA
											  JOIN AuditConductQuestions ACQ ON ACQ.QuestionId = ACSA.QuestionId AND ACQ.AuditConductId = AC.Id AND ACSA.ConductId = AC.Id
												 AND ACQ.InActiveDateTime IS NULL AND ACSA.InActiveDateTime IS NULL), 0) AS AnsweredCount,
					 ISNULL((SELECT COUNT(1) FROM AuditConductSubmittedAnswer ACSA
											  JOIN AuditConductAnswers ACS ON ACSA.AuditAnswerId = ACS.Id 
												AND ACS.AuditConductId = AC.Id AND ACSA.ConductId = AC.Id AND ACS.QuestionOptionResult = 1 
												AND ACSA.InActiveDateTime IS NULL AND ACS.InActiveDateTime IS NULL), 0) AS ValidAnswersCount,
					(SELECT AG.TagId,AG.TagName FROM AuditTags AG WHERE AG.AuditId = ACM.Id AND AG.InActiveDateTime IS NULL AND AG.AuditConductId IS NULL FOR XML PATH('AuditTagsModel'), ROOT('AuditTagsModel'), TYPE) AS AuditTagsModelXml,
					(SELECT AG.TagId,AG.TagName FROM AuditTags AG WHERE AG.AuditConductId = AC.Id AND AG.InActiveDateTime IS NULL FOR XML PATH('AuditTagsModel'), ROOT('AuditTagsModel'), TYPE) AS ConductTagsModelXml,
					AF.Id ParentConductId,
					AF.AuditFolderName ParentAuditConductName,
					0 Lvl,
					CAST(0 AS VARBINARY) AS FolderTimeStamp,
					AC.ProjectId,
					1 IsConduct,
					GS.[Status],
					AC.AuditRatingId,
					AR.AuditRatingName,
					CASE WHEN EXISTS(SELECT Id FROM CustomField F WHERE ReferenceId = AC.Id AND  F.InactiveDateTime IS NULL) THEN 1 ELSE 0 END HaveCustomFields
				  FROM AuditConduct AC
				  INNER JOIN AuditCompliance ACM ON ACM.Id = AC.AuditComplianceId
				  INNER JOIN [User] U ON U.Id = AC.CreatedByUserId
				  INNER JOIN [User] URR ON URR.Id = AC.ResponsibleUserId
				  LEFT JOIN EMPLOYEE E ON E.UserId = U.Id
				  LEFT JOIN AuditRating AR ON AR.Id = AC.AuditRatingId
				  LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id 
				  LEFT JOIN [GenericStatus] GS ON GS.ReferenceId = AC.Id AND GS.CompanyId = @CompanyId AND GS.ReferenceTypeId = '0ffd91f7-e1a3-44e1-a304-85e62745f25b' AND GS.IsArchived IS NULL
				  LEFT JOIN (SELECT A.Id AS AuditId,ISNULL(T.Permission,1) Permission FROM AuditCompliance A 
							   LEFT JOIN(
										 SELECT AG.AuditId,IIF(AG.TagId = @OperationsPerformedBy OR UR.Id IS NOT NULL OR EB.Id IS NOT NULL OR BU.BusinessUnitId IS NOT NULL,1,0) AS Permission
												FROM AuditTags AG
			                 					JOIN Employee E ON E.UserId = @OperationsPerformedBy AND AG.InActiveDateTime IS NULL
			                 					LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.BranchId = AG.TagId 
													  AND (EB.ActiveFrom < GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo > GETDATE()))
												LEFT JOIN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](@OperationsPerformedBy,@CompanyId,@BusinessUnitIds)) BU ON BU.BusinessUnitId = AG.TagId
			                 					LEFT JOIN [UserRole] UR ON UR.UserId = E.UserId AND UR.RoleId = AG.TagId AND UR.InactiveDateTime IS NULL
												--LEFT JOIN Asset A ON A.Id = AG.TagId
												--LEFT JOIN GenericFormKey GFK ON GFK.Id = AG.TagId
												WHERE (@BranchId IS NULL OR @BranchId = EB.BranchId)
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
									AND (@BusinessUnitIds IS NULL OR T.Permission = 1) 
												
			                 					GROUP BY A.Id,ISNULL(T.Permission,1)) AG ON AG.AuditId = ACM.Id
				  LEFT JOIN [User] UU ON UU.Id = AC.UpdatedByUserId
				  LEFT JOIN AuditFolder AF ON AF.Id = ACM.AuditFolderId
				  WHERE (@AuditComplianceId IS NULL OR AC.AuditComplianceId = @AuditComplianceId)
					AND ACM.CompanyId = @CompanyId
					AND (@BranchId IS NULL OR EB.BranchId = @BranchId)
					AND (@ProjectId IS NULL OR AC.ProjectId = @ProjectId)
					AND (@AuditConductId IS NULL OR AC.Id = @AuditConductId)
					AND (@AuditConductName IS NULL OR AC.AuditConductName = @AuditConductName)
				AND (@BusinessUnitIds IS NULL OR AG.AuditId IS NOT NULL) 
					AND (@AccessAllFeaturePermit = 1 OR AG.AuditId IS NOT NULL)
					AND (@SearchText IS NULL OR (AC.AuditConductName LIKE @SearchText
					  OR  AC.[Description] LIKE @SearchText))
					AND ((@IsArchived = 1 AND AC.InActiveDateTime IS NOT NULL) 
						OR (@IsArchived = 0 AND AC.InActiveDateTime IS NULL))
					AND 
					(
						(
							(ISNULL(AC.CronStartDate,AC.CreatedDateTime) BETWEEN @DateFrom AND @DateTo)
							OR AC.DeadlineDate BETWEEN @DateFrom AND @DateTo
						)
						OR
						(
							@DateFrom IS NULL AND @DateTo IS NULL
						)
					)
					AND  (@UserId IS NULL OR @UserId = AC.ResponsibleUserId)
					AND (@PeriodValue IS NULL OR ((ISNULL(AC.CronStartDate,AC.CreatedDateTime) BETWEEN @FROMDATE AND @TODATE) ))
					--AND ((@IsCompleted =  AC.IsCompleted))
					AND AC.InActiveDateTime IS NOT NULL
			) AS T
			WHERE (@StatusFilter IS NULL OR 1 = (CASE WHEN @StatusFilter = 'In progress' AND T.QuestionsCount > T.AnsweredCount AND T.AnsweredCount != 0 AND T.DeadlineDate >= GETUTCDATE() THEN 1
														WHEN @StatusFilter = 'Over due' AND T.QuestionsCount > T.AnsweredCount AND T.DeadlineDate < GETUTCDATE() THEN 1 
														WHEN @StatusFilter = 'Completed' AND T.IsCompleted = 1 THEN 1 END))
			ORDER BY T.AuditConductName ASC

			CREATE TABLE #AuditFolder
		 (
			Id INT IDENTITY(1,1),
			AuditFolderId UNIQUEIDENTIFIER
		 )

		 INSERT INTO #AuditFolder(AuditFolderId)
		 SELECT DISTINCT ParentConductId FROM #AuditConductWithFolders

		 DECLARE @AuditFolderCounter INT = 1, @AuditFolderCount INT, @AuditFolderId UNIQUEIDENTIFIER

		 SELECT @AuditFolderCount = COUNT(1) FROM #AuditFolder

		 WHILE(@AuditFolderCounter <= @AuditFolderCount)
		 BEGIN

			SELECT @AuditFolderId = AuditFolderId FROM #AuditFolder WHERE Id = @AuditFolderCounter

			INSERT INTO #AuditConductWithFolders(ProjectId,ConductId,AuditConductName,ParentConductId,ParentAuditConductName,[FolderTimeStamp],Lvl,IsConduct, CreatedDateTime, UpdatedDateTime)
			SELECT APF.ProjectId,APF.Id,APF.AuditFolderName,APF.ParentAuditFolderId,AF.AuditFolderName,APF.[TimeStamp],lvl,0, APF.CreatedDateTime, APF.UpdatedDateTime
			FROM dbo.Ufn_GetAuditParentFolders(@AuditFolderId) APF
			     LEFT JOIN AuditFolder AF ON AF.Id = APF.ParentAuditFolderId
			WHERE APF.Id NOT IN (SELECT ConductId FROM #AuditConductWithFolders)
			AND APF.CompanyId = @CompanyId

			SET @AuditFolderCounter = @AuditFolderCounter + 1

		 END

		 UPDATE #AuditConductWithFolders SET AuditConductName = 'Conducts' WHERE ParentConductId IS NULL

		 SELECT * FROM #AuditConductWithFolders ORDER BY UpdatedDateTime, AuditConductName

		END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END

