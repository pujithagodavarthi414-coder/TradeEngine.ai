namespace BTrak.Common
{
    public class Enumerators
    {
        public enum Roles
        {
            CEO = 1,
            LeadDeveloper = 2,
            SoftwareEngineer = 3,
            AnalystDeveloper = 4,
            Manager = 5,
            Consultant = 14
        }

        public enum Branches
        {
            Ongole = 1,
            Hyderabad = 2,
            UK = 3,
        }

        public enum ColorNames
        {
            Green,
            Red,
            Pink,
            Blue,
            Ash
        }

        public enum TaskStatus
        {
            NotStarted = 1,
            AnalysisCompleted = 2,
            DevInprogress = 3,
            DevCompleted = 4,
            Deployed = 5,
            QAApproved = 6,
            SignedOff = 7,
            Inprogress = 8,
            Completed = 9,
            Blocked = 10,
            New = 11,
            Resolved = 12,
            Verified = 13
        }

        public enum IncludeEnum
        {
            CurrentEmployeesOnly = 1,
            CurrentandPastEmployees = 2,
            PastEmployeesOnly = 3,
        }

        public enum WorkflowEnum
        {
            SuperAgile = 1,
            Kanban = 2,
            KanbanBugSheet = 3
        }

        public enum UserStoriesStatus
        {
            Current = 1,
            Previous = 2,
            Future = 3
        }

        public enum ReplanReasons
        {
            Other = 4
        }

        public enum FeedTimesheet
        {
            Intime = 1,
            LunchStart = 2,
            LunchEnd = 3,
            Finish = 4,
            BreakIn = 5,
            BreakOut = 6,
            LunchDeadLineTime = 70
        }

        public enum BoardTypes
        {
            SuperAgile = 1,
            Kanban = 2,
            Api = 3,
            KanbanBugSheet = 4
        }

        public enum FeatureEnum
        {
            Projects = 1,
            AddUserStory = 2,
            EditUserStory = 3,
            AddGoal = 4,
            LockGoal = 5,
            ApproveGoal = 6,
            ArchiveProject = 7,
            ArchiveGoal = 8,
            MainDashboard = 9,
            SnapshotMainDashboard = 10,
            PreviewMainDashboard = 11,
            LiveDashboard = 12,
            SnapshotLiveDashboard = 13,
            HRDashboard = 14,
            HRDashboardView = 15,
            TimeSheet = 16,
            ViewTimeSheet = 17,
            FeedTimeSheet = 18,
            HRManagement = 19,
            AddEmployee = 20,
            EmployeeList = 21,
            CanteenManagement = 22,
            AddCredit = 23,
            PurchaseItem = 24,
            AddFoodItem = 25,
            OrganizationChart = 26,
            OrganizationChartView = 27,
            RoomTemperature = 28,
            RoomTemperatureView = 29,
            Audit = 30,
            AuditHistory = 31,
            TimeSheetHistory = 32,
            UserManagement = 33,
            AddUser = 34,
            EditUser = 35,
            ChangePassword = 36,
            Settings = 37,
            AddNewIPAddress = 38,
            AddCurrentIPAddress = 39,
            AddProject = 40,
            EditProject = 41,
            EditGoal = 42,
            LiveDashboardView = 43,
            MainDashboardView = 44,
            MyProfile = 45,
            MyProfileView = 46,
            LeadManagement = 47,
            LeadManagementView = 48,
            AssetsManagement = 49,
            AssetsDashboard = 50,
            AssetsList = 51,
            LocationManagement = 52,
            VendorManagement = 53,
            FoodOrderManagement = 54,
            FoodOrderDashboard = 55,
            LateNightFoodOrder = 56,
            MakeAnOrder = 57,
            RoleManagement = 58,
            AddRole = 59,
            EditRole = 60,
            CopyRole = 61,
            ViewProjects = 62,
            SpentTimeReport = 63,
            HrHistory = 64,
            ToDo = 65,
            ToDoView = 66,
            UpdateStatus = 67,
            Owner = 68,
            Dependency = 69,
            StatusReporting = 70,
            StatusReportingConfiguration = 71,
            AddNewLead = 72,
            EditLeadDetails = 73,
            AddNotes = 74,
            EditNotes = 75,
            SnoozeLead = 76,
            Comments = 77,
            CustomAppications = 78,
            CustomApps = 79
        }

        public enum StatusReportingWeekOptions
        {
            Monday = 1,
            Tuesday = 2,
            Wednesday = 3,
            Thursday = 4,
            Friday = 5,
            Saturday = 6,
            Sunday = 7,
            EveryWorkingday = 8,
            LastWorkingdayoftheMonth = 9
        }

        public enum ModuleTypeEnum
        {
            Hrm = 1,
            Assets = 2,
            FoodOrder = 3,
            Projects = 4,
            Cron = 5,
            Invoices = 6,
            Expenses = 7,
            TestRepo = 8,
            CompanyStructure = 9,
            Scripts = 10,
            Audits = 11,
            Conducts = 12,
            Clients = 13,
            ClientStamp = 14,
            Programs = 15
        }

        public enum NotificationType
        {
            Email = 1,
            PushNotification = 2
        }

        public enum FileTypeEnum
        {
            HrmFiles = 1,
            AssetsFiles = 2,
            FoodOrderFiles = 3,
            ProjectFiles = 4,
            CustomFiles = 5,
            TestSuiteFiles = 6,
            TestCaseFiles = 7,
            HtmlAppFiles = 8,
            CustomDocFiles = 9,
            ExpensesFiles = 10,
            InvoiceFiles = 11,
            PayRoll = 12,
            signature = 13,
            AuditFiles = 14,
            RecruitmentFiles = 15,
            EntryFormInvoice = 16,
            ContractFiles = 17,
            FormDocumentFile = 18,
            ClientSettingsFile = 19,
            ClientStampDetails = 20
        }

        public enum TaskType
        {
            Goal = 1,
            WorkItemORBug = 2,
            Sprint = 3,
            Adhoc = 4,
            Project = 5,
            Employee = 6
        }

        public enum RecentSearchType
        {
            Menu = 1,
            Dashboard = 2,
            Widget = 3,
            Employee = 4,
            Project = 5,
            WorkItemOrBug = 6,
            Adhoc = 7,
            Goal = 8,
            Sprint = 9
        }
        public enum ExportDataConfiguration
        {
            FormTypes = 1,
            Roles = 2,
            EntityRoleOutputModels = 3,
            WorkItemTypes = 4,
            BoardTypeApis = 5,
            BoardTypes = 6,
            WorkItemStatuses = 7,
            WorkItemSubTypes = 8,
            ProjectTypes = 9,
            WorkFlowAndStatusModel = 10,
            Projects = 11,
            GoalTemplates = 12,
            TemplateUserStories = 13,
            MasterQuestionTypes = 14,
            QuestionTypes = 15,
            AuditsList = 16,
            AuditCategories = 17,
            AuditCategoryQuestions = 18,
            PayrollComponents = 19,
            PayrollTemplates = 20,
            PayrollTemplateConfigurations = 21,
            ProfessionalTaxRange = 22,
            TaxSlabs = 23,
            CustomFields = 24,
            FavouriteApps = 25,
            SystemApps = 26,
            CustomApps = 27
        }

        public enum ModeType
        {
            None = 0,
            StealthMode = 1,
            PrMode = 2,
            PunchCardMode = 3,
            MessengerMode = 4
        }

        public enum FileSystemType
        {
            Local = 1,
            Azure = 2
        }

        public enum CriteriaType
        {
            Is = 1,
            IsNot = 2,
            IsEmpty = 3,
            IsNotEmpty = 4,
            StartsWith = 5,
            EndsWith = 6,
            Contains = 7,
            NotContains = 8
        }

        public enum EventType { 
            Message = 13,
            Signal=18
        }

        public enum WorkflowTaskType
        {
            StartEvent =0,
            MailTask =1 ,
            FieldUpdateTask,
            CheckListTask,
            ServiceTask,
            UserTask,
            EndEvent,
            ScriptTask,
            SendTask,
            ReceiveTask,
            XorGateWay,
            AndGateWay,
            EventGateWay,
            messageEvent,
            TimerEvent,
            TerminationEvent,
            ErrorEvent,
            EscalationEvent,
            SignalEvent,
            EventHelperUserTask
        }

    }
}
