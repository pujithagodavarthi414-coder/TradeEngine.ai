using System;
using System.Configuration;
using System.Web.Hosting;

namespace BTrak.Common
{
    public class AppConstants
    {
        public static Guid UserStoryBugType = new Guid("16E881A4-9C6D-4021-AA2A-E84C05FB608A");
        public const int ResetPasswodExpiredDays = 10;
        public const string TeamLead = "Lead Developer";
        public static Guid LeadDeveloperGuid = new Guid("3269CA75-879D-44BA-99E1-A94B8CA80E64");
        public const string AnalystDeveloper = "Analyst Developer";
        //public const int EditUserStory = 1;
        public const int ReplanUserStory = 2;
        public const string NewUserStory = "New user story added";
        public const string UserManagementView = "Manage Users";
        public const string ProjectManagement = "Manage Projects";
        public const string RoleManagementView = "Manage Roles";
        public const string LeadManagementViewDetails = "Manage Leads";
        public const string EmployeeManagement = "Add Employee";
        public static string UatBlobContainerRefernce = "uatsiteuploads";
        public static string LocalBlobContainerReference = "localsiteuploads";
        public static string HrmBlobDirectoryReference = "hrm";
        public static string AssetsBlobDirectoryReference = "assets";
        public static string FoodOrderBlobDirectoryReference = "foodorder";
        public static string ProjectsBlobDirectoryReference = "projects";
        public const string SuccessMessage = "success";
        public const string ErrorMessage = "error";
        public const string Description = "Description";
        public const string File = "File";
        public const string IgnoredHistoryConstant = "IgnoredHistory";
        public const string CreateLead = "Create Lead";
        public const int SalesExecutiveRole = 8;
        public const string SiteAddressExtension = ".snovasys.io";
        public const string EnvironmentName = "EnvironmentName";

        /*Asset Management*/
        public const string listofAssets = "List Of Assets";
        public const string Assetdashboard = "Asset Dashboard";
        public const string VendorManagementView = "Vendor Management";
        public const string LocationManagementView = "Location Management";
        public const string SupplierManagement = "Supplier Management";

        /*FoodOrders Management*/
        public const string OrdersDashBoard = "Orders DashBoard";
        public const string LateNightFoodOrders = "All Latenight FoodOrders";
        //public const string MakeAnOrder = "Make An Order";

        /*Canteen Management*/
        public const string CanteenManagementView = "Canteen Management";

        /*Leave Management*/
        public const string RoleNameOfHeadOfTheCompany = "CEO";
        public const string DefaultLeaveStatus = "Waiting For Approval";

        public const string LeaveApproved = "Approved";
        public const string LeaveRejected = "Rejected";
        public const string GetLeaveTypesApiUrl = "LeaveManagement/LeaveManagementApi/GetLeaveTypes";
        public const string GetLeaveSessionsApiUrl = "LeaveManagement/LeaveManagementApi/GetLeaveSessions";
        public const string GetLeaveStatusApiUrl = "LeaveManagement/LeaveManagementApi/GetLeaveStatus";
        public const string LoginApiUrl = "Api/LoginApi/Authorise";
        public const string ApplyOrUpdateLeaveApiUrl = "LeaveManagement/LeaveManagementApi/ApplyOrUpdateLeave";
        public const string DeleteLeaveApiUrl = "LeaveManagement/LeaveManagementApi/DeleteLeave/";
        public const string ApproveOrRejectLeaveApiUrl = "LeaveManagement/LeaveManagementApi/ApproveOrRejectLeave/";
        public const string GetLeavesListApiUrl = "LeaveManagement/LeaveManagementApi/GetLeavesList";
        public const string GetLeavesInfoApiUrl = "LeaveManagement/LeaveManagementApi/GetLeavesInfo";
        public const string AddCommentApiUrl = "LeaveManagement/LeaveManagementApi/AddComment";
        public const string GetLeaveCommentsApiUrl = "LeaveManagement/LeaveManagementApi/GetLeaveComments/";


        /* Status  */
        public const string NotStarted = "Not Started";
        public const string AnalysisCompleted = "Analysis Completed";
        public const string DevInprogress = "Dev Inprogress";
        public const string DevCompleted = "Dev Completed";
        public const string Deployed = "Deployed";
        public const string QAApproved = "QA Approved";
        public const string SignedOff = "Signed Off";
        public const string Inprogress = "Inprogress";
        public const string Completed = "Completed";
        public const string Blocked = "Blocked";
        /* Status  */

        public const string SuperAgile = "Super Agile";
        public const string Kanban = "Kanban";
        public const string KanbanBugs = "Kanban Bugs";

        // public const int FeedTimeSheet = 6;
        public const string SeriousIssue = "#ff141c";
        public const string SeriousIssueReplaceColor = "#ffcc99";

        public const string NoStatusColor = "#fff";

        public const string SettingsManagement = "Settings Management";
        public const string WorkingHours = "Working Hours";

        public const string LeaveTypeId = "34AE0967-6076-4F5A-9D45-3015E3D19B2A";
        public const string LeaveSessionId = "A720E52B-9D82-450E-BEEB-346D0838303B";
        public const string LeaveStatusId = "438F5E0C-519A-4F31-B177-0E5DA6A841E1";
        public const string LeaveApprovalId = "FC5848C8-F9CD-459D-AE32-27124C8728DA";
        public static Guid ApprovedStatusId = new Guid("29ba7038-b0a6-48a1-b448-10ada7af3c21");
        public static Guid RejectedStatusId = new Guid("29ba7038-b0a6-48a1-b448-10ada7af3c23");
        public const int AvgRoomTemp = 25;
        public static Guid SickLeaveTypeId = new Guid("F2785350-EF29-42E4-A7D5-7AC4FF086AD6");
        public static Guid CasualLeaveTypeId = new Guid("D2184B73-FD09-460B-9B13-81600A0C8084");
        public static Guid RemoteWorkingIndustryId = new Guid("7499F5E3-0EF2-4044-B840-2411B68302F9");
        public static Guid PracticeManagementIndustryId = new Guid("3AA49D13-76C9-4842-840E-4AC759B65DF8");
        public static Guid HRIndustryId = new Guid("FEC07283-AA98-41E1-B3D3-28CD6C6C5D97");
        public static Guid EnergySectorIndustryId = new Guid("BBBB8092-EBCC-43FF-A039-5E3BD2FACE51");

        /* Status Reporting */
        public const string Monday = "88DCEAB2-8497-4697-A807-8960D97574AB";
        public const string Tuesday = "DFE38C65-CD5E-48C1-91D1-68A902BE2A30";
        public const string Wednesday = "A69F6E29-1EC1-4686-A158-4C66BC903D76";
        public const string Thursday = "FD9D6C9F-FC56-4222-8479-494A46FD718B";
        public const string Friday = "A9BF44B3-67E9-4C1B-AF3E-2907C53444D3";
        public const string Saturday = "FC4559DC-EB5C-45B7-8F4A-EF7A132CCDB2";
        public const string Sunday = "5F158D61-6CAF-4635-9314-6EA5726C2EF1";
        public const string EveryWorkingday = "B8E4A61B-CC0C-4317-95B3-A743DD53E136";
        public const string LastWorkingdayoftheMonth = "3B422297-5A20-4F49-A0C6-F3277C233F76";
        public static readonly Guid Working = new Guid("37F7633A-05EA-4DF5-A9E0-A9114CEEA191");
        public static readonly Guid NoMoreRequirement = new Guid("651AAC7E-A41E-46E2-B603-62CCC2FB35E1");

