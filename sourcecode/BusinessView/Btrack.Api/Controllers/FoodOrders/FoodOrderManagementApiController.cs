using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.FoodOrders;
using Btrak.Services.FoodOrders;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.FoodOrders
{
    public class FoodOrderManagementApiController : AuthTokenApiController
    {
        private readonly IFoodOrderManagementService _foodOrderManagementService;

        public FoodOrderManagementApiController(IFoodOrderManagementService foodOrderManagementService)
        {
            _foodOrderManagementService = foodOrderManagementService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertFoodOrder)]
        public JsonResult<BtrakJsonResult> UpsertFoodOrder(FoodOrderManagementInputModel foodOrderManagementInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertFoodOrder", "foodOrderManagementInputModel", foodOrderManagementInputModel, "FoodOrderManagement Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? foodOrderIdReturned = _foodOrderManagementService.UpsertFoodOrder(foodOrderManagementInputModel, LoggedInContext, validationMessages);
                LoggingManager.Info("FoodOrder Upsert is completed. Return Guid is " + foodOrderIdReturned + ", source command is " + foodOrderManagementInputModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertFoodOrder", "FoodOrderManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertFoodOrder", "FoodOrderManagement Api"));
                return Json(new BtrakJsonResult { Data = foodOrderIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFoodOrder", "FoodOrderManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchFoodOrder)]
        public JsonResult<BtrakJsonResult> SearchFoodOrder(FoodOrderManagementSearchCriteriaInputModel foodOrderManagementSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchFoodOrders", "foodOrderManagementSearchCriteriaInputModel", foodOrderManagementSearchCriteriaInputModel, "FoodOrderManagement Api"));
                if (foodOrderManagementSearchCriteriaInputModel == null)
                {
                    foodOrderManagementSearchCriteriaInputModel = new FoodOrderManagementSearchCriteriaInputModel();
                }
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting foodOrders list");
                List<FoodOrderManagementApiReturnModel> foodOrdersList = _foodOrderManagementService.SearchFoodOrders(foodOrderManagementSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchFoodOrders", "FoodOrderManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchFoodOrders", "FoodOrderManagement Api"));
                return Json(new BtrakJsonResult { Data = foodOrdersList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFoodOrder", "FoodOrderManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetFoodOrderById)]
        public JsonResult<BtrakJsonResult> GetFoodOrderById(Guid? foodOrderId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetFoodOrderById", "foodOrderId", foodOrderId, "FoodOrderManagement Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                FoodOrderManagementApiReturnModel foodOrderReturned = _foodOrderManagementService.GetFoodOrderById(foodOrderId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFoodOrderById", "FoodOrderManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFoodOrderById", "FoodOrderManagement Api"));
                return Json(new BtrakJsonResult { Data = foodOrderReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFoodOrderById", "FoodOrderManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllFoodOrders)]
        public JsonResult<BtrakJsonResult> GetAllFoodOrders(LatestFoodOrdersModel searchCriteriaInputModelBase)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllFoodOrders", "pageNumber", searchCriteriaInputModelBase.PageNumber, "FoodOrderManagement Api"));
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllFoodOrders", "pageSize", searchCriteriaInputModelBase.PageSize, "FoodOrderManagement Api"));
                FoodOrderManagementSearchCriteriaInputModel foodOrderManagementSearchCriteriaInputModel = new FoodOrderManagementSearchCriteriaInputModel()
                {
                    PageNumber = searchCriteriaInputModelBase.PageNumber,
                    PageSize = searchCriteriaInputModelBase.PageSize,
                    SortBy = searchCriteriaInputModelBase.SortBy,
                    SortDirectionAsc = searchCriteriaInputModelBase.SortDirectionAsc
                };
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                List<FoodOrderManagementApiReturnModel> foodOrdersList = _foodOrderManagementService.SearchFoodOrders(foodOrderManagementSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllFoodOrders", "FoodOrderManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllFoodOrders", "FoodOrderManagement Api"));
                return Json(new BtrakJsonResult { Data = foodOrdersList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllFoodOrders", "FoodOrderManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRecentFoodOrders)]
        public JsonResult<BtrakJsonResult> GetRecentFoodOrders(LatestFoodOrdersModel searchCriteriaInputModelBase)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetRecentFoodOrders", "pageNumber", searchCriteriaInputModelBase.PageNumber, "FoodOrderManagement Api"));
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetRecentFoodOrders", "pageSize", searchCriteriaInputModelBase.PageSize, "FoodOrderManagement Api"));
                FoodOrderManagementSearchCriteriaInputModel foodOrderManagementSearchCriteriaInputModel = new FoodOrderManagementSearchCriteriaInputModel()
                {
                    PageNumber = searchCriteriaInputModelBase.PageNumber,
                    PageSize = searchCriteriaInputModelBase.PageSize,
                    SortBy = searchCriteriaInputModelBase.SortBy,
                    SortDirectionAsc = searchCriteriaInputModelBase.SortDirectionAsc,
                    SearchText = searchCriteriaInputModelBase.SearchText,
                    IsRecent = searchCriteriaInputModelBase.IsRecent,
                    EntityId = searchCriteriaInputModelBase.EntityId
                };
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                List<FoodOrderManagementApiReturnModel> foodOrdersList = _foodOrderManagementService.SearchFoodOrders(foodOrderManagementSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRecentFoodOrders", "FoodOrderManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRecentFoodOrders", "FoodOrderManagement Api"));
                return Json(new BtrakJsonResult { Data = foodOrdersList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRecentFoodOrders", "FoodOrderManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetMonthlyFoodOrderReport)]
        public JsonResult<BtrakJsonResult> GetMonthlyFoodOrderReport(DateTime? date,Guid? entityId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMonthlyFoodOrderReport", "Date", date, "FoodOrderManagement Api"));
                FoodOrderManagementSearchCriteriaInputModel foodOrderManagementSearchCriteriaInputModel = new FoodOrderManagementSearchCriteriaInputModel()
                {
                   Date = date,
                   EntityId =entityId
                };
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                List<FoodOrderManagementSpReturnModel> foodOrderDashboardList = _foodOrderManagementService.GetMonthlyFoodOrderReport(foodOrderManagementSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMonthlyFoodOrderReport", "FoodOrderManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMonthlyFoodOrderReport", "FoodOrderManagement Api"));
                return Json(new BtrakJsonResult { Data = foodOrderDashboardList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMonthlyFoodOrderReport", "FoodOrderManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ChangeFoodOrderStatus)]
        public JsonResult<BtrakJsonResult> ChangeFoodOrderStatus(ChangeFoodOrderStatusInputModel changeFoodOrderStatusInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ChangeFoodOrderStatus", "changeFoodOrderStatusInputModel", changeFoodOrderStatusInputModel, "FoodOrderManagement Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? foodOrderIdReturned = _foodOrderManagementService.ChangeFoodOrderStatus(changeFoodOrderStatusInputModel, LoggedInContext, validationMessages);
                LoggingManager.Info("FoodOrder status updated. Return Guid is " + foodOrderIdReturned + ", source command is " + changeFoodOrderStatusInputModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ChangeFoodOrderStatus", "FoodOrderManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ChangeFoodOrderStatus", "FoodOrderManagement Api"));
                return Json(new BtrakJsonResult { Data = foodOrderIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ChangeFoodOrderStatus", "FoodOrderManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
