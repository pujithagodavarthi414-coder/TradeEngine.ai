using System;
using System.Collections.Generic;
using System.Linq;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.CustomApplication;
using Btrak.Models.GenericForm;
using Btrak.Models.MasterData;
using Btrak.Models.Role;
using Btrak.Models.Widgets;
using Btrak.Services.CompanyStructure;
using Btrak.Services.CustomApplication;
using Btrak.Services.GenericForm;
using Btrak.Services.MasterData;
using Btrak.Services.Role;
using Btrak.Services.Widgets;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models.BoardType;
using Btrak.Models.ComplianceAudit;
using Btrak.Models.EntityRole;
using Btrak.Models.EntityType;
using Btrak.Models.Projects;
using Btrak.Models.ProjectType;
using Btrak.Models.Status;
using Btrak.Models.UserStory;
using Btrak.Services.BoardTypeApis;
using Btrak.Services.BoardTypes;
using Btrak.Services.EntityRole;
using Btrak.Services.EntityType;
using Btrak.Services.Projects;
using Btrak.Services.Status;
using Btrak.Services.UserStory;
using Btrak.Models.WorkFlow;
using Btrak.Services.ComplianceAudit;
using Btrak.Services.Templates;
using Btrak.Services.WorkFlow;
using Newtonsoft.Json;
using Btrak.Services.CustomTags;
using Btrak.Services.PayRoll;
using Btrak.Models.PayRoll;
using Btrak.Services.Branch;
using Btrak.Models.Employee;
using Btrak.Models.SoftLabelConfigurations;
using Btrak.Models.Goals;
using Btrak.Services.Goals;
using Btrak.Models.CustomFields;
using Btrak.Services.CustomFields;
using Btrak.Models.CompanyStructure;
using static BTrak.Common.Enumerators;
using Btrak.Models.CompanyStructureManagement;
using Btrak.Models.CustomTags;
using Btrak.Services.CompanyStructureManagement;
using Btrak.Models.SystemManagement;
using System.Web;

namespace Btrak.Services.SystemConfiguration
{
    public class SystemConfigurationService : ISystemConfigurationService
    {
        private readonly WidgetRepository _widgetRepository;
        private readonly IWidgetService _widgetService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IGenericFormService _genericFormService;
        private readonly IMasterDataManagementService _masterDataManagementService;
        private readonly ICustomApplicationService _customApplicationService;
        private readonly IGenericFormMasterDataService _genericFormMasterDataService;
        private readonly IRoleService _roleService;
        private readonly IEntityRoleService _entityRoleService;
        private readonly IEntityRoleFeatureService _entityRoleFeatureService;
        private readonly IUserStoryReplanTypeService _userStoryReplanTypeService;
        private readonly IBoardTypeApiService _boardTypeApiService;
        private readonly IBoardTypeService _boardTypeService;
        private readonly IStatusService _statusService;
        private readonly IUserStorySubTypeService _userStorySubTypeService;
        private readonly IProjectTypeService _projectTypeService;
        private readonly IWorkFlowService _workFlowService;
        private readonly IWorkFlowStatusService _workFlowStatusService;
        private readonly IWorkFlowEligibleStatusTransitionService _workFlowEligibleStatusTransitionService;
        private readonly IProjectService _projectService;
        private readonly IUserStoryService _userStoryService;
        private readonly IComplianceAuditService _complianceAuditService;
        private readonly IPayRollService _payRollService;
        private readonly IBranchService _branchService;
        private readonly IGoalService _goalService;

        private readonly ICustomTagService _customTagService;
        private readonly CustomFieldRepository _customFieldFormRepository;
        private readonly ICustomFieldService _customFieldService;
        private readonly ICompanyStructureManagementService _companyStructureManagementService;
        private readonly SystemCountryRepository _systemCountryRepository; 
        private readonly ICustomApiAppService _customApiAppService; 

        public SystemConfigurationService(IWidgetService widgetService, ICompanyStructureService companyStructureService,
            IGenericFormService genericFormService, IMasterDataManagementService masterDataManagementService,
            ICustomApplicationService customApplicationService, IGenericFormMasterDataService genericFormMasterDataService,
            IRoleService roleService, WidgetRepository widgetRepository,
            IEntityRoleService entityRoleService, IEntityRoleFeatureService entityRoleFeatureService,
            IUserStoryReplanTypeService userStoryReplanTypeService, IBoardTypeApiService boardTypeApiService,
            IBoardTypeService boardTypeService, IStatusService statusService,
            IUserStorySubTypeService userStorySubTypeService, IProjectTypeService projectTypeService,
            IWorkFlowService workFlowService, IWorkFlowStatusService workFlowStatusService,
            IWorkFlowEligibleStatusTransitionService workFlowEligibleStatusTransitionService,
            IProjectService projectService,
            IUserStoryService userStoryService, IComplianceAuditService complianceAuditService, ICustomTagService customTagService,
            IPayRollService payRollService, IBranchService branchService, IGoalService goalService,
            CustomFieldRepository customFieldFormRepository,
            ICustomFieldService customFieldService,
            ICompanyStructureManagementService companyStructureManagementService,
            ICustomApiAppService  customApiAppService,
            SystemCountryRepository systemCountryRepository)
        {
            _widgetService = widgetService;
            _companyStructureService = companyStructureService;
            _genericFormService = genericFormService;
            _masterDataManagementService = masterDataManagementService;
            _customApplicationService = customApplicationService;
            _genericFormMasterDataService = genericFormMasterDataService;
            _roleService = roleService;
            _widgetRepository = widgetRepository;
            _entityRoleService = entityRoleService;
            _entityRoleFeatureService = entityRoleFeatureService;
            _userStoryReplanTypeService = userStoryReplanTypeService;
            _boardTypeApiService = boardTypeApiService;
            _boardTypeService = boardTypeService;
            _statusService = statusService;
            _userStorySubTypeService = userStorySubTypeService;
            _projectTypeService = projectTypeService;
            _workFlowService = workFlowService;
            _workFlowStatusService = workFlowStatusService;
            _workFlowEligibleStatusTransitionService = workFlowEligibleStatusTransitionService;
            _projectService = projectService;
            _userStoryService = userStoryService;
            _complianceAuditService = complianceAuditService;
            _customTagService = customTagService;
            _payRollService = payRollService;
            _branchService = branchService;
            _goalService = goalService;
            _customFieldFormRepository = customFieldFormRepository;
            _customFieldService = customFieldService;
            _companyStructureManagementService = companyStructureManagementService;
            _customApiAppService = customApiAppService;
            _systemCountryRepository = systemCountryRepository;
        }

        public SystemConfigurationModel ExportSystemConfiguration(SystemExportInputModel systemExportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string siteAddress)
        {
            SystemConfigurationModel systemConfigurationExportModel = new SystemConfigurationModel();

            if (systemExportInputModel == null) systemExportInputModel = new SystemExportInputModel();
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SystemConfigurationExportModel", "System configuration service"));

                if (systemExportInputModel.IsExportData == true || (systemExportInputModel.ExportDataModelIds != null && systemExportInputModel.ExportDataModelIds.Count > 0))
                {
                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.Roles))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllRoles", "System configuration service"));
                            List<RolesOutputModel> roles = _roleService.GetAllRoles(new RolesSearchCriteriaInputModel
                            {
                                IsArchived = false
                            }, loggedInContext, new List<ValidationMessage>());

