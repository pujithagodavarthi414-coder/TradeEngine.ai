
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
    public class DataSetHistoryApiController : AuthTokenApiController
    {
        private readonly IDataSetHistoryService _dataSetHistoryService;
        public DataSetHistoryApiController(IDataSetHistoryService dataSetHistoryService)
        {
            _dataSetHistoryService = dataSetHistoryService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateDataSetHistory)]
        public JsonResult CreateDataSetHistory(DataSetHistoryInputModel dataSetHistoryInputInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSetHistory", "DataSetHistoryApiController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;
                var dataSetId = _dataSetHistoryService.CreateDataSetHistory(dataSetHistoryInputInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSetHistory", "DataSetHistoryApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSetHistory", "DataSetHistoryApiController"));

                return Json(new DataJsonResult { Data = dataSetId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSetHistory", "DataSetHistoryApiController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchDataSetHistory)]
        public JsonResult SearchDataSetHistory(Guid? dataSetId, Guid? referenceId,int? pageNo, int? pageSize)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSetHistory", "DataSetHistoryApiController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;

                List<DataSetHistoryInputModel> history = _dataSetHistoryService.SearchDataSetHistory(dataSetId, referenceId, pageNo, pageSize,  LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSetHistory", "DataSetHistoryApiController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSetHistory", "DataSetHistoryApiController"));

                return Json(new DataJsonResult { Data = history, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSetHistory", "DataSetHistoryApiController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }
    }
}