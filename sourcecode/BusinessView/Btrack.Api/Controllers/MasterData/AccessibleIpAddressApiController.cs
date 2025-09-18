using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Services.MasterData;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.MasterData
{
    public class AccessibleIpAddressApiController : AuthTokenApiController
    {
        private readonly IAccessibleIpAddressService _accessibleIpAddressService;

        public AccessibleIpAddressApiController(IAccessibleIpAddressService accessibleIpAddressService)
        {
            _accessibleIpAddressService = accessibleIpAddressService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAccessibleIpAddresses)]
        public JsonResult<BtrakJsonResult> UpsertAccessibleIpAddresses(AccessibleIpAddressUpsertModel accessibleIpAddressUpsertModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert accessible ip address", "accessibleIpAddressUpsertModel", accessibleIpAddressUpsertModel, "accessible ip address Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? ipAddressId = _accessibleIpAddressService.UpsertAccessibleIpAddresses(accessibleIpAddressUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert accessible ip address", "UpsertAccessibleIpAddress Api "));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert accessible id address", "UpsertAccessibleIpAddress Api"));

                return Json(new BtrakJsonResult { Data = ipAddressId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAccessibleIpAddresses", "AccessibleIpAddressApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}