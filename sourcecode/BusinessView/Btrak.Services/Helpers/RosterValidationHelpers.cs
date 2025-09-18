using Btrak.Models;
using Btrak.Models.Roster;
using BTrak.Common;
using BTrak.Common.Texts;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Helpers
{
    public class RosterValidationHelpers
    {
        public List<ValidationMessage> CreateRosterSolutions(RosterInputModel rosterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Create Roster Solutions validating LoggedInUser", "Roster Validation Helpers"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (rosterInputModel.rosterBasicDetails == null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Create Roster Solutions validating Basic details", "Roster Validation Helpers"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyBasicDetails
                });
            }

            if (rosterInputModel.workingDays.Count <= 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Create Roster Solutions validating total working days", "Roster Validation Helpers"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyWeekdays
                });
            }

            return validationMessages;
        }

        public List<ValidationMessage> CreateRosterPlan(RosterPlanSolution rosterPlanSolution, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Create Roster Plan validating LoggedInUser", "Roster Validation Helpers"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (rosterPlanSolution.RequestId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Create Roster Plan validating request id", "Roster Validation Helpers"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyRequestId
                });
            }

            if (rosterPlanSolution.Plans.Count <= 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Create Roster Plan validating plans", "Roster Validation Helpers"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = LangText.NotEmptyRosterPlans
                });
            }

            return validationMessages;
        }
    }
}
