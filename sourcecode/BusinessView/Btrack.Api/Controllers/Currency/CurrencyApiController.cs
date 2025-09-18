using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Currency;
using Btrak.Services.Currency;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Currency
{
    public class CurrencyApiController : AuthTokenApiController
    {
        private readonly ICurrencyService _currencyService;

        public CurrencyApiController()
        {
            _currencyService = new CurrencyService();
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCurrencyList)]
        public JsonResult<BtrakJsonResult> GetCurrencyList(CurrencySearchCriteriaInputModel currencySearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get currency list", "Currency Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if(currencySearchCriteriaInputModel==null)
                {
                    currencySearchCriteriaInputModel = new CurrencySearchCriteriaInputModel();
                }

                List<CurrencyOutputModel> currencyList = _currencyService.GetCurrencyList(currencySearchCriteriaInputModel, validationMessages,LoggedInContext);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get currency list", "Currency Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get currency list", "Currency Api"));
                return Json(new BtrakJsonResult { Data = currencyList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCurrencyList", "CurrencyApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