        public static readonly string ApiUrl = ConfigurationManager.AppSettings["WebApiUrl"];

        public static readonly string MoneyDisplayFormat = "#.00";


        public static Guid OtherRelationShipGuid = new Guid("6E1B5094-C614-4158-BAB3-DC136AFD1F89");

        public static Guid TimesheetConstants = new Guid("D0EDA1CF-610A-43B1-821B-2A6EB8F0927A");

        /* Timesheet */
        public const string BackwardConstant = "backward";
        public const string WeekConstant = "week";
        public const string ForwardConstant = "Forward";
        public const string DayConstant = "Day";

        public const string CurrentUserStories = "CurrentUserStories";
        public const string PreviousUserStories = "PreviousUserStories";
        public const string FutureUserStories = "FutureUserStories";

        /* Board Type UI */
        public static Guid BoardTypeUiSuperAgile = new Guid("D0C55A82-303C-4976-8884-026441BA75BF");
        public static Guid BoardTypeUiKanban = new Guid("2F4A6A4F-D04A-42CA-9E87-C4FF95747288");
        public static Guid BoardTypeUiKanbanBugs = new Guid("E3F924E2-9858-4B8D-BB30-16C64860BBD8");
        /* Board Type UI */

        /* Board Type */
        public static Guid BoardTypeSuperAgile = new Guid("28009E1D-EB84-41F0-9541-E10F054FE6C1");
        public static Guid BoardTypeKanban = new Guid("B2683875-8FF4-4826-877D-3119B776441E");
        public static Guid BoardTypeKanbanBugs = new Guid("F28643CA-9F23-42E0-B51E-03F82A99A281");
        public static Guid BoardTypeApi = new Guid("9B5F4791-684B-4CAA-979B-3ECD8B3629C3");
        public static Guid BoardTypeLogTimeApi = new Guid("204169B4-3D26-4E45-9EB0-2EFD0BFD52DD");
        public static Guid BoardTypeTemparatureApi = new Guid("D495B567-C0B6-4B3A-A0DB-D918E4FB2FD1");

        /* Workflows */
        public static Guid SuperAgileWorkFlow = new Guid("B7A0A6E4-FA8F-4600-894D-0C66D89456D9");
        public static Guid KanbanWorkFlow = new Guid("E36CA831-A26E-414D-80CF-8C340CC3B395");
        public static Guid KanbanbugsWorkFlow = new Guid("029E3CE3-2D85-4956-BF78-C86C4DA8E217");

        /* User Story Status*/
        public static Guid NotStartedGuid = new Guid("67260E91-CDEF-41D0-AEBC-C48FD4DE814D");
        public static Guid New = new Guid("A50D34C9-F1C5-41B3-A9B9-63759FA3446F");
        public static Guid Verified = new Guid("C6E85DA3-649B-45FF-83B0-3C127BDD7712");
        public static Guid AnalysisCompletedGuid = new Guid("16BA9FD4-AA96-4B6C-909C-488CA4D4E9FD");
        public static Guid DevInprogressGuid = new Guid("47332259-7D32-479D-A704-569C00F2B0B3");
        public static Guid DevCompletedGuid = new Guid("733BFB1B-EF72-4586-9C09-AB9D4AD296D5");
        public static Guid DeployedGuid = new Guid("BC978F0D-6A8B-450F-85AE-E88BA37B06A2");
        public static Guid QAApprovedGuid = new Guid("B3B17186-6D07-4416-878D-F78A73A753FC");
        public static Guid SignedOffGuid = new Guid("D348204E-A7D4-40C1-A5AD-7A667D8F4216");
        public static Guid BlockedGuid = new Guid("4B959CA8-1B72-45C0-9199-1B274B099860");
        public static Guid UserStoryComments = new Guid("C31FD627-B65C-4884-8F6A-864C0AB8336E");
        public static Guid UserStoryTypeId = new Guid("16E881A4-9C6D-4021-AA2A-E84C05FB608A");
        public static Guid CompletedGuid = new Guid("7503DACE-D75A-4DF1-B687-64334263B908");

        /* Project And Goal Status */
        public const string NotStartedHex = "#b7b7b7";

        /* Goal Status Guid */
        public static Guid ActiveStateGuid = new Guid("7A79AB9F-D6F0-40A0-A191-CED6C06656DE");
        public static Guid ReplanStateGuid = new Guid("5AF65423-AFC4-4E9D-A011-F4DF97ED5FAF");
        public static Guid BacklogStateGuid = new Guid("F6F118EA-7023-45F1-BCF6-CE6DB1CEE5C3");
        public static Guid CompletedStateGuid = new Guid("CF5FDAE7-4E4E-4AEC-892B-C283D32EBB26");
        public static Guid NotNeededStateGuid = new Guid("80BD3EF1-A1D8-4E34-93F5-8239C2E21B58");
        public static Guid GaveUpStateGuid = new Guid("693C6DC2-210F-412B-AFD0-9A8DF9B3CF6E");

        /* UserStory Replan Types */
        public static Guid ChangeEstimatedTimeGuid = new Guid("DE88FF80-B0A0-4399-A933-5B2B948329ED");
        public static Guid ChangeDeadLineGuid = new Guid("F31341B2-7F08-4BDD-AD1B-7DC6B3824593");
        public static Guid ChangeUserStoryGuid = new Guid("F116F495-8E21-4F8F-A7B9-EE1E82E5B1D9");
        public static Guid ChangeOwnerGuid = new Guid("4B285F45-C06D-44D5-BC7E-E3CA3F02B179");
        public static Guid ChangeDependencyGuid = new Guid("0ED76463-B136-447F-895D-B5AD258EF481");

