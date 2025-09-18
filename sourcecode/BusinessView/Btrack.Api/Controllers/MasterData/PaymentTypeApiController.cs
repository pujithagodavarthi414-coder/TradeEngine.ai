using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Services.MasterData;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.MasterData
{
    public class PaymentTypeApiController : AuthTokenApiController
    {
        private readonly PaymentTypeService _paymentTypeService;
        private readonly LeaveStatusService _leaveStatusService;

        public PaymentTypeApiController(PaymentTypeService paymentTypeService,LeaveStatusService leaveStatusService)
        {
            _paymentTypeService = paymentTypeService;
            _leaveStatusService = leaveStatusService;
        }

      
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPaymentType)]
        public JsonResult<BtrakJsonResult> UpsertPaymentType(PaymentTypeUpsertModel paymentTypeUpsertModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert payment  Type", "paymentTypeUpsertModel", paymentTypeUpsertModel, "Payment type MasterData Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? paymentTypeIdReturned = _paymentTypeService.UpsertPaymentType(paymentTypeUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert payment  Type", "Payment type MasterData Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert payment Type", "Payment type MasterData Api"));

                return Json(new BtrakJsonResult { Data = paymentTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPaymentType", "PaymentTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPaymentTypes)]
        public JsonResult<BtrakJsonResult> GetPaymentTypes(GetPaymentTypeSearchCriteriaInputModel getPaymentTypeSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPaymentTypes", "getPaymentTypesSearchCriteriaInputModel", getPaymentTypeSearchCriteriaInputModel, "payment type MasterData Api"));
                if (getPaymentTypeSearchCriteriaInputModel == null)
                {
                    getPaymentTypeSearchCriteriaInputModel = new GetPaymentTypeSearchCriteriaInputModel();
                }
                LoggingManager.Info("Getting payment Type list");
                List<GetPaymentTypeOutputModel> paymentTypesList = _paymentTypeService.GetPaymentTypes(getPaymentTypeSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get payment Type", "payment type MasterData Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get payment Type", "payment type MasterData Api"));
                return Json(new BtrakJsonResult { Data = paymentTypesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetPaymentTypes)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLeaveStatus)]
        public JsonResult<BtrakJsonResult> GetLeaveStatus(GetLeavestatusSearchCriteriaInputModel getLeavestatusSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get leave status", "getLeavestatusSearchCriteriaInputModel", getLeavestatusSearchCriteriaInputModel, "leave status MasterData Api"));
                if (getLeavestatusSearchCriteriaInputModel == null)
                {
                    getLeavestatusSearchCriteriaInputModel = new GetLeavestatusSearchCriteriaInputModel();
                }
                LoggingManager.Info("Getting leave status list");
                List<GetLeaveStatusOutputModel> leaveStatusList = _leaveStatusService.GetLeaveStatus(getLeavestatusSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Leave status", "leave status MasterData Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Leave status", "leave status MasterData Api"));
                return Json(new BtrakJsonResult { Data = leaveStatusList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetLeaveStatus)
                });

                return null;
            }
        }
    }
}