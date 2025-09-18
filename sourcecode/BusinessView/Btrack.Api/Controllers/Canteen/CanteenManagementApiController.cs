using Btrak.Models;
using Btrak.Models.Canteen;
using Btrak.Services.Canteen;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.Canteen
{
    public class CanteenManagementApiController : AuthTokenApiController
    {
        private readonly ICanteenService _canteenService;
        private BtrakJsonResult _btrakJsonResult;

        public CanteenManagementApiController(ICanteenService canteenService)
        {
            _canteenService = canteenService;
            _btrakJsonResult = new BtrakJsonResult();
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCanteenFoodItem)]
        public JsonResult<BtrakJsonResult> UpsertCanteenFoodItem(CanteenFoodItemInputModel canteenFoodItemInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Canteen Food Item", "canteenFoodItemInputModel", canteenFoodItemInputModel, "Canteen Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? foodItemId = _canteenService.UpsertCanteenFoodItem(canteenFoodItemInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Canteen Food Item", "Canteen Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Canteen Food Item", "Canteen Api"));
                return Json(new BtrakJsonResult { Data = foodItemId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCanteenFoodItem", "CanteenManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchFoodItems)]
        public JsonResult<BtrakJsonResult> SearchFoodItems(FoodItemSearchCriteriaInputModel foodItemSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Food Items", "canteenFoodItemInputModel", foodItemSearchCriteriaInputModel, "Canteen Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<FoodItemApiReturnModel> foodItemList = _canteenService.SearchFoodItems(foodItemSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Food Items", "Canteen Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Food Items", "Canteen Api"));
                return Json(new BtrakJsonResult { Data = foodItemList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFoodItems", "CanteenManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetFoodItemById)]
        public JsonResult<BtrakJsonResult> GetFoodItemById(Guid? foodItemId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get FoodItem By Id", "foodItemId", foodItemId, "Canteen Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                FoodItemApiReturnModel foodItem = _canteenService.GetFoodItemById(foodItemId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get FoodItem By Id", "Canteen Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get FoodItem By Id", "Canteen Api"));
                return Json(new BtrakJsonResult { Data = foodItem, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFoodItemById", "CanteenManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCanteenCredit)]
        public JsonResult<BtrakJsonResult> UpsertCanteenCredit(CanteenCreditInputModel canteenCreditInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Canteen Credit", "canteenCreditInputModel", canteenCreditInputModel, "Canteen Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                bool? canteenCredit = _canteenService.UpsertCanteenCredit(canteenCreditInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Canteen Credit", "Canteen Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Canteen Credit", "Canteen Api"));
                return Json(new BtrakJsonResult { Data = canteenCredit, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCanteenCredit", "CanteenManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchCanteenCredit)]
        public JsonResult<BtrakJsonResult> SearchCanteenCredit(CanteenCreditSearchInputModel canteenCreditSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCanteenCredit", "canteenCreditSearchInputModel", canteenCreditSearchInputModel, "Canteen Api"));
                if (canteenCreditSearchInputModel == null)
                {
                    canteenCreditSearchInputModel = new CanteenCreditSearchInputModel();
                }
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                LoggingManager.Info("Getting foodOrders list ");
                List<CanteenCreditApiOutputModel> canteenCreditList = _canteenService.SearchCanteenCredit(canteenCreditSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCanteenCredit", "Canteen Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCanteenCredit", "Canteen Api"));
                return Json(new BtrakJsonResult { Data = canteenCreditList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCanteenCredit", "CanteenManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCanteenCreditByUserId)]
        public JsonResult<BtrakJsonResult> GetCanteenCreditByUserId(Guid? userId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCanteenCreditByUserId", "userId", userId, "Canteen Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<CanteenCreditApiOutputModel> canteenCredit = _canteenService.GetCanteenCreditByUserId(userId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCanteenCreditByUserId", "Canteen Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCanteenCreditByUserId", "Canteen Api"));
                return Json(new BtrakJsonResult { Data = canteenCredit, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCanteenCreditByUserId", "CanteenManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.PurchaseCanteenItem)]
        public JsonResult<BtrakJsonResult> PurchaseCanteenItem(List<PurchaseCanteenItemInputModel> purchaseCanteenItemInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Purchase Canteen Item", "purchaseCanteenItemInputModel", purchaseCanteenItemInputModel, "Canteen Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<Guid> purchaseResult = _canteenService.PurchaseCanteenItem(purchaseCanteenItemInputModel, false, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Purchase Canteen Item", "Canteen Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Purchase Canteen Item", "Canteen Api"));
                return Json(new BtrakJsonResult { Data = purchaseResult, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PurchaseCanteenItem", "CanteenManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchCanteenPurchases)]
        public JsonResult<BtrakJsonResult> SearchCanteenPurchases(SearchCanteenPurcahsesInputModel searchCanteenPurchasesInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCanteenPurchases", "searchCanteenPurcahsesInputModel", searchCanteenPurchasesInputModel, "Canteen Api"));
                if (searchCanteenPurchasesInputModel == null)
                {
                    searchCanteenPurchasesInputModel = new SearchCanteenPurcahsesInputModel();
                }
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<CanteenPurchaseOutputModel> canteenPurchasesList = _canteenService.SearchCanteenPurchases(searchCanteenPurchasesInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCanteenPurchases", "Canteen Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCanteenPurchases", "Canteen Api"));
                return Json(new BtrakJsonResult { Data = canteenPurchasesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCanteenPurchases", "CanteenManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserCanteenPurchases)]
        public JsonResult<BtrakJsonResult> GetUserCanteenPurchases(SearchCanteenPurcahsesInputModel searchCanteenPurchasesInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCanteenPurchases", "searchCanteenPurchasesInputModel", searchCanteenPurchasesInputModel, "Canteen Api"));
                if (searchCanteenPurchasesInputModel == null)
                {
                    searchCanteenPurchasesInputModel = new SearchCanteenPurcahsesInputModel();
                }
                searchCanteenPurchasesInputModel.UserId = LoggedInContext.LoggedInUserId;
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<CanteenPurchaseOutputModel> canteenPurchasesList = _canteenService.SearchCanteenPurchases(searchCanteenPurchasesInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCanteenPurchases", "Canteen Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCanteenPurchases", "Canteen Api"));
                return Json(new BtrakJsonResult { Data = canteenPurchasesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserCanteenPurchases", "CanteenManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchCanteenBalance)]
        public JsonResult<BtrakJsonResult> SearchCanteenBalance(SearchCanteenBalanceInputModel searchCanteenBalanceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCanteenBalance", "searchCanteenBalanceInputModel", searchCanteenBalanceInputModel, "Canteen Api"));
                if (searchCanteenBalanceInputModel == null)
                {
                    searchCanteenBalanceInputModel = new SearchCanteenBalanceInputModel();
                }
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<CanteenBalanceApiOutputModel> canteenPurchasesList = _canteenService.SearchCanteenBalance(searchCanteenBalanceInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCanteenBalance", "Canteen Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCanteenBalance", "Canteen Api"));
                return Json(new BtrakJsonResult { Data = canteenPurchasesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCanteenBalance", "CanteenManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetMyCanteenBalance)]
        public JsonResult<BtrakJsonResult> GetMyCanteenBalance()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMyCanteenBalance", "null", null, "Canteen Api"));

                SearchCanteenBalanceInputModel searchCanteenBalanceInputModel = new SearchCanteenBalanceInputModel
                {
                    UserId = LoggedInContext.LoggedInUserId
                };

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<CanteenBalanceApiOutputModel> canteenPurchasesList = _canteenService.SearchCanteenBalance(searchCanteenBalanceInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCanteenBalance", "Canteen Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCanteenBalance", "Canteen Api"));
                return Json(new BtrakJsonResult { Data = canteenPurchasesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMyCanteenBalance", "CanteenManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
