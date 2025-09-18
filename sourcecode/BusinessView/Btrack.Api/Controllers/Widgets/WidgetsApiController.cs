using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Branch;
using Btrak.Models.ComplianceAudit;
using Btrak.Models.HrManagement;
using Btrak.Models.MasterData;
using Btrak.Models.Role;
using Btrak.Models.Widgets;
using Btrak.Services.CompanyStructure;
using Btrak.Services.ComplianceAudit;
using Btrak.Services.FileUploadDownload;
using Btrak.Services.GenericForm;
using Btrak.Services.HrManagement;
using Btrak.Services.MasterData;
using Btrak.Services.TestRail;
using Btrak.Services.Widgets;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Results;
using System.Data;

namespace BTrak.Api.Controllers.Widgets
{
    public class WidgetsApiController : AuthTokenApiController
    {
        private readonly IWidgetService _widgetService;
        private readonly IFileStoreService _fileStoreService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly ITestSuiteService _testSuiteService;
        private readonly IComplianceAuditService _complianceAuditService;
        private readonly IGenericFormService _genericFormService;
        private readonly IHrManagementService _hrManagementService;
        private readonly ProductivityDashboardRepository _productivityDashboardRepository;
        private readonly BranchRepository _branchRepository;
        private readonly DesignationRepository _designationRepository;
        private readonly RoleRepository _roleRepository;
        private readonly DepartmentRepository _departmentRepository;
        private readonly BusinessSuiteRepository _businessSuiteRepository;
        private readonly ICustomApiAppService _customApiService;
        private readonly IMasterDataManagementService _masterDataManagementService;


