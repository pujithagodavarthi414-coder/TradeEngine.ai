using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.SpModels;
using Btrak.Models;
using Btrak.Models.TestRail;
using BTrak.Common;

namespace Btrak.Services.TestRail
{
    public interface ITestRunService
    {
        Guid? UpsertTestRun(TestRunInputModel testRunInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteTestRun(Guid? testRunId, byte[] timeStamp, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TestRunApiReturnModel GetTestRunById(Guid? testRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTestPlan(TestPlanInputModel testPlanInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TestPlanApiReturnModel GetTestPlanById(Guid testPlanId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DropdownModel> GetProjectMemberDropdown(Guid projectId, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<TestRunApiReturnModel> SearchTestRuns(TestRunSearchCriteriaInputModel testRunSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestPlanApiReturnModel> SearchTestPlans(TestPlanSearchCriteriaInputModel testPlanSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestRunAndPlansOverviewModel> GetTestRunsAndTestPlans(Guid projectId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int? GetOpenTestRunCount(Guid projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int? GetCompletedTestRunCount(Guid projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestRailHistoryModel> GetUserStoryScenarioHistory(TestCaseHistoryInputModel testCaseHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? InsertTestCaseHistory(TestCaseHistoryMiniModel testCaseHistoryMiniModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ReportModel GetTestRunReport(Guid testRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ReportModel GetTestPlanReport(Guid testPlanId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateTestCaseStatus(TestCaseStatusInputModel testCaseStatusInputModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        Guid? UpsertUserStoryScenario(TestCaseStatusInputModel testCaseStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid> UpdateTestRunResultForMultipleTestCases(TestCaseAssignInputModel testCaseAssignInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestTeamStatusReportingRetunrModel> GetTestTeamStatusReporting(TestTeamStatusReportingInputModel testTeamStatusReportingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task PushSplitBar(string webhookUrl, LoggedInContext loggedInContext);
        Task PushSplitBarToWebHook(string url, LoggedInContext loggedInContext);
        string GetD3SplitBarChartHtml(List<TestTeamStatusReportingRetunrModel> testTeamStatusReportingRetunrModel, LoggedInContext loggedInContext);
        List<UploadTestRunsFromExcelModel> UploadTestRunsFromCsv(string projectName, string testRunName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool UploadTestRunFromXml(string projectName, string testSuiteName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TestTeamStatusReportingRetunrModel> GetTestTeamStatusReportingProjectWise(TestTeamStatusReportingInputModel testTeamStatusReportingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
