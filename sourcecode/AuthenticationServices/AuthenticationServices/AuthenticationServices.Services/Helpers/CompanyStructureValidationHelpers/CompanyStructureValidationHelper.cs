using AuthenticationServices.Common;
using AuthenticationServices.Common.Texts;
using AuthenticationServices.Models;
using AuthenticationServices.Models.CompanyStructure;
using AuthenticationServices.Models.Modules;
using System;
using System.Collections.Generic;

namespace AuthenticationServices.Services.Helpers.CompanyStructureValidationHelpers
{
    public class CompanyStructureValidationHelper
    {
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

            if (companyInputModel.LastName != null && companyInputModel.LastName.Length > 250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.LastNameLengthCannotExceedThan250characters
                });
            }

            if (companyInputModel.CompanyName != null && companyInputModel.CompanyName.Length > 800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.CompanyNameLengthCannotExceedThan800characters
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

        public static bool ArchiveCompany(ArchiveCompanyInputModel archiveCompanyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ArchiveCompany", "archiveCompanyInputModel", archiveCompanyInputModel, "CompanyStructure Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (archiveCompanyInputModel == null)
            {
                archiveCompanyInputModel = new ArchiveCompanyInputModel();
            }

            if (archiveCompanyInputModel.CompanyId ==  null || archiveCompanyInputModel.CompanyId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCompanyId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertModulePageValidations(ModulePageUpsertInputModel modulePageInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompany", "companyInputModel", modulePageInputModel, "CompanyStructure Validation Helper"));

            if (modulePageInputModel == null)
            {
                modulePageInputModel = new ModulePageUpsertInputModel();
            }

            if (string.IsNullOrEmpty(modulePageInputModel.PageName) && modulePageInputModel.IsNewPage == false)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyModulePageName
                });
            }

            if (modulePageInputModel.PageName != null && modulePageInputModel.PageName.Length > 250 && modulePageInputModel.IsNewPage == false)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.PageNameExceptionLength
                });
            }

            if (modulePageInputModel.ModuleId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyModuleId
                });
            }
            return validationMessages.Count <= 0;
        }
    }
}
