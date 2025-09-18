using Btrak.Models;
using Btrak.Models.Assets;
using Btrak.Models.SeatingArrangement;
using Btrak.Services.Assets;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.Assets
{
    public class AssetApiController : AuthTokenApiController
    {
        private readonly IAssetServices _assetService;
        private BtrakJsonResult _btrakJsonResult;

        public AssetApiController(IAssetServices assetService)
        {
            _assetService = assetService;
            _btrakJsonResult = new BtrakJsonResult
            {
                Success = false
            };
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAsset)]
        public JsonResult<BtrakJsonResult> UpsertAsset(AssetsInputModel assetDetailsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Asset Started", "assetDetailsModel", assetDetailsModel, "Asset Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? assetId = _assetService.UpsertAsset(assetDetailsModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Asset Upsert is completed. Return Guid is " + assetId + ", source command is " + assetDetailsModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Asset", "Asset Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Asset", "Asset Api"));
                return Json(new BtrakJsonResult { Data = assetId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAsset", "AssetApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchAssets)]
        public JsonResult<BtrakJsonResult> SearchAssets(AssetSearchCriteriaInputModel assetSearchCriteriaModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchAssets", "assetSearchCriteriaModel", assetSearchCriteriaModel, "Assets Api"));

                if (assetSearchCriteriaModel == null)
                {
                    assetSearchCriteriaModel = new AssetSearchCriteriaInputModel();
                }

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                LoggingManager.Info("Getting asset List");

                List<AssetsOutputModel> assetList = _assetService.SearchAllAssets(assetSearchCriteriaModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Assets", "Asset Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Assets", "Asset Api"));

                return Json(new BtrakJsonResult { Data = assetList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAssets", "AssetApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllUsersAssets)]
        public JsonResult<BtrakJsonResult> GetAllUsersAssets(AssetSearchCriteriaInputModel assetSearchCriteriaModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllUsersAssets", "loggedInContext", LoggedInContext, "Assets Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                LoggingManager.Info("GetAllUsersAssets");

                List<AllUsersAssetsModel> assetList = _assetService.GetAllUsersAssets(assetSearchCriteriaModel,LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllUsersAssets", "Asset Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllUsersAssets", "Asset Api"));

                return Json(new BtrakJsonResult { Data = assetList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllUsersAssets", "AssetApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAssetsCount)]
        public JsonResult<BtrakJsonResult> GetAssetsCount(AssetSearchCriteriaInputModel assetSearchCriteriaModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Assets Count", "Asset Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                int? assetCount = _assetService.GetAssetsCount(assetSearchCriteriaModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Assets Count", "Assets Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Assets Count", "Asset Api"));
                return Json(new BtrakJsonResult { Success = true, Data = assetCount }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAssetsCount", "AssetApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetMyAssets)]
        public JsonResult<BtrakJsonResult> GetMyAssets(Guid userId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAssetDetailsById", "assetId", userId, "Asset Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                AssetsOutputModel asset = _assetService.GetMyAsset(userId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Asset Details by Id", "Assets Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Asset Details by Id", "Asset Api"));
                return Json(new BtrakJsonResult { Success = true, Data = asset }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMyAssets", "AssetApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateAssigneeForMultipleAssets)]
        public JsonResult<BtrakJsonResult> UpdateAssigneeForMultipleAssets(AssetsInputModel assetDetailsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Update multiple assets", "Asset Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List <AssetsMultipleUpdateReturnModel> assetCount = _assetService.UpdateAssigneeForMultipleAssets(assetDetailsModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update multiple assets", "Assets Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update multiple assets", "Asset Api"));
                return Json(new BtrakJsonResult { Success = true, Data = assetCount }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateAssigneeForMultipleAssets", "AssetApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertSeating)]
        public JsonResult<BtrakJsonResult> UpsertSeatingArrangement(SeatingArrangementInputModel seatingModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Seating Arrangement Started", "seatingModel", seatingModel, "Asset Api"));
                if (ModelState.IsValid)
                {
                    List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                    Guid? seatingId = _assetService.UpsertSeatingArrangement(seatingModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Seating Arrangement", "Assets Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Seating Arrangement Ended", "Asset Api"));

                    return Json(new BtrakJsonResult { Success = true, Data = seatingId }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Seating Arrangement Ended", "Asset Api"));

                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSeatingArrangement", "AssetApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchSeatingArrangement)]
        public JsonResult<BtrakJsonResult> SearchSeatingArrangement(SeatingSearchCriteriaInputModel seatingSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Seating Arrangement", "seatingSearchCriteriaInputModel", seatingSearchCriteriaInputModel, "Asset Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<SeatingArrangementOutputModel> seating = _assetService.GetAllSeatingArrangement(seatingSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Seating Arrangement by Id", "Assets Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Seating Arrangement by Id", "Asset Api"));

                return Json(new BtrakJsonResult { Success = true, Data = seating }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSeatingArrangement", "AssetApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetSeatingArrangementById)]
        public JsonResult<BtrakJsonResult> GetSeatingArrangementById(Guid seatingArrangementId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Seating Arrangement by Id", "seatingArrangementId", seatingArrangementId, "Asset Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                SeatingArrangementOutputModel seating = _assetService.GetSeatingArrangementById(seatingArrangementId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Seating Arrangement by Id", "Assets Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Seating Arrangement by Id", "Asset Api"));
                return Json(new BtrakJsonResult { Success = true, Data = seating }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSeatingArrangementById", "AssetApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAssetsAssignedToEmployees)]
        public JsonResult<BtrakJsonResult> GetAssetsAssignedToEmployees(AssetSearchCriteriaInputModel assetSearchCriteriaModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get all assets assigned to employee", "assetSearchCriteriaModel", assetSearchCriteriaModel, "Asset Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<AssetsDashboardOutputModel> seating = _assetService.GetAllAssetsAssignedToEmployees(assetSearchCriteriaModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get all assets assigned to employee", "Assets Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get all assets assigned to employee", "Asset Api"));

                return Json(new BtrakJsonResult { Success = true, Data = seating }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAssetsAssignedToEmployees", "AssetApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAssetCommentsAndHistory)]
        public JsonResult<BtrakJsonResult> GetAssetCommentsAndHistory(AssetCommentAndHistorySearchCriteriaInputModel assetCommentAndHistorySearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Asset CommentsAndHistory", "AssetCommentAndHistorySearchCriteriaInputModel", assetCommentAndHistorySearchCriteriaInputModel, "Asset Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<AssetCommentsAndHistoryOutputModel> assetCommentsAndHistory = _assetService.GetCommentsAndHistory(assetCommentAndHistorySearchCriteriaInputModel, LoggedInContext, validationMessages);
                validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get all comments and history of an asset", "Asset Api"));
                return Json(new BtrakJsonResult { Success = true, Data = assetCommentsAndHistory }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAssetCommentsAndHistory", "AssetApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllAssets)]
        public JsonResult<BtrakJsonResult> GetAllAssets(AssetSearchCriteriaInputModel assetSearchCriteriaModel)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get all Assets", "assetSearchCriteriaModel", assetSearchCriteriaModel, "Asset Api"));
            return SearchAssets(assetSearchCriteriaModel);
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.PrintAssets)]
        public async Task<JsonResult<BtrakJsonResult>> PrintAssets(AssetFileInputModel assetFileInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "PrintAssets", "assetFileInputModel", assetFileInputModel, "Asset Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                byte[] byteArray = await _assetService.PrintAssets(assetFileInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "PrintAssets", "Asset Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "PrintAssets", "Asset Api"));

                return Json(new BtrakJsonResult { Data = byteArray, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PrintAssets", "AssetApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}

