using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.WorkFlow;
using BTrak.Common;

namespace Btrak.Services.Helpers.WorkFlow
{
    public static class WorkFlowValidations
    {
        public static bool ValidateUpsertWorkFlow(WorkFlowUpsertInputModel workFlowUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(workFlowUpsertInputModel.WorkFlowName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyWorkFlowName)
                });
            }

            if (workFlowUpsertInputModel.WorkFlowName?.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForWorkFlowName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateWorkFlowById(Guid? workFlowId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (workFlowId == Guid.Empty || workFlowId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyWorkFlowId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateWorkFlowFoundWithId(Guid? workFlowId, List<ValidationMessage> validationMessages, WorkFlowApiReturnModel workFlowSpReturnModel)
        {
            if (workFlowSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundWorkFlowWithTheId, workFlowId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
