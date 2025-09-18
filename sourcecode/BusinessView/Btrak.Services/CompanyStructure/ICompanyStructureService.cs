using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using BTrak.Common;

namespace Btrak.Services.CompanyStructure
{
    public interface ICompanyStructureService
    {
        List<CompanyStructureOutputModel> SearchIndustries(CompanyStructureSearchCriteriaInputModel companyStructureSearchCriteriaInputModel, List<ValidationMessage> validationMessages);
        CompanyStructureOutputModel GetIndustryById(Guid? industryId, List<ValidationMessage> validationMessages);
        List<MainUseCaseOutputModel> SearchMainUseCases(MainUseCaseSearchCriteriaInputModel mainUseCaseSearchCriteriaInputModel, List<ValidationMessage> validationMessages);
        MainUseCaseOutputModel GetMainUseCaseById(Guid? mainUseCaseId, List<ValidationMessage> validationMessages);
        Guid? UpsertIndustryModule(IndustryModuleInputModel industryModuleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<IndustryModuleOutputModel> SearchIndustryModule(IndustryModuleSearchCriteriaInputModel industryModuleSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IndustryModuleOutputModel GetIndustryModuleById(Guid? industryModuleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<NumberFormatOutputModel> SearchNumberFormats(NumberFormatSearchCriteriaInputModel numberFormatSearchCriteriaInputModel, List<ValidationMessage> validationMessages);
        NumberFormatOutputModel GetNumberFormatById(Guid? numberFormatId, List<ValidationMessage> validationMessages);
        List<DateFormatOutputModel> SearchDateFormats(DateFormatSearchCriteriaInputModel dateFormatSearchCriteriaInputModel, List<ValidationMessage> validationMessages);
        DateFormatOutputModel GetDateFormatById(Guid? dateFormatId, List<ValidationMessage> validationMessages);
        List<TimeFormatOutputModel> SearchTimeFormats(TimeFormatSearchCriteriaInputModel timeFormatSearchCriteriaInputModel, List<ValidationMessage> validationMessages);
        TimeFormatOutputModel GetTimeFormatById(Guid? timeFormatId, List<ValidationMessage> validationMessages);
        UpsertCompanyOutputModel UpsertCompany(LoggedInContext loggedInContext, CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages);
        void CheckUpsertCompanyValidations(CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages);
        List<CompanyOutputModel> SearchCompanies(CompanySearchCriteriaInputModel companySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CompanyOutputModel GetCompanyById(Guid? companyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<IntroducedByOptionsOutputModel> SearchIntroducedByOptions(IntroducedByOptionsSearchInputModel introducedByOptionsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IntroducedByOptionsOutputModel GetIntroducedByOptionById(Guid? introducedByOptionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteCompanyModule(DeleteCompanyModuleModel deleteCompanyModuleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteCompanyTestData(DeleteCompanyTestDataModel deleteCompanyTestDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CompanyThemeModel GetCompanyTheme(Guid? loggedInUserId);
        bool? IsCompanyExists(List<ValidationMessage> validationMessages);
        string SendEmailContact(SendMailInputModel sendMailInputModel1);
        string SendEmailOffer(SendMailInputModel sendMailInputModel1 , LoggedInContext loggedInContext);
        CompanyOutputModel GetCompanyDetails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpdateCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void InsertCompanyTestData(UpsertCompanyOutputModel upsertCompanyOutputModel);
        bool? UpsertCompanyConfigurationUrl(LoggedInContext loggedInContext, CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages);
        string GetCompanyConfigurationUrl(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpsertCompanySignUpDetails(CompanyInputModel registrationInputModel,List<ValidationMessage> validationMessages);
        bool SendVerificationEmail(CompanyInputModel registrationInputModel);
        bool? UpsertEmailVerifyDetails(CompanyInputModel registrationInputModel, List<ValidationMessage> validationMessages);
        bool? UpdateCompanySettings(LoggedInContext loggedInContext, CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages);

    }
}
