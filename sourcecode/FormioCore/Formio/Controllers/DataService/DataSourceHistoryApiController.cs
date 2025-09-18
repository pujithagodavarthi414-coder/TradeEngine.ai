using Formio.Helpers;
using formioCommon.Constants;
using Formio.Models;
using formioModels.Data;
using formioServices.data;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using formioModels;

namespace Formio.Controllers.DataService
{
    [ApiController]
    public class DataSourceHistoryApiController : AuthTokenApiController
    {
        private readonly IDataSourceHistoryService _dataSourceHistoryService;
       public DataSourceHistoryApiController(IDataSourceHistoryService dataSourceHistoryService)
        {
            _dataSourceHistoryService = dataSourceHistoryService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateDataSourceHistory)]
        public JsonResult CreateDataSourceHistory(DataSourceHistoryInputModel dataSourceUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceHistory", "DataSourceHistoryController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                var dataSourceId = _dataSourceHistoryService.CreateDataSourceHistory(dataSourceUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSourceHistory", "DataSourceHistoryController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSourceHistory", "DataSourceHistoryController"));

                return Json(new DataJsonResult { Data = dataSourceId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSourceHistory", "DataSourceHistoryController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchDataSourceHistory)]

        public JsonResult SearchDataSourceHistory(Guid? id, Guid? dataSourceId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceHistory", "DataSourceHistoryController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;
                var dataSourceHistorySearchInputModel = new DataSourceHistorySearchInputModel();
                dataSourceHistorySearchInputModel.Id = id;
                dataSourceHistorySearchInputModel.IsArchived = false;
                dataSourceHistorySearchInputModel.DataSourceId = dataSourceId;

                var dataSourceHistoryRecords = _dataSourceHistoryService.SearchDataSourceHistory(dataSourceHistorySearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceHistory", "DataSourceHistoryController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSourceHistory", "DataSourceHistoryController"));

                return Json(new DataJsonResult { Data = dataSourceHistoryRecords, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSourceHistory", "DataSourceHistoryController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }
    }
}