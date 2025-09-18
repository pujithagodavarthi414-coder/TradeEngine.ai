using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Goals;
 
using BTrak.Common;
 
namespace Btrak.Services.Helpers.UserStory
{
    public class UserStoryReplanValidations
    {
        public static bool ValidateGoalReplanHistory(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, GoalSearchCriteriaInputModel goalSearchCriteriaInputModel)
        {
            CommonValidationHelper.ValidateSearchCriteria(loggedInContext, goalSearchCriteriaInputModel, validationMessages);
 
            if (goalSearchCriteriaInputModel.GoalId == Guid.Empty || goalSearchCriteriaInputModel.GoalId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalId
                });
            }
 
            return validationMessages.Count <= 0;
        }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
    }
}