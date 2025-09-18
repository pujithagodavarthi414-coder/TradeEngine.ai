using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models.WorkFlow;

namespace Btrak.Services.Helpers.WorkFlow
{
    public static class WorkFlowStatusValidations
    {
        public static bool ValidateUpsertWorkFlowStatus(WorkFlowStatusUpsertInputModel workFlowStatusUpsertInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (workFlowStatusUpsertInputModel.WorkFlowId == Guid.Empty || workFlowStatusUpsertInputModel.WorkFlowId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyWorkFlowId)
                });
            }

            if (workFlowStatusUpsertInputModel.StatusId?.Count == 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyStatusId)
                });
            }
            
            return validationMessages.Count <= 0;
        }

        public static bool ValidateWorkFlowStatusById(Guid? workFlowStatusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (workFlowStatusId == Guid.Empty || workFlowStatusId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyWorkFlowStatusId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateWorkFlowStatusFoundWithId(Guid? workFlowStatusId, List<ValidationMessage> validationMessages, WorkFlowStatusApiReturnModel workFlowStatusSpReturnModel)
        {
            if (workFlowStatusSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundWorkFlowStatusWithTheId, workFlowStatusId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
