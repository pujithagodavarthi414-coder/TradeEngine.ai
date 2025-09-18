using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.BoardType;
using BTrak.Common;

namespace Btrak.Services.Helpers.BoardType
{
    public class BoardTypeApiValidations
    {
        public static bool ValidateBoardTypeApiFoundWithId(Guid? boardTypeApiId, List<ValidationMessage> validationMessages, BoardTypeApiApiReturnModel boardTypeApiSpReturnModel)
        {
            if (boardTypeApiSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundBoardTypeApiWithTheId, boardTypeApiId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertBoardTypeApi(BoardTypeApiUpsertInputModel boardTypeApiUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(boardTypeApiUpsertInputModel.ApiName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyBoardTypeApiName)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateBoardTypeApiById(Guid? boardTypeApiId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (boardTypeApiId == Guid.Empty || boardTypeApiId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyBoardTypeApiId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
