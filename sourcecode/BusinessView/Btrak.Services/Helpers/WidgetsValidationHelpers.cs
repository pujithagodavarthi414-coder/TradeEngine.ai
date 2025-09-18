using Btrak.Models;
using Btrak.Models.Widgets;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Helpers
{
    public class WidgetsValidationHelpers
    {
        public static bool UpsertWidgetValidations(WidgetInputModel widgetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Widget Validation", "WidgetModel", widgetModel, "Widget Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(widgetModel.WidgetName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "widget name is required", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.WidgetNameRequired
                });

                return false;
            }
            if (widgetModel.WidgetName.Length > 50)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "widget name length exceeded", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.WidgetNameLengthExceeded
                });
            }

            if (!string.IsNullOrEmpty(widgetModel.Description) && widgetModel.Description.Length > 1000)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Description length exceeded", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DescriptionLengthExceeded
                });
            }

            if (widgetModel.SelectedRoleIds != null && widgetModel.SelectedRoleIds.Count == 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Role was not selected", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRoleId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertCustomWidgetValidations(CustomWidgetsInputModel widgetModel, bool isFromValidator, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Widget Validation", "WidgetModel", widgetModel, "Widget Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(widgetModel.CustomWidgetName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "custom widget name is required", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.CustomWidgetNameRequired
                });

                return false;
            }
          
            if (widgetModel.CustomWidgetName.Length > 50)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "custom widget name length exceeded", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.CustomWidgetNameLengthExceeded
                });
            }

            if (!string.IsNullOrEmpty(widgetModel.Description) && widgetModel.Description.Length > 1000)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "custom widget description length exceeded", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.CustomWidgetDescriptionLengthExceeded
                });
            }
            if (widgetModel.SelectedRoleIds != null && widgetModel.SelectedRoleIds.Count == 0)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Role was not selected", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRoleId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertWorkspaceValidations(WorkspaceInputModel workspaceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Workspace Validation", "workspaceModel", workspaceModel, "Widget Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(workspaceModel.WorkspaceName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Workspace name is required", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.WorkspaceNameRequired
                });

                return false;
            }
            if (workspaceModel.WorkspaceName.Length > 50)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Workspace name length exceeded", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.WorkspaceNameLengthExceeded
                });
            }

            if (!string.IsNullOrEmpty(workspaceModel.Description) && workspaceModel.Description.Length > 250)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Description length exceeded", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DescriptionLengthExceeded
                });
            }

            if (string.IsNullOrEmpty(workspaceModel.SelectedRoleIds) && string.IsNullOrWhiteSpace(workspaceModel.SelectedRoleIds) && !workspaceModel.IsFromExport)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Role was not selected", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyRoleId
                });
            }


            return validationMessages.Count <= 0;
        }
        
        public static void WorkspaceIdValidations(Guid? workspaceId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "workspaceId validating LoggedInUser", "Widget Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (workspaceId == null || workspaceId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.WorkspaceIdRequired
                });
            }
        }

        public static void UpdateDashboardNameValidations(DashboardModel dashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "workspaceId validating LoggedInUser", "Widget Service"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (dashboardModel.DashboardId == null || dashboardModel.DashboardId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DashboardIdRequired
                });
            }

            if (string.IsNullOrEmpty(dashboardModel.DashboardName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.DashboardNameRequired
                });
            }
        }

        public static bool UpsertProcInputsAndOuputs(ProcInputsAndOutputModel procInputsAndOutputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Inputs And Outputs Validation", "procInputsAndOutputModel", procInputsAndOutputModel, "Widget Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(procInputsAndOutputModel.ProcName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "proc name is required", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.WidgetNameRequired
                });

                return false;
            }

            if (procInputsAndOutputModel.CustomWidgetId == null || procInputsAndOutputModel.CustomWidgetId ==  Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Custom widget Id is required", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.WidgetNameRequired
                });

                return false;
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertCustomWidgetApiDetailsValidators(CustomApiAppInputModel customApiAppInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCustomWidgetApiDetailsValidators", "CustomApiAppInputModel", customApiAppInputModel, "Widget Validation Helper"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(customApiAppInputModel.HttpMethod))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "http method is required", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.HttpMethodIsRequired
                });

                return false;
            }

            if (string.IsNullOrEmpty(customApiAppInputModel.ApiUrl))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Api url is required", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ApiUrlIsRequired
                });

                return false;
            }

            if (customApiAppInputModel.CustomWidgetId == null || customApiAppInputModel.CustomWidgetId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Custom widget Id is required", "widget Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.WidgetNameRequired
                });

                return false;
            }

            return validationMessages.Count <= 0;
        }
    }
}
