using Btrak.Models;
using Btrak.Models.GRD;
using Btrak.Services.GRD;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.GRD
{
    public class GRDApiController : AuthTokenApiController
    {
        private readonly IGRDService _gRDService;
        public GRDApiController(IGRDService gRDService)
        {
            _gRDService = gRDService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertGRD)]
        public JsonResult<BtrakJsonResult> UpsertGRD(GRDInputModel grdInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGRD", "grdInput", grdInputModel, "GRD Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? grdId = _gRDService.UpsertGRD(grdInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GRD Upsert is completed. Return Guid is " + grdId + ", source command is " + grdInputModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertGRD", "GRD Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertGRD", "GRD Api"));
                return Json(new BtrakJsonResult { Data = grdId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGRD", "GRDApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetGRD)]
        public JsonResult<BtrakJsonResult> GetGRD(GRDSearchInputModel grdInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetGRD", "grdInput", grdInput, "GRD Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<GRDSearchOutputModel> grdList = _gRDService.GetGRD(grdInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGRD", "GRD Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGRD", "GRD Api"));
                return Json(new BtrakJsonResult { Data = grdList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGRD", "GRDApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetGRDDropDown)]
        public JsonResult<BtrakJsonResult> GetGRDDropDown(Guid? CompanyId = null)
        {
            try
            {
                GRDSearchInputModel grdInput = new GRDSearchInputModel();

                grdInput.CompanyId = CompanyId;

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetGRDDropDown", "grdInput", grdInput, "GRD Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<GRDSearchOutputModel> grdList = _gRDService.GetGRD(grdInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGRDDropDown", "GRD Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGRDDropDown", "GRD Api"));
                return Json(new BtrakJsonResult { Data = grdList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGRDDropDown", "GRDApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCreditNote)]
        public async Task<JsonResult<BtrakJsonResult>> UpsertCreditNote(CreditNoteUpsertInputModel creditNoteUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCreditNote", "creditNoteUpsertInputModel", creditNoteUpsertInputModel, "GRD Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? creditNoteId = await _gRDService.UpsertCreditNote(creditNoteUpsertInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Credit note Upsert is completed. Return Guid is " + creditNoteId + ", source command is " + creditNoteUpsertInputModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCreditNote", "GRD Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCreditNote", "GRD Api"));
                return Json(new BtrakJsonResult { Data = creditNoteId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCreditNote", "GRDApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SendCreditNoteMail)]
        public JsonResult<BtrakJsonResult> SendCreditNoteMail(CreditNoteUpsertInputModel creditNoteUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SendCreditNoteMail", "creditNoteUpsertInputModel", creditNoteUpsertInputModel, "GRD Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                string fileUrl = _gRDService.SendCreditNoteMail(creditNoteUpsertInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Credit note email is completed. Return Guid is " + fileUrl + ", source command is " + creditNoteUpsertInputModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendCreditNoteMail", "GRD Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendCreditNoteMail", "GRD Api"));
                return Json(new BtrakJsonResult { Data = fileUrl, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCreditNote", "GRDApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCreditNote)]
        public JsonResult<BtrakJsonResult> GetCreditNote(CreditNoteSearchInputModel creditNoteSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCreditNote", "grdInput", creditNoteSearchInputModel, "GRD Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<CreditNoteSearchOutputModel> creditNotes = _gRDService.GetCreditNote(creditNoteSearchInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCreditNote", "GRD Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCreditNote", "GRD Api"));
                return Json(new BtrakJsonResult { Data = creditNotes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCreditNote", "GRDApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertMasterAccount)]
        public JsonResult<BtrakJsonResult> UpsertMasterAccount(MasterAccountUpsertInputModel masterAccountUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertMasterAccount", "masterAccountUpsertInputModel", masterAccountUpsertInputModel, "GRD Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? masterAccountId = _gRDService.UpsertMasterAccount(masterAccountUpsertInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Master account Upsert is completed. Return Guid is " + masterAccountId + ", source command is " + masterAccountUpsertInputModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertMasterAccount", "GRD Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertMasterAccount", "GRD Api"));
                return Json(new BtrakJsonResult { Data = masterAccountId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMasterAccount", "GRDApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMasterAccount)]
        public JsonResult<BtrakJsonResult> GetMasterAccount(MasterAccountSearchInputModel masterAccountSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMasterAccount", "grdInput", masterAccountSearchInputModel, "GRD Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<MasterAccountSearchOutputModel> masterAccounts = _gRDService.GetMasterAccounts(masterAccountSearchInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMasterAccount", "GRD Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMasterAccount", "GRD Api"));
                return Json(new BtrakJsonResult { Data = masterAccounts, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMasterAccount", "GRDApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertExpenseBooking)]
        public JsonResult<BtrakJsonResult> UpsertExpenseBooking(ExpenseBookingUpsertInputModel expenseBookingUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertExpenseBooking", "expenseBookingUpsertInputModel", expenseBookingUpsertInputModel, "GRD Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? expenseBookingId = _gRDService.UpsertExpenseBooking(expenseBookingUpsertInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Expense booking Upsert is completed. Return Guid is " + expenseBookingId + ", source command is " + expenseBookingUpsertInputModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertExpenseBooking", "GRD Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertExpenseBooking", "GRD Api"));
                return Json(new BtrakJsonResult { Data = expenseBookingId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpenseBooking", "GRDApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetExpenseBookings)]
        public JsonResult<BtrakJsonResult> GetExpenseBookings(ExpenseBookingSearchInputModel expenseBookingSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetExpenseBookings", "expenseBookingSearchInputModel", expenseBookingSearchInputModel, "GRD Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<ExpenseBookingSearchOutputModel> masterAccounts = _gRDService.GetExpenseBookings(expenseBookingSearchInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExpenseBookings", "GRD Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExpenseBookings", "GRD Api"));
                return Json(new BtrakJsonResult { Data = masterAccounts, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExpenseBookings", "GRDApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPaymentReceipt)]
        public JsonResult<BtrakJsonResult> UpsertPaymentReceipt(PaymentReceiptUpsertInputModel paymentReceiptUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertPaymentReceipt", "paymentReceiptUpsertInputModel", paymentReceiptUpsertInputModel, "GRD Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? paymentReceiptId = _gRDService.UpsertPaymentReceipt(paymentReceiptUpsertInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Payment receipt Upsert is completed. Return Guid is " + paymentReceiptId + ", source command is " + paymentReceiptUpsertInputModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPaymentReceipt", "GRD Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPaymentReceipt", "GRD Api"));
                return Json(new BtrakJsonResult { Data = paymentReceiptId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPaymentReceipt", "GRDApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPaymentReceipts)]
        public JsonResult<BtrakJsonResult> GetPaymentReceipts(PaymentReceiptSearchInputModel paymentReceiptSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPaymentReceipts", "paymentReceiptSearchInputModel", paymentReceiptSearchInputModel, "GRD Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<PaymentReceiptSearchOutputModel> paymentReceipts = _gRDService.GetPaymentReceipts(paymentReceiptSearchInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPaymentReceipts", "GRD Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPaymentReceipts", "GRD Api"));
                return Json(new BtrakJsonResult { Data = paymentReceipts, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPaymentReceipts", "GRDApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