        //public static Guid OtherRelationShipGuid = new Guid("6E1B5094-C614-4158-BAB3-DC136AFD1F89");
        public static Guid IsAccessible = new Guid("ABF96D97-67ED-4889-A83E-2C5D86265A9D");
        public static Guid AddUserStory = new Guid("F52ED81D-C95C-423A-8DD0-5BA2F24445D0");
        public static Guid EditUserStory = new Guid("B559F45F-9190-413A-A81D-A0B367930912");
        public static Guid ArchiveUserStory = new Guid("BBFE2DB6-82D5-4F02-A5A9-A12539CD03A1");
        public static Guid AddGoal = new Guid("B807298F-0DF3-4C6B-8700-2E30D870F7A9");
        public static Guid LockGoal = new Guid("908A3813-7789-4CC3-A5D7-A6803B83EC45");
        public static Guid ApproveGoal = new Guid("D7D40C22-CCC4-48EF-876E-9FE13E65F9B6");
        public static Guid ArchiveProject = new Guid("ECA4BE28-AD9B-46B2-B6CA-BD293430A5F4");
        public static Guid ArchiveGoal = new Guid("A9A14F39-8980-42D5-8963-1D9A552EF779");
        public static Guid MainDashboard = new Guid("26F9BC5D-3CBF-4483-BD7E-98BA270A7F9E");
        public static Guid SnapshotMainDashboard = new Guid("B5A59FAF-2A4B-4794-9B6F-91332F4CFB90");
        public static Guid PreviewMainDashboard = new Guid("73AC549C-804F-4CD5-B203-801F09C68969");
        public static Guid LiveDashboard = new Guid("4191D298-4A53-4BEF-8A77-BE9E04F23B75");
        public static Guid SnapshotLiveDashboard = new Guid("1AE4F018-9974-4606-9882-70FB8CAF6B55");
        public static Guid HRDashboard = new Guid("15EA2EF2-72B6-4FE4-8028-C09C67D66F7D");
        public static Guid HRDashboardView = new Guid("80C4904F-D8CA-427A-80AD-5C027A31A934");
        public static Guid TimeSheet = new Guid("2843FEEB-8EF3-4EA0-8135-C8B60A652385");
        public static Guid ViewTimeSheet = new Guid("B67656BC-86FF-4B7B-B94A-9D127906127B");
        public static Guid FeedTimeSheet = new Guid("7718123F-7E8C-4E0C-9A9F-303E7DA10839");
        public static Guid HRManagement = new Guid("0A1AD1E7-1A0F-4B03-8B82-F814B36C4679");
        public static Guid AddEmployee = new Guid("23BA9FE2-33A2-4495-ACEF-C1D34C2B5857");
        public static Guid EmployeeList = new Guid("D7D8AD44-9C9A-446B-8904-478A8FF6C50F");
        public static Guid AddCredit = new Guid("7E0A7AF0-CF89-438A-BF3C-1FF9BDA74490");
        public static Guid PurchaseItem = new Guid("7927B248-362F-425A-8610-521E714457BB");
        public static Guid AddFoodItem = new Guid("06ABD2E9-5426-4E2B-A0FB-8932366B8322");
        public static Guid OrganizationChart = new Guid("E37B1251-07E8-4C9E-98A8-929731DFD938");
        public static Guid OrganizationChartView = new Guid("91B68A06-C9C0-4492-AE8C-348DF7D6316B");
        public static Guid RoomTemperature = new Guid("B126C444-24D6-4BF1-A91C-DBBC314C3872");
        public static Guid RoomTemperatureView = new Guid("EA74BBD4-7827-46E7-8C51-6FE7544C7E1B");
        public static Guid Audit = new Guid("8A7791A7-C5DB-4357-82BA-5F9D04AACF0F");
        public static Guid AuditHistory = new Guid("4DB8C220-EEA9-4C28-80F4-24300EFEF283");
        public static Guid TimeSheetHistory = new Guid("BF6207AE-AA6B-4EAE-840F-8FEEB5584770");
        public static Guid UserManagement = new Guid("CD903D29-C846-46AC-A0DC-C9F160F16526");
        public static Guid AddUser = new Guid("8478BC43-9C6F-4A4F-9E38-4FEC74CF8639");
        public static Guid EditUser = new Guid("BCBA2C08-27E3-4034-A458-2FA25E9C0C80");
        public static Guid Settings = new Guid("F5A3C106-F57D-4A04-A660-035E8ABD8561");
        public static Guid AddNewIPAddress = new Guid("C9702945-652F-41F7-A0D8-A16434668ACE");
        public static Guid AddCurrentIPAddress = new Guid("8193BAAC-62BF-4CBF-8388-C6BC967F19F5");
        public static Guid CurrencyId = new Guid("EA19C204-F130-487D-921C-22CD1F8AACEA");
        public static Guid AddProject = new Guid("0729A24F-1851-41F2-A994-2F3606A7DB7A");
        public static Guid EditProject = new Guid("09A10EB3-EDF2-4B79-B91B-4D385B327A54");
        public static Guid EditGoal = new Guid("6ED289A8-C817-436F-BFDA-8C11359C212E");
        public static Guid LiveDashboardView = new Guid("6A88C736-9DD5-420D-8895-2EEF797A1837");
        public static Guid MainDashboardView = new Guid("2829C08D-B0C8-4AE8-9EAA-4D1D1A8678DD");
        public static Guid MyProfile = new Guid("0528EC40-82A8-41C8-9DE3-E82D5E7CF4AE");
        public static Guid MyProfileView = new Guid("672302F7-97EF-450C-8B09-43FF0054671E");
        public static Guid LeadManagement = new Guid("2FB94EC2-1AA5-46B7-866E-7442AA2E2064");
        public static Guid LeadManagementView = new Guid("81DD75D7-F837-477F-9EDF-8A1665E53694");
        public static Guid AssetsManagement = new Guid("A4E43F04-A1FB-44AB-BE76-2E51E93A8A33");
        public static Guid ProductsManagement = new Guid("C190388E-D7C9-4B79-862D-33C8AAE51998");
        public static Guid SuppliersManagement = new Guid("22318DC0-C005-4F91-8D7B-495A962DF268");
        public static Guid AssetsDashboard = new Guid("3CFB0282-BB47-46D9-B98F-F068F5C0A650");
        public static Guid AssetsList = new Guid("DEEA78A2-0DB3-4A7F-A814-D8F28A01B4EA");
        public static Guid LocationManagement = new Guid("8AD4A2AF-A398-4508-8AD6-446DCCCB9E42");
        public static Guid VendorManagement = new Guid("0898DAD1-1732-4C08-8C2F-9A844AC612B6");
        public static Guid FoodOrderManagement = new Guid("57B2B1C6-D2A9-424E-A131-AE9E48EC6D33");
        public static Guid LeaveType = new Guid("CE8B75B5-2EB7-44C2-8BA2-99B6B846B66C");
        public static Guid SearchCompanyStructure = new Guid("27E9D2A3-1BFE-4C8D-B497-5E987883C643");
        public static Guid SearchMainUseCases = new Guid("B8160D7B-8519-41A6-A58E-03FFB958AEBD");
        public static Guid SearchDateFormats = new Guid("61372278-C8DE-4326-AF4F-40277A94AB45");
        public static Guid SearchTimeFormats = new Guid("4FE49F98-D40A-4EB6-AA0D-34C6CE792447");
        public static Guid SearchCompanies = new Guid("1C993177-54DC-49F0-AC71-FF26DAB3E649");
        public static Guid SearchIndustryModule = new Guid("9A5A5A52-10E8-42C5-9329-05B28B1A94C6");
        public static Guid SearchNumberFormats = new Guid("74D92BEC-CDD5-4961-B36B-E12F16E71EDE");
        public static Guid FoodOrderDashboard = new Guid("DACACDDD-474B-46BB-ACCB-E942A4D9DBF5");
        public static Guid LateNightFoodOrder = new Guid("C1FE1A0D-9E46-4C41-988C-67DFCF2881BE");
        public static Guid MakeAnOrder = new Guid("BB21773F-6CF3-49AB-B316-64A384ADF3BB");
        public static Guid RoleManagement = new Guid("F71F8874-5D1E-4F96-B8D9-7ECB18888766");
        public static Guid AddRole = new Guid("08A37693-91C7-45B5-8956-1CBAC792D796");
        public static Guid EditRole = new Guid("B3BE7453-5540-4D03-B455-8C3E2F145FB0");
        public static Guid CopyRole = new Guid("637E2C31-8C06-4D77-9792-E060743DB5EE");
        public static Guid ViewProjects = new Guid("1EA862E3-41B0-4F49-9C22-126CF381AB95");
        public static Guid SpentTimeReport = new Guid("2EE678C5-1EEF-44B2-8E29-A3F8753B73D6");
        public static Guid HrHistory = new Guid("B2C6CF30-4190-4EF2-BFFA-1B55A5E20F9F");
        public static Guid ToDo = new Guid("177118C6-8839-4179-B7F1-3C39A9CC0C05");
        public static Guid ToDoView = new Guid("0417F0C3-5D02-4609-AE27-4E302E77A3E2");
        public static Guid UpdateStatus = new Guid("987D7D66-601A-4358-B590-D3CD38A97C1A");
        public static Guid Owner = new Guid("05698BF1-D58B-46B3-BB7E-55D45D8A7DC5");
        public static Guid Dependency = new Guid("C522B6F6-DC5C-48CE-AB7B-961E4B664804");
        public static Guid StatusReporting = new Guid("BD4D8229-F1C3-4421-8D96-737682C62701");
        public static Guid StatusReportingConfiguration = new Guid("81D2F1A7-618A-46AF-A5A0-73A7E5AF38B7");
        public static Guid AddNewLead = new Guid("9922F0E8-A1E7-4007-B6C5-4BB90C8C5231");
        public static Guid EditLeadDetails = new Guid("4EBD4815-DB07-4B14-B796-DCB382C5E50C");
        public static Guid AddNotes = new Guid("57E4BD32-A062-4500-BA5E-CB8400BB55F2");
        public static Guid EditNotes = new Guid("1D176F32-449E-419E-BF5D-DC96B0002888");
        public static Guid SnoozeLead = new Guid("5D540FE3-A2D0-493E-8E0E-D9F569EACA6F");
        public static Guid ArchiveLead = new Guid("58470823-CC20-4B94-82D2-8389803BC9F5");
        public static Guid ProductivityIndexView = new Guid("FF225CD9-D163-4514-86C9-7F70F7F24C4F");
        public static Guid ViewLeadManagement = new Guid("D4707138-E3CE-4244-BC38-E2C03C12C141");
        public static Guid UserStoriesRecord = new Guid("298F5F6E-70D6-4D11-926D-A9C2C61E5D4E");
        public static Guid AccessRecord = new Guid("891B3877-BFB5-46EB-B2BF-9FCF07A3B5C4");
        public static Guid MemberAccessRecord = new Guid("9F910D2C-E807-4F71-9416-CAFC4408AE46");
        public static Guid ViewTimeSheetHistory = new Guid("15921452-ED38-4FE8-B8EE-F6B2507D25D1");
        public static Guid ReportsDashboard = new Guid("D0732791-833D-4644-82D3-CBF066F67D01");
        public static Guid MtdRecordInformation = new Guid("D63247B3-82F4-485B-A3F8-7E452064F3B5");
        public static Guid YtdInformation = new Guid("7595BCAE-AF57-40E9-A8ED-F1C3DE54C742");
        public static Guid Userstory = new Guid("45C33EE6-0177-4704-80EB-3776DFBF6CB4");
        public static Guid AddUserStoryReplan = new Guid("C04F5E7C-A0E4-4B2D-BD63-1153D6C46FE6");
        public static Guid GetGoal = new Guid("924AB89B-C445-4223-B432-321DC4AE8794");
        public static Guid AddGoalReplan = new Guid("FF50DC52-EE07-4D74-9132-BA23C336A24D");
        public static Guid LeaveManagement = new Guid("4AA0354A-46CD-4BD0-87F0-99D81045E549");
        public static Guid TransferCanteenAmount = new Guid("8B56F480-06CB-4CCE-8A01-F090230FFCC5");
        public static Guid AssetsReport = new Guid("DF0EAC63-B479-479A-86EE-A1A3FD0F025E");
        public static Guid EmployeeUserStories = new Guid("B5D0045B-898C-4835-BD51-FECA9F4B1E6F");
        public static Guid EmployeeWorkAllocationSummary = new Guid("E0ABC253-4EE3-46D5-9D10-994550D68487");
        public static Guid TimesheetFeed = new Guid("EAE83D12-A1DD-4D88-B140-D971CB809A31");
        public static Guid OverNight = new Guid("8A617EC8-F352-4E4D-92AC-14081473F2C3");
        public static Guid NextDayEnd = new Guid("A8D8EEF5-19FD-43D8-9B81-83A291C2FF99");
        public const string ExpenseStatusGuid = "f90720cb-47a2-4b97-86bd-09ec9cfc2f00";
        public const string ExpenseStatusReportGuid = "5c471d3d-92db-4dd6-ba86-f03a8ccbfe4e";
        public const string ExpenseStatusReportSubmitApprovalGuid = "644ecbc8-58d9-4ed9-8746-3b6187029f20";
        public const string ExpenseStatusReportRejectedGuid = "1ff8554f-d0c1-4d64-a115-9ce4d3e0db1d";
        public const string ExpenseStatusReportArchiveGuid = "23d67280-322a-4b88-b6b7-1f112e0cc80c";
        public const string ExpenseStatusReportReimbursedGuid = "fa273f7f-1565-40f8-9d64-ea137c92c5ef";
        public static Guid IsProductivekanabanBoard = new Guid("39CDA561-BA18-49DC-B73C-21C824A95A6B");
        public static Guid IsUserStoriesMultiSelect = new Guid("7832782D-94E5-4FE4-B8BC-A4E937F970F4");
        public static Guid CanteenManagementViewGuid = new Guid("161A332F-50AF-4BBC-924C-3CEE44E91432");
        public static Guid AllGoals = new Guid("7506ED21-C510-4894-8682-9B97ACE94050");
        public static Guid ProjectResponsiblePerson = new Guid("1D45CFEA-D62F-44CF-A21F-FA280C412AD1");
        public static Guid CEO = new Guid("0B2921A9-E930-4013-9047-670B5352F308");
        public static Guid UnassignedGuid = new Guid("A6C3A0B8-92F5-447C-9F07-FCA4574CACD6");
        public static Guid Widgets = new Guid("9AFC8BF2-D49A-487D-8F6C-0A7F4997E702");


