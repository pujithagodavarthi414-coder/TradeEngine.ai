using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Branch;
using BTrak.Common;

namespace Btrak.Services.Helpers.Branch
{
    public class BranchValidations
    {
        public static bool ValidateUpsertBranch(BranchUpsertInputModel branchUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(branchUpsertInputModel.BranchName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyBranchName
                });
            }

            if (branchUpsertInputModel.BranchName?.Length > AppConstants.InputWithMaxSize800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForBranchName
                });
            }

            //if (branchUpsertInputModel.RegionId == null || branchUpsertInputModel.RegionId == Guid.Empty)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyRegionId
            //    });
            //}

            return validationMessages.Count <= 0;
        }
    }
}