                            if (roles != null && roles.Count > 0)
                            {
                                foreach (var role in roles)
                                {
                                    var roleDetails = _roleService.GetRoleById(role.RoleId, loggedInContext,
                                        new List<ValidationMessage>());

                                    if (roleDetails != null && !string.IsNullOrWhiteSpace(roleDetails.Features))
                                    {
                                        List<FeatureModel> features =
                                            JsonConvert.DeserializeObject<List<FeatureModel>>(roleDetails.Features);

                                        if (features != null && features.Count > 0)
                                        {
                                            roles.FirstOrDefault(x => x.RoleId == role.RoleId).FeatureIds = new List<Guid>();

                                            features.ForEach(x => roles.FirstOrDefault(y => y.RoleId == role.RoleId).FeatureIds.Add(x.Id));
                                        }
                                    }
                                }
                            }
                            systemConfigurationExportModel.Roles = roles;
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.MasterQuestionTypes))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMasterQuestionTypes", "System configuration service"));
                            systemConfigurationExportModel.MasterQuestionTypes = _complianceAuditService.GetMasterQuestionTypes(new QuestionTypeApiInputModel(), loggedInContext, new List<ValidationMessage>());
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.QuestionTypes))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQuestionTypes", "System configuration service"));
                            systemConfigurationExportModel.QuestionTypes = _complianceAuditService.GetQuestionTypes(new QuestionTypeApiInputModel(), loggedInContext, new List<ValidationMessage>());
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.AuditsList))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAudits", "System configuration service"));
                            systemConfigurationExportModel.AuditsList = _complianceAuditService.SearchAudits(new AuditComplianceApiInputModel()
                            {
                                IsArchived = false,
                                IsForFilter = true
                            }, loggedInContext, new List<ValidationMessage>());

                            List<AuditCategoryApiReturnModel> auditCategories = new List<AuditCategoryApiReturnModel>();
                            List<AuditQuestionsApiReturnModel> auditCategoryQuestions = new List<AuditQuestionsApiReturnModel>();

                            if (systemConfigurationExportModel.AuditsList != null && systemConfigurationExportModel.AuditsList.Count > 0)
                            {
                                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAuditCategories", "System configuration service"));
                                foreach (var audit in systemConfigurationExportModel.AuditsList)
                                {
                                    List<AuditCategoryApiReturnModel> auditCategoryApiReturnModels = _complianceAuditService.SearchAuditCategories(new AuditCategoryApiInputModel
                                    {
                                        AuditId = audit.AuditId,
                                        IsArchived = false
                                    }, loggedInContext, new List<ValidationMessage>());

                                    if (auditCategoryApiReturnModels != null && auditCategoryApiReturnModels.Count > 0)
                                    {
                                        auditCategories = GetHierarchyOfAuditCategoriesAndSubCategories(auditCategoryApiReturnModels, audit.AuditId);

                                        auditCategoryQuestions =
                                            GetAuditCategoryQuestionsByAuditCategories(auditCategories, loggedInContext);
                                    }
                                }
                            }
                            if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.AuditCategories))
                            {
                                systemConfigurationExportModel.AuditCategories = auditCategories;
                            }
                            if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.AuditCategoryQuestions))
                            {
                                systemConfigurationExportModel.AuditCategoryQuestions = auditCategoryQuestions;
                            }
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }

                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.EntityRoleOutputModels))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEntityRole", "System configuration service"));
                            List<EntityRoleOutputModel> entityRoleList = _entityRoleService.GetEntityRole(new EntityRoleSearchCriteriaInputModel
                            {
                                IsArchived = false
                            }, loggedInContext, new List<ValidationMessage>());

                            if (entityRoleList != null && entityRoleList.Count > 0)
                            {
                                foreach (var entityRole in entityRoleList)
                                {
                                    var permittedEntityRoleFeatures = _entityRoleFeatureService.GetAllPermittedEntityRoleFeatures(
                                        new EntityRoleFeatureSearchInputModel
                                        {
                                            EntityRoleId = entityRole.EntityRoleId
                                        }, loggedInContext, new List<ValidationMessage>());

                                    if (permittedEntityRoleFeatures != null && permittedEntityRoleFeatures.Count > 0)
                                    {
                                        entityRole.EntityRoleFeaturesList = permittedEntityRoleFeatures;
                                    }
                                }
                            }
                            systemConfigurationExportModel.EntityRoleOutputModels = entityRoleList;
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.PayrollComponents))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollComponents", "System configuration service"));
                            systemConfigurationExportModel.PayrollComponents = _payRollService.GetPayRollComponents(new PayRollComponentSearchInputModel
                            {
                                IsArchived = false
                            }, loggedInContext, new List<ValidationMessage>());
                        }
                        catch (Exception ex)
                        {

                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }

                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.PayrollTemplates))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollTemplates", "System configuration service"));
                            systemConfigurationExportModel.PayrollTemplates = _payRollService.GetPayRollTemplates(new PayRollTemplateSearchInputModel
                            {
                                IsArchived = false
                            }, loggedInContext, new List<ValidationMessage>());
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.PayrollTemplateConfigurations))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollTemplateConfigurations", "System configuration service"));
                            if (systemConfigurationExportModel.PayrollTemplates != null &&
                           systemConfigurationExportModel.PayrollTemplates.Count > 0)
                            {
                                foreach (var payrollTemplate in systemConfigurationExportModel.PayrollTemplates)
                                {
                                    systemConfigurationExportModel.PayrollTemplateConfigurations = _payRollService.GetPayRollTemplateConfigurations(new PayRollTemplateConfigurationSearchInputModel
                                    {
                                        PayRollTemplateId = payrollTemplate.PayRollTemplateId
                                    }, loggedInContext, new List<ValidationMessage>());
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.ProfessionalTaxRange))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProfessionalTaxRanges", "System configuration service"));
                            systemConfigurationExportModel.ProfessionalTaxRange = _masterDataManagementService.GetProfessionalTaxRanges(loggedInContext, new List<ValidationMessage>());
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }

                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.TaxSlabs))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTaxSlabs", "System configuration service"));
                            var taxSlab = new TaxSlabs();
                            systemConfigurationExportModel.TaxSlabs = _masterDataManagementService.GetTaxSlabs(taxSlab, loggedInContext, new List<ValidationMessage>());
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.FormTypes))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "FormTypes", "System configuration service"));
                            List<FormTypes> formTypes = new List<FormTypes>();
                            var formTypesList = _genericFormService.GetFormTypes(loggedInContext, new List<ValidationMessage>());
                            foreach (var formtype in formTypesList)
                            {
                                List<Forms> forms = new List<Forms>();

                                var formTypeId = formtype.Id;

                                var formsList = _genericFormService.GetGenericFormsByTypeId(formTypeId, loggedInContext, new List<ValidationMessage>());

                                foreach (var form in formsList)
                                {
                                    List<FormKeys> formkeys = new List<FormKeys>();

                                    var genericFormKeyModel = new GenericFormKeySearchInputModel()
                                    {
                                        IsArchived = false,
                                        GenericFormId = form.Id
                                    };

                                    var formsKeyList = _genericFormService.GetGenericFormKey(genericFormKeyModel, loggedInContext, new List<ValidationMessage>());

                                    foreach (var formkey in formsKeyList)
                                    {
                                        formkeys.Add(new FormKeys()
                                        {
                                            key = formkey.Key,
                                            Label = formkey.Label
                                        });
                                    }

                                    // Get CustomApplications

                                    List<CustomApplications> customApplications = new List<CustomApplications>();

                                    var customApplicationModel = new CustomApplicationSearchInputModel()
                                    {
                                        FormId = form.Id
                                    };

                                    try
                                    {
                                        var customApplicationsList = _customApplicationService.GetCustomApplication(customApplicationModel, loggedInContext, new List<ValidationMessage>());
                                        foreach (var customapplication in customApplicationsList)
                                        {
                                            var customApplicationSearchModel = new CustomApplicationSearchInputModel()
                                            {
                                                CustomApplicationId = customapplication.CustomApplicationId
                                            };

                                            var customApplicationsForRoles = _customApplicationService.GetCustomApplication(customApplicationSearchModel, loggedInContext, new List<ValidationMessage>());

                                            List<CustomApplicationKeys> customApplicationKeys = new List<CustomApplicationKeys>();

                                            var customApplicationKeyInpuModel = new CustomApplicationKeySearchInputModel()
                                            {
                                                CustomApplicationId = customapplication.CustomApplicationId
                                            };

                                            var customApplicationsKeyList = _customApplicationService.GetCustomApplicationKeys(customApplicationKeyInpuModel, loggedInContext, new List<ValidationMessage>());

                                            foreach (var customapplicationkey in customApplicationsKeyList)
                                            {
                                                customApplicationKeys.Add(new CustomApplicationKeys()
                                                {
                                                    GenericFormKeyId = customapplicationkey.GenericFormKeyId,
                                                    IsDefault = customapplicationkey.IsDefault,
                                                    IsPrivate = customapplicationkey.IsPrivate,
                                                    IsTag = customapplicationkey.IsTag,
                                                    IsTrendsEnable = customapplicationkey.IsTrendsEnable,
                                                    CustomApplicationId = customapplicationkey.CustomApplicationId
                                                });
                                            }

                                            List<CustomApplicationWorkflows> customApplicationWorkflows = new List<CustomApplicationWorkflows>();

                                            var customApplicationWorkflowSearchInputModel = new CustomApplicationWorkflowUpsertInputModel()
                                            {
                                                CustomApplicationId = customapplication.CustomApplicationId
                                            };

                                            var customApplicationWorkflowsList = _customApplicationService.GetCustomApplicationWorkflow(customApplicationWorkflowSearchInputModel, loggedInContext, new List<ValidationMessage>());

                                            foreach (var workflow in customApplicationWorkflowsList)
                                            {
                                                customApplicationWorkflows.Add(new CustomApplicationWorkflows()
                                                {
                                                    WorkflowTypeId = workflow.WorkflowTypeId,
                                                    WorkflowTypeName = workflow.WorkflowTypeName,
                                                    WorkflowXml = workflow.WorkflowXml,
                                                    Rulejson = workflow.RuleJson
                                                });
                                            }

                                            customApplications.Add(new CustomApplications()
                                            {
                                                CustomApplicationName = customapplication.CustomApplicationName,
                                                IsAbleToLogin = customapplication.IsAbleToLogin,
                                                PublicMessage = customapplication.PublicMessage,
                                                PublicUrl = customapplication.PublicUrl,
                                                FormName = customapplication.FormName,
                                                FormTypeName = customapplication.FormTypeName,
                                                FormJson = customapplication.FormJson,
                                                FormId = customapplication.FormId,
                                                FormTypeId = customapplication.FormTypeId,
                                                RoleIds = customApplicationsForRoles[0].RoleIds,
                                                RoleNames = customApplicationsForRoles[0].RoleNames,
                                                CustomApplicationKeys = customApplicationKeys,
                                                CustomApplicationWorkflows = customApplicationWorkflows,
                                                SelectedEnableTrendsKeys = customapplication.SelectedEnableTrendsKeys,
                                                SelectedTagKeyIds = customapplication.SelectedTagKeyIds,
                                                SelectedPrivateKeyIds = customapplication.SelectedPrivateKeyIds,
                                                SelectedKeyIds = customapplication.SelectedKeyIds
                                            });
                                        }
                                    }
                                    catch (Exception exception)
                                    {
                                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", exception.Message), exception);

                                    }

                                    forms.Add(new Forms()
                                    {
                                        FormName = form.FormName,
                                        FormJson = form.FormJson,
                                        FormKeys = formkeys,
                                        CustomApplications = customApplications
                                    });
                                }

                                formTypes.Add(new FormTypes()
                                {
                                    FormTypeName = formtype.FormTypeName,
                                    Forms = forms
                                });
                            }
                            systemConfigurationExportModel.FormTypes = formTypes;
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.WorkItemTypes))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "WorkItemTypes", "System configuration service"));
                            systemConfigurationExportModel.WorkItemTypes = _userStoryReplanTypeService.GetUserStoryTypes(new UserStoryTypeSearchInputModel(),
                                                    loggedInContext, new List<ValidationMessage>());
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.BoardTypeApis))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "BoardTypeApis", "System configuration service"));
                            systemConfigurationExportModel.BoardTypeApis =
                            _boardTypeApiService.GetAllBoardTypeApi(new BoardTypeApiInputModel(), loggedInContext,
                                new List<ValidationMessage>());
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.BoardTypes))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "BoardTypes", "System configuration service"));
                            systemConfigurationExportModel.BoardTypes =
                            _boardTypeService.GetAllBoardTypes(new BoardTypeInputModel(), loggedInContext,
                                new List<ValidationMessage>());
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.WorkItemStatuses))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "WorkItemStatuses", "System configuration service"));
                            systemConfigurationExportModel.WorkItemStatuses =
                                                    _statusService.GetAllStatuses(new UserStoryStatusInputModel(), loggedInContext,
                                                        new List<ValidationMessage>());
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.WorkItemSubTypes))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "WorkItemSubTypes", "System configuration service"));
                            systemConfigurationExportModel.WorkItemSubTypes = _userStorySubTypeService.SearchUserStorySubTypes(
                            new UserStorySubTypeSearchCriteriaInputModel(), loggedInContext, new List<ValidationMessage>());
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.ProjectTypes))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ProjectTypes", "System configuration service"));
                            systemConfigurationExportModel.ProjectTypes =
                                                    _projectTypeService.GetAllProjectTypes(new ProjectTypeInputModel(), loggedInContext,
                                                        new List<ValidationMessage>());
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }

                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.WorkFlowAndStatusModel))
                    {
                        try
                        {

                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "WorkFlowAndStatusModel", "System configuration service"));
                            systemConfigurationExportModel.WorkFlowAndStatusModel = new WorkFlowAndStatusModel();

                            systemConfigurationExportModel.WorkFlowAndStatusModel.WorkFlows = _workFlowService.GetAllWorkFlows(false, loggedInContext, new List<ValidationMessage>());

                            if (systemConfigurationExportModel.WorkFlowAndStatusModel.WorkFlows != null && systemConfigurationExportModel.WorkFlowAndStatusModel.WorkFlows.Count > 0)
                            {
                                systemConfigurationExportModel.WorkFlowAndStatusModel.WorkFlowStatuses = new List<WorkFlowStatusApiReturnModel>();
                                systemConfigurationExportModel.WorkFlowAndStatusModel.WorkFlowEligibleStatusTransitionModels = new List<WorkFlowEligibleStatusTransitionApiReturnModel>();

                                foreach (var workFlow in systemConfigurationExportModel.WorkFlowAndStatusModel.WorkFlows)
                                {
                                    List<WorkFlowStatusApiReturnModel> workFlowStatus = _workFlowStatusService.GetAllWorkFlowStatus(false, workFlow.WorkFlowId, null, loggedInContext, new List<ValidationMessage>());

                                    if (workFlowStatus != null && workFlowStatus.Count > 0)
                                    {
                                        systemConfigurationExportModel.WorkFlowAndStatusModel.WorkFlowStatuses.AddRange(workFlowStatus);
                                    }

                                    List<WorkFlowEligibleStatusTransitionApiReturnModel> workFlowEligibleStatusTransitionModels = _workFlowEligibleStatusTransitionService.GetWorkFlowEligibleStatusTransitions(new WorkFlowEligibleStatusTransitionInputModel()
                                    {
                                        WorkFlowId = workFlow.WorkFlowId
                                    }, loggedInContext, new List<ValidationMessage>());

                                    if (workFlowEligibleStatusTransitionModels != null &&
                                        workFlowEligibleStatusTransitionModels.Count > 0)
                                    {
                                        systemConfigurationExportModel.WorkFlowAndStatusModel.WorkFlowEligibleStatusTransitionModels.AddRange(workFlowEligibleStatusTransitionModels);
                                    }
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.Projects))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Projects", "System configuration service"));
                            systemConfigurationExportModel.Projects = _projectService.SearchProjects(new ProjectSearchCriteriaInputModel(), loggedInContext, new List<ValidationMessage>());
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }

                    }

                    if (systemConfigurationExportModel.Projects != null && systemConfigurationExportModel.Projects.Count > 0)
                    {
                        try
                        {

                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GoalTemplates", "System configuration service"));
                            if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.GoalTemplates))
                            {
                                systemConfigurationExportModel.GoalTemplates = new List<GoalApiReturnModel>();
                                foreach (var project in systemConfigurationExportModel.Projects)
                                {
                                    List<GoalApiReturnModel> goals = _goalService.SearchGoals(new GoalSearchCriteriaInputModel
                                    {
                                        ProjectId = project.ProjectId
                                    }, loggedInContext, new List<ValidationMessage>());

                                    if (goals != null && goals.Count > 0)
                                    {
                                        systemConfigurationExportModel.GoalTemplates.AddRange(goals);
                                    }
                                }
                            }

                            if (systemConfigurationExportModel.GoalTemplates != null &&
                                systemConfigurationExportModel.GoalTemplates.Count > 0 && systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.TemplateUserStories))
                            {
                                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "TemplateUserStories", "System configuration service"));
                                systemConfigurationExportModel.TemplateUserStories = new List<GetUserStoriesOverviewReturnModel>();

                                foreach (var goalTemplate in systemConfigurationExportModel.GoalTemplates)
                                {
                                    var templateUserStories = _userStoryService.GetUserStoriesOverview(
                                        new UserStorySearchCriteriaInputModel
                                        {
                                            GoalId = goalTemplate.GoalId
                                        }, loggedInContext, new List<ValidationMessage>());

                                    if (templateUserStories != null && templateUserStories.Count > 0)
                                    {
                                        systemConfigurationExportModel.TemplateUserStories.AddRange(templateUserStories);
                                    }
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                    if (systemExportInputModel.ExportDataModelIds.Contains((int)ExportDataConfiguration.CustomFields))
                    {
                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CustomFields", "System configuration service"));
                            systemConfigurationExportModel.CustomFields = _customFieldFormRepository.SearchCustomFields(new CustomFieldSearchCriteriaInputModel(), loggedInContext, validationMessages);
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }

                    }

                        try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSystemApps", "System configuration service"));
                            List<SystemAppsExport> systemApps = new List<SystemAppsExport>();

                            var widgetSearchCriteriaInputModel = new WidgetSearchCriteriaInputModel
                            {
                                IsArchived = false
                            };

                            widgetSearchCriteriaInputModel.IsExoport = true;

                            List<WidgetApiReturnModel> widgets = _widgetService.GetWidgetsBasedOnUser(widgetSearchCriteriaInputModel, loggedInContext, validationMessages);

                            List<WidgetApiReturnModel> systemWidgets = new List<WidgetApiReturnModel>();

                            if (widgets != null && widgets.Count > 0)
                            {
                                systemWidgets = widgets.Where(x => !x.IsCustomWidget).ToList();
                            }

                            foreach (var systemApp in systemWidgets)
                            {
                                systemApps.Add(new SystemAppsExport
                                {
                                    SystemAppName = systemApp.WidgetName,
                                    SystemAppDescription = systemApp.Description,
                                    RoleNames = systemApp.RoleNames,
                                    RoleIds = systemApp.RoleIds,
                                    Tags = systemApp.Tags,
                                    IsArchived = systemApp.IsArchived,
                                    IsFavouriteWidget = systemApp.IsFavouriteWidget
                                });
                            }
                            systemConfigurationExportModel.SystemApps = systemApps;
                        }
                        catch (Exception ex)
                        {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                    }

                    try
                        {
                            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApps", "System configuration service"));
                            List<CustomAppsExport> customApps = new List<CustomAppsExport>();

                            var customWidgetSearchCriteriaInputModel = new CustomWidgetSearchCriteriaInputModel
                            {
                                IsArchived = false
                            };

                            customWidgetSearchCriteriaInputModel.IsExport = true;

                            var customWidgets = _widgetRepository.GetCustomWidgets(customWidgetSearchCriteriaInputModel, loggedInContext, new List<ValidationMessage>());

                            foreach (var app in customWidgets)
                            {
                                var procInputsAndOutputModel = new ProcInputsAndOutputModel
                                {
                                    CustomWidgetId = app.CustomWidgetId,
                                    CustomStoredProcId = app.CustomStoredProcId
                                };

                                CustomApiAppInputModel customApiAppInput = new CustomApiAppInputModel();
                            
                                if (app?.IsApi == true)
                                {
                                    CustomApiAppInputModel customApiAppInputModel = new CustomApiAppInputModel();
                                    customApiAppInputModel.CustomWidgetId = app.CustomWidgetId;
                                    customApiAppInput = _widgetRepository.GetCustomAppApiDetails(customApiAppInputModel, loggedInContext, validationMessages);
                                }


                            customApps.Add(new CustomAppsExport()
                                {
                                    CustomAppName = app.CustomWidgetName,
                                    CustomAppDescription = app.Description,
                                    CustomAppQuery = app.WidgetQuery,
                                    IsArchived = app.IsArchived,
                                    VisualizationName = app.VisualizationName,
                                    VisualizationType = app.VisualizationType,
                                    XCoOrdinate = app.XAxisColumnName,
                                    YCoOrdinate = app.YAxisDetails,
                                    IsHtml = app.IsHtml,
                                    FileUrls = app.FileUrls,
                                    DefaultColumns = app.DefaultColumns,
                                    RoleNames = app.RoleNames,
                                    RoleIds = app.RoleIds,
                                    Tags = app.Tags,
                                    IsEditable = app.IsEditable,
                                    PivotMeasurersToDisplay = "",//TODO 
                                    CronExpression = app.CronExpression,
                                    CronExpressionName = app.CronExpressionName,
                                    SelectedCharts = app.SelectedCharts,
                                    TemplateType = app.TemplateType,
                                    TemplateUrl = app.TemplateUrl,
                                    JobId = app.JobId,
                                    CustomAppAPIDetails = customApiAppInput,
                                    CustomWidgetsMultipleChartsXml = app.CustomWidgetsMultipleChartsXML,
                                    CustomAppColumns = app.CustomAppColumns,
                                    ProcName = app.ProcName,
                                    IsProc = app.IsProc,
                                    SubQueryType = app.SubQueryType,
                                    SubQuery = app.SubQuery,
                                    IsFavouriteWidget = app.IsFavouriteWidget,
                                    ProcInputsAndOutputModel = _widgetRepository.GetProcInputsAndOuputs(procInputsAndOutputModel, loggedInContext, new List<ValidationMessage>())
                                });
                            }
                            systemConfigurationExportModel.CustomApps = customApps;
                        }
                        catch (Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }
                    }

                if (systemExportInputModel.IsExportConfiguration == true)
                {
                    try
                    {
                        LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SoftLabelConfigurations", "System configuration service"));
                        systemConfigurationExportModel.SoftLabelConfigurations = _masterDataManagementService.GetSoftLabelsConfigurationsList(new SoftLabelsSearchInputModel(), loggedInContext, new List<ValidationMessage>());

                        LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CompanyModules", "System configuration service"));
                        systemConfigurationExportModel.CompanyModules = _masterDataManagementService.GetCompanyModulesList(new ModuleDetailsModel(), loggedInContext, validationMessages);

                        LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CompanyTheme", "System configuration service"));
                        systemConfigurationExportModel.CompanyTheme = _companyStructureService.GetCompanyTheme(loggedInContext.LoggedInUserId);

                        LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompanySettings", "System configuration service"));
                        CompanySettingsSearchInputModel companySettingsSearchInputModel = new CompanySettingsSearchInputModel
                        {
                            IsArchived = false,
                            IsFromExport = true
                        };

                        systemConfigurationExportModel.CompanySettings = _masterDataManagementService.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages);
                    }
                    catch (Exception ex)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                    }
                }

                if (systemExportInputModel.IsExportDashboard == true || (systemExportInputModel.WorkspaceIds != null && systemExportInputModel.WorkspaceIds.Count > 0))
                {
                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ExportDashboard", "System configuration service"));
                    List<DashboardsExport> dashboards = new List<DashboardsExport>();
                    try
                    {
                        var workspaceSearchCriteriaInputModel = new WorkspaceSearchCriteriaInputModel
                        {
                            IsArchived = false,
                            IsFromExport = true
                        };
                        var dashboardList = _widgetRepository.GetWorkspaces(workspaceSearchCriteriaInputModel, loggedInContext, new List<ValidationMessage>());
                        var selectedDashboardList = dashboardList.Where(x => systemExportInputModel.WorkspaceIds.Contains(x.WorkspaceId ?? new Guid())).ToList();
                        foreach (var dashboard in selectedDashboardList)
                        {

                            List<DashboardApps> dashboardApps = new List<DashboardApps>();
                            List<CustomAppsExport> customApps = new List<CustomAppsExport>();
                            var dashboardSearchCriteriaInputModel = new DashboardSearchCriteriaInputModel()
                            {
                                WorkspaceId = dashboard.WorkspaceId,
                                IsFromExport = true
                            };

                            var dashboardAppsList = _widgetRepository.GetDashboards(dashboardSearchCriteriaInputModel, loggedInContext, new List<ValidationMessage>());

                            foreach (var app in dashboardAppsList)
                            {

                                if (app.IsCustomWidget == true || app.IsHtml == true)
                                {
                                    var customWidgetSearchCriteriaInputModel = new CustomWidgetSearchCriteriaInputModel
                                    {
                                        IsArchived = false,
                                        CustomWidgetName = app.Name != app.CustomWidgetOriginalName ? (!string.IsNullOrWhiteSpace(app.CustomWidgetOriginalName) ? app.CustomWidgetOriginalName : app.Name) : app.Name
                                    };

                                    customWidgetSearchCriteriaInputModel.IsExport = true;

                                    var customWidgets = _widgetRepository.GetCustomWidgets(customWidgetSearchCriteriaInputModel, loggedInContext, new List<ValidationMessage>());

                                    foreach (var customApp in customWidgets)
                                    {
                                        var procInputsAndOutputModel = new ProcInputsAndOutputModel
                                        {
                                            CustomWidgetId = customApp.CustomWidgetId,
                                            CustomStoredProcId = customApp.CustomStoredProcId
                                        };

                                        CustomApiAppInputModel customApiAppInput = new CustomApiAppInputModel();

                                        if(customApp?.IsApi == true)
                                        {
                                            CustomApiAppInputModel customApiAppInputModel = new CustomApiAppInputModel();
                                            customApiAppInputModel.CustomWidgetId = customApp.CustomWidgetId;
                                            customApiAppInput = _widgetRepository.GetCustomAppApiDetails(customApiAppInputModel, loggedInContext, validationMessages);
                                        }


                                        customApps.Add(new CustomAppsExport()
                                        {
                                            CustomAppName = customApp.CustomWidgetName,
                                            CustomAppDescription = customApp.Description,
                                            CustomAppQuery = customApp.WidgetQuery,
                                            IsArchived = customApp.IsArchived,
                                            VisualizationName = customApp.VisualizationName,
                                            VisualizationType = customApp.VisualizationType,
                                            XCoOrdinate = customApp.XAxisColumnName,
                                            YCoOrdinate = customApp.YAxisDetails,
                                            IsHtml = customApp.IsHtml,
                                            IsAPI = customApp?.IsApi,
                                            FileUrls = customApp.FileUrls,
                                            DefaultColumns = customApp.DefaultColumns,
                                            RoleNames = customApp.RoleNames,
                                            RoleIds = customApp.RoleIds,
                                            Tags = customApp.Tags,
                                            IsEditable = app.IsEditable,
                                            PivotMeasurersToDisplay = "",//TODO 
                                            CronExpression = customApp.CronExpression,
                                            CronExpressionName = customApp.CronExpressionName,
                                            SelectedCharts = customApp.SelectedCharts,
                                            TemplateType = customApp.TemplateType,
                                            TemplateUrl = customApp.TemplateUrl,
                                            JobId = customApp.JobId,
                                            CustomWidgetsMultipleChartsXml = customApp.CustomWidgetsMultipleChartsXML,
                                            CustomAppColumns = customApp.CustomAppColumns,
                                            ProcName = customApp.ProcName,
                                            IsProc = customApp.IsProc,
                                            SubQueryType = customApp.SubQueryType,
                                            SubQuery = customApp.SubQuery,
                                            IsFavouriteWidget = customApp.IsFavouriteWidget,
                                            ModuleIds = customApp.ModuleIds,
                                            CustomAppAPIDetails = customApiAppInput,
                                            ProcInputsAndOutputModel = _widgetRepository.GetProcInputsAndOuputs(procInputsAndOutputModel, loggedInContext, new List<ValidationMessage>())
                                        });
                                    }
                                }

                                dashboardApps.Add(new DashboardApps()
                                {
                                    Name = app.Name != app.CustomWidgetOriginalName ? (!string.IsNullOrWhiteSpace(app.CustomWidgetOriginalName) ? app.CustomWidgetOriginalName : app.Name) : app.Name,
                                    DashboardName = app.DashboardName,
                                    X = app.X,
                                    Y = app.Y,
                                    Cols = app.Cols,
                                    Rows = app.Rows,
                                    MinItemCols = app.MinItemCols,
                                    MinItemRows = app.MinItemRows,
                                    IsArchived = app.IsArchived,
                                    IsCustomWidget = app.IsCustomWidget,
                                    PersistanceJson = app.PersistanceJson,
                                    Component = app.Component,
                                    CustomWidgetId = app.CustomWidgetId,
                                    CustomAppVisualizationId = app.CustomAppVisualizationId,
                                    Order = app.Order,
                                    ModuleIds = app.ModuleIds
                                });
                            }

                            dashboards.Add(new DashboardsExport()
                            {
                                DashboardName = dashboard.WorkspaceName,
                                DashboardDescription = dashboard.Description,
                                IsHidden = dashboard.IsHidden,
                                IsArchived = dashboard.IsArchived,
                                DefaultDashboardRoleIds = dashboard.DefaultDashboardRoleIds,
                                ViewRoleIds = dashboard.RoleIds,
                                EditRoleIds = dashboard.EditRoleIds,
                                DeleteRoleIds = dashboard.DeleteRoleIds,
                                DashboardApps = dashboardApps,
                                RoleNames = dashboard.RoleNames,
                                EditRoleNames = dashboard.EditRoleNames,
                                DeleteRoleNames = dashboard.DeleteRoleNames,
                                DefaultDashboardRoleNames = dashboard.DefaultDashboardRolesNames,
                                IsCustomizedFor = dashboard.IsCustomizedFor,
                                IsListView = dashboard.IsListView,
                                DashboardCustomApps = customApps
                            });

                        }
                        systemConfigurationExportModel.Dashboards = dashboards;
                    }
                    catch (Exception ex)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                    }

                }

                return systemConfigurationExportModel;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationService ", exception.Message), exception);

                return null;
            }
        }


        public string ImportSystemConfiguration(SystemConfigurationModel configuredData, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                var companyTheme = configuredData.CompanyTheme;
                var dashboards = configuredData.Dashboards;
                var forms = configuredData.FormTypes;
                var roles = configuredData.Roles;
                var entityRoles = configuredData.EntityRoleOutputModels;

                // Import company theme
                if (configuredData.CompanySettings != null && configuredData.CompanySettings.Count > 0)
                {
                    configuredData.CompanySettings.ForEach(x =>
                    {
                        if (x.Key == "MiniLogo")
                            x.Value = x.Value ?? "https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/hrm/0b2921a9-e930-4013-9047-670b5352f308/Logo-favicon-6b9022d6-7175-4f55-b4da-d5b2e5c98d4e.png";
                        if (x.Key == "MainLogo")
                            x.Value = x.Value ?? "https://bviewstorage.blob.core.windows.net/6671cd0d-5b91-4044-bdcc-e1f201c086c5/projects/d72d1c2f-dfbe-4d48-9605-cd3b7e38ed17/Main-Logo-9277cc4b-0c1f-4093-a917-1a65e874b3c9.png";
                    });

                    var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();

                    List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementService.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, new List<ValidationMessage>(), true);

                    foreach (var companySetting in configuredData.CompanySettings)
                    {
                        var companySetttingFindObj = companySettings.Find(x => x.Key == companySetting.Key);

                        if (companySetttingFindObj != null)
                        {
                            var companySettingsUpsertInputModel = new CompanySettingsUpsertInputModel()
                            {
                                Key = companySetttingFindObj.Key,
                                Value = companySetting.Value,
                                Description = companySetting.Description,
                                CompanySettingsId = companySetttingFindObj.CompanySettingsId,
                                TimeStamp = companySetttingFindObj.TimeStamp,
                                IsVisible = companySetting.IsVisible
                            };
                            _masterDataManagementService.UpsertCompanySettings(companySettingsUpsertInputModel, loggedInContext, new List<ValidationMessage>());
                        }
                    }
                }

                if (configuredData.CompanyModules != null && configuredData.CompanyModules.Count > 0)
                {
                    var companyModules = _masterDataManagementService.GetCompanyModulesList(new ModuleDetailsModel(), loggedInContext, validationMessages);

                    foreach (var companyModule in configuredData.CompanyModules)
                    {
                        var companyModuleObj = companyModules.FindAll(x => x.CompanyId == loggedInContext.CompanyGuid && x.ModuleId == companyModule.ModuleId && x.ModuleName.Trim() == companyModule.ModuleName.Trim()).ToList();
                        if (companyModuleObj != null && companyModuleObj.Count > 0)
                        {
                            var moduleDetailsModel = new ModuleDetailsModel();
                            moduleDetailsModel.CompanyModuleId = companyModuleObj[0].CompanyModuleId;
                            moduleDetailsModel.IsEnabled = companyModule.IsEnabled;
                            moduleDetailsModel.IsActive = companyModule.IsActive;
                            Guid? companySettingsId = _masterDataManagementService.UpsertCompanyModule(moduleDetailsModel, loggedInContext, validationMessages);
                        }
                    }
                }

                //Import roles
                if (roles != null && roles.Count > 0)
                {
                    var allRoles = _roleService.GetAllRoles(new RolesSearchCriteriaInputModel { }, loggedInContext, new List<ValidationMessage>());
                    foreach (var role in roles)
                    {
                        var selectedRole = allRoles.Find(x => x.RoleName == role.RoleName);
                        var roleUpsertModel = new RolesInputModel
                        {
                            RoleName = role.RoleName,
                            RoleId = selectedRole?.RoleId,
                            TimeStamp = selectedRole?.TimeStamp
                        };

                        if (role.FeatureIds != null && role.FeatureIds.Count > 0)
                        {
                            roleUpsertModel.FeatureIds = new List<Guid>();

                            roleUpsertModel.FeatureIds.AddRange(role.FeatureIds);
                        }

                        _roleService.UpsertRole(roleUpsertModel, loggedInContext, new List<ValidationMessage>());
                    }
                }

                if (entityRoles != null && entityRoles.Count > 0)
                {
                    var allEntityRoles = _entityRoleService.GetEntityRole(new EntityRoleSearchCriteriaInputModel { }, loggedInContext, new List<ValidationMessage>());

                    foreach (var entityRole in entityRoles)
                    {
                        var selectedEntityRole = allEntityRoles.Find(x => x.EntityRoleName == entityRole.EntityRoleName && x.CompanyId == loggedInContext.CompanyGuid);

                        var entityRoleDetails = _entityRoleService.UpsertEntityRole(new EntityRoleInputModel
                        {
                            EntityRoleName = entityRole.EntityRoleName,
                            EntityRoleId = selectedEntityRole?.EntityRoleId,
                            TimeStamp = selectedEntityRole?.TimeStamp
                        }, loggedInContext, new List<ValidationMessage>());

                        if (entityRoleDetails != null && entityRole.EntityRoleFeaturesList != null && entityRole.EntityRoleFeaturesList.Count > 0 && entityRoleDetails != Guid.Empty)
                        {
                            var entityRoleFeatureDetails = new EntityRoleFeatureUpsertInputModel
                            {
                                EntityRoleId = entityRoleDetails
                            };

                            entityRoleFeatureDetails.EntityFeatureIds = new List<Guid>();

                            entityRole.EntityRoleFeaturesList.ForEach(x =>
                            {
                                if (x.EntityFeatureId != null)
                                    entityRoleFeatureDetails.EntityFeatureIds.Add((Guid)x.EntityFeatureId);
                            });

                            _entityRoleFeatureService.UpsertEntityRoleFeature(entityRoleFeatureDetails,
                                loggedInContext, new List<ValidationMessage>());
                        }
                    }
                }

                var getAllRoles = _roleService.GetAllRoles(new RolesSearchCriteriaInputModel(), loggedInContext, validationMessages).ToList();
                var getAllCustomTags = _customTagService.GetCustomTags(new CustomTagsSearchCriteriaModel(), loggedInContext, validationMessages);

                if (configuredData.SystemApps !=null && configuredData.SystemApps.Count > 0)
                {
                    var allSystemApps = _widgetService.GetWidgets(new WidgetSearchCriteriaInputModel(), loggedInContext, new List<ValidationMessage>());

                    foreach (var systemapp in configuredData.SystemApps)
                    {
                        List<Guid> rolesList = (!string.IsNullOrWhiteSpace(systemapp.RoleNames)) ? getAllRoles.FindAll(x => systemapp.RoleNames.Split(',').ToList().Contains(x.RoleName)).Select(y => (Guid)y.RoleId).ToList() : new List<Guid>();
                        var systemAppFindObj = allSystemApps.Find(x => x.WidgetName == systemapp.SystemAppName);

                        if (systemAppFindObj !=null)
                        {
                            var customTagsSearchCriteria = new CustomTagsSearchCriteriaModel();
                            customTagsSearchCriteria.Tags = systemapp.Tags;

                            List<CustomTagsInputModel> customTags = null;
                            List<Guid> TagsIds = null;
                            if (customTagsSearchCriteria.Tags != null)
                            {
                                customTags = (!string.IsNullOrWhiteSpace(systemapp.Tags)) ? getAllCustomTags.FindAll(x => systemapp.Tags.Split(',').ToList().Contains(x.Tag)).ToList() : null;
                                if (customTags != null)
                                {
                                    TagsIds = customTags.Select(x => x.Id ?? Guid.Empty).ToList();
                                }
                            }

                            var widgetInputModel = new WidgetInputModel()
                            {
                                WidgetName = systemapp.SystemAppName,
                                Description = systemapp.SystemAppDescription,
                                SelectedRoleIds = rolesList,
                                IsArchived = systemapp.IsArchived,
                                TagsIds = TagsIds,
                                WidgetId = systemAppFindObj?.WidgetId,
                                TimeStamp = systemAppFindObj?.TimeStamp
                            };

                            widgetInputModel.WidgetId = _widgetService.UpsertWidget(widgetInputModel, loggedInContext, new List<ValidationMessage>());

                            if (systemapp.IsFavouriteWidget == true)
                            {
                                var favouriteWidgetsInputModel = new FavouriteWidgetsInputModel()
                                {
                                    WidgetId = widgetInputModel.WidgetId,
                                    IsFavouriteWidget = true
                                };
                                _widgetService.AddWidgetToFavourites(favouriteWidgetsInputModel, loggedInContext, new List<ValidationMessage>());
                            }
                        }
                    }
                }

                var allCustomApps = _widgetService.GetCustomWidgets(new CustomWidgetSearchCriteriaInputModel(), loggedInContext, new List<ValidationMessage>());
                if (configuredData.CustomApps !=null && configuredData.CustomApps.Count > 0)
                {
                    foreach (var customapp in configuredData.CustomApps)
                    {
                        List<Guid> rolesList = (!string.IsNullOrWhiteSpace(customapp.RoleNames)) ? getAllRoles.FindAll(x => customapp.RoleNames.Split(',').ToList().Contains(x.RoleName)).Select(y => (Guid)y.RoleId).ToList() : new List<Guid>();
                        var customAppFindObj = allCustomApps !=null ? allCustomApps.Find(x=> x.CustomWidgetName?.ToLower() == customapp.CustomAppName?.ToLower()) : null;
                        if (customAppFindObj !=null)
                        {
                            if ((bool)customapp.IsHtml)
                            {
                                var customHtmlApptInputModel = new CustomHtmlAppInputModel()
                                {
                                    CustomHtmlAppName = customAppFindObj.CustomWidgetName,
                                    Description = customAppFindObj.Description,
                                    HtmlCode = customAppFindObj.WidgetQuery,
                                    IsArchived = customAppFindObj.IsArchived,
                                    FileUrls = customAppFindObj.FileUrls,
                                    SelectedRoleIds = rolesList,
                                    CustomHtmlAppId = customAppFindObj?.CustomWidgetId,
                                    TimeStamp = customAppFindObj?.TimeStamp
                                };
                                customapp.CustomWidgetId = _widgetService.UpsertCustomHtmlApp(customHtmlApptInputModel, loggedInContext, new List<ValidationMessage>());
                            }
                            else
                            {
                                List<CustomAppChartModel> chartsDetails;

                                chartsDetails = Utilities.GetObjectFromXml<CustomAppChartModel>(customAppFindObj.CustomWidgetsMultipleChartsXML, "CustomWidgetsMultipleChartsModel");

                                var customAppDetails = customAppFindObj.CustomAppColumns != null ? Utilities.GetObjectFromXml<CustomWidgetHeaderModel>(customAppFindObj.CustomAppColumns, "CustomAppColumns") : null;
                                if (chartsDetails != null && chartsDetails.Count > 0)
                                {
                                    foreach (var chart in chartsDetails)
                                    {
                                        chart.CustomApplicationChartId = null;
                                    }

                                    var customTagsSearchCriteria = new CustomTagsSearchCriteriaModel();
                                    customTagsSearchCriteria.Tags = customapp.Tags;

                                    List<CustomTagsInputModel> customTags = null;
                                    List<Guid> TagsIds = null;

                                    if (customTagsSearchCriteria.Tags != null)
                                    {
                                        customTags = (!string.IsNullOrWhiteSpace(customapp.Tags)) ? getAllCustomTags.FindAll(x => customapp.Tags.Split(',').ToList().Contains(x.Tag)).ToList() : null;

                                        if (customTags != null)
                                        {
                                            TagsIds = customTags.Select(x => x.Id ?? Guid.Empty).ToList();

                                        }
                                    }
                                    //var customAppInputModel = new CustomWidgetsInputModel()
                                    //{
                                    //    CustomWidgetName = customAppFindObj.CustomWidgetName,
                                    //    Description = customAppFindObj.Description,
                                    //    WidgetQuery = customAppFindObj.WidgetQuery,
                                    //    IsArchived = null,
                                    //    IsEditable = customAppFindObj.IsEditable,
                                    //    SelectedRoleIds = rolesList,
                                    //    ChartsDetails = chartsDetails,
                                    //    DefaultColumns = customAppDetails,
                                    //    ProcName = customAppFindObj.ProcName,
                                    //    IsProc = customAppFindObj.IsProc,
                                    //    TagsIds = TagsIds,
                                    //    CustomWidgetId = customAppFindObj?.CustomWidgetId,
                                    //    TimeStamp = customAppFindObj?.TimeStamp
                                    //};
                                    var widgetInputModel = new WidgetInputModel()
                                    {
                                        WidgetName = customAppFindObj.CustomWidgetName,
                                        SelectedRoleIds = rolesList,
                                        TagsIds = TagsIds,
                                        IsCustomWidget = true,
                                        WidgetId = customAppFindObj?.CustomWidgetId
                                    };
                                    //customapp.CustomWidgetId = _widgetService.UpsertCustomWidget(customAppInputModel, loggedInContext, new List<ValidationMessage>());

                                    customapp.CustomWidgetId = _widgetService.UpsertImportWidget(widgetInputModel, loggedInContext, new List<ValidationMessage>());

                                    if (customapp?.CustomWidgetId != null && customapp?.CustomAppAPIDetails != null && customapp?.CustomAppAPIDetails?.ApiUrl != null)
                                    {
                                        var procInputsAndOutputModel = new CustomApiAppInputModel()
                                        {
                                            CustomWidgetId = customapp.CustomWidgetId,
                                            ApiUrl = customapp.CustomAppAPIDetails.ApiUrl.Trim(),
                                            ApiHeadersJson = customapp.CustomAppAPIDetails.ApiHeadersJson,
                                            ApiHeaders = customapp.CustomAppAPIDetails.ApiHeaders,
                                            OutputParams = customapp.CustomAppAPIDetails.OutputParams,
                                            HttpMethod = customapp.CustomAppAPIDetails.HttpMethod,
                                            BodyJson = customapp.CustomAppAPIDetails.BodyJson,
                                            ApiOutputsJson = customapp.CustomAppAPIDetails.ApiOutputsJson,
                                            OutputRoot = customapp.CustomAppAPIDetails.OutputRoot,
                                        };
                                        customapp.CustomAppAPIDetails.CustomWidgetId = _customApiAppService.UpsertCustomAppApiDetails(procInputsAndOutputModel, loggedInContext, new List<ValidationMessage>());
                                    }
                                }
                            }

                            if (customapp.IsFavouriteWidget == true)
                            {
                                var favouriteWidgetsInputModel = new FavouriteWidgetsInputModel()
                                {
                                    WidgetId = customapp.CustomWidgetId,
                                    IsFavouriteWidget = true
                                };
                                _widgetService.AddWidgetToFavourites(favouriteWidgetsInputModel, loggedInContext, new List<ValidationMessage>());
                            }
                        }
                    }
                }
               
                if(configuredData.Dashboards !=null && configuredData.Dashboards.Count > 0)
                {
                    var customWidgetInputModel = new CustomWidgetSearchCriteriaInputModel();
                    var allDashboards = _widgetService.GetWorkspaces(new WorkspaceSearchCriteriaInputModel(), loggedInContext, new List<ValidationMessage>());

                    if (dashboards != null && dashboards.Count > 0)
                    {
                        foreach (var dashboard in dashboards)
                        {
                            Guid? workspaceId;

                            var dashboardData = allDashboards.FindAll(x => x.WorkspaceName == dashboard.DashboardName).ToList();

                            var viewRoleIds = (!string.IsNullOrWhiteSpace(dashboard.RoleNames)) ? getAllRoles.FindAll(x => dashboard.RoleNames.Split(',').ToList().Contains(x.RoleName)).Select(y => y.RoleId).ToList() : null;
                            var editRoleIds = (!string.IsNullOrWhiteSpace(dashboard.EditRoleNames)) ? getAllRoles.FindAll(x => dashboard.EditRoleNames.Split(',').ToList().Contains(x.RoleName)).Select(y => y.RoleId).ToList() : null;
                            var deleteRoleIds = (!string.IsNullOrWhiteSpace(dashboard.DeleteRoleNames)) ? getAllRoles.FindAll(x => dashboard.DeleteRoleNames.Split(',').ToList().Contains(x.RoleName)).Select(y => y.RoleId).ToList() : null;
                            var defaultRoleIds = (!string.IsNullOrWhiteSpace(dashboard.DefaultDashboardRoleNames)) ? getAllRoles.FindAll(x => dashboard.DefaultDashboardRoleNames.Split(',').ToList().Contains(x.RoleName)).Select(y => y.RoleId).ToList() : null;

                            if (dashboardData == null || dashboardData?.Count == 0)
                            {
                                var workspaceInputModel = new WorkspaceInputModel()
                                {
                                    WorkspaceName = dashboard.DashboardName,
                                    Description = dashboard.DashboardDescription,
                                    IsHidden = dashboard.IsHidden,
                                    IsArchived = dashboard.IsArchived,
                                    IsCustomizedFor = dashboard.IsCustomizedFor,
                                    IsFromExport = true,
                                    IsListView = dashboard.IsListView,
                                    SelectedRoleIds = dashboard.RoleNames != null ? string.Join(",", viewRoleIds) : null,
                                    EditRoleIds = dashboard.EditRoleNames != null ? string.Join(",", editRoleIds) : null,
                                    DeleteRoleIds = dashboard.DeleteRoleNames != null ? string.Join(",", deleteRoleIds) : null
                                };
                                workspaceId = _widgetService.UpsertWorkspace(workspaceInputModel, loggedInContext, new List<ValidationMessage>());
                            }
                            else
                            {
                                workspaceId = dashboardData[0].WorkspaceId;
                            }

                            var dashboardConfigurationGetModel = new DashboardConfigurationInputModel()
                            {
                                DashboardId = workspaceId
                            };

                            var configuredDetails = _widgetService.GetDashboardConfigurations(dashboardConfigurationGetModel, loggedInContext, new List<ValidationMessage>());

                            if (configuredDetails != null && dashboard.DefaultDashboardRoleNames != null && configuredDetails.Count() > 0)
                            {
                                var dashboardConfigurationInputModel = new DashboardConfigurationInputModel()
                                {
                                    DashboardId = configuredDetails[0].DashboardId,
                                    TimeStamp = configuredDetails[0].TimeStamp,
                                    DashboardConfigurationId = configuredDetails[0].DashboardConfigurationId,
                                    DefaultDashboardRoles = dashboard.DefaultDashboardRoleNames != null ? string.Join(",", defaultRoleIds) : null,
                                    ViewRoles = dashboard.RoleNames != null ? string.Join(",", viewRoleIds) : null,
                                    EditRoles = dashboard.EditRoleNames != null ? string.Join(",", editRoleIds) : null,
                                    DeleteRoles = dashboard.DeleteRoleNames != null ? string.Join(",", deleteRoleIds) : null
                                };
                                _widgetService.UpsertDashboardConfiguration(dashboardConfigurationInputModel, loggedInContext, new List<ValidationMessage>());
                            }

                            int newAppsCount = 0;
                            if (dashboard.DashboardCustomApps != null && dashboard.DashboardCustomApps.Count > 0)
                            {
                                foreach (var customapp in dashboard.DashboardCustomApps)
                                {
                                    var appData = allCustomApps !=null ? allCustomApps.FindAll(x => x.CustomWidgetName?.ToLower() == customapp.CustomAppName?.ToLower()).ToList() : null;
                                    if (appData == null || appData?.Count == 0)
                                    {
                                        var moduleList = customapp.ModuleIds?.Split(',').ToList();

                                        List<Guid> rolesList = (!string.IsNullOrWhiteSpace(customapp.RoleNames)) ? getAllRoles.FindAll(x => customapp.RoleNames.Split(',').ToList().Contains(x.RoleName)).Select(y => (Guid)y.RoleId).ToList() :new List<Guid>();

                                        if ((bool)customapp.IsHtml)
                                        {
                                            var customHtmlApptInputModel = new CustomHtmlAppInputModel()
                                            {
                                                CustomHtmlAppName = customapp.CustomAppName,
                                                Description = customapp.CustomAppDescription,
                                                HtmlCode = customapp.CustomAppQuery,
                                                IsArchived = customapp.IsArchived,
                                                FileUrls = customapp.FileUrls,
                                                SelectedRoleIds = rolesList,
                                                ModuleIds = (moduleList != null && moduleList.Count > 0) ? moduleList.ConvertAll(Guid.Parse) : new List<Guid>()
                                            };
                                            customapp.CustomWidgetId = _widgetService.UpsertCustomHtmlApp(customHtmlApptInputModel, loggedInContext, new List<ValidationMessage>());
                                           
                                        }
                                        else
                                        {
                                            List<CustomAppChartModel> chartsDetails;

                                            chartsDetails = Utilities.GetObjectFromXml<CustomAppChartModel>(customapp.CustomWidgetsMultipleChartsXml, "CustomWidgetsMultipleChartsModel");

                                            var customAppDetails = customapp.CustomAppColumns != null ? Utilities.GetObjectFromXml<CustomWidgetHeaderModel>(customapp.CustomAppColumns, "CustomAppColumns") : null;
                                            if (chartsDetails != null && chartsDetails.Count > 0)
                                            {
                                                foreach (var chart in chartsDetails)
                                                {
                                                    chart.CustomApplicationChartId = null;
                                                }

                                                var customTagsSearchCriteria = new CustomTagsSearchCriteriaModel();
                                                customTagsSearchCriteria.Tags = customapp.Tags;

                                                List<CustomTagsInputModel> customTags = null;
                                                List<Guid> TagsIds = null;

                                                if (customTagsSearchCriteria.Tags != null)
                                                {
                                                    customTags = (!string.IsNullOrWhiteSpace(customapp.Tags)) ? getAllCustomTags.FindAll(x => customapp.Tags.Split(',').ToList().Contains(x.Tag)).ToList() : null;
                                                    if (customTags != null)
                                                    {
                                                        TagsIds = customTags.Select(x => x.Id ?? Guid.Empty).ToList();

                                                    }
                                                }

                                                var customAppInputModel = new CustomWidgetsInputModel()
                                                {
                                                    CustomWidgetName = customapp.CustomAppName,
                                                    Description = customapp.CustomAppDescription,
                                                    WidgetQuery = customapp.CustomAppQuery,
                                                    IsArchived = null,
                                                    IsEditable = customapp.IsEditable,
                                                    SelectedRoleIds = rolesList,
                                                    ChartsDetails = chartsDetails,
                                                    DefaultColumns = customAppDetails,
                                                    ProcName = customapp.ProcName,
                                                    IsApi = customapp.IsAPI,
                                                    IsProc = customapp.IsProc,
                                                    TagsIds = TagsIds,
                                                    ModuleIds = (moduleList != null && moduleList.Count > 0) ? moduleList.ConvertAll(Guid.Parse) : new List<Guid>()
                                                };

                                                customapp.CustomWidgetId = _widgetService.UpsertCustomWidget(customAppInputModel, loggedInContext, new List<ValidationMessage>());

                                                if (customapp.CustomWidgetId != null && customapp.ProcInputsAndOutputModel != null)
                                                {
                                                    var procInputsAndOutputModel = new ProcInputsAndOutputModel()
                                                    {
                                                        CustomWidgetId = customapp.CustomWidgetId,
                                                        ProcName = customapp.ProcInputsAndOutputModel.ProcName.Trim(),
                                                        InputsJson = customapp.ProcInputsAndOutputModel.InputsJson,
                                                        OutputsJson = customapp.ProcInputsAndOutputModel.OutputsJson,
                                                        LegendsJson = customapp.ProcInputsAndOutputModel.LegendsJson
                                                    };
                                                    customapp.ProcInputsAndOutputModel.CustomStoredProcId = _widgetService.UpsertProcInputsAndOuputs(procInputsAndOutputModel, loggedInContext, new List<ValidationMessage>());
                                                }

                                                if (customapp?.CustomWidgetId != null && customapp?.CustomAppAPIDetails != null && customapp?.CustomAppAPIDetails?.ApiUrl != null)
                                                {
                                                    var procInputsAndOutputModel = new CustomApiAppInputModel()
                                                    {
                                                        CustomWidgetId = customapp.CustomWidgetId,
                                                        ApiUrl = customapp.CustomAppAPIDetails.ApiUrl.Trim(),
                                                        ApiHeadersJson = customapp.CustomAppAPIDetails.ApiHeadersJson,
                                                        ApiHeaders = customapp.CustomAppAPIDetails.ApiHeaders,
                                                        OutputParams = customapp.CustomAppAPIDetails.OutputParams,
                                                        HttpMethod = customapp.CustomAppAPIDetails.HttpMethod,
                                                        BodyJson = customapp.CustomAppAPIDetails.BodyJson,
                                                        ApiOutputsJson = customapp.CustomAppAPIDetails.ApiOutputsJson,
                                                        OutputRoot = customapp.CustomAppAPIDetails.OutputRoot,
                                                    };
                                                    customapp.CustomAppAPIDetails.CustomWidgetId = _customApiAppService.UpsertCustomAppApiDetails(procInputsAndOutputModel, loggedInContext, new List<ValidationMessage>());
                                                }
                                            }
                                        }

                                        if (customapp.IsFavouriteWidget == true)
                                        {
                                            var favouriteWidgetsInputModel = new FavouriteWidgetsInputModel()
                                            {
                                                WidgetId = customapp.CustomWidgetId,
                                                IsFavouriteWidget = true
                                            };
                                            _widgetService.AddWidgetToFavourites(favouriteWidgetsInputModel, loggedInContext, new List<ValidationMessage>());
                                        }

                                        if (customapp.SelectedCharts != null)
                                        {
                                            var cronExpressionInputModel = new CronExpressionInputModel()
                                            {
                                                CronExpression = customapp.CronExpression,
                                                CronExpressionName = customapp.CronExpressionName,
                                                CronExpressionDescription = customapp.CronExpressionDescription,
                                                CustomWidgetId = customapp.CustomWidgetId,
                                                IsArchived = customapp.IsArchived,
                                                SelectedCharts = customapp.SelectedCharts,
                                                TemplateType = customapp.TemplateType,
                                                TemplateUrl = customapp.TemplateUrl,
                                                JobId = customapp.JobId,
                                                ChartsUrls = customapp.ChartsUrls,
                                                FileUrl = customapp.FileUrl,
                                                FileBytes = customapp.FileBytes,
                                                RunNow = customapp.RunNow
                                            };

                                            _widgetService.UpsertCronExpression(cronExpressionInputModel, loggedInContext, new List<ValidationMessage>());
                                        }
                                        newAppsCount = newAppsCount + 1;
                                    }
                                };
                            }

                            if(newAppsCount > 0)
                                allCustomApps = _widgetService.GetCustomWidgets(new CustomWidgetSearchCriteriaInputModel(), loggedInContext, new List<ValidationMessage>());

                            if (dashboard.DashboardApps != null && dashboard.DashboardApps.Count > 0)
                            {
                                var dashboardSearchCriteriaInputModel = new DashboardSearchCriteriaInputModel()
                                {
                                    WorkspaceId = workspaceId,
                                    IsFromExport = true,
                                };

                                var dashboardAllApps = _widgetRepository.GetDashboards(dashboardSearchCriteriaInputModel, loggedInContext, new List<ValidationMessage>());

                                foreach (var apps in dashboard.DashboardApps)
                                {
                                    var dashboardApps = dashboardAllApps.FindAll(x => x.Name == apps.Name && x.DashboardName == apps.DashboardName).ToList();
                                    if ((dashboardApps == null || dashboardApps?.Count == 0) && workspaceId !=null)
                                    {
                                        var appData = allCustomApps !=null ? allCustomApps.FindAll(x => x.CustomWidgetName?.ToLower() == apps.Name?.ToLower()).ToList() : null;

                                        Guid? customAppVisualizationId = null;

                                        if (appData != null && appData.Count > 0)
                                        {
                                            if (appData[0].CustomWidgetsMultipleChartsXML != null)
                                            {
                                                List<CustomAppChartModel> chartsDetails;

                                                chartsDetails = Utilities.GetObjectFromXml<CustomAppChartModel>(appData[0].CustomWidgetsMultipleChartsXML, "CustomWidgetsMultipleChartsModel");

                                                bool isAppInstalled = true;

                                                foreach (var chart in chartsDetails)
                                                {
                                                    if (((bool)chart.IsDefault || chartsDetails.Count > 0) && isAppInstalled)
                                                    {
                                                        customAppVisualizationId = chart.CustomApplicationChartId;
                                                        List<DashboardModel> dashboardModel = new List<DashboardModel>();
                                                        dashboardModel.Add(new DashboardModel()
                                                        {
                                                            DashboardId = Guid.NewGuid(),
                                                            Name = apps.Name,
                                                            X = apps.X,
                                                            Y = apps.Y,
                                                            Cols = apps.Cols,
                                                            Rows = apps.Rows,
                                                            MinItemCols = apps.MinItemCols,
                                                            MinItemRows = apps.MinItemRows,
                                                            Component = apps.Component,
                                                            DashboardName = apps.DashboardName,
                                                            CustomWidgetId = appData[0].CustomWidgetId,
                                                            IsCustomWidget = apps.IsCustomWidget,
                                                            IsArchived = (bool)apps.IsArchived,
                                                            CustomAppVisualizationId = customAppVisualizationId,
                                                            Order = apps.Order

                                                        });

                                                        var dashboardInputModel = new DashboardInputModel()
                                                        {
                                                            WorkspaceId = workspaceId,
                                                            Dashboard = dashboardModel,
                                                            IsFromImport = true
                                                        };

                                                        _widgetService.InsertDashboard(dashboardInputModel, loggedInContext, new List<ValidationMessage>());

                                                        isAppInstalled = false;
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                List<DashboardModel> dashboardModel = new List<DashboardModel>();
                                                dashboardModel.Add(new DashboardModel()
                                                {
                                                    DashboardId = Guid.NewGuid(),
                                                    Name = apps.Name,
                                                    X = apps.X,
                                                    Y = apps.Y,
                                                    Cols = apps.Cols,
                                                    Rows = apps.Rows,
                                                    MinItemCols = apps.MinItemCols,
                                                    MinItemRows = apps.MinItemRows,
                                                    Component = apps.Component,
                                                    DashboardName = apps.DashboardName,
                                                    CustomWidgetId = appData[0].CustomWidgetId,
                                                    IsCustomWidget = apps.IsCustomWidget,
                                                    IsArchived = (bool)apps.IsArchived,
                                                    CustomAppVisualizationId = customAppVisualizationId,
                                                    Order = apps.Order

                                                });

                                                var dashboardInputModel = new DashboardInputModel()
                                                {
                                                    WorkspaceId = workspaceId,
                                                    Dashboard = dashboardModel,
                                                    IsFromImport = true
                                                };

                                                _widgetService.InsertDashboard(dashboardInputModel, loggedInContext, new List<ValidationMessage>());
                                            }
                                        }
                                        else
                                        {
                                            List<DashboardModel> dashboardModel = new List<DashboardModel>();
                                            dashboardModel.Add(new DashboardModel()
                                            {
                                                DashboardId = Guid.NewGuid(),
                                                Name = apps.Name,
                                                X = apps.X,
                                                Y = apps.Y,
                                                Cols = apps.Cols,
                                                Rows = apps.Rows,
                                                MinItemCols = apps.MinItemCols,
                                                MinItemRows = apps.MinItemRows,
                                                Component = apps.Component,
                                                DashboardName = apps.DashboardName,
                                                CustomWidgetId = (appData != null && appData.Count > 0) ? appData[0].CustomWidgetId : null,
                                                IsCustomWidget = apps.IsCustomWidget,
                                                IsArchived = (bool)apps.IsArchived,
                                                CustomAppVisualizationId = customAppVisualizationId,
                                                Order = apps.Order
                                            });

                                            var dashboardInputModel = new DashboardInputModel()
                                            {
                                                WorkspaceId = workspaceId,
                                                Dashboard = dashboardModel,
                                                IsFromImport = true
                                            };

                                            _widgetService.InsertDashboard(dashboardInputModel, loggedInContext, new List<ValidationMessage>());
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Import Forms
                if (forms != null && forms.Count > 0)
                {
                    var allFormTypeDetails = _genericFormMasterDataService.GetGenericFormTypes(new GetGenericFormTypesSearchCriteriaInputModel(), loggedInContext, new List<ValidationMessage>());

                    foreach (var formType in forms)
                    {
                        Guid? formTypeId;
                        Guid? formId = null;

                        var formTypeDetails = allFormTypeDetails.FindAll(x => x.FormTypeName == formType.FormTypeName).ToList();
                        if (formTypeDetails == null || formTypeDetails?.Count == 0)
                        {
                            var genericFormTypeUpsertModel = new GenericFormTypeUpsertModel()
                            {
                                FormTypeName = formType.FormTypeName,
                                IsArchived = formType.IsArchived
                            };

                            formTypeId = _genericFormMasterDataService.UpsertGenericFormType(genericFormTypeUpsertModel, loggedInContext, new List<ValidationMessage>());
                        }
                        else formTypeId = formTypeDetails[0].Id;
                        //if (formTypeId != null)
                        //{
                        //    foreach (var form in formType.Forms)
                        //    {
                        //        var genericFormSearchCriteriaInputModel = new GenericFormSearchCriteriaInputModel()
                        //        {
                        //            FormTypeId = (Guid)formTypeId,
                        //            FormName = form.FormName
                        //        };

                        //        var formDetails = _genericFormService.GetGenericForms(genericFormSearchCriteriaInputModel, loggedInContext, new List<ValidationMessage>());


                        //        if (formDetails == null || formDetails?.Count == 0)
                        //        {
                        //            var genericFormUpsertInputModel = new GenericFormUpsertInputModel()
                        //            {
                        //                FormName = form.FormName,
                        //                FormJson = form.FormJson,
                        //                FormTypeId = formTypeId
                        //            };

                        //            GenericFormApiReturnModel createdForm = _genericFormService.UpsertGenericForms(genericFormUpsertInputModel, loggedInContext, new List<ValidationMessage>()).Result;

                        //            if (createdForm != null)
                        //            {
                        //                foreach (var formkey in form.FormKeys)
                        //                {
                        //                    var genericFormKeyUpsertInputModel = new GenericFormKeyUpsertInputModel()
                        //                    {
                        //                        GenericFormId = createdForm.Id,
                        //                        Key = formkey.key,
                        //                        //Label = formkey.Label,
                        //                        IsArchived = formkey.IsArchived,
                        //                        IsDefault = formkey.IsDefault
                        //                    };
                        //                    _genericFormService.UpsertGenericFormKey(genericFormKeyUpsertInputModel, loggedInContext, new List<ValidationMessage>());
                        //                }

                        //                formId = createdForm.Id;
                        //            }
                        //        }
                        //        else
                        //        {
                        //            formId = formDetails[0].Id;
                        //        }

                        //        // Import CustomApplications

                        //        var domainName = HttpContext.Current.Request.Headers.GetValues("Origin").FirstOrDefault();

                        //        if (form.CustomApplications != null && form.CustomApplications.Count > 0)
                        //        {
                        //            foreach (var application in form.CustomApplications)
                        //            {
                        //                Guid? customApplicationId;

                        //                var customApplicationSearchInputModel = new CustomApplicationSearchInputModel()
                        //                {
                        //                    CustomApplicationName = application.CustomApplicationName

                        //                };


                        //                var applicationDetails = _customApplicationService.GetCustomApplication(customApplicationSearchInputModel, loggedInContext, new List<ValidationMessage>());

                        //                List<Guid?> genericFormIds = new List<Guid?>();

                        //                var isUpdate = true;


                        //                foreach (var applicationids in applicationDetails)
                        //                {
                        //                    genericFormIds.Add(applicationids.FormId);
                        //                }

                        //                if (genericFormIds.ToList().Contains(formId))
                        //                {
                        //                    isUpdate = false;
                        //                }
                        //                else
                        //                {
                                            
                        //                    genericFormIds.Add(formId);
                        //                }
                                        

                        //                var roleIds =(!string.IsNullOrWhiteSpace(application.RoleNames)) ? getAllRoles.FindAll(x => application.RoleNames.Split(',').ToList().Contains(x.RoleName)).Select(y => y.RoleId).ToList() : new List<Guid?>();

                        //                if (applicationDetails == null || applicationDetails?.Count == 0)
                        //                {
                        //                    var customApplicationUpsertInputModel = new CustomApplicationUpsertInputModel()
                        //                    {
                        //                        CustomApplicationName = application.CustomApplicationName,
                        //                        PublicMessage = application.PublicMessage,
                        //                        IsArchived = application.IsArchived,
                        //                        RoleIds = application.RoleNames != null ? string.Join(",", roleIds) : null,
                        //                        FormId = formId.ToString(),
                        //                        // FormTypeId = application.FormTypeId,
                        //                        DomainName = domainName,
                        //                        SelectedKeyIds = application.SelectedKeyIds,
                        //                        SelectedPrivateKeyIds = application.SelectedPrivateKeyIds,
                        //                        SelectedTagKeyIds = application.SelectedTagKeyIds,
                        //                        SelectedEnableTrendsKeys = application.SelectedEnableTrendsKeys
                        //                    };
                        //                    customApplicationId = _customApplicationService.UpsertCustomApplication(customApplicationUpsertInputModel, loggedInContext, new List<ValidationMessage>());
                        //                }
                        //                else if ((applicationDetails != null || applicationDetails?.Count != 0) && isUpdate == true)
                        //                {
                        //                    var customApplicationUpsertInputModel = new CustomApplicationUpsertInputModel()
                        //                    {
                        //                        CustomApplicationName = application.CustomApplicationName,
                        //                        CustomApplicationId = applicationDetails.FirstOrDefault().CustomApplicationId,
                        //                        TimeStamp = applicationDetails.FirstOrDefault().TimeStamp,
                        //                        PublicMessage = application.PublicMessage,
                        //                        IsArchived = application.IsArchived,
                        //                        RoleIds = application.RoleNames != null ? string.Join(",", roleIds) : null,
                        //                        FormId = genericFormIds != null ? string.Join(",", genericFormIds) : null,
                        //                        // FormTypeId = application.FormTypeId,
                        //                        DomainName = domainName,
                        //                        SelectedKeyIds = application.SelectedKeyIds,
                        //                        SelectedPrivateKeyIds = application.SelectedPrivateKeyIds,
                        //                        SelectedTagKeyIds = application.SelectedTagKeyIds,
                        //                        SelectedEnableTrendsKeys = application.SelectedEnableTrendsKeys
                        //                    };
                        //                    customApplicationId = _customApplicationService.UpsertCustomApplication(customApplicationUpsertInputModel, loggedInContext, new List<ValidationMessage>());
                        //                }
                        //                else
                        //                {
                        //                    customApplicationId = applicationDetails[0].CustomApplicationId;
                        //                }

                        //                if (application.CustomApplicationWorkflows != null &&
                        //                    application.CustomApplicationWorkflows.Count > 0)
                        //                {
                        //                    foreach (var workflow in application.CustomApplicationWorkflows)
                        //                    {
                        //                        var customApplicationWorkflowSearchInputModel = new CustomApplicationWorkflowUpsertInputModel()
                        //                        {
                        //                            CustomApplicationId = customApplicationId
                        //                        };

                        //                        var customApplicationWorkflowsList = _customApplicationService.GetCustomApplicationWorkflow(customApplicationWorkflowSearchInputModel, loggedInContext, new List<ValidationMessage>());

                        //                        if (customApplicationWorkflowsList == null || customApplicationWorkflowsList?.Count == 0)
                        //                        {
                        //                            var customApplicationWorkflowUpsertInputModel = new CustomApplicationWorkflowUpsertInputModel()
                        //                            {
                        //                                CustomApplicationId = customApplicationId,
                        //                                WorkflowXml = workflow.WorkflowXml,
                        //                                RuleJson = workflow.Rulejson,
                        //                                CustomApplicationFormId = formId,
                        //                                CustomApplicationWorkflowTypeId = workflow.WorkflowTypeId
                        //                            };
                        //                            _customApplicationService.UpsertCustomApplicationWorkflow(customApplicationWorkflowUpsertInputModel, loggedInContext, new List<ValidationMessage>());
                        //                        }
                        //                    }
                        //                }
                        //            }
                        //        }
                        //    }
                        //}
                    }
                }

                if (configuredData.WorkItemTypes != null && configuredData.WorkItemTypes.Count > 0)
                {
                    var workItemTypesList = _userStoryReplanTypeService.GetUserStoryTypes(new UserStoryTypeSearchInputModel(),
                                                 loggedInContext, new List<ValidationMessage>());

                    configuredData.WorkItemTypes.ForEach(workItemType =>
                    {
                        var workItemTypeNameFindObj = workItemTypesList.Find(x => x.UserStoryTypeName == workItemType.UserStoryTypeName);

                        _userStoryReplanTypeService.UpsertUserStoryType(new UpsertUserStoryTypeInputModel
                        {
                            UserStoryTypeId = workItemTypeNameFindObj?.UserStoryTypeId,
                            UserStoryTypeName = workItemType.UserStoryTypeName,
                            ShortName = workItemType.ShortName,
                            UserStoryTypeColor = workItemType.UserStoryTypeColor,
                            IsBug = workItemType.IsBug,
                            IsLogTimeRequired = workItemType.IsLogTimeRequired,
                            IsUserStory = workItemType.IsUserStory,
                            IsQaRequired = workItemType.IsQaRequired,
                            IsAction = workItemType.IsAction,
                            TimeStamp = workItemTypeNameFindObj?.TimeStamp,
                        }, loggedInContext, new List<ValidationMessage>());
                    });
                }

                if (configuredData.BoardTypeApis != null && configuredData.BoardTypeApis.Count > 0)
                {
                    var boardTypeApiList = _boardTypeApiService.GetAllBoardTypeApi(new BoardTypeApiInputModel(), loggedInContext,
                            new List<ValidationMessage>());
                    configuredData.BoardTypeApis.ForEach(boardTypeApi =>
                    {
                        var boardTypeApiNameFindObj = boardTypeApiList.Find(x => x.ApiName == boardTypeApi.ApiName);
                        _boardTypeApiService.UpsertBoardTypeApi(new BoardTypeApiUpsertInputModel
                        {
                            ApiName = boardTypeApi.ApiName,
                            ApiUrl = boardTypeApi.ApiUrl,
                            BoardTypeApiId = boardTypeApiNameFindObj?.BoardTypeApiId,
                            TimeStamp = boardTypeApiNameFindObj?.TimeStamp
                        }, loggedInContext, new List<ValidationMessage>());
                    });
                }

                if (configuredData.WorkItemSubTypes != null && configuredData.WorkItemSubTypes.Count > 0)
                {
                    var workItemSubTypesList = _userStorySubTypeService.SearchUserStorySubTypes(
                        new UserStorySubTypeSearchCriteriaInputModel(), loggedInContext, new List<ValidationMessage>());

                    configuredData.WorkItemSubTypes.ForEach(workItemSubType =>
                    {
                        var workItemSubTypeFindObj = workItemSubTypesList.Find(x => x.UserStorySubTypeName == workItemSubType.UserStorySubTypeName);

                        _userStorySubTypeService.UpsertUserStorySubType(new UserStorySubTypeUpsertInputModel
                        {
                            UserStorySubTypeId = workItemSubTypeFindObj?.UserStorySubTypeId,
                            UserStorySubTypeName = workItemSubType.UserStorySubTypeName,
                            TimeStamp = workItemSubTypeFindObj?.TimeStamp,

                        }, loggedInContext, new List<ValidationMessage>());

                    });
                }

                if (configuredData.ProjectTypes != null && configuredData.ProjectTypes.Count > 0)
                {
                    var projectTypesList = _projectTypeService.GetAllProjectTypes(new ProjectTypeInputModel(), loggedInContext,
                                                    new List<ValidationMessage>());

                    configuredData.ProjectTypes.ForEach(projectType =>
                    {
                        var projectTypeNameFindObj = projectTypesList.Find(x => x.ProjectTypeName == projectType.ProjectTypeName);

                        _projectTypeService.UpsertProjectType(new ProjectTypeUpsertInputModel
                        {
                            ProjectTypeName = projectType.ProjectTypeName,
                            ProjectTypeId = projectTypeNameFindObj?.ProjectTypeId,
                            TimeStamp = projectTypeNameFindObj?.TimeStamp,
                        }, loggedInContext, new List<ValidationMessage>());
                    });
                }

                var allBoardTypes = _boardTypeService.GetAllBoardTypes(new BoardTypeInputModel(), loggedInContext,
                           new List<ValidationMessage>());
                var allWorkFlows = _workFlowService.GetAllWorkFlows(false, loggedInContext,
                                    new List<ValidationMessage>());
                if (configuredData.BoardTypes != null && configuredData.BoardTypes.Count > 0)
                {
                    configuredData.BoardTypes.ForEach(boardType =>
                    {
                        var boardTypeFindObj = allBoardTypes.Find(x => x.BoardTypeName == boardType.BoardTypeName);
                        var workflowFindObj = allWorkFlows.Find(x => x.WorkFlowName == boardType.WorkFlowName);
                        _boardTypeService.UpsertBoardType(new BoardTypeUpsertInputModel
                        {
                            BoardTypeName = boardType.BoardTypeName,
                            BoardTypeUiId = boardType.BoardTypeUiId,
                            WorkFlowId = workflowFindObj?.WorkFlowId,
                            BoardTypeId = boardTypeFindObj?.BoardTypeId,
                            TimeStamp = boardTypeFindObj?.TimeStamp,
                            IsSuperAgileBoard = boardType.IsSuperAgileBoard ?? false,
                            IsBugBoard = boardType.IsBugBoard ?? false,
                            IsDefault = boardType.IsDefault ?? false
                        }, loggedInContext,
                            new List<ValidationMessage>());
                    });
                }

                var allWorkItemStatuses = _statusService.GetAllStatuses(new UserStoryStatusInputModel(), loggedInContext,
                                                    new List<ValidationMessage>());

                if (configuredData.WorkItemStatuses != null && configuredData.WorkItemStatuses.Count > 0)
                {
                    foreach (var workItemStatus in configuredData.WorkItemStatuses)
                    {
                        var workItemStatusFindObj = allWorkItemStatuses.Find(x => x.UserStoryStatusName == workItemStatus.UserStoryStatusName);
                        Guid? statusId = _statusService.UpsertStatus(new UserStoryStatusUpsertInputModel
                        {
                            TaskStatusId = workItemStatus.TaskStatusId,
                            UserStoryStatusName = workItemStatus.UserStoryStatusName,
                            UserStoryStatusColor = workItemStatus.UserStoryStatusColor,
                            UserStoryStatusId = workItemStatusFindObj?.UserStoryStatusId,
                            TimeStamp = workItemStatusFindObj?.TimeStamp
                        }, loggedInContext, new List<ValidationMessage>());
                    }
                }

                if (configuredData.WorkFlowAndStatusModel != null)
                {
                    allWorkItemStatuses = _statusService.GetAllStatuses(new UserStoryStatusInputModel(), loggedInContext,
                                                    new List<ValidationMessage>());

                    if (configuredData.WorkFlowAndStatusModel.WorkFlows != null &&
                        configuredData.WorkFlowAndStatusModel.WorkFlows.Count > 0)
                    {
                        Guid? workFlowId = null;
                        foreach (var workflow in configuredData.WorkFlowAndStatusModel.WorkFlows)
                        {
                            workFlowId = _workFlowService.UpsertWorkFlow(workflow.WorkFlowName, null, false, null, loggedInContext, new List<ValidationMessage>());

                            if (workFlowId == null || workFlowId == Guid.Empty)
                            {
                                allWorkFlows = _workFlowService.GetAllWorkFlows(false, loggedInContext,
                                    new List<ValidationMessage>());

                                if (allWorkFlows != null && allWorkFlows.Count > 0 &&
                                    allWorkFlows.FirstOrDefault(x => x.WorkFlowName == workflow.WorkFlowName) != null)
                                {
                                    workFlowId = allWorkFlows
                                        .FirstOrDefault(x => x.WorkFlowName == workflow.WorkFlowName).WorkFlowId;
                                }
                            }

                            if (workFlowId != null)
                            {
                                workflow.WorkFlowId = workFlowId;

                                if (configuredData.WorkFlowAndStatusModel.WorkFlowStatuses != null &&
                                    configuredData.WorkFlowAndStatusModel.WorkFlowStatuses.Where(x => x.WorkflowName == workflow.WorkFlowName).ToList().Count > 0)
                                {
                                    configuredData.WorkFlowAndStatusModel.WorkFlowStatuses.Where(x => x.WorkflowName == workflow.WorkFlowName).ToList().ForEach(x => x.WorkFlowId = workFlowId);
                                }

                                if (configuredData.WorkFlowAndStatusModel.WorkFlowEligibleStatusTransitionModels !=
                                    null && configuredData.WorkFlowAndStatusModel.WorkFlowEligibleStatusTransitionModels
                                        .Where(x => x.WorkflowName == workflow.WorkFlowName).ToList().Count > 0)
                                {
                                    configuredData.WorkFlowAndStatusModel.WorkFlowEligibleStatusTransitionModels
                                        .Where(x => x.WorkflowName == workflow.WorkFlowName).ToList().ForEach(x => x.WorkFlowId = workFlowId);
                                }

                                configuredData.WorkFlowAndStatusModel.WorkFlows
                                        .FirstOrDefault(x => x.WorkFlowName == workflow.WorkFlowName).WorkFlowId =
                                    workFlowId;

                                if (configuredData.BoardTypes != null && configuredData.BoardTypes.Count > 0 &&
                                    configuredData.BoardTypes.FirstOrDefault(x =>
                                        x.WorkFlowId == workflow.WorkFlowId) != null)
                                {
                                    configuredData.BoardTypes.FirstOrDefault(x =>
                                        x.WorkFlowId == workflow.WorkFlowId).WorkFlowId = workFlowId;
                                }
                            }
                        }

                        if (configuredData.BoardTypes != null && configuredData.BoardTypes.Count > 0)
                        {
                            configuredData.BoardTypes.ForEach(boardType =>
                            {
                                var boardTypeFindObj = allBoardTypes.Find(x => x.BoardTypeName == boardType.BoardTypeName);
                                _boardTypeService.UpsertBoardType(new BoardTypeUpsertInputModel
                                {
                                    BoardTypeName = boardType.BoardTypeName,
                                    BoardTypeUiId = boardType.BoardTypeUiId,
                                    WorkFlowId = workFlowId,
                                    BoardTypeId = boardTypeFindObj?.BoardTypeId,
                                    TimeStamp = boardTypeFindObj?.TimeStamp
                                }, loggedInContext,
                                    new List<ValidationMessage>());
                            });
                        }
                    }

                    if (configuredData.WorkFlowAndStatusModel.WorkFlowStatuses != null &&
                        configuredData.WorkFlowAndStatusModel.WorkFlowStatuses.Count > 0)
                    {
                        if (configuredData.WorkItemStatuses != null && configuredData.WorkItemStatuses.Count > 0)
                        {
                            foreach (var workItemStatus in configuredData.WorkItemStatuses)
                            {
                                var workItemStatusFindObj = allWorkItemStatuses.Find(x => x.UserStoryStatusName == workItemStatus.UserStoryStatusName);
                                Guid? statusId = _statusService.UpsertStatus(new UserStoryStatusUpsertInputModel
                                {
                                    TaskStatusId = workItemStatus.TaskStatusId,
                                    UserStoryStatusName = workItemStatus.UserStoryStatusName,
                                    UserStoryStatusColor = workItemStatus.UserStoryStatusColor,
                                    UserStoryStatusId = workItemStatusFindObj?.UserStoryStatusId,
                                    TimeStamp = workItemStatusFindObj?.TimeStamp
                                }, loggedInContext, new List<ValidationMessage>());

                                if (statusId == null || statusId == Guid.Empty)
                                {
                                    var allStatuses = _statusService.GetAllStatuses(new UserStoryStatusInputModel
                                    {
                                        UserStoryStatusName = workItemStatus.UserStoryStatusName
                                    }, loggedInContext,
                                        new List<ValidationMessage>());

                                    if (allStatuses != null && allStatuses.Count > 0 &&
                                        allStatuses.FirstOrDefault(x => x.UserStoryStatusName == workItemStatus.UserStoryStatusName) != null)
                                    {
                                        statusId = allStatuses
                                            .FirstOrDefault(x => x.UserStoryStatusName == workItemStatus.UserStoryStatusName).UserStoryStatusId;
                                    }
                                }

                                if (statusId != null && statusId != Guid.Empty && configuredData.WorkFlowAndStatusModel.WorkFlowStatuses != null &&
                                    configuredData.WorkItemStatuses.Count > 0)
                                {
                                    if (configuredData.WorkFlowAndStatusModel.WorkFlowStatuses.Where(x =>
                                            x.UserStoryStatusName == workItemStatus.UserStoryStatusName).ToList().Count > 0)
                                    {
                                        configuredData.WorkFlowAndStatusModel.WorkFlowStatuses.Where(x =>
                                            x.UserStoryStatusName == workItemStatus.UserStoryStatusName).ToList().ForEach(x => x.UserStoryStatusId = statusId);
                                    }

                                    if (configuredData.WorkFlowAndStatusModel.WorkFlowEligibleStatusTransitionModels !=
                                        null && configuredData.WorkFlowAndStatusModel
                                            .WorkFlowEligibleStatusTransitionModels.Count > 0)
                                    {
                                        if (configuredData.WorkFlowAndStatusModel
                                                .WorkFlowEligibleStatusTransitionModels.Where(x =>
                                                    x.FromWorkflowUserStoryStatus == workItemStatus.UserStoryStatusName)
                                                .ToList().Count > 0)
                                        {
                                            configuredData.WorkFlowAndStatusModel
                                                .WorkFlowEligibleStatusTransitionModels.Where(x =>
                                                    x.FromWorkflowUserStoryStatus == workItemStatus.UserStoryStatusName)
                                                .ToList().ForEach(x => x.FromWorkflowUserStoryStatusId = statusId);
                                        }

                                        if (configuredData.WorkFlowAndStatusModel
                                                .WorkFlowEligibleStatusTransitionModels.Where(x =>
                                                    x.ToWorkflowUserStoryStatus == workItemStatus.UserStoryStatusName)
                                                .ToList().Count > 0)
                                        {
                                            configuredData.WorkFlowAndStatusModel
                                                .WorkFlowEligibleStatusTransitionModels.Where(x =>
                                                    x.ToWorkflowUserStoryStatus == workItemStatus.UserStoryStatusName)
                                                .ToList().ForEach(x => x.ToWorkflowUserStoryStatusId = statusId);
                                        }
                                    }
                                }
                            }
                        }

                        foreach (var workflow in configuredData.WorkFlowAndStatusModel.WorkFlows)
                        {
                            var selectedWorkFlowStauses = configuredData.WorkFlowAndStatusModel.WorkFlowStatuses
                                .Where(x => x.WorkFlowId == workflow.WorkFlowId).OrderBy(x => x.OrderId).ToList();

                            List<Guid> statusIds = new List<Guid>();

                            if (selectedWorkFlowStauses != null && selectedWorkFlowStauses.Count > 0)
                            {
                                foreach (var workflowStatus in selectedWorkFlowStauses)
                                {
                                    var workItemStatuFindObj = allWorkItemStatuses.Find(x => x.UserStoryStatusName == workflowStatus.UserStoryStatusName);

                                    if (workItemStatuFindObj != null)
                                        statusIds.Add((Guid)workItemStatuFindObj.UserStoryStatusId);
                                }
                            }

                            if (statusIds != null && statusIds.Count > 0)
                            {
                                _workFlowStatusService.UpsertWorkFlowStatus(new WorkFlowStatusUpsertInputModel
                                {
                                    WorkFlowId = workflow.WorkFlowId,
                                    StatusId = statusIds
                                }, loggedInContext, new List<ValidationMessage>());
                            }

                            var workFlowTransitions = configuredData.WorkFlowAndStatusModel
                                .WorkFlowEligibleStatusTransitionModels.Where(x => x.WorkFlowId == workflow.WorkFlowId)
                                .ToList();

                            if (workFlowTransitions != null && workFlowTransitions.Count > 0)
                            {
                                foreach (var workFlowTransition in workFlowTransitions)
                                {
                                    var workItemFromStatuFindObj = allWorkItemStatuses.Find(x => x.UserStoryStatusName == workFlowTransition.FromWorkflowUserStoryStatus);
                                    var workItemToStatuFindObj = allWorkItemStatuses.Find(x => x.UserStoryStatusName == workFlowTransition.ToWorkflowUserStoryStatus);
                                    if (workItemToStatuFindObj != null && workItemToStatuFindObj != null)
                                    {
                                        _workFlowEligibleStatusTransitionService.UpsertWorkFlowEligibleStatusTransition(
                                       new WorkFlowEligibleStatusTransitionUpsertInputModel
                                       {
                                           WorkFlowId = workflow.WorkFlowId,
                                           FromWorkflowUserStoryStatusId = workItemFromStatuFindObj.UserStoryStatusId,
                                           ToWorkflowUserStoryStatusId = workItemToStatuFindObj.UserStoryStatusId
                                       }, loggedInContext,
                                       new List<ValidationMessage>());
                                    }

                                }
                            }
                        }
                    }
                }


                var allProjectsList = new List<ProjectApiReturnModel>();

                if (configuredData.Projects !=null || configuredData.AuditsList != null)
                {
                    allProjectsList = _projectService.SearchProjects(new ProjectSearchCriteriaInputModel(), loggedInContext, new List<ValidationMessage>());
                }

                if (configuredData.Projects != null && configuredData.Projects.Count > 0)
                {
                    var allUserStoryTypes = _userStoryReplanTypeService.GetUserStoryTypes(new UserStoryTypeSearchInputModel(), loggedInContext, new List<ValidationMessage>()).ToList();

                    foreach (var project in configuredData.Projects)
                    {
                        var projectFindObj = allProjectsList.Find(x => x.ProjectName == project.ProjectName && x.CompanyId == loggedInContext.CompanyGuid);
                        Guid? projectId = _projectService.UpsertProject(new ProjectUpsertInputModel
                        {
                            ProjectId = projectFindObj?.ProjectId,
                            ProjectName = project.ProjectName,
                            ProjectResponsiblePersonId = loggedInContext.LoggedInUserId,
                            IsSprintsConfiguration = project.IsSprintsConfiguration,
                            TimeStamp = project.TimeStamp
                        }, loggedInContext, new List<ValidationMessage>());

                        if (projectId != null && projectId != Guid.Empty)
                        {
                            if (configuredData.GoalTemplates != null && configuredData.GoalTemplates.Count > 0)
                            {
                                if (configuredData.GoalTemplates.Where(x => x.ProjectId == project.ProjectId).ToList()
                                        .Count > 0)
                                {
                                    configuredData.GoalTemplates.Where(x => x.ProjectId == project.ProjectId).ToList().ForEach(x => x.ProjectId = (Guid)projectId);
                                }
                            }
                        }

                        if (configuredData.GoalTemplates != null && configuredData.GoalTemplates.Count > 0)
                        {
                            var projectGoalTemplates = configuredData.GoalTemplates.Where(x => x.ProjectId == projectId).ToList();
                            var goalList = _goalService.SearchGoals(new GoalSearchCriteriaInputModel
                            {
                                ProjectId = projectId
                            }, loggedInContext, new List<ValidationMessage>());

                            if (projectGoalTemplates != null && projectGoalTemplates.Count > 0)
                            {

                                foreach (var goalTemplate in projectGoalTemplates)
                                {
                                    var goalFindObj = goalList.Find(x => x.ProjectId == projectId && x.GoalName == goalTemplate.GoalName);

                                    List<BoardTypeApiReturnModel> boardTypeApiReturnModels = _boardTypeService.GetAllBoardTypes(new BoardTypeInputModel { BoardTypeName = goalTemplate.BoardTypeName }, loggedInContext,
                                        new List<ValidationMessage>());
                                    Guid? goalId = _goalService.UpsertGoal(new GoalUpsertInputModel
                                    {
                                        GoalId = goalFindObj?.GoalId,
                                        TimeStamp = goalFindObj?.TimeStamp,
                                        IsToBeTracked = goalTemplate?.IsToBeTracked,
                                        GoalName = goalTemplate.GoalName,
                                        GoalShortName = goalTemplate.GoalShortName,
                                        OnboardProcessDate = goalTemplate.OnboardProcessDate,
                                        GoalBudget = goalTemplate.GoalBudget,
                                        IsLocked = goalTemplate.IsLocked,
                                        GoalResponsibleUserId = loggedInContext.LoggedInUserId,
                                        IsApproved = goalTemplate.IsApproved,
                                        ProjectId = goalTemplate.ProjectId,
                                        BoardTypeId = boardTypeApiReturnModels != null && boardTypeApiReturnModels.Count > 0 ? boardTypeApiReturnModels[0].BoardTypeId : null,
                                    }, loggedInContext,
                                        new List<ValidationMessage>());

                                    if (goalId != null && goalId != Guid.Empty)
                                    {
                                        if (configuredData.TemplateUserStories != null &&
                                            configuredData.TemplateUserStories.Count > 0)
                                        {
                                            if (configuredData.TemplateUserStories
                                                    .Where(x => x.GoalId == goalTemplate.GoalId).ToList().Count > 0)
                                            {
                                                configuredData.TemplateUserStories
                                                    .Where(x => x.GoalId == goalTemplate.GoalId).ToList().ForEach(x => x.GoalId = goalId);
                                            }
                                        }
                                    }

                                    if (configuredData.TemplateUserStories != null &&
                                        configuredData.TemplateUserStories.Count > 0)
                                    {
                                        var templateUserStories = configuredData.TemplateUserStories
                                            .Where(x => x.GoalId == goalId).ToList();

                                        if (templateUserStories != null && templateUserStories.Count > 0)
                                        {
                                            var templateUserStoriesList = _userStoryService.GetUserStoriesOverview(
                                    new UserStorySearchCriteriaInputModel
                                    {
                                        GoalId = goalTemplate.GoalId
                                    }, loggedInContext, new List<ValidationMessage>());

                                            foreach (var templateUserStory in templateUserStories)
                                            {
                                                var userStoryFindObj = templateUserStoriesList.Find(x => x.GoalId == goalId && x.ProjectId == templateUserStory.ProjectId
                                                && x.UserStoryName == templateUserStory.UserStoryName);

                                                Guid? userStoryTypeId;

                                                //var userStoryStatus = _statusService.GetAllStatuses(
                                                //    new UserStoryStatusInputModel
                                                //    {
                                                //        UserStoryStatusName = templateUserStory.UserStoryStatusName
                                                //    }, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault();

                                                //var userStoryType = _userStoryReplanTypeService.GetUserStoryTypes(
                                                //    new UserStoryTypeSearchInputModel
                                                //    {
                                                //        UserStoryTypeName = templateUserStory.UserStoryTypeName
                                                //    }, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault();

                                                var userStoryStatus = allWorkItemStatuses.Find(x => x.UserStoryStatusName == templateUserStory.UserStoryStatusName);
                                                var userStoryType = allUserStoryTypes.Find(x => x.UserStoryTypeName == templateUserStory.UserStoryTypeName);
                                                if (userStoryType == null)
                                                {
                                                    userStoryTypeId = _userStoryReplanTypeService.UpsertUserStoryType(
                                                        new UpsertUserStoryTypeInputModel
                                                        {
                                                            UserStoryTypeName = templateUserStory.UserStoryTypeName
                                                        }, loggedInContext, new List<ValidationMessage>());
                                                }
                                                else
                                                {
                                                    userStoryTypeId = userStoryType.UserStoryTypeId;
                                                }

                                                if (userStoryTypeId != null && userStoryTypeId != Guid.Empty)
                                                {
                                                    _userStoryService.UpsertUserStory(new UserStoryUpsertInputModel
                                                    {
                                                        UserStoryId = userStoryFindObj?.UserStoryId,
                                                        TimeStamp = userStoryFindObj?.TimeStamp,
                                                        GoalId = templateUserStory.GoalId,
                                                        EstimatedTime = templateUserStory.EstimatedTime,
                                                        UserStoryName = templateUserStory.UserStoryName,
                                                        UserStoryTypeId = userStoryTypeId,
                                                        UserStoryStatusId = userStoryStatus != null ? userStoryStatus.UserStoryStatusId : null,
                                                        Order = templateUserStory.Order,
                                                        ProjectId = templateUserStory.ProjectId,
                                                        UserStoryUniqueName = templateUserStory.UserStoryUniqueName,
                                                        DeadLineDate = templateUserStory.DeadLineDate
                                                    },
                                                        loggedInContext, new List<ValidationMessage>());
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                if (configuredData.QuestionTypes != null && configuredData.QuestionTypes.Count > 0)
                {
                    var questionTypeList = _complianceAuditService.GetQuestionTypes(new QuestionTypeApiInputModel(), loggedInContext, new List<ValidationMessage>());
                    foreach (var questionType in configuredData.QuestionTypes)
                    {
                        var questionTypeFindObj = questionTypeList.Find(x => x.QuestionTypeName == questionType.QuestionTypeName);
                        questionType.QuestionTypeOptions.ForEach(x => x.QuestionTypeOptionId = null);

                        _complianceAuditService.UpsertQuestionType(new QuestionTypeApiInputModel
                        {
                            QuestionTypeName = questionType.QuestionTypeName,
                            MasterQuestionTypeId = questionType.MasterQuestionTypeId,
                            QuestionTypeOptionsXml = questionType.QuestionTypeOptionsXml,
                            IsArchived = questionType.IsArchived,
                            QuestionTypeOptions = questionType.QuestionTypeOptions,
                            QuestionTypeId = questionTypeFindObj?.QuestionTypeId,
                            TimeStamp = questionTypeFindObj?.TimeStamp
                        }, loggedInContext,
                            new List<ValidationMessage>());
                    }
                }

                if (configuredData.AuditsList != null && configuredData.AuditsList.Count > 0)
                {
                    var auditsList = _complianceAuditService.SearchAudits(new AuditComplianceApiInputModel()
                    {
                        IsArchived = false
                    }, loggedInContext, new List<ValidationMessage>());

                    allProjectsList = _projectService.SearchProjects(new ProjectSearchCriteriaInputModel(), loggedInContext, new List<ValidationMessage>());

                    foreach (var audit in configuredData.AuditsList)
                    {
                        var projectsList = allProjectsList.FindAll(x=> x.ProjectName == audit.ProjectName).ToList();
                        if (projectsList != null && projectsList.Count > 0)
                        {
                            audit.AuditTagsModels.ForEach(x => x.TagId = null);
                            var auditFindObj = auditsList.Find(x => x.AuditName == audit.AuditName);
                            var auditId = _complianceAuditService.UpsertAuditCompliance(new AuditComplianceApiInputModel
                            {
                                AuditName = audit.AuditName,
                                AuditDescription = audit.AuditDescription,
                                IsArchived = audit.IsArchived,
                                AuditTagsModels = audit.AuditTagsModels,
                                //CronExpression = audit.CronExpression,
                                ScheduleEndDate = audit.ScheduleEndDate,
                                ConductEndDate = audit.ConductEndDate,
                                //IsPaused = audit.IsPaused,
                                IsRAG = audit.IsRAG,
                                InBoundPercent = audit.InBoundPercent,
                                OutBoundPercent = audit.OutBoundPercent,
                                AuditId = auditFindObj?.AuditId,
                                TimeStamp = auditFindObj?.TimeStamp,
                                ProjectId = projectsList[0].ProjectId,
                                ResponsibleUserId = loggedInContext.LoggedInUserId
                            },
                                loggedInContext, new List<ValidationMessage>());
                            if (auditId != null && configuredData.AuditCategories != null && configuredData.AuditCategories.Count > 0)
                            {
                                List<AuditCategoryApiReturnModel> selectedAuditCategories = configuredData.AuditCategories
                                    .Where(x => x.AuditComplianceId == audit.AuditId).ToList();

                                if (selectedAuditCategories != null && selectedAuditCategories.Count > 0)
                                {
                                    InsertAuditQuestionsByCategories(selectedAuditCategories, auditId, loggedInContext,
                                        configuredData.AuditCategoryQuestions, null);
                                }
                            }
                        }
                    }
                }
                
                var companyDetails = _companyStructureService.GetCompanyDetails(loggedInContext, validationMessages);
                var systemCountrySearchCriteriaInputModel = new SystemCountrySearchCriteriaInputModel();
                systemCountrySearchCriteriaInputModel.CountryId = companyDetails?.CountryId;
                List<SystemCountryApiReturnModel> systemCountries = _systemCountryRepository.SearchSystemCountries(systemCountrySearchCriteriaInputModel, validationMessages).ToList();

                if (systemCountries !=null && systemCountries[0]?.CountryName == "India")
                {
                    var countryInputModel = new CountrySearchInputModel();
                    countryInputModel.CountryName = "India";
                    List<CountryApiReturnModel> countries = _companyStructureManagementService.GetCountries(countryInputModel, validationMessages, loggedInContext);

                    EmployeeInputModel employeeInputModel = new EmployeeInputModel
                    {
                        UserId = loggedInContext.LoggedInUserId
                    };

                    var userBranch = _branchService.GetUserBranchDetails(employeeInputModel, loggedInContext, new List<ValidationMessage>());

                    if (configuredData.PayrollComponents != null && configuredData.PayrollComponents.Count > 0)
                    {
                        foreach (var payrollComponent in configuredData.PayrollComponents)
                        {
                            Guid? payrollComponentId = _payRollService.UpsertPayRollComponent(new PayRollComponentUpsertInputModel
                            {
                                ComponentName = payrollComponent.ComponentName,
                                IsDeduction = payrollComponent.IsDeduction ?? false,
                                IsVariablePay = payrollComponent.IsVariablePay ?? false,
                                EmployeeContributionPercentage = payrollComponent.EmployeeContributionPercentage,
                                EmployerContributionPercentage = payrollComponent.EmployerContributionPercentage,
                                IsVisible = payrollComponent.IsVisible ?? false,
                                RelatedToContributionPercentage = payrollComponent.RelatedToContributionPercentage
                            }, loggedInContext, new List<ValidationMessage>());
                        }
                    }

                    if (configuredData.PayrollTemplates != null && configuredData.PayrollTemplates.Count > 0)
                    {
                        foreach (var payrollTemplate in configuredData.PayrollTemplates)
                        {
                            PayRollTemplateUpsertInputModel payrollTemplateId = _payRollService.UpsertPayRollTemplate(new PayRollTemplateUpsertInputModel
                            {
                                PayRollName = payrollTemplate.PayRollName,
                                PayRollShortName = payrollTemplate.PayRollShortName,
                                IsRepeatInfinitly = payrollTemplate.IsRepeatInfinitly,
                                IslastWorkingDay = payrollTemplate.IslastWorkingDay,
                                FrequencyId = payrollTemplate.FrequencyId,
                                CurrencyId = payrollTemplate.CurrencyId,
                                InfinitlyRunDate = payrollTemplate.InfinitlyRunDate
                            }, loggedInContext, new List<ValidationMessage>());
                        }
                    }

                    if (configuredData.PayrollTemplateConfigurations != null && configuredData.PayrollTemplateConfigurations.Count > 0)
                    {
                       var allPayrollComponents = _payRollService.GetPayRollComponents(new PayRollComponentSearchInputModel(), loggedInContext, new List<ValidationMessage>());

                       foreach (var payrollTemplateConfiguration in configuredData.PayrollTemplateConfigurations)
                        {
                            List<PayRollComponentSearchOutputModel> payrollComponents = new List<PayRollComponentSearchOutputModel>();
                            List<PayRollComponentSearchOutputModel> dependentPayrollComponents = new List<PayRollComponentSearchOutputModel>();
                            List<PayRollComponentSearchOutputModel> components = new List<PayRollComponentSearchOutputModel>();
                            List<PayRollTemplateSearchOutputModel> payrollTemplates = new List<PayRollTemplateSearchOutputModel>();
                            if (payrollTemplateConfiguration.PayRollTemplateName != null)
                            {
                                PayRollTemplateSearchInputModel payRollTemplateSearchInputModel = new PayRollTemplateSearchInputModel
                                {
                                    PayRollTemplateName = payrollTemplateConfiguration.PayRollTemplateName
                                };
                                payrollTemplates = _payRollService.GetPayRollTemplates(payRollTemplateSearchInputModel, loggedInContext, new List<ValidationMessage>());
                            }
                            if (payrollTemplateConfiguration.PayRollComponentName != null)
                            {
                                //PayRollComponentSearchInputModel payRollComponentSearchInputModel = new PayRollComponentSearchInputModel
                                //{
                                //    ComponentName = payrollTemplateConfiguration.PayRollComponentName
                                //};
                                payrollComponents = allPayrollComponents.FindAll(x => x.ComponentName == payrollTemplateConfiguration.PayRollComponentName).ToList();
                               // payrollComponents = _payRollService.GetPayRollComponents(payRollComponentSearchInputModel, loggedInContext, new List<ValidationMessage>());
                            }
                            if (payrollTemplateConfiguration.DependentPayRollComponentName != null)
                            {
                                //PayRollComponentSearchInputModel dependentPayRollComponentSearchInputModel = new PayRollComponentSearchInputModel
                                //{
                                //    ComponentName = payrollTemplateConfiguration.DependentPayRollComponentName
                                //};
                                payrollComponents = allPayrollComponents.FindAll(x => x.ComponentName == payrollTemplateConfiguration.DependentPayRollComponentName).ToList();
                                //dependentPayrollComponents = _payRollService.GetPayRollComponents(dependentPayRollComponentSearchInputModel, loggedInContext, new List<ValidationMessage>());
                            }
                            if (payrollTemplateConfiguration.ComponentName != null)
                            {
                                //PayRollComponentSearchInputModel componentSearchInputModel = new PayRollComponentSearchInputModel
                                //{
                                //    ComponentName = payrollTemplateConfiguration.ComponentName
                                //};
                                payrollComponents = allPayrollComponents.FindAll(x => x.ComponentName == payrollTemplateConfiguration.ComponentName).ToList();

                                //components = _payRollService.GetPayRollComponents(componentSearchInputModel, loggedInContext, new List<ValidationMessage>());
                            }
                            List<Guid> payrollIds = new List<Guid>();
                            payrollIds.Add(payrollComponents[0]?.PayRollComponentId ?? Guid.Empty);
                            Guid? payrollTemplateConfigurationId = _payRollService.UpsertPayRollTemplateConfiguration(new PayRollTemplateConfigurationUpsertInputModel
                            {
                                PayRollComponentIds = payrollIds,
                                PayRollTemplateId = payrollTemplates.Count > 0 ? payrollTemplates[0]?.PayRollTemplateId ?? Guid.Empty : Guid.Empty,
                                IsPercentage = payrollTemplateConfiguration.IsPercentage,
                                Amount = payrollTemplateConfiguration.Amount,
                                Percentagevalue = payrollTemplateConfiguration.Percentagevalue,
                                IsCtcDependent = payrollTemplateConfiguration.IsCtcDependent,
                                DependentPayRollComponentId = dependentPayrollComponents.Count > 0 ? dependentPayrollComponents[0]?.PayRollComponentId : null,
                                IsRelatedToPT = payrollTemplateConfiguration.IsRelatedToPT,
                                ComponentId = components.Count > 0 ? components[0]?.PayRollComponentId : null,
                                Order = payrollTemplateConfiguration.Order
                            }, loggedInContext, new List<ValidationMessage>());
                        }
                    }

                    if (configuredData.ProfessionalTaxRange != null && configuredData.ProfessionalTaxRange.Count > 0)
                    {
                        foreach (var professionalTaxRange in configuredData.ProfessionalTaxRange)
                        {
                            Guid? professionalTaxRangeId = _masterDataManagementService.UpsertProfessionalTaxRanges(new ProfessionalTaxRange
                            {
                                FromRange = professionalTaxRange.FromRange,
                                ToRange = professionalTaxRange.ToRange,
                                TaxAmount = professionalTaxRange.TaxAmount,
                                IsArchived = professionalTaxRange.IsArchived,
                                ActiveFrom = professionalTaxRange.ActiveFrom,
                                ActiveTo = professionalTaxRange.ActiveTo,
                                BranchId = userBranch?.BranchId
                            }, loggedInContext, new List<ValidationMessage>());
                        }
                    }

                    if (configuredData.TaxSlabs != null && configuredData.TaxSlabs.Count > 0)
                    {
                        foreach (var taxSlabs in configuredData.TaxSlabs.Where(x => x.ParentId == null))
                        {
                            Guid? taxSlabsId = _masterDataManagementService.UpsertTaxSlabs(new TaxSlabsUpsertInputModel
                            {
                                Name = taxSlabs.Name,
                                FromRange = taxSlabs.FromRange,
                                ToRange = taxSlabs.ToRange,
                                TaxPercentage = taxSlabs.TaxPercentage,
                                ActiveFrom = taxSlabs.ActiveFrom,
                                ActiveTo = taxSlabs.ActiveTo,
                                MinAge = taxSlabs.MinAge,
                                MaxAge = taxSlabs.MaxAge,
                                ForMale = taxSlabs.ForMale,
                                ForFemale = taxSlabs.ForFemale,
                                Handicapped = taxSlabs.Handicapped,
                                Order = taxSlabs.Order,
                                IsArchived = taxSlabs.IsArchived,
                                IsFlatRate = taxSlabs.IsFlatRate,
                                ParentId = taxSlabs.ParentId,
                                CountryId = countries[0]?.CountryId
                            }, loggedInContext, new List<ValidationMessage>());
                        }

                        foreach (var taxSlabs in configuredData.TaxSlabs.Where(x => x.ParentId != null))
                        {
                            if (taxSlabs.ParentId != null)
                            {
                                var taxSlab = new TaxSlabs();
                                if (taxSlabs.Name == "5-10L" || taxSlabs.Name == "2.5-5L" || taxSlabs.Name == "0-2.5L" || taxSlabs.Name == "Above 10L")
                                {
                                    taxSlab.Name = "Upto 60 years";
                                }
                                if (taxSlabs.Name == "Upto 3L" || taxSlabs.Name == "3.0-5.0L" || taxSlabs.Name == "5.0-10.0L" || taxSlabs.Name == "Above 10.0L")
                                {
                                    taxSlab.Name = "Age 60-80";
                                }
                                if (taxSlabs.Name == "upto 5L" || taxSlabs.Name == "B/w 5-10L" || taxSlabs.Name == "Above 10.0 L")
                                {
                                    taxSlab.Name = "Above 80 years";
                                }
                                if (taxSlabs.Name == "upto 2.5L" || taxSlabs.Name == "2.5-5.0 L" || taxSlabs.Name == "5-7.5L" || taxSlabs.Name == "7.5-10L"
                                    || taxSlabs.Name == "10-12.5L" || taxSlabs.Name == "12.5-15L" || taxSlabs.Name == "above 15L")
                                {
                                    taxSlab.Name = "Slabs";
                                }
                                List<TaxSlabs> taxSlabsList = _masterDataManagementService.GetTaxSlabs(taxSlab, loggedInContext, new List<ValidationMessage>());
                                taxSlabs.ParentId = taxSlabsList[0].TaxSlabId;
                            }

                            Guid? taxSlabsId = _masterDataManagementService.UpsertTaxSlabs(new TaxSlabsUpsertInputModel
                            {
                                Name = taxSlabs.Name,
                                FromRange = taxSlabs.FromRange,
                                ToRange = taxSlabs.ToRange,
                                TaxPercentage = taxSlabs.TaxPercentage,
                                ActiveFrom = taxSlabs.ActiveFrom,
                                ActiveTo = taxSlabs.ActiveTo,
                                MinAge = taxSlabs.MinAge,
                                MaxAge = taxSlabs.MaxAge,
                                ForMale = taxSlabs.ForMale,
                                ForFemale = taxSlabs.ForFemale,
                                Handicapped = taxSlabs.Handicapped,
                                Order = taxSlabs.Order,
                                IsArchived = taxSlabs.IsArchived,
                                IsFlatRate = taxSlabs.IsFlatRate,
                                ParentId = taxSlabs.ParentId,
                                CountryId = countries[0]?.CountryId
                            }, loggedInContext, new List<ValidationMessage>());
                        }
                    }

                    if (configuredData.TaxAllowances != null && configuredData.TaxAllowances.Count > 0)
                    {
                        try
                        {
                            List<TaxAllowanceTypeModel> taxAllowanceTypess = _payRollService.GetTaxAllowanceTypes(new PayRollTemplateSearchInputModel(), loggedInContext, validationMessages);

                            foreach (var taxAllowance in configuredData.TaxAllowances.Where(x => x.ParentId == null))
                            {
                                var taxAllowanceTypes = taxAllowanceTypess.FindAll(x => x.TaxAllowanceTypeName == "Manual").ToList();
                                taxAllowance.TaxAllowanceTypeId = taxAllowanceTypes[0].TaxAllowanceTypeId;

                                Guid? taxAllowanceId = _payRollService.UpsertTaxAllowance(new TaxAllowanceUpsertInputModel
                                {
                                    Name = taxAllowance.Name,
                                    TaxAllowanceTypeId = taxAllowance.TaxAllowanceTypeId,
                                    IsPercentage = taxAllowance.IsPercentage,
                                    MaxAmount = taxAllowance.MaxAmount,
                                    PercentageValue = taxAllowance.PercentageValue,
                                    ParentId = taxAllowance.ParentId,
                                    PayRollComponentId = taxAllowance.PayRollComponentId,
                                    ComponentId = taxAllowance.ComponentId,
                                    FromDate = taxAllowance.FromDate,
                                    ToDate = taxAllowance.ToDate,
                                    OnlyEmployeeMaxAmount = taxAllowance.OnlyEmployeeMaxAmount,
                                    MetroMaxPercentage = taxAllowance.MetroMaxPercentage,
                                    LowestAmountOfParentSet = taxAllowance.LowestAmountOfParentSet,
                                    CountryId = countries[0]?.CountryId
                                }, loggedInContext, new List<ValidationMessage>());
                            }

                            foreach (var taxAllowance in configuredData.TaxAllowances.Where(x => x.ParentId != null))
                            {

                                if (taxAllowance.Name == "40% BASIC" || taxAllowance.Name == "EPF" || taxAllowance.Name == "RENTAL-10%BASIC"
                                    || taxAllowance.Name == "SCHOOL FEES")
                                {
                                    var taxAllowanceTypes = taxAllowanceTypess.FindAll(x => x.TaxAllowanceTypeName == "Automatic").ToList();
                                    taxAllowance.TaxAllowanceTypeId = taxAllowanceTypes[0].TaxAllowanceTypeId;
                                }
                                else
                                {
                                    var taxAllowanceTypes = taxAllowanceTypess.FindAll(x => x.TaxAllowanceTypeName == "Manual").ToList();
                                    taxAllowance.TaxAllowanceTypeId = taxAllowanceTypes[0].TaxAllowanceTypeId;
                                }

                                if (taxAllowance.ParentId != null)
                                {
                                    var taxAllowanceModel = new TaxAllowanceSearchInputModel();
                                    if (taxAllowance.Name == "HOME LOAN INTEREST")
                                    {
                                        taxAllowanceModel.Name = "24";
                                    }
                                    if (taxAllowance.Name == "ELSS" || taxAllowance.Name == "EPF" || taxAllowance.Name == "HOME LOAN PRINCIPAL" || taxAllowance.Name == "KVP"
                                        || taxAllowance.Name == "LIC" || taxAllowance.Name == "NSC" || taxAllowance.Name == "PPF"
                                        || taxAllowance.Name == "SCHOOL FEES" || taxAllowance.Name == "SSY" || taxAllowance.Name == "STAMP DUTY")
                                    {
                                        taxAllowanceModel.Name = "80C";
                                    }
                                    if (taxAllowance.Name == "NPS")
                                    {
                                        taxAllowanceModel.Name = "80CCD(1B)";
                                    }
                                    if (taxAllowance.Name == "MEDICLAIM")
                                    {
                                        taxAllowanceModel.Name = "80D";
                                    }
                                    if (taxAllowance.Name == "INTEREST ON SAVINGS ACCOUNT (OTHER THAN SENIOR CITIZEN)")
                                    {
                                        taxAllowanceModel.Name = "80TTA";
                                    }
                                    if (taxAllowance.Name == "INTEREST ON DEPOSITS WITH POST OFFICE, BANKS, CO-OPERATIVE BANK (SENEIOR CITIZEN)"
                                        || taxAllowance.Name == "INTEREST ON SAVINGS ACCOUNT (SENEIOR CITIZEN)")
                                    {
                                        taxAllowanceModel.Name = "80TTB";
                                    }
                                    if (taxAllowance.Name == "40% BASIC" || taxAllowance.Name == "RENTAL RECEIPTS" || taxAllowance.Name == "RENTAL-10%BASIC")
                                    {
                                        taxAllowanceModel.Name = "HRA";
                                    }

                                    taxAllowanceModel.IsArchived = false;
                                    taxAllowanceModel.IsMainPage = true;
                                    List<TaxAllowanceSearchOutputModel> taxAllowancesList = _payRollService.GetTaxAllowances(taxAllowanceModel, loggedInContext, new List<ValidationMessage>());
                                    taxAllowance.ParentId = taxAllowancesList[0].TaxAllowanceId;

                                    if (taxAllowance.PayRollComponentId != null)
                                    {
                                        var payRollComponentSearchInputModel = new PayRollComponentSearchInputModel();
                                        payRollComponentSearchInputModel.ComponentName = "Basic";
                                        List<PayRollComponentSearchOutputModel> PayRollComponents = _payRollService.GetPayRollComponents(payRollComponentSearchInputModel, loggedInContext, validationMessages);
                                        taxAllowance.PayRollComponentId = PayRollComponents[0].PayRollComponentId;
                                    }

                                    if (taxAllowance.ComponentId != null)
                                    {
                                        var payRollTemplateSearchInputModel = new PayRollTemplateSearchInputModel();
                                        payRollTemplateSearchInputModel.ComponentName = "#Basic#-#RentalReceiptValue#";
                                        List<ComponentSearchOutPutModel> components = _payRollService.GetComponents(payRollTemplateSearchInputModel, loggedInContext, validationMessages);
                                        taxAllowance.ComponentId = components[0].ComponentId;
                                    }

                                }

                                Guid? taxAllowanceId = _payRollService.UpsertTaxAllowance(new TaxAllowanceUpsertInputModel
                                {
                                    Name = taxAllowance.Name,
                                    TaxAllowanceTypeId = taxAllowance.TaxAllowanceTypeId,
                                    IsPercentage = taxAllowance.IsPercentage,
                                    MaxAmount = taxAllowance.MaxAmount,
                                    PercentageValue = taxAllowance.PercentageValue,
                                    ParentId = taxAllowance.ParentId,
                                    PayRollComponentId = taxAllowance.PayRollComponentId,
                                    ComponentId = taxAllowance.ComponentId,
                                    FromDate = taxAllowance.FromDate,
                                    ToDate = taxAllowance.ToDate,
                                    OnlyEmployeeMaxAmount = taxAllowance.OnlyEmployeeMaxAmount,
                                    MetroMaxPercentage = taxAllowance.MetroMaxPercentage,
                                    LowestAmountOfParentSet = taxAllowance.LowestAmountOfParentSet,
                                    CountryId = countries[0]?.CountryId
                                }, loggedInContext, new List<ValidationMessage>());
                            }

                        }
                        catch(Exception ex)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ImportSystemConfiguration", "SystemConfigurationService ", ex.Message), ex);

                        }

                    }
                }

                if (configuredData.SoftLabelConfigurations != null && configuredData.SoftLabelConfigurations.Count > 0)
                {
                    var softLabelConfigurations = _masterDataManagementService.GetSoftLabelsConfigurationsList(new SoftLabelsSearchInputModel
                    {
                        IsArchived = false
                    }, loggedInContext, new List<ValidationMessage>());
                    foreach (var softLabelConfiguration in configuredData.SoftLabelConfigurations)
                    {
                        Guid? softLabelId = null;
                        if (softLabelConfigurations != null && softLabelConfigurations.Count > 0)
                        {
                            softLabelId = softLabelConfigurations[0].SoftLabelConfigurationId;
                        }

                        Guid? softLabelConfigurationId = _masterDataManagementService.UpsertSoftLabelConfigurations(new UpsertSoftLabelConfigurationsModel
                        {
                            SoftLabelConfigurationId = softLabelId,
                            ProjectLabel = softLabelConfiguration.ProjectLabel,
                            GoalLabel = softLabelConfiguration.GoalLabel,
                            EmployeeLabel = softLabelConfiguration.EmployeeLabel,
                            UserStoryLabel = softLabelConfiguration.UserStoryLabel,
                            DeadlineLabel = softLabelConfiguration.DeadlineLabel,
                            ProjectsLabel = softLabelConfiguration.ProjectsLabel,
                            GoalsLabel = softLabelConfiguration.GoalsLabel,
                            EmployeesLabel = softLabelConfiguration.EmployeesLabel,
                            UserStoriesLabel = softLabelConfiguration.UserStoriesLabel,
                            DeadlinesLabel = softLabelConfiguration.DeadlinesLabel,
                            ScenarioLabel = softLabelConfiguration.ScenarioLabel,
                            ScenariosLabel = softLabelConfiguration.ScenariosLabel,
                            RunLabel = softLabelConfiguration.RunLabel,
                            RunsLabel = softLabelConfiguration.RunsLabel,
                            VersionLabel = softLabelConfiguration.VersionLabel,
                            VersionsLabel = softLabelConfiguration.VersionsLabel,
                            TestReportLabel = softLabelConfiguration.TestReportLabel,
                            TestReportsLabel = softLabelConfiguration.TestReportsLabel,
                            EstimatedTimeLabel = softLabelConfiguration.EstimatedTimeLabel,
                            EstimationsLabel = softLabelConfiguration.EstimationsLabel,
                            EstimationLabel = softLabelConfiguration.EstimationLabel,
                            EstimateLabel = softLabelConfiguration.EstimateLabel,
                            EstimatesLabel = softLabelConfiguration.EstimatesLabel,
                            AuditLabel = softLabelConfiguration.AuditLabel,
                            AuditsLabel = softLabelConfiguration.AuditsLabel,
                            ConductLabel = softLabelConfiguration.ConductLabel,
                            ConductsLabel = softLabelConfiguration.ConductsLabel,
                            ActionLabel = softLabelConfiguration.ActionLabel,
                            ActionsLabel = softLabelConfiguration.ActionsLabel,
                            TimelineLabel = softLabelConfiguration.TimelineLabel,
                            AuditActivityLabel = softLabelConfiguration.AuditActivityLabel,
                            AuditAnalyticsLabel = softLabelConfiguration.AuditAnalyticsLabel,
                            AuditReportLabel = softLabelConfiguration.AuditReportLabel,
                            AuditReportsLabel = softLabelConfiguration.AuditReportsLabel,
                            AuditQuestionLabel = softLabelConfiguration.AuditQuestionLabel,
                            AuditQuestionsLabel = softLabelConfiguration.AuditQuestionsLabel,
                            IsArchived = softLabelConfiguration.IsArchived,
                            TimeStamp = softLabelConfigurations != null ? softLabelConfigurations[0].TimeStamp : null
                        }, loggedInContext, new List<ValidationMessage>());
                    }
                }

                if (configuredData.CustomFields != null && configuredData.CustomFields.Count > 0)
                {
                    var customFields = _customFieldFormRepository.SearchCustomFields(new CustomFieldSearchCriteriaInputModel(), loggedInContext, validationMessages);

                    foreach (var CustomField in configuredData.CustomFields)
                    {
                        var customfieldFindObj = customFields.Find(x => x.FormName == CustomField.FormName);
                        Guid? createdFormId = _customFieldService.UpsertCustomFieldForm(
                                               new UpsertCustomFieldModel
                                               {
                                                   FormName = CustomField.FormName,
                                                   FormJson = CustomField.FormJson,
                                                   FormDataJson = CustomField.FormDataJson,
                                                   ReferenceId = CustomField.ReferenceId,
                                                   ReferenceTypeId = CustomField.ReferenceTypeId,
                                                   ModuleTypeId = CustomField.ModuleTypeId,
                                                   FormKeys = CustomField.FormKeys,
                                                   CustomFieldId = customfieldFindObj?.CustomFieldId,
                                                   TimeStamp = customfieldFindObj?.TimeStamp
                                               }, loggedInContext, new List<ValidationMessage>());

                        if (createdFormId != null)
                        {
                            Guid? createdFormDataId = _customFieldService.UpdateCustomFieldData(new UpsertCustomFieldModel
                            {
                                CustomFieldId = createdFormId,
                                FormDataJson = CustomField.FormDataJson,
                                ReferenceId = CustomField.ReferenceId,
                                ModuleTypeId = CustomField.ModuleTypeId
                            }, loggedInContext, new List<ValidationMessage>());
                        }

                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ImportSystemConfiguration", "SystemConfigurationService ", exception.Message), exception);

            }
            return "success";
        }

        private List<Guid> InsertRoles(string roleNames, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<Guid> rolesList = new List<Guid>();
            var roles = roleNames.Split(',');

           var getAllRoles = _roleService.GetAllRoles(new RolesSearchCriteriaInputModel(), loggedInContext, validationMessages).ToList();

            foreach (var role in roles)
            {
                var roleFindObj = getAllRoles.FindAll(x => x.RoleName == role).ToList();

                if (roleFindObj != null && roleFindObj.Count > 0)
                {
                    foreach (var selectedrole in roleFindObj)
                    {
                        if (selectedrole.RoleId != null)
                        {
                            rolesList.Add((Guid)selectedrole.RoleId);
                        }
                    }
                }
                else
                {
                    var roleModel = new RolesInputModel()
                    {
                        RoleName = role
                    };

                    Guid? roleIdReturned = _roleService.UpsertRole(roleModel, loggedInContext, validationMessages);

                    if (roleIdReturned != null)
                    {
                        rolesList.Add((Guid)roleIdReturned);
                    }
                }
            }
            return rolesList;
        }

        private List<AuditCategoryApiReturnModel> GetHierarchyOfAuditCategoriesAndSubCategories(List<AuditCategoryApiReturnModel> auditCategories, Guid? auditId)
        {
            List<AuditCategoryApiReturnModel> auditCategoriesList = new List<AuditCategoryApiReturnModel>();

            foreach (var category in auditCategories)
            {
                category.AuditComplianceId = auditId;

                if (category.SubAuditCategories != null && category.SubAuditCategories.Count > 0)
                {
                    category.SubAuditCategories =
                        GetHierarchyOfAuditCategoriesAndSubCategories(category.SubAuditCategories, auditId);
                }

                auditCategoriesList.Add(category);
            }

            return auditCategoriesList;
        }

        private List<AuditQuestionsApiReturnModel> GetAuditCategoryQuestionsByAuditCategories(List<AuditCategoryApiReturnModel> auditCategories, LoggedInContext loggedInContext)
        {
            List<AuditQuestionsApiReturnModel> auditCategoryQuestions = new List<AuditQuestionsApiReturnModel>();

            foreach (var auditCategory in auditCategories)
            {
                List<AuditQuestionsApiReturnModel> categoryQuestions = _complianceAuditService.GetAuditQuestions(
                    new AuditQuestionsApiInputModel
                    {
                        AuditCategoryId = auditCategory.AuditCategoryId,
                        IsArchived = false,
                        IsHierarchical = false
                    }, loggedInContext, new List<ValidationMessage>());

                if (categoryQuestions != null && categoryQuestions.Count > 0)
                {
                    foreach (var question in categoryQuestions)
                    {
                        AuditQuestionsApiReturnModel categoryQuestion = _complianceAuditService.GetAuditQuestions(
                            new AuditQuestionsApiInputModel
                            {
                                AuditCategoryId = auditCategory.AuditCategoryId,
                                IsArchived = false,
                                IsHierarchical = false,
                                QuestionId = question.QuestionId
                            }, loggedInContext, new List<ValidationMessage>()).FirstOrDefault();

                        categoryQuestions.FirstOrDefault(x => x.QuestionId == question.QuestionId)
                            .QuestionOptions = categoryQuestion.QuestionOptions;
                    }

                    auditCategoryQuestions.AddRange(categoryQuestions);
                }

                if (auditCategory.SubAuditCategories != null && auditCategory.SubAuditCategories.Count > 0)
                {
                    var subCategoryQuestions =
                        GetAuditCategoryQuestionsByAuditCategories(auditCategory.SubAuditCategories, loggedInContext);

                    if (subCategoryQuestions != null && subCategoryQuestions.Count > 0)
                    {
                        auditCategoryQuestions.AddRange(subCategoryQuestions);
                    }
                }
            }

            return auditCategoryQuestions;
        }

        public void InsertAuditQuestionsByCategories(List<AuditCategoryApiReturnModel> selectedAuditCategories, Guid? auditId, LoggedInContext loggedInContext, List<AuditQuestionsApiReturnModel> auditQuestions, Guid? parentAuditCategoryId)
        {
            foreach (var auditCategory in selectedAuditCategories)
            {
                var auditCategoryId = _complianceAuditService.UpsertAuditCategory(new AuditCategoryApiInputModel
                {
                    AuditCategoryName = auditCategory.AuditCategoryName,
                    IsArchived = auditCategory.IsArchived ?? false,
                    AuditId = auditId,
                    ParentAuditCategoryId = parentAuditCategoryId,
                    AuditCategoryDescription = auditCategory.AuditCategoryDescription
                }, loggedInContext, new List<ValidationMessage>());


                List<AuditQuestionsApiReturnModel> selectedAuditCategoryQuestions = auditQuestions
                    .Where(x => x.AuditCategoryId == auditCategory.AuditCategoryId).ToList();

                if (selectedAuditCategoryQuestions.Count > 0 && auditCategoryId != null)
                {
                    foreach (var auditCategoryQuestion in selectedAuditCategoryQuestions)
                    {
                        auditCategoryQuestion.QuestionOptions.ForEach(x => x.QuestionOptionId = null);

                        QuestionTypeApiReturnModel questionType = new QuestionTypeApiReturnModel();

                        if (!string.IsNullOrWhiteSpace(auditCategoryQuestion.QuestionTypeName))
                        {
                            QuestionTypeApiInputModel questionTypeApiInputModel = new QuestionTypeApiInputModel
                            {
                                QuestionTypeName = auditCategoryQuestion.QuestionTypeName
                            };
                            questionType = _complianceAuditService.GetQuestionTypes(questionTypeApiInputModel, loggedInContext, new List<ValidationMessage>()).FirstOrDefault();
                            if (questionType.QuestionTypeOptions.Count() > 0 && auditCategoryQuestion.QuestionOptions.Count() > 0)
                            {
                                foreach (var questionOption in auditCategoryQuestion.QuestionOptions)
                                {
                                    questionOption.QuestionTypeOptionId = questionType.QuestionTypeOptions
                    .FirstOrDefault(x => x.QuestionTypeOptionName == questionOption.QuestionOptionName)?.QuestionTypeOptionId;
                                }
                            }
                        }
                        _complianceAuditService.UpsertAuditQuestion(
                            new AuditQuestionsApiInputModel
                            {
                                AuditId = auditId,
                                AuditCategoryId = auditCategoryId,
                                QuestionTypeId = questionType != null ? questionType.QuestionTypeId : null,
                                QuestionName = auditCategoryQuestion.QuestionName,
                                QuestionDescription = auditCategoryQuestion.QuestionDescription,
                                IsArchived = auditCategoryQuestion.IsArchived ?? false,
                                IsOriginalQuestionTypeScore = auditCategoryQuestion.IsOriginalQuestionTypeScore,
                                IsQuestionMandatory = auditCategoryQuestion.IsQuestionMandatory,
                                QuestionOptions = auditCategoryQuestion.QuestionOptions,
                                QuestionHint = auditCategoryQuestion.QuestionHint
                            }, loggedInContext,
                            new List<ValidationMessage>());
                    }
                }

                if (auditCategoryId != null && auditCategory.SubAuditCategories != null &&
                    auditCategory.SubAuditCategories.Count > 0)
                {
                    InsertAuditQuestionsByCategories(auditCategory.SubAuditCategories, auditId, loggedInContext,
                        auditQuestions, auditCategoryId);
                }
            }
        }
    }
}