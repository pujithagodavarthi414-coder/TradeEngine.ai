using Btrak.Models;
using Btrak.Models.Projects;
using Btrak.Models.TestRail;
using Btrak.Services.TestRail;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.TestRail
{
    public class TestSuiteApiController : AuthTokenApiController
    {
        private readonly ITestSuiteService _testSuiteService;
        private BtrakJsonResult _btrakJsonResult;

        public TestSuiteApiController(ITestSuiteService testSuiteService)
        {
            _testSuiteService = testSuiteService;
            _btrakJsonResult = new BtrakJsonResult
            {
                Success = false
            };
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetProjects)]
        public JsonResult<BtrakJsonResult> GetProjects(ProjectSearchCriteriaInputModel searchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Projects", "TestSuite Api"));

                var validationMessages = new List<ValidationMessage>();

                var projectList = _testSuiteService.GetProjectList(searchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Projects", "Test Suite Api"));

                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Projects", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = projectList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProjects", " TestSuiteApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTestSuite)]
        public JsonResult<BtrakJsonResult> UpsertTestSuite(TestSuiteInputModel testSuiteInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Suite", "testSuiteInputModel", testSuiteInputModel, "Test Suite Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Suite", "testSuiteInputModel", testSuiteInputModel, "Test Suite Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var testSuiteIdentifier = _testSuiteService.UpsertTestSuite(testSuiteInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Suite", "Test Suite Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info("TestSuite Upsert is completed. Return Guid is : " + testSuiteIdentifier + "Source command is " + testSuiteInputModel);

                    return Json(new BtrakJsonResult { Data = testSuiteIdentifier, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Suite", "Test Suite Api"));

                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestSuite", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateTestSuiteProject)]
        public JsonResult<BtrakJsonResult> UpdateTestSuiteProject(TestSuiteInputModel testSuiteInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update Test Suite Project", "testSuiteInputModel", testSuiteInputModel, "Test Suite Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update Test Suite Project", "testSuiteInputModel", testSuiteInputModel, "Test Suite Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var testSuiteIdentifier = _testSuiteService.UpdateTestSuiteProject(testSuiteInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Suite", "Test Suite Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info("TestSuite Upsert is completed. Return Guid is : " + testSuiteIdentifier + "Source command is " + testSuiteInputModel);

                    return Json(new BtrakJsonResult { Data = testSuiteIdentifier, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Suite", "Test Suite Api"));

                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestSuite", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteTestSuite)]
        public JsonResult<BtrakJsonResult> DeleteTestSuite(TestSuiteInputModel testSuiteInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Test Suite", "testSuiteId", testSuiteInputModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var deletedSuiteId = _testSuiteService.DeleteTestSuite(testSuiteInputModel.TestSuiteId, testSuiteInputModel.TimeStamp, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Test Suite", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Test Suite", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = deletedSuiteId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteTestSuite", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteTestCase)]
        public JsonResult<BtrakJsonResult> DeleteTestCase(TestCaseInputModel testCaseInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Test Case", "testCaseInputModel", testCaseInputModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var archivedTestCaseId = _testSuiteService.DeleteTestCase(testCaseInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Test Case", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Test Case", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = archivedTestCaseId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteTestCase", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchTestSuites)]
        public JsonResult<BtrakJsonResult> SearchTestSuites(TestSuiteSearchCriteriaInputModel testSuiteSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search TestSuites", "testSuiteSearchCriteriaInputModel", testSuiteSearchCriteriaInputModel, "Test Suite Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search TestSuites", "testSuiteSearchCriteriaInputModel", testSuiteSearchCriteriaInputModel, "Test Suite Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var testSuites = _testSuiteService.SearchTestSuites(testSuiteSearchCriteriaInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Test Suites", "Test Suite Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search TestSuites", "Test Suite Api"));

                    return Json(new BtrakJsonResult { Success = true, Data = testSuites }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search TestSuites", "Test Suite Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestSuites", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCopyOrMoveCases)]
        public JsonResult<BtrakJsonResult> UpsertCopyOrMoveCases(CopyOrMoveTestCasesApiInputModel copyOrMoveTestCasesApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCopyOrMoveCases", "testSuiteSearchCriteriaInputModel", copyOrMoveTestCasesApiInputModel, "Test Suite Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCopyOrMoveCases", "testSuiteSearchCriteriaInputModel", copyOrMoveTestCasesApiInputModel, "Test Suite Api"));

                    var validationMessages = new List<ValidationMessage>();

                    Guid? testCaseId = _testSuiteService.UpsertCopyOrMoveCases(copyOrMoveTestCasesApiInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCopyOrMoveCases", "Test Suite Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCopyOrMoveCases", "Test Suite Api"));

                    return Json(new BtrakJsonResult { Success = true, Data = testCaseId }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCopyOrMoveCases", "Test Suite Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCopyOrMoveCases", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestSuiteById)]
        public JsonResult<BtrakJsonResult> GetTestSuiteById(Guid suiteId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get TestSuite By Id Started", "TestSuite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testSuite = _testSuiteService.GetTestSuiteById(suiteId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestSuite By Id", "Test Suite Api"));

                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestSuite By Id", "Test Suite Api"));

                return Json(new BtrakJsonResult { Data = testSuite, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestSuiteById", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTestSuiteSection)]
        public JsonResult<BtrakJsonResult> UpsertTestSuiteSection(TestSuiteSectionInputModel testSuiteSectionInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Suite Section Started", "testSuiteSectionInputModel", testSuiteSectionInputModel, "TestSuite Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Suite Section Started", "testSuiteSectionInputModel", testSuiteSectionInputModel, "TestSuite Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var testSuiteSectionIdentifier = _testSuiteService.UpsertTestSuiteSection(testSuiteSectionInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Suite Section", "TestSuite Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Suite Section", "TestSuite Api"));
                    return Json(new BtrakJsonResult { Data = testSuiteSectionIdentifier, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Suite Section", "TestSuite Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestSuiteSection", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteTestSuiteSection)]
        public JsonResult<BtrakJsonResult> DeleteTestSuiteSection(TestSuiteSectionInputModel testSuiteSectionInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Test Suite Section", "testSuiteSectionInputModel", testSuiteSectionInputModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var archivedSectionId = _testSuiteService.DeleteTestSuiteSection(testSuiteSectionInputModel.TestSuiteSectionId, testSuiteSectionInputModel.TimeStamp, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Test Suite Section", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Test Suite Section", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = archivedSectionId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteTestSuiteSection", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchTestSuiteSections)]
        public JsonResult<BtrakJsonResult> SearchTestSuiteSections(TestSuiteSectionSearchCriteriaInputModel testSuiteSectionSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Suite Sections", "testSuiteSectionSearchCriteriaInputModel", testSuiteSectionSearchCriteriaInputModel, "Test Suite Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Suite Sections", "testSuiteSectionSearchCriteriaInputModel", testSuiteSectionSearchCriteriaInputModel, "Test Suite Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var testSuiteSections = _testSuiteService.SearchTestSuiteSections(testSuiteSectionSearchCriteriaInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Test Suite Sections", "TestSuite Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Test Suite Sections", "Test Suite Api"));
                    return Json(new BtrakJsonResult { Success = true, Data = testSuiteSections }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Test Suite Sections", "Test Suite Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestSuiteSections", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestSuiteSectionById)]
        public JsonResult<BtrakJsonResult> GetTestSuiteSectionById(Guid sectionId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Test Suite Section By Id", "sectionId", sectionId, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testSuiteSection = _testSuiteService.GetTestSuiteSectionById(sectionId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Suite Section By Id", "Test Suite Api"));

                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Suite Section By Id", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testSuiteSection, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestSuiteSectionById", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTestCase)]
        public JsonResult<BtrakJsonResult> UpsertTestCase(TestCaseInputModel testCaseInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case", "testCaseInputModel", testCaseInputModel, "TestSuite Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case", "testCaseInputModel", testCaseInputModel, "TestSuite Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var testCaseIdentifier = _testSuiteService.UpsertTestCase(testCaseInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test case", "TestSuite Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test case", "TestSuite Api"));
                    return Json(new BtrakJsonResult { Data = testCaseIdentifier, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test case", "TestSuite Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestCases", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertMultipleTestCases)]
        public JsonResult<BtrakJsonResult> UpsertMultipleTestCases(TestCaseInputModel testCaseInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Multiple Test Cases", "testCaseInputModel", testCaseInputModel, "TestSuite Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Multiple Test Cases", "testCaseInputModel", testCaseInputModel, "TestSuite Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var testCaseIdentifiers = _testSuiteService.UpsertMultipleTestCases(testCaseInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Multiple Test Cases", "TestSuite Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Multiple Test Cases", "TestSuite Api"));
                    return Json(new BtrakJsonResult { Data = testCaseIdentifiers, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Multiple Test Cases", "TestSuite Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMultipleTestCases", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTestCaseTitle)]
        public JsonResult<BtrakJsonResult> UpsertTestCaseTitle(TestCaseTitleInputModel testCaseTitleInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case Title", "testCaseTitleInputModel", testCaseTitleInputModel, "TestSuite Api"));

                var validationMessages = new List<ValidationMessage>();

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case Title", "testCaseTitleInputModel", testCaseTitleInputModel, "TestSuite Api"));

                    var testCaseId = _testSuiteService.UpsertTestCaseTitle(testCaseTitleInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Case Title", "TestSuite Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Case Title", "TestSuite Api"));
                    return Json(new BtrakJsonResult { Data = testCaseId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Case Title", "TestSuite Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestCaseTitles", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchTestCases)]
        public JsonResult<BtrakJsonResult> SearchTestCases(SearchTestCaseInputModel searchTestCaseInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Cases", "searchTestCaseInputModel", searchTestCaseInputModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCases = _testSuiteService.SearchRequiredTestCases(searchTestCaseInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Test Cases", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Test Cases", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCases, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestCases", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ReorderTestCases)]
        public JsonResult<BtrakJsonResult> ReorderTestCases(List<Guid> testCaseIds)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ReorderTestCases", "searchTestCaseInputModel", testCaseIds, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCases = _testSuiteService.ReorderTestCases(testCaseIds, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReorderTestCases", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReorderTestCases", "Test Suite Api"));
                return Json(new BtrakJsonResult { Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReorderTestCases", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.MoveCasesToSection)]
        public JsonResult<BtrakJsonResult> MoveCasesToSection(MoveTestCasesModel moveTestCasesModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "MoveCasesToSection", "searchTestCaseInputModel", moveTestCasesModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var sectionId = _testSuiteService.MoveCasesToSection(moveTestCasesModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "MoveCasesToSection", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "MoveCasesToSection", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = sectionId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "MoveCasesToSection", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserStoryScenarios)]
        public JsonResult<BtrakJsonResult> GetUserStoryScenarios(SearchTestCaseInputModel searchTestCaseInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get UserStory Scenarios", "searchTestCaseInputModel", searchTestCaseInputModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCases = _testSuiteService.GetUserStoryScenarios(searchTestCaseInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get UserStory Scenarios", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get UserStory Scenarios", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCases, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryScenarios", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTestCasesByFilters)]
        public JsonResult<BtrakJsonResult> GetTestCasesByFilters(SearchTestCaseInputModel searchTestCaseInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Cases By Filters", "searchTestCaseInputModel", searchTestCaseInputModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCases = _testSuiteService.GetTestCasesByFilters(searchTestCaseInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Cases By Filters", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Cases By Filters", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCases, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestCasesByFilters", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchTestCaseDetailsById)]
        public JsonResult<BtrakJsonResult> SearchTestCaseDetailsById(SearchTestCaseDetailsInputModel searchTestCaseDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search TestCase Details By Id", "SearchTestCaseDetailsInputModel", searchTestCaseDetailsInputModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCases = _testSuiteService.SearchTestCaseDetailsById(searchTestCaseDetailsInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search TestCase Details By Id", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search TestCase Details By Id", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCases, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestCaseDetailsById", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchTestCasesByTestRunId)]
        public JsonResult<BtrakJsonResult> SearchTestCasesByTestRunId(SearchTestCaseInputModel searchTestCaseInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Test Cases By TestRunId", "searchTestCaseInputModel", searchTestCaseInputModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCases = _testSuiteService.SearchTestCasesByTestRunId(searchTestCaseInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Test Cases By TestRunId", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Test Cases By TestRunId", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCases, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestCasesByTestRunId", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchTestRunCaseDetailsById)]
        public JsonResult<BtrakJsonResult> SearchTestRunCaseDetailsById(SearchTestCaseInputModel searchTestCaseInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search TestRunCase Details By Id", "searchTestCaseInputModel", searchTestCaseInputModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCases = _testSuiteService.SearchTestRunCaseDetailsById(searchTestCaseInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search TestRunCase Details By Id", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search TestRunCase Details By Id", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCases, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchTestRunCaseDetailsById", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateMultipleTestCases)]
        public JsonResult<BtrakJsonResult> UpdateMultipleTestCases(TestCaseInputModel testCaseInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update Multiple Test Cases", "testCaseInputModel", testCaseInputModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCaseIds = _testSuiteService.UpdateMultipleTestCases(testCaseInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Multiple Test Cases", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Multiple Test Cases", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCaseIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateMultipleTestCases", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestCaseById)]
        public JsonResult<BtrakJsonResult> GetTestCaseById(Guid testCaseId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Case By Id", "testCaseId", testCaseId, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCase = _testSuiteService.GetTestCaseById(testCaseId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Case By Id", "TestSuite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Case By Id", "TestSuite Api"));
                return Json(new BtrakJsonResult { Data = testCase, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestCaseById", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetSectionsAndSubSections)]
        public JsonResult<BtrakJsonResult> GetSectionsAndSubSections(Guid? suiteId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Sections And SubSections", "suiteId", suiteId, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var sectionList = _testSuiteService.GetSectionsAndSubsections(suiteId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Sections And SubSections", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Sections And SubSections", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = sectionList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSectionsAndSubSections", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestSuiteCount)]
        public JsonResult<BtrakJsonResult> GetTestSuiteCount(Guid? projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test suite Count", "project Id", projectId, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testSuiteCount = _testSuiteService.GetTestSuiteCount(projectId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test suite Count", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test suite Count", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testSuiteCount, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestSuiteCount", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestCasesCountByProject)]
        public JsonResult<BtrakJsonResult> GetTestCasesCountByProject(Guid? projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Cases Count By Project", "projectId", projectId, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCasesCount = _testSuiteService.GetTestCasesCountByProject(projectId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Cases Count By Project", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Cases Count By Project", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCasesCount, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestCasesCountByProject", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestRailOverviewCountsByProjectId)]
        public JsonResult<BtrakJsonResult> GetTestRailOverviewCountsByProjectId(Guid? projectId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Suite and Test Cases Count By Project", "projectId", projectId, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCasesCount = _testSuiteService.GetTestRailOverviewCountsByProjectId(projectId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Suite and Test Cases Count By Project", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Suite and Test Cases Count By Project", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCasesCount, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRailOverviewCountsByProjectId", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTestCaseStatusMasterValue)]
        public JsonResult<BtrakJsonResult> UpsertTestCaseStatusMasterValue(TestCaseStatusMasterDataInputModel testCaseStatusMasterDataInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert TestCase Status Master Value", "testCaseStatusMasterDataInputModel", testCaseStatusMasterDataInputModel, "Test Suite Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert TestCase Status Master Value", "testCaseStatusMasterDataInputModel", testCaseStatusMasterDataInputModel, "Test Suite Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var statusIdentifier = _testSuiteService.UpsertTestCaseStatusMasterValue(testCaseStatusMasterDataInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert TestCase Status Master Value", "Test Suite Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert TestCase Status Master Value", "Test Suite Api"));
                    return Json(new BtrakJsonResult { Data = statusIdentifier, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert TestCase Status Master Value", "Test Suite Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestCaseStatusMasterValue", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTestRailConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertTestRailConfiguration(TestRailConfigurationInputModel testRailConfigurationInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTestRailConfiguration", "testCaseStatusMasterDataInputModel", testRailConfigurationInputModel, "Test Suite Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTestRailConfiguration", "testCaseStatusMasterDataInputModel", testRailConfigurationInputModel, "Test Suite Api"));

                    var validationMessages = new List<ValidationMessage>();

                    var statusIdentifier = _testSuiteService.UpsertTestRailConfiguration(testRailConfigurationInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTestRailConfiguration", "Test Suite Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTestRailConfiguration", "Test Suite Api"));
                    return Json(new BtrakJsonResult { Data = statusIdentifier, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTestRailConfiguration", "Test Suite Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestRailConfiguration", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTestCaseTypeMasterValue)]
        public JsonResult<BtrakJsonResult> UpsertTestCaseTypeMasterValue(TestRailMasterDataModel testRailMasterDataInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert TestCase Type Master Value", "testRailMasterDataInputModel", testRailMasterDataInputModel, "Test Suite Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert TestCase Type Master Value", "testRailMasterDataInputModel", testRailMasterDataInputModel, "Test Suite Api"));
                    var validationMessages = new List<ValidationMessage>();

                    var typeIdentifier = _testSuiteService.UpsertTestCaseTypeMasterValue(testRailMasterDataInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert TestCase Type Master Value", "Test Suite Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert TestCase Type Master Value", "Test Suite Api"));
                    return Json(new BtrakJsonResult { Data = typeIdentifier, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert TestCase Type Master Value", "Test Suite Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestCaseTypeMasterValue", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTestCasePriorityMasterValue)]
        public JsonResult<BtrakJsonResult> UpsertTestCasePriorityMasterValue(TestRailMasterDataModel testRailMasterDataInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert TestCase Priority Master Value", "testRailMasterDataInputModel", testRailMasterDataInputModel, "Test Suite Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert TestCase Priority Master Value", "testRailMasterDataInputModel", testRailMasterDataInputModel, "Test Suite Api"));
                    var validationMessages = new List<ValidationMessage>();

                    var priorityIdentifier = _testSuiteService.UpsertTestCasePriorityMasterValue(testRailMasterDataInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert TestCase Priority Master Value", "Test Suite Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert TestCase Priority Master Value", "Test Suite Api"));
                    return Json(new BtrakJsonResult { Data = priorityIdentifier, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert TestCase Priority Master Value", "Test Suite Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestCasePriorityMasterValue", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllTestCaseStatuses)]
        public JsonResult<BtrakJsonResult> GetAllTestCaseStatuses(TestCaseStatusMasterDataModel testCaseStatusMasterDataModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Test Case Statuses", "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCaseStatusList = _testSuiteService.GetAllTestCaseStatuses(testCaseStatusMasterDataModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Test Case Statuses", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Test Case Statuses", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCaseStatusList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTestCaseStatuses", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTestRailConfigurations)]
        public JsonResult<BtrakJsonResult> GetTestRailConfigurations(TestRailConfigurationInputModel testRailConfigurationInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTestRailConfigurations", "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testRailConfigurationsList = _testSuiteService.GetTestRailConfigurations(testRailConfigurationInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTestRailConfigurations", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTestRailConfigurations", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testRailConfigurationsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRailConfigurations", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllTestCaseTypes)]
        public JsonResult<BtrakJsonResult> GetAllTestCaseTypes(TestRailMasterDataModel testRailMasterDataModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Test Case Types", "testRailMasterDataModel", testRailMasterDataModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCaseTypeList = _testSuiteService.GetAllTestCaseTypes(testRailMasterDataModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Test Case Types", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Test Case Types", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCaseTypeList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTestCaseTypes", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllTestCasePriorities)]
        public JsonResult<BtrakJsonResult> GetAllTestCasePriorities(TestRailMasterDataModel testRailMasterDataModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Test Case Priorities", "testRailMasterDataModel", testRailMasterDataModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCasePriorityList = _testSuiteService.GetAllTestCasePriorities(testRailMasterDataModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Test Case Priorities", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Test Case Priorities", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCasePriorityList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTestCasePriorities", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllTestCaseTemplates)]
        public JsonResult<BtrakJsonResult> GetAllTestCaseTemplates(TestRailMasterDataModel testRailMasterDataModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get All Test Case Templates", "testRailMasterDataModel", testRailMasterDataModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCasetemplateList = _testSuiteService.GetAllTestCaseTemplates(testRailMasterDataModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Test Case Templates", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Test Case Templates", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCasetemplateList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTestCaseTemplates", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestCaseStatusMasterDataById)]
        public JsonResult<BtrakJsonResult> GetTestCaseStatusMasterDataById(Guid? statusId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Case Status Master Data By Id", "statusId", statusId, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCaseStatus = _testSuiteService.GetTestCaseStatusMasterDataById(statusId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Case Status Master Data By Id", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Case Status Master Data By Id", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCaseStatus, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestCaseStatusMasterDataById", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestCaseTypeMasterDataById)]
        public JsonResult<BtrakJsonResult> GetTestCaseTypeMasterDataById(Guid? typeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Case Type Master Data By Id", "Type Id", typeId, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCaseType = _testSuiteService.GetTestCaseTypeMasterDataById(typeId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Case Type Master Data By Id", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Case Type Master Data By Id", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCaseType, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestCaseTypeMasterDataById", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestCasePriorityMasterDataById)]
        public JsonResult<BtrakJsonResult> GetTestCasePriorityMasterDataById(Guid? priorityId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Test Case Priority Master Data By Id", "priorityId", priorityId, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCasePriority = _testSuiteService.GetTestCasePriorityMasterDataById(priorityId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Case Priority Master Data By Id", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Test Case Priority Master Data By Id", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCasePriority, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestCasePriorityMasterDataById", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UploadTestSuiteCasesFromExcel)]
        public async Task<JsonResult<BtrakJsonResult>> UploadTestSuiteCasesFromExcel(string projectName)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upload TestSuite Cases From Excel", "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();
                var provider = new MultipartMemoryStreamProvider();
                await Request.Content.ReadAsMultipartAsync(provider);
                var result = new List<UploadTestCasesFromExcelModel>();

                foreach (var file in provider.Contents)
                {
                    var dataStream = await file.ReadAsStreamAsync();

                    result = _testSuiteService.ProcessExcelData(projectName, dataStream, LoggedInContext, new List<ValidationMessage>());
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upload TestSuite Cases From Excel", "TestSuite Api"));

                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upload TestSuite Cases From Excel", "TestSuite Api"));
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuiteCasesFromExcel", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTestSuiteCasesOverview)]
        public JsonResult<BtrakJsonResult> GetTestSuiteCasesOverview(TestSuiteCasesOverviewInputModel testSuiteCasesOverviewInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestSuite Cases Overview", "TestSuiteCasesOverviewInputModel", testSuiteCasesOverviewInputModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testSuiteCases = _testSuiteService.GetTestSuiteCasesOverview(testSuiteCasesOverviewInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestSuite Cases Overview", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestSuite Cases Overview", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testSuiteCases, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestSuiteCasesOverview", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTestCasesHierarchy)]
        public JsonResult<BtrakJsonResult> GetTestCasesHierarchy(SearchTestCaseInputModel testSuiteSectionSearchCriteria)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get TestCases Hierarchy", "TestSuiteSectionSearchCriteriaInputModel", testSuiteSectionSearchCriteria, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCasesHierarchy = _testSuiteService.GetTestCasesHierarchy(testSuiteSectionSearchCriteria, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestCases Hierarchy", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get TestCases Hierarchy", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCasesHierarchy, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestCasesHierarchy", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UploadTestCasesFromCsv)]
        public JsonResult<BtrakJsonResult> UploadTestCasesFromCsv(string projectName)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upload TestCases From Csv", "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCase = _testSuiteService.UploadTestSuitesFromCsv(projectName, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upload TestCases From Csv", "TestSuite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upload TestCases From Csv", "TestSuite Api"));
                return Json(new BtrakJsonResult { Data = testCase, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestCasesFromCsv", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.DownloadTestCasesCsvTemplate)]
        public async Task<HttpResponseMessage> DownloadTestCasesCsvTemplate()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadTestCasesCsvTemplate", "Test Suite Api"));

                var path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/SampleTestSuiteImport.csv");

                var result = File.ReadAllBytes(path);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadTestCasesCsvTemplate", "Test Suite Api"));

                return await TaskWrapper.ExecuteFunctionOnBackgroundThread(() =>
                {
                    var response = Request.CreateResponse(HttpStatusCode.OK);

                    response.Content = new ByteArrayContent(result);
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/text");
                    response.Content.Headers.Add("content-disposition", "attachment;filename=SampleTestSuiteImport.csv");
                    return response;
                });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestCasesFromCsv", "TestSuiteApiController ", exception.Message), exception);

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UploadTestSuitesFromXml)]
        public JsonResult<BtrakJsonResult> UploadTestSuitesFromXml(string projectName)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upload TestCases From Xml", "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var isUploadedSuccessfully = _testSuiteService.UploadTestSuiteFromXml(projectName, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upload TestCases From Xml", "TestSuite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upload TestCases From Xml", "TestSuite Api"));
                return Json(new BtrakJsonResult { Data = isUploadedSuccessfully, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadTestSuitesFromXml", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTestCaseAutomationType)]
        public JsonResult<BtrakJsonResult> UpsertTestCaseAutomationType(TestCaseAutomationTypeInputModel testCaseAutomationTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case Automation Type", "testCaseAutomationTypeInputModel", testCaseAutomationTypeInputModel, "Test Suite Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Test Case Automation Type", "testCaseAutomationTypeInputModel", testCaseAutomationTypeInputModel, "Test Suite Api"));
                    var validationMessages = new List<ValidationMessage>();

                    var testCaseAutomationTypeId = _testSuiteService.UpsertTestCaseAutomationType(testCaseAutomationTypeInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Case Automation Type", "Test Suite Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Case Automation Type", "Test Suite Api"));
                    return Json(new BtrakJsonResult { Data = testCaseAutomationTypeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Test Case Automation Type", "Test Suite Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestCaseAutomationType", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTestRepoDataForJson)]
        public JsonResult<BtrakJsonResult> GetTestRepoDataForJson(TestSuiteDownloadModel model)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTestRepoDataForJson", "Test Suite Api"));

                var result = GetTestRepoDataForJson(model.ProjectName, model.PersonName, model.ToMails, model.Download, model.TestSuiteName);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTestRepoDataForJson", "TestSuite Api"));

                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRepoDataForJson", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTestRepoDataForJson)]
        public JsonResult<BtrakJsonResult> GetTestRepoDataForJson(string projectName, string personName, string toMails, string download = null, string testSuiteName = null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTestRepoDataForJson", "Test Suite Api"));

                object result = null;
                download = !string.IsNullOrEmpty(download) ? download : AppConstants.Json;
                testSuiteName = !string.IsNullOrEmpty(testSuiteName) ? testSuiteName : null;

                var validationMessages = new List<ValidationMessage>();

                var loggedInContext = LoggedInContext;

                var site = HttpContext.Current.Request.Url.Authority;

                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    var testSuitesJson = _testSuiteService.GetTestRepoDataForJson(projectName, testSuiteName, loggedInContext, validationMessages);

                    if (download?.ToLower() == AppConstants.Excel)
                    {
                        TestSuiteDownloadModel exportModel = new TestSuiteDownloadModel();
                        exportModel.ProjectName = projectName;
                        exportModel.PersonName = personName;
                        exportModel.ToMails = toMails;
                        exportModel.Download = download;
                        exportModel.TestSuiteName = testSuiteName;
                        result = _testSuiteService.GetTestRepoDataForExcel(testSuitesJson, exportModel, site, loggedInContext, validationMessages);
                    }
                    else
                    {
                        result = testSuitesJson;
                    }
                });

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTestRepoDataForJson", "TestSuite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTestRepoDataForJson", "TestSuite Api"));
                return Json(new BtrakJsonResult { Data = null, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTestRepoDataForJson", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllTestCaseAutomationTypes)]
        public JsonResult<BtrakJsonResult> GetAllTestCaseAutomationTypes(TestCaseAutomationTypeSearchCriteriaInputModel testRailMasterDataModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get All Test Case AutomationTypes", "testRailMasterDataModel", testRailMasterDataModel, "Test Suite Api"));

                var validationMessages = new List<ValidationMessage>();

                var testCasePriorityList = _testSuiteService.GetAllTestCaseAutomationTypes(testRailMasterDataModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Test Case AutomationTypes", "Test Suite Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Test Case AutomationTypes", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = testCasePriorityList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTestCaseAutomationTypes", "TestSuiteApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}