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

namespace Formio.Controllers.DataService
{
    [ApiController]

    public class DataSoureceKeysConfigurationController : AuthTokenApiController
    {
        private readonly IDataSourceKeysConfigurationService _dataSourceKeyConfigurationService;
        public DataSoureceKeysConfigurationController(IDataSourceKeysConfigurationService dataSourceKeysConfigurationService)
        {
            _dataSourceKeyConfigurationService = dataSourceKeysConfigurationService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateDataSourceKeysConfiguration)]
        public JsonResult CreateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeysConfiguration", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                var dataSetId = _dataSourceKeyConfigurationService.CreateDataSourceKeysConfiguration(dataSetUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSourceKeysConfiguration", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSourceKeysConfiguration", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSourceKeysConfiguration", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }
       
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateDataSourceKeysConfiguration)]
        public JsonResult UpdateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSourceKeysConfiguration", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                Guid? dataSetId = _dataSourceKeyConfigurationService.UpdateDataSourceKeysConfiguration(dataSetUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSourceKeysConfiguration", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSourceKeysConfiguration", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSourceKeysConfiguration", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ArchiveDataSourceKeysConfiguration)]
        public JsonResult ArchiveDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSourceKeysConfiguration", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                Guid? dataSetId = _dataSourceKeyConfigurationService.ArchiveDataSourceKeysConfiguration(dataSetUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSourceKeysConfiguration", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSourceKeysConfiguration", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSourceKeysConfiguration", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchDataSourceKeysConfiguration)]
        public JsonResult SearchDataSourceKeysConfiguration(Guid? id, Guid? dataSourceId, Guid? dataSourceKeyId, Guid? customApplicationId, bool? isOnlyForKeys)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceKeysConfiguration", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                var searchInputModel = new DataSourceKeysConfigurationSearchInputModel();
                searchInputModel.Id = id;
                searchInputModel.DataSourceId = dataSourceId;
                searchInputModel.DataSourceKeyId = dataSourceKeyId;
                searchInputModel.CustomApplicationId = customApplicationId;
                searchInputModel.IsOnlyForKeys = isOnlyForKeys ?? false;

                DataSourceKeysConfigurationModel dataSourceKeysOutputModels = _dataSourceKeyConfigurationService.SearchDataSourceKeyConfiguration(searchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceKeysConfiguration", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceKeysConfiguration", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSourceKeysOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSourceKeysConfiguration", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [AllowAnonymous]
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchDataSourceKeysConfigurationAnonymous)]
        public JsonResult SearchDataSourceKeysConfigurationAnonymous(Guid? id, Guid? dataSourceId, Guid? dataSourceKeyId, Guid? customApplicationId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceKeysConfigurationAnonymous", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                var searchInputModel = new DataSourceKeysConfigurationSearchInputModel();
                searchInputModel.Id = id;
                searchInputModel.DataSourceId = dataSourceId;
                searchInputModel.DataSourceKeyId = dataSourceKeyId;
                searchInputModel.CustomApplicationId = customApplicationId;

                List<DataSourceKeysConfigurationOutputModel> dataSourceKeysOutputModels = _dataSourceKeyConfigurationService.SearchDataSourceKeysConfigurationAnonymous(searchInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceKeysConfigurationAnonymous", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceKeysConfigurationAnonymous", "DataSourceController"));

                return Json(new DataJsonResult { Data = dataSourceKeysOutputModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSourceKeysConfigurationAnonymous", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }
    }
}
