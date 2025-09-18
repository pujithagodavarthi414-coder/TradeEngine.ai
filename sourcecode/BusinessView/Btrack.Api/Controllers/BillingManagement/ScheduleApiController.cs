using Btrak.Models;
using Btrak.Models.BillingManagement;
using Btrak.Services.BillingManagement;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.BillingManagement
{
    public class ScheduleApiController : AuthTokenApiController
    {
        private readonly IScheduleService _scheduleService;

        public ScheduleApiController(IScheduleService scheduleService)
        {
            _scheduleService = scheduleService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertInvoiceSchedule)]
        public JsonResult<BtrakJsonResult> UpsertInvoiceSchedule(UpsertInvoiceScheduleInputModel upsertInvoiceScheduleInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInvoiceSchedule", "Schedule Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (upsertInvoiceScheduleInputModel == null)
                {
                    upsertInvoiceScheduleInputModel = new UpsertInvoiceScheduleInputModel();
                }

                Guid? scheduleId = _scheduleService.UpsertInvoiceSchedule(upsertInvoiceScheduleInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInvoiceSchedule", "Schedule Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInvoiceSchedule", "Schedule Api"));
                return Json(new BtrakJsonResult { Data = scheduleId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertInvoiceSchedule", "ScheduleApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(ValidationMessages.ExceptionUpsertInvoiceSchedule), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInvoiceSchedules)]
        public JsonResult<BtrakJsonResult> GetInvoiceSchedules(ScheduleInputModel scheduleInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get all invoice schedules", "Schedule Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (scheduleInputModel == null)
                {
                    scheduleInputModel = new ScheduleInputModel();
                }

                List<ScheduleOutputModel> schedules = _scheduleService.GetInvoiceSchedules(scheduleInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get all invoice schedules", "Schedule Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get all invoice schedules", "Schedule Api"));
                return Json(new BtrakJsonResult { Data = schedules, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceSchedules", "ScheduleApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetInvoiceSchedules), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetScheduleTypes)]
        public JsonResult<BtrakJsonResult> GetScheduleTypes(ScheduleTypeInputModel scheduleTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get all scheduletypes", "Schedule Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (scheduleTypeInputModel == null)
                {
                    scheduleTypeInputModel = new ScheduleTypeInputModel();
                }

                List<ScheduleTypeOutputModel> scheduleTypes = _scheduleService.GetScheduleTypes(scheduleTypeInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get all scheduletypes", "Schedule Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get all scheduletypes", "Schedule Api"));
                return Json(new BtrakJsonResult { Data = scheduleTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetScheduleTypes", "ScheduleApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetScheduleTypes), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetScheduleSequence)]
        public JsonResult<BtrakJsonResult> GetScheduleSequence(ScheduleSequenceInputModel scheduleSequenceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetScheduleSequence", "Schedule Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (scheduleSequenceInputModel == null)
                {
                    scheduleSequenceInputModel = new ScheduleSequenceInputModel();
                }

                List<ScheduleSequenceOutputModel> scheduleSequences = _scheduleService.GetScheduleSequence(scheduleSequenceInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetScheduleSequence", "Schedule Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetScheduleSequence", "Schedule Api"));
                return Json(new BtrakJsonResult { Data = scheduleSequences, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetScheduleSequence", "ScheduleApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetScheduleSequences), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
