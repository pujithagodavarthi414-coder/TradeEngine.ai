using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.ConfigurationType;
using Btrak.Models.Sprints;
using Btrak.Models.UserStory;
using BTrak.Common;

namespace Btrak.Services.Helpers.UserStoryValidationHelpers
{
    public class UserStoryValidationHelper
    {
        public static bool ValidateUpsertUserStory(UserStoryUpsertInputModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            
            if (string.IsNullOrEmpty(userStoryUpsertInputModel.UserStoryName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryName
                });
            }

            if (userStoryUpsertInputModel.UserStoryName?.Length > AppConstants.InputWithMaxSize800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForUserStoryName
                });
            }
            if (userStoryUpsertInputModel.IsReplan == true)
            {
                if (userStoryUpsertInputModel.GoalReplanId == Guid.Empty || userStoryUpsertInputModel.GoalReplanId == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyGoalReplanTypeId
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertUserStoryLink(UserStoryLinkUpsertModel userStoryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (userStoryUpsertInputModel.UserStoryId == null || userStoryUpsertInputModel.UserStoryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
            }

            if (userStoryUpsertInputModel.LinkUserStoryTypeId == null || userStoryUpsertInputModel.LinkUserStoryTypeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryLinkTypeId
                });
            }
            if (userStoryUpsertInputModel.LinkUserStoryId == null || userStoryUpsertInputModel.LinkUserStoryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryLinkId
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool ValidateGetCommentsCountByUserStoryId(Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (userStoryId == null || userStoryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUserStoryWithSameName(UserStoryUpsertInputModel userStoryUpsertInputModel, List<ValidationMessage> validationMessages, List<UserStorySpReturnModel> uerStorySpReturnModels)
        {
            if (uerStorySpReturnModels != null && uerStorySpReturnModels.Count > 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.AlreadyExistUserStoryWithTheName, userStoryUpsertInputModel.UserStoryName)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUserStoryById(Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (userStoryId == Guid.Empty || userStoryId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static string ValidateUserStoriesByGoals(List<Guid> goalIds, List<ValidationMessage> validationMessages)
        {
            string goalXml;

            if (goalIds != null && goalIds.Count > 0)
            {
                goalXml = Utilities.ConvertIntoListXml(goalIds);
            }
            else
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalIds
                });

                return null;
            }

            return goalXml;
        }

        public static bool ValidateUserStoryFoundWithId(Guid? userStoryId, List<ValidationMessage> validationMessages, UserStorySpReturnModel userStorySpReturnModel)
        {
            if (userStorySpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundUserStoryWithTheId, userStoryId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUserStoryFoundWithId(Guid? userStoryId, List<ValidationMessage> validationMessages, UserStoryApiReturnModel oldUserStoryUpsertInputModel)
        {
            if (oldUserStoryUpsertInputModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundUserStoryWithTheId, userStoryId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateSprintUserStoryFoundWithId(Guid? userStoryId, List<ValidationMessage> validationMessages, SprintSearchOutPutModel oldUserStoryUpsertInputModel)
        {
            if (oldUserStoryUpsertInputModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundUserStoryWithTheId, userStoryId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateInsertMultipleUserStoriesUsingFile(Guid? goalId, string filePath, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (goalId == null || goalId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalId
                });
            }

            if (string.IsNullOrEmpty(filePath))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFilePath
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertMultipleUserStoriesValidation(UserStoryUpsertInputModel userStoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertMultipleUserStoriesValidation", "userStoryModel", userStoryModel, "UserStoryValidationHelper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (((userStoryModel.IsFromTemplate == false  || userStoryModel.IsFromTemplate == null) && (userStoryModel.IsFromSprint == null || userStoryModel.IsFromSprint == false)) && userStoryModel.GoalId == null || userStoryModel.GoalId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalId
                });
            }

            if (userStoryModel.IsFromTemplate == true && userStoryModel.TemplateId == null || userStoryModel.TemplateId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTemplateId
                });
            }

            if (userStoryModel.IsFromSprint == true && userStoryModel.SprintId == null || userStoryModel.SprintId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySprintId
                });
            }

            if (userStoryModel.MultipleUserStoryName == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryName
                });
            }

            if (userStoryModel.IsReplan == true)
            {
                if (userStoryModel.GoalReplanId == Guid.Empty || userStoryModel.GoalReplanId == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyGoalReplanTypeId
                    });
                }
            }

            if (userStoryModel.MultipleUserStoryName != null)
                foreach (var multipleUserStoryName in userStoryModel.MultipleUserStoryName)
                {
                    if (multipleUserStoryName.Length > AppConstants.InputWithMaxSize800)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = ValidationMessages.MaximumLengthForUserStoryName
                        });
                    }
                }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertMultipleUserStoriesBasedOnConfigurationValidation(UserStoryUpsertInputModel userStoryModel, List<ConfigurationTypeApiReturnModel> fields, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertMultipleUserStoriesBasedOnConfigurationValidation", "userStoryModel", userStoryModel, "UserStoryValidationHelper"));

            foreach (var field in fields)
            {
                if (field.FieldId == AppConstants.UserStoryNameGuid && string.IsNullOrEmpty(userStoryModel.UserStoryName))
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = field.FieldName + " is required"
                    });
                }

                if (field.FieldId == AppConstants.UserStoryEstimatedTimeGuid && (userStoryModel.EstimatedTime == null || userStoryModel.EstimatedTime <= 0))
                {
                    if (userStoryModel.EstimatedTime == null)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = field.FieldName + " is required"
                        });
                    }

                    if (userStoryModel.EstimatedTime <= 0)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = field.FieldName + " should be greater than zero"
                        });
                    }
                }

                if (field.FieldId == AppConstants.UserStoryDeadLineGuid && userStoryModel.DeadLineDate == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = field.FieldName + " is required"
                    });
                }
                if (field.FieldId == AppConstants.UserStoryOwnerGuid && (userStoryModel.OwnerUserId == null || userStoryModel.OwnerUserId == Guid.Empty))
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = field.FieldName + " is required"
                    });
                }
                if (field.FieldId == AppConstants.UserStoryDependencyGuid && (userStoryModel.DependencyUserId == null || userStoryModel.DependencyUserId == Guid.Empty))
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = field.FieldName + " is required"
                    });
                }
                if (field.FieldId == AppConstants.UserStoryStatusGuid && (userStoryModel.UserStoryStatusId == null || userStoryModel.UserStoryStatusId == Guid.Empty))
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = field.FieldName + " is required"
                    });
                }
                if (field.FieldId == AppConstants.UserStoryBugPriorityGuid && (userStoryModel.BugPriorityId == null || userStoryModel.BugPriorityId == Guid.Empty))
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = field.FieldName + " is required"
                    });
                }
                if (field.FieldId == AppConstants.UserStoryBugCausedUserGuid && (userStoryModel.BugCausedUserId == null || userStoryModel.BugCausedUserId == Guid.Empty))
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = field.FieldName + " is required"
                    });
                }
                if (field.FieldId == AppConstants.ProjectFeatureGuid && (userStoryModel.ProjectFeatureId == null || userStoryModel.ProjectFeatureId == Guid.Empty))
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = field.FieldName + " is required"
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateArchiveUserStory(ArchiveUserStoryInputModel archiveUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (archiveUserStoryInputModel.UserStoryId == null || archiveUserStoryInputModel.UserStoryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateParkUserStory(ParkUserStoryInputModel parkUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (parkUserStoryInputModel.UserStoryId == null || parkUserStoryInputModel.UserStoryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateGetUserStoryHistory(Guid userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (userStoryId == null || userStoryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateAmendUserStoriesDeadline(UserStoryAmendInputModel userStoryAmmendInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (userStoryAmmendInputModel.UserStoryIds == null || userStoryAmmendInputModel.UserStoryIds.Count <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryIds
                });
            }

            if (userStoryAmmendInputModel.AmendedDaysCount == null || userStoryAmmendInputModel.AmendedDaysCount <= 0)
            {
                if (userStoryAmmendInputModel.AmendedDaysCount == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyAmendedDays
                    });
                }

                if (userStoryAmmendInputModel.AmendedDaysCount <= 0)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotAmendedDaysLessThanZero
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool SearchUserStoryDetails(UserStorySearchCriteriaInputModel userStorySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if ((userStorySearchCriteriaInputModel.UserStoryId == null || userStorySearchCriteriaInputModel.UserStoryId == Guid.Empty) &&
                string.IsNullOrEmpty(userStorySearchCriteriaInputModel.SearchText))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryAndNumber
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertUserStoryTags(UserStoryTagUpsertInputModel userStoryTagUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (userStoryTagUpsertInputModel.UserStoryId == null || userStoryTagUpsertInputModel.UserStoryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateSearchUserStoryTags(UserStoryTagSearchInputModel userStoryTagSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (userStoryTagSearchInputModel.UserStoryId == null || userStoryTagSearchInputModel.UserStoryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ArchiveCompletedUserStories(ArchiveCompletedUserStoryInputModel archiveCompletedUserStoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if ((archiveCompletedUserStoryInputModel.GoalId == null || archiveCompletedUserStoryInputModel.GoalId == Guid.Empty) && (archiveCompletedUserStoryInputModel.IsFromSprint == false || archiveCompletedUserStoryInputModel.IsFromSprint == null))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalId
                });
            }

            if ((archiveCompletedUserStoryInputModel.SprintId == null || archiveCompletedUserStoryInputModel.SprintId == Guid.Empty) && archiveCompletedUserStoryInputModel.IsFromSprint == true)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySprintId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpdateMultipleUserStoriesGoal(UpdateMultipleUserStoriesGoalInputModel updateMultipleUserStoriesGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(updateMultipleUserStoriesGoalInputModel.UserStoryIds))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryIds
                });
            }

            if (updateMultipleUserStoriesGoalInputModel.GoalId == null || updateMultipleUserStoriesGoalInputModel.GoalId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpdateGoalUserStoryToSprint(Guid? sprintId, Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (sprintId == null || sprintId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySprintId
                });
            }

            if (userStoryId == null || userStoryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetSprintsBugReport(BugReportSearchInputModel bugReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (bugReportInputModel.SprintId == null || bugReportInputModel.SprintId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySprintId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
