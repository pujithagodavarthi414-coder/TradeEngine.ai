using Btrak.Models;
using Btrak.Models.PayRoll;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.PayRollHelper
{
    public class PayRollValidationHelper
    {
        public static bool UpsertPayRollComponentValidation(PayRollComponentUpsertInputModel PayRollComponentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll component validation", "payRollComponentUpsertInputModel", PayRollComponentUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(PayRollComponentUpsertInputModel.ComponentName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayRollComponent
                });
            }

            if (!string.IsNullOrEmpty(PayRollComponentUpsertInputModel.ComponentName))
            {
                if (PayRollComponentUpsertInputModel.ComponentName.Length > 250)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.PayRollComponentNameLengthExceeded
                    });
                }
            }
            return validationMessages.Count <= 0;
        }

        public static bool UpsertPayRollTemplateValidation(PayRollTemplateUpsertInputModel PayRollTemplateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll template validation", "payRollComponentUpsertInputModel", PayRollTemplateUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(PayRollTemplateUpsertInputModel.PayRollName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayRollName
                });
            }

            if (string.IsNullOrEmpty(PayRollTemplateUpsertInputModel.PayRollShortName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayRollShortName
                });
            }

            if (!string.IsNullOrEmpty(PayRollTemplateUpsertInputModel.PayRollName))
            {
                if (PayRollTemplateUpsertInputModel.PayRollName.Length > 250)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.PayRollTemplateNameLengthExceeded
                    });
                }
            }

            if (!string.IsNullOrEmpty(PayRollTemplateUpsertInputModel.PayRollShortName))
            {
                if (PayRollTemplateUpsertInputModel.PayRollShortName.Length > 250)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.PayRollTemplateShortNameLengthExceeded
                    });
                }
            }

            if (PayRollTemplateUpsertInputModel.CurrencyId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCurrencyId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertPayRollTemplateConfigurationValidation(PayRollTemplateConfigurationUpsertInputModel payRollTemplateConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll template configuration validation", "payRollTemplateConfigurationUpsertInputModel", payRollTemplateConfigurationUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (payRollTemplateConfigurationUpsertInputModel.PayRollComponentId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayRollComponentId
                });
            }

            if (payRollTemplateConfigurationUpsertInputModel.PayRollTemplateId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayRollTemplateId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertResignationValidation(ResignationStatusSearchInputModel resignationStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessageses)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert resignation status", "resignation status UpsertModel", resignationStatusSearchInputModel, "Upsert payment type Validation helper"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessageses);

            if (string.IsNullOrEmpty(resignationStatusSearchInputModel.StatusName))
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyResignationStatus
                });
            }

            return validationMessageses.Count <= 0;
        }

        public static bool UpsertPayRollRoleConfigurationValidation(PayRollRoleConfigurationUpsertInputModel PayRollRoleConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll role configuration validation", "PayRollRoleConfigurationUpsertInputModel", PayRollRoleConfigurationUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (PayRollRoleConfigurationUpsertInputModel.PayRollTemplateId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayRollTemplateId
                });
            }
            if (PayRollRoleConfigurationUpsertInputModel.RoleId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRoleId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertPayRollBranchConfigurationValidation(PayRollBranchConfigurationUpsertInputModel PayRollBranchConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll branch configuration validation", "PayRollBranchConfigurationUpsertInputModel", PayRollBranchConfigurationUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (PayRollBranchConfigurationUpsertInputModel.PayRollTemplateId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayRollTemplateId
                });
            }
            if (PayRollBranchConfigurationUpsertInputModel.BranchId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyBranchId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertPayRollGenderConfigurationValidation(PayRollGenderConfigurationUpsertInputModel PayRollGenderConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll gender configuration validation", "PayRollGenderConfigurationUpsertInputModel", PayRollGenderConfigurationUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (PayRollGenderConfigurationUpsertInputModel.PayRollTemplateId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayRollTemplateId
                });
            }
            if (PayRollGenderConfigurationUpsertInputModel.GenderId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGender
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertPayRollMaritalStatusConfigurationValidation(PayRollMaritalStatusConfigurationUpsertInputModel PayRollMaritalStatusConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll marital status configuration validation", "PayRollMaritalStatusConfigurationUpsertInputModel", PayRollMaritalStatusConfigurationUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (PayRollMaritalStatusConfigurationUpsertInputModel.PayRollTemplateId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayRollTemplateId
                });
            }
            if (PayRollMaritalStatusConfigurationUpsertInputModel.MaritalStatusId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyMaritalStatus
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertTaxAllowanceValidation(TaxAllowanceUpsertInputModel TaxAllowanceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll marital status configuration validation", "TaxAllowanceUpsertInputModel", TaxAllowanceUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (TaxAllowanceUpsertInputModel.Name == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NameShouldNotBeNull
                });
            }
            if (TaxAllowanceUpsertInputModel.TaxAllowanceTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.TaxAllowanceTypeShouldNotBeNull
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeTaxAllowanceDetailsValidation(EmployeeTaxAllowanceDetailsUpsertInputModel EmployeeTaxAllowanceDetailsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll marital status configuration validation", "EmployeeTaxAllowanceDetailsUpsertInputModel", EmployeeTaxAllowanceDetailsUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (EmployeeTaxAllowanceDetailsUpsertInputModel.EmployeeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.EmployeeShouldNotBeNull
                });
            }
            if (EmployeeTaxAllowanceDetailsUpsertInputModel.TaxAllowanceId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.TaxAllowanceShouldNotBeNull
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertLeaveEncashmentSettingsValidation(LeaveEncashmentSettingsUpsertInputModel LeaveEncashmentSettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll marital status configuration validation", "LeaveEncashmentSettingsUpsertInputModel", LeaveEncashmentSettingsUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (LeaveEncashmentSettingsUpsertInputModel.Percentage == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PercentageShouldNotBeNull
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertFinancialYearConfigurationsValidation(FinancialYearConfigurationsUpsertInputModel FinancialYearConfigurationsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll marital status configuration validation", "FinancialYearConfigurationsUpsertInputModel", FinancialYearConfigurationsUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (FinancialYearConfigurationsUpsertInputModel.CountryId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.CountryShouldNotBeNull
                });
            }
            if (FinancialYearConfigurationsUpsertInputModel.FromMonth == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FromMonthShouldNotBeNull
                });
            }
            if (FinancialYearConfigurationsUpsertInputModel.ToMonth == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ToMonthShouldNotBeNull
                });
            }


            return validationMessages.Count <= 0;
        }

        public static bool UpsertTdsSettingsValidation(TdsSettingsUpsertInputModel TdsSettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll marital status configuration validation", "TdsSettingsUpsertInputModel", TdsSettingsUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (TdsSettingsUpsertInputModel.BranchId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.BranchShouldNotBeNull
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertContractPaySettingsValidation(ContractPaySettingsUpsertInputModel ContractPaySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll marital status configuration validation", "ContractPaySettingsUpsertInputModel", ContractPaySettingsUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (ContractPaySettingsUpsertInputModel.BranchId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.BranchShouldNotBeNull
                });
            }
            if (ContractPaySettingsUpsertInputModel.ContractPayTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ContractPayTypeShouldNotBeNull
                });
            }
            if (ContractPaySettingsUpsertInputModel.ActiveFrom == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ActiveFromShouldNotBeNull
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeLoanValidation(EmployeeLoanUpsertInputModel EmployeeLoanUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll marital status configuration validation", "EmployeeLoanUpsertInputModel", EmployeeLoanUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (EmployeeLoanUpsertInputModel.EmployeeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.EmployeeShouldNotBeNull
                });
            }
            if (EmployeeLoanUpsertInputModel.LoanAmount == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.LoanAmountShouldNotBeNull
                });
            }
            if (EmployeeLoanUpsertInputModel.LoanInterestPercentagePerMonth == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.LoanInterestPercentagePerMonthShouldNotBeNull
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertPayRollRunEmployeeComponentValidation(PayRollRunEmployeeComponentUpsertInputModel PayRollRunEmployeeComponentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll component validation", "PayRollRunEmployeeComponentUpsertInputModel", PayRollRunEmployeeComponentUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (!string.IsNullOrEmpty(PayRollRunEmployeeComponentUpsertInputModel.Comments))
            {
                if (PayRollRunEmployeeComponentUpsertInputModel.Comments.Length > 800)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.CommentsLengthError
                    });
                }
            }
            return validationMessages.Count <= 0;
        }

        public static bool UpsertRateTagValidation(RateTagInputModel rateSheetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertRateTagValidation", "rateSheetInputModel", rateSheetInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(rateSheetInputModel.RateTagName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRateTagName
                });
            }

            if (!string.IsNullOrEmpty(rateSheetInputModel.RateTagName))
            {
                if (rateSheetInputModel.RateTagName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.RateTagNameLengthExceeded
                    });
                }
            }

            if (rateSheetInputModel.RatePerHour <= 0 && rateSheetInputModel.RatePerHourMon <= 0 && rateSheetInputModel.RatePerHourTue <= 0 && rateSheetInputModel.RatePerHourWed <= 0 && rateSheetInputModel.RatePerHourThu <= 0 && rateSheetInputModel.RatePerHourFri <= 0 && rateSheetInputModel.RatePerHourSat <= 0 && rateSheetInputModel.RatePerHourSun <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.RateTagValueRequired
                });
            }

            return validationMessages.Count <= 0;
        }


        public static bool InsertEmployeeRateTagDetailsValidation(EmployeeRateTagDetailsAddInputModel employeeRateTagDetailsAddInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "InsertEmployeeSalaryDetails", "employeeRateTagDetailsAddInputModel", employeeRateTagDetailsAddInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeRateTagDetailsAddInputModel.RateTagEmployeeId == null || employeeRateTagDetailsAddInputModel.RateTagEmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeRateTagDetailsAddInputModel.RateTagCurrencyId == null || employeeRateTagDetailsAddInputModel.RateTagCurrencyId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCurrencyId
                });
            }

            if (employeeRateTagDetailsAddInputModel.RateTagDetails != null && employeeRateTagDetailsAddInputModel.RateTagDetails.Count > 0)
            {
                foreach (var employeeRateTag in employeeRateTagDetailsAddInputModel.RateTagDetails)
                {
                    if (employeeRateTag.RatePerHour <= 0 && employeeRateTag.RatePerHourMon <= 0 && employeeRateTag.RatePerHourTue <= 0 && employeeRateTag.RatePerHourWed <= 0 && employeeRateTag.RatePerHourThu <= 0 && employeeRateTag.RatePerHourFri <= 0 && employeeRateTag.RatePerHourSat <= 0 && employeeRateTag.RatePerHourSun <= 0)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = ValidationMessages.RateTagValueRequired
                        });
                    }
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpdateEmployeeRateTagDetailsValidation(EmployeeRateTagDetailsEditInputModel employeeRateTagDetailsEditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "InsertEmployeeSalaryDetails", "employeeRateTagDetailsEditInputModel", employeeRateTagDetailsEditInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeRateTagDetailsEditInputModel.RateTagEmployeeId == null || employeeRateTagDetailsEditInputModel.RateTagEmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeRateTagDetailsEditInputModel.RateTagCurrencyId == null || employeeRateTagDetailsEditInputModel.RateTagCurrencyId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCurrencyId
                });
            }

            if (employeeRateTagDetailsEditInputModel.RatePerHour <= 0 && employeeRateTagDetailsEditInputModel.RatePerHourMon <= 0 && employeeRateTagDetailsEditInputModel.RatePerHourTue <= 0 && employeeRateTagDetailsEditInputModel.RatePerHourWed <= 0 && employeeRateTagDetailsEditInputModel.RatePerHourThu <= 0 && employeeRateTagDetailsEditInputModel.RatePerHourFri <= 0 && employeeRateTagDetailsEditInputModel.RatePerHourSat <= 0 && employeeRateTagDetailsEditInputModel.RatePerHourSun <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.RateTagValueRequired
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool ValidateEmployeeRateTagById(EmployeeRateTagDetailsInputModel employeeRateTagDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (employeeRateTagDetailsInputModel.EmployeeId == Guid.Empty || employeeRateTagDetailsInputModel.EmployeeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeRateTagDetailsInputModel.EmployeeRateTagId == Guid.Empty || employeeRateTagDetailsInputModel.EmployeeRateTagId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeRateTagId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertPartsOfDayValidation(PartsOfDayUpsertInputModel partsOfDayInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertPartsOfDayValidation", "partsOfDayInputModel", partsOfDayInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(partsOfDayInputModel.PartsOfDayName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySpecificDayReason
                });
            }

            if (partsOfDayInputModel.PartsOfDayName?.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForPartsOfDayName
                });
            }

            return validationMessages.Count <= 0;
        }


        public static bool InsertRateTagConfigurationsValidation(RateTagConfigurationAddInputModel rateTagConfigurationAddInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "InsertEmployeeSalaryDetails", "rateTagConfigurationAddInputModel", rateTagConfigurationAddInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (rateTagConfigurationAddInputModel.RateTagCurrencyId == null || rateTagConfigurationAddInputModel.RateTagCurrencyId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCurrencyId
                });
            }

            if (rateTagConfigurationAddInputModel.RateTagDetails != null && rateTagConfigurationAddInputModel.RateTagDetails.Count > 0)
            {
                foreach (var employeeRateTag in rateTagConfigurationAddInputModel.RateTagDetails)
                {
                    if (employeeRateTag.RatePerHour <= 0 && employeeRateTag.RatePerHourMon <= 0 && employeeRateTag.RatePerHourTue <= 0 && employeeRateTag.RatePerHourWed <= 0 && employeeRateTag.RatePerHourThu <= 0 && employeeRateTag.RatePerHourFri <= 0 && employeeRateTag.RatePerHourSat <= 0 && employeeRateTag.RatePerHourSun <= 0)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = ValidationMessages.RateTagValueRequired
                        });
                    }
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpdateRateTagConfigurationValidation(RateTagConfigurationEditInputModel rateTagConfigurationEditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateRateTagConfigurationValidation", "rateTagConfigurationEditInputModel", rateTagConfigurationEditInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (rateTagConfigurationEditInputModel.RatePerHour <= 0 && rateTagConfigurationEditInputModel.RatePerHourMon <= 0 && rateTagConfigurationEditInputModel.RatePerHourTue <= 0 && rateTagConfigurationEditInputModel.RatePerHourWed <= 0 && rateTagConfigurationEditInputModel.RatePerHourThu <= 0 && rateTagConfigurationEditInputModel.RatePerHourFri <= 0 && rateTagConfigurationEditInputModel.RatePerHourSat <= 0 && rateTagConfigurationEditInputModel.RatePerHourSun <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.RateTagValueRequired
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool UpsertRateTagRoleBranchConfigurationValidation(RateTagRoleBranchConfigurationUpsertInputModel rateTagRoleBranchConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateRateTagConfigurationValidation", "rateTagConfigurationEditInputModel", rateTagRoleBranchConfigurationUpsertInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
           
            if (rateTagRoleBranchConfigurationUpsertInputModel.StartDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.StartDateShouldNotBeNull
                });
            }
            if (rateTagRoleBranchConfigurationUpsertInputModel.EndDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.EndDateShouldNotBeNull
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertBankValidation(BankUpsertInputModel bankUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateRateTagConfigurationValidation", "rateTagConfigurationEditInputModel", bankUpsertInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (bankUpsertInputModel.BankName == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.BankNameShouldNotBeNull
                });
            }
            if (bankUpsertInputModel.CountryId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.CountryShouldNotBeNull
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeePreviousCompanyTaxValidation(EmployeePreviousCompanyTaxUpsertInputModel EmployeePreviousCompanyTaxUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll marital status configuration validation", "EmployeePreviousCompanyTaxUpsertInputModel", EmployeePreviousCompanyTaxUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (EmployeePreviousCompanyTaxUpsertInputModel.EmployeeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.EmployeeShouldNotBeNull
                });
            }
            if (EmployeePreviousCompanyTaxUpsertInputModel.TaxAmount == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.TaxAmountShouldNotBeNull
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertPayRollRunEmployeeComponentYTDValidation(PayRollRunEmployeeComponentYTDUpsertInputModel PayRollRunEmployeeComponentYTDUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert pay roll component validation", "PayRollRunEmployeeComponentYTDUpsertInputModel", PayRollRunEmployeeComponentYTDUpsertInputModel, "Payroll Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(PayRollRunEmployeeComponentYTDUpsertInputModel.OriginalComponentAmount.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ActualComponentAmountShouldNotBeNull
                });
            }

            if (!string.IsNullOrEmpty(PayRollRunEmployeeComponentYTDUpsertInputModel.Comments))
            {
                if (PayRollRunEmployeeComponentYTDUpsertInputModel.Comments.Length > 800)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.CommentsLengthError
                    });
                }
            }
            return validationMessages.Count <= 0;
        }
    }
}
