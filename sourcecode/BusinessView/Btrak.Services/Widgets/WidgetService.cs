using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.GenericForm;
using Btrak.Models.Notification;
using Btrak.Models.SlackMessages;
using Btrak.Models.SystemManagement;
using Btrak.Models.Widgets;
using Btrak.Services.Audit;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.FileUploadDownload;
using Btrak.Services.FormDataServices;
using Btrak.Services.Helpers;
using Btrak.Services.Notification;
using Btrak.Services.Performance;
using BTrak.Common;
using BTrak.Common.Constants;
using Hangfire;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.Helpers;
using System.Web.Script.Serialization;

namespace Btrak.Services.Widgets
{
    public class WidgetService : IWidgetService
    {
        private readonly WidgetRepository _widgetRepository = new WidgetRepository();

        private readonly IAuditService _auditService;

        private readonly ICompanyStructureService _companyStructureService;

        private readonly IFileStoreService _fileStoreService;

        private readonly INotificationService _notificationService;

        private readonly UserRepository _userRepository = new UserRepository();

        private readonly GoalRepository _goalRepository = new GoalRepository();

        private readonly GenericFormRepository _genericFormRepository = new GenericFormRepository();

        private readonly IEmailService _emailService;
        private readonly IDataSetService _dataSetService;


        private DateTime? _dateFrom;
        private DateTime? _dateTo;
        private DateTime? _date;

        public WidgetService(ICompanyStructureService companyStructureService, IAuditService auditService, IFileStoreService fileStoreService, INotificationService notificationService, IEmailService emailService, IDataSetService dataSetService)
        {
            _companyStructureService = companyStructureService;
            _auditService = auditService;
            _fileStoreService = fileStoreService;
            _notificationService = notificationService;
            _emailService = emailService;
            _dataSetService = dataSetService;
        }

