using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Notification;
using Btrak.Models.StatusReportingConfiguration;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.StatusReport;
using Btrak.Services.Notification;
using Btrak.Services.User;
using BTrak.Common;
using BTrak.Common.Constants;
using Omu.ValueInjecter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Btrak.Services.StatusReporting
{
    public class StatusReportingService : IStatusReportingService
    {
        private readonly StatusReportingRepository _statusReportingRepository;
        private readonly INotificationService _notificationService;
        private readonly IUserService _userService;
        private readonly IAuditService _auditService;

        public StatusReportingService(StatusReportingRepository statusReportingRepository, INotificationService notificationService, IUserService userService, IAuditService auditService)
        {
            _statusReportingRepository = statusReportingRepository;
            _notificationService = notificationService;
            _userService = userService;
            _auditService = auditService;
        }

        public List<StatusReportingOptionsApiReturnModel> GetStatusConfigurationOptions(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatusConfigurationOptions", "Status Reporting Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<StatusReportingOptionsApiReturnModel> options = _statusReportingRepository.GetStatusConfigurationOptions(loggedInContext, validationMessages);
            return options.OrderBy(x => x.SortOrder).ToList();
        }

        public Guid? UpsertReportSeenStatus(StatusReportSeenUpsertInputModel reportSeenUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Report Seen Status", "Status Reporting Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _statusReportingRepository.UpsertReportSeenStatus(reportSeenUpsertInputModel, loggedInContext, validationMessages);
        }

        public StatusReportingConfigurationApiReturnModel UpsertStatusReportingConfiguration(StatusReportingConfigurationUpsertInputModel statusReportingConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertStatusReportingConfiguration", "Status Reporting Service"));

            LoggingManager.Debug(statusReportingConfiguration.ToString());

            if (!StatusReportValidations.ValidateUpsertStatusReportingConfiguration(statusReportingConfiguration, loggedInContext, validationMessages))
            {
                return null;
            }

            statusReportingConfiguration.Id = _statusReportingRepository.UpsertStatusReportingConfiguration(statusReportingConfiguration, loggedInContext, validationMessages);

            if (validationMessages.Count > 0 )
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetStatusConfigurationOptionsCommandId, statusReportingConfiguration, loggedInContext);

            StatusReportingConfigurationApiReturnModel statusReportingConfigurationApiReturnModel = ConvertToStatusReportingConfigurationApiReturnModel(statusReportingConfiguration);

            LoggingManager.Debug(statusReportingConfigurationApiReturnModel?.ToString());
            if (!statusReportingConfiguration.IsArchived)
            {
                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    try
                    {
                        var employeeIds = statusReportingConfiguration.EmployeeIds.Split(',').ToList();

                        foreach (var employeeId in employeeIds)
                        {
                            if (employeeId.ToLower() != loggedInContext.LoggedInUserId.ToString().ToLower())
                            {
                                _notificationService.SendNotification(new ConfigureStatusReportNotification(
                               string.Format(NotificationSummaryConstants.StatusConfigurationAssignmentMessage, statusReportingConfiguration.ConfigurationName),
                               loggedInContext.LoggedInUserId,
                               new Guid(employeeId),
                               statusReportingConfiguration.GenericFormId,
                               statusReportingConfiguration.ConfigurationName), loggedInContext, new Guid(employeeId));
                            }
                        }

                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertStatusReportingConfiguration", "StatusReportingService ", exception.Message), exception);

                    }
                });
            }

            return statusReportingConfigurationApiReturnModel;
        }

        public List<StatusReportingConfigurationApiReturnModel> GetStatusReportingConfigurations(StatusReportingConfigurationSearchCriteriaInputModel statusReportingConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatusReportingConfigurations", "Status Reporting Service"));

            LoggingManager.Debug(statusReportingConfiguration.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetStatusReportingConfigurationsCommandId, statusReportingConfiguration, loggedInContext);

            List<StatusReportingConfigurationApiReturnModel> statusReportingConfigurations = _statusReportingRepository.GetStatusReportingConfigurations(statusReportingConfiguration, loggedInContext, validationMessages);
            return statusReportingConfigurations;
        }

        public List<StatusReportingConfigurationFormApiReturnModel> GetStatusReportingConfigurationForms(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatusReportingConfigurationForms", "Status Reporting Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<StatusReportingConfigurationFormApiReturnModel> statusReportingConfigurationForms = _statusReportingRepository.GetStatusReportingConfigurationForms(loggedInContext, validationMessages);
            return statusReportingConfigurationForms;
        }

        public StatusReportApiReturnModel CreateStatusReport(StatusReportUpsertInputModel statusReport, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateStatusReport", "Status Reporting Service"));

            LoggingManager.Debug(statusReport.ToString());

            statusReport.SubmittedDateTime = DateTime.Now;

            if (!StatusReportValidations.ValidateStatusReport(statusReport, loggedInContext, validationMessages))
            {
                return null;
            }

            statusReport.Id = _statusReportingRepository.CreateStatusReport(statusReport, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.CreateStatusReportCommandId, statusReport, loggedInContext);

            StatusReportApiReturnModel statusReportApiReturnModel = ConvertToStatusReportApiReturnModel(statusReport);

            LoggingManager.Debug(statusReportApiReturnModel?.ToString());

            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                try
                {
                    var reportToMembers = _statusReportingRepository.GetReportToMembers(loggedInContext, validationMessages);

                    var loggedInUser = _userService.GetUserById(loggedInContext.LoggedInUserId,null, loggedInContext, validationMessages);

                    if (validationMessages.Count == 0)
                    {
                        foreach (var member in reportToMembers)
                        {
                            _notificationService.SendNotification(new StatusReportSubmittedNotification(
                                string.Format(NotificationSummaryConstants.StatusReportSubmittedMessage, statusReport.FormName, loggedInUser.FullName),
                                loggedInContext.LoggedInUserId,
                                member.UserId,
                                statusReport.StatusReportingConfigurationOptionId,
                                statusReport.FormName,
                                loggedInUser.FullName), loggedInContext, member.UserId);
                        }
                    }
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateStatusReport", "StatusReportingService ", exception.Message), exception);

                }
            });

            return statusReportApiReturnModel;
        }

        public List<StatusReportApiReturnModel> GetStatusReportings(StatusReportSearchCriteriaInputModel statusReport, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatusReportings", "Status Reporting Service"));

            LoggingManager.Debug(statusReport.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetStatusReportingsCommandId, statusReport, loggedInContext);

            List<StatusReportApiReturnModel> statusReports = _statusReportingRepository.GetStatusReportings(statusReport, loggedInContext, validationMessages);
            return statusReports;
        }

        private static StatusReportApiReturnModel ConvertToStatusReportApiReturnModel(StatusReportUpsertInputModel statusReportUpsertInputModel)
        {
            StatusReportApiReturnModel statusReportApiReturnModel = new StatusReportApiReturnModel();

            statusReportApiReturnModel.InjectFrom<NullableInjection>(statusReportUpsertInputModel);

            return statusReportApiReturnModel;
        }

        private static StatusReportingConfigurationApiReturnModel ConvertToStatusReportingConfigurationApiReturnModel(StatusReportingConfigurationUpsertInputModel statusReportingConfigurationUpsertInputModel)
        {
            StatusReportingConfigurationApiReturnModel statusReportingConfigurationApiReturnModel = new StatusReportingConfigurationApiReturnModel();

            statusReportingConfigurationApiReturnModel.InjectFrom<NullableInjection>(statusReportingConfigurationUpsertInputModel);

            return statusReportingConfigurationApiReturnModel;
        }
    }
}
