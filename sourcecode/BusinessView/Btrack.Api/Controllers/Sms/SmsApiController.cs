using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Text;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Crm.Sms;
using Btrak.Services.SMS;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;


namespace BTrak.Api.Controllers.Sms
{
    public class SmsApiController : AuthTokenApiController
    {
        private readonly ISmsService _smsService;

        public SmsApiController(ISmsService smsService)
        {
            _smsService = smsService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertSmsTemplate)]
        public JsonResult<BtrakJsonResult> UpsertSmsTemplate(SmsTemplateInputModel smsTemplateInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSmsTemplate", "SMS Api") + " " + smsTemplateInputModel);

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? commentIdIdReturned = _smsService.UpsertSmsTemplate(smsTemplateInputModel, LoggedInContext, validationMessages);

                LoggingManager.Info("Sms Template Upsert is completed. Return Guid is " + commentIdIdReturned + ", source command is " + smsTemplateInputModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSmsTemplate", "SMS Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSmsTemplate", "SMS Api"));
                return Json(new BtrakJsonResult { Data = commentIdIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSmsTemplate", "SmsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchSmsTemplate)]
        public JsonResult<BtrakJsonResult> SearchSmsTemplate(SmsTemplateSearchTemplateInputModel smsTemplateSearchTemplateInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchSmsTemplate", "SMS Api") + " " + smsTemplateSearchTemplateInputModel);

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<SmsTemplateOutputModel> templates = _smsService.SearchSmsTemplate(smsTemplateSearchTemplateInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchSmsTemplate", "SMS Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchSmsTemplate", "SMS Api"));
                return Json(new BtrakJsonResult { Data = templates, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSmsTemplate", "SmsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetSmsTemplateById)]
        public JsonResult<BtrakJsonResult> GetSmsTemplateById(SmsTemplateSearchTemplateInputModel smsTemplateSearchTemplateInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSmsTemplateById", "SMS Api") + " " + smsTemplateSearchTemplateInputModel);

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                SmsTemplateOutputModel templates = _smsService.GetSmsTemplateById(smsTemplateSearchTemplateInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSmsTemplateById", "SMS Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSmsTemplateById", "SMS Api"));
                return Json(new BtrakJsonResult { Data = templates, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSmsTemplateById", "SmsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SendMessage)]
        public JsonResult<BtrakJsonResult> SendMessage(SendSmsInputModel sendSmsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendMessage", "SMS Api") + " " + sendSmsInputModel);

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if(sendSmsInputModel.IsOtp)
                {
                    _smsService.SendOTP(sendSmsInputModel, LoggedInContext, validationMessages);
                }
                else
                {
                    _smsService.SendMessage(sendSmsInputModel, LoggedInContext, validationMessages);
                }
                Guid? mesageSentid = _smsService.SendMessage(sendSmsInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendMessage", "SMS Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendMessage", "SMS Api"));
                return Json(new BtrakJsonResult { Data = mesageSentid, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendMessage", "SmsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SendOTP)]
        public JsonResult<BtrakJsonResult> SendOTP(SendSmsInputModel sendSmsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendOTP", "SMS Api") + " " + sendSmsInputModel);

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                object smsResponse = _smsService.SendOTP(sendSmsInputModel, LoggedInContext, validationMessages);
                
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendOTP", "SMS Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendOTP", "SMS Api"));
                return Json(new BtrakJsonResult { Data = smsResponse, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendOTP", "SmsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ValidateOTP)]
        public JsonResult<BtrakJsonResult> ValidateOTP(SendSmsInputModel sendSmsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateOtp", "SMS Api") + " " + sendSmsInputModel);

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                object mesageSent = _smsService.ValidateOTP(sendSmsInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ValidateOtp", "SMS Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ValidateOtp", "SMS Api"));
                return Json(new BtrakJsonResult { Data = mesageSent, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateOtp", "SmsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

    }
}