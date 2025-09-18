using Btrak.Models;
using Btrak.Models.ActivityTracker;
using Btrak.Models.ActTracker;
using Btrak.Models.Productivity;
using Btrak.Models.TimeSheet;
using Btrak.Services.ActivityTracker;
using Btrak.Services.TimeSheet;
using Btrak.Services.Productivity;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.Productivity
{
    public class ProductivityApiController : AuthTokenApiController
    {
        //private readonly UserAuthTokenFactory _userAuthTokenFactory = new UserAuthTokenFactory();
        private IProductivityService _productivityApiServices;
        //private IActivityTrackerService _activityTrackerService;
        public ProductivityApiController(IProductivityService productivityApiServices)
        {
            _productivityApiServices = productivityApiServices;
            // _activityTrackerService = activityTrackerService;
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetProductivityDetails)]
        public JsonResult<BtrakJsonResult> GetProductivityDetails(ProductivityInputModel productivityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProductivityDetails", "ProductivityInputModel", productivityInputModel, "Productivity Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;
                List<ProductivityOutputModel> productivity = _productivityApiServices.GetProductivityDetails(productivityInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ProductivityDetails", "Productivity Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ProductivityDetails", "Productivity Api"));
                return Json(new BtrakJsonResult { Data = productivity, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProductivityDetails", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetProductivityandQualityStats)]
        public JsonResult<BtrakJsonResult> GetProductivityandQualityStats(ProductivityInputModel productivityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProductivityandQualityStats", "ProductivityInputModel", productivityInputModel, "Productivity Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;
                List<ProductivityStatsOutputModel> productivity = _productivityApiServices.GetProductivityandQualityStats(productivityInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ProductivityandQualityStats", "Productivity Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ProductivityandQualityStats", "Productivity Api"));
                return Json(new BtrakJsonResult { Data = productivity, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProductivityandQualityStats", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTrendInsightsReport)]
        public JsonResult<BtrakJsonResult> GetTrendInsightsReport(TrendInsightsReportInputModel trendInsightsReportInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTrendInsightsReport", "Productivity Api"));

                BtrakJsonResult btrakJsonResult;

                List<TrendInsightsReportOutputModel> trendInsightsReport = _productivityApiServices.GetTrendInsightsReport(trendInsightsReportInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTrendInsightsReport", "Productivity Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTrendInsightsReport", "Productivity Api"));
                return Json(new BtrakJsonResult { Data = trendInsightsReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTrendInsightsReport", " ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetNoOfBugsDrillDown)]
        public JsonResult<BtrakJsonResult> GetNoOfBugsDrillDown(ProductivityInputModel productivityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetNoOfBugsDrillDownDetails", "ProductivityInputModel", productivityInputModel, "Productivity Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;
                List<NoOfBugsOutputModel> productivity = _productivityApiServices.GetNoOfBugsDrillDown(productivityInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "NoOfBugsDrillDownDetails", "Productivity Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "NoOfBugsDrillDownDetails", "Productivity Api"));
                return Json(new BtrakJsonResult { Data = productivity, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetNoOfBugsDrillDownDetails", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPlannedDetailsDrillDown)]
        public JsonResult<BtrakJsonResult> GetPlannedDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPlannedDetailsDrillDown", "PlannedHoursDrillDown Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PlannedHoursDrillDownOutputModel> plannedHours= _productivityApiServices.GetPlannedDetailsDrillDown(productivityDrillDownInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPlannedDetailsDrillDown", "PlannedHoursDrillDown Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPlannedDetailsDrillDown", "PlannedHoursDrillDown Api"));

                return Json(new BtrakJsonResult { Data = plannedHours, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPlannedDetailsDrillDown", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetProductivityDrillDown)]
        public JsonResult<BtrakJsonResult> GetProductivityDrillDown(ProductivityInputModel productivityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, " GetProductivityDrillDown", "ProductivityDrillDown Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ProductivityDrillDownOutputModel> productivityDetails= _productivityApiServices.GetProductivityDrillDown(productivityInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, " GetProductivityDrillDown", "ProductivityDrillDown Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, " GetProductivityDrillDown", "ProductivityDrillDown Api"));

                return Json(new BtrakJsonResult { Data = productivityDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, " GetProductivityDrillDown", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUtilizationDrillDown)]
        public JsonResult<BtrakJsonResult> GetUtilizationDrillDown(ProductivityInputModel productivityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, " GetUtilizationDrillDown", "GetUtilizationDrillDown Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<UtilizationOutputModel> utilizationDetails= _productivityApiServices.GetUtilizationDrillDown(productivityInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, " GetUtilizationDrillDown", "GetUtilizationDrillDown Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, " GetUtilizationDrillDown", "GetUtilizationDrillDown Api"));

                return Json(new BtrakJsonResult { Data = utilizationDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, " GetUtilizationDrillDown", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEfficiencyDrillDown)]
        public JsonResult<BtrakJsonResult> GetEfficiencyDrillDown(ProductivityInputModel productivityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEfficiencyDrillDown", "GetEfficiencyDrillDown Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EfficiencyDrillDownOutputModel> efficiencyDetails = _productivityApiServices.GetEfficiencyDrillDown(productivityInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, " GetEfficiencyDrillDown", "GetEfficiencyDrillDown Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, " GetEfficiencyDrillDown", "GetEfficiencyDrillDown Api"));

                return Json(new BtrakJsonResult { Data = efficiencyDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, " GetEfficiencyDrillDown", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetHrStats)]
        public JsonResult<BtrakJsonResult> GetHrStats (ProductivityInputModel productivityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetNoOfBugsDrillDownDetails", "ProductivityInputModel", productivityInputModel, "Productivity Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;
                List<HrStatsOutputModel> productivity = _productivityApiServices.GetHrStats(productivityInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "NoOfBugsDrillDownDetails", "Productivity Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "NoOfBugsDrillDownDetails", "Productivity Api"));
                return Json(new BtrakJsonResult { Data = productivity, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetNoOfBugsDrillDownDetails", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetNoOfBounceBacksDrillDown)]
        public JsonResult<BtrakJsonResult> GetNoOfBounceBacksDrillDown(ProductivityInputModel productivityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetNoOfBugsDrillDownDetails", "ProductivityInputModel", productivityInputModel, "Productivity Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;
                List<NoOfBounceBacksOutputModel> productivity = _productivityApiServices.GetNoOfBounceBacksDrillDown(productivityInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "NoOfBugsDrillDownDetails", "Productivity Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "NoOfBugsDrillDownDetails", "Productivity Api"));
                return Json(new BtrakJsonResult { Data = productivity, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetNoOfBugsDrillDownDetails", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDeliveredDetailsDrillDown)]
        public JsonResult<BtrakJsonResult> GetDeliveredDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, " GetDeliveredDetailsDrillDown", "GetDeliveredDetailsDrillDown Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<DeliveredHoursOutputModel> deliveredHoursDetails= _productivityApiServices.GetDeliveredDetailsDrillDown(productivityDrillDownInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDeliveredDetailsDrillDown", "GetDeliveredDetailsDrillDown Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDeliveredDetailsDrillDown", "GetDeliveredDetailsDrillDown Api"));

                return Json(new BtrakJsonResult { Data = deliveredHoursDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDeliveredDetailsDrillDown", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetNoOfReplansDrillDown)]
        public JsonResult<BtrakJsonResult> GetNoOfReplansDrillDown(ProductivityInputModel productivityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetNoOfBugsDrillDownDetails", "ProductivityInputModel", productivityInputModel, "Productivity Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;
                List<NoOfBounceBacksOutputModel> productivity = _productivityApiServices.GetNoOfReplansDrillDown(productivityInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "NoOfBugsDrillDownDetails", "Productivity Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "NoOfBugsDrillDownDetails", "Productivity Api"));
                return Json(new BtrakJsonResult { Data = productivity, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetNoOfBugsDrillDownDetails", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetSpentHoursDetailsDrillDown)]
        public JsonResult<BtrakJsonResult> GetSpentHoursDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSpentHoursDetailsDrillDown", "GetSpentHoursDetailsDrillDown Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<SpentHoursDrillDownOutputModel> spentHoursDetails = _productivityApiServices.GetSpentHoursDetailsDrillDown(productivityDrillDownInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSpentHoursDetailsDrillDown", "GetSpentHoursDetailsDrillDown Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSpentHoursDetailsDrillDown", "GetSpentHoursDetailsDrillDown Api"));

                return Json(new BtrakJsonResult { Data = spentHoursDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSpentHoursDetailsDrillDown", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCompletedTasksDetailsDrillDown)]
        public JsonResult<BtrakJsonResult> GetCompletedTasksDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompletedTasksDetailsDrillDown", "GetCompletedTasksDetailsDrillDown Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<CompletedTasksDrillDownOutputModel> completedTasksDetails = _productivityApiServices.GetCompletedTasksDetailsDrillDown(productivityDrillDownInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompletedTasksDetailsDrillDown", "GetCompletedTasksDetailsDrillDown Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompletedTasksDetailsDrillDown", "GetCompletedTasksDetailsDrillDown Api"));

                return Json(new BtrakJsonResult { Data = completedTasksDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompletedTasksDetailsDrillDown", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPendingTasksDetailsDrillDown)]
        public JsonResult<BtrakJsonResult> GetPendingTasksDetailsDrillDown(ProductivityDrillDownInputModel productivityDrillDownInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPendingTasksDetailsDrillDown", "GetPendingTasksDetailsDrillDown Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PendingTasksDrillDownOutputModel> pendingTasksDetails = _productivityApiServices.GetPendingTasksDetailsDrillDown(productivityDrillDownInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPendingTasksDetailsDrillDown", "GetPendingTasksDetailsDrillDown Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPendingTasksDetailsDrillDown", "GetPendingTasksDetailsDrillDown Api"));

                return Json(new BtrakJsonResult { Data = pendingTasksDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPendingTasksDetailsDrillDown", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetBranchMembers)]
        public JsonResult<BtrakJsonResult> GetBranchMembers(BranchMembersInputModel branchMembersInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBranchMembers", "GetBranchMembers Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<BranchMembersOutputModel> BranchMembers = _productivityApiServices.GetBranchMembers(branchMembersInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBranchMembers", "GetBranchMembers Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBranchMembers", "GetBranchMembers Api"));

                return Json(new BtrakJsonResult { Data = BranchMembers, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBranchMembers", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ProductivityDashboardJobMannually)]
        public JsonResult<BtrakJsonResult> ProductivityDashboardJobMannually(ProductivityJobMannualModel productivityJobMannualModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ProductivityDashboardJobMannually", "ProductivityDashboardJobMannually Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                _productivityApiServices.ProductivityJobMannual(productivityJobMannualModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ProductivityJobMannual", "ProductivityJobMannual Api"));
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ProductivityJobMannual", "ProductivityJobMannual Api"));

                return Json(new BtrakJsonResult { Data = null, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ProductivityJobMannual", "ProductivityApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}