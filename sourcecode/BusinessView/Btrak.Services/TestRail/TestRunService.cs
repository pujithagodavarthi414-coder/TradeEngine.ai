using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Projects;
using Btrak.Models.SystemManagement;
using Btrak.Models.TestRail;
using Btrak.Models.UserStory;
using Btrak.Services.Audit;
using Btrak.Services.Communication;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.TestRailValidationHelpers;
using Btrak.Services.Projects;
using Btrak.Services.User;
using Btrak.Services.UserStory;
using BTrak.Common;
using BTrak.Common.Texts;
using CsvHelper;
using Hangfire;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Script.Serialization;
using System.Xml;

namespace Btrak.Services.TestRail
{
    public class TestRunService : ITestRunService
    {
        private readonly IAuditService _auditService;
        private readonly IUserService _userService;
        private readonly IProjectService _projectService;
        private readonly TestRailPartialRepository _testRailPartialRepository;
        private readonly ITestRailFileService _testRailFileService;
        private readonly IOverviewService _overviewService;
        private readonly TestRailValidationHelper _testRailValidationHelper;
        private readonly TestSuiteValidationHelper _testSuiteValidationHelper;
        private readonly ITestSuiteService _testSuiteService;
        private readonly IMilestoneService _milestoneService;
        private readonly IUpdateGoalService _goalService;
        private readonly FileRepository _fileRepository;
        private readonly GoalRepository _goalRepository = new GoalRepository();
        private readonly ICompanyStructureService _companyStructureService;
        private readonly UserRepository _userRepository;
        private readonly IEmailService _emailService;

        public TestRunService(IAuditService auditService, IUserService userService, TestRailPartialRepository testRailPartialRepository, UserRepository userRepository,
            ITestRailFileService testRailFileService, IOverviewService overviewService,
            TestRailValidationHelper testRailValidationHelper, TestSuiteValidationHelper testSuiteValidationHelper, ICompanyStructureService companyStructureService,
            ITestSuiteService testSuiteService, IProjectService projectService, IMilestoneService milestoneService, GoalRepository goalRepository, IUpdateGoalService goalService, IEmailService emailService)
        {
            _auditService = auditService;
            _userService = userService;
            _testRailPartialRepository = testRailPartialRepository;
            _testRailFileService = testRailFileService;
            _overviewService = overviewService;
            _testRailValidationHelper = testRailValidationHelper;
            _testSuiteValidationHelper = testSuiteValidationHelper;
            _testSuiteService = testSuiteService;
            _projectService = projectService;
            _milestoneService = milestoneService;
            _companyStructureService = companyStructureService;
            _goalService = goalService;
            _goalRepository = goalRepository;
            _userRepository = userRepository;
            _emailService = emailService;
        }

        public Guid? UpsertTestRun(TestRunInputModel testRunInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Run", "testRunInputModel", testRunInputModel, "TestRun Service"));

            _testRailValidationHelper.UpsertTestRunValidation(loggedInContext, validationMessages, testRunInputModel);

            string selectedCasesXml = null;

            string selectedSectionsXml = null;

            if (validationMessages.Any())
            {
                return null;
            }

            if (testRunInputModel.SelectedCases != null && testRunInputModel.SelectedCases.Count > 0)
            {
                selectedCasesXml = Utilities.GetXmlFromObject(testRunInputModel.SelectedCases);
            }

            if (testRunInputModel.SelectedSections != null && testRunInputModel.SelectedSections.Count > 0)
            {
                selectedSectionsXml = Utilities.GetXmlFromObject(testRunInputModel.SelectedSections);
            }

            var testRunId = _testRailPartialRepository.UpsertTestRun(testRunInputModel, loggedInContext, selectedCasesXml, selectedSectionsXml, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testRunId != Guid.Empty)
            {
                var testRailAuditJsonModel = new TestRailAuditJsonModel
                {
                    Title = testRunInputModel.TestRunName,
                    TitleId = testRunId,
                    Action = testRunInputModel.TestRunId == null ? "Created"
                        : testRunInputModel.IsArchived ? "Deleted"
                        : testRunInputModel.IsCompleted == true ? "Closed" : "Updated",
                    TabName = "TestRun",
                    ColorCode = "#e5ae47"
                };
                _overviewService.SaveTestRailAudit(testRailAuditJsonModel, loggedInContext, validationMessages);

                if (validationMessages.Count > 0)
                {
                    return null;
                }

                _auditService.SaveAudit(AppCommandConstants.UpsertTestRunCommandId, testRunInputModel, loggedInContext);

                if (testRunInputModel.TestRunId == testRunId)
                {
                    LoggingManager.Debug("Test Run is updated Successfully with the Id:" + testRunId);
                }
                else
                {
                    LoggingManager.Debug("Test Run is created Successfully with the Id:" + testRunId);
                }

                BackgroundJob.Enqueue(() => UpdateFolderAndStoreSizeByFolderId(testRunId, loggedInContext));

                return testRunId;
            }

            return null;
        }

        public TestRunApiReturnModel GetTestRunById(Guid? testRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Run By Id", "testRunId", testRunId, "Test Run Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetTestRunByIdCommandId, testRunId, loggedInContext);

            TestRunSearchCriteriaInputModel testRunSearchCriteriaInputModel = new TestRunSearchCriteriaInputModel
            {
                TestRunId = testRunId
            };

