using Btrak.Models;
using Btrak.Models.CustomApplication;
using Btrak.Services.FormDataServices;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.DataService
{
    public class DataSetApiController : AuthTokenApiController
    {
        private readonly IDataSetService _dataSetService;

        public DataSetApiController(IDataSetService dataSetService)
        {
            _dataSetService = dataSetService;
        }
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetDataSetById)]
        public async Task<JsonResult<BtrakJsonResult>> GetDataSetById(Guid id)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetById", "DataSetController"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                var genericFormSubmittedId = await _dataSetService.GetDataSetById(id, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetById", "DataSetController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetById", "DataSetController"));

                return Json(new BtrakJsonResult { Data = genericFormSubmittedId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetById", "DataSetController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchDataSets)]
        public async Task<JsonResult<BtrakJsonResult>> SearchDataSets(Guid? id, Guid? dataSourceId, string searchText, bool? isArchived, bool? isPagingRequired, int pageNumber, int pageSize)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSets", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var dataSetOutputModelList = await _dataSetService.SearchDataSets(id, dataSourceId, searchText,null, isArchived,isPagingRequired, pageNumber,pageSize, LoggedInContext, validationMessages, null, null, null, null, null);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSets", "DataSourceController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSets", "DataSourceController"));

                return Json(new BtrakJsonResult { Data = dataSetOutputModelList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSourceController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SaveWebPageView)]
        public async Task<JsonResult<BtrakJsonResult>> SaveWebPageView(WebPageViewerModel webPageViewerModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveWebPageView", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var dataSetOutputModelList = await _dataSetService.SaveWebPageView(webPageViewerModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SaveWebPageView", "DataSourceController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SaveWebPageView", "DataSourceController"));

                return Json(new BtrakJsonResult { Data = dataSetOutputModelList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveWebPageView", "DataSourceController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetWebPageView)]
        public async Task<JsonResult<BtrakJsonResult>> GetWebPageView(string path)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWebPageView", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var dataSetOutputModelList = await _dataSetService.GetWebPageView(path, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWebPageView", "DataSourceController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWebPageView", "DataSourceController"));

                return Json(new BtrakJsonResult { Data = dataSetOutputModelList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWebPageView", "DataSourceController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteMultipleDataSets)]
        public JsonResult<BtrakJsonResult> DeleteMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteMultipleDataSets", "livesService"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                var result = _dataSetService.DeleteMultipleDataSets(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteMultipleDataSets", "livesService"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteMultipleDataSets", "livesService"));
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteMultipleDataSets", "LivesApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UnArchiveMultipleDataSets)]
        public JsonResult<BtrakJsonResult> UnArchiveMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UnArchiveMultipleDataSets", "livesService"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                var result = _dataSetService.UnArchiveMultipleDataSets(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UnArchiveMultipleDataSets", "livesService"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UnArchiveMultipleDataSets", "livesService"));
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UnArchiveMultipleDataSets", "LivesApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}