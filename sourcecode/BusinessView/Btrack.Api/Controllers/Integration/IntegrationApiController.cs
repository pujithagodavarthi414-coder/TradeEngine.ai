using Btrak.Services.Integration;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models.Integration;
using Btrak.Models;

namespace BTrak.Api.Controllers.Integration
{
    public class IntegrationApiController : Api.AuthTokenApiController
    {
        private readonly IIntegrationService _integrationService;

        public IntegrationApiController(IIntegrationService integrationService)
        {
            this._integrationService = integrationService;
        }

        #region CheckIntegrationDetails
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CheckIntegrationDetails)]
        public JsonResult<BtrakSlackJsonResult> CheckIntegrationDetails(IntegrationDetailsModel integrationDetailsModel)
        {
            try
            {
                LoggingManager.Info("Entered into CheckIntegrationDetails");

                bool result = _integrationService.ValidateIntegrationDetails(integrationDetailsModel, LoggedInContext);

                LoggingManager.Info("Exit from CheckIntegrationDetails");
                return Json(new BtrakSlackJsonResult { Success = true, Data = result }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckIntegrationDetails", "IntegrationApiController", exception.Message), exception);
                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region GetUserWork
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetUserWork)]
        public JsonResult<BtrakSlackJsonResult> GetUserWork(Guid? integrationTypeId)
        {
            try
            {
                LoggingManager.Info("Entered into GetUserWork");

                var validationMessages = new List<ValidationMessage>();

                List<MyWorkDetailsModel> myWorkDetails = _integrationService.GetUserWorkItems(integrationTypeId, loggedInContext: LoggedInContext, validationMessages: validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out BtrakJsonResult btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserWork", "Integration Api"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserWork", "Integration Api"));

                return Json(new BtrakSlackJsonResult { Success = true, Data = myWorkDetails }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserWork", "IntegrationApiController", exception.Message), exception);
                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region AddWorkLogTime
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.AddWorkLogTime)]
        public JsonResult<BtrakSlackJsonResult> AddWorkLogTime(WorkLogTimeInputModel workLogTimeInputModel)
        {
            try
            {
                LoggingManager.Info("Entered into GetUserWork");

                bool result = _integrationService.AddWorkLogTime(workLogTimeInputModel,LoggedInContext);

                LoggingManager.Info("Exit from GetUserWork");
                return Json(new BtrakSlackJsonResult { Success = true, Data = result }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserWork", "IntegrationApiController", exception.Message), exception);
                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion
        #region GetIntegrationTypes
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetIntegrationTypes)]
        public JsonResult<BtrakJsonResult> GetIntegrationTypes()
        {
            try
            {
                LoggingManager.Info("Entered into GetIntegrationTypes");
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<IntegrationTypesDetailsModel> result = _integrationService.GetIntegrationTypes(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIntegrationTypes", "IntegrationApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info("Exit from GetIntegrationTypes");
                return Json(new BtrakJsonResult { Success = true, Data = result }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIntegrationTypes", "IntegrationApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion
        #region GetUserIntegrationTypes
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetUserIntegrationTypes)]
        public JsonResult<BtrakJsonResult> GetUserIntegrationTypes()
        {
            try
            {
                LoggingManager.Info("Entered into GetUserIntegrationTypes");
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<IntegrationTypesDetailsModel> result = _integrationService.GetUserIntegrationTypes(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserIntegrationTypes", "IntegrationApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info("Exit from GetUserIntegrationTypes");
                return Json(new BtrakJsonResult { Success = true, Data = result }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserIntegrations", "IntegrationApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion
        #region GetCompanyIntegrationTypes
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCompanyIntegrationTypes)]
        public JsonResult<BtrakJsonResult> GetCompanyIntegrationTypes()
        {
            try
            {
                LoggingManager.Info("Entered into GetCompanyIntegrationTypes");
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<IntegrationTypesDetailsModel> result = _integrationService.GetCompanyIntegrationTypes(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyIntegrationTypes", "IntegrationApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info("Exit from GetCompanyIntegrationTypes");
                return Json(new BtrakJsonResult { Success = true, Data = result }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyIntegrationTypes", "IntegrationApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion

        #region GetCompanyLevelIntrgrations
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCompanyLevelIntrgrations)]
        public JsonResult<BtrakJsonResult> GetCompanyLevelIntrgrations(CompanyLevelIntegrationsInputModel companyLevelIntegrationsInputModel)
        {
            try
            {
                LoggingManager.Info("Entered into GetCompanyLevelIntrgrations");
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<CompanyOrUserLevelIntegrationDetailsModel> result = _integrationService.GetCompanyLevelIntrgrations(companyLevelIntegrationsInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyLevelIntrgrations", "IntegrationApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info("Exit from GetCompanyLevelIntrgrations");
                return Json(new BtrakJsonResult { Success = true, Data = result }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyLevelIntrgrations", "IntegrationApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion
        #region AddOrUpdateCompanyLevelIntegration
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.AddOrUpdateCompanyLevelIntegration)]
        public JsonResult<BtrakJsonResult> AddOrUpdateCompanyLevelIntegration(CompanyOrUserLevelIntegrationDetailsModel companylevelintegrationInputModel)
        {
            try
            {
                LoggingManager.Info("Entered into AddOrUpdateCompanyLevelIntegration");
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? result = _integrationService.AddOrUpdateCompanyLevelIntegration(companylevelintegrationInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AddOrUpdateCompanyLevelIntegration", "IntegrationApiController"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info("Exit from AddOrUpdateCompanyLevelIntegration");
                return Json(new BtrakJsonResult { Success = true, Data = result }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AddOrUpdateCompanyLevelIntegration", "IntegrationApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        #endregion
    }
}