        public Guid? UpsertWidget(WidgetInputModel widgetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertWidget", "widgetInputModel", widgetInputModel, "Widget Service"));

            if (!WidgetsValidationHelpers.UpsertWidgetValidations(widgetInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (widgetInputModel.SelectedRoleIds != null && widgetInputModel.SelectedRoleIds.Count > 0)
            {
                widgetInputModel.RoleIdsXml = Utilities.GetXmlFromObject(widgetInputModel.SelectedRoleIds);
            }

            if (widgetInputModel.TagsIds != null && widgetInputModel.TagsIds.Count > 0)
            {
                widgetInputModel.TagIdsXml = Utilities.GetXmlFromObject(widgetInputModel.TagsIds);
            }

            Guid? widgetId = _widgetRepository.UpsertWidget(widgetInputModel, loggedInContext, validationMessages);
            if (widgetId != Guid.Empty)
            {
                _auditService.SaveAudit(AppConstants.Widgets, widgetInputModel, loggedInContext);
                return widgetId;
            }

            return null;
        }

        public Guid? UpsertChildWorkspace(Guid childWorkspaceId, Guid parentId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertChildWorkspace", "parentworkspace", parentId, "Widget Service"));

            Guid? workspaceId = _widgetRepository.UpsertChildWidget(childWorkspaceId, parentId, loggedInContext, validationMessages);
            if (workspaceId != Guid.Empty)
            {
                _auditService.SaveAudit(AppConstants.Widgets, parentId, loggedInContext);
                return workspaceId;
            }

            return null;
        }

        public Guid? UpsertImportWidget(WidgetInputModel widgetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertWidget", "widgetInputModel", widgetInputModel, "Widget Service"));

            if (widgetInputModel.SelectedRoleIds != null && widgetInputModel.SelectedRoleIds.Count > 0)
            {
                widgetInputModel.RoleIdsXml = Utilities.GetXmlFromObject(widgetInputModel.SelectedRoleIds);
            }

            if (widgetInputModel.TagsIds != null && widgetInputModel.TagsIds.Count > 0)
            {
                widgetInputModel.TagIdsXml = Utilities.GetXmlFromObject(widgetInputModel.TagsIds);
            }

            Guid? widgetId = _widgetRepository.UpsertImportWidget(widgetInputModel, loggedInContext, validationMessages);

            if (widgetId != Guid.Empty)
            {
                _auditService.SaveAudit(AppConstants.Widgets, widgetInputModel, loggedInContext);
                return widgetId;
            }

            return null;
        }

        public List<WidgetApiReturnModel> GetWidgets(WidgetSearchCriteriaInputModel widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWidgets", "WidgetSearchCriteriaInputModel", widgetSearchCriteriaInputModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _widgetRepository.GetWidgets(widgetSearchCriteriaInputModel, loggedInContext, validationMessages);
        }

        public List<TagApiReturnModel> GetWidgetTags(bool? isFromSearch, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _widgetRepository.GetWidgetTags(isFromSearch, loggedInContext, validationMessages).ToList();
        }

        public Guid? UpsertDashboardConfiguration(DashboardConfigurationInputModel dashboardConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertDashboardConfiguration", "dashboardConfigurationInputModel", dashboardConfigurationInputModel, "Widget Service"));

            Guid? configurationId = _widgetRepository.UpsertDashboardConfiguration(dashboardConfigurationInputModel, loggedInContext, validationMessages);

            if (configurationId != Guid.Empty)
            {
                _auditService.SaveAudit(AppConstants.Widgets, dashboardConfigurationInputModel, loggedInContext);
                return configurationId;
            }

            return null;
        }

        public List<DashboardConfigurationReturnModel> GetDashboardConfigurations(DashboardConfigurationInputModel dashboardConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetDashboardConfigurations", "DashboardConfigurationInputModel", dashboardConfigurationInputModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _widgetRepository.GetDashboardConfigurations(dashboardConfigurationInputModel, loggedInContext, validationMessages);
        }

        public List<WidgetApiReturnModel> GetWidgetsBasedOnUser(WidgetSearchCriteriaInputModel widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWidgetsBasedOnUser", "WidgetSearchCriteriaInputModel", widgetSearchCriteriaInputModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _widgetRepository.GetWidgetsBasedOnUser(widgetSearchCriteriaInputModel, loggedInContext, validationMessages);
        }

        public List<WidgetTagsAndWorkspaceReturnModel> GetWidgetTagsAndWorkspaces(List<WidgetTagsAndWorkspaceModel> widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWidgetTagsAndWorkspaces", "WidgetSearchCriteriaInputModel", widgetSearchCriteriaInputModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            string widgetXml = Utilities.GetXmlFromObject(widgetSearchCriteriaInputModel);
            return _widgetRepository.GetWidgetTagsAndWorkspaces(widgetSearchCriteriaInputModel, widgetXml, loggedInContext, validationMessages);
        }

        public Guid? AddWidgetToFavourites(FavouriteWidgetsInputModel widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "AddWidgetToFavourites", "FavouriteWidgetsInputModel", widgetSearchCriteriaInputModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _widgetRepository.AddWidgetToFavourites(widgetSearchCriteriaInputModel, loggedInContext, validationMessages);
        }

        public List<WidgetApiReturnModel> GetAllWidgets(WidgetSearchCriteriaInputModel widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllWidgets", "WidgetSearchCriteriaInputModel", widgetSearchCriteriaInputModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _widgetRepository.GetAllWidgets(widgetSearchCriteriaInputModel, loggedInContext, validationMessages);
        }

        public Guid? UpsertWorkspace(WorkspaceInputModel workspaceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertWorkspace", "WorkspaceInputModel", workspaceInputModel, "Widget Service"));
            if (!WidgetsValidationHelpers.UpsertWorkspaceValidations(workspaceInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? workspaceId = _widgetRepository.UpsertWorkspace(workspaceInputModel, loggedInContext, validationMessages);

            if (workspaceId != Guid.Empty)
            {
                _auditService.SaveAudit(AppConstants.Widgets, workspaceInputModel, loggedInContext);
                return workspaceId;
            }

            return null;
        }

        public Guid? InsertDuplicateDashboard(WorkspaceInputModel workspaceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "InsertDuplicateDashboard", "WorkspaceInputModel", workspaceInputModel, "Widget Service"));

            Guid? workspaceId = _widgetRepository.InsertDuplicateDashboard(workspaceInputModel, loggedInContext, validationMessages);

            if (workspaceId != Guid.Empty)
            {
                _auditService.SaveAudit(AppConstants.Widgets, workspaceInputModel, loggedInContext);
                return workspaceId;
            }

            return null;
        }

        public List<WorkspaceApiReturnModel> GetWorkspaces(WorkspaceSearchCriteriaInputModel workspaceSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWorkspaces", "WorkspaceSearchCriteriaInputModel", workspaceSearchCriteriaInputModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _widgetRepository.GetWorkspaces(workspaceSearchCriteriaInputModel, loggedInContext, validationMessages);
        }

        public Guid? InsertDashboard(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "InsertDashboard", "DashboardInputModel", dashboardInputModel, "Widget Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            string dashboardXml = Utilities.GetXmlFromObject(dashboardInputModel.Dashboard);

            Guid? dashboardId = _widgetRepository.InsertDashboard(dashboardInputModel, dashboardXml, loggedInContext, validationMessages);

            if (dashboardId != Guid.Empty)
            {
                _auditService.SaveAudit(AppConstants.Widgets, dashboardInputModel, loggedInContext);
                return dashboardId;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Insert Dashboard", "Widget Service"));
            return null;
        }

        public Guid? SetDefaultDashboardForUser(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SetDefaultDashboardForUser", "DashboardInputModel", dashboardInputModel, "Widget Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _widgetRepository.SetDefaultDashboardForUser(dashboardInputModel, loggedInContext, validationMessages);
        }

        public CustomAppDashboardPersistanceModel GetCustomAppDashboardPersistanceForUser(CustomAppDashboardPersistanceModel persistanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCustomAppDashboardPersistanceForUser", "CustomAppDashboardPersistanceModel", persistanceModel, "Widget Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _widgetRepository.GetCustomAppDashboardPersistanceForUser(persistanceModel, loggedInContext, validationMessages);
        }

        public Guid? SetCustomAppDashboardPersistanceForUser(CustomAppDashboardPersistanceModel persistanceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SetDefaultDashboardForUser", "CustomAppDashboardPersistanceModel", persistanceModel, "Widget Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _widgetRepository.SetCustomAppDashboardPersistanceForUser(persistanceModel, loggedInContext, validationMessages);
        }

        public Guid? UpdateDashboardName(DashboardModel dashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateDashboardName", "DashboardModel", dashboardModel, "Widget Service"));

            WidgetsValidationHelpers.UpdateDashboardNameValidations(dashboardModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return _widgetRepository.UpdateDashboardName(dashboardModel, loggedInContext, validationMessages);
        }

        public Guid? UpdateDashboard(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateDashboard", "DashboardInputModel", dashboardInputModel, "Widget Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            string dashboardXml = Utilities.GetXmlFromObject(dashboardInputModel.Dashboard);

            Guid? workspaceId = _widgetRepository.UpdateDashboard(dashboardInputModel, dashboardXml, loggedInContext, validationMessages);

            if (workspaceId != Guid.Empty)
            {
                _auditService.SaveAudit(AppConstants.Widgets, dashboardInputModel, loggedInContext);
                return workspaceId;
            }

            return null;
        }

        public List<DashboardApiReturnModel> GetDashboards(DashboardSearchCriteriaInputModel dashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetDashboards", "DashboardSearchCriteriaInputModel", dashboardSearchCriteriaInputModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _widgetRepository.GetDashboards(dashboardSearchCriteriaInputModel, loggedInContext, validationMessages);
        }

        public Guid? GetCustomizedDashboardId(DashboardSearchCriteriaInputModel dashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCustomizedDashboardId", "dashboardSearchCriteriaInputModel", dashboardSearchCriteriaInputModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _widgetRepository.GetCustomizedDashboardId(dashboardSearchCriteriaInputModel, loggedInContext, validationMessages);
        }


        public List<ColumnFormatTypeModel> GetColumnFormatTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetSubQueryTypes", "Widget Service"));

            //if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            //{
            //    return null;
            //}

            return _widgetRepository.GetColumnFormatTypes(loggedInContext, validationMessages);
        }

        public List<ColumnFormatTypeModel> GetColumnFormatTypesById(Guid? ColumnFormatTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetSubQueryTypes", "Widget Service"));

            //if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            //{
            //    return null;
            //}

            return _widgetRepository.GetColumnFormatTypesById(ColumnFormatTypeId, loggedInContext, validationMessages);
        }

        public List<ColumnFormatTypeModel> GetColumnFormatById(Guid? ColumnFormatTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return _widgetRepository.GetColumnFormatById(ColumnFormatTypeId, loggedInContext, validationMessages);

        }


        public List<SubQueryTypeModel> GetSubQueryTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetSubQueryTypes", "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _widgetRepository.GetSubQueryTypes(loggedInContext, validationMessages);
        }

        public Guid? DeleteWorkspace(WorkspaceInputModel workspaceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            WidgetsValidationHelpers.WorkspaceIdValidations(workspaceInputModel.WorkspaceId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppConstants.Widgets, workspaceInputModel.WorkspaceId, loggedInContext);

            var workspaceId = _widgetRepository.DeleteWorkspace(workspaceInputModel, loggedInContext, validationMessages);

            return validationMessages.Count > 0 ? null : workspaceId;

        }

        public Guid? UpsertCustomWidget(CustomWidgetsInputModel widgetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CronExpressionApiReturnModel cronExpressionApiReturnModel = new CronExpressionApiReturnModel();

            int? jobId = new int();

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCustomWidget", "CustomWidgetsInputModel", widgetInputModel, "Widget Service"));

            if (!WidgetsValidationHelpers.UpsertCustomWidgetValidations(widgetInputModel, false, loggedInContext, validationMessages))
            {
                return null;
            }

            if (widgetInputModel.SelectedRoleIds != null && widgetInputModel.SelectedRoleIds.Count > 0)
            {
                widgetInputModel.RoleIdsXml = Utilities.GetXmlFromObject(widgetInputModel.SelectedRoleIds);
            }

            if (widgetInputModel.ModuleIds != null && widgetInputModel.ModuleIds.Count > 0)
            {
                widgetInputModel.ModuleIdsXML = Utilities.GetXmlFromObject(widgetInputModel.ModuleIds);
            }

            if (widgetInputModel.DefaultColumns != null && widgetInputModel.DefaultColumns.Count > 0)
            {
                widgetInputModel.DefaultColumnsXml = Utilities.GetXmlFromObject(widgetInputModel.DefaultColumns);
            }

            if (widgetInputModel.ChartsDetails != null && widgetInputModel.ChartsDetails.Count > 0)
            {
                widgetInputModel.ChartsDetails.ForEach((chart) =>
                {
                    if (chart.VisualisationColors != null && chart.VisualisationColors.Count > 0)
                    {
                        chart.ChartColorJson = JsonConvert.SerializeObject(chart.VisualisationColors);
                    }
                });
                widgetInputModel.ChartsDetailsXml = Utilities.GetXmlFromObject(widgetInputModel.ChartsDetails);
            }

            if (widgetInputModel.TagsIds != null && widgetInputModel.TagsIds.Count > 0)
            {
                widgetInputModel.TagIdsXml = Utilities.GetXmlFromObject(widgetInputModel.TagsIds);
            }

            Guid? customWidgetId = _widgetRepository.UpsertCustomWidget(widgetInputModel, loggedInContext, validationMessages);

            if (widgetInputModel.IsArchived == true)
            {
                cronExpressionApiReturnModel = _widgetRepository.GetCronExpressionDetails(widgetInputModel.CustomWidgetId, loggedInContext, validationMessages);

                if (cronExpressionApiReturnModel != null)
                {
                    RecurringJob.RemoveIfExists(cronExpressionApiReturnModel.JobId.ToString());
                }
            }
            else if (widgetInputModel.CustomWidgetId != null && widgetInputModel.IsArchived == false && cronExpressionApiReturnModel.CronExpression != null)
            {
                cronExpressionApiReturnModel = _widgetRepository.GetCronExpressionDetails(widgetInputModel.CustomWidgetId, loggedInContext, validationMessages);

                CronExpressionInputModel cronExpressionInput = new CronExpressionInputModel()
                {
                    CronExpression = cronExpressionApiReturnModel.CronExpression,
                    CronExpressionId = cronExpressionApiReturnModel.CronExpressionId,
                    CronExpressionName = cronExpressionApiReturnModel.CronExpressionName,
                    CronExpressionDescription = cronExpressionApiReturnModel.CronExpressionDescription,
                    CustomWidgetId = cronExpressionApiReturnModel.CustomWidgetId,
                    TemplateType = cronExpressionApiReturnModel.TemplateType,
                    TemplateUrl = cronExpressionApiReturnModel.TemplateUrl,
                    ChartsUrls = cronExpressionApiReturnModel.ChartsUrls,
                    FileUrl = JsonConvert.DeserializeObject<List<FileDetailsModel>>(cronExpressionApiReturnModel.ChartsUrls),
                    TimeStamp = cronExpressionApiReturnModel.TimeStamp,
                    CustomAppName = widgetInputModel.CustomWidgetName,
                    SelectedCharts = cronExpressionApiReturnModel.SelectedChartIds
                };
                UpsertCronExpressionApiReturnModel upsertCronExpressionApiReturnModel = _widgetRepository.UpsertCronExpression(cronExpressionInput, loggedInContext, validationMessages);

                RunSchedulingJobs(cronExpressionInput, loggedInContext, validationMessages, upsertCronExpressionApiReturnModel.JobId);
            }

            if (customWidgetId != Guid.Empty)
            {
                _auditService.SaveAudit(AppConstants.Widgets, widgetInputModel, loggedInContext);
                return customWidgetId;
            }

            return null;
        }

        public Guid? ArchivedScheduling(ArchivedRecurringExpressionModel widgetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ArchivedScheduling", "CustomWidgetsInputModel", widgetInputModel, "Widget Service"));

            Guid? customWidgetId = _widgetRepository.ArchiveCronExpression(widgetInputModel, loggedInContext, validationMessages);


            if (customWidgetId != Guid.Empty)
            {
                _auditService.SaveAudit(AppConstants.Widgets, widgetInputModel, loggedInContext);
                return customWidgetId;
            }

            return null;
        }

        public Guid? UpsertCustomHtmlApp(CustomHtmlAppInputModel widgetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCustomWidget", "CustomWidgetsInputModel", widgetInputModel, "Widget Service"));

            //if (!WidgetsValidationHelpers.UpsertCustomWidgetValidations(widgetInputModel, false, loggedInContext, validationMessages))
            //{
            //    return null;
            //}

            if (widgetInputModel.SelectedRoleIds != null && widgetInputModel.SelectedRoleIds.Count > 0)
            {
                widgetInputModel.RoleIdsXml = Utilities.GetXmlFromObject(widgetInputModel.SelectedRoleIds);
            }

            if (widgetInputModel.ModuleIds != null && widgetInputModel.ModuleIds.Count > 0)
            {
                widgetInputModel.ModuleIdsXml = Utilities.GetXmlFromObject(widgetInputModel.ModuleIds);
            }

            Guid? customWidgetId = _widgetRepository.UpsertCustomHtmlApp(widgetInputModel, loggedInContext, validationMessages);

            if (customWidgetId != Guid.Empty)
            {
                _auditService.SaveAudit(AppConstants.Widgets, widgetInputModel, loggedInContext);
                return customWidgetId;
            }

            return null;
        }

        public List<CustomWidgetsApiReturnModel> GetCustomWidgets(CustomWidgetSearchCriteriaInputModel widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCustomWidgets", "CustomWidgetSearchCriteriaInputModel", widgetSearchCriteriaInputModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            var customWidgetDetails = _widgetRepository.GetCustomWidgets(widgetSearchCriteriaInputModel, loggedInContext, validationMessages);

            Parallel.ForEach(customWidgetDetails.Where(p => p.IsHtml != true).ToList(), customWidget =>
            {
                customWidget.AllChartsDetails = Utilities.GetObjectFromXml<CustomAppChartModel>(customWidget.CustomWidgetsMultipleChartsXML, "CustomWidgetsMultipleChartsModel");
            });

            //foreach (var widget in customWidgetDetails)
            //{
            //    if ((bool)widget.IsHtml && !(widgetSearchCriteriaInputModel.IsFormTags))
            //    {
            //        ReplaceHtmlTags(widget, loggedInContext, validationMessages);
            //    }
            //}

            return customWidgetDetails;
        }

        private void ReplaceHtmlTags(CustomWidgetsApiReturnModel widget, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                var formData = widget.WidgetQuery;
                Regex regex = new Regex(@"##(.+?)##");
                var tagsList = regex.Matches(formData);
                foreach (var tag in tagsList)
                {
                    var details = tag.ToString().Replace("##", "").Split('.');
                    if (details.Length > 0)
                    {
                        var formKey = details[2];
                        var genericFormInput = new GenericFormSubmittedSearchInputModel()
                        {
                            GenericFormSubmittedId = new Guid(details[1])
                        };
                        var genericFormSubmitted = _genericFormRepository.GetGenericFormSubmitted(genericFormInput, loggedInContext, validationMessages);
                        var formResult = GetValuesFromJson(genericFormSubmitted.FirstOrDefault().FormJson);
                        var keyValue = formResult.DataPairs?.FirstOrDefault(p => p.Key == formKey)?.Value;
                        widget.WidgetQuery = widget.WidgetQuery.Replace(tag.ToString(), keyValue);
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReplaceHtmlTags", "WidgetService ", exception.Message), exception);

            }

        }

        public PerformanceDataValues GetValuesFromJson(string formData)
        {
            List<JsonDataPairs> datapairs = new List<JsonDataPairs>();
            var overaallData = formData.Trim();
            var overaallDataLength = overaallData.Length;
            overaallData = overaallData.Substring(1, overaallDataLength - 2);
            var rawDatasplits = overaallData.Replace("\"", "");
            var rawkeyValuePairs = rawDatasplits.Split(',');
            foreach (var rawKeyValue in rawkeyValuePairs)
            {
                var rawKeyValueSplits = rawKeyValue.Split(':');
                if (rawKeyValueSplits.Length > 1)
                {
                    var key = rawKeyValueSplits[0];
                    if (key != "submit")
                    {
                        var value = rawKeyValueSplits[1];
                        var properData = new JsonDataPairs
                        {
                            Key = key,
                            Value = value
                        };
                        datapairs.Add(properData);
                    }
                }
            }
            return new PerformanceDataValues { DataPairs = datapairs };
        }

        public Guid? UpsertDashboardFilter(DynamicDashboardFilterModel dashboardFilterModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertDashboardFilter", "DashboardFilterModel", dashboardFilterModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            if (dashboardFilterModel?.Filters.Count > 0)
            {
                dashboardFilterModel.FiltersXml = Utilities.GetXmlFromObject(dashboardFilterModel.Filters);

                return _widgetRepository.UpsertDashboardFilter(dashboardFilterModel, loggedInContext, validationMessages);
            }

            return null;

        }

        public List<FilterKeyValuePair> GetDashboardFilters(DynamicDashboardFilterModel dashboardFilterModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertDashboardFilter", "DashboardFilterModel", dashboardFilterModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            var filters = _widgetRepository.GetDashboardFilters(dashboardFilterModel, loggedInContext, validationMessages);

            return filters;
        }

        public List<FilterKeyValuePair> GetAllDashboardFilters(DynamicDashboardFilterModel dashboardFilterModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllDashboardFilters", "DashboardFilterModel", dashboardFilterModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            var filters = _widgetRepository.GetAllDashboardFilters(dashboardFilterModel, loggedInContext, validationMessages);

            return filters;
        }

        public DashboardApiReturnModel UpsertCustomAppFilter(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCustomAppFilter", "DashboardInputModel", dashboardInputModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            var customFilterId = _widgetRepository.UpsertCustomAppFilter(dashboardInputModel, loggedInContext, validationMessages);

            CustomWidgetSearchCriteriaInputModel customWidgetSearchCriteriaInputModel = new CustomWidgetSearchCriteriaInputModel()
            {
                CustomWidgetId = dashboardInputModel.CustomAppId,
                DashboardId = dashboardInputModel.Id
            };
            var customWidgetData = GetCustomGridData(customWidgetSearchCriteriaInputModel, loggedInContext, validationMessages);

            return new DashboardApiReturnModel()
            {
                GridData = customWidgetData.QueryData,
                GridColumns = customWidgetData.Headers,
                FilterQuery = customWidgetData.FilterQuery

            };
        }

        public WidgetDynamicQueryReturnModel GetWidgetDynamicQueryResult(WidgetDynamicQueryModel widgetDynamicQueryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isDataRequired)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWidgetDynamicQueryResult", "WidgetDynamicQueryModel", widgetDynamicQueryModel, "Widget Service"));

            string filterQuery = null;
            _dateFrom = null;
            _dateTo = null;
            _date = null;
            string branchId = null;
            string entityId = null;
            string designationId = null;
            string roleId = null;
            string departmentId = null;
            bool? isActiveEmployees = null;

            if (widgetDynamicQueryModel.DynamicQuery != null)
            {
                if (!string.IsNullOrWhiteSpace(widgetDynamicQueryModel.DynamicQuery) && !string.IsNullOrWhiteSpace(widgetDynamicQueryModel.ClickedColumnData))
                {
                    dynamic data = Json.Decode(widgetDynamicQueryModel.ClickedColumnData);
                    bool c = Convert.GetTypeCode(data) != TypeCode.Object;
                    if (!c)
                    {
                        foreach (var d in data)
                        {
                            widgetDynamicQueryModel.DynamicQuery = Regex.Replace(widgetDynamicQueryModel.DynamicQuery, $"##{d.Key}##", match =>
                            {
                                return $"{d.Value}";
                            });
                        }
                    }
                    else
                    {
                        widgetDynamicQueryModel.DynamicQuery = Regex.Replace(widgetDynamicQueryModel.DynamicQuery, $"##category##", match =>
                        {
                            return $"{data}";
                        });

                    }
                }
                if (widgetDynamicQueryModel.WorkspaceId != null || widgetDynamicQueryModel.DashboardId != null)
                {

                    DynamicDashboardFilterModel dashboardFilterModel = new DynamicDashboardFilterModel();
                    dashboardFilterModel.DashboardId = widgetDynamicQueryModel.WorkspaceId;
                    dashboardFilterModel.DashboardAppId = widgetDynamicQueryModel.DashboardId;
                    var filters = GetDashboardFilters(dashboardFilterModel, loggedInContext, new List<ValidationMessage>());

                    var tagFilters = filters.Where(p => p.IsSystemFilter == false && !string.IsNullOrEmpty(p.FilterValue)).ToList();

                    if (widgetDynamicQueryModel.DynamicQuery.Contains("$JSON_PARAMETERS$") && tagFilters.Count > 0)
                    {
                        string customFilterQueryString = null;
                        foreach (var filter in tagFilters)
                        {
                            if (!string.IsNullOrEmpty(customFilterQueryString))
                            {
                                customFilterQueryString = customFilterQueryString + " AND ";
                            }
                            customFilterQueryString = customFilterQueryString + "JSON_VALUE(FormJson,'$." + filter.FilterKey + "') = '" + filter.FilterValue + "'";
                        }
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("$JSON_PARAMETERS$", customFilterQueryString == null ? "1 = 1" : customFilterQueryString);
                    }
                    if (filters.Where(p => p.IsSystemFilter == true && !string.IsNullOrEmpty(p.FilterValue)).ToList().Count > 0)
                    {
                        var projectId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "Project" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@ProjectId", projectId);

                        var testSuiteId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "TestSuite" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@TestSuiteId", testSuiteId);

                        var AuditId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "Audit" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@AuditId", AuditId);

                        var SourceId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "Source" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@SourceId", SourceId);

                        var EmploymentStatusId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "EmploymentStatus" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@EmploymentStatusId", EmploymentStatusId);

                        var JobOpeningStatusId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "JobOpeningStatus" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@JobOpeningStatusId", JobOpeningStatusId);

                        var HiringStatusId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "HiringStatus" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@HiringStatusId", HiringStatusId);


                        var CandidateId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "Candidate" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@CandidateId", CandidateId);


                        var userId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "User" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@UserId", userId);

                        entityId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "Entity" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;

                        branchId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "Branch" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;

                        designationId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "Designation" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;

                        roleId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "Role" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;

                        departmentId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "Department" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;

                        var IsfinancialYear = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "FinancialYear" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@IsFinancialYear", IsfinancialYear == "true" ? "1" : IsfinancialYear == "false" ? "0" : IsfinancialYear);

                        var businessunitId = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "BusinessUnit" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@BusinessUnitIds", businessunitId);

                        var IsActiveEmployeesOnly = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "ActiveEmployees" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@IsActiveEmployeesOnly", IsActiveEmployeesOnly == "true" ? "1" : IsActiveEmployeesOnly == "false" ? "0" : IsActiveEmployeesOnly);
                        if (IsActiveEmployeesOnly == "true")
                        {
                            isActiveEmployees = true;
                        }
                        else if (IsActiveEmployeesOnly == "false")
                        {
                            isActiveEmployees = false;
                        }
                        else
                        {
                            isActiveEmployees = null;
                        }

                        var month = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "Month" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@Month", month != null ? "'" + month + "'" : month);

                        var year = filters.FirstOrDefault(p => p.IsSystemFilter == true && p.FilterKey == "Year" && !string.IsNullOrEmpty(p.FilterValue))?.FilterValue;
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@Year", year != null ? "'" + year + "'" : year);
                    }

                    var dateFilter = filters.FirstOrDefault(p => p.FilterName == "Date" && !string.IsNullOrEmpty(p.FilterValue));

                    if (dateFilter?.FilterValue == "lastMonth" || dateFilter?.FilterValue == "thisMonth" || dateFilter?.FilterValue == "lastWeek" || dateFilter?.FilterValue == "nextWeek")
                    {
                        DateFromDateTo(dateFilter.FilterValue);
                    }
                    else if (dateFilter != null)
                    {
                        var obj = JsonConvert.DeserializeObject<DateFilterModel>(dateFilter.FilterValue);
                        if (obj.Date != null && obj.DateFrom == null && obj.DateTo == null)
                        {
                            _date = obj.Date;
                        }
                        else
                        {
                            _dateFrom = obj.DateFrom;
                            _dateTo = obj.DateTo;
                        }
                    }
                }

                string isActiveFilter = null;
                if (isActiveEmployees == true)
                {
                    isActiveFilter = "1";
                }
                else if (isActiveEmployees == false)
                {
                    isActiveFilter = "0";
                }
                else
                {
                    isActiveFilter = null;
                }

                if(widgetDynamicQueryModel.IsMongoQuery == null || widgetDynamicQueryModel.IsMongoQuery == false)
                {
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@DateFrom", (_dateFrom != null ? "'" + _dateFrom?.ToString("yyyy-MM-dd") + "'" : "null"));
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@DateTo", (_dateTo != null ? "'" + _dateTo?.ToString("yyyy-MM-dd") + "'" : "null"));
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@Date", (_date != null ? "'" + _date?.ToString("yyyy-MM-dd") + "'" : "null"));
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("$JSON_PARAMETERS$", "1 = 1");
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@OperationsPerformedBy", loggedInContext.LoggedInUserId.ToString());
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@CompanyId", loggedInContext.CompanyGuid.ToString());
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@ProjectId", widgetDynamicQueryModel.DashboardFilters?.ProjectId.ToString());
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@AuditId", widgetDynamicQueryModel.DashboardFilters?.AuditId.ToString());
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@TestSuiteId", widgetDynamicQueryModel.DashboardFilters?.TestSuiteId.ToString());
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@UserId", widgetDynamicQueryModel.DashboardFilters?.UserId.ToString());
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@GoalId", widgetDynamicQueryModel.DashboardFilters?.GoalId.ToString());
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@SourceId", widgetDynamicQueryModel.DashboardFilters?.SourceId.ToString());
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@CandidateId", widgetDynamicQueryModel.DashboardFilters?.CandidateId.ToString());
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@HiringStatusId", widgetDynamicQueryModel.DashboardFilters?.HiringStatusId.ToString());
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@JobOpeningStatusId", widgetDynamicQueryModel.DashboardFilters?.JobOpeningStatusId.ToString());
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@EmploymentStatusId", widgetDynamicQueryModel.DashboardFilters?.EmploymentStatusId.ToString());
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@DesignationId", designationId);
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@BranchId", branchId);
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@EntityId", entityId);
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@DepartmentId", departmentId);
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@RoleId", roleId);
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@SubmittedFormId", widgetDynamicQueryModel.SubmittedFormId.ToString());
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@IsReportingOnly", widgetDynamicQueryModel.IsReportingOnly ? "1" : "0");
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@IsMyself", widgetDynamicQueryModel.IsMyself ? "1" : "0");
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@IsAll", widgetDynamicQueryModel.IsAll ? "1" : "0");
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@IsActiveEmployees", isActiveFilter);
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@BusinessUnitIds", widgetDynamicQueryModel.DashboardFilters?.BusinessUnitId);
                    widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@FormId", widgetDynamicQueryModel.DashboardFilters != null && widgetDynamicQueryModel.DashboardFilters.FormId != null ? "'" + widgetDynamicQueryModel.DashboardFilters.FormId.ToString() + "'" : "null");
                    if (widgetDynamicQueryModel.DynamicQuery.Contains("@CurrentDateTime"))
                    {
                        var indianTimeDetails = TimeZoneHelper.GetIstTime();
                        DateTimeOffset? buttonClickedDate = indianTimeDetails?.UserTimeOffset;

                        if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
                        {
                            LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                            var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                            buttonClickedDate = userTimeDetails?.UserTimeOffset;
                        }
                        widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@CurrentDateTime", buttonClickedDate.Value.DateTime.ToString());
                    }

                }

                if (widgetDynamicQueryModel.FilterQuery != null && widgetDynamicQueryModel.FilterQuery != "")
                {
                    var jsonData = JsonConvert.DeserializeObject<QueryBuilder>(widgetDynamicQueryModel.FilterQuery);

                    if (jsonData != null)
                    {
                        var dynamicQuery = QueryBuilder(jsonData.Condition, jsonData.Rules, "");

                        if (dynamicQuery != null && dynamicQuery != "")
                        {
                            filterQuery = " where (" + dynamicQuery + ")";
                        }
                    }

                }

            }

            if (!isDataRequired && widgetDynamicQueryModel.CustomWidgetId != null && (widgetDynamicQueryModel.IsMongoQuery == false || widgetDynamicQueryModel.IsMongoQuery == null))
            {
                var inserted = _widgetRepository.ModifyCustomAppColumns(widgetDynamicQueryModel, filterQuery, isDataRequired, loggedInContext, validationMessages);
            }

            var result = new WidgetHeadersWithData();
            if(widgetDynamicQueryModel.IsMongoQuery == true)
            {
                widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@DateFrom", (_dateFrom != null ? "ISODate(\"" + _dateFrom?.ToString("yyyy-MM-dd") + "\")" : "\"\""));
                widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@DateTo", (_dateTo != null ? "ISODate(\"" + _dateTo?.ToString("yyyy-MM-dd") + "\")" : "\"\""));
                widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("@Date", (_date != null ? "ISODate(\"" + _date?.ToString("yyyy-MM-dd") + "\")" : "\"\""));
                

                widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("#DateFrom", (_dateFrom != null ? "false" : "true"));
                widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("#DateTo", (_dateTo != null ? "false" : "true"));
                widgetDynamicQueryModel.DynamicQuery = widgetDynamicQueryModel.DynamicQuery.Replace("#Date", (_date != null ? "false" : "true"));

                var headers = _dataSetService.GetMongoQueryDetails(widgetDynamicQueryModel.DynamicQuery,true, widgetDynamicQueryModel.CollectionName, loggedInContext, validationMessages).Result;
                var queryResult = _dataSetService.GetMongoQueryDetails(widgetDynamicQueryModel.DynamicQuery, false, widgetDynamicQueryModel.CollectionName, loggedInContext, validationMessages).Result;

                if (headers != null)
                {
                    if(headers.ApiResponseMessages.Count > 0)
                    {
                        foreach(var validation in headers.ApiResponseMessages)
                        {
                            validationMessages.Add(new ValidationMessage
                            {
                                ValidationMessageType = MessageTypeEnum.Error,
                                ValidationMessaage = validation.Message
                            });
                        }
                        return null;
                    } else
                    {
                        result.HeadersJson = headers.Data.ToString();
                        result.Query = queryResult.Data.ToString();
                    }
                }
            } else
            {
                result = _widgetRepository.GetCustomQueryHeaders(widgetDynamicQueryModel, filterQuery, isDataRequired, loggedInContext, validationMessages);
            }

            if (result == null)
            {
                return new WidgetDynamicQueryReturnModel();
            }

            if (widgetDynamicQueryModel.AllChartsDetails?.FirstOrDefault(x => x.VisualizationType == "pivot") != null && result != null)
            {
                result.Query = result.Query?.Replace("null", "\"\"").ToString();
            }

            ////Colmn format for datatable

            if (widgetDynamicQueryModel.ColumnFormatQuery != "" && widgetDynamicQueryModel.ColumnFormatQuery != null)
            {
                if(result.Query!=null)
                result.Query = FormatColumns(result.Query, widgetDynamicQueryModel.ColumnFormatQuery, loggedInContext);
            }
            if (widgetDynamicQueryModel.AllChartsDetails != null)
            {
                if (widgetDynamicQueryModel.AllChartsDetails[0].ColumnFormatQuery != null && widgetDynamicQueryModel.AllChartsDetails[0].ColumnFormatQuery != "")
                {
                    if (result.Query != null)
                        result.Query = FormatColumns(result.Query, widgetDynamicQueryModel.AllChartsDetails[0].ColumnFormatQuery, loggedInContext);
                }
            }

            var headersTemp = new List<CustomWidgetHeaderModel>();

            if (result?.HeadersJson != null & result?.HeadersJson?.Length > 0)
                 headersTemp = JsonConvert.DeserializeObject<List<CustomWidgetHeaderModel>>(result.HeadersJson);

            if (widgetDynamicQueryModel.ColumnAltName != null && widgetDynamicQueryModel.CustomWidgetId==null)
            {
                var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                dynamic columnAltTemp = serializer.Deserialize(widgetDynamicQueryModel.ColumnAltName, typeof(object));
                foreach (var item in headersTemp)
                {
                    var columnNameTemp = item.Field;
                    foreach (var ele in columnAltTemp)
                    {
                        // item.ColumnName = items.
                        var colname = ele.Key;
                        if (colname == item.Field && ele.Value != "" && ele.Value != null)
                        {
                            item.ColumnAltName = Convert.ToString(ele.Value);
                            item.Title = Convert.ToString(ele.Value);
                        }
                    }

                }
            }

            return new WidgetDynamicQueryReturnModel()
            {
                Headers = headersTemp,
                QueryData = result.Query,
                FilterQuery = widgetDynamicQueryModel.FilterQuery,
                Name = widgetDynamicQueryModel.Name,
                AllChartsDetails = widgetDynamicQueryModel.AllChartsDetails,
                Description = widgetDynamicQueryModel.Description,
                ChartColorJson = widgetDynamicQueryModel.ChartColorJson
                //DoSubQueryExists = widgetDynamicQueryModel.DoSubQueryExists
            };
        }