        public static Guid UserManagementViewGuid = new Guid("E3524D81-294D-475E-96E8-F23259723FF8");

        public static Guid RoleManagementViewGuid = new Guid("758DDB24-2684-406A-991A-49EDF5CE9D6E");

        public static Guid ParkUserStory = new Guid("874D13FB-899E-4598-BDCD-F837D905B648");
        public static Guid ParkGoal = new Guid("661B2809-8928-4194-BF61-1EF3A22C9F64");

        public static Guid ProjectFeature = new Guid("8D628E40-CD02-44D7-B853-9375E5234C5D");
        public static Guid TestManagement = new Guid("C0A301B8-2E9B-45AD-A574-C483D1CB32B8");

        public static Guid FileSearchCriteriaInputCommandTypeGuid = new Guid("D29DBDE5-8471-496D-90FE-96F148B9C814");


        /* Permission Configurations */
        public static Guid GoalStatusConfiguration = new Guid("2A9519FB-E7A3-4BCD-AA97-8BFCD34E3E4F");
        public static Guid UserStoryStatusConfiguration = new Guid("0C7996E2-5F0E-4733-9DE8-FFF09291B370");

        /* Work Flow Management */
        public static Guid WorkFlowManagementGuid = new Guid("1227D35A-9357-43A0-A7A7-DF0DC13A9F72");
        public static Guid AddWorkFlowGuid = new Guid("F5C5E2C4-DE28-4604-B1C6-954904E1C03D");
        public static Guid AddWorkFlowStatusGuid = new Guid("1090138B-CC86-4AED-90C5-CCC34FBE5EB4");
        public static Guid EditWorkFlowStatusGuid = new Guid("10D33572-B09B-4B58-80DC-1D0DCE45E84A");
        public static Guid DeleteWorkFlowStatusGuid = new Guid("E1A8AFE2-79F3-4E25-9720-A79F03AA6873");
        public static Guid ReorderWorkFlowStatusGuid = new Guid("82AA58F8-90C1-4E2C-B174-AD38B61431F8");
        public static Guid AddNewTransitionGuid = new Guid("F92F00F8-19E3-49E4-8376-B78FCCD0AD26");
        public static Guid EditTransitionGuid = new Guid("27555DE6-C8D1-45C6-A441-9E4519DE2A02");
        public static Guid DeleteTransitionGuid = new Guid("2A812B44-9567-4CEF-97CE-C42760F75AC6");

