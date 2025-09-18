using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Notification;
using Btrak.Services.Notification;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Notification
{
    public class NotificationApiController : AuthTokenApiController
    {
        private readonly INotificationService _notificationService;

        public NotificationApiController(INotificationService notificationService)
        {
            _notificationService = notificationService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetNotifications)]
        public JsonResult<BtrakJsonResult> GetNotifications(NotificationSearchModel notificationSearchModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get notifications", "notificationSearchModel", notificationSearchModel, "GetNotifications Api"));
                if (notificationSearchModel == null)
                {
                    notificationSearchModel = new NotificationSearchModel();
                }

                LoggingManager.Info("Getting notifications list");

                List<NotificationsOutputModel> notificationsList = _notificationService.GetNotifications(notificationSearchModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get notifications", "GetNotifications Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get notifications", "GetNotifications Api"));
                return Json(new BtrakJsonResult { Data = notificationsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetNotifications)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        //[Route(RouteConstants.UpsertUserNotificationRead)]
        [Route(RouteConstants.UpsertReadNewNotifications)]
        public JsonResult<BtrakJsonResult> UpsertUserNotificationRead(List<NotificationsOutputModel> userNotificationReads)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertUserNotificationRead", "Notification Service and logged details=" + LoggedInContext));
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            ///
            var notificationdIds = userNotificationReads.Select(p => p.Id).ToList();
            
            var result = _notificationService.UpsertUserNotificationRead(notificationdIds, DateTime.UtcNow,null,LoggedInContext, validationMessages);

            if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
            {
                validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get notifications", "GetNotifications Api"));
                return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get notifications", "GetNotifications Api"));
            return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
        }

        //[HttpPost]
        //[HttpOptions]
        //[Route(RouteConstants.UpsertReadNewNotifications)]
        //public List<Guid?> UpsertReadNewNotifications(List<NotificationsOutputModel> userNotificationReads)
        //{
        //    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertUserNotificationRead", "Notification Service and logged details=" + LoggedInContext));
        //    var validationMessages = new List<ValidationMessage>();
        //    //TODO:[UserNotificationRead] - to be stamped after the user reads the notifciation
        //    ///userNotificationRead.ReadDateTime = DateTime.UtcNow;
        //    ///
        //    var notificationdIds = userNotificationReads.Select(p => p.NotificationId).ToList();

        //    var result = _notificationService.UpsertUserNotificationRead(notificationdIds, DateTime.UtcNow, null, LoggedInContext, validationMessages);

        //    return result;
        //}
    }
}