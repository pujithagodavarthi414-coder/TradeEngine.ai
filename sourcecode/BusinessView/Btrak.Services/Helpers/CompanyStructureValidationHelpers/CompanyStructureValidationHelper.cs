using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using BTrak.Common;
using BTrak.Common.Texts;

namespace Btrak.Services.Helpers.CompanyStructureValidationHelpers
{
    public class CompanyStructureValidationHelper
    {
        public static bool GetIndustryByIdValidation(Guid? industryId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetIndustryByIdValidation", "industryId", industryId, "CompanyStructure Validation Helper"));
           
            if (industryId == null || industryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyIndustryId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetMainUseCaseByIdValidation(Guid? mainUseCaseId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMainUseCaseByIdValidation", "mainUseCaseId", mainUseCaseId, "CompanyStructure Validation Helper"));
          
            if (mainUseCaseId == null || mainUseCaseId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyMainUseCaseId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool DeleteCompanyModule(DeleteCompanyModuleModel deleteCompanyModuleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteCompanyModule", "deleteCompanyModuleModel", deleteCompanyModuleModel, "CompanyStructure Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (deleteCompanyModuleModel == null)
            {
                deleteCompanyModuleModel = new DeleteCompanyModuleModel();
            }

            if (deleteCompanyModuleModel.CompanyModuleId == null || deleteCompanyModuleModel.CompanyModuleId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyModuleId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool DeleteCompanyTestData(DeleteCompanyTestDataModel deleteCompanyTestDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteCompanyTestData", "deleteCompanyTestDataModel", deleteCompanyTestDataModel, "CompanyStructure Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (deleteCompanyTestDataModel == null)
            {
                deleteCompanyTestDataModel = new DeleteCompanyTestDataModel();
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertIndustryModuleValidation(IndustryModuleInputModel industryModuleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertIndustryModuleValidation", "industryModuleInputModel", industryModuleInputModel, "CompanyStructure Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (industryModuleInputModel == null)
            {
                industryModuleInputModel = new IndustryModuleInputModel();
            }

            if (industryModuleInputModel.IndustryId == null || industryModuleInputModel.IndustryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyIndustryId
                });
            }

            if (industryModuleInputModel.ModuleId == null || industryModuleInputModel.ModuleId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyModuleId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetIndustryModuleByIdValidation(Guid? industryModuleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetIndustryModuleByIdValidation", "industryModuleId", industryModuleId, "CompanyStructure Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (industryModuleId == null || industryModuleId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyIndustryModuleId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetNumberFormatByIdValidation(Guid? numberFormatId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetNumberFormatByIdValidation", "numberFormatId", numberFormatId, "CompanyStructure Validation Helper"));
          
            if (numberFormatId == null || numberFormatId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyNumberFormatId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetDateFormatByIdValidation(Guid? dateFormatId,  List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetDateFormatByIdValidation", "dateFormatId", dateFormatId, "CompanyStructure Validation Helper"));
           
            if (dateFormatId == null || dateFormatId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDateFormatId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetTimeFormatByIdValidation(Guid? timeFormatId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTimeFormatByIdValidation", "timeFormatId", timeFormatId, "CompanyStructure Validation Helper"));
          
            if (timeFormatId == null || timeFormatId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTimeFormatId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertCompany(CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompany", "companyInputModel", companyInputModel, "CompanyStructure Validation Helper"));
            
            if (companyInputModel == null)
            {
                companyInputModel = new CompanyInputModel();
            }

            if (string.IsNullOrEmpty(companyInputModel.CompanyName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.CompanyNameShouldNotBeNull
                });
            }

            if (companyInputModel.SiteAddress != null && companyInputModel.SiteAddress.Length > 800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.SiteAddressLengthCannotExceedThan800characters
                });
            }

            if (companyInputModel.FirstName != null && companyInputModel.FirstName.Length > 250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.FirstNameLengthCannotExceedThan250characters
                });
            }

            if (companyInputModel.LastName!= null && companyInputModel.LastName.Length > 250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.LastNameLengthCannotExceedThan250characters
                });
            }

            if (companyInputModel.CompanyName !=null && companyInputModel.CompanyName.Length > 800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.CompanyNameLengthCannotExceedThan800characters
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetCompanyByIdValidation(Guid? companyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyByIdValidation", "companyId", companyId, "CompanyStructure Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (companyId == null || companyId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetIntroducedByOptionById(Guid? introducedByOptionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetIntroducedByOptionById", "introducedByOptionId", introducedByOptionId, "CompanyStructure Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (introducedByOptionId == null || introducedByOptionId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyIntroducedByOptionId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
