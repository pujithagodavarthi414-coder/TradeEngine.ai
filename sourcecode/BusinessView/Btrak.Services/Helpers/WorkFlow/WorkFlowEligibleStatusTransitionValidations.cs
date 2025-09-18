using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models.WorkFlow;

namespace Btrak.Services.Helpers.WorkFlow
{
    public static class WorkFlowEligibleStatusTransitionValidations
    {
        public static bool ValidateUpsertWorkFlowEligibleStatusTransition(WorkFlowEligibleStatusTransitionUpsertInputModel workFlowEligibleStatusTransitionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (workFlowEligibleStatusTransitionUpsertInputModel.WorkFlowId == Guid.Empty || workFlowEligibleStatusTransitionUpsertInputModel.WorkFlowId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyWorkFlowId)
                });
            }

            if (workFlowEligibleStatusTransitionUpsertInputModel.FromWorkflowUserStoryStatusId == Guid.Empty || workFlowEligibleStatusTransitionUpsertInputModel.FromWorkflowUserStoryStatusId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFromWorkFlowUserStoryStatusId)
                });
            }

            if (workFlowEligibleStatusTransitionUpsertInputModel.ToWorkflowUserStoryStatusId == Guid.Empty || workFlowEligibleStatusTransitionUpsertInputModel.ToWorkflowUserStoryStatusId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyToWorkFlowUserStoryStatusId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateWorkFlowEligibleStatusTransitionById(Guid? workFlowStatusTransitionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (workFlowStatusTransitionId == Guid.Empty || workFlowStatusTransitionId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyWorkFlowEligibleStatusTransitionWithTheId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateWorkFlowEligibleStatusTransitionFoundWithId(Guid? workFlowStatusTransitionId, List<ValidationMessage> validationMessages, WorkFlowEligibleStatusTransitionApiReturnModel workFlowEligibleStatusTransitionSpReturnModel)
        {
            if (workFlowEligibleStatusTransitionSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundWorkFlowEligibleStatusTransitionWithTheId, workFlowStatusTransitionId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
