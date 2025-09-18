using System;
using System.Collections.Generic;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.ActTracker;

namespace Btrak.Services.Helpers.ActTrrackerValidationHelper
{
    public static class ActTrackerValidationHelper
    {
        public static bool ActTrackerRoleConfigurationValidation(ActTrackerRoleConfigurationUpsertInputModel actTrackerRoleConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertActTrackerRoleConfiguration", "actTrackerRoleConfigurationUpsertInputModel", actTrackerRoleConfigurationUpsertInputModel, "ActTrackerService"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (actTrackerRoleConfigurationUpsertInputModel.AppUrlId== null || actTrackerRoleConfigurationUpsertInputModel.AppUrlId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyAppUrlId
                });
            }

            if (actTrackerRoleConfigurationUpsertInputModel.RoleId.Count<=0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRoleIds
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool ActTrackerScreenSHotFrequencyValidation(ActTrackerScreenShotFrequencyUpsertInputModel actTrackerScreenShotFrequencyUpsertInputModel , LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertActTrackerScreenSHotFrequency", "actTrackerScreenShotFrequencyUpsertInputModel", actTrackerScreenShotFrequencyUpsertInputModel, "ActTrackerService"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (actTrackerScreenShotFrequencyUpsertInputModel.ScreenShotFrequency == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyScreenShotFrequency
                });
            }

            if (actTrackerScreenShotFrequencyUpsertInputModel.RoleIds == null || actTrackerScreenShotFrequencyUpsertInputModel.RoleIds.Count <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRoleIds
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool ActTrackerRolePermissionValidation(ActTrackerRolePermissionUpsertInputModel actTrackerRolePermissionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertActTrackerRolePermission", "actTrackerRolePermissionUpsertInputModel", actTrackerRolePermissionUpsertInputModel, "ActTrackerService"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            //if (actTrackerRolePermissionUpsertInputModel.RoleId.Count <= 0)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.NotEmptyRoleIds
            //    });
            //}

            if (actTrackerRolePermissionUpsertInputModel.IsIdleTime == true)
            {
                if (actTrackerRolePermissionUpsertInputModel.IdleScreenShotCaptureTime == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyIdleScreenShotCaptureTime
                    });
                }

                if (actTrackerRolePermissionUpsertInputModel.IdleAlertTime == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyIdleAlertTime
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool ActTrackerAppUrlsValidation(ActTrackerAppUrlsUpsertInputModel actTrackerAppUrlsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertActTrackerRolePermission", "actTrackerAppUrlsUpsertInputModel", actTrackerAppUrlsUpsertInputModel, "ActTrackerService"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (actTrackerAppUrlsUpsertInputModel.AppUrlTypeId==null || actTrackerAppUrlsUpsertInputModel.AppUrlTypeId==Guid.Empty)
            {
                //validationMessages.Add(new ValidationMessage
                //{
                //    ValidationMessageType = MessageTypeEnum.Error,
                //    ValidationMessaage = ValidationMessages.NotEmptyAppUrlId
                //});
            }

            if (actTrackerAppUrlsUpsertInputModel.AppUrlName == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyIdleAlertTime
                });
            }


            if (actTrackerAppUrlsUpsertInputModel != null && actTrackerAppUrlsUpsertInputModel.ProductiveRoleIds?.Count <= 0 
                 && actTrackerAppUrlsUpsertInputModel.UnproductiveRoleIds?.Count <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRoleIds
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
