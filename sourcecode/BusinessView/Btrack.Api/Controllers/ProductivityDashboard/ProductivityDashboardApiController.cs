using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Services.ProductivityDashboard;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Btrak.Models.ProductivityDashboard;
using Btrak.Models.MyWork;
using Btrak.Models.TestRail;

namespace BTrak.Api.Controllers.ProductivityDashboard
{
    public class ProductivityDashboardApiController : AuthTokenApiController
    {
        private readonly IProductivityDashboardService _productivityDashboardService;

        public ProductivityDashboardApiController(IProductivityDashboardService productivityDashboardService)
        {
            _productivityDashboardService = productivityDashboardService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetProductivityIndexForDevelopers)]
        public JsonResult<BtrakJsonResult> GetProductivityIndexForDevelopers(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProductivityIndexForDevelopers", "ProductivityDashboard Api"));

                if (productivityDashboardSearchCriteriaInputModel == null)
                {
                    productivityDashboardSearchCriteriaInputModel = new ProductivityDashboardSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ProductivityIndexApiReturnModel> productivityIndex = _productivityDashboardService.GetProductivityIndexForDevelopers(productivityDashboardSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProductivityIndexForDevelopers", "ProductivityDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProductivityIndexForDevelopers", "ProductivityDashboard Api"));

                return Json(new BtrakJsonResult { Data = productivityIndex, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProductivityIndexForDevelopers", "ProductivityDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserStoryStatuses)]
        public JsonResult<BtrakJsonResult> GetUserStoryStatuses(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStoryStatuses", "ProductivityDashboard Api"));

                if (productivityDashboardSearchCriteriaInputModel == null)
                {
                    productivityDashboardSearchCriteriaInputModel = new ProductivityDashboardSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<UserStoryStatusesApiReturnModel> userStories = _productivityDashboardService.GetUserStoryStatuses(productivityDashboardSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryStatuses", "ProductivityDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryStatuses", "ProductivityDashboard Api"));

                return Json(new BtrakJsonResult { Data = userStories, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryStatuses", "ProductivityDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetQaPerformance)]
        public JsonResult<BtrakJsonResult> GetQaPerformance(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQaPerformance", "ProductivityDashboard Api"));

                if (productivityDashboardSearchCriteriaInputModel == null)
                {
                    productivityDashboardSearchCriteriaInputModel = new ProductivityDashboardSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<TestingAgeApiReturnModel> userStories = _productivityDashboardService.GetQaPerformance(productivityDashboardSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetQaPerformance", "ProductivityDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetQaPerformance", "ProductivityDashboard Api"));

                return Json(new BtrakJsonResult { Data = userStories, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetQaPerformance", "ProductivityDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserStoriesWaitingForQaApproval)]
        public JsonResult<BtrakJsonResult> GetUserStoriesWaitingForQaApproval(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStoriesWaitingForQaApproval", "ProductivityDashboard Api"));

                if (productivityDashboardSearchCriteriaInputModel == null)
                {
                    productivityDashboardSearchCriteriaInputModel = new ProductivityDashboardSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<QaApprovalApiReturnModel> userStories = _productivityDashboardService.GetUserStoriesWaitingForQaApproval(productivityDashboardSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoriesWaitingForQaApproval", "ProductivityDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoriesWaitingForQaApproval", "ProductivityDashboard Api"));

                return Json(new BtrakJsonResult { Data = userStories, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoriesWaitingForQaApproval", "ProductivityDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEveryDayTargetStatus)]
        public JsonResult<BtrakJsonResult> GetEveryDayTargetStatus(Guid? entityId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEveryDayTargetStatus", "ProductivityDashboard Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ProductivityTargetStatusApiReturnModel> status = _productivityDashboardService.GetEveryDayTargetStatus(entityId,LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEveryDayTargetStatus", "ProductivityDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEveryDayTargetStatus", "ProductivityDashboard Api"));

                return Json(new BtrakJsonResult { Data = status, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEveryDayTargetStatus", "ProductivityDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetBugReport)]
        public JsonResult<BtrakJsonResult> GetBugReport(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBugReport", "ProductivityDashboard Api"));

                if (productivityDashboardSearchCriteriaInputModel == null)
                {
                    productivityDashboardSearchCriteriaInputModel = new ProductivityDashboardSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<BugReportApiReturnModel> bugReport = _productivityDashboardService.GetBugReport(productivityDashboardSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBugReport", "ProductivityDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBugReport", "ProductivityDashboard Api"));

                return Json(new BtrakJsonResult { Data = bugReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBugReport", "ProductivityDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeUserStories)]
        public JsonResult<BtrakJsonResult> GetEmployeeUserStories(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Employee UserStories", "ProductivityDashboard Api"));

                if (productivityDashboardSearchCriteriaInputModel == null)
                {
                    productivityDashboardSearchCriteriaInputModel = new ProductivityDashboardSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EmployeeUserStoriesApiReturnModel> userStories = _productivityDashboardService.GetEmployeeUserStories(productivityDashboardSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employee UserStories", "ProductivityDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employee UserStories", "ProductivityDashboard Api"));

                return Json(new BtrakJsonResult { Data = userStories, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeUserStories", "ProductivityDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEntityDropDown)]
        public JsonResult<BtrakJsonResult> GetEntityDropDown(string searchText,bool isEmployeeList = false)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEntityDropDown", "searchText", searchText, "ProductivityDashboard Api"));


                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<EntityDropDownOutputModel> entities = _productivityDashboardService.GetEntityDropDown(searchText,isEmployeeList, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEntityDropDown", "ProductivityDashboard Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEntityDropDown", "ProductivityDashboard Api"));
                return Json(new BtrakJsonResult { Data = entities, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEntityDropDown", "ProductivityDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetProductivityIndexUserStoriesForDevelopers)]
        public JsonResult<BtrakJsonResult> GetProductivityIndexUserStoriesForDevelopers(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProductivityIndexUserStoriesForDevelopers", "ProductivityDashboard Api"));

                if (productivityDashboardSearchCriteriaInputModel == null)
                {
                    productivityDashboardSearchCriteriaInputModel = new ProductivityDashboardSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<UserHistoricalWorkReportSearchSpOutputModel> productivityIndexUserStories = _productivityDashboardService.GetProductivityIndexUserStoriesForDevelopers(productivityDashboardSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProductivityIndexUserStoriesForDevelopers", "ProductivityDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProductivityIndexUserStoriesForDevelopers", "ProductivityDashboard Api"));

                return Json(new BtrakJsonResult { Data = productivityIndexUserStories, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProductivityIndexUserStoriesForDevelopers", "ProductivityDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetProduvtivityIndexDrillDownExcelTemplate)]
        public JsonResult<BtrakJsonResult> GetProduvtivityIndexDrillDownExcelTemplate(ProductivityDashboardSearchCriteriaInputModel productivityDashboardSearchCriteriaInputModel)
        {
            try
            {
                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                PdfGenerationOutputModel file = _productivityDashboardService.GetProduvtivityIndexDrillDownExcelTemplate(productivityDashboardSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetDetailsUploadTemplate", "ProductivityDashboard Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetDetailsUploadTemplate", "ProductivityDashboard Api"));

                return Json(new BtrakJsonResult { Data = file, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProduvtivityIndexDrillDownExcelTemplate", "ProductivityDashboardApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

    }
}
