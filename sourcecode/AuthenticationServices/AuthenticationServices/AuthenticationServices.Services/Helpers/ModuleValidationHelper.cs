using AuthenticationServices.Common;
using AuthenticationServices.Common.Texts;
using AuthenticationServices.Models;
using AuthenticationServices.Models.Modules;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Services.Helpers
{
    public class ModuleValidationHelper
    {
        public static bool UpsertModule(ModuleUpsertInputModel moduleInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertModule", "ModuleUpsertInputModel", moduleInputModel, "Module Validation Helper"));

            if (moduleInputModel == null)
            {
                moduleInputModel = new ModuleUpsertInputModel();
            }

            if (string.IsNullOrEmpty(moduleInputModel.ModuleName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyModuleName
                });
            }

            
            if (moduleInputModel.ModuleName != null && moduleInputModel.ModuleName.Length > 250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.ModuleNameLengthExceeded
                });
            }

           

            return validationMessages.Count <= 0;
        }
    }
}
