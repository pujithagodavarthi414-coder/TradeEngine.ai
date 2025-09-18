using System;
using Btrak.Models;
using Btrak.Models.HrManagement;
using BTrak.Common;
using System.Collections.Generic;
using Btrak.Models.Employee;
using Btrak.Models.MasterData;
using Btrak.Models.SoftLabelConfigurations;

namespace Btrak.Services.Helpers.MasterDataValidationHelper
{
    public class MasterDataValidationHelper
    {
        public static bool UpsertSkillsValidation(SkillsInputModel skillsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertSkills", "skillsInputModel", skillsInputModel, "HrManagement Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(skillsInputModel.SkillName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySkillName
                });
            }

            if (!string.IsNullOrEmpty(skillsInputModel.SkillName))
            {
                if (skillsInputModel.SkillName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.SkillNameLengthExceeded
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertSubscriptionPaidBy(SubscriptionPaidByUpsertInputModel subscriptionPaidByUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertSubscriptionPaidBy", "subscriptionPaidByUpsertInputModel", subscriptionPaidByUpsertInputModel, "Master Data Management Validations Helper"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(subscriptionPaidByUpsertInputModel.SubscriptionPaidByName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySubscriptionPaidBy
                });
            }

            if (subscriptionPaidByUpsertInputModel.SubscriptionPaidByName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForSubscriptionPaidByName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertTimeFormatValidation(TimeFormatInputModel timeFormatInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeFormatValidation", "timeFormatInputModel", timeFormatInputModel, "Master Data Management Validations Helper"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(timeFormatInputModel.TimeFormatName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTimeFormat
                });
            }

            if (timeFormatInputModel.TimeFormatName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForTimeFormat
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertDateFormatValidation(DateFormatInputModel dateFormatInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertDateFormatValidation", "dateFormatInputModel", dateFormatInputModel, "Master Data Management Validations Helper"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(dateFormatInputModel.DateFormatName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDateFormat
                });
            }

            if (dateFormatInputModel.DateFormatName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForDateFormat
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertMainUseCaseValidation(MainUseCaseInputModel mainUseCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertMainUseCase", "mainUseCaseInputModel", mainUseCaseInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(mainUseCaseInputModel.MainUseCaseName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyMainUseCase
                });
            }

            if (mainUseCaseInputModel.MainUseCaseName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForMainUseCase
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertScriptValidation(GetScriptsInputModel scriptsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert script", "scriptsInputModel", scriptsInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(scriptsInputModel.ScriptName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyScriptName
                });
            }
            if (string.IsNullOrEmpty(scriptsInputModel.Version))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyVersion
                });
            }
            if (string.IsNullOrEmpty(scriptsInputModel.ScriptUrl))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyScriptUrl
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertNumberFormatValidation(NumberFormatInputModel numberFormatInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertNumberFormat", "numberFormatInputModel", numberFormatInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(numberFormatInputModel.NumberFormat))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyNumberFormat
                });
            }

            if (numberFormatInputModel.NumberFormat?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForNumberFormat
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertCompanyIntroducedByOptionValidation(CompanyIntroducedByOptionInputModel companyIntroducedByOptionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyIntroducedByOption", "companyIntroducedByOptionInputModel", companyIntroducedByOptionInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(companyIntroducedByOptionInputModel.Option))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyIntroducedByOption
                });
            }

            if (companyIntroducedByOptionInputModel.Option?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForCompanyIntroducedByOption
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertStateValidation(StateInputModel stateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertStateValidation", "stateInputModel", stateInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(stateInputModel.StateName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyStateName
                });
            }

            if (stateInputModel.StateName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForStateName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertReferenceTypeValidation(ReferenceTypeInputModel referenceTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertReferenceTypeValidation", "referenceTypeInputModel", referenceTypeInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(referenceTypeInputModel.ReferenceTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReferenceTypeName
                });
            }

            if (referenceTypeInputModel.ReferenceTypeName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForReferenceTypeName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertLicenseTypeValidation(LicenseTypeInputModel licenseTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertLicenseTypeValidation", "licenseTypeInputModel", licenseTypeInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(licenseTypeInputModel.LicenceTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLicenseTypeName
                });
            }

            if (licenseTypeInputModel.LicenceTypeName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForLicenseTypeName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertHolidayValidation(HolidayInputModel holidayInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertHolidayValidation", "holidayInputModel", holidayInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (holidayInputModel.IsWeekOff == null || holidayInputModel.IsWeekOff == false)
            {
                if (string.IsNullOrEmpty(holidayInputModel.Reason))
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyHolidayReason
                    });
                }

                if (holidayInputModel.Reason?.Length > AppConstants.InputWithMaxSize50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.MaximumLengthForHolidayReason
                    });
                }

                if (holidayInputModel.CountryId == null || holidayInputModel.CountryId == Guid.Empty)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyCountryId
                    });
                }

                if (holidayInputModel.Date == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyDate
                    });
                }
            }
            return validationMessages.Count <= 0;
        }

        public static bool UpsertEducationLevel(EducationLevelUpsertModel educationLevelUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEducationLevelValidation", "educationLevelUpsertModel", educationLevelUpsertModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(educationLevelUpsertModel.EducationLevelName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEducationLevelName
                });
            }

            if (educationLevelUpsertModel.EducationLevelName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForEducationLevelName
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool UpsertReportingMethod(ReportingMethodUpsertModel reportingMethodUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertReportingMethod", "educationLevelUpsertModel", reportingMethodUpsertModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(reportingMethodUpsertModel.ReportingMethodName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReportingMethodType
                });
            }

            if (reportingMethodUpsertModel.ReportingMethodName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForReportingMethodType
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool UpsertMembership(MembershipUpsertModel membershipUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertMembership", "membershipUpsertModel", membershipUpsertModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(membershipUpsertModel.MembershipName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyMembershipType
                });
            }

            if (membershipUpsertModel.MembershipName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForMembershipType
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmploymentStatusValidation(EmploymentStatusInputModel employmentStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmploymentContractValidation", "employmentStatusInputModel", employmentStatusInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(employmentStatusInputModel.EmploymentStatusName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmploymentStatusName
                });
            }

            if (!string.IsNullOrEmpty(employmentStatusInputModel.EmploymentStatusName))
            {
                if (employmentStatusInputModel.EmploymentStatusName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.EmploymentStatusNameLengthExceeded
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertPayFrequencyValidation(PayFrequencyUpsertModel payFrequencyUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertPayFrequencyValidation", "payFrequencyUpsertModel", payFrequencyUpsertModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(payFrequencyUpsertModel.PayFrequencyName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPayFrequencyName
                });
            }

            if (!string.IsNullOrEmpty(payFrequencyUpsertModel.PayFrequencyName))
            {
                if (payFrequencyUpsertModel.PayFrequencyName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.PayFrequencyNameLengthExceeded
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertNationalityValidation(NationalityUpsertModel nationalityUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertNationalityValidation", "nationalityUpsertModel", nationalityUpsertModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(nationalityUpsertModel.NationalityName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyNationalityName
                });
            }

            if (!string.IsNullOrEmpty(nationalityUpsertModel.NationalityName))
            {
                if (nationalityUpsertModel.NationalityName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NationalityNameLengthExceeded
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertLanguageValidation(LanguageUpsertModel languageUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertLanguageValidation", "languageUpsertModel", languageUpsertModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(languageUpsertModel.LanguageName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLanguageName
                });
            }

            if (!string.IsNullOrEmpty(languageUpsertModel.LanguageName))
            {
                if (languageUpsertModel.LanguageName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.LanguageNameLengthExceeded
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertJobCategoriesValidation(JobCategoriesUpsertModel jobCategoriesUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert job categories Validation", "jobCategoriesUpsertModel", jobCategoriesUpsertModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(jobCategoriesUpsertModel.JobCategoryName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyJobCategoried
                });
            }

            if (!string.IsNullOrEmpty(jobCategoriesUpsertModel.JobCategoryName))
            {
                if (jobCategoriesUpsertModel.JobCategoryName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.JobCategoriesNameLengthExceeded
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertAppSettingsValidation(AppSettingsUpsertInputModel appSettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert job categories Validation", "appSettingsUpsertInputModel", appSettingsUpsertInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(appSettingsUpsertInputModel.AppSettingsName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyJobCategoried
                });
            }

            if (!string.IsNullOrEmpty(appSettingsUpsertInputModel.AppSettingsName))
            {
                if (appSettingsUpsertInputModel.AppSettingsName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.JobCategoriesNameLengthExceeded
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertCompanySettingsValidation(CompanySettingsUpsertInputModel companySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert job categories Validation", "appSettingsUpsertInputModel", companySettingsUpsertInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(companySettingsUpsertInputModel.Key))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanySettingsKey
                });
            }

            if (!string.IsNullOrEmpty(companySettingsUpsertInputModel.Key))
            {
                if (companySettingsUpsertInputModel.Key.Length > 500)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.CompanySettingsKeyNameLengthExceeded
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertSoftLabelConfigurationsValidation(UpsertSoftLabelConfigurationsModel softLabelsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert SoftLabel Validation", "softLabelsUpsertInputModel", softLabelsUpsertInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(softLabelsUpsertInputModel.ProjectLabel))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectLabel
                });
            }

            if (!string.IsNullOrEmpty(softLabelsUpsertInputModel.ProjectLabel))
            {
                if (softLabelsUpsertInputModel.ProjectLabel.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.ProjectLabelLengthExceeded
                    });
                }
            }

            if (string.IsNullOrEmpty(softLabelsUpsertInputModel.GoalLabel))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalLabel
                });
            }

            if (!string.IsNullOrEmpty(softLabelsUpsertInputModel.GoalLabel))
            {
                if (softLabelsUpsertInputModel.GoalLabel.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.GoalLabelLengthExceeded
                    });
                }
            }

            if (string.IsNullOrEmpty(softLabelsUpsertInputModel.UserStoryLabel))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryLabel
                });
            }

            if (!string.IsNullOrEmpty(softLabelsUpsertInputModel.UserStoryLabel))
            {
                if (softLabelsUpsertInputModel.UserStoryLabel.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.UserStoryLabelLengthExceeded
                    });
                }
            }

            if (string.IsNullOrEmpty(softLabelsUpsertInputModel.DeadlineLabel))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDeadlineLabel
                });
            }

            if (!string.IsNullOrEmpty(softLabelsUpsertInputModel.DeadlineLabel))
            {
                if (softLabelsUpsertInputModel.DeadlineLabel.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.DeadlineLabelLengthExceeded
                    });
                }
            }

            if (string.IsNullOrEmpty(softLabelsUpsertInputModel.ProjectsLabel))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectsLabel
                });
            }

            if (!string.IsNullOrEmpty(softLabelsUpsertInputModel.ProjectsLabel))
            {
                if (softLabelsUpsertInputModel.ProjectsLabel.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.ProjectsLabelLengthExceeded
                    });
                }
            }

            if (string.IsNullOrEmpty(softLabelsUpsertInputModel.GoalsLabel))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalsLabel
                });
            }

            if (!string.IsNullOrEmpty(softLabelsUpsertInputModel.GoalsLabel))
            {
                if (softLabelsUpsertInputModel.GoalLabel.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.GoalsLabelLengthExceeded
                    });
                }
            }

            if (string.IsNullOrEmpty(softLabelsUpsertInputModel.UserStoriesLabel))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoriesLabel
                });
            }

            if (!string.IsNullOrEmpty(softLabelsUpsertInputModel.UserStoriesLabel))
            {
                if (softLabelsUpsertInputModel.UserStoryLabel.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.UserStoriesLabelLengthExceeded
                    });
                }
            }

            if (string.IsNullOrEmpty(softLabelsUpsertInputModel.DeadlinesLabel))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDeadlinesLabel
                });
            }

            if (!string.IsNullOrEmpty(softLabelsUpsertInputModel.DeadlinesLabel))
            {
                if (softLabelsUpsertInputModel.DeadlineLabel.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.DeadlinesLabelLengthExceeded
                    });
                }
            }

            if (!string.IsNullOrEmpty(softLabelsUpsertInputModel.EstimatedTimeLabel))
            {
                if (softLabelsUpsertInputModel.EstimatedTimeLabel.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.EstimatedTimeLabelLengthExceeded
                    });
                }
            }
            if (string.IsNullOrEmpty(softLabelsUpsertInputModel.EstimatedTimeLabel))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEstimatedTimeLabel
                });
            }

            if (!string.IsNullOrEmpty(softLabelsUpsertInputModel.EstimationLabel))
            {
                if (softLabelsUpsertInputModel.DeadlineLabel.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.EstimationLabelLengthExceeded
                    });
                }
            }
            if (string.IsNullOrEmpty(softLabelsUpsertInputModel.EstimationLabel))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEstimationLabel
                });
            }

            if (!string.IsNullOrEmpty(softLabelsUpsertInputModel.EstimationsLabel))
            {
                if (softLabelsUpsertInputModel.DeadlineLabel.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.EstimationsLabelLengthExceeded
                    });
                }
            }
            if (string.IsNullOrEmpty(softLabelsUpsertInputModel.EstimationsLabel))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEstimationsLabel
                });
            }

           

            return validationMessages.Count <= 0;
        }

        public static bool GetSoftLabelByIdValidations(Guid? softLabelId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (softLabelId == Guid.Empty || softLabelId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySoftLabelId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertLeaveFrequencyValidations(LeaveFrequencyUpsertInputModel leaveFrequencyUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert leave frequency Validation", "leaveFrequencyUpsertInputModel", leaveFrequencyUpsertInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (leaveFrequencyUpsertInputModel.DateFrom == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DateShouldNotBeNull
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertLeaveFormulaValidations(LeaveFormulaUpsertInputModel leaveFormulaUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert leave frequency Validation", "leaveFrequencyUpsertInputModel", leaveFormulaUpsertInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (leaveFormulaUpsertInputModel.NoOfDays <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NoOfDaysNotNull
                });
            }
            if (leaveFormulaUpsertInputModel.NoOfLeaves <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NoOfLeavesNotNull
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertRateSheetValidation(RateSheetInputModel rateSheetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertRateSheetValidation", "rateSheetInputModel", rateSheetInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(rateSheetInputModel.RateSheetName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRateSheetName
                });
            }

            if (!string.IsNullOrEmpty(rateSheetInputModel.RateSheetName))
            {
                if (rateSheetInputModel.RateSheetName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.RateSheetNameLengthExceeded
                    });
                }
            }

            if (rateSheetInputModel.RatePerHour <= 0 && rateSheetInputModel.RatePerHourMon <= 0 && rateSheetInputModel.RatePerHourTue <= 0 && rateSheetInputModel.RatePerHourWed <= 0 && rateSheetInputModel.RatePerHourThu <= 0 && rateSheetInputModel.RatePerHourFri <= 0 && rateSheetInputModel.RatePerHourSat <= 0 && rateSheetInputModel.RatePerHourSun <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.RateSheetValueRequired
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertPeakHourValidation(PeakHourInputModel peakHourInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertPeakHourValidation", "peakHourInputModel", peakHourInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(peakHourInputModel.PeakHourOn))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPeakHourOn
                });
            }

            if (peakHourInputModel.PeakHourFrom > peakHourInputModel.PeakHourTo)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PeakHourEndTimeShouldBeGreater
                });
            }            

            if ((peakHourInputModel.PeakHourFrom.Equals(new TimeSpan(0, 0, 0))) && (peakHourInputModel.PeakHourTo.Equals(new TimeSpan(0, 0, 0))))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPeakHourFrom
                });
            } 

            //if ((peakHourInputModel.PeakHourTo.Equals(new TimeSpan(0, 0, 0))))
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyPeakHourTo
            //    });
            //}
            return validationMessages.Count <= 0;
        }

        public static bool UpsertTimeSheetSubmissionValidation(TimeSheetSubmissionUpsertInputModel timeSheetSubmissionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeSheetSubmissionValidation", "timeSheetSubmissionUpsertInputModel", timeSheetSubmissionUpsertInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (timeSheetSubmissionUpsertInputModel.ActiveFrom == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyActiveFrom
                });
            }

            if (timeSheetSubmissionUpsertInputModel.TimeSheetFrequencyId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTimeSheetFrequency
                });
            }


            return validationMessages.Count <= 0;
        }

        public static bool UpsertEmployeeTimeSheetPunchCardValidation(EmployeeTimeSheetPunchCardUpsertInputModel employeeTimeSheetPunchCardUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeSheetSubmissionValidation", "employeeTimeSheetPunchCardUpsertInputModel", employeeTimeSheetPunchCardUpsertInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (employeeTimeSheetPunchCardUpsertInputModel.Date == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDate
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool UpdateTimeSheetPunchCardValidation(TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeSheetSubmissionValidation", "timeSheetPunchCardUpDateInputModel", timeSheetPunchCardUpDateInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (timeSheetPunchCardUpDateInputModel.FromDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFromDate
                });
            }

            if (timeSheetPunchCardUpDateInputModel.ToDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyToDate
                });
            }

            if (timeSheetPunchCardUpDateInputModel.StatusId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyStatusId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertSpecificDayValidation(SpecificDayInputModel holidayInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertSpecificDayValidation", "holidayInputModel", holidayInputModel, "Master Data Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(holidayInputModel.Reason))
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptySpecificDayReason
                    });
                }

                if (holidayInputModel.Reason?.Length > AppConstants.InputWithMaxSize50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.MaximumLengthForSpecificDayReason
                    });
                }

                if (holidayInputModel.Date == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyDate
                    });
                }
            return validationMessages.Count <= 0;
        }
    }
}
