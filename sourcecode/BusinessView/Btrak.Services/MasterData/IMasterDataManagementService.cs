using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using Btrak.Models.MasterData;
using Btrak.Models.User;
using Btrak.Models.SoftLabelConfigurations;
using BTrak.Common;
using Btrak.Models.PayRoll;

namespace Btrak.Services.MasterData
{
    public interface IMasterDataManagementService
    {
        string UpsertCompanyLogo(UploadProfileImageInputModel uploadProfileImageInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCompanyModule(ModuleDetailsModel moduleDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ModuleDetailsModel> GetModulesList(ModuleDetailsModel moduleDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ModuleDetailsModel> GetCompanyModulesList(ModuleDetailsModel moduleDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool? importConfiguration = false);
        Guid? UpsertEmploymentStatus(EmploymentStatusInputModel employmentStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetStatesOutputModel> GetStates(GetStatesSearchCriteriaInputModel getStatesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetLicenceTypesOutputModel> GetLicenceTypes(GetLicenceTypesSearchCriteriaInputModel getLicenceTypesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<NationalityApiReturnModel> GetNationalities(NationalitySearchInputModel nationalitySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmploymentStatusOutputModel> GetEmploymentStatus(EmploymentStatusSearchCriteriaInputModel getEmploymentStatusSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ReportingMethodsOutputModel> GetReportingMethods(ReportingMethodsSearchCriteriaInputModel getReportingMethodsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PayFrequencyOutputModel> GetPayFrequency(PayFrequencySearchCriteriaInputModel payFrequencySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EducationLevelsOutputModel> GetEducationLevels(EducationLevelSearchInputModel educationLevelSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SkillsOutputModel> GetSkills(SkillsSearchCriteriaInputModel skillsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertSkills(SkillsInputModel skillsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CompetenciesOutputModel> GetCompetencies(GetCompetenciesSearchCriteriaInputModel getCompetenciesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LanguageFluenciesOutputModel> GetLanguageFluencies(GetLanguageFluenciesSearchCriteriaInputModel getLanguageFluenciesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LanguagesOutputModel> GetLanguages(GetLanguagesSearchCriteriaInputModel getLanguagesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertSubscriptionPaidByOption(SubscriptionPaidByUpsertInputModel subscriptionPaidByUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SubscriptionPaidByApiReturnModel> GetSubscriptionPaidByOptions(SubscriptionPaidBySearchCriteriaInputModel subscriptionPaidBySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<MembershipApiReturnModel> GetMemberships(MembershipSearchCriteriaInputModel membershipSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTimeFormat(TimeFormatInputModel timeFormatInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertDateFormat(DateFormatInputModel dateFormatInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertMainUseCase(MainUseCaseInputModel mainUseCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetAccessibleIpAddressesOutputModel> GetAccessibleIpAddresses(GetAccessibleIpAddressesSearchCriteriaInputModel getAccessibleIpAddressesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<GetScriptsOutputModel> GetScripts(GetScriptsInputModel getScriptsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        byte[] Scripts(string scriptName, string version, List<ValidationMessage> validationMessages);

        string GetScriptPath(string scriptName, string version, List<ValidationMessage> validationMessages);

        Guid? UpsertScript(GetScriptsInputModel scriptsInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);

        void DeleteScript(Guid scriptId, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);

        Guid? UpsertNumberFormat(NumberFormatInputModel numberFormatInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCompanyIntroducedByOption(CompanyIntroducedByOptionInputModel companyIntroducedByOptionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertState(StateInputModel stateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertReferenceType(ReferenceTypeInputModel referenceTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ReferenceTypeOutputModel> GetReferenceTypes(ReferenceTypeSearchCriteriaInputModel referenceTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertLicenseType(LicenseTypeInputModel licenseTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetAllNationalitiesOutputModel> GetAllNationalities(GetAllNationalitiesSearchCriteriaInputModel getAllNationalitiesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GendersOutputModel> GetGenders(GendersSearchCriteriaInputModel gendersSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<MaritalStatusesOutputModel> GetMaritalStatuses(MaritalStatusesSearchCriteriaInputModel maritalStatusesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertHoliday(HolidayInputModel holidayInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<HolidaysOutputModel> GetHolidays(HolidaySearchCriteriaInputModel holidaySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEducationLevel(EducationLevelUpsertModel educationLevelUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertReportingMethod(ReportingMethodUpsertModel reportingMethodUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertMembership(MembershipUpsertModel membershipUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPayFrequency(PayFrequencyUpsertModel payFrequencyUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertLanguage(LanguageUpsertModel languageUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertNationality(NationalityUpsertModel nationalityUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertJobCategories(JobCategoriesUpsertModel jobCategoriesUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<JobCategorySearchOutputModel> SearchJobCategoryDetails(JobCategorySearchInputModel jobCategorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EducationLevelsDropDownOutputModel> GetEducationLevelsDropDown(string searchText,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AppSettingsOutputModel> GetAppsettings(Appsettings appSettingSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertAppSettings(AppSettingsUpsertInputModel appSettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CompanySettingsSearchOutputModel> GetCompanySettings(CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool? importConfiguration = false);
        UsersInitialDataModel GetUsersInitialData(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCompanySettings(CompanySettingsUpsertInputModel companySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeaveFrequencySearchOutputModel> GetLeaveFrequencies(LeaveFrequencySearchInputModel leaveFrequencySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertLeaveFrequency(LeaveFrequencyUpsertInputModel leaveFrequencyUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeaveFormulSearchOutputModel> GetLeaveFormula(LeaveFormulaSearchInputModel leaveFormulaSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertLeaveFormula(LeaveFormulaUpsertInputModel leaveFormulaUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EncashmentTypeSearchOutputModel> GetEncashmentTypes(SearchCriteriaInputModelBase searchCriteriaInputModelBase, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RestrictionTypeSearchOutputModel> GetRestrictionTypes(RestrictionTypeSearchInputModel restrictionTypeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertRestrictionType(RestrictionTypeUpsertInputModel restrictionTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStoryTypeDropDownOutputModel> GetUserStoryTypeDropDown(bool? isArchived, string searchText,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool GetCompanyWorkItemStartFunctionalityRequired(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    List<SoftLabelApiReturnModel> GetSoftLabelsConfigurationsList(SoftLabelsSearchInputModel SoftLabelsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertSoftLabelConfigurations(UpsertSoftLabelConfigurationsModel softLabelUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        SoftLabelApiReturnModel GetSoftLabelById(Guid? softLabelId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<RateSheetOutputModel> GetRateSheets(RateSheetSearchCriteriaInputModel rateSheetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RateSheetForOutputModel> GetRateSheetForNames(RateSheetForSearchCriteriaInputModel rateSheetForSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertRateSheet(RateSheetInputModel rateSheetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PeakHourOutputModel> GetPeakHours(PeakHourSearchCriteriaInputModel peakHourSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPeakHour(PeakHourInputModel peakHourInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<WeekdayOutputModel> GetWeekdays(WeekdaySearchCriteriaInputModel weekdaySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProfessionalTaxRange> GetProfessionalTaxRanges(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertProfessionalTaxRanges(ProfessionalTaxRange professionalTaxRange, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TaxSlabs> GetTaxSlabs(TaxSlabs taxSlabs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTaxSlabs(TaxSlabsUpsertInputModel taxSlabs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool GetAddOrEditCustomAppIsRequired(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertSpecificDay(SpecificDayInputModel holidayInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SpecificDayOutPutModel> GetSpecificDays(SpecificDaySearchCriteriaInputModel holidaySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        DocumentSettingsSearchOutputModel GetDocumentStorageSettings(CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CompanyHierarchyModel> GetCompanyHierarchicalStructure(CompanyHierarchyModel companyHierarchyModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCompanyStructure(CompanyHierarchyModel companyHierarchyModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string SearchEntities(Guid? entityId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertBusinessUnit(BusinessUnitModel businessUnitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string SearchBusinessUnits(BusinessUnitModel businessUnitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<BusinessUnitDropDownModel> GetBusinessUnitDropDown(BusinessUnitDropDownModel businessUnitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
