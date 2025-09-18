using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.BoardType;
using BTrak.Common;

namespace Btrak.Services.Helpers.BoardType
{
    public class BoardTypeValidations
    {
        public static bool ValidateBoardTypeFoundWithId(Guid? boardTypeId, List<ValidationMessage> validationMessages, BoardTypeApiReturnModel boardTypeSpReturnModel)
        {
            if (boardTypeSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundBoardTypeWithTheId, boardTypeId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertBoardType(BoardTypeUpsertInputModel boardTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(boardTypeUpsertInputModel.BoardTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyBoardTypeName
                });
            }

            if (boardTypeUpsertInputModel.BoardTypeName?.Length > AppConstants.InputWithMaxSize800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForBoardTypeName
                });
            }

            if (boardTypeUpsertInputModel.BoardTypeUiId == Guid.Empty || boardTypeUpsertInputModel.BoardTypeUiId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyBoardTypeUi
                });
            }

            if (boardTypeUpsertInputModel.WorkFlowId == Guid.Empty || boardTypeUpsertInputModel.WorkFlowId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyWorkFlowId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateBoardTypeById(Guid? boardTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (boardTypeId == Guid.Empty || boardTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyBoardTypeId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
