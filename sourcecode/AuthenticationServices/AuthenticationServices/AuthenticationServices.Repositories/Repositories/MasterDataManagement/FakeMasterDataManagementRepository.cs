using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.MasterData;
using AuthenticationServices.Models.User;
using System;
using System.Collections.Generic;

namespace AuthenticationServices.Repositories.Repositories.MasterDataManagement
{
    public class FakeMasterDataManagementRepository : IMasterDataManagementRepository
    {
        public Guid? UpsertCompanySettings(CompanySettingsUpsertInputModel companySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return null;
        }

        public List<CompanySettingsSearchOutputModel> GetCompanySettings(CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new List<CompanySettingsSearchOutputModel>();
        }

        public string UpsertCompanyLogo(UploadProfileImageInputModel uploadProfileImageInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return uploadProfileImageInputModel.ProfileImage;
        }
    }
}
