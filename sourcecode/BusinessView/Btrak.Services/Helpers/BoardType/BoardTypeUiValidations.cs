using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.BoardType;
using BTrak.Common;

namespace Btrak.Services.Helpers.BoardType
{
    public class BoardTypeUiValidations
    {
        public static bool ValidateBoardTypeUiFoundWithId(Guid? boardTypeUiId, List<ValidationMessage> validationMessages, BoardTypeUiApiReturnModel boardTypeUiApiReturnModel)
        {
            if (boardTypeUiApiReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundBoardTypeUiWithTheId, boardTypeUiId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
