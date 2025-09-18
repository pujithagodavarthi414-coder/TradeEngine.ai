using Btrak.Models;
using Btrak.Models.Currency;
using Btrak.Models.CurrencyConversion;
using Btrak.Models.Employee;
using Btrak.Models.HrDashboard;
using Btrak.Models.HrManagement;
using Btrak.Models.PayGradeRates;
using Btrak.Models.PaymentMethod;
using Btrak.Models.RateType;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Btrak.Services.Helpers.HRManagementValidationHelpers
{
    public class HrManagementValidationsHelper
    {
        public static bool UpsertShiftTimingValidation(ShiftTimingInputModel shiftTimingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertShiftTimingValidation", "shiftTimingInputModel", shiftTimingInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(shiftTimingInputModel.Shift))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyShift
                });
            }

            //if (shiftTimingInputModel.DaysOfWeek == null && shiftTimingInputModel.ShiftTimingId == null)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyDayOfWeek
            //    });
            //}

            if (shiftTimingInputModel.Shift?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForShift
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertShiftWeekValidation(ShiftWeekUpsertInputModel shiftTimingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertShiftWeekValidation", "shiftTimingInputModel", shiftTimingInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(shiftTimingInputModel.DayOfWeek))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDayOfWeek
                });
            }

            if (shiftTimingInputModel.ShiftTimingId == null || shiftTimingInputModel.ShiftTimingId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyShiftTimingId
                });
            }

            if (shiftTimingInputModel.StartTime == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyStratTiming
                });
            }

            if (shiftTimingInputModel.DeadLine == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDeadline
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertShiftExceptionsException(ShiftExceptionUpsertInputModel shiftTimingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertShiftExceptionValidation", "shiftTimingInputModel", shiftTimingInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (shiftTimingInputModel.ExceptionDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyExceptionDate
                });
            }

            if (shiftTimingInputModel.ShiftTimingId == null || shiftTimingInputModel.ShiftTimingId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyShiftTimingId
                });
            }

            if (shiftTimingInputModel.StartTime == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyStratTiming
                });
            }
            if (shiftTimingInputModel.DeadLine == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDeadline
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeShiftValidation(EmployeeShiftInputModel employeeShiftInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeShiftValidation", "employeeShiftInputModel", employeeShiftInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeShiftInputModel.ShiftTimingId == null || employeeShiftInputModel.ShiftTimingId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTiming
                });
            }

            if (employeeShiftInputModel.EmployeeId == null || employeeShiftInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeShiftInputModel.ActiveFrom == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyActiveFrom
                });
            }

            if ((employeeShiftInputModel.ActiveFrom != null) && (employeeShiftInputModel.ActiveTo != null) && DateTime.Compare((DateTime)employeeShiftInputModel.ActiveFrom, (DateTime)employeeShiftInputModel.ActiveTo) > 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.EmployeeActiveFrom
                });
            }


            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertContractType(ContractTypeUpsertInputModel contractTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(contractTypeUpsertInputModel.ContractTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyContractTypeName
                });
            }

            if (contractTypeUpsertInputModel.ContractTypeName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForContractTypeName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateContractTypeById(ContractTypeSearchInputModel contractTypeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (contractTypeSearchInputModel.ContractTypeId == Guid.Empty || contractTypeSearchInputModel.ContractTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyContractTypeId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateEmployeeLicenceById(EmployeeLicenseDetailsInputModel GetEmployeeLicenseDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (GetEmployeeLicenseDetailsInputModel.EmployeeId == Guid.Empty || GetEmployeeLicenseDetailsInputModel.EmployeeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateEmployeeSalaryById(Models.HrManagement.EmployeeSalaryDetailsInputModel getEmployeeSalaryDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (getEmployeeSalaryDetailsInputModel.EmployeeId == Guid.Empty || getEmployeeSalaryDetailsInputModel.EmployeeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateEmployeeId(Guid? EmployeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (EmployeeId == Guid.Empty || EmployeeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateContractTypeFoundWithId(ContractTypeSearchInputModel contractTypeSearchInputModel, List<ValidationMessage> validationMessages, ContractTypeApiReturnModel contractTypeSpReturnModel)
        {
            if (contractTypeSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundContractTypeWithTheId, contractTypeSearchInputModel.ContractTypeId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertDepartment(DepartmentUpsertInputModel departmentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(departmentUpsertInputModel.DepartmentName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDepartmentName
                });
            }

            if (departmentUpsertInputModel.DepartmentName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForDepartmentName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateDepartmentById(DepartmentSearchInputModel departmentSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (departmentSearchInputModel.DepartmentId == Guid.Empty || departmentSearchInputModel.DepartmentId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDepartmentId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateDepartmentFoundWithId(DepartmentSearchInputModel departmentSearchInputModel, List<ValidationMessage> validationMessages, DepartmentApiReturnModel departmentSpReturnModel)
        {
            if (departmentSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundDepartmentWithTheId, departmentSearchInputModel.DepartmentId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertCurrencyValidation(CurrencyInputModel currencyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCurrencyValidation", "currencyInputModel", currencyInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(currencyInputModel.CurrencyName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCurrencyName
                });
            }

            if (!string.IsNullOrEmpty(currencyInputModel.CurrencyName))
            {
                if (currencyInputModel.CurrencyName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.CurrencyNameLengthExceeded
                    });
                }

            }

            if (string.IsNullOrEmpty(currencyInputModel.CurrencyCode))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCurrencyCode
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertCurrencyConversionValidation(CurrencyConversionInputModel currencyConversionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCurrencyConversionValidation", "currencyConversionInputModel", currencyConversionInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (currencyConversionInputModel.FromCurrency == null || currencyConversionInputModel.FromCurrency == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFromCurrency
                });
            }

            if (currencyConversionInputModel.ToCurrency == null || currencyConversionInputModel.ToCurrency == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyToCurrency
                });
            }

            if (currencyConversionInputModel.EffectiveFrom == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEffectiveFrom
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertPaymentMethod(PaymentMethodInputModel paymentMethodInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Payment Method", "paymentMethodInputModel", paymentMethodInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(paymentMethodInputModel.PaymentMethodName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPaymentMethodName
                });
            }

            if (!string.IsNullOrEmpty(paymentMethodInputModel.PaymentMethodName))
            {
                if (paymentMethodInputModel.PaymentMethodName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.PaymentMethodNameLengthExceeded
                    });
                }

            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertDesignation(DesignationUpsertInputModel designationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(designationUpsertInputModel.DesignationName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDesignationName
                });
            }

            if (designationUpsertInputModel.DesignationName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForDesignationName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertPayGrade(PayGradeUpsertInputModel payGradeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(payGradeUpsertInputModel.PayGradeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayGradeName
                });
            }

            if (payGradeUpsertInputModel.PayGradeName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForPayGradeName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertBreakType(BreakTypeUpsertInputModel breakTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(breakTypeUpsertInputModel.BreakTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyBreakTypeName
                });
            }

            if (breakTypeUpsertInputModel.BreakTypeName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForBreakTypeName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertRateTypeValidation(RateTypeInputModel rateTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertRateTypeValidation", "rateTypeInputModel", rateTypeInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(rateTypeInputModel.TypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRateTypeName
                });
            }

            if (!string.IsNullOrEmpty(rateTypeInputModel.TypeName))
            {
                if (rateTypeInputModel.TypeName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.RateTypeNameLengthExceeded
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeLicenceDetailsValidation(EmployeeLicenceDetailsInputModel employeeLicenceDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeLicenceDetailsValidation", "employeeLicenceDetailsInputModel", employeeLicenceDetailsInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeLicenceDetailsInputModel.EmployeeId == null || employeeLicenceDetailsInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (string.IsNullOrEmpty(employeeLicenceDetailsInputModel.LicenceNumber))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLicenceNumber
                });
            }

            if (!string.IsNullOrEmpty(employeeLicenceDetailsInputModel.LicenceNumber))
            {
                if (employeeLicenceDetailsInputModel.LicenceNumber.Length > 20)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.LicenceNumberLengthExceeded
                    });
                }

            }

            //if (employeeLicenceDetailsInputModel.LicenceIssuedDate == null)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyLicenceIssuedDate
            //    });
            //}

            //if (employeeLicenceDetailsInputModel.LicenceExpiryDate == null)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyLicenceExpiryDate
            //    });
            //}

            if (employeeLicenceDetailsInputModel.LicenceTypeId == null || employeeLicenceDetailsInputModel.LicenceTypeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLicenceTypeId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeContactDetailsValidation(EmployeeContactDetailsInputModel employeeContactDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeContactDetailsValidation", "employeeContactDetailsInputModel", employeeContactDetailsInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeContactDetailsInputModel.EmployeeId == null || employeeContactDetailsInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeContactDetailsInputModel.CountryId == null || employeeContactDetailsInputModel.CountryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCountryId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeePersonalDetailsValidation(EmployeePersonalDetailsInputModel employeePersonalDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeePersonalDetailsValidation", "employeePersonalDetailsInputModel", employeePersonalDetailsInputModel, "HrManagement Validations Helper"));

            if (string.IsNullOrEmpty(employeePersonalDetailsInputModel.FirstName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFirstName
                });
            }

            if (!string.IsNullOrEmpty(employeePersonalDetailsInputModel.FirstName))
            {
                if (employeePersonalDetailsInputModel.FirstName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.FirstNameLengthExceeded
                    });
                }
            }

            if (string.IsNullOrEmpty(employeePersonalDetailsInputModel.Email))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmail
                });
            }

            if (!string.IsNullOrEmpty(employeePersonalDetailsInputModel.Email))
            {
                if (employeePersonalDetailsInputModel.Email.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.EmailLengthExceeded
                    });
                }
                string email = employeePersonalDetailsInputModel.Email;
                Regex regex = new Regex(@"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$");
                Match match = regex.Match(email);
                if (!match.Success)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.EmailFormat
                    });
                }
            }

            if (string.IsNullOrEmpty(employeePersonalDetailsInputModel.RoleIds))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRoleId
                });
            }

            //if (string.IsNullOrEmpty(employeePersonalDetailsInputModel.MobileNo))
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyMobileNumber
            //    });
            //}

            //if (employeePersonalDetailsInputModel.IsUpsertEmployee == true)
            //{

            //    if (employeePersonalDetailsInputModel.JobCategoryId == null || employeePersonalDetailsInputModel.JobCategoryId == Guid.Empty)
            //    {
            //        validationMessages.Add(new ValidationMessage
            //        {
            //            ValidationMessageType = MessageTypeEnum.Error,
            //            ValidationMessaage = string.Format(ValidationMessages.NotEmptyJobCategoryId)
            //        });
            //    }

            //    if (employeePersonalDetailsInputModel.DesignationId == null || employeePersonalDetailsInputModel.DesignationId == Guid.Empty)
            //    {
            //        validationMessages.Add(new ValidationMessage
            //        {
            //            ValidationMessageType = MessageTypeEnum.Error,
            //            ValidationMessaage = string.Format(ValidationMessages.NotEmptyDesignationId)
            //        });
            //    }

            //    if (employeePersonalDetailsInputModel.EmploymentStatusId == null || employeePersonalDetailsInputModel.EmploymentStatusId == Guid.Empty)
            //    {
            //        validationMessages.Add(new ValidationMessage
            //        {
            //            ValidationMessageType = MessageTypeEnum.Error,
            //            ValidationMessaage = string.Format(ValidationMessages.NotEmptyEmploymentStatusId)
            //        });
            //    }

            //    if (employeePersonalDetailsInputModel.BranchId == null || employeePersonalDetailsInputModel.BranchId == Guid.Empty)
            //    {
            //        validationMessages.Add(new ValidationMessage
            //        {
            //            ValidationMessageType = MessageTypeEnum.Error,
            //            ValidationMessaage = string.Format(ValidationMessages.NotEmptyBranchId)
            //        });
            //    }

            //    if (employeePersonalDetailsInputModel.DateOfJoining == null)
            //    {
            //        validationMessages.Add(new ValidationMessage
            //        {
            //            ValidationMessageType = MessageTypeEnum.Error,
            //            ValidationMessaage = string.Format(ValidationMessages.NotEmptyDateOfJoining)
            //        });
            //    }

            //    //if (employeePersonalDetailsInputModel.ActiveFrom == null)
            //    //{
            //    //    validationMessages.Add(new ValidationMessage
            //    //    {
            //    //        ValidationMessageType = MessageTypeEnum.Error,
            //    //        ValidationMessaage = string.Format(ValidationMessages.NotEmptyActiveFrom)
            //    //    });
            //    //}
            //}

            return validationMessages.Count <= 0;
        }

        public static bool AssignPayGradeRatesValidation(PayGradeRatesInputModel payGradeRatesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "AssignPayGradeRatesValidation", "payGradeRatesSpInputModel", payGradeRatesInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (payGradeRatesInputModel.PayGradeId == null || payGradeRatesInputModel.PayGradeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayGradeId
                });
            }

            if (payGradeRatesInputModel.PayGradeRateModel == null || payGradeRatesInputModel.PayGradeRateModel.Count <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayGradeRateModel
                });
            }

            if (payGradeRatesInputModel.PayGradeRateModel != null)
            {
                foreach (PayGradeRateModel payGradeRate in payGradeRatesInputModel.PayGradeRateModel)
                {
                    if (payGradeRate.RateId == null || payGradeRate.RateId == Guid.Empty)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = ValidationMessages.NotEmptyRateIds
                        });
                    }
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeEmergencyContactDetailsValidation(EmployeeEmergencyContactDetailsInputModel employeeEmergencyContactDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeEmergencyContactDetailsValidation", "employeeEmergencyContactDetailsInputModel", employeeEmergencyContactDetailsInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeEmergencyContactDetailsInputModel.EmployeeId == null || employeeEmergencyContactDetailsInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (string.IsNullOrEmpty(employeeEmergencyContactDetailsInputModel.FirstName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFirstName
                });
            }

            if (!string.IsNullOrEmpty(employeeEmergencyContactDetailsInputModel.FirstName))
            {
                if (employeeEmergencyContactDetailsInputModel.FirstName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.FirstNameLengthExceeded
                    });
                }
            }

            if (employeeEmergencyContactDetailsInputModel.IsDependentContact == null)
            {
                if (employeeEmergencyContactDetailsInputModel.FirstName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyIsDependentContact
                    });
                }
            }

            if (employeeEmergencyContactDetailsInputModel.IsEmergencyContact == null)
            {
                if (employeeEmergencyContactDetailsInputModel.FirstName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyIsEmergencyContact
                    });
                }
            }

            if (employeeEmergencyContactDetailsInputModel.RelationshipId == Guid.Empty || employeeEmergencyContactDetailsInputModel.RelationshipId == null)
            {
                if (employeeEmergencyContactDetailsInputModel.FirstName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyRelationshipId
                    });
                }
            }

            if (!string.IsNullOrEmpty(employeeEmergencyContactDetailsInputModel.LastName))
            {
                if (employeeEmergencyContactDetailsInputModel.LastName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.LastNameLengthExceeded
                    });
                }
            }

            if (string.IsNullOrEmpty(employeeEmergencyContactDetailsInputModel.MobileNo))
            {
                if (employeeEmergencyContactDetailsInputModel.MobileNo?.Length > 20)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyMobileNumber
                    });
                }
            }

            if (!string.IsNullOrEmpty(employeeEmergencyContactDetailsInputModel.MobileNo) && (employeeEmergencyContactDetailsInputModel.MobileNo.Length > 20))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MobileNoLengthExceeded
                });
            }

            if (employeeEmergencyContactDetailsInputModel.RelationshipId == null || employeeEmergencyContactDetailsInputModel.RelationshipId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRelationshipId
                });
            }

            if (employeeEmergencyContactDetailsInputModel.IsEmergencyContact == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyIsEmergencyContact
                });
            }

            if (employeeEmergencyContactDetailsInputModel.IsDependentContact == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyIsDependentContact
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmploymentContractValidation(EmploymentContractInputModel employmentContractInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmploymentContractValidation", "employmentContractInputModel", employmentContractInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employmentContractInputModel.EmployeeId == null || employmentContractInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employmentContractInputModel.ContractTypeId == null || employmentContractInputModel.ContractTypeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyContractTypeId
                });
            }

            if (employmentContractInputModel.StartDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyStartDate
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeJobValidation(EmployeeJobInputModel employeeJobInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeJobValidation", "employeeJobInputModel", employeeJobInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeJobInputModel.EmployeeId == null || employeeJobInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeJobInputModel.DesignationId == null || employeeJobInputModel.DesignationId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDesignationId
                });
            }

            if (employeeJobInputModel.EmploymentStatusId == null || employeeJobInputModel.EmploymentStatusId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmploymentStatusId
                });
            }

            if (employeeJobInputModel.JobCategoryId == null || employeeJobInputModel.JobCategoryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyJobCategoryId
                });
            }

            if (employeeJobInputModel.DepartmentId == null || employeeJobInputModel.DepartmentId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDepartmentId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeImmigrationDetailsValidation(Models.Employee.EmployeeImmigrationDetailsInputModel employeeImmigrationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeImmigrationDetailsValidation", "employeeImmigrationDetailsInputModel", employeeImmigrationDetailsInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeImmigrationDetailsInputModel.EmployeeId == null || employeeImmigrationDetailsInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeImmigrationDetailsInputModel.CountryId == null || employeeImmigrationDetailsInputModel.CountryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCountryId
                });
            }

            if (string.IsNullOrEmpty(employeeImmigrationDetailsInputModel.Document))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDocument
                });
            }

            if (!string.IsNullOrEmpty(employeeImmigrationDetailsInputModel.Document))
            {
                if (employeeImmigrationDetailsInputModel.Document.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.DocumentLengthExceeded
                    });
                }

            }

            if (string.IsNullOrEmpty(employeeImmigrationDetailsInputModel.DocumentNumber))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDocumentNumber
                });
            }

            if (!string.IsNullOrEmpty(employeeImmigrationDetailsInputModel.DocumentNumber))
            {
                if (employeeImmigrationDetailsInputModel.DocumentNumber.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.DocumentNumberLengthExceeded
                    });
                }

            }
            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeSalaryDetailsValidation(Models.Employee.EmployeeSalaryDetailsInputModel employeeSalaryDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeSalaryDetails", "employeeSalaryDetailsInputModel", employeeSalaryDetailsInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeSalaryDetailsInputModel.EmployeeId == null || employeeSalaryDetailsInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (string.IsNullOrEmpty(employeeSalaryDetailsInputModel.SalaryComponent))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySalaryComponent
                });
            }

            if (!string.IsNullOrEmpty(employeeSalaryDetailsInputModel.SalaryComponent))
            {
                if (employeeSalaryDetailsInputModel.SalaryComponent.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.SalaryComponentLengthExceeded
                    });
                }
            }

            if (employeeSalaryDetailsInputModel.PayGradeId == null || employeeSalaryDetailsInputModel.PayGradeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayGradeId
                });
            }

            if (employeeSalaryDetailsInputModel.PaymentMethodId == null || employeeSalaryDetailsInputModel.PaymentMethodId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPaymentMethodId
                });
            }

            if (employeeSalaryDetailsInputModel.PayFrequencyId == null || employeeSalaryDetailsInputModel.PayFrequencyId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayFrequencyId
                });
            }

            if (employeeSalaryDetailsInputModel.CurrencyId == null || employeeSalaryDetailsInputModel.CurrencyId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCurrencyId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeReportToValidation(EmployeeReportToInputModel employeeReportToInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeReportToValidation", "employeeReportToInputModel", employeeReportToInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeReportToInputModel.EmployeeId == null || employeeReportToInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeReportToInputModel.ReportToEmployeeId == null || employeeReportToInputModel.ReportToEmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReportingToEmployeeId
                });
            }

            if (employeeReportToInputModel.ReportingMethodId == null || employeeReportToInputModel.ReportingMethodId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReportingMethodId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeWorkExperienceValidation(EmployeeWorkExperienceInputModel employeeWorkExperienceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeWorkExperience", "employeeWorkExperienceInputModel", employeeWorkExperienceInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeWorkExperienceInputModel.EmployeeId == null || employeeWorkExperienceInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }
            if (string.IsNullOrEmpty(employeeWorkExperienceInputModel.Company))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPreviousCompany
                });
            }

            if (!string.IsNullOrEmpty(employeeWorkExperienceInputModel.Company))
            {
                if (employeeWorkExperienceInputModel.Company.Length > 100)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.PreviousCompanyLengthExceeded
                    });
                }
            }

            if (employeeWorkExperienceInputModel.DesignationId == null || employeeWorkExperienceInputModel.DesignationId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDesignationId
                });
            }

            if (employeeWorkExperienceInputModel.FromDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFromDate
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeEducationDetails(Models.Employee.EmployeeEducationDetailsInputModel employeeEducationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeEducationDetails", "employeeEducationDetailsInputModel", employeeEducationDetailsInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeEducationDetailsInputModel.EmployeeId == null || employeeEducationDetailsInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }
            if (string.IsNullOrEmpty(employeeEducationDetailsInputModel.Institute))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyInstitute
                });
            }

            if (!string.IsNullOrEmpty(employeeEducationDetailsInputModel.Institute))
            {
                if (employeeEducationDetailsInputModel.Institute.Length > 150)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.InstituteLengthExceeded
                    });
                }
            }

            if (!string.IsNullOrEmpty(employeeEducationDetailsInputModel.MajorSpecialization))
            {
                if (employeeEducationDetailsInputModel.MajorSpecialization.Length > 800)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.MajorSpecializationLengthExceeded
                    });
                }
            }

            if (employeeEducationDetailsInputModel.EducationLevelId == null || employeeEducationDetailsInputModel.EducationLevelId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEducationLevelId
                });
            }

            if (employeeEducationDetailsInputModel.GpaOrScore == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGpaOrScore
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeSkillsValidation(EmployeeSkillsInputModel employeeSkillsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeSkillsValidation", "employeeSkillsInputModel", employeeSkillsInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeSkillsInputModel.EmployeeId == null || employeeSkillsInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeSkillsInputModel.SkillId == null || employeeSkillsInputModel.SkillId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySkillId
                });
            }

            if (employeeSkillsInputModel.DateFrom == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDateFrom
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeLanguagesValidation(EmployeeLanguagesInputModel employeeLanguagesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeLanguagesValidation", "employeeLanguagesInputModel", employeeLanguagesInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeLanguagesInputModel.EmployeeId == null || employeeLanguagesInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeLanguagesInputModel.LanguageId == null || employeeLanguagesInputModel.LanguageId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLanguageId
                });
            }

            //if (employeeLanguagesInputModel.FluencyId == null || employeeLanguagesInputModel.FluencyId == Guid.Empty)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyFluencyId
            //    });
            //}

            if (employeeLanguagesInputModel.CompetencyId == null || employeeLanguagesInputModel.CompetencyId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompetencyId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertRelationShip(RelationshipUpsertModel relationshipUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (relationshipUpsertModel.RelationshipName == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRelationshipName
                });
            }

            else if (relationshipUpsertModel.RelationshipName.Length > 50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.RelationshipNameLengthExceeded
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertEmployeeMemberships(EmployeeMembershipUpsertInputModel employeeMembershipUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (employeeMembershipUpsertInputModel.EmployeeId == null || employeeMembershipUpsertInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeMembershipUpsertInputModel.MembershipId == null || employeeMembershipUpsertInputModel.MembershipId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyMembershipId
                });
            }

            if (employeeMembershipUpsertInputModel.CommenceDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCommenceDate
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertEmployeeBankDetail(EmployeeBankDetailUpsertInputModel employeeBankDetailUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (employeeBankDetailUpsertInputModel.EmployeeId == null || employeeBankDetailUpsertInputModel.EmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeBankDetailUpsertInputModel.IFSCCode?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForSortCode
                });
            }

            if (string.IsNullOrEmpty(employeeBankDetailUpsertInputModel.AccountNumber))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyAccountNumber
                });
            }

            if (employeeBankDetailUpsertInputModel.AccountNumber?.Length > AppConstants.InputWithMaxSize20)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForAccountNumber
                });
            }

            if (string.IsNullOrEmpty(employeeBankDetailUpsertInputModel.AccountName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyAccountName
                });
            }

            if (employeeBankDetailUpsertInputModel.AccountName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForAccountName
                });
            }

            //if (string.IsNullOrEmpty(employeeBankDetailUpsertInputModel.BuildingSocietyRollNumber))
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyBuildingSocietyRollNumber
            //    });
            //}

            //if (employeeBankDetailUpsertInputModel.BuildingSocietyRollNumber?.Length > AppConstants.InputWithMaxSize50)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.MaximumLengthForBuildingSocietyRollNumber
            //    });
            //}

            if (employeeBankDetailUpsertInputModel.BankId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyBankName
                });
            }

            if (employeeBankDetailUpsertInputModel.BankName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForBankName
                });
            }

            if (string.IsNullOrEmpty(employeeBankDetailUpsertInputModel.BranchName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeBranchName
                });
            }

            if (employeeBankDetailUpsertInputModel.BranchName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForEmployeeBranchName
                });
            }

            if (employeeBankDetailUpsertInputModel.EffectiveFrom == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDateFrom
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateGetEmployeeOverViewDetails(Guid? employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (employeeId == null || employeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool InsertEmployeeRatesheetDetailsValidation(Models.Employee.EmployeeRateSheetDetailsAddInputModel employeeRateSheetDetailsAddInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "InsertEmployeeSalaryDetails", "employeeRateSheetDetailsAddInputModel", employeeRateSheetDetailsAddInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeRateSheetDetailsAddInputModel.RateSheetEmployeeId == null || employeeRateSheetDetailsAddInputModel.RateSheetEmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeRateSheetDetailsAddInputModel.RateSheetCurrencyId == null || employeeRateSheetDetailsAddInputModel.RateSheetCurrencyId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCurrencyId
                });
            }

            if (employeeRateSheetDetailsAddInputModel.RateSheetDetails == null || employeeRateSheetDetailsAddInputModel.RateSheetDetails.Count <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRateSheetDetails
                });
            }

            if (employeeRateSheetDetailsAddInputModel.RateSheetDetails != null && employeeRateSheetDetailsAddInputModel.RateSheetDetails.Count > 0)
            {
                foreach (var employeeRatesheet in employeeRateSheetDetailsAddInputModel.RateSheetDetails)
                {
                    if (employeeRatesheet.RatePerHour <= 0 && employeeRatesheet.RatePerHourMon <= 0 && employeeRatesheet.RatePerHourTue <= 0 && employeeRatesheet.RatePerHourWed <= 0 && employeeRatesheet.RatePerHourThu <= 0 && employeeRatesheet.RatePerHourFri <= 0 && employeeRatesheet.RatePerHourSat <= 0 && employeeRatesheet.RatePerHourSun <= 0)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = ValidationMessages.RateSheetValueRequired
                        });
                    }
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpdateEmployeeRatesheetDetailsValidation(Models.Employee.EmployeeRatesheetDetailsEditInputModel employeeRatesheetDetailsEditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "InsertEmployeeSalaryDetails", "employeeRatesheetDetailsEditInputModel", employeeRatesheetDetailsEditInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeRatesheetDetailsEditInputModel.RateSheetEmployeeId == null || employeeRatesheetDetailsEditInputModel.RateSheetEmployeeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeRatesheetDetailsEditInputModel.RateSheetCurrencyId == null || employeeRatesheetDetailsEditInputModel.RateSheetCurrencyId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCurrencyId
                });
            }

            if (employeeRatesheetDetailsEditInputModel.RatePerHour <= 0 && employeeRatesheetDetailsEditInputModel.RatePerHourMon <= 0 && employeeRatesheetDetailsEditInputModel.RatePerHourTue <= 0 && employeeRatesheetDetailsEditInputModel.RatePerHourWed <= 0 && employeeRatesheetDetailsEditInputModel.RatePerHourThu <= 0 && employeeRatesheetDetailsEditInputModel.RatePerHourFri <= 0 && employeeRatesheetDetailsEditInputModel.RatePerHourSat <= 0 && employeeRatesheetDetailsEditInputModel.RatePerHourSun <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.RateSheetValueRequired
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertWebHook(WebHookUpsertInputModel webhookUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(webhookUpsertInputModel.WebHookName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDepartmentName
                });
            }

            if (webhookUpsertInputModel.WebHookName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForDepartmentName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateWebHookById(WebHookSearchInputModel webhookSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (webhookSearchInputModel.WebHookId == Guid.Empty || webhookSearchInputModel.WebHookId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDepartmentId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertHtmlTemplate(HtmlTemplateUpsertInputModel htmlTemplateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(htmlTemplateUpsertInputModel.HtmlTemplateName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDepartmentName
                });
            }

            if (htmlTemplateUpsertInputModel.HtmlTemplateName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForDepartmentName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateHtmlTemplateById(HtmlTemplateSearchInputModel htmlTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (htmlTemplateSearchInputModel.HtmlTemplateId == Guid.Empty || htmlTemplateSearchInputModel.HtmlTemplateId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDepartmentId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateWebHookFoundWithId(WebHookSearchInputModel webhookSearchInputModel, List<ValidationMessage> validationMessages, WebHookApiReturnModel webhookSpReturnModel)
        {
            if (webhookSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundDepartmentWithTheId, webhookSearchInputModel.WebHookId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateHtmlTemplateFoundWithId(HtmlTemplateSearchInputModel htmlTemplateSearchInputModel, List<ValidationMessage> validationMessages, HtmlTemplateApiReturnModel htmltemplateSpReturnModel)
        {
            if (htmltemplateSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundDepartmentWithTheId, htmlTemplateSearchInputModel.HtmlTemplateId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateEmployeeRatesheetById(EmployeeRateSheetDetailsInputModel employeeRateSheetDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (employeeRateSheetDetailsInputModel.EmployeeId == Guid.Empty || employeeRateSheetDetailsInputModel.EmployeeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeId
                });
            }

            if (employeeRateSheetDetailsInputModel.EmployeeRatesheetId == Guid.Empty || employeeRateSheetDetailsInputModel.EmployeeRatesheetId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmployeeRateSheetId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateBadgeInputs(BadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(badgeModel.BadgeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.BadgeNameIsRequired
                });
            }
            else if (badgeModel.BadgeName.Length > 50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.BadgeNameLengthExceeded
                });
            }

            if (!string.IsNullOrEmpty(badgeModel.Description) && badgeModel.Description.Length > 250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DescriptionMaxLength250
                });
            }

            if (string.IsNullOrEmpty(badgeModel.ImageUrl))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.BadgeLogoIsRequired
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateEmployeeBadgeInputs(EmployeeBadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (badgeModel.IsArchived == false && badgeModel.BadgeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.BadgeIsRequired
                });
            }
            if (badgeModel.IsArchived == false && badgeModel.AssignedTo.Count == 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.AssignToIsRequired
                });
            }

            if (!string.IsNullOrEmpty(badgeModel.BadgeDescription) && badgeModel.BadgeDescription.Length > 250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DescriptionMaxLength250
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool ValidateReminderInputs(ReminderModel reminderModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (reminderModel.ReferenceId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReferenceId
                });
            }

            if (reminderModel.ReferenceTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReferenceTypeId
                });
            }

            if (reminderModel.NotificationType == 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotificationTypeIsRequired
                });
            }

            if (!string.IsNullOrEmpty(reminderModel.AdditionalInfo) && reminderModel.AdditionalInfo.Length > 650)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.InfoLenghtMustNotExceed650
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool ValidateAnnouncementInputs(AnnouncementModel announcementModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(announcementModel.Announcement))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.AnnouncementIsRequired
                });
            }
            if (string.IsNullOrEmpty(announcementModel.AnnouncedTo))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.AnnouncedToIsRequired
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
