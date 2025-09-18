using System;
using Btrak.Models;
using Btrak.Models.Work;
using BTrak.Common;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.WorkFlow
{
    public static class WorkServiceValidations
    {
        public static bool UpsertWorkValidations(WorkUpsertInputModel workUpsertInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (string.IsNullOrEmpty(workUpsertInputModel.WorkJson))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.WorkJsonDataIsRequired)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetWorkByIdValidations(Guid? workId, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            if (workId == null || workId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.WorkIdIsRequired)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