        /* Board Type Work Flow Management */
        public static Guid BoardTypeWorkFlowManagementGuid = new Guid("EE48D6EB-D858-4A7A-BA2B-416E128404CC");
        public static Guid AddBoardTypeWorkFlowGuid = new Guid("75715ED3-6AD0-4A7F-98C8-BE07D1DB0821");
        //public static Guid EditBoardTypeWorkFlowGuid = new Guid("A6F8686B-491B-4F3B-973A-3BFE6509E61A");
        public static Guid EditBoardTypeUiGuid = new Guid("231F1867-711F-488C-8EE9-712C33FE7DCF");

        /* Permissions Management */
        public static Guid PermissionsManagementGuid = new Guid("39818493-19A5-4E3E-B76E-EAC244018312");
        public static Guid AddConfigurationGuid = new Guid("2CD11361-6F87-4DF1-AB3F-4883A247B684");
        public static Guid EditPermissionGuid = new Guid("00116D72-7EB8-49BE-BF52-1610F7CF8408");

        public static Guid GenericConfiguration = new Guid("C3896186-AC01-4E2E-A806-025DEE139311");
        public static Guid AddPermission = new Guid("1B562292-D4DB-44ED-8A84-9750E16F96D2");
        public static Guid EditPermission = new Guid("65BB44C3-BDEC-473D-8BCE-BCC8EF026A06");

        /* Fields */
        public static Guid UserStoryStatusGuid = new Guid("7362E870-D6E0-409E-8AF8-3CCEF03CC0AA");
        public static Guid UserStoryDependencyGuid = new Guid("4748329D-2EA0-495F-A65D-43AB2C69E6B4");
        public static Guid UserStoryOwnerGuid = new Guid("F548F6CB-14E7-4B06-AD0B-863EB9C3B3F4");
        public static Guid UserStoryDeadLineGuid = new Guid("385B30A8-8984-4B33-AE13-929720A17DE7");
        public static Guid UserStoryEstimatedTimeGuid = new Guid("93E7B421-23C7-4656-86C7-B965E62A269A");
        public static Guid UserStoryNameGuid = new Guid("47420F5A-1330-4EFD-9623-CE3BFBD93556");
        public static Guid UserStoryBugPriorityGuid = new Guid("EF384ED4-C7E6-4809-A080-1139AE838E70");
        public static Guid UserStoryBugCausedUserGuid = new Guid("577D5565-BF7B-41D7-88DB-C062F67098FA");
        public static Guid ProjectFeatureGuid = new Guid("914B0647-02D1-4AE3-8290-F997C5D85D2F");
        public static Guid UserStoryParkGuid = new Guid("70795395-7406-4483-9471-EC791731D96E");
        public static Guid UserStoryReorderGuid = new Guid("573A6362-896D-4510-BA56-FE652F4078E2");
        public static Guid UserStoryArchiveGuid = new Guid("74CA5CC9-7DF5-4BA1-B03A-E83CCEEF46D7");
        public static Guid FeatureGuid = new Guid("914B0647-02D1-4AE3-8290-F997C5D85D2F");

        /* Expenses */
        public const string ExpenseUnReportedStatus = "d139e62a-77c9-400a-b4f2-5989eed367a4";
        public const string ExpenseReportedStatus = "050c9946-64e2-47f7-9c77-0fad533b6c0c";
        public static Guid Finance = new Guid("e1ea97c1-7742-4794-a7e9-458b518c5a0d");
        public static Guid SubmittExpense = new Guid("beab1d27-32aa-4dc7-b536-799b0953957e");
        public static Guid ExpenseManagement = new Guid("82DC0A53-2408-49DE-9ED1-E9243F0D7EBD");
        public static Guid ExpenseReport = new Guid("ea184772-11b9-4974-b529-1885798c13e4");
        public static Guid ExpenseReimbursement = new Guid("827b4cf7-a79f-48be-b4b0-117368779f22");
        public static Guid ExpenseReject = new Guid("e6fdd22d-2c0c-4a51-8850-676dfdddf82b");
        public static Guid UndoReimbursement = new Guid("b314410c-86b2-4a7a-9e96-538406e3c834");
        public static Guid DeleteExpenseReport = new Guid("7D694DAC-502F-43F1-ABD8-4B42997C80CE");
        public static Guid ArchiveExpenseReport = new Guid("B5F147E4-7E21-416C-AEA6-C484014E6483");
        public static Guid UnArchiveExpenseReport = new Guid("FD09EFF8-B363-454C-B8B0-12EC4BFD438B");
        public static Guid CreateExpenseReport = new Guid("8792CA2A-C1EB-4092-876C-0E55A00C109C");
        public static Guid EditExpenseReport = new Guid("7273C5AD-6F57-4273-8146-BF04DCF6ECBF");
        public static Guid CreateExpense = new Guid("6169C540-F1E6-427B-9495-210CC130582C");
        public static Guid EditExpense = new Guid("6EE34173-6BAD-47BE-9789-BDA6DE18C791");
        public static Guid DeleteExpense = new Guid("0EB21059-0323-4402-B687-982DB75DA552");
        public static Guid CreateExpenseMerchant = new Guid("5BAF127D-328F-47A4-9592-4D265547512E");
        public static Guid CreateExpenseCategory = new Guid("65590B83-4D6A-4132-B933-3DE79F7B2CA3");

        /* HR Dashboard Report Level Permissions */
        public static Guid EmployeeAttendance = new Guid("C60A4B8A-7F61-4ADA-862A-D71ADCDD857F");
        public static Guid EmployeeWorkingDays = new Guid("EE278204-0315-4EE7-A4D1-5134C20594D3");
        public static Guid EmployeeSpentTime = new Guid("F260A2A2-0A1E-4B10-B90F-C0BB3FB73EE8");
        public static Guid LateEmployee = new Guid("838EE924-E1D4-4F09-9589-EE35AA09AFAA");
        public static Guid EmployeePresence = new Guid("36210950-5A2D-467B-AC98-A4341A5D2E24");
        public static Guid LateEmployeesCountVsDate = new Guid("10B5C173-E470-4369-BF9D-85EBC68F03F5");
        public static Guid Activity = new Guid("B217B301-4CDE-4BC3-B82F-FE292A2C9C50");
        public static Guid FeatureUsage = new Guid("A1B44831-D787-4240-9E64-33392A0207C1");
        public static Guid LeavesReport = new Guid("87348A3D-F5BD-44E5-B922-583AA1CB2B3E");
        public static Guid LogTimeReport = new Guid("2BCF0D2F-F5A7-48A8-8288-E7B96A843604");