        public WidgetsApiController(DepartmentRepository departmentService, RoleRepository roleService, DesignationRepository designationService, BranchRepository branchService, ProductivityDashboardRepository productivityDashboardSevice, IWidgetService widgetService, IFileStoreService fileStoreService, ICompanyStructureService companyStructureService, ITestSuiteService testSuiteService, IGenericFormService genericFormService, IHrManagementService hrManagementService,
            BusinessSuiteRepository businessSuiteRepository, ICustomApiAppService customApiAppService, IComplianceAuditService complianceAuditService,
            IMasterDataManagementService masterDataManagementService)
        {
            _complianceAuditService = complianceAuditService;
            _widgetService = widgetService;
            _fileStoreService = fileStoreService;
            _companyStructureService = companyStructureService;
            _testSuiteService = testSuiteService;
            _genericFormService = genericFormService;
            _hrManagementService = hrManagementService;
            _productivityDashboardRepository = productivityDashboardSevice;
            _branchRepository = branchService;
            _designationRepository = designationService;
            _roleRepository = roleService;
            _departmentRepository = departmentService;
            _businessSuiteRepository = businessSuiteRepository;
            _customApiService = customApiAppService;
            _masterDataManagementService = masterDataManagementService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertWidget)]
        public JsonResult<BtrakJsonResult> UpsertWidget(WidgetInputModel widgetInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertWidget", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? widgetId = _widgetService.UpsertWidget(widgetInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWidget", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWidget", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgetId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWidget", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWidgets)]
        public JsonResult<BtrakJsonResult> GetWidgets(WidgetSearchCriteriaInputModel widgetSearchCriteriaInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWidgets", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<WidgetApiReturnModel> widgets = _widgetService.GetWidgets(widgetSearchCriteriaInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWidgets", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWidgets", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgets, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWidgets", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertImportWidget)]
        public JsonResult<BtrakJsonResult> UpsertImportWidget(WidgetInputModel widgetInputModel )
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertImportWidget", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? widgetId = _widgetService.UpsertImportWidget(widgetInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertImportWidget", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertImportWidget", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgetId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertImportWidget", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetWidgetTags)]
        public JsonResult<BtrakJsonResult> GetWidgetTags(bool? isFromSearch)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWidgets", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<TagApiReturnModel> widgets = _widgetService.GetWidgetTags(isFromSearch, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWidgets", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWidgets", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgets, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWidgetTags", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ReorderTags)]
        public JsonResult<BtrakJsonResult> ReOrderWidgetTagsForUser(List<Guid> tagIds)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReorderTags", "Widget Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                _widgetService.ReorderTags(tagIds, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReorderTags", "Widget Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReorderTags", "Widget Api"));
                return Json(new BtrakJsonResult { Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReOrderWidgetTagsForUser", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertDashboardConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertDashboardConfiguration(DashboardConfigurationInputModel dashboardConfigurationInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDashboardConfiguration", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? configurationId = _widgetService.UpsertDashboardConfiguration(dashboardConfigurationInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDashboardConfiguration", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDashboardConfiguration", "Widget Api"));
                return Json(new BtrakJsonResult { Data = configurationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDashboardConfiguration", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDashboardConfigurations)]
        public JsonResult<BtrakJsonResult> GetDashboardConfigurations(DashboardConfigurationInputModel dashboardConfigurationInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDashboardConfigurations", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<DashboardConfigurationReturnModel> widgets = _widgetService.GetDashboardConfigurations(dashboardConfigurationInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDashboardConfigurations", "Widget Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDashboardConfigurations", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgets, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDashboardConfigurations", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWidgetsBasedOnUser)]
        public JsonResult<BtrakJsonResult> GetWidgetsBasedOnUser(WidgetSearchCriteriaInputModel widgetSearchCriteriaInput)
       {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWidgetsBasedOnUser", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<WidgetApiReturnModel> widgets = _widgetService.GetWidgetsBasedOnUser(widgetSearchCriteriaInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWidgetsBasedOnUser", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWidgetsBasedOnUser", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgets, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWidgetsBasedOnUser", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWidgetTagsAndWorkspaces)]
        public JsonResult<BtrakJsonResult> GetWidgetTagsAndWorkspaces(List<WidgetTagsAndWorkspaceModel> widgetSearchCriteriaInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWidgetsBasedOnUser", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<WidgetTagsAndWorkspaceReturnModel> widgets = _widgetService.GetWidgetTagsAndWorkspaces(widgetSearchCriteriaInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWidgetsBasedOnUser", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWidgetsBasedOnUser", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgets, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWidgetTagsAndWorkspaces", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.AddWidgetToFavourites)]
        public JsonResult<BtrakJsonResult> AddWidgetToFavourites(FavouriteWidgetsInputModel widgetSearchCriteriaInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AddWidgetToFavourites", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var widgets = _widgetService.AddWidgetToFavourites(widgetSearchCriteriaInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AddWidgetToFavourites", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AddWidgetToFavourites", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgets, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AddWidgetToFavourites", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllWidgets)]
        public JsonResult<BtrakJsonResult> GetAllWidgets(WidgetSearchCriteriaInputModel widgetSearchCriteriaInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllWidgets", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<WidgetApiReturnModel> widgets = _widgetService.GetAllWidgets(widgetSearchCriteriaInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllWidgets", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllWidgets", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgets, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllWidgets", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertWorkspace)]
        public JsonResult<BtrakJsonResult> UpsertWorkspace(WorkspaceInputModel workspaceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertWorkspace", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? workspaceId = _widgetService.UpsertWorkspace(workspaceInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkspace", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkspace", "Widget Api"));
                return Json(new BtrakJsonResult { Data = workspaceId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkspace", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertChildWorkspace)]
        public JsonResult<BtrakJsonResult> UpsertChildWorkspace(WorkspaceInputModel workspaceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertWorkspace", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? workspaceId = _widgetService.UpsertWorkspace(workspaceInputModel, LoggedInContext, validationMessages);
                Guid? RelationId = _widgetService.UpsertChildWorkspace(workspaceId.Value, workspaceInputModel.parentId.Value, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkspace", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkspace", "Widget Api"));
                return Json(new BtrakJsonResult { Data = workspaceId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkspace", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertDuplicateDashboard)]
        public JsonResult<BtrakJsonResult> InsertDuplicateDashboard(WorkspaceInputModel workspaceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertDuplicateDashboard", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? workspaceId = _widgetService.InsertDuplicateDashboard(workspaceInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertDuplicateDashboard", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertDuplicateDashboard", "Widget Api"));
                return Json(new BtrakJsonResult { Data = workspaceId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertDuplicateDashboard", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWorkspaces)]
        public JsonResult<BtrakJsonResult> GetWorkspaces(WorkspaceSearchCriteriaInputModel workspaceSearchCriteria)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWorkspaces", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<WorkspaceApiReturnModel> workspaces = _widgetService.GetWorkspaces(workspaceSearchCriteria, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkspaces", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkspaces", "Widget Api"));
                return Json(new BtrakJsonResult { Data = workspaces, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkspaces", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWorkspaceFilters)]
        public JsonResult<BtrakJsonResult> GetWorkspaceFilters(WorkspaceFilterInputModel filterModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWorkspaceFilters", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;
                WorkspaceFilterOutputModel workspaceFilterOutputModel = new WorkspaceFilterOutputModel();

                // projects
                var projectList = _testSuiteService.GetProjectList(filterModel.SearchCriteriaInputModel, LoggedInContext, validationMessages);
                workspaceFilterOutputModel.ProjectsList = projectList;

                AuditComplianceApiInputModel auditComplianceApiInputModel = new AuditComplianceApiInputModel();
                auditComplianceApiInputModel.IsArchived = false;
                auditComplianceApiInputModel.IsForFilter = true;
                var auditList = _complianceAuditService.SearchAudits(auditComplianceApiInputModel, LoggedInContext, validationMessages);
                workspaceFilterOutputModel.AuditList = auditList;

                BusinessUnitDropDownModel businessUnitDropDownModel = new BusinessUnitDropDownModel();
                businessUnitDropDownModel.IsFromHR = true;
                List<BusinessUnitDropDownModel> businessUnitsList = _masterDataManagementService.GetBusinessUnitDropDown(businessUnitDropDownModel, LoggedInContext, validationMessages);
                workspaceFilterOutputModel.BusinessUnitsList = businessUnitsList;

                var EntityList = _productivityDashboardRepository.GetEntityDropDown(null, false, LoggedInContext, validationMessages).ToList();
                workspaceFilterOutputModel.EntityList = EntityList;

                BranchSearchInputModel branchInputModel = new BranchSearchInputModel();
                branchInputModel.IsArchived = false;
                var BranchList = _branchRepository.GetAllBranches(branchInputModel, LoggedInContext, validationMessages).ToList();
                workspaceFilterOutputModel.BranchList = BranchList;

                DesignationSearchInputModel designationSearchInputModel = new DesignationSearchInputModel();
                designationSearchInputModel.IsArchived = false;
                var DesignationList = _designationRepository.GetDesignations(designationSearchInputModel, LoggedInContext, validationMessages).ToList();
                workspaceFilterOutputModel.DesignationList = DesignationList;

                RolesSearchCriteriaInputModel roleSearchCriteriaInputModel = new RolesSearchCriteriaInputModel();
                roleSearchCriteriaInputModel.IsArchived = false;
                var RolesList = _roleRepository.GetAllRoles(roleSearchCriteriaInputModel, LoggedInContext, validationMessages).ToList();
                workspaceFilterOutputModel.RolesList = RolesList;

                DepartmentSearchInputModel departmentSearchInputModel = new DepartmentSearchInputModel();
                var departmentList = _departmentRepository.GetDepartments(departmentSearchInputModel, LoggedInContext, validationMessages).ToList();
                workspaceFilterOutputModel.DepartmentList = departmentList;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkspaceFilters", "Widget Api"));

                    return Json(btrakApiResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                // cusstom application tag keys
                List<FilterKeyValuePair> customApplicationTags = _genericFormService.GetCustomApplicationTagKeys(filterModel.GetCustomApplicationTagInpuModel, LoggedInContext, validationMessages);
                workspaceFilterOutputModel.CustomApplicationTagKeys = customApplicationTags;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkspaceFilters", "Widget Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                // users list
                SearchModel searchModel = new SearchModel();
                List<TeamMemberOutputModel> teamMembersList = _hrManagementService.GetMyTeamMembersList(searchModel, LoggedInContext, validationMessages);
                workspaceFilterOutputModel.UsersList = teamMembersList;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkspaceFilters", "Widget Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                // workspace filters
                List<FilterKeyValuePair> filters = _widgetService.GetAllDashboardFilters(filterModel.DashboardFilterModel, LoggedInContext, validationMessages);
                workspaceFilterOutputModel.WorkspaceFilters = filters;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkspaceFilters", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkspaceFilters", "Widget Api"));
                return Json(new BtrakJsonResult { Data = workspaceFilterOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkspaceFilters", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

       

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteWorkspace)]
        public JsonResult<BtrakJsonResult> DeleteWorkspace(WorkspaceInputModel workspaceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Workspace", "WorkspaceInputModel", workspaceInputModel, "Widget Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? workspaceId = _widgetService.DeleteWorkspace(workspaceInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Workspace", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Workspace", "Widget Api"));
                return Json(new BtrakJsonResult { Data = workspaceId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteWorkspace", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateDashboard)]
        public JsonResult<BtrakJsonResult> UpdateDashboard(DashboardInputModel dashboardInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDashboard", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? dashboardId = _widgetService.UpdateDashboard(dashboardInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDashboard", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDashboard", "Widget Api"));
                return Json(new BtrakJsonResult { Data = dashboardId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDashboard", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertDashboard)]
        public JsonResult<BtrakJsonResult> InsertDashboard(DashboardInputModel dashboardInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertDashboard", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? dashboardId = _widgetService.InsertDashboard(dashboardInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertDashboard", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertDashboard", "Widget Api"));
                return Json(new BtrakJsonResult { Data = dashboardId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertDashboard", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDashboards)]
        public JsonResult<BtrakJsonResult> GetDashboards(DashboardSearchCriteriaInputModel dashboardSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDashboards", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<DashboardApiReturnModel> dashboard = _widgetService.GetDashboards(dashboardSearchCriteriaInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDashboards", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDashboards", "Widget Api"));
                return Json(new BtrakJsonResult { Data = dashboard, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDashboards", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCustomizedDashboardId)]
        public JsonResult<BtrakJsonResult> GetCustomizedDashboardId(DashboardSearchCriteriaInputModel dashboardSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomizedDashboardId", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? dashboardId = _widgetService.GetCustomizedDashboardId(dashboardSearchCriteriaInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomizedDashboardId", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomizedDashboardId", "Widget Api"));
                return Json(new BtrakJsonResult { Data = dashboardId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomizedDashboardId", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetSubQueryTypes)]
        public JsonResult<BtrakJsonResult> GetSubQueryTypes()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSubQueryTypes", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<SubQueryTypeModel> dashboardId = _widgetService.GetSubQueryTypes(LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSubQueryTypes", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSubQueryTypes", "Widget Api"));
                return Json(new BtrakJsonResult { Data = dashboardId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSubQueryTypes", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }



        [AllowAnonymous]
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetColumnFormatTypes)]
        public JsonResult<BtrakJsonResult> GetColumnFormatTypes()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetColumnFormatTypes", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<ColumnFormatTypeModel> dashboardId = _widgetService.GetColumnFormatTypes(LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetColumnFormatTypes", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetColumnFormatTypes", "Widget Api"));
                return Json(new BtrakJsonResult { Data = dashboardId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetColumnFormatTypes", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [AllowAnonymous]
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetColumnFormatTypesById)]
        public JsonResult<BtrakJsonResult> GetColumnFormatTypesById(Guid? ColumnFormatTypeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetColumnFormatTypesById", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<ColumnFormatTypeModel> dashboardId = _widgetService.GetColumnFormatTypesById(ColumnFormatTypeId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetColumnFormatTypesById", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetColumnFormatTypesById", "Widget Api"));
                return Json(new BtrakJsonResult { Data = dashboardId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetColumnFormatTypesById", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCustomWidget)]
        public JsonResult<BtrakJsonResult> UpsertCustomWidget(CustomWidgetsInputModel widgetInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomWidget", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? customWidgetId = _widgetService.UpsertCustomWidget(widgetInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomWidget", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomWidget", "Widget Api"));
                return Json(new BtrakJsonResult { Data = customWidgetId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomWidget", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.RemoveSchedulingForCustomApp)]
        public JsonResult<BtrakJsonResult> RemoveSchedulingForCustomApp(ArchivedRecurringExpressionModel archivedInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ArchivedScheduling", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? customWidgetId = _widgetService.ArchivedScheduling(archivedInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchivedScheduling", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomWidget", "Widget Api"));
                return Json(new BtrakJsonResult { Data = customWidgetId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                //  LoggingManager.Error(ValidationMessages.ExceptionCustomWidgetUpsert, exception);
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomWidget", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertDashboardFilter)]
        public JsonResult<BtrakJsonResult> UpsertDashboardFilter(DynamicDashboardFilterModel dashboardFilterModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDashboardFilter", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? filterId = _widgetService.UpsertDashboardFilter(dashboardFilterModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDashboardFilter", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDashboardFilter", "Widget Api"));
                return Json(new BtrakJsonResult { Data = filterId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDashboardFilter", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDashboardFilters)]
        public JsonResult<BtrakJsonResult> GetDashboardFilters(DynamicDashboardFilterModel dashboardFilterModel)
        
        { 
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDashboardFilters", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<FilterKeyValuePair> filters = _widgetService.GetDashboardFilters(dashboardFilterModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDashboardFilters", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDashboardFilters", "Widget Api"));
                return Json(new BtrakJsonResult { Data = filters, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDashboardFilters", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllDashboardFilters)]
        public JsonResult<BtrakJsonResult> GetAllDashboardFilters(DynamicDashboardFilterModel dashboardFilterModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllDashboardFilters", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<FilterKeyValuePair> filters = _widgetService.GetAllDashboardFilters(dashboardFilterModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllDashboardFilters", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllDashboardFilters", "Widget Api"));
                return Json(new BtrakJsonResult { Data = filters, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllDashboardFilters", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCustomHtmlApp)]
        public JsonResult<BtrakJsonResult> UpsertCustomHtmlApp(CustomHtmlAppInputModel widgetInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomHtmlApp", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? customWidgetId = _widgetService.UpsertCustomHtmlApp(widgetInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomHtmlApp", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomHtmlApp", "Widget Api"));
                return Json(new BtrakJsonResult { Data = customWidgetId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomHtmlApp", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCustomAppFilter)]
        public JsonResult<BtrakJsonResult> UpsertCustomAppFilter(DashboardInputModel dashboardInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomAppFilter", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                DashboardApiReturnModel dashboard = _widgetService.UpsertCustomAppFilter(dashboardInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomAppFilter", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomAppFilter", "Widget Api"));
                return Json(new BtrakJsonResult { Data = dashboard, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomAppFilter", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCustomWidgets)]
        public JsonResult<BtrakJsonResult> GetCustomWidgets(CustomWidgetSearchCriteriaInputModel widgetSearchCriteriaInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomWidgets", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<CustomWidgetsApiReturnModel> widgets = _widgetService.GetCustomWidgets(widgetSearchCriteriaInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomWidgets", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomWidgets", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgets, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomWidgets", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWidgetDynamicQueryResult)]
        public JsonResult<BtrakJsonResult> GetWidgetDynamicQueryResult(WidgetDynamicQueryModel dynamicQueryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWidgetDynamicQueryResult", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                WidgetDynamicQueryReturnModel queryResult = _widgetService.GetWidgetDynamicQueryResult(dynamicQueryModel, LoggedInContext, validationMessages, true);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWidgetDynamicQueryResult", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWidgetDynamicQueryResult", "Widget Api"));
                return Json(new BtrakJsonResult { Data = queryResult, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWidgetDynamicQueryResult", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CustomWidgetNameValidator)]
        public JsonResult<BtrakJsonResult> CustomWidgetNameValidator(CustomWidgetsInputModel widgetInputs)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CustomWidgetNameValidator", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                WidgetDynamicQueryReturnModel isValidated = _widgetService.CustomWidgetNameValidator(widgetInputs, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CustomWidgetNameValidator", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CustomWidgetNameValidator", "Widget Api"));
                return Json(new BtrakJsonResult { Data = isValidated, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CustomWidgetNameValidator", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCustomGridData)]
        public JsonResult<BtrakJsonResult> GetCustomGridData(CustomWidgetSearchCriteriaInputModel widgetInputs)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomGridData", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                WidgetDynamicQueryReturnModel widgetGrid = _widgetService.GetCustomGridData(widgetInputs, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomGridData", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomGridData", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgetGrid, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomGridData", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCronExpression)]
        public JsonResult<BtrakJsonResult> UpsertCronExpression(CronExpressionInputModel cronExpressionInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Cron Expression", "cronExpressionInputModel", cronExpressionInputModel, "Widgets Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                int? cronExpressionId = new int();

                cronExpressionId = _widgetService.UpsertCronExpression(cronExpressionInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Cron Expression", "Widgets Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Cron Expression", "Widgets Api"));
                return Json(new BtrakJsonResult { Data = cronExpressionId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCronExpression", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCustomWidgetSubQuery)]
        public JsonResult<BtrakJsonResult> UpsertCustomWidgetSubQuery(CustomWidgetSearchCriteriaInputModel widgetInputs)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomWidgetSubQuery", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? widgetGrid = _widgetService.UpsertCustomWidgetSubQuery(widgetInputs, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomWidgetSubQuery", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomWidgetSubQuery", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgetGrid, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomWidgetSubQuery", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SetAsDefaultDashboardPersistance)]
        public JsonResult<BtrakJsonResult> SetAsDefaultDashboardPersistance(WorkspaceInputModel workspaceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SetAsDefaultDashboardPersistance", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                bool? setSuccessfully = _widgetService.SetAsDefaultDashboardPersistance(workspaceInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SetAsDefaultDashboardPersistance", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SetAsDefaultDashboardPersistance", "Widget Api"));
                return Json(new BtrakJsonResult { Data = setSuccessfully, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetAsDefaultDashboardPersistance", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ResetToDefaultDashboard)]
        public JsonResult<BtrakJsonResult> ResetToDefaultDashboard(WorkspaceInputModel workspaceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ResetToDefaultDashboard", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                bool? setSuccessfully = _widgetService.ResetToDefaultDashboard(workspaceInputModel.WorkspaceId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ResetToDefaultDashboard", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ResetToDefaultDashboard", "Widget Api"));
                return Json(new BtrakJsonResult { Data = setSuccessfully, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ResetToDefaultDashboard", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertDashboardVisuaizationType)]
        public JsonResult<BtrakJsonResult> UpsertDashboardVisuaizationType(DashboardInputModel dashboardModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Dashboard VisuaizationType", "dashboardModel", dashboardModel, "Widgets Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? CustomAppVisualizationId = _widgetService.UpsertDashboardVisuaizationType(dashboardModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Dashboard VisuaizationType", "Widgets Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Dashboard VisuaizationType", "Widgets Api"));
                return Json(new BtrakJsonResult { Data = CustomAppVisualizationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDashboardVisuaizationType", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SetDefaultDashboardForUser)]
        public JsonResult<BtrakJsonResult> SetDefaultDashboardForUser(DashboardInputModel dashboardModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Set default dashboard for user", "dashboardModel", dashboardModel, "Widgets Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? dashboardStatusId = _widgetService.SetDefaultDashboardForUser(dashboardModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Set default dashboard for user", "Widgets Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Set default dashboard for user", "Widgets Api"));
                return Json(new BtrakJsonResult { Data = dashboardStatusId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetDefaultDashboardForUser", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCustomAppDashboardPersistanceForUser)]
        public JsonResult<BtrakJsonResult> GetCustomAppDashboardPersistanceForUser(CustomAppDashboardPersistanceModel persistanceModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get CustomApp Dashboard Persistance For User", "CustomAppDashboardPersistanceModel", persistanceModel, "Widgets Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                CustomAppDashboardPersistanceModel persistance = _widgetService.GetCustomAppDashboardPersistanceForUser(persistanceModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get CustomApp Dashboard Persistance For User", "Widgets Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get CustomApp Dashboard Persistance For User", "Widgets Api"));
                return Json(new BtrakJsonResult { Data = persistance, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomAppDashboardPersistanceForUser", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SetCustomAppDashboardPersistanceForUser)]
        public JsonResult<BtrakJsonResult> SetCustomAppDashboardPersistanceForUser(CustomAppDashboardPersistanceModel persistanceModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Set CustomApp Dashboard Persistance For User", "CustomAppDashboardPersistanceModel", persistanceModel, "Widgets Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? persistanceId = _widgetService.SetCustomAppDashboardPersistanceForUser(persistanceModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Set CustomApp Dashboard Persistance For User", "Widgets Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Set CustomApp Dashboard Persistance For User", "Widgets Api"));
                return Json(new BtrakJsonResult { Data = persistanceId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetCustomAppDashboardPersistanceForUser", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateDashboardName)]
        public JsonResult<BtrakJsonResult> UpdateDashboardName(DashboardModel dashboardModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Update Dashboard Name", "CustomAppDashboardPersistanceModel", dashboardModel, "Widgets Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? dashboardId = _widgetService.UpdateDashboardName(dashboardModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Dashboard Name", "Widgets Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Dashboard Name", "Widgets Api"));

                return Json(new BtrakJsonResult { Data = dashboardId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDashboardName", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertWorkspaceDashboardFilter)]
        public JsonResult<BtrakJsonResult> UpsertWorkspaceDashboardFilter(WorkspaceDashboardFilterInputModel workspaceDashboardFilterInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Workspace Dashboard Filter", "Custom App Dashboard Persistance Model", workspaceDashboardFilterInputModel, "Widgets Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? WorkspaceDashboardFilterId = _widgetService.UpsertWorkspaceDashboardFilter(workspaceDashboardFilterInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Workspace Dashboard Filter", "Widgets Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Workspace Dashboard Filter", "Widgets Api"));

                return Json(new BtrakJsonResult { Data = WorkspaceDashboardFilterId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWorkspaceDashboardFilter", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWorkspaceDashboardFilters)]
        public JsonResult<BtrakJsonResult> GetWorkspaceDashboardFilters(WorkspaceDashboardFilterInputModel workspaceDashboardFilterInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Workspace Dashboard Filters", "Custom App Dashboard Persistance Model", workspaceDashboardFilterInputModel, "Widgets Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<WorkspaceDashboardFilterOutputModel> WorkspaceDashboardFilterDetails = _widgetService.GetWorkspaceDashboardFilters(workspaceDashboardFilterInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Workspace Dashboard Filters", "Widgets Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Workspace Dashboard Filters", "Widgets Api"));

                return Json(new BtrakJsonResult { Data = WorkspaceDashboardFilterDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWorkspaceDashboardFilters", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCustomeHtmlAppDetails)]
        public JsonResult<BtrakJsonResult> GetCustomeHtmlAppDetails(Guid? customHtmlAppId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCustomeHtmlAppDetails", "customHtmlAppId", customHtmlAppId, "Widgets Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                CustomeHtmlAppDetailsSearchOutputModel customeHtmlAppDetailsSearchOutputModel = _widgetService.GetCustomeHtmlAppDetails(customHtmlAppId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomeHtmlAppDetails", "Widgets Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomeHtmlAppDetails", "Widgets Api"));

                return Json(new BtrakJsonResult { Data = customeHtmlAppDetailsSearchOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomeHtmlAppDetails", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertProcInputsandOutputs)]
        public JsonResult<BtrakJsonResult> UpsertProcInputsAndOuputs(ProcInputsAndOutputModel procInputsAndOutputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProcInputsAndOuputs", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? widgetId = _widgetService.UpsertProcInputsAndOuputs(procInputsAndOutputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProcInputsAndOuputs", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProcInputsAndOuputs", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgetId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProcInputsAndOuputs", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetProcInputsandOutputs)]
        public JsonResult<BtrakJsonResult> GetProcInputsAndOuputs(ProcInputsAndOutputModel procInputsAndOutputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertProcInputsAndOuputs", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                ProcInputsAndOutputModel procInputsAndOutputModels = _widgetService.GetProcInputsAndOuputs(procInputsAndOutputModel, LoggedInContext, validationMessages);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertProcInputsAndOuputs", "Widget Api"));
                return Json(new BtrakJsonResult { Data = procInputsAndOutputModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProcInputsAndOuputs", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetProcData)]
        public JsonResult<BtrakJsonResult> GetProcData(ProcInputsAndOutputModel procInputsAndOutputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProcData", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var customAppProcData = new CustromAppProcOutputModel();

                // get proc inputs and outputs api
                ProcInputsAndOutputModel procInputsAndOutputs = _widgetService.GetProcInputsAndOuputs(procInputsAndOutputModel, LoggedInContext, validationMessages);

                // upsert data api
                JObject businessSuitePostInput = new JObject();

                if (procInputsAndOutputs.Inputs.Any())
                {
                    foreach (var input in procInputsAndOutputs.Inputs)
                    {
                        businessSuitePostInput[$"{input.ParameterName}"] = input.InputData != null ? input.InputData.ToString().Count() > 0 ? input.InputData.ToString() : null : null;
                    }
                }

                if (procInputsAndOutputModel.DashboardFilters != null)
                {
                    if (procInputsAndOutputModel.DashboardFilters.ProjectId != null)
                    {
                        businessSuitePostInput["ProjectId"] = procInputsAndOutputModel.DashboardFilters.ProjectId;
                    }
                    if (procInputsAndOutputModel.DashboardFilters.AuditId != null)
                    {
                        businessSuitePostInput["AuditId"] = procInputsAndOutputModel.DashboardFilters.AuditId;
                    }
                }

                
                businessSuitePostInput["SpName"] = procInputsAndOutputs.ProcName.Trim();
                businessSuitePostInput["isForFilters"] = "true";
                businessSuitePostInput["workspaceId"] = procInputsAndOutputModel.WorkspaceId;
                businessSuitePostInput["dashboardId"] = procInputsAndOutputModel.DashboardId;

                string jsonResult = JsonConvert.SerializeObject(businessSuitePostInput);

                var values = JsonConvert.DeserializeObject<Dictionary<string, object>>(jsonResult);

                var returnedData = _businessSuiteRepository.UpsertData(values, validationMessages, LoggedInContext);

                customAppProcData.ProcInputsAndOutputs = procInputsAndOutputs;
                customAppProcData.UpsertData = returnedData;

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetProcData", "Widget Api"));
                return Json(new BtrakJsonResult { Data = customAppProcData, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetProcData", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SetAsDefaultDashboardView)]
        public JsonResult<BtrakJsonResult> SetAsDefaultDashboardView(WorkspaceInputModel workspaceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SetAsDefaultDashboardView", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                bool? setSuccessfully = _widgetService.SetAsDefaultDashboardView(workspaceInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SetAsDefaultDashboardView", "Widget Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SetAsDefaultDashboardView", "Widget Api"));
                return Json(new BtrakJsonResult { Data = setSuccessfully, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetAsDefaultDashboardView", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetApiData)]
        public async Task<JsonResult<BtrakJsonResult>> GetApiData(CustomApiAppInputModel customApiAppInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetApiData", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                ApiOutputDataModel apiData = await _customApiService.GetApiData(customApiAppInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetApiData", "Widget Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetApiData", "Widget Api"));
                return Json(new BtrakJsonResult { Data = apiData, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetApiData", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCustomAppApiDetails)]
        public JsonResult<BtrakJsonResult> UpsertCustomAppApiDetails(CustomApiAppInputModel customApiAppInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomAppApiDetails", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? customAppDetailsId = _customApiService.UpsertCustomAppApiDetails(customApiAppInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomAppApiDetails", "Widget Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCustomAppApiDetails", "Widget Api"));
                return Json(new BtrakJsonResult { Data = customAppDetailsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomAppApiDetails", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCustomAppApiDetails)]
        public JsonResult<BtrakJsonResult> GetCustomAppApiDetails(CustomApiAppInputModel customApiAppInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomAppApiDetails", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                CustomApiAppInputModel customApiAppDetails = _customApiService.GetCustomAppApiDetails(customApiAppInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomAppApiDetails", "Widget Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCustomAppApiDetails", "Widget Api"));
                return Json(new BtrakJsonResult { Data = customApiAppDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCustomAppApiDetails", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SendWidgetReportEmail)]
        public async Task<JsonResult<BtrakJsonResult>> SendWidgetReportEmail(SendWidgetReportModel sendWidgetReportModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendWidgetReportEmail", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                bool customApiAppDetails = _customApiService.SendWidgetReportEmail(sendWidgetReportModel, LoggedInContext, validationMessages).Result;

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendWidgetReportEmail", "Widget Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendWidgetReportEmail", "Widget Api"));
                return Json(new BtrakJsonResult { Data = customApiAppDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendWidgetReportEmail", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SetDashboardsOrder)]
        public JsonResult<BtrakJsonResult> SetDashboardsOrder(DashboardOrderSearchCriteriaInputModel dashboardInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SetDashboardsOrder", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                bool? setSuccessfully = _widgetService.SetDashboardsOrder(dashboardInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SetDashboardsOrder", "Widget Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SetDashboardsOrder", "Widget Api"));
                return Json(new BtrakJsonResult { Data = setSuccessfully, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetDashboardsOrder", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.IsHavingSystemAppAccess)]
        public JsonResult<BtrakJsonResult> IsHavingSystemAppAccess(string widgetName)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "IsHavingSystemAppAccess", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                bool outPut = _widgetService.IsHavingSystemAppAccess(widgetName, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "IsHavingSystemAppAccess", "Widget Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "IsHavingSystemAppAccess", "Widget Api"));
                return Json(new BtrakJsonResult { Data = outPut, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetDashboardsOrder", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertDynamicModule)]
        public JsonResult<BtrakJsonResult> UpsertDynamicModule(DynamicModuleUpsertModel dynamicModuleUpsertModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDynamicModule", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var dynamicWidgetModule = _widgetService.UpsertDynamicModule(dynamicModuleUpsertModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDynamicModule", "Widget Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDynamicModule", "Widget Api"));
                return Json(new BtrakJsonResult { Data = dynamicWidgetModule, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDynamicModule", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDynamicModules)]
        public JsonResult<BtrakJsonResult> GetDynamicModules(DynamicModuleUpsertModel dynamicModuleUpsertModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDynamicModules", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var dynamicWidgetModule = _widgetService.GetDynamicModules(dynamicModuleUpsertModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDynamicModules", "Widget Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDynamicModules", "Widget Api"));
                return Json(new BtrakJsonResult { Data = dynamicWidgetModule, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDynamicModules", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDynamicModuleTabs)]
        public JsonResult<BtrakJsonResult> GetDynamicModuleTabs(DynamicModuleUpsertModel dynamicModuleUpsertModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDynamicModuleTabs", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var dynamicWidgetModule = _widgetService.GetDynamicModuleTabs(dynamicModuleUpsertModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDynamicModuleTabs", "Widget Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDynamicModuleTabs", "Widget Api"));
                return Json(new BtrakJsonResult { Data = dynamicWidgetModule, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDynamicModules", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetMongoCollections)]
        public JsonResult<BtrakJsonResult> GetMongoCollections()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMongoCollections", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var result = _widgetService.GetMongoCollections(LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMongoCollections", "Widget Api"));

                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMongoCollections", "Widget Api"));
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMongoCollections", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCO2EmmisionReport)]
        public JsonResult<BtrakJsonResult> GetCO2EmmisionReport(GetCO2EmmisionReportInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCO2EmmisionReport", "Widget Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<GetCO2EmmisionReportOutputModel> widgets = _widgetService.GetCO2EmmisionReport(inputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCO2EmmisionReport", "Widget Api"));

                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCO2EmmisionReport", "Widget Api"));
                return Json(new BtrakJsonResult { Data = widgets, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCO2EmmisionReport", "WidgetsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
