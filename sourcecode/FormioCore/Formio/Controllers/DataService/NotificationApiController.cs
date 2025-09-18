using Formio.Helpers;
using Formio.Models;
using formioCommon.Constants;
using formioModels.Data;
using formioServices.Data;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System;
using formioServices.data;
using formioModels;

namespace Formio.Controllers.DataService
{
    [ApiController]
    public class NotificationApiController : AuthTokenApiController
    {
        private readonly INotificationService _notificationService;
        public NotificationApiController(INotificationService notificationService)
        {
            _notificationService = notificationService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.NotificationAlertWorkFlow)]
        public JsonResult NotificationAlertWorkFlow(NotificationAlertModel alertModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "NotificationAlertWorkFlow", "DataSourceController"));

                var validationMessages = new List<ValidationMessage>();
                DataJsonResult DataJsonResult;
                _notificationService.NotificationAlertWorkFlow(alertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out DataJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "NotificationAlertWorkFlow", "DataSourceController"));
                    return Json(new DataJsonResult { Success = false, ApiResponseMessages = DataJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "NotificationAlertWorkFlow", "DataSourceController"));

                return Json(new DataJsonResult { Data = null, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "NotificationAlertWorkFlow", "DataSourceController", exception.Message), exception);

                return Json(new DataJsonResult(exception.Message));
            }
        }
    }
}