        /* Project Management */
        public static string ProjectsManagementFeatureName = "Projects";

        public static int InputWithMaxSize20 = 20;
        public static int InputWithMaxSize50 = 50;
        public static int InputWithMaxSize100 = 100;
        public static int InputWithMaxSize250 = 250;
        public static int InputWithMaxSize500 = 500;
        public static int InputWithMaxSize800 = 800;
        public static int InputWithMaxSize1000 = 1000;
        public static int InputWithMaxSize2000 = 2000;

        public static int OtherThanLoggedUserType = 1;
        public static int LoggedUserType = 2;

        public static int Week = 5; // one week considered as 5 days
        public static int Day = 8; // one day considered as 8 hours

        /* Performance rolefeature */
        public static Guid CanApprovePerformanceFeatureId = new Guid("5E34726C-6368-49D0-88D8-7E4F4E7D0161");

        /* Work Management */

        public static Guid WorkManagement = new Guid("6FB373C4-D173-4CF3-9003-8AD035D35027");

        public static Guid SetTo = new Guid("E4155596-282F-40EE-BF83-7E996454AE66");
        public static Guid UseExistingEstimateHours = new Guid("8008E5E4-9060-41AF-80EC-BCB5BAF7C22C");
        public static Guid AdjustAutomatically = new Guid("197359ED-C9FE-4699-A394-C33CA66446EF");
        public static Guid ReduceBy = new Guid("60AA43AB-FD07-4654-A0E1-F1572C1E79DE");

        public static Guid Projects = new Guid("F3AEDC05-A81C-4F8F-B7F7-5B07C128CE12");
        public static Guid ProjectTags = new Guid("710BEA84-1787-4EC9-B0BC-9EC744D5DA76");
        public static Guid Goals = new Guid("FC361D23-F317-4704-B86F-0D6E7287EEE9");
        public static Guid UserStories = new Guid("BB2AFDD8-ED61-4F94-A5D6-024B06AAD854");
        public static Guid ProjectFeatures = new Guid("D6E35A46-5241-4683-90F4-D0BF8FD2FD90");
        public static Guid ProjectMembers = new Guid("6AA8EB9F-219D-4040-B74D-67D11D67C2F6");

        public static Guid UserStoryPriorities = new Guid("737D57E5-D29A-4D30-99AD-A60129AA5D8B");

        public static Guid Statuses = new Guid("73159254-3B0C-4DD1-BAF2-D23BBB96F6F2");
        public static Guid GoalStatuses = new Guid("F5EF1D71-92F8-4F42-96E0-6BAC50661A94");
        public static Guid ProcessDashboardStatuses = new Guid("66654FB7-4121-4256-9B7D-F4BE9ACC8C9D");

        public static Guid TransitionDeadlines = new Guid("CE286268-680E-4EE8-9397-CDDFD00F1DA3");

        public static Guid ProjectTypes = new Guid("379DCA60-68F0-406C-9C40-C5C634E36818");
        public static Guid ConfigurationTypes = new Guid("0BB78FE7-CF28-45DF-A878-EB0CC4E8B72C");
        public static Guid ConfigurationSettings = new Guid("FB8FE947-B6E0-4260-A50E-721D042461F6");

        public static Guid Roles = new Guid("212D77E7-3E63-4D44-9747-391523EE722F");

        public static Guid BoardTypes = new Guid("188D70D7-5C3E-4251-B871-4B0BA0D7665F");
        public static Guid BoardTypeApis = new Guid("5A7E2173-7640-45F3-B718-A4925F34F96D");
        public static Guid BoardTypeUis = new Guid("9F1C89F6-CB4A-4FA6-87F4-79B538D3EB9C");

        public static Guid WorkFlows = new Guid("6DD1EC32-7B9A-4078-9B1E-67B52BF4A1DC");
        public static Guid WorkFlowStatuses = new Guid("9EAD288C-7A44-46FD-A477-A31B2CB1C9AC");
        public static Guid WorkFlowEligibleStatusTransitions = new Guid("68A4FA19-12F3-43A4-BB17-25CF83853E70");

        public static Guid BugPriorities = new Guid("01550DC3-5796-41D9-90D0-4CDF1393CCFA");
        public static Guid GetUserStoryReplanTypes = new Guid("00FA8616-6ADE-42B2-8F8C-6607BD81D7B4");
        public static Guid Features = new Guid("D66E8F4A-C7DF-413A-B515-8065FC4DCF70");
        public static Guid ButtonTypes = new Guid("7CC5EB6E-35CE-4B94-9D60-A4678DFE34AA");
        public static Guid Comments = new Guid("28EF4204-1983-4DF9-843C-2144593B252B");
        public static Guid ConsiderHours = new Guid("80C1BCB4-D0C7-49EF-8B6D-4FEDE22619E5");

        public static Guid GoalReplanHistory = new Guid("B38F8E4F-8257-480B-A0C4-ABD896077E72");

        public static Guid EmployeeWorkAllocation = new Guid("85E02F29-E3E5-4428-9E77-2A42B190CDDA");
        public static Guid ProjectMemberWorkAllocation = new Guid("BD609B64-DBD7-4F4C-92B0-A3092C3DCEE1");

        public static Guid Employees = new Guid("52651790-8528-4471-B864-9894F36A7116");
        public static Guid Users = new Guid("3722A977-2578-43C3-BBA6-BDF79B741E10");
        public static Guid ChangePassword = new Guid("8C947AF0-C7CD-4F5C-B755-8396918B11DF");

        public static Guid GoalReplanTypes = new Guid("B0B28F3E-1323-44DE-99C8-CA6A40014432");
        public static Guid UserStorySubTypes = new Guid("3734D75C-4A16-4DB5-9455-B8AC4649F17D");
        public static Guid UserStoryLogTime = new Guid("C218D22A-D676-44BE-AB3A-6EF08F1C3DCD");
        public static Guid UserStoryLogTimeReport = new Guid("DBE32FD3-E64E-46CE-A87C-0F06ED2995E6");

        public static Guid ProductivityIndex = new Guid("E3E572EF-F2FD-4643-9982-B4A7ABBC8422");
        public static Guid DevQuality = new Guid("DA71CB6D-2758-4528-BBFF-D6F31EBB80B1");
        public static Guid QaPerformance = new Guid("68A49F78-4DB9-4F7D-B302-C3ED039F5B4C");
        public static Guid UserStoriesWaitingForQaApproval = new Guid("78D5F664-AA1F-4350-8496-8DE690AF0EC8");
        public static Guid EveryDayTargetStatus = new Guid("14E13B03-7429-44B6-9C23-2E5E81FF60CC");
        public static Guid BugReport = new Guid("EA9785B3-8AD8-416C-8194-6F9A3CB9CD05");

        public static Guid GenericForms = new Guid("137FA14C-E705-499E-ACDF-4926EECF74EE");
        public static Guid StatusReportingConfigurations = new Guid("455A85C4-BD8D-4425-B978-44D17778520D");
        public static Guid StatusReports = new Guid("455A85C4-BD8D-4425-B978-44D17778520D");

