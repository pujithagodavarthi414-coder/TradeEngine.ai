using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.EntityType;
using BTrak.Common;

namespace Btrak.Services.Helpers.EntityType
{
    public class EntityRoleFeatureValidations
    {
        public static bool ValidateUpsertEntityRoleFeature(EntityRoleFeatureUpsertInputModel entityRoleFeatureUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (entityRoleFeatureUpsertInputModel.EntityRoleId == null || entityRoleFeatureUpsertInputModel.EntityRoleId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEntityRoleId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
