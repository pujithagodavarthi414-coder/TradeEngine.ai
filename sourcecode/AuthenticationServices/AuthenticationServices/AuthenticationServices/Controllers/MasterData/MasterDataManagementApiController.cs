using AuthenticationServices.Api.Controllers.Api;
using AuthenticationServices.Api.Helpers;
using AuthenticationServices.Api.Models;
using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.MasterData;
using AuthenticationServices.Models.User;
using AuthenticationServices.Services.MasterData;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;

namespace AuthenticationServices.Api.Controllers.MasterData
{
    [ApiController]
    public class MasterDataManagementApiController : AuthTokenApiController
    {
        private readonly IMasterDataManagementService _masterDataManagementService;
        IConfiguration _iconfiguration;
        public MasterDataManagementApiController(IMasterDataManagementService masterDataManagementService, IConfiguration iconfiguration)
        {
            _masterDataManagementService = masterDataManagementService;
            _iconfiguration = iconfiguration;
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCompanySettingsDetails)]
        public JsonResult GetCompanysettingsDetails(Guid? companySettingsId, string key, string description, string value, string searchText, bool? isArchived, bool? isSystemApp, bool? isFromExport)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompanySettingsDetails", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                CompanySettingsSearchInputModel companySettingsSearchInputModel = new CompanySettingsSearchInputModel()
                {
                    CompanySettingsId = companySettingsId,
                    Key = key,
                    Description = description,
                    Value = value,
                    SearchText = searchText,
                    IsArchived = isArchived,
                    IsSystemApp = isSystemApp,
                    IsFromExport = isFromExport
                };

                List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementService.GetCompanySettings(companySettingsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanySettingsDetails", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanySettingsDetails", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = companySettings, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanysettingsDetails", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompanysettings)]
        public JsonResult UpsertCompanySettings(CompanySettingsUpsertInputModel companySettingsUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAppSetting", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? companySettingsId = _masterDataManagementService.UpsertCompanySettings(companySettingsUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanySetting", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanySetting", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = companySettingsId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanySettings", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompanyLogo)]
        public JsonResult UpsertCompanyLogo(UploadProfileImageInputModel uploadProfileImageInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAppSetting", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                string companySettingsId = _masterDataManagementService.UpsertCompanyLogo(uploadProfileImageInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanySetting", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanySetting", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = companySettingsId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyLogo", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }
    }
}