            var testRuns = _testRailPartialRepository.SearchTestRuns(testRunSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testRuns.Count > 0)
            {
                TestRunApiReturnModel testRun = testRuns[0];
                if (testRun?.IsIncludeAllCases != null && (bool)testRun.IsIncludeAllCases)
                {
                    var overviewInputModel = new TestSuiteCasesOverviewInputModel
                    {
                        TestSuiteId = testRun.TestSuiteId
                    };
                    testRun.TestSuiteCases = _testSuiteService.GetTestSuiteCasesOverview(overviewInputModel, loggedInContext, validationMessages);
                }
                else
                {
                    if (testRun?.SelectedCasesXml != null)
                    {
                        testRun.SelectedCasesDetails = Utilities.GetObjectFromXml<TestCaseOverviewModel>(testRun.SelectedCasesXml, "SelectedCases").ToList();
                    }
                }

                return testRun;
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundTestRunWithTheId, testRunId)
            });

            return null;

        }

        public Guid? DeleteTestRun(Guid? testRunId, byte[] timeStamp, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Test Run", "testRunId", testRunId, "Test Run Service"));

            _testSuiteValidationHelper.TestRunIdValidation(testRunId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.DeleteTestRunCommandId, testRunId, loggedInContext);

            TestRunInputModel testRunInputModel = new TestRunInputModel
            {
                TestRunId = testRunId,
                TimeStamp = timeStamp
            };

            var returnTestRunId = _testRailPartialRepository.DeleteTestRun(testRunInputModel, loggedInContext, validationMessages);

            return validationMessages.Count > 0 ? null : returnTestRunId;
        }


        public Guid? UpsertTestPlan(TestPlanInputModel testPlanInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Plan", "testPlanInputModel", testPlanInputModel, "Test Run Service"));

            string testSuiteIdsXml = string.Empty;

            _testRailValidationHelper.UpsertTestPlanValidation(loggedInContext, validationMessages, testPlanInputModel);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testPlanInputModel.TestSuiteIds != null)
            {
                testSuiteIdsXml = Utilities.GetXmlFromObject(testPlanInputModel.TestSuiteIds);
            }

            var testPlanId = _testRailPartialRepository.UpsertTestPlan(testPlanInputModel, loggedInContext, testSuiteIdsXml, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testPlanId != Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Test Plan audit saving", "TestRun Service"));

                var testRailAuditJsonModel = new TestRailAuditJsonModel
                {
                    Title = testPlanInputModel.TestPlanName,
                    TitleId = testPlanId,
                    Action = testPlanInputModel.TestPlanId == null ? "Created"
                        : testPlanInputModel.IsArchived ? "Deleted"
                        : testPlanInputModel.IsCompleted ? "Closed" : "Updated",
                    TabName = "TestPlan",
                    ColorCode = "#e5ae47"
                };
                _overviewService.SaveTestRailAudit(testRailAuditJsonModel, loggedInContext, validationMessages);

                if (validationMessages.Count > 0)
                {
                    return null;
                }

                _auditService.SaveAudit(AppCommandConstants.UpsertTestPlanCommandId, testPlanInputModel, loggedInContext);

                if (testPlanInputModel.TestPlanId == testPlanId)
                {
                    LoggingManager.Debug("Test Plan is updated Successfully with the Id:" + testPlanId);
                }
                else
                {
                    LoggingManager.Debug("Test Plan is created Successfully with the Id:" + testPlanId);
                }

                return testPlanId;
            }

            return null;

        }

        public TestPlanApiReturnModel GetTestPlanById(Guid testPlanId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Plan By Id", "TestPlanId", testPlanId, "Test Run Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetTestPlanByIdCommandId, testPlanId, loggedInContext);

            TestPlanSearchCriteriaInputModel testPlanSearchCriteriaInputModel = new TestPlanSearchCriteriaInputModel
            {
                TestPlanId = testPlanId
            };

            var testPlans = _testRailPartialRepository.SearchTestPlans(testPlanSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testPlans.Count > 0)
            {
                return testPlans[0];
            }

            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundTestPlanWithTheId, testPlanId)
            });

            return null;

        }

        public List<DropdownModel> GetProjectMemberDropdown(Guid projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Project Member Dropdown", "ProjectId", projectId, "TestRun Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetProjectMemberDropdownCommandId, projectId, loggedInContext);

            var projectMembers = _testRailPartialRepository.GetProjectMemberDropdown(projectId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<DropdownModel> users = new List<DropdownModel>();

            foreach (var projectMember in projectMembers)
            {
                DropdownModel user = new DropdownModel
                {
                    Id = projectMember.UserId,
                    Value = projectMember.UserName,
                    ProfileImage = projectMember.ProfileImage
                };

                users.Add(user);
            }

            return users;

        }

        public List<TestRunApiReturnModel> SearchTestRuns(TestRunSearchCriteriaInputModel testRunSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Runs", "testRunSearchCriteriaInputModel", testRunSearchCriteriaInputModel, "TestRun Service"));

            _auditService.SaveAudit(AppCommandConstants.SearchTestRunsCommandId, testRunSearchCriteriaInputModel, loggedInContext);

            if (!string.IsNullOrEmpty(testRunSearchCriteriaInputModel.TestRunIds))
            {
              string[] testRunIds = testRunSearchCriteriaInputModel.TestRunIds.Split(new[] { ',' });

              List<Guid> allTestRunIds = testRunIds.Select(Guid.Parse).ToList();

              testRunSearchCriteriaInputModel.TestrunIdsXml = Utilities.ConvertIntoListXml(allTestRunIds.ToList());
            }
            else
            {
             testRunSearchCriteriaInputModel.TestRunIds = null;
            }

           var testRuns = _testRailPartialRepository.SearchTestRuns(testRunSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return testRuns;
        }

        public List<TestRailHistoryModel> GetUserStoryScenarioHistory(TestCaseHistoryInputModel testCaseHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get UserStory Scenario History", "GetUserStoryScenarioHistory", testCaseHistoryInputModel, "TestRun Service"));

           //_testRailValidationHelper.ValidateUserstoryId(loggedInContext, validationMessages, testCaseHistoryInputModel);

            List<UserStoryHistoryModel> userStoryHistoryList = new List<UserStoryHistoryModel>();

            if (validationMessages.Count > 0)
            {
                return null;
            }

            var userStoryScenarioHistoy = _testRailPartialRepository.GetUserStoryScenarioHistory(testCaseHistoryInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }
            if (userStoryScenarioHistoy.Count > 0 && testCaseHistoryInputModel.UserStoryId != null)
            {               
                userStoryScenarioHistoy.Where(p => p.TestCaseId != null && p.TestRunId == null ).ToList().ForEach(t => { t.Description = string.Format(GetPropValue(t.Description),  t.TestCaseTitle , t.OldValue, t.NewValue); });
                userStoryScenarioHistoy.Where(p => p.TestCaseId == null && p.TestRunId == null ).ToList().ForEach(t => { t.Description = string.Format(GetPropValue(t.Description),t.TestCaseTitle, t.OldValue, t.NewValue,t.StepText); });
            }

            return userStoryScenarioHistoy;
        }

        public Guid? InsertTestCaseHistory(TestCaseHistoryMiniModel testCaseHistoryMiniModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertTestCaseHistory", "InsertTestCaseHistory", "TestRun Service"));

            _auditService.SaveAudit(AppCommandConstants.InsertTestCaseHistoryCommandId, testCaseHistoryMiniModel, loggedInContext);

            var testCaseHistory = _testRailPartialRepository.InsertTestCaseHistory(testCaseHistoryMiniModel, loggedInContext, validationMessages);

            return testCaseHistory;
        }

        public List<TestTeamStatusReportingRetunrModel> GetTestTeamStatusReporting(TestTeamStatusReportingInputModel testTeamStatusReportingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTestTeamStatusReporing", "GetUserStoryScenarioHistory", "TestRun Service"));

            List<TestTeamStatusReportingRetunrModel> testTeamStatusReporing = _testRailPartialRepository.GetTestTeamStatusReporting(testTeamStatusReportingInputModel, loggedInContext, validationMessages);

            return testTeamStatusReporing;
        }

        public async Task PushSplitBar(string webhookUrl, LoggedInContext loggedInContext)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "PushSplitBar", "TestRun Service"));

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            TestTeamStatusReportingInputModel testTeamStatusReportingInputModel = new TestTeamStatusReportingInputModel()
            {
                UserId = loggedInContext.LoggedInUserId
            };

            var barChartRequiredData = GetTestTeamStatusReporting(testTeamStatusReportingInputModel, loggedInContext, validationMessages);

            var htmlInput = GetD3SplitBarChartHtml(barChartRequiredData, loggedInContext);

            if (htmlInput != null)
            {
                await _goalService.ConvertHtmlToImageAndPushMessageToSlack(htmlInput, "Expected vs actual spent hours", "Expected vs actual spent hours", webhookUrl);
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Post burndown", "Update goal service"));
        }

        public async Task PushSplitBarToWebHook(string url, LoggedInContext loggedInContext)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "PushSplitBarToBtrakChat", "TestRun Service"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                TestTeamStatusReportingInputModel testTeamStatusReportingInputModel = new TestTeamStatusReportingInputModel()
                {
                    UserId = loggedInContext.LoggedInUserId
                };

                var barChartRequiredData = GetTestTeamStatusReporting(testTeamStatusReportingInputModel, loggedInContext, validationMessages);

                var htmlInput = GetD3SplitBarChartHtml(barChartRequiredData, loggedInContext);

                if (htmlInput != null)
                {
                    await _goalService.ConvertHtmlToImageAndPushMessageToWebHook(htmlInput, "Expected vs actual spent hours", "Expected vs actual spent hours", url , loggedInContext);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Post burndown", "Update goal service"));
            }
            catch(Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PushSplitBarToWebHook", "TestRunService ", ex.Message), ex);

            }
        }

        public string GetD3SplitBarChartHtml(List<TestTeamStatusReportingRetunrModel> testTeamStatusReportingRetunrModel, LoggedInContext loggedInContext)
        {
            var splitBarChartJson = new JavaScriptSerializer().Serialize(testTeamStatusReportingRetunrModel);

            var html = _goalRepository.GetHtmlTemplateByName("SplitBarChartTemplate", loggedInContext.CompanyGuid).Replace("##splitBarChartJson##", splitBarChartJson);

            return html;
        }

        public List<TestPlanApiReturnModel> SearchTestPlans(TestPlanSearchCriteriaInputModel testPlanSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Plans", "testPlanSearchCriteriaInputModel", testPlanSearchCriteriaInputModel, "TestRun Service"));

            CommonValidationHelper.CheckValidationForSearchCriteria(loggedInContext, testPlanSearchCriteriaInputModel, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.SearchTestPlansCommandId, testPlanSearchCriteriaInputModel, loggedInContext);

            var testPlans = _testRailPartialRepository.SearchTestPlans(testPlanSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return testPlans;

        }

        public List<TestRunAndPlansOverviewModel> GetTestRunsAndTestPlans(Guid projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Runs And Test Plans", "ProjectId", projectId, "TestRun Service"));

            _testSuiteValidationHelper.ProjectIdValidation(loggedInContext, validationMessages, projectId);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<TestRunAndPlansOverviewModel> testRunsAndPlans = _testRailPartialRepository.GetTestRunsAndTestPlans(projectId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            var report = new ReportModel();

            foreach (var record in testRunsAndPlans)
            {
                if (record.IsTestRun)
                {
                    report = _testRailPartialRepository.GetTestRunReport(record.Id, loggedInContext, validationMessages);

                    if (validationMessages.Count > 0)
                    {
                        return null;
                    }

                }
                else if (!record.IsTestRun)
                {
                    report = _testRailPartialRepository.GetTestPlanReport(record.Id, loggedInContext, validationMessages);

                    if (validationMessages.Count > 0)
                    {
                        return null;
                    }
                }

                if (report != null)
                {
                    record.PassedCount = report.PassedCount;
                    record.FailedCount = report.FailedCount;
                    record.UntestedCount = report.UntestedCount;
                    record.RetestCount = report.RetestCount;
                    record.BlockedCount = report.BlockedCount;
                    record.PassedPercent = report.PassedPercent;
                    record.UntestedPercent = report.UntestedPercent;
                    record.RetestPercent = report.RetestPercent;
                }
            }

            return testRunsAndPlans;

        }

        public ReportModel GetTestRunReport(Guid testRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Run Report", "TestRunId", testRunId, "TestRun Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetTestRunReportCommandId, testRunId, loggedInContext);

            ReportModel testRunReport = _testRailPartialRepository.GetTestRunReport(testRunId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testRunReport.TotalCount > 0)
            {
                testRunReport.PassedPercent = testRunReport.PassedCount / testRunReport.TotalCount * 100;
                testRunReport.FailedPercent = testRunReport.FailedCount / testRunReport.TotalCount * 100;
                testRunReport.UntestedPercent = testRunReport.UntestedCount / testRunReport.TotalCount * 100;
                testRunReport.BlockedPercent = testRunReport.BlockedCount / testRunReport.TotalCount * 100;
                testRunReport.RetestPercent = testRunReport.RetestCount / testRunReport.TotalCount * 100;
            }

            return testRunReport;

        }

        public ReportModel GetTestPlanReport(Guid testPlanId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Plan Report", "TestPlanId", testPlanId, "Test Run Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetTestPlanReportCommandId, testPlanId, loggedInContext);

            var testPlanReport = _testRailPartialRepository.GetTestPlanReport(testPlanId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return testPlanReport;

        }

        public int? GetOpenTestRunCount(Guid projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Open Test Run Count", "ProjectId", projectId, "TestRun Service"));

            _testSuiteValidationHelper.ProjectIdValidation(loggedInContext, validationMessages, projectId);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetOpenTestRunCountCommandId, projectId, loggedInContext);

            return GetTestRunCount(projectId, loggedInContext, false, validationMessages);

        }

        public int? GetCompletedTestRunCount(Guid projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Completed Test Run Count", "ProjectId", projectId, "TestRun Service"));

            _testSuiteValidationHelper.ProjectIdValidation(loggedInContext, validationMessages, projectId);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetCompletedTestRunCountCommandId, projectId, loggedInContext);

            return GetTestRunCount(projectId, loggedInContext, true, validationMessages);

        }

        private int? GetTestRunCount(Guid projectId, LoggedInContext loggedInContext, bool isCompleted, List<ValidationMessage> validationMessages)
        {
            var testRunSearchInputCriteriaModel = new TestRunSearchCriteriaInputModel
            {
                PageSize = 1,
                PageNumber = 1,
                IsCompleted = isCompleted,
                ProjectId = projectId
            };

            List<TestRunApiReturnModel> testRuns = _testRailPartialRepository.SearchTestRuns(testRunSearchInputCriteriaModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testRuns.Count > 0)
            {
                return testRuns[0].TotalCount;
            }

            return 0;
        }

        public Guid? UpdateTestCaseStatus(TestCaseStatusInputModel testCaseStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update Test Case Status", "testCaseStatusInputModel", testCaseStatusInputModel, "TestRun Service"));

            TestCaseApiReturnModel testCase = null;

            string stepStatusXml = null;

            _testRailValidationHelper.UpdateTestCaseStatusValidation(loggedInContext, validationMessages, testCaseStatusInputModel);

            if (testCaseStatusInputModel.TestCaseId != Guid.Empty)
            {
                testCase = _testSuiteService.GetTestCaseById(testCaseStatusInputModel.TestCaseId, loggedInContext, validationMessages, true);
            }

            if (validationMessages.Any())
            {
                return null;
            }

            if (testCaseStatusInputModel.StepStatus != null)
            {
                stepStatusXml = Utilities.GetXmlFromObject(testCaseStatusInputModel.StepStatus);
            }

            if (testCaseStatusInputModel.FilePath != null)
            {
                var testRailFileModel = new TestRailFileModel
                {
                    TestRailId = testCaseStatusInputModel.TestCaseId,
                    IsTestCaseStatus = true,
                    FilePathList = testCaseStatusInputModel.FilePath,
                    FilePathXml = Utilities.GetXmlFromObject(testCaseStatusInputModel.FilePath)
                };

                _testRailFileService.UpsertFile(testRailFileModel, loggedInContext, validationMessages);
            }

            var testCaseId = _testRailPartialRepository.UpdateTestCaseStatus(testCaseStatusInputModel, loggedInContext, stepStatusXml, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testCaseId != Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update TestCase Status audit saving", "Test Run Service"));

                var statusDetails = _testSuiteService.GetTestCaseStatusMasterDataById(testCaseStatusInputModel.StatusId, loggedInContext, validationMessages);

                var testRailAuditJsonModel = new TestRailAuditJsonModel
                {
                    Title = testCase?.Title,
                    TitleId = testCaseStatusInputModel.TestCaseId,
                    Status = statusDetails.Status,
                    Action = statusDetails.Status == "Passed" || statusDetails.Status == "Failed" ? "Tested" : "Marked",
                    TabName = "TestCase",
                    ColorCode = statusDetails.StatusHexValue
                };
                _overviewService.SaveTestRailAudit(testRailAuditJsonModel, loggedInContext, validationMessages);

                if (validationMessages.Count > 0)
                {
                    return null;
                }
            }
            return testCaseId;
        }

        public Guid? UpsertUserStoryScenario(TestCaseStatusInputModel testCaseStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert UserStory Scenario", "testCaseStatusInputModel", testCaseStatusInputModel, "TestRun Service"));

            string stepStatusXml = null;

            _testRailValidationHelper.UpsertUserStoryScenarioValidation(loggedInContext, validationMessages, testCaseStatusInputModel);

            if (validationMessages.Any())
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                testCaseStatusInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (testCaseStatusInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                testCaseStatusInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }


            if (testCaseStatusInputModel.StepStatus != null)
            {
                stepStatusXml = Utilities.GetXmlFromObject(testCaseStatusInputModel.StepStatus);
            }

            if (testCaseStatusInputModel.FilePath != null)
            {
                var testRailFileModel = new TestRailFileModel
                {
                    TestRailId = testCaseStatusInputModel.TestCaseId,
                    IsTestCaseStatus = true,
                    FilePathList = testCaseStatusInputModel.FilePath,
                    FilePathXml = Utilities.GetXmlFromObject(testCaseStatusInputModel.FilePath)
                };

                _testRailFileService.UpsertFile(testRailFileModel, loggedInContext, validationMessages);
            }

            var testCaseId = _testRailPartialRepository.UpsertUserStoryScenario(testCaseStatusInputModel, loggedInContext, stepStatusXml, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertUserStoryScenario, testCaseStatusInputModel, loggedInContext);

            return testCaseId;
        }

        public List<Guid> UpdateTestRunResultForMultipleTestCases(TestCaseAssignInputModel testCaseAssignInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update Assign For Multiple TestCases", "testCaseAssignInputModel", testCaseAssignInputModel, "TestRun Service"));

            string testCaseIdsXml = string.Empty;

            _testRailValidationHelper.UpdateAssignForMultipleTestCases(loggedInContext, validationMessages, testCaseAssignInputModel);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (testCaseAssignInputModel.TestCaseIds != null)
            {
                testCaseIdsXml = Utilities.GetXmlFromObject(testCaseAssignInputModel.TestCaseIds);
            }

            _auditService.SaveAudit(AppCommandConstants.UpdateAssignForMultipleTestCasesCommandId, testCaseAssignInputModel, loggedInContext);

            var testCaseIds = _testRailPartialRepository.UpdateTestRunResultForMultipleTestCases(testCaseIdsXml, testCaseAssignInputModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            //if (testCaseIds != null)
            //{
            //    //SendMail(loggedInContext, testCaseAssignInputModel);

            //    foreach (var testCaseId in testCaseIds)
            //    {
            //        var testCase = _testSuiteService.GetTestCaseById(testCaseId, loggedInContext, validationMessages);
            //        var testRailAuditJsonModel = new TestRailAuditJsonModel
            //        {
            //            Title = testCase?.Title,
            //            TitleId = testCaseId,
            //            AssignToId = testCaseAssignInputModel.AssignToId,
            //            Action = "Assigned To",
            //            TabName = "TestCase",
            //            ColorCode = "#6c99e6"
            //        };
            //        _overviewService.SaveTestRailAudit(testRailAuditJsonModel, loggedInContext, validationMessages);

            //        if (validationMessages.Count > 0)
            //        {
            //            return null;
            //        }
            //    }
            //    _auditService.SaveAudit(AppCommandConstants.UpdateAssignForMultipleTestCasesCommandId, testCaseAssignInputModel, loggedInContext);
            //    return testCaseIds;
            //}
           
            return testCaseIds;
        }



        private void SendMail(LoggedInContext loggedInContext, TestCaseAssignInputModel testCaseAssignInputModel)
        {
            try
            {
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                var fromUser = _userService.GetUserDetails(loggedInContext.LoggedInUserId, loggedInContext);
                var fromAddress = fromUser.UserName;
                if (testCaseAssignInputModel.AssignToId != null)
                {
                    var toUser = _userService.GetUserDetails((Guid)testCaseAssignInputModel.AssignToId, loggedInContext);
                    var toAddress = toUser.UserName;
                    var testsCount = testCaseAssignInputModel.TestCaseIds.Count;
                    TestCaseApiReturnModel testCase = _testSuiteService.GetTestCaseById(testCaseAssignInputModel.TestCaseIds[0], loggedInContext, validationMessages);
                    var testSuite = _testSuiteService.GetTestSuiteById(testCase.TestSuiteId, loggedInContext, validationMessages);
                    var project = _projectService.GetProjectById(testSuite.ProjectId, loggedInContext, validationMessages);
                    var testRun = GetTestRunById(testCaseAssignInputModel.TestRunId, loggedInContext, validationMessages);

                    string subject;
                    if (testsCount > 1)
                    {
                        subject = "[TestRail QA]" + testsCount + " tests were assigned to you";
                    }
                    else
                    {
                        subject = "[TestRail QA]" + testCase.Title + " was assigned to you";
                    }
                    string html = System.IO.File.ReadAllText("E:/SourceTree/BView New/sourcecode/BusinessView/Btrak.Services/TestRail/TestRailTemplate.html");

                    html = html.Replace("{QA}", toUser.FullName);
                    html = html.Replace("{No.of}", testsCount.ToString());
                    html = html.Replace("{Assigner}", fromUser.FullName);
                    html = html.Replace("{TestRunName}", testRun.TestRunName);
                    html = html.Replace("{ProjectName}", project.ProjectName);

                    if (testsCount > 1)
                    {
                        foreach (var testCaseId in testCaseAssignInputModel.TestCaseIds)
                        {
                            var testCaseData = _testSuiteService.GetTestCaseById(testCaseId, loggedInContext, validationMessages);
                            html = html + testCaseData.TestCaseIdentity + ":" + testCaseData.Title + "<br>";
                        }
                    }
                    else
                    {
                        html = html + testCase.TestCaseIdentity + ":" + testCase.Title + "<br>";
                    }
                    CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);
                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);
                    string[] emails = new[] { toAddress };
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = emails,
                        HtmlContent = html,
                        Subject = subject,
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                    //_communicationService.SendMail(fromAddress, toAddress, null, subject, html, null);
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendMail", "TestRunService ", exception.Message), exception);

                throw;
            }
        }


        public List<UploadTestRunsFromExcelModel> UploadTestRunsFromCsv(string projectName, string testRunName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upload TestRuns From Csv", "projectName", projectName, "Test Run Service"));

            var excelResult = new List<UploadTestRunsFromExcelModel>();

            var httpRequest = HttpContext.Current.Request;

            using (TextReader fileReader = new StreamReader(httpRequest.InputStream))
            {
                fileReader.ReadLine(); //to skip the first line

                var csvReader = new CsvReader(fileReader);

                csvReader.Configuration.MissingFieldFound = null;

                csvReader.Configuration.BadDataFound = null;

                csvReader.Configuration.HasHeaderRecord = false;

                List<UploadTestRunsFromExcelModel> testRunRecords = csvReader.GetRecords<UploadTestRunsFromExcelModel>().ToList();

                var skipCount = testRunRecords.FindIndex(x => x.ID.Contains("ID"));

                if (skipCount != -1)
                {
                    skipCount = skipCount + 1;
                }
                else
                {
                    throw new Exception("Invalid Csv file");
                }

                List<ValidationMessage> validations = new List<ValidationMessage>();
                //csvReader.Read();
                //csvReader.ReadHeader();
                //string[] headerRow = csvReader.Context.HeaderRecord;

                _testRailValidationHelper.UploadTestRunsCsvValidation(testRunRecords[skipCount - 1], loggedInContext, validationMessages);

                if (validationMessages.Count > 0)
                {
                    return null;
                }

                foreach (var row in testRunRecords.Skip(skipCount))
                {
                    if (string.IsNullOrEmpty(row.TestSuiteName) && string.IsNullOrEmpty(row.Title))
                    {
                        break;
                    }

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "testRunRecord", row));

                    if (row.Template == "Test Case (Steps)")
                    {
                        List<TestCaseStepMiniModel> testCaseStepMiniModels = SplitSteps(row.Steps, row.ActualResult, row.StepStatus, row);

                        if (testCaseStepMiniModels == null)
                        {
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "TestRun Record Insertion Failed", "testRunRecord", row, "Test Run Service"));
                            excelResult.Add(row);
                            continue;
                        }

                        row.TestCaseStepsXml = testCaseStepMiniModels != null ? testCaseStepMiniModels.Count > 0 ? Utilities.GetXmlFromObject(testCaseStepMiniModels) : null : null;

                        if (validationMessages.Count > 0)
                        {
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "TestCase Record Insertion Failed", "testRunRecord", row, "Test Run Service"));
                            validations.AddRange(validationMessages);
                            validationMessages.Clear();
                            excelResult.Add(row);
                            continue;
                        }
                    }
                    else
                    {
                        row.TestCaseStepsXml = null;
                    }

                    _testRailPartialRepository.UploadTestRunFromCsv(projectName, testRunName, row, loggedInContext, validationMessages);


                    if (validationMessages.Count > 0)
                    {
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "TestCase Record Insertion Failed", "testRunRecord", row, "Test Run Service"));
                        validations.AddRange(validationMessages);
                        validationMessages.Clear();
                        excelResult.Add(row);
                        continue;
                    }

                }

                if (validations.Count > 0)
                {
                    validationMessages.AddRange(validations);
                }

                fileReader.Close();

                return excelResult;
            }
        }

        public bool UploadTestRunFromXml(string projectName, string testSuiteName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upload TestRun From Csv", "projectName", projectName, "Test Run Service"));

                var file = HttpContext.Current.Request.Files[0];
                XmlDocument doc = new XmlDocument();
                doc.Load(XmlReader.Create(file.InputStream));

                Guid? projectId = Guid.Empty;
                Guid? testSuiteId = Guid.Empty;
                List<ValidationMessage> validations = new List<ValidationMessage>();
                var testCaseStatusMasterDataInput = new TestCaseStatusMasterDataModel()
                {
                    IsArchived = false
                };

                var testCaseStatuses = _testSuiteService.GetAllTestCaseStatuses(testCaseStatusMasterDataInput, loggedInContext, validationMessages);

                var projectSearchCriteriaInputModel = new ProjectSearchCriteriaInputModel()
                {
                    ProjectName = projectName.Trim(),
                    IsArchived = false
                };
                var projectSearchResults = _projectService.SearchProjects(projectSearchCriteriaInputModel, loggedInContext, validations);

                if (validations.Count > 0)
                {
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestRunXML", "TestRun", "Unable to search project with the name " + projectName));
                    validationMessages.AddRange(validations);
                    validations.Clear();
                    return false;
                }

                if (projectSearchResults.Count > 0)
                {
                    projectId = projectSearchResults.FirstOrDefault().ProjectId;
                }
                else
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestRunXML", "TestRun", "Didn't find any project with name " + projectName));
                    validationMessages.AddRange(validations);
                    validations.Clear();
                    return false;
                }

                var testSuiteSearchInputModel = new TestSuiteSearchCriteriaInputModel()
                {
                    TestSuiteName = testSuiteName.Trim(),
                    ProjectId = projectId
                };
                var TestSuites = _testSuiteService.SearchTestSuites(testSuiteSearchInputModel, loggedInContext, validations);

                if (validations.Count > 0)
                {
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestRunXML", "TestRun", "Unable to search testsuites with the name " + testSuiteName));
                    validationMessages.AddRange(validations);
                    validations.Clear();
                    return false;
                }

                if (TestSuites.Count > 0)
                {
                    testSuiteId = TestSuites.FirstOrDefault().TestSuiteId;
                }
                else
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestRunXML", "TestRun", "Didn't find any testsuite with name " + testSuiteName));
                    validationMessages.AddRange(validations);
                    validations.Clear();
                    return false;
                }

                var testRunName = string.IsNullOrEmpty((doc.SelectSingleNode("/run/name") as XmlElement)?.InnerText) ? (doc.SelectSingleNode("/run/name") as XmlElement)?.InnerText : (doc.SelectSingleNode("/run/name") as XmlElement)?.InnerText.Trim();
                var mileStoneName = doc.SelectSingleNode("/run/milestone") as XmlElement;
                var isCompleted = (doc.SelectSingleNode("/run/completed") as XmlElement)?.InnerText;

                var milestoneInputModel = new MilestoneInputModel()
                {
                    ProjectId = projectId,
                    MilestoneTitle = string.IsNullOrEmpty(mileStoneName?.InnerText) ? mileStoneName?.InnerText : mileStoneName.InnerText.Trim()
                };
                var milestoneId = _milestoneService.UpsertMilestone(milestoneInputModel, loggedInContext, validations);

                if (validations.Count > 0)
                {
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestRunXML", "TestRun", "Unable to search testsuites with the name " + testSuiteName));
                    validationMessages.AddRange(validations);
                    validations.Clear();
                }

                var testRunInputModel = new TestRunInputModel()
                {
                    ProjectId = projectId,
                    TestRunName = testRunName,
                    TestSuiteId = testSuiteId,
                    IsFromUpload = true,
                    IsCompleted = (string.IsNullOrEmpty(isCompleted) || isCompleted == "true") ? true : false,
                    MilestoneId = milestoneId,
                    Description = (doc.SelectSingleNode("/run/description") as XmlElement)?.InnerText,
                    IsArchived = false,
                    IsIncludeAllCases = false
                };
                var testRunId = UpsertTestRun(testRunInputModel, loggedInContext, validations);

                if (validations.Count > 0)
                {
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestRunXML", "TestRun", "Unable to search testsuites with the name " + testSuiteName));
                    validationMessages.AddRange(validations);
                    return false;
                }

                XmlNodeList sections = doc.SelectNodes("run/sections/section");

                foreach (XmlElement section in sections.Cast<XmlElement>().Where(x => x != null).ToList())
                {
                    var sectionName = string.IsNullOrEmpty((section.SelectSingleNode("name") as XmlElement).InnerText) ? (section.SelectSingleNode("name") as XmlElement).InnerText : (section.SelectSingleNode("name") as XmlElement).InnerText.Trim();

                    XmlNodeList subSections = section.SelectNodes("sections/section");
                    XmlNodeList testCases = section.SelectNodes("tests/test");

                    if (subSections.Count > 0 || testCases.Count > 0)
                    {
                        var testSuiteSectionSearchCriteriaInput = new TestSuiteSectionSearchCriteriaInputModel()
                        {
                            ParentSectionId = null,
                            SectionName = sectionName,
                            IsFromTestRunUplaods = true,
                            TestSuiteId = testSuiteId
                        };

                        Guid? sectionId = _testSuiteService.SearchTestSuiteSections(testSuiteSectionSearchCriteriaInput, loggedInContext, validations).FirstOrDefault()?.TestSuiteSectionId;
                        if (validations.Count > 0)
                        {
                            validationMessages.AddRange(validations);
                            validations.Clear();
                            continue;
                        }
                        if (sectionId == null)
                        {
                            var StaticValidation = new ValidationMessage
                            {
                                ValidationMessaage = string.Format(ValidationMessages.TestSuiteUploadParentSectionNotFound, sectionName),
                                ValidationMessageType = MessageTypeEnum.Error
                            };
                            validationMessages.Add(StaticValidation);
                            continue;
                        }


                        foreach (var subSection in subSections.OfType<XmlElement>().Where(x => x != null).ToList())
                        {
                            UpdateSection(subSection, (Guid)sectionId, (Guid)testRunId, loggedInContext, validationMessages, testCaseStatuses, sectionName, (Guid)testSuiteId);
                        }

                        foreach (var testCase in testCases.OfType<XmlElement>().Where(x => x != null).ToList())
                        {
                            UpdateCase(testCase, sectionId, (Guid)testRunId, loggedInContext, validationMessages, testCaseStatuses, sectionName);
                        }
                    }
                }
                return true;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestRunFromXml", "TestRunService ", exception.Message), exception);
                throw;
            }
        }

        private void UpdateCase(XmlElement testCase, Guid? sectionId, Guid testRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, List<DropdownModel> testCaseStatuses, string sectionName)
        {
            try
            {
                var validations = new List<ValidationMessage>();
                var testCaseTitle = string.IsNullOrEmpty((testCase.SelectSingleNode("title") as XmlElement)?.InnerText) ? (testCase.SelectSingleNode("title") as XmlElement)?.InnerText : (testCase.SelectSingleNode("title") as XmlElement)?.InnerText.Trim();
                if (testCaseTitle != null && testCaseTitle.Contains("![](index.php?/attachments/get/"))
                {
                    testCaseTitle = _testSuiteService.ReplaceImageUrls(testCaseTitle);
                }
                var statusType = testCase.SelectSingleNode("status") as XmlElement;
                var statusId = testCaseStatuses.FirstOrDefault(p => p.Value == statusType.InnerText.Trim()).Id;
                var recentChange = testCase.SelectNodes("changes/change").OfType<XmlElement>().Where(x => x != null).FirstOrDefault();
                TimeSpan elapsedTime = new TimeSpan();
                var searchTestCaseInputModel = new SearchTestCaseInputModel()
                {
                    Title = testCaseTitle,
                    SectionId = sectionId
                };
                var testCaseFound = _testSuiteService.SearchTestCases(searchTestCaseInputModel, loggedInContext, validations).FirstOrDefault();
                if (validations.Count > 0)
                {
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadingTestRunXML", "TestRun", "Unable to search testcase with the title " + testCaseTitle));
                    validationMessages.AddRange(validations);
                    validations.Clear();
                    return;
                }
                if (testCaseFound == null)
                {
                    var StaticValidation = new ValidationMessage
                    {
                        ValidationMessaage = string.Format(ValidationMessages.TestSuiteUploadTestCaseNotFound, testCaseTitle, sectionName),
                        ValidationMessageType = MessageTypeEnum.Error
                    };
                    validationMessages.Add(StaticValidation);
                    return;
                }
                SearchTestCaseDetailsInputModel searchTestCaseDetailsInputModel = new SearchTestCaseDetailsInputModel()
                {
                    TestCaseId = testCaseFound.TestCaseId,
                    SectionId = sectionId
                };
                var testCaseDetails = _testSuiteService.SearchTestCaseDetailsById(searchTestCaseDetailsInputModel, loggedInContext, validations);
                string statusComment = recentChange != null ? (recentChange.SelectSingleNode("comment") as XmlElement)?.InnerText : null;
                string statusCommentWithoutUrl = statusComment;
                if (statusComment != null && statusComment.Contains("![](index.php?/attachments/get/"))
                {
                    var fileUrls = _testSuiteService.GetImagePaths(statusComment);
                    TestRailFileModel testRailFileModel = new TestRailFileModel
                    {
                        TestRailId = testCaseDetails.TestCaseId,
                        TestRunId = testRunId,
                        IsTestRun = true,
                        IsTestCaseStatus = true,
                        FilePathList = fileUrls.Select(x => x.FilePath).ToList(),
                        FileName = fileUrls[0].FileName
                    };
                    _testRailFileService.UpsertFile(testRailFileModel, loggedInContext, validations);
                    statusComment = _testSuiteService.ReplaceImageUrls(statusComment);
                }
                var stepstoBeUpdated = new List<TestCaseStepMiniModel>();
                Guid? testCaseStatusId = Guid.Empty;
                if (recentChange != null)
                {
                    TimeSpan.TryParse((recentChange.SelectSingleNode("elapsed") as XmlElement)?.InnerText, out elapsedTime);
                    var stepResultsFromXml = recentChange.SelectNodes("custom/step_results/step");
                    if (testCaseDetails != null && testCaseDetails.TestCaseSteps != null)
                    {
                        foreach (var testCaseStep in testCaseDetails.TestCaseSteps)
                        {
                            var testCaseStepMiniModel = new TestCaseStepMiniModel()
                            {
                                StepId = testCaseStep.StepId,
                                StepOrder = testCaseStep.StepOrder,
                                StepText = testCaseStep.StepText,
                                StepExpectedResult = testCaseStep.StepExpectedResult,
                                StepStatusId = testCaseStatuses.FirstOrDefault(p => p.Value.ToLower() == "untested").Id
                            };
                            stepstoBeUpdated.Add(testCaseStepMiniModel);
                        }
                        foreach (var stepChange in stepResultsFromXml.OfType<XmlElement>().Where(x => x != null).ToList())
                        {
                            var internalstepStatusId = testCaseStatuses.FirstOrDefault(p => p.Value.ToLower() == "untested").Id;
                            var internalstepStatus = (stepChange.SelectSingleNode("status") as XmlElement)?.InnerText;
                            if (internalstepStatus != null)
                            {
                                internalstepStatusId = testCaseStatuses.FirstOrDefault(p => p.Value == internalstepStatus.Trim()).Id;
                            }
                            var step = (stepChange.SelectSingleNode("content") as XmlElement)?.InnerText;
                            if (step != null && step.Contains("![](index.php?/attachments/get/"))
                            {
                                step = _testSuiteService.ReplaceImageUrls(step);
                            }
                            var stepId = testCaseDetails.TestCaseSteps.FirstOrDefault(p => p.StepText.ToLower().Trim() == step.ToLower().Trim())?.StepId;
                            if (stepId == null || stepId == Guid.Empty)
                            {
                                continue;
                            }
                            var actualResult = (stepChange.SelectSingleNode("actual") as XmlElement)?.InnerText;
                            if (actualResult != null && actualResult.Contains("![](index.php?/attachments/get/"))
                            {
                                var fileUrls = _testSuiteService.GetImagePaths(actualResult);
                                TestRailFileModel testRailFileModel = new TestRailFileModel
                                {
                                    TestRailId = stepId,
                                    TestRunId = testRunId,
                                    IsTestCaseStep = true,
                                    FilePathList = fileUrls.Select(x => x.FilePath).ToList(),
                                    FileName = fileUrls[0].FileName
                                };
                                _testRailFileService.UpsertFile(testRailFileModel, loggedInContext, validations);
                                actualResult = _testSuiteService.ReplaceImageUrls(actualResult);
                            }
                            stepstoBeUpdated.Where(p => p.StepId == stepId).ToList().ForEach(t => { t.StepStatusId = internalstepStatusId; t.StepActualResult = actualResult; });
                        }
                    }
                    var testCaseStatusInputModel = new TestCaseStatusInputModel()
                    {
                        TestCaseId = testCaseDetails.TestCaseId,
                        TestRunId = testRunId,
                        StatusId = statusId,
                        StatusComment = statusCommentWithoutUrl,
                        Version = (recentChange.SelectSingleNode("version") as XmlElement)?.InnerText,
                        Elapsed = elapsedTime,
                        TimeStamp = testCaseDetails.TimeStamp,
                        StepStatus = stepstoBeUpdated
                    };
                    testCaseStatusId = UpdateTestCaseStatus(testCaseStatusInputModel, loggedInContext, validations);
                }
                else
                {
                    if (testCaseDetails.TestCaseSteps != null)
                    {
                        foreach (var testCaseStep in testCaseDetails.TestCaseSteps)
                        {
                            var internalstepStatusId = testCaseStatuses.FirstOrDefault(p => p.Value.ToLower() == "untested").Id;
                            var testCaseStepMiniModel = new TestCaseStepMiniModel()
                            {
                                StepId = testCaseStep.StepId,
                                StepOrder = testCaseStep.StepOrder,
                                StepText = testCaseStep.StepText,
                                StepExpectedResult = testCaseStep.StepExpectedResult,
                                StepStatusId = internalstepStatusId
                            };
                            stepstoBeUpdated.Add(testCaseStepMiniModel);
                        }
                    }
                    var testCaseStatusInputModel = new TestCaseStatusInputModel()
                    {
                        TestCaseId = testCaseDetails.TestCaseId,
                        TestRunId = testRunId,
                        StatusId = statusId,
                        TimeStamp = testCaseDetails.TimeStamp,
                        StepStatus = stepstoBeUpdated
                    };
                    testCaseStatusId = UpdateTestCaseStatus(testCaseStatusInputModel, loggedInContext, validations);
                }
                if (validations.Count > 0)
                {
                    validationMessages.AddRange(validations);
                    validations.Clear();
                    return;
                }
                var changes = testCase.SelectNodes("changes/change");
                foreach (var change in changes.OfType<XmlElement>().Where(x => x != null).ToList())
                {
                    var caseStatusType = (change.SelectSingleNode("status") as XmlElement)?.InnerText;
                    var createdDate = (change.SelectSingleNode("createdon") as XmlElement)?.InnerText;
                    var createdDateTime = DateTime.Now;
                    DateTime.TryParse(createdDate, out createdDateTime);
                    if (!string.IsNullOrEmpty(caseStatusType))
                    {
                        var testRailHistoryModel = new TestRailHistoryModel()
                        {
                            TestCaseId = testCaseDetails.TestCaseId,
                            TestRunId = testRunId,
                            NewValue = caseStatusType,
                            FieldName = "CaseStatus",
                            CreatedDateTime = createdDateTime,
                            IsFromUpload = true
                        };
                        _testRailPartialRepository.InsertTestRailHistory(testRailHistoryModel, loggedInContext, validations);
                    }
                    var assignedTo = (change.SelectSingleNode("assignedto") as XmlElement)?.InnerText;
                    if (!string.IsNullOrEmpty(assignedTo))
                    {
                        var testRailHistoryModel = new TestRailHistoryModel()
                        {
                            TestCaseId = testCaseDetails.TestCaseId,
                            TestRunId = testRunId,
                            NewValue = assignedTo,
                            FieldName = "Assignee",
                            CreatedDateTime = createdDateTime,
                            IsFromUpload = true
                        };
                        _testRailPartialRepository.InsertTestRailHistory(testRailHistoryModel, loggedInContext, validations);
                    }
                    var comment = (change.SelectSingleNode("comment") as XmlElement)?.InnerText;
                    var commentFileUrls = "";
                    if (comment != null && comment.Contains("![](index.php?/attachments/get/"))
                    {
                        var fileUrls = _testSuiteService.GetImagePaths(comment);
                        comment = _testSuiteService.ReplaceImageUrls(comment);
                        foreach (var fileUrl in fileUrls)
                        {
                            commentFileUrls = string.IsNullOrEmpty(commentFileUrls) ? fileUrl.FilePath : commentFileUrls + ", " + fileUrl.FilePath;
                        }
                    }
                    if (!string.IsNullOrEmpty(comment) || !string.IsNullOrEmpty(commentFileUrls))
                    {
                        var testRailHistoryModel = new TestRailHistoryModel()
                        {
                            TestCaseId = testCaseDetails.TestCaseId,
                            TestRunId = testRunId,
                            NewValue = comment,
                            FilePath = commentFileUrls,
                            FieldName = !string.IsNullOrEmpty(assignedTo) ? "AssignToComment" : "StatusComment",
                            CreatedDateTime = createdDateTime,
                            IsFromUpload = true
                        };
                        _testRailPartialRepository.InsertTestRailHistory(testRailHistoryModel, loggedInContext, validations);
                    }
                    var stepResults = change.SelectNodes("custom/step_results/step");
                    var i = 0;
                    foreach (var stepResult in stepResults.OfType<XmlElement>().Where(x => x != null).ToList())
                    {
                        stepstoBeUpdated = stepstoBeUpdated.OrderBy(p => p.StepOrder).ToList();
                        var stepStatus = (stepResult.SelectSingleNode("status") as XmlElement)?.InnerText;
                        var actualResult = (stepResult.SelectSingleNode("actual") as XmlElement)?.InnerText;
                        var actualResultFileUrls = "";
                        if (actualResult != null && actualResult.Contains("![](index.php?/attachments/get/"))
                        {
                            var fileUrls = _testSuiteService.GetImagePaths(actualResult);
                            actualResult = _testSuiteService.ReplaceImageUrls(actualResult);
                            foreach (var fileUrl in fileUrls)
                            {

                                actualResultFileUrls = string.IsNullOrEmpty(actualResultFileUrls) ? fileUrl.FilePath : actualResultFileUrls + ", " + fileUrl.FilePath;
                            }
                        }
                        if (!string.IsNullOrEmpty(stepStatus))
                        {
                            var stepHistoryModel = new TestRailHistoryModel()
                            {
                                StepId = stepstoBeUpdated[i].StepId,
                                TestRunId = testRunId,
                                TestCaseId = testCaseDetails.TestCaseId,
                                NewValue = stepStatus,
                                FieldName = "StepStatus",
                                CreatedDateTime = createdDateTime,
                                IsFromUpload = true
                            };
                            _testRailPartialRepository.InsertTestRailHistory(stepHistoryModel, loggedInContext, validations);
                        }
                        if (!string.IsNullOrEmpty(actualResult) || !string.IsNullOrEmpty(actualResultFileUrls))
                        {
                            var stepHistoryModel = new TestRailHistoryModel()
                            {
                                StepId = stepstoBeUpdated[i].StepId,
                                TestRunId = testRunId,
                                TestCaseId = testCaseDetails.TestCaseId,
                                NewValue = actualResult,
                                FilePath = actualResultFileUrls,
                                FieldName = "ActualResult",
                                CreatedDateTime = createdDateTime,
                                IsFromUpload = true
                            };
                            _testRailPartialRepository.InsertTestRailHistory(stepHistoryModel, loggedInContext, validations);
                        }
                        i++;
                    }
                };
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateCase", "TestRunService ", exception.Message), exception);

            }
        }

        private void UpdateSection(XmlElement section, Guid parentSectionId, Guid testRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, List<DropdownModel> testCaseStatuses, string parentSectionName, Guid testSuiteId)
        {
            var sectionName = string.IsNullOrEmpty((section.SelectSingleNode("name") as XmlElement).InnerText) ? (section.SelectSingleNode("name") as XmlElement).InnerText : (section.SelectSingleNode("name") as XmlElement).InnerText.Trim();
            var validations = new List<ValidationMessage>();

            XmlNodeList subSections = section.SelectNodes("sections/section");
            XmlNodeList testCases = section.SelectNodes("tests/test");

            if (subSections.Count > 0 || testCases.Count > 0)
            {
                var testSuiteSectionSearchCriteriaInput = new TestSuiteSectionSearchCriteriaInputModel()
                {
                    ParentSectionId = parentSectionId,
                    SectionName = sectionName,
                    IsFromTestRunUplaods = true,
                    TestSuiteId = testSuiteId
                };
                var sectionId = _testSuiteService.SearchTestSuiteSections(testSuiteSectionSearchCriteriaInput, loggedInContext, validations).FirstOrDefault()?.TestSuiteSectionId;

                if (validations.Count > 0)
                {
                    validationMessages.AddRange(validations);
                    validations.Clear();
                    return;
                }
                if (sectionId == null)
                {
                    var StaticValidation = new ValidationMessage
                    {
                        ValidationMessaage = string.Format(ValidationMessages.TestSuiteUploadSectionNotFound, sectionName, parentSectionName),
                        ValidationMessageType = MessageTypeEnum.Error
                    };
                    validationMessages.Add(StaticValidation);
                    return;
                }

                foreach (var subSection in subSections.OfType<XmlElement>().Where(x => x != null).ToList())
                {
                    if (subSection.SelectNodes("tests/test").Count > 0 || subSection.SelectNodes("sections/section").Count > 0)
                    {
                        UpdateSection(subSection, (Guid)sectionId, testRunId, loggedInContext, validationMessages, testCaseStatuses, sectionName, testSuiteId);
                    }
                };

                foreach (var testCase in testCases.OfType<XmlElement>().Where(x => x != null).ToList())
                {
                    UpdateCase(testCase, sectionId, testRunId, loggedInContext, validationMessages, testCaseStatuses, sectionName);
                }
            }
        }

        private List<TestCaseStepMiniModel> SplitSteps(string step, string actualResult, string stepStatus, UploadTestRunsFromExcelModel row)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SplitSteps", "step", step, "Test Run Service"));

            List<string> stepsResult = new List<string>();

            List<string> expectedResults = new List<string>();

            const string searchText = "\r\nExpected Result:\r\n";

            var steplength = step.Length;
            int number = 1;

            List<TestCaseStepMiniModel> testCaseStepMiniModels = new List<TestCaseStepMiniModel>();

            for (int i = 0; i < steplength; i++)
            {
                int stepStartIndex = step.IndexOf(number + ". ", StringComparison.Ordinal);

                int stepEndIndex = step.IndexOf(searchText, StringComparison.Ordinal);

                var nextStepIndex = step.IndexOf(number + 1 + ". ", StringComparison.Ordinal);

                if (nextStepIndex != -1 && nextStepIndex < stepEndIndex)
                {
                    stepEndIndex = -1;
                }

                if (stepEndIndex < 0)
                {
                    stepEndIndex = step.IndexOf(number + 1 + ". ", StringComparison.Ordinal);

                    if (stepEndIndex > 0)
                    {
                        stepsResult.Add(step.Substring(stepStartIndex + 3, stepEndIndex - (stepStartIndex + 3)));

                        step = step.Substring(stepEndIndex);
                        i = i + stepEndIndex;
                        number++;
                        expectedResults.Add(string.Empty);
                        continue;
                    }

                    stepsResult.Add(step.Substring(stepStartIndex));
                    expectedResults.Add(string.Empty);
                    break;
                }

                stepsResult.Add(step.Substring(stepStartIndex + 3, stepEndIndex - (stepStartIndex + 3)));

                int resultStartIndex = stepEndIndex + searchText.Length;

                int resultEndIndex = step.IndexOf(number + 1 + ". ", StringComparison.Ordinal);

                if (resultEndIndex > 0)
                {
                    expectedResults.Add(step.Substring(resultStartIndex, resultEndIndex - resultStartIndex));
                    step = step.Substring(resultEndIndex);
                }
                else
                {
                    expectedResults.Add(step.Substring(resultStartIndex));
                    break;
                }

                i = i + resultEndIndex;

                number++;
            }

            number = 1;

            var actualResults = new List<string>();
            var stepsStatus = new List<string>();

            var actualResultLength = actualResult.Length;

            for (int i = 0; i < actualResultLength; i++)
            {
                int stepStartIndex = actualResult.IndexOf(number + ".", StringComparison.Ordinal);
                var stepEndIndex = actualResult.IndexOf(number + 1 + ".", StringComparison.Ordinal);

                int statusStartIndex = stepStatus.IndexOf(number + ".", StringComparison.Ordinal);
                var statusEndIndex = stepStatus.IndexOf(number + 1 + ".", StringComparison.Ordinal);

                if (stepEndIndex < 0)
                {
                    actualResults.Add(stepStartIndex > 0 ? actualResult.Substring(stepStartIndex) : null);
                    stepsStatus.Add(stepStatus.Substring(statusStartIndex));
                    break;
                }
                else
                {
                    actualResults.Add(actualResult.Substring(stepStartIndex, stepEndIndex - stepStartIndex));
                    stepsStatus.Add(stepStatus.Substring(statusStartIndex, statusEndIndex - statusStartIndex));
                }

                number++;
            }

            if (stepsResult.Count != expectedResults.Count)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SplitSteps Steps and expected results count mismatched", "Test Run Service"));
                return null;
            }

            for (int j = 0; j < stepsResult.Count; j++)
            {
                TestCaseStepMiniModel testCaseStepMiniModel = new TestCaseStepMiniModel
                {
                    StepOrder = j + 1,
                    StepText = stepsResult[j],
                    StepExpectedResult = expectedResults[j],
                    StepActualResult = string.IsNullOrEmpty(actualResult) ? null : actualResults[j],
                    StepStatusName = string.IsNullOrEmpty(stepStatus) ? null : stepsStatus[j]
                };

                testCaseStepMiniModels.Add(testCaseStepMiniModel);
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SplitSteps", "Test Run Service"));

            return testCaseStepMiniModels;
        }

        private string GetPropValue(string propName)
        {
            object src = new LangText();
            return src.GetType().GetProperty(propName)?.GetValue(src, null).ToString();
        }

        public void UpdateFolderAndStoreSizeByFolderId(Guid? folderId, LoggedInContext loggedInContext)
        {
            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            _fileRepository.UpdateFolderAndStoreSizeByFolderId(folderId, loggedInContext, validationMessages);
        }

        public List<TestTeamStatusReportingRetunrModel> GetTestTeamStatusReportingProjectWise(TestTeamStatusReportingInputModel testTeamStatusReportingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTestTeamStatusReportingProjectWise", "GetUserStoryScenarioHistoryProjectWise", "TestRun Service"));

            List<TestTeamStatusReportingRetunrModel> testTeamStatusReporing = _testRailPartialRepository.GetTestTeamStatusReportingProjectWise(testTeamStatusReportingInputModel, loggedInContext, validationMessages);

            return testTeamStatusReporing;
        }

    }
}