        public static Guid ViewContacts = new Guid("2D833750-66BD-4304-BE18-F2C746FC4944");
        public static Guid ViewChannels = new Guid("5F090472-709A-404E-B75B-D7FC6E909E2D");
        public static Guid ArchiveChannels = new Guid("353B2018-E652-490E-ABB1-8CBE78B2140F");
        public static Guid ViewChannelMembers = new Guid("654A8263-8635-4AF2-B0BF-7B4F967AB2F3");
        public static Guid ArchiveChannelMembers = new Guid("AB0AC7A3-6528-4A5D-B542-BF43CAB9630F");
        public static Guid ViewChat = new Guid("2C741072-65A1-48F8-AF89-FA35EAC9DC74");
        public static Guid MainUseCases = new Guid("DBAB4D67-CD18-4A09-AF96-D77028FB984C");

        public static Guid Canteen = new Guid("75FB990C-094A-4038-B509-B136BD367B2B");
        public static Guid CompanyLocation = new Guid("84F8992A-655C-4C1E-9227-0190768F45F9");

        public static Guid TimeZone = new Guid("D5FAEE0E-A714-4C6A-A321-6E5A7A3053EF");
        public static Guid DefaultTimeZoneId = new Guid("C527B633-9FB6-4D9F-BE87-5172DBE87D18");

        public static Guid ContractTypes = new Guid("94C0BC7E-9169-43D2-8A1C-FEA5B3F9D7B3");
        public static Guid Departments = new Guid("B6D5D5A5-67FE-4D00-87FB-F93FEFFE7AC8");
        public static Guid Designations = new Guid("F90EC95A-EB75-4D7E-AC6E-BC36583814BB");
        public static Guid PayGrades = new Guid("9896F9FE-A4C6-4ABB-B404-B26CA3363520");
        public static Guid BreakTypes = new Guid("9CDC56A9-C03B-4AE6-A3F1-D90FA72A3B80");
        public static Guid Countries = new Guid("3910D8E2-DE74-4696-918D-D71D2A845CFD");
        public static Guid Regions = new Guid("B41E3EE1-1587-4EA6-A81F-57C33F89D68B");
        public static Guid Branches = new Guid("C8768528-BFC2-46B7-B2F5-788352485977");
        public static Guid CompanyStructure = new Guid("67425175-B6D7-4DD1-AC1A-3C10B003D29C");

        public static Guid Performance = new Guid("A1B5255B-A294-4E8D-8674-223A6FE16218");

        public static Guid Nationalities = new Guid("EF993FE2-E6E2-4222-B7AC-CDDE6078BDF0");
        public static Guid AllNationalities = new Guid("6601C87E-18DB-4345-BFD1-0F9724C8BA40");
        public static Guid ManageGenders = new Guid("891CC46B-CBAF-49A7-9974-A3FD6824C483");
        public static Guid ManageMartialStatuses = new Guid("D5FF153B-7AB6-480A-8826-18CA2F619287");

        public static Guid SubscriptionPaidBys = new Guid("09E6746A-C4A4-46C9-B3FB-D2672C9607C2");
        public static Guid Memberships = new Guid("A366C067-9182-418F-A853-79130167001A");
        public static Guid EmployeeBankDetails = new Guid("F90EC95A-EB75-4D7E-AC6E-BC36583814BB");

        public static Guid EntityFeatures = new Guid("212D77E7-3E63-4D44-9747-391523EE722F");
        public static Guid EntityRoleFeatures = new Guid("F3AEDC05-A81C-4F8F-B7F7-5B07C128CE12");

        public static Guid GoalTags = new Guid("DEC78E4B-A8A3-4AAD-A026-51B6A4D51EC6");
        public static Guid UserStoryTags = new Guid("DEC78E4B-A8A3-4AAD-A026-51B6A4D51EC6");

        public static Guid ViewTestrepoReports = new Guid("3D569305-47CE-4674-AC8D-A830B9D1FD2B");

        public static Guid Feedback = new Guid("F07A7236-167B-492F-A1CA-D63D5A8ECC11");

        //public static Guid EmployeeDetails = new Guid("F90EC95A-EB75-4D7E-AC6E-BC36583814BB");
        //Service bus 

        //Servicebus constants for chat application
        public static string MessageType = "Text";
        public static string CommeNotificatonMessage = "Added comment: {0}";
        public static string ApplicationName = "BTrak";