        public string FormatColumns(string query, string columnformat, LoggedInContext loggedInContext)
        {

            string strquery = query;

            var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            dynamic deserializeQuery = serializer.Deserialize(query, typeof(object));


            System.Data.DataTable dtResults = new System.Data.DataTable();
            dtResults.Clear();

            var headers = deserializeQuery[0];
            foreach (var item in headers)
            {
                var header = item.Key;
                dtResults.Columns.Add(header);
            }

            List<object> dataList = new List<object>();


            foreach (var elem in deserializeQuery)
            {
                dataList.Clear();
                foreach (var subelem in elem)
                {
                    var subelemvalue = subelem.Value;
                    dataList.Add(subelem.Value);
                }
                var xy = dataList.ToArray();
                dtResults.Rows.Add(dataList.ToArray());
            }

            //format query
            dynamic formatQuery = serializer.Deserialize(columnformat, typeof(object));

            //iterate through each format
            foreach (var ele in formatQuery)
            {
                var colname = ele.Key;
                if (ele.Value != "" && ele.Value != null)
                {
                    Guid? colformattypeId = Guid.Parse(ele.Value);
                    List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                    List<ColumnFormatTypeModel> colFormat = GetColumnFormatById(colformattypeId, loggedInContext, validationMessages);


                    if (dtResults.Columns.Contains(colname))
                    {
                        foreach (DataRow row in dtResults.Rows)
                        {
                            if (colFormat.FirstOrDefault() != null)
                            {
                                string strFormatType = colFormat.FirstOrDefault().ColumnFormatType;
                                //apply column format for each row

                                if ((Convert.ToString(row[ele.Key])) != null && (Convert.ToString(row[ele.Key])) != string.Empty)
                                {
                                    //Regex rgx = new Regex(@"(^{[&\/\\#,+()$~%._\'"":*?<>{}@`;^=-]})$");
                                    Regex rgx = new Regex("[^A-Za-z0-9.-]");
                                    bool containsSpecialCharacter = rgx.IsMatch(Convert.ToString(row[ele.Key]));
                                    if (!containsSpecialCharacter)
                                    {
                                        decimal value;
                                        bool isDecimal = Decimal.TryParse(row[ele.Key], out value);

                                        //Number Related
                                        if (strFormatType == "Decimal2")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("N");
                                        }
                                        else if (strFormatType == "Comma separated")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("N0");
                                        }
                                        else if (strFormatType == "Decimal")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("N1");
                                        }

                                        //Currency
                                        else if (strFormatType == "United States Dollar")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("en-US")).ToString();
                                        }

                                        else if (strFormatType == "Indian Rupee")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("en-IN")).ToString();

                                        }
                                        else if (strFormatType == "Euro")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("en-IE")).ToString();
                                        }
                                        else if (strFormatType == "Albanian Lek")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("sq-XK")).ToString();
                                            //if (isDecimal)
                                            //{
                                            //    RegionInfo ad = new RegionInfo("sq-XK");
                                            //    row[ele.Key] = ad.CurrencySymbol + Convert.ToDouble(row[ele.Key]).ToString("N");
                                            //}
                                        }
                                        else if (strFormatType == "Nepalese Rupee")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("ne-IN")).ToString();
                                        }
                                        else if (strFormatType == "Iceland Krona")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("en-IS")).ToString();
                                        }
                                        else if (strFormatType == "Hongkong Dollar")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = "HK" + Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("en-HK")).ToString();
                                        }
                                        else if (strFormatType == "Brazilian Real")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("en-BR")).ToString();
                                        }
                                        else if (strFormatType == "Algerian Dinar")
                                        {
                                            if (isDecimal)
                                            {
                                                //RegionInfo ad = new RegionInfo("ar-DZ");
                                                //row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("N") + ad.CurrencySymbol;
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("ar-DZ")).ToString();
                                            }
                                        }
                                        else if (strFormatType == "Australian Dollar")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] ="A"+ Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("en-AU")).ToString();

                                        }
                                        else if (strFormatType == "Canadian Dollar")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = "C" + Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("en-CA")).ToString();
                                        }
                                        else if (strFormatType == "Afganisthan Afgani")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("fa-AF")).ToString();
                                            //if (isDecimal)
                                            //{
                                            //    RegionInfo ad = new RegionInfo("fa-AF");
                                            //    row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("N") + ad.CurrencySymbol;
                                            //}
                                        }
                                        else if (strFormatType == "Indonesian Rupaiah")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("en-ID")).ToString();
                                        }
                                        else if (strFormatType == "Pound Sterling")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("en-GB")).ToString();
                                        }
                                        else if (strFormatType == "Hungarian Forient")
                                        {
                                            //if (isDecimal)
                                            //{
                                            //    RegionInfo ad = new RegionInfo("hu-HU");
                                            //    row[ele.Key] = ad.CurrencySymbol + Convert.ToDouble(row[ele.Key]).ToString("N");
                                            //}
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("hu-HU")).ToString();
                                        }
                                        else if (strFormatType == "Bolivian Boliviano")
                                        {
                                            if (isDecimal)
                                                row[ele.Key] = Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("es-BO")).ToString();
                                        }

                                        else if (strFormatType == "Singapore Dollar")

                                        {
                                            if (isDecimal)
                                                row[ele.Key] = "S" + Convert.ToDouble(row[ele.Key]).ToString("C", new CultureInfo("en-SG")).ToString();
                                        }
                                    }

                                    //Datetime Related
                                    else if (strFormatType == "MM/DD/YY")
                                    {
                                        row[ele.Key] = Convert.ToDateTime(row[ele.Key].ToString()).ToString("MM/dd/yy").ToString();
                                    }
                                    else if (strFormatType == "DD/MM/YY")
                                    {
                                        row[ele.Key] = Convert.ToDateTime(row[ele.Key].ToString()).ToString("dd/MM/yy").ToString();
                                    }
                                    else if (strFormatType == "D Month, Yr")
                                    {
                                        row[ele.Key] = Convert.ToDateTime(row[ele.Key].ToString()).ToString("d MMM, yy").ToString();
                                    }
                                    else if (strFormatType == "YY/MM/DD")
                                    {
                                        row[ele.Key] = Convert.ToDateTime(row[ele.Key].ToString()).ToString("yy/MM/dd").ToString();
                                    }



                                }
                            }
                        }
                    }
                }
            }



            var dicObj = new Dictionary<string, object>();

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row1;

            foreach (DataRow dr in dtResults.Rows)
            {
                row1 = new Dictionary<string, object>();
                foreach (DataColumn col in dtResults.Columns)
                {
                    row1.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row1);
            }


            dynamic serializeQuery = serializer.Serialize(rows);

            return serializeQuery;
        }

        public WidgetDynamicQueryReturnModel CustomWidgetNameValidator(CustomWidgetsInputModel widgetInputs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "CustomWidgetNameValidator", "CustomWidgetsInputModel", widgetInputs, "Widget Service"));

            if (!WidgetsValidationHelpers.UpsertCustomWidgetValidations(widgetInputs, true, loggedInContext, validationMessages))
            {
                return null;
            }

            var isValidated = _widgetRepository.CustomWidgetNameValidator(widgetInputs, loggedInContext, validationMessages);

            if (isValidated != false)
            {
                var dynamicQueryModel = new WidgetDynamicQueryModel();
                dynamicQueryModel.DynamicQuery = widgetInputs.WidgetQuery;
                dynamicQueryModel.CustomWidgetId = widgetInputs.CustomWidgetId;
                dynamicQueryModel.IsMongoQuery = widgetInputs.IsMongoQuery;
                dynamicQueryModel.CollectionName = widgetInputs.CollectionName;
                WidgetDynamicQueryReturnModel queryResult = GetWidgetDynamicQueryResult(dynamicQueryModel, loggedInContext, validationMessages, false);
                return queryResult;
            }

            return new WidgetDynamicQueryReturnModel();
        }

        public WidgetDynamicQueryReturnModel GetCustomGridData(CustomWidgetSearchCriteriaInputModel widgetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCustomGridData", "CustomWidgetSearchCriteriaInputModel", widgetSearchCriteriaInputModel, "Widget Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            //var customWidgetData = widgetSearchCriteriaInputModel.GetSubQuery.HasValue && widgetSearchCriteriaInputModel.GetSubQuery.Value == true ?
            //                        GetSubQueryForCustomWidget(widgetSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault()
            //                    : GetCustomWidgets(widgetSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();


            //_widgetRepository.GetBasicCustomWidgetDetails(widgetSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            var customWidgetDetails = _widgetRepository.GetBasicCustomWidgetDetails(widgetSearchCriteriaInputModel, loggedInContext, validationMessages);

            Parallel.ForEach(customWidgetDetails.Where(p => p.IsHtml != true).ToList(), customWidget =>
            {
                customWidget.AllChartsDetails = Utilities.GetObjectFromXml<CustomAppChartModel>(customWidget.CustomWidgetsMultipleChartsXML, "CustomWidgetsMultipleChartsModel");
            });

            var customWidgetData = customWidgetDetails.FirstOrDefault();

            WidgetDynamicQueryModel widgetDynamicQueryModel = new WidgetDynamicQueryModel()
            {
                DynamicQuery = widgetSearchCriteriaInputModel.GetSubQuery.HasValue && widgetSearchCriteriaInputModel.GetSubQuery.Value == true ? customWidgetData?.SubQuery : customWidgetData?.WidgetQuery,
                IsSubQuery = widgetSearchCriteriaInputModel.GetSubQuery,
                Name = customWidgetData?.CustomWidgetName,
                AllChartsDetails = customWidgetData?.AllChartsDetails,
                SubmittedFormId = widgetSearchCriteriaInputModel?.SubmittedFormId,
                WorkspaceId = widgetSearchCriteriaInputModel?.WorkspaceId,
                DashboardFilters = widgetSearchCriteriaInputModel?.DashboardFilters,
                DashboardId = widgetSearchCriteriaInputModel?.DashboardId,
                Description = customWidgetData?.Description,
                //DoSubQueryExists = !string.IsNullOrWhiteSpace(customWidgetData?.SubQuery),
                SubQueryType = customWidgetData?.SubQueryType,
                CustomWidgetId = widgetSearchCriteriaInputModel.CustomWidgetId,
                IsAll = widgetSearchCriteriaInputModel.IsAll,
                IsReportingOnly = widgetSearchCriteriaInputModel.IsReportingOnly,
                IsMyself = widgetSearchCriteriaInputModel.IsMyself,
                IsMongoQuery = customWidgetData?.IsMongoQuery,
                CollectionName = customWidgetData?.CollectionName
            };

            return GetWidgetDynamicQueryResult(widgetDynamicQueryModel, loggedInContext, validationMessages, true);
        }

        //public string GetWidgetFilterQueryBuilder(WidgetDynamicQueryModel widgetDynamicQueryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWidgetFilterQueryBuilder", "WidgetDynamicQueryModel", widgetDynamicQueryModel, "Widget Service"));

        //    if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
        //    {
        //        return null;
        //    }

        //    var jsonData = JsonConvert.DeserializeObject<QueryBuilder>(widgetDynamicQueryModel.DynamicQuery);

        //    var dynamicQuery = QueryBuilder(jsonData.Condition, jsonData.Rules, "");

        //    if (dynamicQuery == null || dynamicQuery == "")
        //    {
        //        return "";
        //    }

        //    return "where (" + dynamicQuery + ")";
        //}

        public bool? SetAsDefaultDashboardPersistance(WorkspaceInputModel workspaceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SetAsDefaultDashboardPersistance", "workspaceId", workspaceModel.WorkspaceId, "Workspace Service"));

            WidgetsValidationHelpers.WorkspaceIdValidations(workspaceModel.WorkspaceId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppConstants.Widgets, workspaceModel.WorkspaceId, loggedInContext);

            _widgetRepository.SetAsDefaultDashboardPersistance(workspaceModel, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return true;
        }

        public bool? SetAsDefaultDashboardView(WorkspaceInputModel workspace, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SetAsDefaultDashboardView", "workspaceId", workspace?.WorkspaceId, "Workspace Service"));

            WidgetsValidationHelpers.WorkspaceIdValidations(workspace?.WorkspaceId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppConstants.Widgets, workspace?.WorkspaceId, loggedInContext);

            _widgetRepository.SetAsDefaultDashboardView(workspace, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return true;
        }

        public bool? SetDashboardsOrder(DashboardOrderSearchCriteriaInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SetDashboardsOrder", "workspaceId", dashboardInputModel?.WorkspaceId, "Workspace Service"));

            WidgetsValidationHelpers.WorkspaceIdValidations(dashboardInputModel?.WorkspaceId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            string dashboardIdsXml;

            if (dashboardInputModel != null && dashboardInputModel.DashboardIds.Count > 0)
            {
                dashboardIdsXml = Utilities.ConvertIntoListXml(dashboardInputModel.DashboardIds);
            }
            else
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReorderQuestionIds
                });

                return null;
            }

            _auditService.SaveAudit(AppConstants.Widgets, dashboardInputModel?.WorkspaceId, loggedInContext);

            _widgetRepository.SetDashboardsOrder(dashboardInputModel, dashboardIdsXml, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }
            return true;
        }
        public bool? ResetToDefaultDashboard(Guid? workspaceId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ResetToDefaultDashboard", "workspaceId", workspaceId, "Workspace Service"));

            WidgetsValidationHelpers.WorkspaceIdValidations(workspaceId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppConstants.Widgets, workspaceId, loggedInContext);

            _widgetRepository.ResetToDefaultDashboard(workspaceId, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return true;
        }

        private string QueryBuilder(string condition, List<QueryRule> query, string filterQuery)
        {
            var rulesCount = query.Where(p => (p.Value != null && p.Value != "") || p.Rules != null).ToList().Count;
            foreach (var queryRule in query.Where(p => (p.Value != null && p.Value != "") || p.Rules != null).ToList())
            {
                if (queryRule.Field != null && queryRule.Operator != null && queryRule.Value != null)
                {
                    filterQuery = filterQuery + "( " + GetSqlQuery(queryRule.Field, queryRule.Operator, queryRule.Value) + " )";
                }

                if (rulesCount > 1)
                {
                    filterQuery = filterQuery + " " + condition + " ";
                }

                if (queryRule.Rules != null && queryRule.Rules.Count > 0)
                {
                    filterQuery = filterQuery + "( " + QueryBuilder(queryRule.Condition, queryRule.Rules, "") + " )";
                }

                rulesCount--;
            }

            return filterQuery;
        }

        private string GetSqlQuery(string queryField, string queryOperator, string queryValue)
        {
            if (queryOperator == "Equals")
            {
                return "[" + queryField + "]" + " = '" + queryValue + "'";
            }

            if (queryOperator == "Does not Equal")
            {
                return "[" + queryField + "]" + " <> '" + queryValue + "'";
            }

            if (queryOperator == "Starts With")
            {
                return "[" + queryField + "]" + " LIKE '" + queryValue + "%'";
            }

            if (queryOperator == "Ends With")
            {
                return "[" + queryField + "]" + " LIKE '%" + queryValue + "'";
            }

            if (queryOperator == "Contains")
            {
                return "[" + queryField + "]" + " LIKE '%" + queryValue + "%'";
            }

            if (queryOperator == "Does Not Contain")
            {
                return "[" + queryField + "]" + " NOT LIKE '%" + queryValue + "%'";
            }

            if (queryOperator == "Does Not Start With")
            {
                return "[" + queryField + "]" + " NOT LIKE '" + queryValue + "%'";
            }

            if (queryOperator == "Does Not End With")
            {
                return "[" + queryField + "]" + " NOT LIKE '%" + queryValue + "'";
            }

            if (queryOperator == "Greater")
            {
                return "[" + queryField + "]" + " > " + queryValue;
            }

            if (queryOperator == "Equal or Greater" || queryOperator == "On or After")
            {
                return "[" + queryField + "]" + " >= " + queryValue;
            }

            if (queryOperator == "On or After date")
            {
                return "[" + queryField + "]" + " >= '" + queryValue + "'";
            }

            if (queryOperator == "Date Equals to")
            {
                return "[" + queryField + "]" + " = '" + queryValue + "'";
            }

            if (queryOperator == "Less")
            {
                return "[" + queryField + "]" + " < " + queryValue;
            }

            if (queryOperator == "Before date")
            {
                return "[" + queryField + "]" + " < '" + queryValue + "'";
            }

            if (queryOperator == "Equal or Less")
            {
                return "[" + queryField + "]" + " <= " + queryValue;
            }

            return "";
        }

        public int? UpsertCronExpression(CronExpressionInputModel cronExpressionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            UpsertCronExpressionApiReturnModel upsertCronExpressionApiReturnModel = new UpsertCronExpressionApiReturnModel();

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCronExpression", "cronExpressionInputModel", cronExpressionInputModel, "Widgets Service"));

            CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            cronExpressionInputModel.FileUrl = _fileStoreService.UploadFiles(companyModel, cronExpressionInputModel, loggedInContext, validationMessages);

            cronExpressionInputModel.ChartsUrls = JsonConvert.SerializeObject(cronExpressionInputModel.FileUrl);

            upsertCronExpressionApiReturnModel = _widgetRepository.UpsertCronExpression(cronExpressionInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertRateTypeCommandId, cronExpressionInputModel, loggedInContext);

            cronExpressionInputModel.UserId = upsertCronExpressionApiReturnModel.UserId;

            cronExpressionInputModel.NewCronExpressionId = upsertCronExpressionApiReturnModel.CronExpressionId;

            RunSchedulingJobs(cronExpressionInputModel, loggedInContext, validationMessages, upsertCronExpressionApiReturnModel.JobId);

            return upsertCronExpressionApiReturnModel.JobId;
        }

        public Guid? UpsertDashboardVisuaizationType(DashboardInputModel dashboardModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertDashboardVisuaizationType", "dashboardModel", dashboardModel, "Widgets Service"));
            dashboardModel.CustomAppVisualizationId = _widgetRepository.UpsertDashboardVisuaizationType(dashboardModel, loggedInContext, validationMessages);
            _auditService.SaveAudit(AppCommandConstants.UpsertRateTypeCommandId, dashboardModel, loggedInContext);
            return dashboardModel.CustomAppVisualizationId;
        }

        public Guid? UpsertCustomWidgetSubQuery(CustomWidgetSearchCriteriaInputModel widgetInputs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCustomWidgetSubQuery", "CustomWidgetSearchCriteriaInputModel", widgetInputs, "Widgets Service"));
            Guid? widgetId = _widgetRepository.UpsertCustomWidgetSubQuery(widgetInputs, loggedInContext, validationMessages);
            _auditService.SaveAudit(AppConstants.Widgets, widgetInputs, loggedInContext);
            return widgetId;
        }

        public CustomeHtmlAppDetailsSearchOutputModel GetCustomeHtmlAppDetails(Guid? customHtmlAppId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCustomeHtmlAppDetails", "customHtmlAppId", customHtmlAppId, "Widgets Service"));
            List<CustomeHtmlAppDetailsOutputModel> customeHtmlApps = _widgetRepository.GetCustomeHtmlAppDetails(customHtmlAppId, loggedInContext, validationMessages);
            return ConvertToModel(customeHtmlApps);
        }

        public void RunSchedulingJobs(CronExpressionInputModel cronExpressionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, int? jobId)
        {
            try
            {
                if (cronExpressionInputModel.RunNow == false)
                {
                    RecurringJob.RemoveIfExists(cronExpressionInputModel.JobId.ToString());
                }
                if (cronExpressionInputModel.TemplateType == "Email")
                {
                    if (jobId != null && cronExpressionInputModel.RunNow == false)
                    {
                        cronExpressionInputModel.CronExpression = cronExpressionInputModel.CronExpression.Replace('?', '*');
                        RecurringJob.AddOrUpdate(jobId.ToString(),
                        () => PostMethod(cronExpressionInputModel, loggedInContext, validationMessages),
                            cronExpressionInputModel.CronExpression);

                        PushNotifications(cronExpressionInputModel, loggedInContext, validationMessages);
                    }
                    else if (cronExpressionInputModel.RunNow == true)
                    {
                        PostMethod(cronExpressionInputModel, loggedInContext, validationMessages);

                        PushNotifications(cronExpressionInputModel, loggedInContext, validationMessages);
                    }
                }
                else if (cronExpressionInputModel.TemplateType == "Webhook")
                {
                    if (jobId != null && cronExpressionInputModel.RunNow == false)
                    {
                        cronExpressionInputModel.CronExpression = cronExpressionInputModel.CronExpression.Replace('?', '*');

                        RecurringJob.AddOrUpdate(jobId.ToString(),
                            () => PushMessagesToSlack(cronExpressionInputModel, loggedInContext, validationMessages), cronExpressionInputModel.CronExpression);

                        PushNotifications(cronExpressionInputModel, loggedInContext, validationMessages);
                    }
                    else if (cronExpressionInputModel.RunNow == true)
                    {
                        PushMessagesToSlack(cronExpressionInputModel, loggedInContext, validationMessages);

                        PushNotifications(cronExpressionInputModel, loggedInContext, validationMessages);
                    }
                }

                //else
                //{
                //    if (cronExpressionInputModel.RunNow == false)
                //    {
                //        cronExpressionInputModel.CronExpression = cronExpressionInputModel.CronExpression.Replace('?', '*');

                //        RecurringJob.AddOrUpdate(jobId.ToString(),
                //            () => PushNotifications(cronExpressionInputModel, loggedInContext, validationMessages), cronExpressionInputModel.CronExpression);
                //    }
                //    else
                //    {
                //        PushNotifications(cronExpressionInputModel, loggedInContext, validationMessages);
                //    }
                //}
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "RunSchedulingJobs", "WidgetService ", exception.Message), exception);

            }

        }

        public void PostMethod(CronExpressionInputModel cronExpressionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);

            var html = _goalRepository.GetHtmlTemplateByName("VisualizationTemplate", loggedInContext.CompanyGuid);

            string FileUrlHtml = string.Empty;

            foreach (var x in cronExpressionInputModel.FileUrl)
            {
                if (x.Filetype == "application/pdf")
                {
                    FileUrlHtml += "<h3><a href =" + x.FileUrl + ">" + x.FileName + "</a></h3 >";
                }
                else
                {
                    FileUrlHtml += "<h3 style = \"padding: 0px; margin: 0px\">" + x.FileName + "</h3>";
                    FileUrlHtml += "<img src=" + x.FileUrl + " " + "alt=\"IMAGES\" style=\"width: 100 %; height: 100 %; padding: 0px; margin: 0px\"/>";

                }
            }

            if (cronExpressionInputModel.FileUrl.Count == 0)
            {
                FileUrlHtml += "<h3 style = \"padding: 0px; margin: 0px\">" + cronExpressionInputModel.SelectedChartName + "</h3>";
            }

            var formattedHtml = html.Replace("##FileURLS##", FileUrlHtml);

            var toAddresses = cronExpressionInputModel.TemplateUrl.Split(',');
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpServer = smtpDetails?.SmtpServer,
                SmtpServerPort = smtpDetails?.SmtpServerPort,
                SmtpMail = smtpDetails?.SmtpMail,
                SmtpPassword = smtpDetails?.SmtpPassword,
                ToAddresses = toAddresses,
                HtmlContent = formattedHtml,
                Subject = "Snovasys Business Suite: Schedules Data",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);

            //var viewsPath = Path.GetFullPath(HostingEnvironment.MapPath(@"~/Views/Emails"));

            //var eng = new FileSystemRazorViewEngine(viewsPath);

            //ViewEngines.Engines.Insert(0, eng);

            //var emailService = new EmailService();

            //EmailTemplateInputModel emailModel = SendScheduledVisualization(cronExpressionInputModel);
            //try
            //{
            //    emailService.Send(emailModel);
            //}
            //catch (Exception exception)
            //{
            //    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ForgotPassword", "Login Api", exception));
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = string.Format(ValidationMessages.MailNotSend)
            //    });
            //}
            //ViewEngines.Engines.RemoveAt(0);
        }
        //private static EmailTemplateInputModel SendScheduledVisualization(CronExpressionInputModel model)
        //{
        //    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Send Reset Password Mail", "Reset Password Service"));

        //    if (model?.FileUrl != null)
        //    {
        //        EmailTemplateInputModel email = new EmailTemplateInputModel("ScheduledVisualizationTemplate")
        //        {

        //            FileUrl = model.FileUrl,
        //            To = model.TemplateUrl
        //        };

        //        return email;
        //    }
        //    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Send Reset Password Mail", "Reset Password Service"));
        //    return null;
        //}

        public async Task PushMessagesToSlack(CronExpressionInputModel cronExpressionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ConvertHtmlToImageAndPushMessageToSlack", "Update goal service"));
            try
            {

                List<MessageAttachmentsModel> messageAttachmentsModels = new List<MessageAttachmentsModel>();

                foreach (var fileUrl in cronExpressionInputModel.FileUrl)
                {
                    MessageAttachmentsModel messageAttachmentsModel = new MessageAttachmentsModel();

                    if (fileUrl.Filetype == "application/pdf")
                    {
                        messageAttachmentsModel.title = fileUrl.FileUrl;
                    }

                    else
                    {
                        messageAttachmentsModel.image_url = fileUrl.FileUrl;
                    }

                    messageAttachmentsModels.Add(messageAttachmentsModel);

                }

                PushMessageInputModel pushMessageInputModel = new PushMessageInputModel
                {
                    text = cronExpressionInputModel.CronExpressionName,
                    attachments = messageAttachmentsModels
                };

                string message = new JavaScriptSerializer().Serialize(pushMessageInputModel);

                LoggingManager.Debug(message);

                HttpClient client = new HttpClient();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, cronExpressionInputModel.TemplateUrl)
                {
                    Content = new StringContent(message, Encoding.UTF8, "application/json")
                };

                await client.SendAsync(request);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PushMessagesToSlack", "WidgetService ", exception.Message), exception);

            }
        }

        public void PushNotifications(CronExpressionInputModel cronExpressionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (cronExpressionInputModel.CronExpressionId == null)
            {
                _notificationService.SendNotification(new MultiChartsAssignedNotification(
                string.Format(NotificationSummaryConstants.ChartsCreatedMessage, cronExpressionInputModel.CustomAppName),
                loggedInContext.LoggedInUserId,
                (cronExpressionInputModel.UserId == null) ? loggedInContext.LoggedInUserId : (Guid)cronExpressionInputModel.UserId,
                cronExpressionInputModel.CronExpressionId,
                cronExpressionInputModel.CronExpressionName
                ), loggedInContext, loggedInContext.LoggedInUserId);
            }
        }

        public Guid? UpsertWorkspaceDashboardFilter(WorkspaceDashboardFilterInputModel workspaceDashboardFilterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Workspace Dashboard Filter", "DashboardModel", workspaceDashboardFilterInputModel, "Widget Service"));

            if (validationMessages.Count > 0)
            {
                return null;
            }

            return _widgetRepository.UpsertWorkspaceDashboardFilter(workspaceDashboardFilterInputModel, loggedInContext, validationMessages);
        }

        public List<WorkspaceDashboardFilterOutputModel> GetWorkspaceDashboardFilters(WorkspaceDashboardFilterInputModel workspaceDashboardFilterInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Workspace Dashboard Filter", "DashboardModel", workspaceDashboardFilterInputModel, "Widget Service"));

            if (validationMessages.Count > 0)
            {
                return new List<WorkspaceDashboardFilterOutputModel>();
            }

            List<WorkspaceDashboardFilterOutputModel> widgetFilterDetails = _widgetRepository.GetWorkspaceDashboardFilters(workspaceDashboardFilterInputModel, loggedInContext, validationMessages);

            return widgetFilterDetails;
        }

        public static CustomeHtmlAppDetailsSearchOutputModel ConvertToModel(List<CustomeHtmlAppDetailsOutputModel> htmlAppDetailsOutputModels)
        {
            var customHtmlAppRoleIds = from s in htmlAppDetailsOutputModels orderby s.CustomHtmlAppName select s.RoleId;

            CustomeHtmlAppDetailsOutputModel customeHtmlAppDetailsOutputModel = htmlAppDetailsOutputModels.FirstOrDefault();

            return new CustomeHtmlAppDetailsSearchOutputModel
            {
                CustomHtmlAppName = customeHtmlAppDetailsOutputModel.CustomHtmlAppName,
                Description = customeHtmlAppDetailsOutputModel.Description,
                HtmlCode = customeHtmlAppDetailsOutputModel.HtmlCode,
                RoleId = new List<Guid?>(customHtmlAppRoleIds)
            };
        }

        public Guid? UpsertProcInputsAndOuputs(ProcInputsAndOutputModel procInputsAndOutputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertProcInputsAndOuputs", "procInputsAndOutputModel", procInputsAndOutputModel, "Widget Service"));

            if (!WidgetsValidationHelpers.UpsertProcInputsAndOuputs(procInputsAndOutputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (procInputsAndOutputModel.Inputs != null || procInputsAndOutputModel.Outputs != null)
            {
                procInputsAndOutputModel.InputsJson = JsonConvert.SerializeObject(procInputsAndOutputModel.Inputs);

                procInputsAndOutputModel.OutputsJson = JsonConvert.SerializeObject(procInputsAndOutputModel.Outputs);
            }

            Guid? widgetId = _widgetRepository.UpsertProcInputsAndOuputs(procInputsAndOutputModel, loggedInContext, validationMessages);

            return null;
        }

        public ProcInputsAndOutputModel GetProcInputsAndOuputs(ProcInputsAndOutputModel procInputsAndOutputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetProcInputsAndOuputs", "procInputsAndOutputModel", procInputsAndOutputModel, "Widget Service"));

            //if (!WidgetsValidationHelpers.UpsertProcInputsAndOuputs(procInputsAndOutputModel, loggedInContext, validationMessages))
            //{
            //    return null;
            //}

            ProcInputsAndOutputModel procInputsAndOutput = _widgetRepository.GetProcInputsAndOuputs(procInputsAndOutputModel, loggedInContext, validationMessages);

            if (procInputsAndOutput != null && procInputsAndOutput.InputsJson != null && procInputsAndOutput.InputsJson != "null")
            {
                procInputsAndOutput.Inputs = JsonConvert.DeserializeObject<List<InputsModel>>(procInputsAndOutput.InputsJson);
            }

            if (procInputsAndOutput != null && procInputsAndOutput.OutputsJson != null && procInputsAndOutput.OutputsJson != "null")
            {
                procInputsAndOutput.Outputs = JsonConvert.DeserializeObject<List<OutputsModel>>(procInputsAndOutput.OutputsJson);
            }


            if (!string.IsNullOrEmpty(procInputsAndOutput.LegendsJson))
            {
                procInputsAndOutput.Legends = JsonConvert.DeserializeObject<List<LegendsModel>>(procInputsAndOutput.LegendsJson);
            }

            if (procInputsAndOutput != null && procInputsAndOutput.LegendsJson != null && procInputsAndOutput.LegendsJson != "null")
            {
                procInputsAndOutput.Legends = JsonConvert.DeserializeObject<List<LegendsModel>>(procInputsAndOutput.LegendsJson);
            }

            if (procInputsAndOutputModel.IsForDashBoard == true)
            {
                CustomWidgetSearchCriteriaInputModel widgetSearchCriteriaInputModel = new CustomWidgetSearchCriteriaInputModel();

                widgetSearchCriteriaInputModel.CustomWidgetId = procInputsAndOutputModel.CustomWidgetId;

                var customWidgetData = GetCustomWidgets(widgetSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

                procInputsAndOutput.CustomWidgetName = customWidgetData.CustomWidgetName;

                procInputsAndOutput.AllChartsDetails = customWidgetData.AllChartsDetails;
            }

            return procInputsAndOutput;
        }

        public string ReorderTags(List<Guid> tagIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            string tagIdsXml;

            if (tagIds != null && tagIds.Count > 0)
            {
                tagIdsXml = Utilities.ConvertIntoListXml(tagIds);
            }
            else
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReorderQuestionIds
                });

                return null;
            }

            _widgetRepository.ReorderTags(tagIdsXml, loggedInContext, validationMessages);

            return "Success";
        }

        public void DateFromDateTo(string filterName)
        {
            _dateFrom = new DateTime();
            _dateTo = new DateTime();
            DateTime now = DateTime.Today;
            if (filterName == "lastMonth")
            {
                var dFirstDayOfThisMonth = DateTime.Today.AddDays(-(DateTime.Today.Day - 1));
                _dateTo = dFirstDayOfThisMonth.AddDays(-1);
                _dateFrom = dFirstDayOfThisMonth.AddMonths(-1);
                //_dateFrom = new DateTime(now.Year, now.Month - 1, 1);
                //_dateTo = new DateTime(now.Year, now.Month, 1).AddDays(-1);
            }
            else if (filterName == "thisMonth")
            {
                var dFirstDayOfThisMonth = DateTime.Today.AddDays(-(DateTime.Today.Day - 1));
                _dateFrom = DateTime.Today.AddDays(-(DateTime.Today.Day - 1));
                _dateTo = dFirstDayOfThisMonth.AddMonths(1).AddDays(-1);

            }
            else if (filterName == "lastWeek")
            {
                _dateFrom = FirstDayOfWeek(now.AddDays(-7));
                _dateTo = LastDayOfWeek(now.AddDays(-7));
            }
            else if (filterName == "nextWeek")
            {
                _dateFrom = FirstDayOfWeek(now.AddDays(7));
                _dateTo = LastDayOfWeek(now.AddDays(7));
            }
        }

        public static DateTime FirstDayOfWeek(DateTime date)
        {
            DayOfWeek fdow = CultureInfo.CurrentCulture.DateTimeFormat.FirstDayOfWeek;
            int offset = fdow - date.DayOfWeek;
            DateTime fdowDate = date.AddDays(offset);
            return fdowDate.AddDays(1);
        }

        public static DateTime LastDayOfWeek(DateTime date)
        {
            DateTime ldowDate = FirstDayOfWeek(date).AddDays(6);
            return ldowDate;
        }

        public bool IsHavingSystemAppAccess(string widgetName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "IsHavingSystemAppAccess", "Widget Service"));
            bool output = _widgetRepository.IsHavingSystemAppAccess(widgetName, loggedInContext, validationMessages);

            return output;
        }

        public Guid? UpsertDynamicModule(DynamicModuleUpsertModel dynamicModuleUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDynamicModule", "Widget Service"));
            
            LoggingManager.Debug(dynamicModuleUpsertModel.ToString());
           
            dynamicModuleUpsertModel.DynamicTabsXML = dynamicModuleUpsertModel.DynamicTabs != null ? dynamicModuleUpsertModel.DynamicTabsXML = Utilities.ConvertIntoListXml(dynamicModuleUpsertModel.DynamicTabs) : null;

            var dynamicModuleResult = _widgetRepository.UpsertDynamicModule(dynamicModuleUpsertModel, loggedInContext, validationMessages);

            return dynamicModuleResult;
        }

        public List<DynamicModuleUpsertModel> GetDynamicModules(DynamicModuleUpsertModel dynamicModuleUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDynamicModules", "Widget Service"));

            LoggingManager.Debug(dynamicModuleUpsertModel.ToString());

            return _widgetRepository.GetDynamicModules(dynamicModuleUpsertModel, loggedInContext, validationMessages);
            
            //List<DynamicModuleUpsertModel> upsertModels = new List<DynamicModuleUpsertModel>();
            
            //foreach(var data in dynamicModuleResult)
            //{
            //    if(data.DynamicTabsXML != null && data.DynamicTabsXML != string.Empty)
            //    {
            //        data.DynamicTabs = Utilities.GetObjectFromXml<DynamicTabs>(data.DynamicTabsXML, "DynamicTabs");
            //        data.DynamicTabsXML = null;
            //    }

            //    upsertModels.Add(data);
            //}

            //return upsertModels;
        }
        public List<DynamicTabs> GetDynamicModuleTabs(DynamicModuleUpsertModel dynamicModuleUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDynamicModules", "Widget Service"));

            LoggingManager.Debug(dynamicModuleUpsertModel.ToString());

            return _widgetRepository.GetDynamicModuleTabs(dynamicModuleUpsertModel, loggedInContext, validationMessages);
        }

        public List<string> GetMongoCollections(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMongoCollections", "Widget Service"));

            var data = _dataSetService.GetMongoCollections(loggedInContext, validationMessages).Result;

            return data;
        }
        public List<GetCO2EmmisionReportOutputModel> GetCO2EmmisionReport(GetCO2EmmisionReportInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCO2EmmisionReport", "Widget Service"));

            return _dataSetService.GetCO2EmmisionReport(inputModel, loggedInContext, validationMessages).Result;
        }
    }
    
}
