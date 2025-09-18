using Btrak.Models;
using Btrak.Models.Employee;
using Btrak.Models.PayRoll;
using Btrak.Models.TestRail;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Btrak.Services.PayRoll
{
    public interface IPayRollService
    {

        List<PayRollComponentSearchOutputModel> GetPayRollComponents(PayRollComponentSearchInputModel payRollComponentSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPayRollComponent(PayRollComponentUpsertInputModel payRollComponentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PayRollTemplateSearchOutputModel> GetPayRollTemplates(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        PayRollTemplateUpsertInputModel UpsertPayRollTemplate(PayRollTemplateUpsertInputModel payRollTemplateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PayRollTemplateConfigurationSearchOutputModel> GetPayRollTemplateConfigurations(PayRollTemplateConfigurationSearchInputModel PayRollTemplateConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPayRollTemplateConfiguration(PayRollTemplateConfigurationUpsertInputModel payRollTemplateConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<ResignationstausSearchOutputModel> GetResignationStatus(ResignationStatusSearchInputModel resignationStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertResignationStatus(ResignationStatusSearchInputModel resignationStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeBonus> GetEmployeesBonusDetails(Guid? employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertEmployeeBonusDetails(EmployeeBonus employeeBonus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<EmployeeOutputModel> GetEmployees(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);


        List<PayRollRoleConfigurationSearchOutputModel> GetPayRollRoleConfigurations(PayRollRoleConfigurationSearchInputModel PayRollRoleConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPayRollRoleConfiguration(PayRollRoleConfigurationUpsertInputModel payRollRoleConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PayRollBranchConfigurationSearchOutputModel> GetPayRollBranchConfigurations(PayRollBranchConfigurationSearchInputModel PayRollBranchConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPayRollBranchConfiguration(PayRollBranchConfigurationUpsertInputModel PayRollBranchConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PayRollGenderConfigurationSearchOutputModel> GetPayRollGenderConfigurations(PayRollGenderConfigurationSearchInputModel PayRollGenderConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPayRollGenderConfiguration(PayRollGenderConfigurationUpsertInputModel PayRollGenderConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PayRollMaritalStatusConfigurationSearchOutputModel> GetPayRollMaritalStatusConfigurations(PayRollMaritalStatusConfigurationSearchInputModel PayRollMaritalStatusConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPayRollMaritalStatusConfiguration(PayRollMaritalStatusConfigurationUpsertInputModel PayRollMaritalStatusConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<PayRollTemplatesForEmployee> GetEmployeesPayTemplates(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<EmployeePayRollConfiguration> GetEmployeePayrollConfiguration(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertEmployeePayrollConfiguration(EmployeePayRollConfiguration employeePayRollConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeResignationSearchOutputModel> GetEmployeesResignation(EmployeeResignationSearchInputModel employeeResignationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeResignation(EmployeeResignationSearchInputModel employeeResignationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        
        List<ComponentSearchOutPutModel> GetComponents(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<PayRollStatus> GetPayrollStatusList(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertPayrollStatus(PayRollStatus payRollStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<TaxAllowanceSearchOutputModel> GetTaxAllowances(TaxAllowanceSearchInputModel TaxAllowanceSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTaxAllowance(TaxAllowanceUpsertInputModel TaxAllowanceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TaxAllowanceTypeModel> GetTaxAllowanceTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<PayrollRun> GetPayrollRunList(bool? isArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeTaxAllowanceDetailsSearchOutputModel> GetEmployeeTaxAllowanceDetails(EmployeeTaxAllowanceDetailsSearchInputModel EmployeeTaxAllowanceDetailsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeTaxAllowanceDetails(EmployeeTaxAllowanceDetailsUpsertInputModel EmployeeTaxAllowanceDetailsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);


        List<PayrollRunEmployee> GetPayrollRunemployeeList(Guid payrollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<EmployeePayslip> GetPaySlipDetails(Guid payrollRunId, Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        string DownloadPayRollRunTemplate(Guid payrollRunId, string TemplateType, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<LeaveEncashmentSettingsSearchOutputModel> GetLeaveEncashmentSettings(LeaveEncashmentSettingsSearchInputModel LeaveEncashmentSettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertLeaveEncashmentSettings(LeaveEncashmentSettingsUpsertInputModel LeaveEncashmentSettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PayrollRunOutPutModel> InsertPayrollRun(PayrollRun payrollRun, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<EmployeeAccountDetailsSearchOutputModel> GetEmployeeAccountDetails(EmployeeAccountDetailsSearchInputModel EmployeeAccountDetailsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeAccountDetails(EmployeeAccountDetailsUpsertInputModel EmployeeAccountDetailsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FinancialYearConfigurationsSearchOutputModel> GetFinancialYearConfigurations(FinancialYearConfigurationsSearchInputModel FinancialYearConfigurationsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertFinancialYearConfigurations(FinancialYearConfigurationsUpsertInputModel FinancialYearConfigurationsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpdatePayrollRunEmployeeStatus(PayrollRunEmployee payrollRunEmployee, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpdatePayrollRunStatus(PayRollStatus payRollStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<PayRollCalculationConfigurationsSearchOutputModel> GetPayRollCalculationConfigurations(PayRollCalculationConfigurationsSearchInputModel PayRollCalculationConfigurationsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPayRollCalculationConfigurations(PayRollCalculationConfigurationsUpsertInputModel PayRollCalculationConfigurationsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeCreditorDetailsSearchOutputModel> GetEmployeeCreditorDetails(EmployeeCreditorDetailsSearchInputModel EmployeeCreditorDetailsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeCreditorDetails(EmployeeCreditorDetailsUpsertInputModel EmployeeCreditorDetailsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PeriodTypeModel> GetPeriodTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PayRollCalculationTypeModel> GetPayRollCalculationTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //List<TaxCalculationTypeModel> GetTaxCalculationTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        string RunPaymentForPayRollRun(Guid payrollRunId, string TemplateType, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PayrollRunEmployee> GetEmployeePayrollDetailsList(Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeSalaryCertificateModel GetEmployeeSalaryCertificate(Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FinancialYearTypeModel> GetFinancialYearTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<HourlyTdsConfigurationSearchOutputModel> GetHourlyTdsConfiguration(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpsertHourlyTdsConfiguration(HourlyTdsConfigurationUpsertInputModel hourlyTdsConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DaysOfWeekConfigurationOutputModel> GetDaysOfWeekConfiguration(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpsertDaysOfWeekConfiguration(UpsertDaysOfWeekConfigurationInputModel upsertDaysOfWeekConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AllowanceTimeSearchOutputModel> GetAllowanceTime(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpsertAllowanceTime(UpsertAllowanceTimeInputModel upsertAllowanceTimeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        decimal? GetPayrollRunEmployeeCount(Guid? payrollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        PdfGenerationOutputModel DownloadPaySlipPdf(Guid payrollRunId, Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        void SendEmailWithPayslip(Guid payrollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? GetStatusIdByName(string statusName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ESIMonthlyStatementOutputModel> GetESIMonthlyStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SalaryRegisterOutputModel> GetSalaryRegister(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<IncomeSalaryStatementOutputModel> GetIncomeSalaryStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProfessionTaxMonthlyStatementOutputModel> GetProfessionTaxMonthlyStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProfessionTaxReturnsOutputModel> GetProfessionTaxReturns(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<byte[]> PrintFormv(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SalaryBillRegisterOutputModel> GetSalaryBillRegister(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<IncomeSalaryStatementDetailsOutputModel> GetIncomeSalaryStatementDetails(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ITSavingsReportOutputModel> GetITSavingsReport(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<IncomeTaxMonthlyStatementOutputModel> GetIncomeTaxMonthlyStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SalaryForITOutputModel> GetSalaryforITOfAnEmployee(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<TdsSettingsSearchOutputModel> GetTdsSettings(TdsSettingsSearchInputModel TdsSettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTdsSettings(TdsSettingsUpsertInputModel TdsSettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<ContractPayTypeModel> GetContractPayTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<ContractPaySettingsSearchOutputModel> GetContractPaySettings(ContractPaySettingsSearchInputModel ContractPaySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertContractPaySettings(ContractPaySettingsUpsertInputModel ContractPaySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<PartsOfDayModel> GetPartsOfDays(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<EmployeeLoanSearchOutputModel> GetEmployeeLoans(EmployeeLoanSearchInputModel EmployeeLoanSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeLoan(EmployeeLoanUpsertInputModel EmployeeLoanUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<LoanTypeModel> GetLoanTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<EmployeeLoanInstallmentOutputModel> GetEmployeeLoanInstallment(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeLoanInstallment(EmployeeLoanInstallmentInputModel employeeLoanInstallmentInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        PayRollMonthlyDetailsModel GetPayRollMonthlyDetails(string dateOfMonth, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? FinalPayRollRun(PayrollRun payrollRun, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PayrollRunOutPutModel> GetPayRollRunEmployeeLeaveDetailsList(Guid? payRollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<EmployeeLoanInstallmentOutputModel> GetEmployeeLoanStatementDetails(Guid? employeeId, Guid? employeeloanId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPayRollRunEmployeeComponent(PayRollRunEmployeeComponentUpsertInputModel PayRollRunEmployeeComponentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RegisterOfWagesOutputModel> GetRegisterOfWages(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeESIReportOutputModel> GetEmployeeESIReport(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeePFReportOutputModel> GetEmployeePFReport(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetTakeHomeAmount(Guid? employeesalaryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetUserCountry(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<RateTagOutputModel> GetRateTags(RateTagSearchCriteriaInputModel rateSheetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RateTagForOutputModel> GetRateTagForNames(RateTagForSearchCriteriaInputModel rateSheetForSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertRateTag(RateTagInputModel rateSheetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? InsertEmployeeRateTagDetails(EmployeeRateTagDetailsAddInputModel employeeRateTagDetailsAddInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateEmployeeRateTagDetails(EmployeeRateTagDetailsEditInputModel employeeRateTagDetailsEditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeRateTagDetailsApiReturnModel SearchEmployeeRateTagDetails(EmployeeRateTagDetailsInputModel employeeRateTagDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RateTagAllowanceTimeSearchOutputModel> GetRateTagAllowanceTime(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpsertRateTagAllowanceTime(UpsertRateTagAllowanceTimeInputModel upsertRateTagAllowanceTimeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPartsOfDay(PartsOfDayUpsertInputModel PartsOfDayUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<BankModel> GetBanks(BankSearchInputModel bankSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? InsertRateTagConfigurations(RateTagConfigurationAddInputModel rateTagConfigurationAddInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateRateTagConfiguration(RateTagConfigurationEditInputModel rateTagConfigurationEditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RateTagConfigurationsApiReturnModel> GetRateTagConfigurations(RateTagConfigurationsInputModel rateTagConfigurationsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ArchivePayRoll(PayRollRunArchiveInputModel payRollRunArchiveInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertRateTagRoleBranchConfiguration(RateTagRoleBranchConfigurationUpsertInputModel RateTagRoleBranchConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RateTagRoleBranchConfigurationApiReturnModel> GetRateTagRoleBranchConfigurations(RateTagRoleBranchConfigurationInputModel rateTagConfigurationsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertBank(BankUpsertInputModel BankUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PayRollBandsSearchOutputModel> GetPayRollBands(PayRollBandsSearchInputModel payRollBandsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPayRollBands(PayRollBandsUpsertInputModel payRollBandsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeePreviousCompanyTaxSearchOutputModel> GetEmployeePreviousCompanyTaxes(EmployeePreviousCompanyTaxSearchInputModel EmployeePreviousCompanyTaxSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeePreviousCompanyTax(EmployeePreviousCompanyTaxUpsertInputModel EmployeePreviousCompanyTaxUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TaxCalculationTypeModel> GetTaxCalculationTypes(TaxCalculationTypeModel taxCalculationTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeRateTagConfigurationApiReturnModel> GetEmployeeRateTagConfigurations(EmployeeRateTagConfigurationInputModel employeeRateTagConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