        //App reference typeIds
        public static Guid UserStoryReferenceTypeId = new Guid("1B35F2D3-1972-491F-8DC8-0A2A1F429934");
        public static Guid ProjectReferenceTypeId = new Guid("26A91CCF-504A-479C-8E8F-92128FB03AF6");
        public static Guid ImmigrationReferenceTypeId = new Guid("563D8A1B-5C33-43C9-8923-8A6982FE2AE9");
        public static Guid LicenceReferenceTypeId = new Guid("7C246F5A-12B3-4938-8208-AD572044CD48");
        public static Guid MembershipReferenceTypeId = new Guid("4AA9C448-A227-4C93-AF08-EDD967494669");
        public static Guid ContractReferenceTypeId = new Guid("99F52614-3394-44FE-8C7F-F308B00E472D");
        public static Guid TestRunActualResultReferenceTypeId = new Guid("F86D67E1-D351-4A76-9FDD-06D1A9D84181");
        public static Guid ContactReferenceTypeId = new Guid("257E4D44-653F-453F-A957-1242C1ECDDD1");
        public static Guid ExpensesReferenceTypeId = new Guid("B7E64259-2F29-4006-A997-13F94CE73B10");
        public static Guid TestSuiteCasePreconditionReferenceTypeId = new Guid("ED61D300-9A7C-450F-8942-2444DACEAD0F");
        public static Guid SprintUserstoryReferenceTypeId = new Guid("FFD17211-18F0-4954-A2E5-251671E937B8");
        public static Guid CustomApplicationReferenceTypeId = new Guid("360F040E-D4C4-42DC-B687-262F4E28B0BD");
        public static Guid LeavesReferenceTypeId = new Guid("E1F5D8AD-B150-4AAA-B78B-362662708E4D");
        public static Guid PersonalDetailsReferenceTypeId = new Guid("B3A25B57-9451-426F-92BE-37E44DAC7251");
        public static Guid GoalReferenceTypeId = new Guid("A40F3109-F880-4214-9367-4D5E86864649");
        public static Guid TestSuiteCaseReferenceTypeId = new Guid("FFDFBE28-D3D9-49F9-9018-50E02D9C8F5B");
        public static Guid DocumentStoreReferenceTypeId = new Guid("2039EE64-BB6E-4757-9E33-55521DC7CC46");
        public static Guid CustomReferenceTypeId = new Guid("DF52BB58-F895-4C7F-B0C1-5D3C5737CC3E");
        public static Guid TestSuiteStepExpectedReferenceTypeId = new Guid("3A3E185B-BD74-4DB6-86BC-677EB9AB1609");
        public static Guid AuditQuestionsReferenceTypeId = new Guid("A9F71842-E4EB-4410-A1C2-69D7BE4BCDBD");
        public static Guid SkillDetailsReferenceTypeId = new Guid("D9E47257-0C4B-4A74-95B5-69FD9CA3C344");
        public static Guid StatusReportingReferenceTypeId = new Guid("244F513B-214B-4919-A0B4-766EE5FFF6BB");
        public static Guid BankReferenceTypeId = new Guid("A593FBE8-DD0A-4B0C-BAC9-79D03BB173A8");
        public static Guid TestSuiteTextDescriptionReferenceTypeId = new Guid("4232A177-164E-456C-B427-7BDEED92DA1D");
        public static Guid EmergencyContactsReferenceTypeId = new Guid("FBDE7023-69A9-4400-8852-81B6AD86E2C5");
        public static Guid ConductsReferenceTypeId = new Guid("0FFD91F7-E1A3-44E1-A304-85E62745F25B");
        public static Guid FoodOrderReferenceTypeId = new Guid("B367553E-79BE-4E37-8D3A-8906793BA0A8");
        public static Guid TaxAllowanceProofsReferenceTypeId = new Guid("F127D3A8-4BE6-40B8-93B3-9397FD830458");
        public static Guid EducationReferenceTypeId = new Guid("22DC965A-F3B9-4FCE-A093-942454A5D552");
        public static Guid TestSuiteCaseGoalReferenceTypeId = new Guid("CFB83453-60DD-4EB5-9818-95CDB3478AC5");
        public static Guid SalaryReferenceTypeId = new Guid("6EE25290-8D7A-49A1-9DA7-99BB1555F473");
        public static Guid DependentsReferenceTypeId = new Guid("40B1D262-C2AE-421D-96E3-9ABFC6383DF9");
        public static Guid IdentificationReferenceTypeId = new Guid("7C246F5A-12B3-4938-8208-AD572044CD48");
        public static Guid CompanyStructureReferenceTypeId = new Guid("5CDE441F-818A-4EEC-BA45-AF3A636C815D");
        public static Guid TestSuiteStepDescriptionReferenceTypeId = new Guid("225BEB5C-1A53-40BB-A29B-B03BE3FA2779");
        public static Guid AuditsReferenceTypeId = new Guid("1618EA33-ACE8-4838-9658-B8E713CEB9DB");
        public static Guid SprintReferenceTypeId = new Guid("38148E7C-9B2F-4735-848D-BD703195A395");
        public static Guid TestRunStatusCommentReferenceTypeId = new Guid("37EF5578-77AA-4A44-AB1E-BE76B585B2CE");
        public static Guid TestSuiteCaseMissionReferenceTypeId = new Guid("77F086EA-E23F-414D-AD14-D4725CEF36C2");
        public static Guid WorkExperienceReferenceTypeId = new Guid("7F65B187-8035-4966-B425-D4B29D24AB2D");
        public static Guid TestSuiteTextExpectedReferenceTypeId = new Guid("6520F42D-DA2E-40E2-BAFA-D5EE4D37F4A3");
        public static Guid PayrollRunReferenceTypeId = new Guid("22459A42-25E0-4315-A64D-D943949ED0AE");
        public static Guid TestRunAssigneeCommentReferenceTypeId = new Guid("E6A6B453-3D12-4F24-894F-E923FFB1C154");
        public static Guid LanguageReferenceTypeId = new Guid("5234405A-A2FC-40E9-ABC2-EDA24F4B8CC3");
        public static Guid JobReferenceTypeId = new Guid("CC4826BF-5E8E-472C-A44F-F8DB6BE32593");
        public static Guid AuditsEvidenceUploadReferenceTypeId = new Guid("98A3A24D-BE04-4A12-8E48-73648A0507FB");
        public static Guid ConductsEvidenceUploadReferenceTypeId = new Guid("6A752767-347B-4E6C-8F73-4E3FA9BF0ACC");
        public static Guid AuditQuestionsEvidenceUploadReferenceTypeId = new Guid("D8C4322A-7041-473A-A4B1-3608B260A5B7");
        public static Guid ConductQuestionsEvidenceUploadReferenceTypeId = new Guid("C6BA92FE-B4A5-4082-B513-9FDCA29610B8");
        public static Guid EvidenceUploadReferenceTypeId = new Guid("BFB5614F-34DE-45C2-AEDA-A2B387FA35C6");
        public static Guid GenericMailReferenceTypeId = new Guid("733C033C-F047-4907-A741-88E9F3090F85");

        //Audit status
        public const string DraftStatus = "DRAFT";
        public const string SubmittedStatus = "SUBMITTED";
        public const string ApprovedStatus = "APPROVED";

        //Test Rail
        public const string Json = "json";
        public const string Excel = "excel";

        public static TimeSpan DefaultStartTime = new TimeSpan(9, 0, 0);
        public static TimeSpan DefaultEndTime = new TimeSpan(18, 0, 0);
        public static string DefaultCurrencyCode = "GBP";

        public const string PayrollSubmittedStatus = "Submitted";
        public const string PayrollPaidStatus = "Paid";
        public const string PayrollApprovedStatus = "Approved";

        public static Guid RosterJobid = new Guid("5625FD19-9232-4CEC-943E-BB51142C15FB");
        public static string RosterCronExpression = "";
        
        public static string uploadFileChunkPath = HostingEnvironment.MapPath("~/upload");

        //platforms
        public static Guid Android = new Guid("C164DCA6-EEA1-48BF-A6A2-3781E5CD7F82");
        public static Guid Windows = new Guid("619EA9F2-E524-4C79-9568-E1BDA78E46B8");

        //Stastus
        public static Guid Active = new Guid("1425BFB4-56D6-4D0D-A0CA-EE2974D7886E");
        public static Guid Break = new Guid("F0F84CD3-80F6-4D16-AA27-953862FADAEA");
        public static Guid Offline = new Guid("AD591598-9D5D-4F13-BCB7-EBB66D52A9CE");
        public static Guid Inactive = new Guid("D5A18E5B-FA73-47CB-95BD-73D7581A8FF9");
        public static Guid Lunch = new Guid("0759498A-4A4E-437C-AF27-F40D0381D00F");
        public static Guid Finish = new Guid("39C16949-1B0F-40E3-8C4A-4733A0653E4A");
        public const string DefaultTimeZone = "India Standard Time";
        public const string DefaultPresenceChannelName = "MessengerPresence-{0}";
        
        public const string ActiveStatusName = "Active";
        public const string MobileStatusName = "Mobile";
        public const string LeaveStatusName = "Leave";
        public const string LunchStatusName = "Lunch";
        public const string FinishStatusName = "Finish";
        public const string BreakStatusName = "Break";
        public const string InactiveStatusName = "Inactive";
        public const string OfflineStatusName = "Offline";
        public const string SnoozeStatusName = "Snooze";
        public const string AuditsBlobDirectoryReference = "audits";
        public const string ConductsBlobDirectoryReference = "conducts";

        public const string ActivityTrackerBlobContainerName = "activitytrackercontainer";

        //AuditQuestionTypes
        public const string DropdownQuestionTypeId = "D628F2C7-6B90-41F6-986A-86105E2BF1A2";
        public const string BooleanQuestionTypeId = "C1CEE1F5-B2D9-4015-BA8D-C0E28D637A2D";
        public const string DateQuestionTypeId = "37094A98-C1E8-4536-A3FD-7621B8538C1F";
        public const string NumericQuestionTypeId = "9F0068F6-B128-4F70-8449-E286EC548AFA";
        public const string TextQuestionTypeId = "2A65297E-BDAF-4F0F-B485-2F7B9F4BFC08";
        public const string TimeQuestionTypeId = "3379266F-C49F-444C-BF07-3CA88313D8F8";

        //SwitchBlActionTypes
        public const string SwitchBlSplitActionText = "We performed split action as per your contract quantity requirements";
        public const string SwitchBlCombineActionText = "We performed combine action as per your contract quantity requirements";
        public const string SwitchBlOneByOneActionText = "We performed onebyone action as per your contract quantity requirements";
    }
}
