using Formio.Helpers;
using Formio.Models;
using formioCommon.Constants;
using formioModels.Data;
using formioServices.Data;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System;
using formioModels;
using formioServices.data;

namespace Formio.Controllers.DataService
{
    [ApiController]
    public class DataLevelKeyConfigurationController : AuthTokenApiController
    {
        private readonly IDataLevelKeyConfigurationService _dataLevelKeyConfigurationService;

        public DataLevelKeyConfigurationController(IDataLevelKeyConfigurationService iDataLevelKeyConfigurationService)
        {
            _dataLevelKeyConfigurationService = iDataLevelKeyConfigurationService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateLevelKeyConfiguration)]
        public JsonResult CreateLevelKeyConfiguration(DataLevelKeyConfigurationModel dataLevelKeyConfigurationModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateLevelKeyConfiguration", "DataLevelKeyConfigurationController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;
                var levelKeyId = _dataLevelKeyConfigurationService.CreateLevelKeyConfiguration(dataLevelKeyConfigurationModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateLevelKeyConfiguration", "DataLevelKeyConfigurationController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateLevelKeyConfiguration", "DataLevelKeyConfigurationController"));

                return Json(new DataJsonResult { Data = levelKeyId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateLevelKeyConfiguration", "DataLevelKeyConfigurationController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchLevelKeyConfiguration)]
        public JsonResult SearchLevelKeyConfiguration(Guid? customApplicationId, Guid? levelId ,bool? isArchived)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchLevelKeyConfiguration", "DataLevelKeyConfigurationController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;
                List<GetDataLevelKeyConfigurationModel> levelKeys = _dataLevelKeyConfigurationService.SearchLevelKeyConfiguration(customApplicationId, levelId, isArchived, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchLevelKeyConfiguration", "DataLevelKeyConfigurationController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchLevelKeyConfiguration", "DataLevelKeyConfigurationController"));

                return Json(new DataJsonResult { Data = levelKeys, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateLevelKeyConfiguration", "DataLevelKeyConfigurationController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }
    }
}
