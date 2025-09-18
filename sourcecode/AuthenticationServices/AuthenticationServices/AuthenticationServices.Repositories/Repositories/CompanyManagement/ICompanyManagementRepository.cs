using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.CompanyStructure;
using AuthenticationServices.Models.HrManagement;
using AuthenticationServices.Models.MasterData;
using AuthenticationServices.Models.Modules;
using System;
using System.Collections.Generic;

namespace AuthenticationServices.Repositories.Repositories.CompanyManagement
{
    public interface ICompanyManagementRepository
    {
        List<CompanyOutputModel> SearchCompanies(CompanySearchCriteriaInputModel companySearchCriteriaInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        CompanyOutputModel GetCompanyDetails(LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);

        void InsertSentMail(EmailGenericModel emailGenericModel, LoggedInContext loggedInContext);
        int GetMailsCount(LoggedInContext loggedInContext);

        List<CompanySettingsSearchOutputModel> GetCompanySettings(
            CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);

        string GetHtmlTemplateByName(string templateName, Guid? companyId);

        List<HtmlTemplateApiReturnModel> GetHtmlTemplates(HtmlTemplateSearchInputModel htmlTemplateSearchInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        void CheckUpsertCompanyValidations(CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages);

        UpsertCompanyOutputModel UpsertCompany(CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages);
        bool UpdateCompanySettings(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpdateCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);  
        Guid? DeleteCompanyTestData(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteCompanyModule(DeleteCompanyModuleModel deleteCompanyModuleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ArchiveCompany(ArchiveCompanyInputModel archiveCompanyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CompanyStructureOutputModel> SearchCompanyStructure(CompanyStructureSearchCriteriaInputModel companyStructureSearchCriteriaInputModel, List<ValidationMessage> validationMessages);
        List<CompanyModuleOutputModel> GetCompanyModules(CompanyModuleSearchInputModel companyModuleSearchCriteriaInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertModule(ModuleUpsertInputModel moduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertModulePage(ModulePageUpsertInputModel moduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ModulePageOutputReturnModel> GetModulePages(ModulePageSearchInputModel modulePageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertModuleLayout(ModuleLayoutUpsertInputModel moduleUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ModuleLayoutOutputReturnModel> GetModuleLayouts(ModulePageSearchInputModel modulePageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ModuleOutputModel> GetModules(ModuleSearchInputModel moduleSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCompanyModules(CompanyModuleUpsertModel companyModuleUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
