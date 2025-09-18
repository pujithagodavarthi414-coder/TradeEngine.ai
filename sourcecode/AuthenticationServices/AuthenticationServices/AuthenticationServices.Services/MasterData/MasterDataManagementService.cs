using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.MasterData;
using AuthenticationServices.Models.User;
using AuthenticationServices.Repositories.Repositories.MasterDataManagement;
using AuthenticationServices.Services.Helpers;
using AuthenticationServices.Services.Helpers.MasterDataValidationHelper;
using System;
using System.Collections.Generic;

namespace AuthenticationServices.Services.MasterData
{
    public class MasterDataManagementService : IMasterDataManagementService
    {
        private readonly IMasterDataManagementRepository _masterDataManagementRepository;
        
        public MasterDataManagementService(IMasterDataManagementRepository masterDataManagementRepository)
        {
            _masterDataManagementRepository = masterDataManagementRepository;
        }
        public List<CompanySettingsSearchOutputModel> GetCompanySettings(CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompanySettings", "MasterDataManagement Service"));
            LoggingManager.Debug(companySettingsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages);
            return companySettings;
        }

        public Guid? UpsertCompanySettings(CompanySettingsUpsertInputModel companySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Company Settings", "MasterDataManagement Service"));

            LoggingManager.Debug(companySettingsUpsertInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertCompanySettingsValidation(companySettingsUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            companySettingsUpsertInputModel.CompanySettingsId = _masterDataManagementRepository.UpsertCompanySettings(companySettingsUpsertInputModel, loggedInContext, validationMessages);
            return companySettingsUpsertInputModel.CompanySettingsId;
        }

        public string UpsertCompanyLogo(UploadProfileImageInputModel uploadProfileImageInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Company Settings", "MasterDataManagement Service"));

            LoggingManager.Debug(uploadProfileImageInputModel.ToString());

            uploadProfileImageInputModel.ProfileImage = _masterDataManagementRepository.UpsertCompanyLogo(uploadProfileImageInputModel, loggedInContext, validationMessages);

            return uploadProfileImageInputModel.ProfileImage;
        }
    }
}
