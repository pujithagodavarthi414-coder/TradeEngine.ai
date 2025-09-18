using Btrak.Models;
using Btrak.Models.HrManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models.Currency;
using Btrak.Models.CurrencyConversion;
using Btrak.Models.Employee;
using Btrak.Models.PayGradeRates;
using Btrak.Models.PaymentMethod;
using Btrak.Models.RateType;
using Btrak.Models.StatusReportingConfiguration;
using Btrak.Models.HrDashboard;
using Btrak.Models.User;

namespace Btrak.Services.HrManagement
{
    public interface IHrManagementService
    {
        Guid? UpsertShiftTiming(ShiftTimingInputModel shiftTimingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeShift(EmployeeShiftInputModel employeeShiftInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertContractType(ContractTypeUpsertInputModel contractTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ContractTypeApiReturnModel> GetContractTypes(ContractTypeSearchInputModel contractTypeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ContractTypeApiReturnModel GetContractTypeById(ContractTypeSearchInputModel contractTypeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertDepartment(DepartmentUpsertInputModel departmentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DepartmentApiReturnModel> GetDepartments(DepartmentSearchInputModel departmentSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        DepartmentApiReturnModel GetDepartmentById(DepartmentSearchInputModel departmentSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCurrency(CurrencyInputModel currencyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CurrencyOutputModel> SearchCurrency(CurrencySearchCriteriaInputModel currencySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertCurrencyConversion(CurrencyConversionInputModel currencyConversionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CurrencyConversionOutputModel> GetCurrencyConversions(CurrencyConversionSearchCriteriaInputModel currencyConversionSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPaymentMethod(PaymentMethodInputModel paymentMethodInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PaymentMethodOutputModel> GetPaymentMethod(PaymentMethodSearchCriteriaInputModel paymentMethodSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertDesignation(DesignationUpsertInputModel designationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DesignationApiReturnModel> GetDesignations(DesignationSearchInputModel designationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPayGrade(PayGradeUpsertInputModel payGradeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PayGradeApiReturnModel> GetPayGrades(PayGradeSearchInputModel payGradeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertBreakType(BreakTypeUpsertInputModel breakTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<BreakTypeApiReturnModel> GetBreakTypes(BreakTypeSearchInputModel breakTypeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertRateType(RateTypeInputModel rateTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RateTypeOutputModel> SearchRateType(RateTypeSearchCriteriaInputModel rateTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PayGradeRatesOutputModel> GetPayGradeRates(PayGradeRatesSearchCriteriaInputModel payGradeRatesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertRelationShip(RelationshipUpsertModel RelationshipUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RelationShipTypeSearchCriteriaInputModel> SearchRelationShip(RelationShipTypeSearchCriteriaInputModel relationShipTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeContactDetails(EmployeeContactDetailsInputModel employeeContactDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeePersonalDetails(EmployeePersonalDetailsInputModel employeePersonalDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeLicenceDetails(EmployeeLicenceDetailsInputModel employeeLicenceDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeEmergencyContactDetails(EmployeeEmergencyContactDetailsInputModel employeeEmergencyContactDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? AssignPayGradeRates(PayGradeRatesInputModel payGradeRatesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmploymentContract(EmploymentContractInputModel employmentContractInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeJob(EmployeeJobInputModel employeeJobInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeImmigrationDetails(Models.Employee.EmployeeImmigrationDetailsInputModel employeeImmigrationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeSalaryDetails(Models.Employee.EmployeeSalaryDetailsInputModel employeeSalaryDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeReportTo(EmployeeReportToInputModel employeeReportToInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeWorkExperience(EmployeeWorkExperienceInputModel employeeWorkExperienceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeEducationDetails(Models.Employee.EmployeeEducationDetailsInputModel employeeEducationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeSkills(EmployeeSkillsInputModel employeeSkillsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeLanguages(EmployeeLanguagesInputModel employeeLanguagesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeMemberships(EmployeeMembershipUpsertInputModel employeeMembershipUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool SendUserRegistrationMail(UserRegistrationDetailsModel userRegistrationDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool GetIsHavingEmployeereportMembers( LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertEmployeeBankDetails(EmployeeBankDetailUpsertInputModel employeeBankDetailUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeBankDetailApiReturnModel> GetAllBankDetails(EmployeeBankDetailSearchInputModel employeeBankDetailSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeDependentContactModel> SearchEmployeeDependentContacts(EmployeeDependentContactSearchInputModel employeeDependentContactSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        EmployeeDetailsApiReturnModel GetEmployeeDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeOverViewDetailsOutputModel> GetEmployeeOverViewDetails(Guid? employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeLicenceDetailsApiReturnModel SearchEmployeeLicenseDetails(EmployeeLicenseDetailsInputModel getEmployeeLicenseDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeSkillDetailsApiReturnModel SearchEmployeeSkillDetails(EmployeeSkillDetailsInputModel getEmployeeSkillDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeWorkExperienceDetailsApiReturnModel SearchEmployeeWorkExperienceDetails(EmployeeWorkExperienceDetailsInputModel getEmployeeWorkExperienceDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeSalaryDetailsApiReturnModel SearchEmployeeSalaryDetails(Models.HrManagement.EmployeeSalaryDetailsInputModel getEmployeeSalaryDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeMembershipDetailsApiReturnModel SearchEmployeeMembershipDetails(EmployeeMembershipDetailsInputModel getEmployeeMembershipDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeReportToDetailsApiReturnModel SearchEmployeeReportToDetails(EmployeeReportToDetailsInputModel getEmployeeReportToDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeLanguageDetailsApiReturnModel SearchEmployeeLanguageDetails(EmployeeLanguageDetailsInputModel getEmployeeLanguageDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeImmigrationDetailsApiReturnModel SearchEmployeeImmigrationDetails(Models.HrManagement.EmployeeImmigrationDetailsInputModel getEmployeeImmigrationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeEmergencyContactDetailsApiReturnModel SearchEmployeeEmergencyContactDetails(EmployeeEmergencyDetailsDetailsInputModel getEmployeeEmergencyDetailsDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeEducationDetailsApiReturnModel SearchEmployeeEducationDetails(Models.HrManagement.EmployeeEducationDetailsInputModel getEmployeeEducationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeDependentContactModel GetEmployeeDependentContactsById(EmployeeDependentContactSearchInputModel employeeDependentContactSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmploymentContractDetailsApiReturnModel SearchEmployeeContractDetails(EmployeeContractDetailsInputModel getEmployeeContractDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TeamMemberOutputModel> GetMyTeamMembersList(SearchModel searchModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ShiftTimingsSearchOutputModel> SearchShiftTimings(ShiftTimingsSearchInputModel shiftTimingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserOutputModel> GetEmployeeReportToMembers(Guid? UserId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? GetMyEmployeeId(Guid? UserId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeDetailsOutputModel GetMyEmployeeDetails(Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ShiftWeekSearchOutputModel> GetShiftWeek(ShiftWeekSearchInputModel shiftWeekSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertShiftWeek(ShiftWeekUpsertInputModel shiftWeekUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<StatusReportingOptionsApiReturnModel> GetShiftTimingOptions(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertShiftException(ShiftExceptionUpsertInputModel shiftExceptionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ShiftExceptionSearchOutputModel> GetShiftException(ShiftExceptionSearchInputModel shiftExceptionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeShiftSearchOutputModel> GetEmployeeShift(EmployeeShiftSearchInputModel employeeShiftSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertWebHook(WebHookUpsertInputModel webhookUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<WebHookApiReturnModel> GetWebHooks(WebHookSearchInputModel webhookSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        WebHookApiReturnModel GetWebHookById(WebHookSearchInputModel webhookSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertHtmlTemplate(HtmlTemplateUpsertInputModel htmlTemplateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<HtmlTemplateApiReturnModel> GetHtmlTemplates(HtmlTemplateSearchInputModel htmlTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        HtmlTemplateApiReturnModel GetHtmlTemplateById(HtmlTemplateSearchInputModel htmlTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DocumentTemplateModel> GetDocumentTemplates(DocumentTemplateModel documentTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeReportDetailsModel GenerateReportForanEmployee(DocumentTemplateModel documentTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertDocumentTemplate(DocumentTemplateModel documentTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? InsertEmployeeRatesheetDetails(EmployeeRateSheetDetailsAddInputModel employeeRateSheetDetailsAddInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateEmployeeRatesheetDetails(EmployeeRatesheetDetailsEditInputModel employeeRatesheetDetailsEditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeRateSheetDetailsApiReturnModel SearchEmployeeRateSheetDetails(Models.HrManagement.EmployeeRateSheetDetailsInputModel employeeRateSheetDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertBadge(BadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<BadgeModel> GetBadges(BadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? AssignBadgeToEmployee(EmployeeBadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeBadgeModel> GetBadgesAssignedToEmployee(EmployeeBadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertAnnouncement(AnnouncementModel announcementModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AnnouncementModel> GetAnnouncements(AnnouncementModel announcementModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertReminder(ReminderModel reminder, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ReminderModel> GetReminders(ReminderModel reminder, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        void EmployeeUpload(List<EmployeePersonalDetailsInputModel> employeePersonalDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertGrade(GradeInputModel gradeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetGradesOutputModel> GetGrades(GetGradesInputModel getGradesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeGrade(EmployeeGradeInputModel employeeGradeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeGradeApiOutputModel> GetEmployeeGrades(EmployeeGradeSearchInputModel employeeGradeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeDetailsHistoryApiReturnModel> GetEmployeeDetailsHistory(EmployeeDetailsHistoryApiInputModel employeeDetailsHistoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void CheckDailyReminders();

        bool UpdateUnreadAnnouncements(AnnouncementReadInputModel announcementReadInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AnnouncementModel> GetUnreadAnnouncements(AnnouncementModel announcementModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ReadAndUnReadUsersOfAnnouncementApiReturnModel> GetReadAndUnReadUsersOfAnnouncement(Guid? AnnouncementId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeListApiOutputModel> GetEmployeesByRoleId(string roleIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int GetActiveUsersCount(Guid? loggedInUserId, List<ValidationMessage> validationMessages);
    }
}
