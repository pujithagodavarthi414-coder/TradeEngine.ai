using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Role;
using BTrak.Common;

namespace Btrak.Services.Helpers.RolesValidationHelpers
{
    public class RolesValidationHelper
    {
        public static bool UpsertRoleValidation(RolesInputModel rolesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertRoleValidation", "rolesInputModel", rolesInputModel, "Roles Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(rolesInputModel.RoleName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyRoleName)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool DeleteRoleValidation(RolesInputModel rolesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteRoleValidation", "rolesInputModel", rolesInputModel, "Roles Validation Helper"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (rolesInputModel.RoleId == Guid.Empty || rolesInputModel.RoleId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyRoleId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetRoleDetailsByIdValidation(Guid? roleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetRoleDetailsByIdValidation", "roleId", roleId, "Roles Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (roleId == Guid.Empty || roleId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyRoleId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateRoleFoundWithId(Guid? roleId, List<ValidationMessage> validationMessages, RolesOutputModel roleModel)
        {
            if (roleModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundRoleWithTheId, roleId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
