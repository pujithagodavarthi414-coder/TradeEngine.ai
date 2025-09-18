using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.MasterData;
using AuthenticationServices.Models.User;
using System;
using System.Collections.Generic;

namespace AuthenticationServices.Services.MasterData
{
    public interface IMasterDataManagementService
    {
        List<CompanySettingsSearchOutputModel> GetCompanySettings(CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCompanySettings(CompanySettingsUpsertInputModel companySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpsertCompanyLogo(UploadProfileImageInputModel uploadProfileImageInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
