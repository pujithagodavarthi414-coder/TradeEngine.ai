using System;
using Btrak.Models;
using Btrak.Models.Goals;
using BTrak.Common;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.Goals
{
    public static class GoalServiceValidation
    {
        public static bool UpsertGoalValidations(GoalUpsertInputModel goalUpsertInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (goalUpsertInputModel.ProjectId == null || goalUpsertInputModel.ProjectId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            if (string.IsNullOrEmpty(goalUpsertInputModel.GoalName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalName
                });
            }

            if (goalUpsertInputModel.GoalName?.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForGoalName
                });
            }

            if (string.IsNullOrEmpty(goalUpsertInputModel.GoalShortName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalShortName
                });
            }

            if (string.IsNullOrEmpty(goalUpsertInputModel.GoalShortName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalShortName
                });
            }

            if (goalUpsertInputModel.GoalShortName?.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForGoalShortName
                });
            }

            if (goalUpsertInputModel.GoalResponsibleUserId == null || goalUpsertInputModel.GoalResponsibleUserId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalResponsiblePerson
                });
            }

            if (goalUpsertInputModel.BoardTypeId == null || goalUpsertInputModel.BoardTypeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyBoardType
                });
            }

            if (goalUpsertInputModel.BoardTypeId != null && goalUpsertInputModel.BoardTypeId != Guid.Empty)
            {
                if (goalUpsertInputModel.BoardTypeId == AppConstants.BoardTypeApi)
                {
                    if (goalUpsertInputModel.BoardTypeApiId == null || goalUpsertInputModel.BoardTypeApiId == Guid.Empty)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = ValidationMessages.NotEmptyBoardTypeApi
                        });
                    }
                }
              
            }

            if (goalUpsertInputModel.OnboardProcessDate == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyOnboardDate
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetGoalByIdValidations(Guid? goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (goalId == Guid.Empty || goalId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool SearchGoalDetails(SearchGoalDetailsInputModel searchGoalDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if ((searchGoalDetailsInputModel.GoalId == null || searchGoalDetailsInputModel.GoalId == Guid.Empty) &&
                string.IsNullOrEmpty(searchGoalDetailsInputModel.GoalUniqueName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalAndNumber
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertGoalTags(GoalTagUpsertInputModel goalTagUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (goalTagUpsertInputModel.GoalId == null || goalTagUpsertInputModel.GoalId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertGoalFilter(UpsertGoalFilterModel goalFilterUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(goalFilterUpsertInputModel.GoalFilterName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalFilterName
                });
            }

            return validationMessages.Count <= 0;
        }


        public static bool ValidateSearchGoalTags(GoalTagSearchInputModel goalTagSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (goalTagSearchInputModel.GoalId == null || goalTagSearchInputModel.GoalId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateGoalId(Guid? goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (goalId == Guid.Empty || goalId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalId
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool ValidateGoalAndDeveloperId(Guid? goalId,Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (goalId == Guid.Empty || goalId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalId
                });
            }

            if (userId == Guid.Empty || userId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserId
                });
            }
            return validationMessages.Count <= 0;
        }
    }
}