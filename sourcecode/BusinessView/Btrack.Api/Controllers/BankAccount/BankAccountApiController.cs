using Btrak.Models;
using Btrak.Models.BankAccount;
using Btrak.Services.BankAccount;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.BankAccount
{
    public class BankAccountApiController : AuthTokenApiController
    {
        private readonly IBankAccountService _bankAccountService;
        public BankAccountApiController(IBankAccountService bankAccountService)
        {
            _bankAccountService = bankAccountService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertBankAccount)]
        public JsonResult<BtrakJsonResult> UpsertBankAccount(BankAccountInputModel bankAccountInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertBankAccount", "grdInput", bankAccountInputModel, "BankAccountApiController"));
                List <ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? bankAccountId = _bankAccountService.UpsertBankAccount(bankAccountInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Bank Account Upsert is completed. Return Guid is " + bankAccountId + ", source command is " + bankAccountInputModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBankAccount", "BankAccountApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBankAccount", "BankAccountApiController"));
                return Json(new BtrakJsonResult { Data = bankAccountId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBankAccount", "BankAccountApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetBankAccount)]
        public JsonResult<BtrakJsonResult> GetBankAccount(BankAccountSearchInputModel bankAccountSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetBankAccount", "bankAccountSearchInputModel", bankAccountSearchInputModel, "BankAccountApiController"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<BankAccountSearchOutputModel> bankAccountList = _bankAccountService.GetBankAccount(bankAccountSearchInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBankAccount", "BankAccountApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBankAccount", "BankAccountApiController"));
                return Json(new BtrakJsonResult { Data = bankAccountList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBankAccount", "BankAccountApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}