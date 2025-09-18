--exec [USP_CompanyTestDataDeleteScript] @CompanyId='632AAC72-C46E-450B-B83E-E5D1789933CB',@UserId='2C4519FC-1557-4E66-AB10-B11372EEBDA6'

CREATE PROCEDURE [dbo].[USP_CompanyTestDataDeleteScript]
(
	@CompanyId UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
		
		DECLARE @IsDemoDataCleared BIT = NULL

		SET @IsDemoDataCleared = (SELECT IsDemoDataCleared FROM Company WHERE Id = @CompanyId AND InActiveDateTime IS NULL)

		DECLARE @RoleId UNIQUEIDENTIFIER = (SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId)

		--DECLARE @NewEntityId UNIQUEIDENTIFIER = (SELECT Id FROM Entity WHERE CompanyId = @CompanyId AND EntityName = (SELECT CompanyName FROM Company WHERE Id = @CompanyId))
        DECLARE @DefaultUserId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[User] WHERE [UserName] = N'Snovasys.Support@Support')

		IF(@IsDemoDataCleared = 0)
		BEGIN
		DELETE FROM [ProcessDashboard] WHERE GoalId IN (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE P.CompanyId = @CompanyId)
		DELETE FROM [SoftLabel] WHERE CompanyId = @CompanyId
		DELETE FROM [SoftLabelConfigurations] WHERE CompanyId = @CompanyId

		--Notifications
		DELETE FROM [UserNotificationRead] WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		
		--Document Management
		DELETE FROM UploadFile WHERE StoreId IN (SELECT Id FROM Store WHERE CompanyId = @CompanyId)

        DELETE FROM Folder WHERE StoreId IN (SELECT Id FROM Store WHERE CompanyId = @CompanyId)

        DELETE FROM Store WHERE CompanyId = @CompanyId

		--Residents realted (Dependencies on widgets)
		DELETE FROM CustomAppDashboardPersistance WHERE CreatedByUserId IN (SELECT Id FROM [User] where companyid = @CompanyId)

		--Widget
		DELETE FROM CustomHtmlVersion WHERE CustomHtmlAppId IN (SELECT Id FROM CustomHtmlApp WHERE  CompanyId = @CompanyId)
		DELETE FROM CustomHtmlApp WHERE  CompanyId = @CompanyId
		DELETE FROM CustomHtmlAppRoleConfiguration WHERE CreatedbyUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [WorkspaceDashboardFilter] WHERE CreatedbyUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM UserDefaultDashboard WHERE DashboardId IN (SELECT Id FROM WorkSpace WHERE CompanyId = @CompanyId)
		DELETE FROM CustomAppDetails WHERE CustomApplicationId  IN (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId)
		DELETE FROM CustomWidgetApiDetails WHERE CustomWidgetId  IN (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId)
		DELETE FROM DashboardConfiguration WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId) 
		DELETE FROM Persistance WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId) 
		DELETE FROM CustomAppFilter WHERE DashboardId IN (SELECT WSD.Id FROM WorkspaceDashboards WSD JOIN Workspace WS ON WSD.WorkspaceId = WS.Id AND WS.CompanyId = @CompanyId)
		DELETE FROM DashboardPersistance WHERE DashboardId IN (SELECT WSD.Id FROM WorkspaceDashboards WSD JOIN Workspace WS ON WSD.WorkspaceId = WS.Id AND WS.CompanyId = @CompanyId)
		DELETE FROM WorkspaceDashboards WHERE WorkspaceId IN (SELECT Id FROM WorkSpace WHERE CompanyId = @CompanyId)
		DELETE FROM Dashboard WHERE CompanyId = @CompanyId
		DELETE FROM WorkSpaceRoleConfiguration WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM WorkSpace WHERE CompanyId = @CompanyId
		DELETE FROM WidgetRoleConfiguration WHERE WidgetId IN (SELECT Id FROM Widget WHERE CompanyId = @CompanyId)
		DELETE FROM WidgetRoleConfiguration WHERE CreatedByUserId = @UserId
		DELETE FROM Widget WHERE CompanyId = @CompanyId
		DELETE FROM CustomWidgetHistory WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId)
		DELETE FROM CustomWidgetRoleConfiguration WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId)
		DELETE FROM CustomAppColumns WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId)
		DELETE FROM CustomWidgets WHERE CompanyId = @CompanyId

		--EXPENSE
		DELETE FROM [InvoiceTask] WHERE InvoiceId IN (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE IT.CompanyId = @CompanyId)
		DELETE FROM [Payment] WHERE PaymentTypeId IN (SELECT Id FROM PaymentType WHERE CompanyId = @CompanyId)
		DELETE FROM [PaymentType] WHERE CompanyId = @CompanyId
		DELETE FROM [InvoiceItem] WHERE InvoiceId IN (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE IT.CompanyId = @CompanyId)
		DELETE FROM [InvoiceCategory] WHERE CompanyId = @CompanyId
		DELETE FROM [Invoice] WHERE CompanyId = @CompanyId
		DELETE FROM [InvoiceType] WHERE CompanyId = @CompanyId
		DELETE FROM [Customer] WHERE CompanyId = @CompanyId
		DELETE FROM [Mode] WHERE CompanyId = @CompanyId
		DELETE FROM ExpenseHistory WHERE ExpenseId IN (SELECT Id FROM Expense WHERE CompanyId = @CompanyId)
		DELETE FROM ExpenseCategoryConfiguration WHERE ExpenseId IN (SELECT Id FROM Expense WHERE CompanyId = @CompanyId)
		DELETE FROM [Expense] WHERE CompanyId = @CompanyId
		DELETE FROM [ExpenseReport] WHERE ReportStatusId IN (SELECT Id FROM ExpenseReportStatus WHERE CompanyId = @CompanyId)
		DELETE FROM [Merchant] WHERE CompanyId = @CompanyId

		--FOOD ORDER
		DELETE FROM [FoodOrderUser] WHERE (UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId) OR OrderId IN (SELECT Id FROM [FoodOrder] WHERE CompanyId = @CompanyId))
		DELETE FROM [File] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [FoodOrder] WHERE CompanyId = @CompanyId

		--CANTEEN
		DELETE FROM [UserPurchasedCanteenFoodItem] WHERE (UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId) OR FoodItemId IN (SELECT Id FROM [CanteenFoodItem] WHERE CompanyId = @CompanyId))
		DELETE FROM [UserCanteenCredit] WHERE (CreditedToUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId) OR CreditedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId))
		DELETE FROM [CanteenFoodItem] WHERE CompanyId = @CompanyId
		
		--Residents realted
		DELETE FROM FormHistory WHERE CreatedByUserId IN (SELECT Id FROM [User] where companyid = @CompanyId)
		DELETE FROM Trend WHERE CreatedByUserId IN (SELECT Id FROM [User] where companyid = @CompanyId)
		DELETE FROM CustomApplicationTag WHERE CreatedByUserId IN (SELECT Id FROM [User] where companyid = @CompanyId)
		DELETE FROM ObservationType WHERE companyid = @CompanyId

		--STATUS REPORTING
		DELETE FROM [CustomApplicationWorkflow] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [GenericFormSubmitted] WHERE Id IN (SELECT GFS.Id FROM [GenericFormSubmitted] GFS INNER JOIN CustomApplication CA ON CA.Id = GFS. CustomApplicationId WHERE CA.CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId))
		DELETE FROM [CustomApplicationKey] WHERE GenericFormId IN (SELECT Id FROM [GenericForm] WHERE FormTypeId IN (SELECT Id FROM FormType WHERE CompanyId = @CompanyId))
		--DELETE FROM [CustomApplicationKey] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [CustomApplicationRoleConfiguration] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
        DELETE FROM CustomApplicationForms WHERE CreatedByUserId in (SELECT Id FROM [User] where companyid = @CompanyId)
		DELETE FROM CustomFieldsMapping WHERE CompanyId = @CompanyId

		DELETE FROM [StatusReportSeenHistory] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [StatusReporting_New] WHERE StatusReportingConfigurationOptionId IN (SELECT SO.Id FROM StatusReportingConfigurationOption SO JOIN [StatusReportingConfiguration_New] S ON S.Id = SO.StatusReportingConfigurationId JOIN [GenericForm] G ON S.GenericFormId = G.Id JOIN FormType F ON F.Id = G.FormTypeId WHERE CompanyId = @CompanyId)
		DELETE FROM [StatusReportingConfigurationUser] WHERE (StatusReportingConfigurationId IN (SELECT S.Id FROM [StatusReportingConfiguration_New] S JOIN [GenericForm] G ON S.GenericFormId = G.Id JOIN FormType F ON F.Id = G.FormTypeId WHERE CompanyId = @CompanyId) OR UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId))
		DELETE FROM [StatusReportingConfigurationOption] WHERE StatusReportingConfigurationId IN (SELECT S.Id FROM [StatusReportingConfiguration_New] S JOIN [GenericForm] G ON S.GenericFormId = G.Id JOIN FormType F ON F.Id = G.FormTypeId WHERE CompanyId = @CompanyId)
		DELETE FROM [StatusReportingConfiguration_New] WHERE GenericFormId IN (SELECT G.Id FROM [GenericForm] G JOIN FormType F ON F.Id = G.FormTypeId WHERE CompanyId = @CompanyId)
		DELETE FROM [GenericFormKey] WHERE GenericFormId IN (SELECT Id FROM [GenericForm] WHERE FormTypeId IN (SELECT Id FROM FormType WHERE CompanyId = @CompanyId))
		DELETE FROM FormSubmissions WHERE GenericFormId IN (SELECT Id FROM [GenericForm] WHERE FormTypeId IN (SELECT Id FROM FormType WHERE CompanyId = @CompanyId))
		DELETE FROM [dbo].[FormAccessibility] WHERE FormId IN (SELECT Id FROM [GenericForm] WHERE FormTypeId IN (SELECT Id FROM FormType WHERE CompanyId = @CompanyId))
		
		DELETE FROM [Customapplication] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		
		DELETE FROM [GenericForm] WHERE FormTypeId IN (SELECT Id FROM FormType WHERE CompanyId = @CompanyId)
		DELETE FROM [FormType] WHERE CompanyId = @CompanyId

		DELETE FROM [Announcement] WHERE CompanyId = @CompanyId
		DELETE FROM EmployeeBadge WHERE BadgeId IN (SELECT Id FROM Badge WHERE CompanyId = @CompanyId)
		DELETE FROM Badge WHERE CompanyId = @CompanyId
		DELETE FROM Performance WHERE ConfigurationId IN (SELECT Id FROM PerformanceConfiguration WHERE CompanyId = @CompanyId)
		DELETE FROM PerformanceSubmissionDetails WHERE PerformanceSubmissionId IN (SELECT Id FROM PerformanceSubmission WHERE ConfigurationId IN (SELECT Id FROM PerformanceConfiguration WHERE CompanyId = @CompanyId))
		DELETE FROM PerformanceSubmission WHERE ConfigurationId IN (SELECT Id FROM PerformanceConfiguration WHERE CompanyId = @CompanyId)
		DELETE FROM PerformanceConfiguration WHERE CompanyId = @CompanyId
		DELETE FROM [Signature] WHERE CompanyId = @CompanyId
		DELETE FROM Reminder WHERE CompanyId = @CompanyId

		--ASSETS		
		DELETE FROM SeatingArrangement WHERE BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId)
		DELETE FROM [VendorDetails] WHERE AssetId IN (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE CompanyId = @CompanyId)
		--DELETE FROM [AssetAssignedToEmployee] WHERE (AssetId IN (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE CompanyId = @CompanyId))
		DELETE FROM [AssetAssignedToEmployee] WHERE AssignedToEmployeeId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		--DELETE FROM AssetHistory WHERE (AssetId IN (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE CompanyId = @CompanyId))
		DELETE AssetHistory WHERE AssetId IN (SELECT ID  FROM [Asset] WHERE (ProductDetailsId IN (SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId) OR ProductId IN(SELECT Id FROM Product WHERE CompanyId = @CompanyId) OR CurrencyId IN (SELECT Id FROM Currency WHERE CompanyId = @CompanyId) OR DamagedByUserId IN (SELECT  Id FROM [User] WHERE companyId = @CompanyId)))

		DELETE FROM [Asset] WHERE (ProductDetailsId IN (SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId) OR ProductId IN(SELECT Id FROM Product WHERE CompanyId = @CompanyId) OR CurrencyId IN (SELECT Id FROM Currency WHERE CompanyId = @CompanyId) OR DamagedByUserId IN (SELECT  Id FROM [User] WHERE companyId = @CompanyId))
		DELETE FROM [ProductDetails] WHERE (ProductId IN (SELECT Id FROM Product WHERE CompanyId = @CompanyId) OR SupplierId IN (SELECT Id FROM Supplier WHERE CompanyId = @CompanyId))
		DELETE FROM [Product] WHERE CompanyId = @CompanyId
		DELETE FROM [Supplier] WHERE CompanyId = @CompanyId
		
		--Leave Management
		DELETE FROM LeaveApplicationStatusSetHistory WHERE LeaveApplicationId IN (SELECT Id FROM LeaveApplication WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId))
		DELETE FROM LeaveApplication WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM GenderLeaveType WHERE LeaveTypeId IN (SELECT Id FROM LeaveType WHERE CompanyId = @CompanyId)
		DELETE FROM MariatalStatusLeaveType WHERE LeaveTypeId IN (SELECT Id FROM LeaveType WHERE CompanyId = @CompanyId)
		DELETE FROM RoleLeaveType WHERE LeaveTypeId IN (SELECT Id FROM LeaveType WHERE CompanyId = @CompanyId)
		DELETE FROM BranchLeaveType WHERE LeaveTypeId IN (SELECT Id FROM LeaveType WHERE CompanyId = @CompanyId)
		DELETE FROM LeaveFrequency WHERE LeaveTypeId IN (SELECT Id FROM LeaveType WHERE CompanyId = @CompanyId)
		DELETE FROM LeaveType WHERE Id IN (SELECT Id FROM LeaveType WHERE CompanyId = @CompanyId)
		DELETE FROM RestrictionType WHERE CompanyId = @CompanyId
		DELETE FROM LeaveFormula WHERE CompanyId = @CompanyId

		--TIMESHEET
		DELETE FROM [Permission] WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM TimeSheetHistory WHERE TimeSheetId IN (SELECT Id FROM TimeSheet WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId))
		DELETE FROM [TimeSheet] WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [BreakType] WHERE CompanyId = @CompanyId
		DELETE FROM [UserBreak] WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [LeaveAllowance] WHERE CompanyId = @CompanyId
		DELETE FROM [ShiftWeek] WHERE ShiftTimingId IN (SELECT Id FROM ShiftTiming WHERE CompanyId = @CompanyId)
		DELETE FROM [ShiftException] WHERE ShiftTimingId IN (SELECT Id FROM ShiftTiming WHERE CompanyId = @CompanyId)
		DELETE FROM [ShiftTiming]  WHERE CompanyId = @CompanyId

		--Testrail
		DELETE FROM [UserStoryScenarioStep] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [UserStoryScenario] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [TestCasesReport] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [TestRailReport] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM	[TestCaseHistory] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM	[TestRunSelectedCase] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM	[TestRunSelectedStep] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [TestRun] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM	[Milestone] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [TestCaseStep] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [TestCase] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [TestRailConfiguration] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [TestRailFile] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)

		--PROJECT
		DELETE FROM InductionConfiguration WHERE CompanyId = @CompanyId
		DELETE FROM [UserStoryWorkflowStatusTransition] WHERE CompanyId = @CompanyId
		DELETE FROM GoalHistory WHERE GoalId IN (SELECT G.Id FROM Goal G JOIN Project P ON P.Id = G.ProjectId AND P.CompanyId = @CompanyId)
		DELETE FROM GoalWorkFlow WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM ProjectFeatureResponsiblePerson WHERE ProjectFeatureId IN (SELECT PF.Id FROM ProjectFeature PF WHERE ProjectId IN (SELECT P.Id FROM Project P WHERE CompanyId = @CompanyId))
		DELETE FROM [ProjectFeature] WHERE ProjectId IN (SELECT P.Id FROM Project P WHERE CompanyId = @CompanyId)
		DELETE FROM UserStoryLogTime WHERE UserStoryId IN (SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE CompanyId = @CompanyId)
		DELETE FROM UserStorySpentTime WHERE UserStoryId IN (SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id  WHERE CompanyId = @CompanyId)
		DELETE FROM UserStoryHistory WHERE UserStoryId IN (SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id  WHERE CompanyId = @CompanyId)
		DELETE FROM UserStoryHistory WHERE UserStoryId IN (SELECT US.Id FROM UserStory US JOIN Templates T ON T.Id = US.TemplateId JOIN Project P ON T.ProjectId = P.Id  WHERE CompanyId = @CompanyId)
		DELETE FROM UserStoryLogTime WHERE UserStoryId IN (SELECT US.Id FROM UserStory US JOIN Sprints S ON S.Id = US.SprintId JOIN PROJECT P ON S.ProjectId = P.Id WHERE CompanyId = @CompanyId)
		DELETE FROM UserStorySpentTime WHERE UserStoryId IN (SELECT US.Id FROM UserStory US JOIN Sprints S ON S.Id = US.SprintId JOIN PROJECT P ON S.ProjectId = P.Id  WHERE CompanyId = @CompanyId)
		DELETE FROM UserStoryHistory WHERE UserStoryId IN (SELECT US.Id FROM UserStory US JOIN Sprints S ON S.Id = US.SprintId JOIN PROJECT P ON S.ProjectId = P.Id  WHERE CompanyId = @CompanyId)
		DELETE FROM BugCausedUser WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [LinkUserStory] WHERE UserStoryId IN (SELECT US.Id FROM UserStory US JOIN Goal G ON US.GoalId = G.Id JOIN PROJECT P ON G.ProjectId = P.Id  WHERE CompanyId = @CompanyId)
		DELETE FROM [UserStory] WHERE GoalId IN (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id  WHERE CompanyId = @CompanyId)
		DELETE FROM [UserStory] WHERE TemplateId IN (SELECT T.Id FROM Templates T JOIN PROJECT P ON T.ProjectId = P.Id  WHERE CompanyId = @CompanyId)
		DELETE FROM [UserStory] WHERE SprintId IN (SELECT S.Id FROM Sprints S JOIN PROJECT P ON S.ProjectId = P.Id  WHERE CompanyId = @CompanyId)
		DELETE FROM [UserStory] WHERE BugPriorityId IN (SELECT Id FROM BugPriority WHERE CompanyId = @CompanyId)
		DELETE FROM [UserStory] WHERE UserStoryStatusId IN (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId)
		--DELETE FROM [UserStoryStatus] WHERE CompanyId = @CompanyId 
		DELETE FROM UserProject WHERE ProjectId IN (SELECT P.Id FROM Project P WHERE CompanyId = @CompanyId)
		DELETE FROM SprintHistory WHERE SprintId IN (SELECT S.Id FROM Sprints S JOIN PROJECT P ON S.ProjectId = P.Id  WHERE CompanyId = @CompanyId)
		DELETE GoalReplan WHERE GoalId IN (SELECT Id FROM Goal WJERE  WHERE ProjectId IN (SELECT P.Id FROM Project P WHERE CompanyId = @CompanyId))
		DELETE FROM Goal WHERE ProjectId IN (SELECT P.Id FROM Project P WHERE CompanyId = @CompanyId)
		DELETE FROM Templates WHERE ProjectId IN (SELECT P.Id FROM Project P WHERE CompanyId = @CompanyId)
		DELETE FROM Sprints WHERE ProjectId IN (SELECT P.Id FROM Project P WHERE CompanyId = @CompanyId)
		DELETE FROM [TestSuiteSection] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [TestSuite] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [ProjectHistory] WHERE ProjectId IN (SELECT Id FROM [Project] WHERE CompanyId = @CompanyId)
		
		DELETE FROM [ReviewTemplate] WHERE CompanyId = @CompanyId

		DELETE FROM RecentSearch WHERE CreatedByUserId IN (SELECT Id FROM [USER] WHERE CompanyId = @CompanyId)
		 --Activity Tracker
		DELETE FROM [ActivityTrackerRolePermission] WHERE CompanyId = @CompanyId

		DELETE FROM [ActivityTrackerScreenShotFrequency] WHERE ComapnyId = @CompanyId

		DELETE FROM [ActivityTrackerRoleConfiguration] WHERE ComapnyId = @CompanyId
		
		DELETE FROM [ActivityTrackerConfigurationState] WHERE CompanyId =  @CompanyId

		DELETE FROM UserActivityTime WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		
		DELETE FROM ActivityScreenShot WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)

		DELETE FROM ActivityTrackerApplicationUrlRole WHERE CompanyId = @CompanyId

		DELETE FROM ActivityTrackerApplicationUrl WHERE CompanyId = @CompanyId
		
		DELETE FROM UserMAC WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		
		--Activity Tracker end
		--EMPLOYEE AND USER
		UPDATE Employee SET [GenderId] = NULL, [BranchId] = NULL, [MaritalStatusId] = NULL, [NationalityId] = NULL, [DateofBirth] = NULL , [MarriageDate] = NULL
		, [Smoker] = 0, [MilitaryService] = 0, [NickName] = NULL, [TaxCode] = NULL, [UpdatedDateTime] = NULL, [UpdatedByUserId] = NULL, [InActiveDateTime] = NULL WHERE UserId = @UserId
		UPDATE [User] SET  [IsPasswordForceReset] = NULL, [IsAdmin] = 0, [ProfileImage] = NULL, [RegisteredDateTime] = GETDATE(), [LastConnection] = NULL, [UpdatedDateTime] = NULL --[RoleId] = @RoleId,
		, [UpdatedByUserId] = NULL, [InActiveDateTime] = NULL, [CurrencyId] = NULL WHERE Id= @UserId 
		DELETE FROM [UserRole] WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [UserActiveDetails] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeDesignation] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeEducation] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeLanguage] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeContactDetails] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeMembership] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeepayrollConfiguration] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeSalary] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeSkill] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeWorkExperience] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [BankDetail] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [Job] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [Contract] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeImmigration] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeLicence] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeEmergencyContact] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeWorkConfiguration] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeShift] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)

		--[EmployeeEntityBranch] Delete Script
		DELETE FROM [EmployeeEntityBranch] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeEntity] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeBranch] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeReportTo] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM EmployeeBranch WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)		
		DELETE FROM UserAuthToken WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId 
		                                AND CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId))
		DELETE FROM ResetPassword WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [User] WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM [EntityBranch] WHERE EntityId IN (SELECT Id FROM Entity WHERE CompanyId = @CompanyId)
		DELETE FROM [Entity] WHERE CompanyId = @CompanyId --AND CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId) AND Id <> @NewEntityId
		DELETE FROM [ProfessionalTaxRange] WHERE BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId)
		DELETE FROM [TaxSlabs] WHERE BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId)
		DELETE FROM [Branch] WHERE CompanyId = @CompanyId --AND CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		DELETE FROM Region WHERE CompanyId = @CompanyId AND CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)
		 
		--INSERT INTO [dbo].[EntityBranch]([Id],[EntityId],[BranchId],[CreatedByUserId],[CreatedDateTime])
  --      SELECT NEWID(),@NewEntityId,@NewEntityId,@DefaultUserId,GETDATE()
		
		--INSERT INTO [dbo].[EmployeeEntity]([Id],EmployeeId,EntityId,[CreatedByUserId],[CreatedDateTime])
  --      SELECT NEWID(),(SELECT Id FROM Employee WHERE UserId = @UserId),@NewEntityId,@DefaultUserId,GETDATE()
		
		--INSERT INTO [dbo].[EmployeeBranch]([Id],[EmployeeId],[BranchId],[ActiveFrom],[CreatedDateTime],[CreatedByUserId])
  --      SELECT NEWID(),(SELECT Id FROM Employee WHERE UserId = @UserId),@NewEntityId,GETDATE(),GETDATE(),@DefaultUserId

  --      INSERT INTO [dbo].[EmployeeEntityBranch] ([Id],[EmployeeId],[BranchId],[CreatedByUserId],[CreatedDateTime])
  --      SELECT NEWID(),(SELECT Id FROM Employee WHERE UserId = @UserId),@NewEntityId,@DefaultUserId,GETDATE()

		--INSERT INTO [dbo].[Branch]([Id],[CompanyId],[BranchName],[CreatedDateTime],[CreatedByUserId])
		--SELECT @NewEntityId,@CompanyId,(SELECT CompanyName FROM Company WHERE Id = @CompanyId),GETDATE(),@UserId

		--POST DEPLOYMENT SCRIPT
	      --No companyid column
		DELETE FROM [WorkflowEligibleStatusTransition] WHERE (WorkflowId IN(SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId))
		
		--DELETE FROM [BoardTypeWorkFlow] WHERE (BoardTypeId IN(SELECT OriginalId FROM BoardType WHERE CompanyId = @CompanyId) OR WorkFlowId IN(SELECT OriginalId FROM WorkFlow WHERE CompanyId = @CompanyId)) AND CreatedByUserId IN (SELECT OriginalId FROM [User] WHERE CompanyId = @CompanyId) 
		DELETE FROM [BoardTypeWorkFlow] WHERE WorkFlowId IN (SELECT Id FROM [WorkFlow] WHERE CompanyId = @CompanyId)

		DELETE FROM [RoleFeature] WHERE RoleId IN(SELECT Id FROM [Role] WHERE CompanyId = @CompanyId)
		 
		 --with companyid column
		
		DELETE FROM [WorkflowStatus] WHERE CompanyId = @CompanyId 

		DELETE FROM [BugPriority] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [UserStoryStatus] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [WorkFlow] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [BoardType] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [EntityRoleFeature] WHERE EntityRoleId IN(SELECT Id FROM [EntityRole] WHERE CompanyId = @CompanyId)
		
		DELETE FROM [EntityRole] WHERE CompanyId = @CompanyId

		-- Invoice And Estimate --
		DELETE IH FROM [InvoiceHistory] IH INNER JOIN [Invoice_New] INV ON INV.Id = IH.InvoiceId AND INV.CompanyId = @CompanyId
		DELETE ITN FROM [InvoiceTask_New] ITN INNER JOIN [Invoice_New] INV ON INV.Id = ITN.InvoiceId AND INV.CompanyId = @CompanyId
		DELETE IIN FROM [InvoiceItem_New] IIN INNER JOIN [Invoice_New] INV ON INV.Id = IIN.InvoiceId AND INV.CompanyId = @CompanyId
		DELETE IPL FROM [InvoicePaymentLog] IPL INNER JOIN [Invoice_New] INV ON INV.Id = IPL.InvoiceId AND CompanyId = @CompanyId
		DELETE FROM [Invoice_New] WHERE CompanyId = @CompanyId
		DELETE FROM [AccountType] WHERE CompanyId = @CompanyId

		DELETE EH FROM [EstimateHistory] EH INNER JOIN [Estimate] INV ON INV.Id = EH.EstimateId AND INV.CompanyId = @CompanyId
		DELETE ET FROM [EstimateTask] ET INNER JOIN [Estimate] INV ON INV.Id = ET.EstimateId AND INV.CompanyId = @CompanyId
		DELETE EI FROM [EstimateItem] EI INNER JOIN [Estimate] INV ON INV.Id = EI.EstimateId AND INV.CompanyId = @CompanyId
		DELETE FROM [Estimate] WHERE CompanyId = @CompanyId

		DELETE FROM [InvoiceStatus] WHERE CompanyId = @CompanyId
		-- Invoice And Estimate --

		DELETE FROM [ClientAddress] WHERE ClientId = (SELECT C.Id FROM [Client] C
		
		INNER JOIN [ClientAddress] CA ON CA.ClientId = C.Id  where C.CompanyId = @CompanyId)

		DELETE FROM [ClientHistory] WHERE ClientId = (SELECT C.Id FROM [Client] C
		
		INNER JOIN [ClientHistory] CH ON CH.ClientId = C.Id  where C.CompanyId = @CompanyId)

		DELETE FROM [ClientSecondaryContact] WHERE ClientId = (SELECT C.Id FROM [Client] C
		
		INNER JOIN [ClientSecondaryContact] CSC ON CSC.ClientId = C.Id  where C.CompanyId = @CompanyId)

		DELETE FROM [Client] WHERE CompanyId = @CompanyId
		
		DELETE WorkflowTrigger WHERE WorkflowId IN (SELECT Id FROM AutomatedWorkFlow WHERE CompanyId = @CompanyId)

		DELETE AutomatedWorkFlow WHERE CompanyId = @CompanyId

		DELETE FROM [Role] WHERE CompanyId = @CompanyId AND Id <> @RoleId

		INSERT INTO UserRole
						   (Id
						   ,UserId
						   ,RoleId
						   ,CreatedByUserId
						   ,CreatedDateTime)
						   SELECT NEWID()
						       ,@UserId
							   ,@RoleId
							   ,@DefaultUserId
							   ,GETDATE()
		
		DELETE FROM [CompanySettings] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [ContractType] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [PaymentMethod] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [Designation] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [ProjectType] WHERE CompanyId = @CompanyId
		
		DELETE FROM [ProcessDashboardStatus] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [PermissionReason] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [dbo].[FoodOrderStatus] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [PaymentStatus] WHERE CompanyId = @CompanyId

		DELETE FROM [MessageType] WHERE CompanyId = @CompanyId 

		DELETE FROM [LicenceType] WHERE CompanyId = @CompanyId
		
		DELETE FROM [GoalReplanType] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [LeaveSession] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [LeaveType] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [LeaveStatus] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [TestCaseType] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [TestCaseStatus] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [TestCaseAutomationType] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [UserStorySubType] WHERE CompanyId = @CompanyId
		
		DELETE FROM [Nationality] WHERE CompanyId = @CompanyId
		
		DELETE FROM [ButtonType] WHERE CompanyId = @CompanyId
		
		--DELETE FROM [ReferenceType] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [PayGrade] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [PayFrequency] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [EmploymentStatus] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [Department] WHERE CompanyId = @CompanyId 
		
		DELETE FROM [Skill] WHERE CompanyId = @CompanyId
		
		DELETE FROM [Language] WHERE CompanyId = @CompanyId
		
		DELETE FROM [MemberShip] WHERE CompanyId = @CompanyId
		
		DELETE FROM [Currency] WHERE CompanyId = @CompanyId

		DELETE FROM [EncashmentType] WHERE CompanyId = @CompanyId

		DELETE FROM [MaritalStatus] WHERE CompanyId = @CompanyId
				
		DELETE FROM [JobCategory] WHERE CompanyId = @CompanyId
		
		DELETE FROM [Comment] WHERE CompanyId = @CompanyId
		
		--Test data master tables
		DELETE FROM [EducationLevel] WHERE CompanyId = @CompanyId
		DELETE FROM [Holiday] WHERE CompanyId = @CompanyId
		DELETE FROM [CompanyLocation] WHERE CompanyId = @CompanyId
		DELETE FROM [AccessisbleIpAdresses] WHERE CompanyId = @CompanyId
		DELETE FROM [FeedBackType] WHERE CompanyId = @CompanyId
		DELETE FROM [RateType] WHERE CompanyId = @CompanyId
		DELETE FROM [State] WHERE CompanyId = @CompanyId
		DELETE FROM [ReportingMethod] WHERE CompanyId = @CompanyId
		DELETE FROM [ExpenseCategory] WHERE CompanyId = @CompanyId
		DELETE FROM [ExpenseReportStatus] WHERE CompanyId = @CompanyId
		
		DELETE FROM [Gender] WHERE CompanyId = @CompanyId

		DELETE FROM [Competency] WHERE CompanyId = @CompanyId

		DELETE FROM [Fluency] WHERE CompanyId = @CompanyId

		DELETE FROM [RelationShip] WHERE CompanyId = @CompanyId

		DELETE FROM [StatusReportingOption_New] WHERE CompanyId = @CompanyId

		DELETE FROM [ConsiderHours] WHERE CompanyId = @CompanyId

		DELETE FROM [Field] WHERE CompanyId = @CompanyId

		DELETE FROM [SubscriptionPaidBy] WHERE CompanyId = @CompanyId

		--DELETE FROM [BoardTypeUi] WHERE CompanyId = @CompanyId AND CreatedByUserId IN (SELECT OriginalId FROM [User] WHERE CompanyId = @CompanyId)

		DELETE FROM [UserStoryPriority] WHERE CompanyId = @CompanyId

		DELETE FROM [UserStoryReviewStatus] WHERE CompanyId = @CompanyId

		DELETE FROM [TestCasePriority] WHERE CompanyId = @CompanyId

		DELETE FROM [TestCaseTemplate] WHERE CompanyId = @CompanyId

		DELETE FROM [TimeSheetSubmission] WHERE CompanyId = @CompanyId

		DELETE FROM [TimeSheetPunchCard] WHERE CompanyId = @CompanyId

		--DELETE FROM [UserStoryReplanType] WHERE CompanyId = @CompanyId AND CreatedByUserId IN (SELECT OriginalId FROM [User] WHERE CompanyId = @CompanyId)

		--DELETE FROM [LogTimeOption] WHERE CompanyId = @CompanyId

		--DELETE FROM [GoalStatus] WHERE CompanyId = @CompanyId

		--DELETE FROM [BoardTypeApi] WHERE CompanyId = @CompanyId AND CreatedByUserId IN (SELECT OriginalId FROM [User] WHERE CompanyId = @CompanyId)
		
		DELETE FROM CustomFormFieldMapping WHERE FormId in (SELECT Id FROM CustomField WHERE CompanyId = @CompanyId)
		DELETE FROM CustomFormFieldKeys WHERE CustomFieldId in (SELECT Id FROM CustomField WHERE CompanyId = @CompanyId)
		DELETE FROM CustomField WHERE CompanyId = @CompanyId

		DELETE FROM [UserStoryType] WHERE CompanyId = @CompanyId

		 DELETE FROM LinkUserStoryType WHERE CompanyId = @CompanyId

		DELETE AQH FROM AuditQuestionHistory AQH 
		INNER JOIN [User] U on U.Id  = AQH.CreatedByUserId AND U.CompanyId = @companyId
        
		DELETE AQH FROM AuditTags AQH
				  INNER JOIN AuditCompliance ACC ON ACC.Id = AQH.AuditId AND ACC.CompanyId = @CompanyId
	    
		DELETE FROM AuditReport WHERE CompanyId = @CompanyId

		DELETE ACS FROM AuditConductSubmittedAnswer ACS INNER JOIN AuditConduct ACD ON ACS.ConductId = ACD.Id
		     INNER JOIN AuditCompliance AC ON ACD.AuditComplianceId = AC.Id AND AC.CompanyId = @CompanyId

		DELETE ACS FROM AuditConductAnswers ACS INNER JOIN AuditConduct ACD ON ACS.AuditConductId = ACD.Id
		     INNER JOIN AuditCompliance AC ON ACD.AuditComplianceId = AC.Id AND AC.CompanyId = @CompanyId

		DELETE ACS FROM AuditConductQuestions ACS INNER JOIN AuditConduct ACD ON ACS.AuditConductId = ACD.Id
		     INNER JOIN AuditCompliance AC ON ACD.AuditComplianceId = AC.Id AND AC.CompanyId = @CompanyId

		DELETE ACSQ FROM AuditConductSelectedQuestion ACSQ INNER JOIN AuditConduct AC ON AC.Id = ACSQ.AuditConductId
					INNER JOIN AuditCompliance ACC ON ACC.Id = AC.AuditComplianceId AND ACC.CompanyId = @CompanyId

		DELETE ACSQ FROM AuditConductSelectedCategory ACSQ INNER JOIN AuditConduct AC ON AC.Id = ACSQ.AuditConductId
					INNER JOIN AuditCompliance ACC ON ACC.Id = AC.AuditComplianceId AND ACC.CompanyId = @CompanyId

		DELETE FROM AuditConduct WHERE AuditComplianceId IN (SELECT Id From AuditCompliance WHERE CompanyId = @CompanyId)

		DELETE AA FROM AuditAnswers AA INNER JOIN AuditQuestions AQ on AQ.Id = AA.AuditQuestionId
				  INNER JOIN AuditCategory AC on AQ.AuditCategoryId = AC.Id 
				  INNER JOIN AuditCompliance ACC ON ACC.Id = AC.AuditComplianceId AND ACC.CompanyId = @CompanyId
		
		DELETE AQ FROM AuditQuestions AQ INNER JOIN AuditCategory AC on AQ.AuditCategoryId = AC.Id 
				  INNER JOIN AuditCompliance ACC ON ACC.Id = AC.AuditComplianceId AND ACC.CompanyId = @CompanyId
		
		DELETE FROM AuditCategory WHERE AuditComplianceId IN (SELECT Id From AuditCompliance WHERE CompanyId = @CompanyId)
		
		DELETE FROM AuditCompliance WHERE CompanyId = @CompanyId
		
		DELETE FROM QuestionTypeOptions WHERE QuestionTypeId IN (SELECT Id From QuestionTypes WHERE CompanyId = @CompanyId)
		
		DELETE FROM QuestionTypes WHERE CompanyId = @CompanyId
		DELETE CustomTags WHERE  TagId IN (SELECT Id FROM Tags WHERE CompanyId = @CompanyId)
		DELETE Tags WHERE CompanyId = @CompanyId

		DELETE FROM RecentSearch WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)

		--DECLARE @CountryId UNIQUEIDENTIFIER = (SELECT TOP(1) Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId)

	    --Payroll
		DELETE FROM [Temp_PayrollRunEmployeeComponent] WHERE PayrollRunId IN (SELECT Id FROM [PayrollRun] WHERE CompanyId = @CompanyId)
		DELETE FROM [Temp_PayrollRunEmployee] WHERE PayrollRunId IN (SELECT Id FROM [PayrollRun] WHERE CompanyId = @CompanyId)
		DELETE FROM [Temp_PayrollRun] WHERE BranchId IN (SELECT Id FROM [Branch] WHERE CompanyId = @CompanyId)
        DELETE FROM [PayrollRunStatus] WHERE PayrollRunId IN (SELECT Id FROM [PayrollRun] WHERE CompanyId = @CompanyId)
        DELETE FROM [PayrollRunEmployee] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [PayrollRunEmployeeComponent] WHERE PayrollRunId IN (SELECT Id FROM [PayrollRun] WHERE CompanyId = @CompanyId)
		DELETE FROM [PayrollRunEmployeeComponentYTD] WHERE PayrollRunId IN (SELECT Id FROM [PayrollRun] WHERE CompanyId = @CompanyId)
		DELETE FROM [PayrollRunEmployeeHistory] WHERE PayrollRunEmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [PayrollRunEmployeeYTDComponent] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [PayrollRunFilteredEmployee] WHERE PayrollRunId IN (SELECT Id FROM [PayrollRun] WHERE CompanyId = @CompanyId)
		DELETE FROM [PayrollRunFilteredEmploymentStatus] WHERE PayrollRunId IN (SELECT Id FROM [PayrollRun] WHERE CompanyId = @CompanyId)

		DELETE FROM [PayrollRun] WHERE CompanyId = @CompanyId

		DELETE FROM [PayrollBranchConfiguration] WHERE PayRollTemplateId IN (SELECT Id FROM PayRollTemplate WHERE CompanyId = @CompanyId)
		DELETE FROM [PayrollMaritalStatusConfiguration] WHERE PayRollTemplateId IN (SELECT Id FROM PayRollTemplate WHERE CompanyId = @CompanyId)
		DELETE FROM [PayrollGenderConfiguration] WHERE PayRollTemplateId IN (SELECT Id FROM PayRollTemplate WHERE CompanyId = @CompanyId)
		DELETE FROM [PayrollRoleConfiguration] WHERE PayRollTemplateId IN (SELECT Id FROM PayRollTemplate WHERE CompanyId = @CompanyId)

		DELETE FROM [EmployeeLoanInstallment] WHERE EmployeeLoanId
		IN (SELECT Id FROM [EmployeeLoan] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId))
		DELETE FROM [EmployeeLoan] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeTaxAllowances] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeAccountDetails] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeCreditorDetails] WHERE BranchId IN (SELECT Id FROM [Branch] WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeBonus] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [EmployeeTaxAllowanceProof] WHERE EmployeeTaxAllowanceId IN (SELECT Id FROM [EmployeeTaxAllowances] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId))
		DELETE FROM [EmployeeResignation] WHERE EmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
		DELETE FROM [Bank] WHERE CountryId IN (SELECT Id FROM [dbo].[Country] WHERE [CompanyId] = @CompanyId)

        DELETE FROM [FinancialYearConfigurations] WHERE CountryId IN (SELECT Id FROM [Country] WHERE CompanyId = @CompanyId)
		DELETE FROM [DaysOfWeekConfiguration] WHERE BranchId IN (SELECT Id FROM [Branch] WHERE CompanyId = @CompanyId)
		DELETE FROM [PayRollCalculationConfigurations] WHERE BranchId IN (SELECT Id FROM [Branch] WHERE CompanyId = @CompanyId)
		DELETE FROM [LeaveEncashmentSettings] WHERE BranchId IN (SELECT Id FROM [Branch] WHERE CompanyId = @CompanyId)
		DELETE FROM [TdsSettings] WHERE BranchId IN (SELECT Id FROM [Branch] WHERE CompanyId = @CompanyId)
		DELETE FROM [HourlyTdsConfiguration] WHERE BranchId IN (SELECT Id FROM [Branch] WHERE CompanyId = @CompanyId)
		DELETE FROM [AllowanceTime] WHERE BranchId IN (SELECT Id FROM [Branch] WHERE CompanyId = @CompanyId)
		DELETE FROM [ContractPaySettings] WHERE BranchId IN (SELECT Id FROM [Branch] WHERE CompanyId = @CompanyId)


		DELETE FROM [RateTagRoleBranchConfiguration] WHERE CompanyId = @CompanyId
        DELETE FROM [RateTagConfiguration] WHERE RateTagRoleBranchConfigurationId IN  (SELECT Id from [RateTagRoleBranchConfiguration] WHERE CompanyId = @CompanyId)
        DELETE FROM [EmployeeRateTag] WHERE RateTagEmployeeId IN (SELECT E.Id FROM Employee E JOIN [User] U ON U.Id = E.UserId WHERE CompanyId = @CompanyId)
        DELETE FROM [RateTagDetails] WHERE RateTagId IN (SELECT Id from [RateTag] WHERE CompanyId = @CompanyId)
		DELETE FROM [RateTag] WHERE CompanyId = @CompanyId

		DELETE FROM [PayrollTemplateTaxSlab] WHERE PayRollTemplateId IN (SELECT Id FROM PayRollTemplate WHERE CompanyId = @CompanyId)
		DELETE FROM TaxCalculationType WHERE CountryId IN (SELECT Id FROM [Country] WHERE CompanyId = @CompanyId)
		DELETE FROM [TaxSlabs] WHERE CountryId IN (SELECT Id FROM Country WHERE CompanyId = @CompanyId)
        DELETE FROM [TaxAllowances] WHERE CountryId IN (SELECT Id FROM Country WHERE CompanyId = @CompanyId)
        DELETE FROM [PayrollTemplateConfiguration] WHERE PayRollTemplateId IN (SELECT Id FROM PayRollTemplate WHERE CompanyId = @CompanyId)
        DELETE FROM [PayrollTemplate] WHERE CompanyId = @CompanyId
        DELETE FROM [PayRollComponent] WHERE CompanyId = @CompanyId
		DELETE FROM [PayrollStatus] WHERE CompanyId = @CompanyId
		DELETE FROM [TaxCalculationType] WHERE CountryId IN (SELECT Id FROM Country WHERE CompanyId = @CompanyId)
		DELETE FROM [TaxAllowanceType] WHERE CompanyId = @CompanyId
		DELETE FROM [WeekDays] WHERE CompanyId = @CompanyId
		DELETE FROM [RateSheetFor] WHERE CompanyId = @CompanyId
		DELETE FROM [RateTagFor] WHERE CompanyId = @CompanyId
		DELETE FROM [PartsOfDay] WHERE CompanyId = @CompanyId
		
		DELETE FROM ActionCategory WHERE  CompanyId = @CompanyId
        DELETE FROM AuditRating WHERE  CompanyId = @CompanyId

		DELETE FROM [Country] WHERE CompanyId = @CompanyId
		
		DELETE FROM Employee WHERE CreatedByUserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)

		UPDATE Company SET IsDemoDataCleared = 1 WHERE Id = @CompanyId AND InActiveDateTime IS NULL

		UPDATE Company SET IsDemoData = 0 WHERE Id = @CompanyId AND InActiveDateTime IS NULL
		DELETE FROM [AuditFolder] WHERE CompanyId = @CompanyId
		DELETE FROM [Project] WHERE CompanyId = @CompanyId
		MERGE INTO [dbo].[Country] AS Target
	    USING ( VALUES 
	    		(NEWID(),@CompanyId, N'Belgium',  N'+32', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'Antarctica', N'+672', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'Albania', N'+335', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'France', N'+33', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'India', N'+91', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'Brazil', N'+91', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'Bangladesh', N'+880', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'Japan', N'+81', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'Dhaka', N'DH', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'England',  N'+91', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'Canada', N'+1', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'China', N'+86', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'Algola', N'+244', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'Europe', N'+45', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'Afganisthan', N'+93', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	    		(NEWID(),@CompanyId, N'Uk', N'+44', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId)
	    		) 
	    AS Source ([Id], [CompanyId], [CountryName], [CountryCode], [CreatedDateTime], [CreatedByUserId])
	    ON Target.Id = Source.Id  
	    WHEN MATCHED THEN 
	    UPDATE SET [CompanyId]  = Source.[CompanyId],
	               [CountryName] = Source.[CountryName],
	               [CreatedDateTime] = Source.[CreatedDateTime],
	               [CreatedByUserId] = Source.[CreatedByUserId],
	               [CountryCode] = Source.[CountryCode]
	    WHEN NOT MATCHED BY TARGET THEN 
	    INSERT([Id], [CompanyId], [CountryName], [CountryCode], [CreatedDateTime], [CreatedByUserId]) 
	    VALUES ([Id], [CompanyId], [CountryName], [CountryCode], [CreatedDateTime], [CreatedByUserId]);

		 DECLARE @NewEntityId UNIQUEIDENTIFIER

   --         INSERT INTO [dbo].[Entity](Id,EntityName,CreatedDateTime,CreatedByUserId,CompanyId)
   --         SELECT @NewEntityId,@CompanyName,GETDATE(),@DefaultUserId,@NewCompanyId
            
   --         INSERT INTO [dbo].[EntityBranch]([Id],[EntityId],[BranchId],[CreatedByUserId],[CreatedDateTime])
   --         SELECT NEWID(),E.Id,E.Id,@DefaultUserId,GETDATE()
   --         FROM Entity E
   --         WHERE E.CompanyId = @NewCompanyId
            
   --         INSERT INTO [dbo].[Branch]([Id],[CompanyId],[BranchName],[CreatedDateTime],[CreatedByUserId])
			--SELECT @NewEntityId,@NewCompanyId,@CompanyName,@Currentdate,@NewUserId

		DECLARE @CompanyName NVARCHAR(250) = (SELECT CompanyName FROM Company WHERE Id = @CompanyId)

		DECLARE @InnerCountryId UNIQUEIDENTIFIER = (SELECT Id FROM Country 
                                                    WHERE CompanyId = @CompanyId
                                                          AND CountryName = (SELECT CountryName FROM SYS_Country WHERE Id = (SELECT [CountryId] FROM Company WHERE Id = @CompanyId))
                                                          AND InActiveDateTime IS NULL)
          
		IF(@InnerCountryId IS NULL)
		BEGIN
		    
		   SET @InnerCountryId = (SELECT TOP (1) Id FROM Country WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL)
		
		END

        DECLARE @Entity TABLE
        (
            EntityId UNIQUEIDENTIFIER    
        )

        INSERT INTO @Entity(EntityId)
        EXEC [dbo].[USP_UpsertEntity] @EntityName = @CompanyName,@IsBranch = 1,@OperationsPerformedBy = @UserId,@CountryId = @InnerCountryId

        SET @NewEntityId = (SELECT EntityId FROM @Entity)

        INSERT INTO [dbo].[EmployeeEntity]([Id],EmployeeId,EntityId,[CreatedByUserId],[CreatedDateTime])
        SELECT NEWID(),(SELECT Id FROM Employee WHERE UserId = @UserId),@NewEntityId,@UserId,GETDATE()

        INSERT INTO [dbo].[EmployeeEntityBranch] ([Id],[EmployeeId],[BranchId],[CreatedByUserId],[CreatedDateTime])
        SELECT NEWID(),(SELECT Id FROM Employee WHERE UserId = @UserId),@NewEntityId,@UserId,GETDATE()

		INSERT INTO [dbo].[EmployeeBranch] ([Id],[EmployeeId],[BranchId],[CreatedByUserId],[CreatedDateTime],ActiveFrom,ActiveTo)
        SELECT NEWID(),(SELECT Id FROM Employee WHERE UserId = @UserId),@NewEntityId,@UserId,GETDATE(),GETDATE(),NULL
		
		DECLARE @EscuteScript NVARCHAR(MAX) = ''

        --TODO
		--	IF EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId<>'7499F5E3-0EF2-4044-B840-2411B68302F9')
		--BEGIN 
        SELECT @EscuteScript = @EscuteScript + '  EXEC [dbo].' + ScriptFileId + ' @CompanyId = ''' 
                                                               + CONVERT(NVARCHAR(50),@CompanyId) + ''',@RoleId = ''' 
                                                               + CONVERT(NVARCHAR(50),@RoleId) + ''',@UserId = ''' 
                                                               + CONVERT(NVARCHAR(50),@UserId) + ''''
        FROM DeploymentScript
        ORDER BY ScriptFileExecutionOrder

        EXECUTE(@EscuteScript);
		--END
		--EXEC [USP_PostDeploymentScript] @RoleId = @RoleId,@CompanyId = @CompanyId,@UserId = @UserId,@Marker = NULL
		
		SELECT @CompanyId

		END
END
GO