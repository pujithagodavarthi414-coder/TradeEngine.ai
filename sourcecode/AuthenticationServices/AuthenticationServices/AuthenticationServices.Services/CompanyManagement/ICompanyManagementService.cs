using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.CompanyStructure;
using AuthenticationServices.Models.Modules;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Services.CompanyManagement
{
    public interface ICompanyManagementService
    {
        CompanyOutputModel GetCompanyById(Guid? companyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void CheckUpsertCompanyValidations(CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages);
        UpsertCompanyOutputModel UpsertCompany(LoggedInContext loggedInContext, CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages);
        void SendCompanyInsertEmailToRegisteredEmailAddress(LoggedInContext loggedInContext, CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages);
        Guid? UpsertCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpdateCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteCompanyTestData(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CompanyOutputModel GetCompanyDetails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CompanyOutputModel> SearchCompanies(CompanySearchCriteriaInputModel companySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteCompanyModule(DeleteCompanyModuleModel deleteCompanyModuleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ArchiveCompany(ArchiveCompanyInputModel archiveCompanyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CompanyStructureOutputModel> SearchIndustries(CompanyStructureSearchCriteriaInputModel companyStructureSearchCriteriaInputModel, List<ValidationMessage> validationMessages);
        List<CompanyModuleOutputModel> GetCompanyModules(CompanyModuleSearchInputModel companyModuleSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertModule(ModuleUpsertInputModel moduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ModulePageOutputReturnModel> GetModulePages(ModulePageSearchInputModel modulePageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertModulePage(ModulePageUpsertInputModel moduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ModuleLayoutOutputReturnModel> GetModuleLayouts(ModulePageSearchInputModel modulePageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertModuleLayout(ModuleLayoutUpsertInputModel moduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ModuleOutputModel> GetModules(ModuleSearchInputModel moduleSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCompanyModule(CompanyModuleUpsertModel companyModuleUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
