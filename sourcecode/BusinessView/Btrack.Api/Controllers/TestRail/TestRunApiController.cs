using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.TestRail;
using Btrak.Services.TestRail;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.TestRail
{
    public class TestRunApiController : AuthTokenApiController
    {
        private readonly ITestRunService _testRunService;
        private BtrakJsonResult _btrakJsonResult;

        public TestRunApiController(ITestRunService testRunService)
        {
            _testRunService = testRunService;
            _btrakJsonResult = new BtrakJsonResult
            {
                Success = false
            };
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTestRun)]
        public JsonResult<BtrakJsonResult> UpsertTestRun(TestRunInputModel testRunInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Run Started", "testRunInputModel", testRunInputModel, "TestRun Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Run", "testRunInputModel", testRunInputModel, "TestRun Api"));

                    var validationMessages = new List<ValidationMessage>();
                    var data = _testRunService.UpsertTestRun(testRunInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Run", "TestRun Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Run", "TestRun Api"));
                    return Json(new BtrakJsonResult { Data = data, Success =  true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Run", "TestRun Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestRun", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestRunById)]
        public JsonResult<BtrakJsonResult> GetTestRunById(Guid testRunId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestRun By Id Started", "testRunId", testRunId, "TestRun Api"));

                var validationMessages = new List<ValidationMessage>();

                var testRun = _testRunService.GetTestRunById(testRunId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestRun By Id", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestRun By Id", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testRun, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRunById", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetProjectMemberDropdown)]
        public JsonResult<BtrakJsonResult> GetProjectMemberDropdown(Guid projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Project Member Dropdown", "ProjectId", projectId, "TestRun Api"));

                var validationMessages = new List<ValidationMessage>();

                var projectMemberList = _testRunService.GetProjectMemberDropdown(projectId, LoggedInContext,validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Project Member Dropdowns", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Project Member Dropdown", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = projectMemberList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjectMemberDropdown", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchTestRuns)]
        public JsonResult<BtrakJsonResult> SearchTestRuns(TestRunSearchCriteriaInputModel testRunSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Runs", "testRunSearchCriteriaInputModel", testRunSearchCriteriaInputModel, "TestRun Api"));

                var validationMessages = new List<ValidationMessage>();

                var testRuns = _testRunService.SearchTestRuns(testRunSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Test Runs", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Test Runs", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testRuns, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestRuns", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserStoryScenarioHistory)]
        public JsonResult<BtrakJsonResult> GetUserStoryScenarioHistory(TestCaseHistoryInputModel testCaseHistoryInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get UserStory Scenario History", "guid", testCaseHistoryInputModel, "TestRun Api"));

                var validationMessages = new List<ValidationMessage>();


                var testRuns = _testRunService.GetUserStoryScenarioHistory(testCaseHistoryInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get UserStory Scenario History", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get UserStory Scenario History", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testRuns, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryScenarioHistory", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertTestCaseHistory)]
        public JsonResult<BtrakJsonResult> InsertTestCaseHistory(TestCaseHistoryMiniModel testCaseHistoryMiniModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "InsertTestCaseHistory", "testCaseHistoryMiniModel", testCaseHistoryMiniModel, "TestRun Api"));

                var validationMessages = new List<ValidationMessage>();

                var testRuns = _testRunService.InsertTestCaseHistory(testCaseHistoryMiniModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertTestCaseHistory", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertTestCaseHistory", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testRuns, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertTestCaseHistory", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteTestRun)]
        public JsonResult<BtrakJsonResult> DeleteTestRun(TestRunInputModel testRunInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Test Runs", "TestRunInputModel", testRunInputModel, "TestRun Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? testRunId = _testRunService.DeleteTestRun(testRunInputModel.TestRunId, testRunInputModel.TimeStamp, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Test Runs", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Test Runs", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testRunId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteTestRun", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTestPlan)]
        public JsonResult<BtrakJsonResult> UpsertTestPlan(TestPlanInputModel testPlanInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Plan Started", "testPlanInputModel", testPlanInputModel, "TestRun Api"));
                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Plan Started", "testPlanInputModel", testPlanInputModel, "TestRun Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var data =  _testRunService.UpsertTestPlan(testPlanInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out  _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Plan", "TestRun Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Plan", "TestRun Api"));
                    return Json(new BtrakJsonResult { Data = data, Success =  true}, UiHelper.JsonSerializerNullValueIncludeSettings);

                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Plan", "TestRun Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestPlan", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestPlanById)]
        public JsonResult<BtrakJsonResult> GetTestPlanById(Guid testPlanId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestPlan By Id Started", "testPlanId", testPlanId, "TestRun Api"));

                var validationMessages = new List<ValidationMessage>();

                var testPlan = _testRunService.GetTestPlanById(testPlanId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestPlan By Id", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestPlan By Id", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testPlan, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestPlanById", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchTestPlans)]
        public JsonResult<BtrakJsonResult> SearchTestPlans(TestPlanSearchCriteriaInputModel testPlanSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Plans", "testPlanSearchCriteriaInputModel", testPlanSearchCriteriaInputModel, "TestRun Api"));

                var validationMessages = new List<ValidationMessage>();

                var testPlans = _testRunService.SearchTestPlans(testPlanSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Test Plans", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Test Plans", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testPlans, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestPlans", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestRunsAndTestPlans)]
        public JsonResult<BtrakJsonResult> GetTestRunsAndTestPlans(Guid projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Runs And Test Plans", "ProjectId", projectId, "Test Run Api"));

                var validationMessages = new List<ValidationMessage>();

                var testRunsAndTestPlans =  _testRunService.GetTestRunsAndTestPlans(projectId,LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Runs And Test Plans", "Test Run Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Runs And Test Plans", "Test Run Api"));
                return Json(new BtrakJsonResult { Data = testRunsAndTestPlans, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRunsAndTestPlans", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestRunReport)]
        public JsonResult<BtrakJsonResult> GetTestRunReport(Guid testRunId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Run Report", "testRunId", testRunId, "Test Run Api"));

                var validationMessages = new List<ValidationMessage>();

                var testRunReport = _testRunService.GetTestRunReport(testRunId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Run Report", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Run Report", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testRunReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRunReport", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestPlanReport)]
        public JsonResult<BtrakJsonResult> GetTestPlanReport(Guid testPlanId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Plan Report", "testPlanId", testPlanId, "Test Run Api"));

                var validationMessages = new List<ValidationMessage>();

                var testRunReport = _testRunService.GetTestPlanReport(testPlanId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Plan Report", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Plan Report", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testRunReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestPlanReport", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetOpenTestRunCount)]
        public JsonResult<BtrakJsonResult> GetOpenTestRunCount(Guid projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Open Test Run Count started","ProjectId", projectId, "Test Run Api"));

                var validationMessages = new List<ValidationMessage>();

                var openTestRunCount = _testRunService.GetOpenTestRunCount(projectId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Open Test Run Count", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Open Test Run Count", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = openTestRunCount, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetOpenTestRunCount", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCompletedTestRunCount)]
        public JsonResult<BtrakJsonResult> GetCompletedTestRunCount(Guid projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Completed Test Run Count started", "ProjectId", projectId, "Test Run Api"));

                var validationMessages = new List<ValidationMessage>();

                var completedTestRunCount = _testRunService.GetCompletedTestRunCount(projectId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Completed Test Run Count", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Completed Test Run Count", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = completedTestRunCount, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompletedTestRunCount", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateTestCaseStatus)]
        public JsonResult<BtrakJsonResult> UpdateTestCaseStatus(TestCaseStatusInputModel testCaseStatusModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update Test Case Status Started", "testCaseStatusModel", testCaseStatusModel, "TestRun Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCaseIds = _testRunService.UpdateTestCaseStatus(testCaseStatusModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Test Case Status", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Test Case Status", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testCaseIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateTestCaseStatus", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertUserStoryScenario)]
        public JsonResult<BtrakJsonResult> UpsertUserStoryScenario(TestCaseStatusInputModel testCaseStatusModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert UserStory Scenario", "testCaseStatusModel", testCaseStatusModel, "TestRun Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCaseId = _testRunService.UpsertUserStoryScenario(testCaseStatusModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert UserStory Scenario", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert UserStory Scenario", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testCaseId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryScenario", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateTestRunResultForMultipleTestCases)]
        public JsonResult<BtrakJsonResult> UpdateTestRunResultForMultipleTestCases(TestCaseAssignInputModel testCaseAssignInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update Multiple TestCase Assign", "testCaseAssignInputModel", testCaseAssignInputModel, "TestRun Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCaseIds = _testRunService.UpdateTestRunResultForMultipleTestCases(testCaseAssignInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Multiple TestCase Assign", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Multiple TestCase Assign", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testCaseIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateTestRunResultForMultipleTestCases", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTestTeamStatusReporting)]
        public JsonResult<BtrakJsonResult> GetTestTeamStatusReporting(TestTeamStatusReportingInputModel testTeamStatusReportingInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTestTeamStatusReporing", "testTeamStatusReportingInputModel", testTeamStatusReportingInputModel, "TestRun Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCaseIds = _testRunService.GetTestTeamStatusReporting(testTeamStatusReportingInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTestTeamStatusReporing", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTestTeamStatusReporing", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testCaseIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestTeamStatusReporting", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UploadTestRunsFromCsv)]
        public JsonResult<BtrakJsonResult> UploadTestRunsFromCsv(string projectName,string testRunName)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadTestRunsFromCsv", "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCase = _testRunService.UploadTestRunsFromCsv(projectName, testRunName, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadTestRunsFromCsv", "TestSuite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadTestRunsFromCsv", "TestSuite Api"));
                return Json(new BtrakJsonResult { Data = testCase, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestRunsFromCsv", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UploadTestRunsFromXml)]
        public JsonResult<BtrakJsonResult> UploadTestRunsFromXml(string projectName, string testSuiteName)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadTestRunsFromXml", "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var isUploadedSuccessfully = _testRunService.UploadTestRunFromXml(projectName, testSuiteName, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadTestRunsFromXml", "TestSuite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadTestRunsFromXml", "TestSuite Api"));
                return Json(new BtrakJsonResult { Data = isUploadedSuccessfully, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestRunsFromXml", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTestTeamStatusReportingProjectWise)]
        public JsonResult<BtrakJsonResult> GetTestTeamStatusReportingProjectWise(TestTeamStatusReportingInputModel testTeamStatusReportingInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTestTeamStatusReportingProjectWise", "testTeamStatusReportingInputModel", testTeamStatusReportingInputModel, "TestRun Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCaseIds = _testRunService.GetTestTeamStatusReportingProjectWise(testTeamStatusReportingInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTestTeamStatusReportingProjectWise", "TestRun Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTestTeamStatusReportingProjectWise", "TestRun Api"));
                return Json(new BtrakJsonResult { Data = testCaseIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestTeamStatusReportingProjectWise", "TestRunApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
