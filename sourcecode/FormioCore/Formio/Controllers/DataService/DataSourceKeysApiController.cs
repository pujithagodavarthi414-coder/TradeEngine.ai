using System;
using System.Collections.Generic;
using Formio.Helpers;
using Formio.Models;
using formioCommon.Constants;
using formioModels;
using formioModels.Data;
using formioServices.data;
using formioServices.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Hosting;
using MongoDB.Bson;
using Newtonsoft.Json;
using System.Linq;

namespace Formio.Controllers.DataService
{
    [ApiController]

    public class DataSoureceKeysController : AuthTokenApiController
    {
        private readonly IDataSourceKeysService _dataSourceKeyService;
        public DataSoureceKeysController(IDataSourceKeysService dataSourceKeysService)
        {
            _dataSourceKeyService = dataSourceKeysService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateDataSourceKeys)]
        public JsonResult CreateDataSourceKeys(DataSourceKeysInputModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeys", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                if (dataSetUpsertInputModel.RelatedFieldsfinalData != null)
                {
                    //JsonConvert.DeserializeObject<dynamic>(dataSetUpsertInputModel.RelatedFieldsfinalData.ToString()).ToBsonDocument();
                    List<RelatedFieldsFinalData> rfJson = JsonConvert.DeserializeObject<List<RelatedFieldsFinalData>>(dataSetUpsertInputModel.RelatedFieldsfinalData.ToString());
                    dataSetUpsertInputModel.RelatedFieldsfinalData = rfJson;
                }

                var dataSetId = _dataSourceKeyService.CreateDataSourceKeys(dataSetUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSourceKeys", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSourceKeys", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSourceKeys", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateDataSourceKeys)]
        public JsonResult UpdateDataSourceKeys(DataSourceKeysInputModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSourceKeys", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                Guid? dataSetId = _dataSourceKeyService.UpdateDataSourceKeys(dataSetUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSourceKeys", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSourceKeys", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSourceKeys", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchDataSourceKeys)]
        public JsonResult SearchDataSourceKeys(Guid? Id, Guid? dataSourceId,  bool? isOnlyForKeys,string searchText, string formIdsString = null, string type = null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceKeys", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                var searchInputModel = new DataSourceKeysSearchInputModel();
                searchInputModel.Id = Id;
                searchInputModel.DataSourceId = dataSourceId;
                searchInputModel.SearchText = searchText;
                searchInputModel.FormIdsString = formIdsString;
                searchInputModel.IsOnlyForKeys = isOnlyForKeys ?? false;
                searchInputModel.Type = type;
                List<DataSourceKeysOutputModel> dataSourceKeysOutputModels = _dataSourceKeyService.SearchDataSourceKeys(searchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceKeys", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceKeys", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSourceKeysOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSourceKeys", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [AllowAnonymous]
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchDataSourceKeysAnonymous)]
        public JsonResult SearchDataSourceKeysAnonymous(Guid? Id, Guid? dataSourceId, string searchText)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceKeysAnonymous", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                var searchInputModel = new DataSourceKeysSearchInputModel();
                searchInputModel.Id = Id;
                searchInputModel.DataSourceId = dataSourceId;
                searchInputModel.SearchText = searchText;

                List<DataSourceKeysOutputModel> dataSourceKeysOutputModels = _dataSourceKeyService.SearchDataSourceKeysAnonymous(searchInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceKeysAnonymous", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceKeysAnonymous", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSourceKeysOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSourceKeysAnonymous", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateOrUpdateQunatityDetails)]
        public JsonResult CreateOrUpdateQunatityDetails(CreateOrUpdateQunatityInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateOrUpdateQunatityDetails", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                var id = _dataSourceKeyService.CreateOrUpdateQunatityDetails(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateOrUpdateQunatityDetails", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateOrUpdateQunatityDetails", "DataSourceController"));

                return Json(new DataJsonResult { Data = id, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateOrUpdateQunatityDetails", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }
    }
}
