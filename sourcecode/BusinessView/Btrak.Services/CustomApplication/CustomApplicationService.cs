using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CustomApplication;
using Btrak.Models.CustomFields;
using Btrak.Models.Employee;
using Btrak.Models.FormDataServices;
using Btrak.Models.GenericForm;
using Btrak.Models.MasterData;
using Btrak.Models.TradeManagement;
using Btrak.Models.User;
using Btrak.Services.Audit;
using Btrak.Services.CustomFields;
using Btrak.Services.FormDataServices;
using Btrak.Services.GenericForm;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.CustomApplication;
using Btrak.Services.MasterData;
using Btrak.Services.User;
using BTrak.Common;
using CamundaClient;
using CamundaClient.Dto;
using CamundaClient.Requests;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Owin;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Text;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.Configuration;
using System.Windows.Forms;
using System.Xml;
using Uno.Extensions;
using Windows.System;

namespace Btrak.Services.CustomApplication
{
    public class CustomApplicationService : ICustomApplicationService
    {
        private readonly CustomApplicationRepository _customApplicationRepository;
        private readonly IAuditService _auditService;
        private readonly ICustomFieldService _customFiledService;
        private readonly IGenericFormService _genericFormService;
        private readonly RoleRepository _roleRepository;
        private readonly EmployeeRepository _employeeRepository;
        private readonly IDataSourceService _dataSourceService;
        private readonly IGenericFormMasterDataService _genericFormMasterDataService;
        private readonly IUserService _userService;
        public CustomApplicationService(IUserService userService, CustomApplicationRepository customApplicationRepository, IGenericFormService genericFormService, IAuditService auditService, RoleRepository roleRepository, EmployeeRepository employeeRepository, ICustomFieldService customFieldService, IDataSourceService dataSourceService, IGenericFormMasterDataService genericFormMasterDataService)
        {
            _customApplicationRepository = customApplicationRepository;
            _auditService = auditService;
            _genericFormService = genericFormService;
            _roleRepository = roleRepository;
            _employeeRepository = employeeRepository;
            _customFiledService = customFieldService;
            _dataSourceService = dataSourceService;
            _genericFormMasterDataService = genericFormMasterDataService;
            _userService = userService;
        }

        public Guid? UpsertCustomApplication(CustomApplicationUpsertInputModel customApplicationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var formIds = new List<Guid?>();

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomApplication", "CustomApplicationService"));

            LoggingManager.Debug(customApplicationUpsertInputModel.ToString());

            //if (!CustomApplcationValidationHelper.ValidateUpsertCustomApplication(customApplicationUpsertInputModel, loggedInContext, validationMessages))
            //{
            //    return null;
            //}

            if (customApplicationUpsertInputModel.UserList?.Count > 0)
            {
                customApplicationUpsertInputModel.UsersXML = Utilities.GetXmlFromObject(customApplicationUpsertInputModel.UserList);
            }

            if (customApplicationUpsertInputModel.SelectedForms.Count > 0)
            {
                customApplicationUpsertInputModel.SelectedFormsXml = Utilities.GetXmlFromObject(customApplicationUpsertInputModel.SelectedForms);
            }
            if (customApplicationUpsertInputModel.Filters != null && customApplicationUpsertInputModel.Filters.ScenarioSteps != null)
            {
                customApplicationUpsertInputModel.Conditions = customApplicationUpsertInputModel.Filters.ScenarioSteps.ToList();
            }

            customApplicationUpsertInputModel.CustomApplicationId = _customApplicationRepository.UpsertCustomApplication(customApplicationUpsertInputModel, loggedInContext, validationMessages);
            
            var dataSourceKeyModel = new DataSourceKeysConfigurationInputModel();
            dataSourceKeyModel.CustomApplicationId = customApplicationUpsertInputModel.CustomApplicationId;
            
            
            Guid? Id = _dataSourceService.ArchiveDataSourceKeysConfiguration(dataSourceKeyModel, loggedInContext, validationMessages).GetAwaiter().GetResult();

            if (!string.IsNullOrEmpty(customApplicationUpsertInputModel.SelectedKeyIds))
            {
                string[] keyIds = customApplicationUpsertInputModel.SelectedKeyIds.Split(new[] { ',' });

                List<Guid> allKeyIds = keyIds.Select(Guid.Parse).ToList();
               
                customApplicationUpsertInputModel.SelectedKeyIdsList = allKeyIds;

                foreach(var keyId in customApplicationUpsertInputModel.SelectedKeyIdsList)
                {
                    DataSourceKeysConfigurationOutputModel dataSourceKeyOutputModel = _dataSourceService.SearchDataSourceKeysConfiguration(null, null, keyId, customApplicationUpsertInputModel.CustomApplicationId,null, loggedInContext, validationMessages).GetAwaiter().GetResult().dataSourceKeys.FirstOrDefault();
                    var dataSourceKeyDefaultModel = new DataSourceKeysConfigurationInputModel();
                    if (dataSourceKeyOutputModel == null)
                    {
                        dataSourceKeyDefaultModel.CustomApplicationId = customApplicationUpsertInputModel.CustomApplicationId;
                        dataSourceKeyDefaultModel.DataSourceKeyId = keyId;
                        dataSourceKeyDefaultModel.IsDefault = true;

                        Guid? dataSourceConfigurationId = _dataSourceService.CreateDataSourceKeysConfiguration(dataSourceKeyDefaultModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    } else
                    {
                        dataSourceKeyDefaultModel.Id = dataSourceKeyOutputModel.Id;
                        dataSourceKeyDefaultModel.CustomApplicationId = dataSourceKeyOutputModel.CustomApplicationId;
                        dataSourceKeyDefaultModel.DataSourceKeyId = keyId;
                        dataSourceKeyDefaultModel.IsDefault = true;
                        dataSourceKeyDefaultModel.IsPrivate = dataSourceKeyOutputModel.IsPrivate;
                        dataSourceKeyDefaultModel.IsTrendsEnable = dataSourceKeyOutputModel.IsTrendsEnable;
                        dataSourceKeyDefaultModel.IsTag = dataSourceKeyOutputModel.IsTag;

                        Guid? dataSourceConfigurationId = _dataSourceService.UpdateDataSourceKeysConfiguration(dataSourceKeyDefaultModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    }
                }
            }
            if (!string.IsNullOrEmpty(customApplicationUpsertInputModel.SelectedPrivateKeyIds))
            {
                string[] privateKeyIds = customApplicationUpsertInputModel.SelectedPrivateKeyIds.Split(new[] { ',' });

                List<Guid> allPrivateKeyIds = privateKeyIds.Select(Guid.Parse).ToList();

                customApplicationUpsertInputModel.SelectedPrivateKeyIdsList = allPrivateKeyIds;

                foreach (var keyId in customApplicationUpsertInputModel.SelectedPrivateKeyIdsList)
                {
                    DataSourceKeysConfigurationOutputModel dataSourceKeyOutputModel = _dataSourceService.SearchDataSourceKeysConfiguration(null, null, keyId, customApplicationUpsertInputModel.CustomApplicationId,null, loggedInContext, validationMessages).GetAwaiter().GetResult().dataSourceKeys.FirstOrDefault();
                    var dataSourceKeyDefaultModel = new DataSourceKeysConfigurationInputModel();
                    if (dataSourceKeyOutputModel == null)
                    {
                        dataSourceKeyDefaultModel.CustomApplicationId = customApplicationUpsertInputModel.CustomApplicationId;
                        dataSourceKeyDefaultModel.DataSourceKeyId = keyId;
                        dataSourceKeyDefaultModel.IsPrivate = true;

                        Guid? dataSourceConfigurationId = _dataSourceService.CreateDataSourceKeysConfiguration(dataSourceKeyDefaultModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    }
                    else
                    {
                        dataSourceKeyDefaultModel.Id = dataSourceKeyOutputModel.Id;
                        dataSourceKeyDefaultModel.CustomApplicationId = dataSourceKeyOutputModel.CustomApplicationId;
                        dataSourceKeyDefaultModel.DataSourceKeyId = keyId;
                        dataSourceKeyDefaultModel.IsDefault = dataSourceKeyOutputModel.IsDefault;
                        dataSourceKeyDefaultModel.IsPrivate = true;
                        dataSourceKeyDefaultModel.IsTrendsEnable = dataSourceKeyOutputModel.IsTrendsEnable;
                        dataSourceKeyDefaultModel.IsTag = dataSourceKeyOutputModel.IsTag;

                        Guid? dataSourceConfigurationId = _dataSourceService.UpdateDataSourceKeysConfiguration(dataSourceKeyDefaultModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    }
                }
            }
            if (!string.IsNullOrEmpty(customApplicationUpsertInputModel.SelectedTagKeyIds))
            {
                string[] tagKeyIds = customApplicationUpsertInputModel.SelectedTagKeyIds.Split(new[] { ',' });

                List<Guid> allTagKeyIds = tagKeyIds.Select(Guid.Parse).ToList();

                customApplicationUpsertInputModel.SelectedTagKeyIdsList = allTagKeyIds;
                foreach (var keyId in customApplicationUpsertInputModel.SelectedTagKeyIdsList)
                {
                    DataSourceKeysConfigurationOutputModel dataSourceKeyOutputModel = _dataSourceService.SearchDataSourceKeysConfiguration(null, null, keyId, customApplicationUpsertInputModel.CustomApplicationId,null, loggedInContext, validationMessages).GetAwaiter().GetResult().dataSourceKeys.FirstOrDefault();
                    var dataSourceKeyDefaultModel = new DataSourceKeysConfigurationInputModel();
                    if (dataSourceKeyOutputModel == null)
                    {
                        dataSourceKeyDefaultModel.CustomApplicationId = customApplicationUpsertInputModel.CustomApplicationId;
                        dataSourceKeyDefaultModel.DataSourceKeyId = keyId;
                        dataSourceKeyDefaultModel.IsTag = true;

                        Guid? dataSourceConfigurationId = _dataSourceService.CreateDataSourceKeysConfiguration(dataSourceKeyDefaultModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    }
                    else
                    {
                        dataSourceKeyDefaultModel.Id = dataSourceKeyOutputModel.Id;
                        dataSourceKeyDefaultModel.CustomApplicationId = dataSourceKeyOutputModel.CustomApplicationId;
                        dataSourceKeyDefaultModel.DataSourceKeyId = keyId;
                        dataSourceKeyDefaultModel.IsDefault = dataSourceKeyOutputModel.IsDefault;
                        dataSourceKeyDefaultModel.IsPrivate = dataSourceKeyOutputModel.IsPrivate;
                        dataSourceKeyDefaultModel.IsTrendsEnable = dataSourceKeyOutputModel.IsTrendsEnable;
                        dataSourceKeyDefaultModel.IsTag = true;

                        Guid? dataSourceConfigurationId = _dataSourceService.UpdateDataSourceKeysConfiguration(dataSourceKeyDefaultModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    }
                }
            }
            if (!string.IsNullOrEmpty(customApplicationUpsertInputModel.SelectedEnableTrendsKeys))
            {
                string[] trendKeyIds = customApplicationUpsertInputModel.SelectedEnableTrendsKeys.Split(new[] { ',' });

                List<Guid> allTrendKeyIds = trendKeyIds.Select(Guid.Parse).ToList();

                customApplicationUpsertInputModel.SelectedEnableTrendsKeysList = allTrendKeyIds;
                foreach (var keyId in customApplicationUpsertInputModel.SelectedEnableTrendsKeysList)
                {
                    DataSourceKeysConfigurationOutputModel dataSourceKeyOutputModel = _dataSourceService.SearchDataSourceKeysConfiguration(null, null, keyId, customApplicationUpsertInputModel.CustomApplicationId,null, loggedInContext, validationMessages).GetAwaiter().GetResult().dataSourceKeys.FirstOrDefault();
                    var dataSourceKeyDefaultModel = new DataSourceKeysConfigurationInputModel();
                    if (dataSourceKeyOutputModel == null)
                    {
                        dataSourceKeyDefaultModel.CustomApplicationId = customApplicationUpsertInputModel.CustomApplicationId;
                        dataSourceKeyDefaultModel.DataSourceKeyId = keyId;
                        dataSourceKeyDefaultModel.IsTrendsEnable = true;

                        Guid? dataSourceConfigurationId = _dataSourceService.CreateDataSourceKeysConfiguration(dataSourceKeyDefaultModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    }
                    else
                    {
                        dataSourceKeyDefaultModel.Id = dataSourceKeyOutputModel.Id;
                        dataSourceKeyDefaultModel.CustomApplicationId = dataSourceKeyOutputModel.CustomApplicationId;
                        dataSourceKeyDefaultModel.DataSourceKeyId = keyId;
                        dataSourceKeyDefaultModel.IsDefault = dataSourceKeyOutputModel.IsDefault;
                        dataSourceKeyDefaultModel.IsPrivate = dataSourceKeyOutputModel.IsPrivate;
                        dataSourceKeyDefaultModel.IsTrendsEnable = true;
                        dataSourceKeyDefaultModel.IsTag = dataSourceKeyOutputModel.IsTag;

                        Guid? dataSourceConfigurationId = _dataSourceService.UpdateDataSourceKeysConfiguration(dataSourceKeyDefaultModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    }
                }
            }
            _auditService.SaveAudit(AppCommandConstants.UpsertCustomApplicationCommandId, customApplicationUpsertInputModel, loggedInContext);

            return customApplicationUpsertInputModel.CustomApplicationId;
        }

        public List<CustomApplicationSearchOutputModel> GetCustomApplication(CustomApplicationSearchInputModel customApplicationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplication", "CustomApplicationService"));

            LoggingManager.Debug(customApplicationSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetCustomApplicationCommandId, customApplicationSearchInputModel, loggedInContext);

            List<CustomApplicationSearchOutputModel> customApplicationForms = new List<CustomApplicationSearchOutputModel>();

            string customApplicationList = _customApplicationRepository.GetCustomApplication(customApplicationSearchInputModel, loggedInContext, validationMessages);
            var user = new UserOutputModel();
            if (customApplicationSearchInputModel.CustomApplicationId != null && customApplicationSearchInputModel.CustomApplicationId != Guid.Empty)
            {
                user = _userService.GetUserById(loggedInContext.LoggedInUserId, true, loggedInContext, validationMessages);
            }

            if (!string.IsNullOrEmpty(customApplicationList))
            {
                customApplicationForms = JsonConvert.DeserializeObject<List<CustomApplicationSearchOutputModel>>(customApplicationList);
            }
            var genericFormTypeSearchInputModel = new GetGenericFormTypesSearchCriteriaInputModel();
            List<GetGenericFormTypesOutputModel> formTypes = new List<GetGenericFormTypesOutputModel>();
            if (customApplicationSearchInputModel.IsList)
            {
                genericFormTypeSearchInputModel.IsArchived = false;
                formTypes = _genericFormMasterDataService.GetGenericFormTypes(genericFormTypeSearchInputModel, loggedInContext, validationMessages);
            }
            foreach (var application in customApplicationForms)
            {
                var dataSource = _dataSourceService.SearchDataSource(application.FormId, null, null, false, loggedInContext, validationMessages, customApplicationSearchInputModel.CompanyId.ToString(), customApplicationSearchInputModel.IsCompanyBased).GetAwaiter().GetResult()?.FirstOrDefault();
                if (customApplicationSearchInputModel.CustomApplicationId != null && customApplicationSearchInputModel.CustomApplicationId != Guid.Empty)
                {
                    var roleIds = user?.RoleIds?.Split(',');
                    if (dataSource != null)
                    {
                        if (dataSource.ViewFormRoleIds != null && dataSource.ViewFormRoleIds.Length > 0)
                        {
                            bool result = dataSource.ViewFormRoleIds.Any(el => roleIds.Contains(el.ToString()));
                            application.ViewForm = result == true ? true : false;
                            application.ViewFormRoleIds = dataSource.ViewFormRoleIds;
                        }
                        if (dataSource.EditFormRoleIds != null && dataSource.EditFormRoleIds.Length > 0)
                        {
                            bool result = dataSource.EditFormRoleIds.Any(el => roleIds.Contains(el.ToString()));
                            application.EditForm = result == true ? true : false;
                            application.EditFormRoleIds = dataSource.EditFormRoleIds;
                        }
                        if (dataSource.EditFormRoleIds == null || (dataSource.EditFormRoleIds != null && dataSource.EditFormRoleIds.Length == 0))
                        {
                            application.EditForm = true;
                        }
                    }
                }
                if (dataSource != null)
                {
                    if (customApplicationSearchInputModel.IsList)
                    {
                        DataSourceOutputModel dataSourceOutputModel = new DataSourceOutputModel();
                        var jsonData = JsonConvert.DeserializeObject<DataSourceOutputModel>(JsonConvert.SerializeObject(JObject.Parse(dataSource.Fields.ToString())));
                        application.FormTypeId = jsonData.FormTypeId;
                        if (application.FormTypeId != null)
                        {
                            if (formTypes != null)
                            {
                                application.FormTypeName = formTypes.Find(formType => formType.FormTypeId == application.FormTypeId).FormTypeName;
                            }
                        }
                    }
                    application.FormName = dataSource.Name;
                    application.Fields = dataSource.Fields;
                    application.FormJson = dataSource.Fields.ToString();
                    application.DataSourceId = application.FormId;
                }

            }

            return customApplicationForms;
        }
        public CustomApplicationSearchOutputModel GetCustomApplicationKeysSelected(CustomApplicationSearchInputModel customApplicationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplication", "CustomApplicationService"));

            LoggingManager.Debug(customApplicationSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetCustomApplicationCommandId, customApplicationSearchInputModel, loggedInContext);

            CustomApplicationSearchOutputModel customApplications = new CustomApplicationSearchOutputModel();

            DataSourceKeysConfiguration dataSourceKeys = _dataSourceService.SearchDataSourceKeysConfiguration(null, null, null, customApplicationSearchInputModel.CustomApplicationId, null, loggedInContext, validationMessages).GetAwaiter().GetResult();
                if (dataSourceKeys != null)
                {
                if (dataSourceKeys != null && dataSourceKeys.dataSourceKeys.Count > 0)
                {
                    customApplications.SelectedEnableTrendsKeys = dataSourceKeys.SelectedEnableTrendsKeys;
                    customApplications.SelectedKeyIds = dataSourceKeys.SelectedKeyIds;
                    customApplications.SelectedPrivateKeyIds = dataSourceKeys.SelectedPrivateKeyIds;
                    customApplications.SelectedTagKeyIds = dataSourceKeys.SelectedTagKeyIds;
                }
                    //customApplications.GenericFormIdsJson = dataSourceKeys.Select(e => new GenericFormJsonModel
                    //{
                    //    GenericFormKeyId = e.DataSourceKeyId,
                    //    IsDefault = e.IsDefault,
                    //    IsTag = e.IsTag,
                    //    IsTrendsEnable = e.IsTrendsEnable,
                    //    IsPrivate = e.IsPrivate
                    //}).ToList();
                    //var selectedKeyIds = customApplications.GenericFormIdsJson.Where(x => x.IsDefault == true).Select(x => x.GenericFormKeyId).ToList();
                    //if (selectedKeyIds.Count > 0)
                    //{
                    //customApplications.SelectedKeyIds = string.Join(",", selectedKeyIds);
                    //}
                    //var selectedPrivateKeyIds = customApplications.GenericFormIdsJson.Where(x => x.IsPrivate == true).Select(x => x.GenericFormKeyId).ToList();
                    //if (selectedPrivateKeyIds.Count > 0)
                    //{
                    //customApplications.SelectedPrivateKeyIds = string.Join(",", selectedPrivateKeyIds);
                    //}
                    //var selectedTagKeyIds = customApplications.GenericFormIdsJson.Where(x => x.IsTag == true).Select(x => x.GenericFormKeyId).ToList();
                    //if (selectedTagKeyIds.Count > 0)
                    //{
                    //customApplications.SelectedTagKeyIds = string.Join(",", selectedTagKeyIds);
                    //}
                    //var selectedTrendEnableKeyIds = customApplications.GenericFormIdsJson.Where(x => x.IsTrendsEnable == true).Select(x => x.GenericFormKeyId).ToList();
                    //if (selectedTrendEnableKeyIds.Count > 0)
                    //{
                    //customApplications.SelectedEnableTrendsKeys = string.Join(",", selectedTrendEnableKeyIds);
                    //}
                }
                else
                {
                    List<DataSourceKeysOutputModel> dataSourcekeysList = _dataSourceService.SearchDataSourceKeys(null, customApplications.FormId,null, null, null,null, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    if (dataSourcekeysList != null && dataSourcekeysList.Count > 0)
                    {
                    customApplications.GenericFormIdsJson = new List<GenericFormJsonModel>();

                    }
                }

            return customApplications;
        }

        public CustomApplicationSearchOutputModel GetPublicCustomApplicationById(CustomApplicationSearchInputModel customApplication, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplication", "CustomApplicationService"));

            var customApplications = _customApplicationRepository.GetPublicCustomApplicationById(customApplication, validationMessages);

            //foreach (var application in customApplications)
            //{
            var application = customApplications;
            List<DataSourceKeysConfigurationOutputModel> dataSourceKeys = _dataSourceService.SearchDataSourceKeysConfiguration(null, null, null, application.CustomApplicationId,null, loggedInContext, validationMessages).GetAwaiter().GetResult().dataSourceKeys;
            if (dataSourceKeys != null && dataSourceKeys.Count > 0)
            {
                var formDetails = dataSourceKeys.Select(e => new GenericFormApiReturnModel
                {
                    FormName = e.FormName,
                    Fields = JsonConvert.SerializeObject(e.Fields),
                    FormTypeId = e.Fields.FormTypeId,
                    FormJson = JsonConvert.SerializeObject(e.Fields)
                }).FirstOrDefault();
                if (formDetails != null)
                {
                    application.FormName = formDetails.FormName;
                    application.FormTypeId = formDetails.FormTypeId;
                    application.Fields = formDetails.Fields;
                    application.FormJson = formDetails.FormJson;
                    application.DataSourceId = application.FormId;
                }
                if (application.FormTypeId != null)
                {
                    var genericFormTypeSearchInputModel = new GetGenericFormTypesSearchCriteriaInputModel();
                    genericFormTypeSearchInputModel.FormTypeId = application.FormTypeId;
                    genericFormTypeSearchInputModel.IsArchived = false;
                    GetGenericFormTypesOutputModel formTypes = _genericFormMasterDataService.GetGenericFormTypesAnonymous(genericFormTypeSearchInputModel, validationMessages).FirstOrDefault();
                    if (formTypes != null)
                    {
                        application.FormTypeName = formTypes.FormTypeName;
                    }
                }
                application.GenericFormIdsJson = dataSourceKeys.Select(e => new GenericFormJsonModel
                {
                    GenericFormKeyId = e.DataSourceKeyId,
                    IsDefault = e.IsDefault,
                    IsTag = e.IsTag,
                    IsTrendsEnable = e.IsTrendsEnable,
                    IsPrivate = e.IsPrivate
                }).ToList();
                var selectedKeyIds = application.GenericFormIdsJson.Where(x => x.IsDefault == true).Select(x => x.GenericFormKeyId).ToList();
                if (selectedKeyIds.Count > 0)
                {
                    application.SelectedKeyIds = string.Join(",", selectedKeyIds);
                }
                var selectedPrivateKeyIds = application.GenericFormIdsJson.Where(x => x.IsPrivate == true).Select(x => x.GenericFormKeyId).ToList();
                if (selectedPrivateKeyIds.Count > 0)
                {
                    application.SelectedPrivateKeyIds = string.Join(",", selectedPrivateKeyIds);
                }
                var selectedTagKeyIds = application.GenericFormIdsJson.Where(x => x.IsTag == true).Select(x => x.GenericFormKeyId).ToList();
                if (selectedTagKeyIds.Count > 0)
                {
                    application.SelectedTagKeyIds = string.Join(",", selectedTagKeyIds);
                }
                var selectedTrendEnableKeyIds = application.GenericFormIdsJson.Where(x => x.IsTrendsEnable == true).Select(x => x.GenericFormKeyId).ToList();
                if (selectedTrendEnableKeyIds.Count > 0)
                {
                    application.SelectedEnableTrendsKeys = string.Join(",", selectedTrendEnableKeyIds);
                }
            }
            else
            {
                List<DataSourceKeysOutputModel> dataSourcekeysList = _dataSourceService.SearchDataSourceKeys(null, application.FormId, null,null,null,null, loggedInContext, validationMessages).GetAwaiter().GetResult();
                if (dataSourcekeysList.Count > 0)
                {
                    var formDetails = dataSourcekeysList.Select(e => new GenericFormApiReturnModel
                    {
                        FormName = e.FormName,
                        Fields = JsonConvert.SerializeObject(e.Fields),
                        FormTypeId = e.Fields.FormTypeId,
                        FormJson = JsonConvert.SerializeObject(e.Fields)
                    }).FirstOrDefault();
                    if (formDetails != null)
                    {
                        application.FormName = formDetails.FormName;
                        application.FormTypeId = formDetails.FormTypeId;
                        application.Fields = formDetails.Fields;
                        application.FormJson = formDetails.FormJson;
                        application.DataSourceId = application.FormId;
                    }
                    if (application.FormTypeId != null)
                    {
                        var genericFormTypeSearchInputModel = new GetGenericFormTypesSearchCriteriaInputModel();
                        genericFormTypeSearchInputModel.FormTypeId = application.FormTypeId;
                        genericFormTypeSearchInputModel.IsArchived = false;
                        GetGenericFormTypesOutputModel formTypes = _genericFormMasterDataService.GetGenericFormTypesAnonymous(genericFormTypeSearchInputModel, validationMessages).FirstOrDefault();
                        if (formTypes != null)
                        {
                            application.FormTypeName = formTypes.FormTypeName;
                        }
                    }
                    application.GenericFormIdsJson = new List<GenericFormJsonModel>();

                }
            }
            //}

            //return customApplications[0];
            return application;
        }


        public Guid? UpsertCustomApplicationKeys(CustomApplicationKeyUpsertInputModel customApplicationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomApplicationKeys", "CustomApplicationService"));

            LoggingManager.Debug(customApplicationUpsertInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            customApplicationUpsertInputModel.CustomApplicationKeyId = _customApplicationRepository.UpsertCustomApplicationKeys(customApplicationUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertCustomApplicationKeyCommandId, customApplicationUpsertInputModel, loggedInContext);

            return customApplicationUpsertInputModel.CustomApplicationKeyId;
        }

        public List<CustomApplicationKeySearchOutputModel> GetCustomApplicationKeys(CustomApplicationKeySearchInputModel customApplicationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplicationKeys", "CustomApplicationService"));

            LoggingManager.Debug(customApplicationSearchInputModel.ToString());

            List<CustomApplicationKeySearchOutputModel> customApplicationKeys = new List<CustomApplicationKeySearchOutputModel>();

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetCustomApplicationKeyCommandId, customApplicationSearchInputModel, loggedInContext);

            List<DataSourceKeysConfigurationOutputModel> dataSourceKeys = _dataSourceService.SearchDataSourceKeysConfiguration(null, null, null, customApplicationSearchInputModel.CustomApplicationId,true, loggedInContext, validationMessages).GetAwaiter().GetResult().dataSourceKeys;
            if (dataSourceKeys.Count > 0)
            {
                customApplicationKeys = dataSourceKeys.Select(e => new CustomApplicationKeySearchOutputModel
                {
                    GenericFormKeyId = e.DataSourceKeyId,
                    IsDefault = e.IsDefault,
                    IsTag = e.IsTag,
                    IsTrendsEnable = e.IsTrendsEnable,
                    IsPrivate = e.IsPrivate,
                    Key = e.Key,
                    CustomApplicationId = e.CustomApplicationId,
                    CustomApplicationKeyId = e.Id,
                }).ToList();
            }
            return customApplicationKeys;
        }

        public Guid? UpsertCustomApplicationWorkflow(CustomApplicationWorkflowUpsertInputModel customApplicationWorkflowUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomApplicationWorkflow", "CustomApplicationService"));

            XmlDocument document = new XmlDocument();

            if (customApplicationWorkflowUpsertInputModel.WorkflowXml != null && customApplicationWorkflowUpsertInputModel.IsPublished == true)
            {
                document.LoadXml(customApplicationWorkflowUpsertInputModel.WorkflowXml);

                var workflowName = !string.IsNullOrEmpty(customApplicationWorkflowUpsertInputModel.WorkflowName) ? customApplicationWorkflowUpsertInputModel.CustomApplicationId +"-"+ customApplicationWorkflowUpsertInputModel.WorkflowName : document.GetElementsByTagName("bpmn:definitions")[0]?.ChildNodes[0]?.Attributes["id"]?.InnerText.Trim();
               
                List<object> files = new List<object>();

                string fileExtension = customApplicationWorkflowUpsertInputModel.WorkflowFileName;

                byte[] array = Encoding.ASCII.GetBytes(customApplicationWorkflowUpsertInputModel.WorkflowXml);
                
                FileParameter filePraParameter = new CamundaClient.Dto.FileParameter(array, workflowName + fileExtension);
                files.Add((object)filePraParameter);
               
                var result = Deploy(workflowName, files, loggedInContext.CompanyGuid.ToString());
            }
            customApplicationWorkflowUpsertInputModel.CustomApplicationId = _customApplicationRepository.UpsertCustomApplicationWorkflow(customApplicationWorkflowUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertCustomApplicationWorkflowCommandId, customApplicationWorkflowUpsertInputModel, loggedInContext);

            return customApplicationWorkflowUpsertInputModel.CustomApplicationWorkflowId;
        }

        public List<CustomApplicationWorkflowSearchOutputModel> GetCustomApplicationWorkflow(CustomApplicationWorkflowUpsertInputModel customApplicationWorkflowSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplicationWorkflows", "CustomApplicationService"));

            LoggingManager.Debug(customApplicationWorkflowSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertCustomApplicationWorkflowCommandId, customApplicationWorkflowSearchInputModel, loggedInContext);

            List<CustomApplicationWorkflowSearchOutputModel> customApplicationWorkflow = _customApplicationRepository.GetCustomApplicationWorkflow(customApplicationWorkflowSearchInputModel, loggedInContext, validationMessages);
            return customApplicationWorkflow;
        }

        public List<CustomApplicationWorkflowTypeReturnModel> GetCustomApplicationWorkflowTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplicationWorkflowTypes", "CustomApplicationService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<CustomApplicationWorkflowTypeReturnModel> customApplicationWorkflowTypes = _customApplicationRepository.GetCustomApplicationWorkflowTypes(loggedInContext, validationMessages);
            return customApplicationWorkflowTypes;
        }

        public FormImportsRawModel ImportCustomApplicationFromExcel(Guid applicationId, string formName, SpreadsheetDocument spreadSheetDocument, string fileName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            FormImportsRawModel formImportsRawModel = new FormImportsRawModel()
            {
                ApplicationId = applicationId
            };

            formImportsRawModel.Sheets = new List<ExcelSheetRawModel>();

            formImportsRawModel.Forms = new List<AppFormRawModel>();

            CustomApplicationSearchInputModel customApplicationSearchInputModel = new CustomApplicationSearchInputModel()
            {
                CustomApplicationId = applicationId
            };

            var applicationData = GetCustomApplication(customApplicationSearchInputModel, loggedInContext, validationMessages);

            CustomFieldMappingInputModel customFieldMappingInputModel = new CustomFieldMappingInputModel()
            {
                CustomApplicationId = applicationId
            };

            var mappingsList = _customApplicationRepository.GetCustomFieldMapping(customFieldMappingInputModel, loggedInContext, validationMessages);

            formImportsRawModel.MappingsList = mappingsList;

            CustomFieldMappingApiOutputModel matchedMapping = null;

            foreach (var mapping in mappingsList)
            {
                if (Regex.Match(fileName, mapping.MappingName).Success)
                {
                    matchedMapping = mapping;
                    break;
                }
            }

            if (matchedMapping != null)
            {
                formImportsRawModel.MappingName = matchedMapping.MappingName;

                formImportsRawModel.SelectedMappingId = matchedMapping.MappingId;

                formImportsRawModel.MappingJson = matchedMapping.MappingJson;
            }

            formImportsRawModel.CustomApplicationName = applicationData.First()?.CustomApplicationName;

            foreach (var form in applicationData)
            {
                GenericFormKeySearchInputModel genericFormKeySearchInputModel = new GenericFormKeySearchInputModel()
                {
                    GenericFormId = form.FormId
                };

                var genericFormKeys = _genericFormService.GetGenericFormKey(genericFormKeySearchInputModel, loggedInContext, validationMessages).ToList();

                if(form?.FormName == null && form?.FormId != null)
                {
                   form.FormName = _dataSourceService.SearchDataSource(form.FormId, null, null, null, loggedInContext, validationMessages).GetAwaiter().GetResult().FirstOrDefault()?.Name;
                }

                AppFormRawModel formRawData = new AppFormRawModel()
                {
                    FormId = form.FormId,
                    FormName = form.FormName,
                    LabelKeyPairs = genericFormKeys.Select(p => new FormPair()
                    {
                        Key = p.Key,
                        Label = p.Label,
                        Type = p.Type,
                        DecimalLimit = p?.DecimalLimit
                    }).ToList()
                };

                formImportsRawModel.Forms.Add(formRawData);
            }

            WorkbookPart workbookPart = spreadSheetDocument.WorkbookPart;
            List<Sheet> sheets = spreadSheetDocument.WorkbookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>().ToList();

            for (int k = 0; k < sheets.ToList().Count; k++)
            {
                ExcelSheetRawModel excelSheetRawModel = new ExcelSheetRawModel();
                string relationshipId = sheets[k].Id.Value;
                WorksheetPart worksheetPart = (WorksheetPart)spreadSheetDocument.WorkbookPart.GetPartById(relationshipId);
                Worksheet workSheet = worksheetPart.Worksheet;
                SheetData sheetData = workSheet.GetFirstChild<SheetData>();
                 IEnumerable<Row> rows = sheetData.Descendants<Row>();
                var rowCount = rows.Count();
                var sheetHeaders = new List<string>();

                for (int i = 0; i < rows.First().Descendants<Cell>().Count(); i++)
                {
                    var header = GetCellValue(spreadSheetDocument, rows.First().Descendants<Cell>().ElementAt(i));

                    sheetHeaders.Add(header);
                }

                excelSheetRawModel.ExcelHeaders = sheetHeaders.Where(p => p != null).ToList();

                var headerRow = true;

                var formRecords = new List<FormData>();

                var sheetName = formName.Trim();

                if(string.IsNullOrEmpty(sheetName) || string.IsNullOrWhiteSpace(sheetName))
                {
                    sheetName = sheets[k].Name.ToString().Trim();
                }

                var formKeys = formImportsRawModel?.Forms?.Where(t => (t?.FormName != null && t?.FormName == sheetName))?.FirstOrDefault()?.LabelKeyPairs?.ToList();

                foreach (Row row in rows)
                {

                    if (!headerRow)
                    {
                        IEnumerable<Cell> cells = SpreadsheetHelper.GetRowCells(row);
                        var keyValuePairs = new List<ExcelPair>();
                        var cellsCount = row.Descendants<Cell>().Count();
                        var i = -1;
                        foreach (Cell cell in cells)
                        {
                            i++;
                            var value = GetCellValue(spreadSheetDocument, cell);

                            if(value != null)
                            {
                                var labelName = string.Empty;
                                var keyName = string.Empty;
                                var headerName = sheetHeaders[i];
                                if(!string.IsNullOrWhiteSpace(headerName) && !string.IsNullOrEmpty(headerName))
                                {
                                    int start = headerName.IndexOf("[") + 1;
                                    int length = headerName.IndexOf("]") - start;
                                    keyName = headerName.Substring(start, length);

                                    var paranthesisStartIndex = headerName.IndexOf("[");
                                    labelName = headerName.Substring(0, paranthesisStartIndex);
                                }
                                
                            int? decimalLimit = formKeys?.Where(t => t.Label?.ToLower() == labelName?.ToLower() && t.Key?.ToLower() == keyName?.ToLower())?.FirstOrDefault()?.DecimalLimit;
                        
                            double cellValue = 0;

                            bool successfullyParsed = double.TryParse(value, out cellValue);

                            string type = formKeys?.Where(t => t.Label?.ToLower() == headerName?.ToLower() && t.Key?.ToLower() == keyName?.ToLower())?.FirstOrDefault()?.Type;

                            if(type == "number"&& cellValue.ToString() != value && successfullyParsed == false && formKeys != null && type != null )
                            {
                                validationMessages.Add(new ValidationMessage { 
                                ValidationMessaage ="Data not matching with key type" 
                                });
                            }

                            ExcelPair tempRow = new ExcelPair
                            {
                                Key = keyName,
                                Header = labelName,
                                Value = cellValue == 0 || decimalLimit == null || value == null ? value : Math.Round(cellValue, (int)(decimalLimit)).ToString()
                            };

                            keyValuePairs.Add(tempRow);
                            }
                            
                        }

                        if (keyValuePairs.Count > 0)
                        {
                            var formRecord = new FormData()
                            {
                                FormKeyValuePairs = keyValuePairs
                            };

                            formRecords.Add(formRecord);
                        }
                    }
                    else
                    {
                        headerRow = false;
                    }
                }

                excelSheetRawModel.SheetData = formRecords;

                excelSheetRawModel.ApplicationId = applicationId;

                excelSheetRawModel.SheetName = sheetName;

                excelSheetRawModel.ImportValidations = new List<GenericFormImportReturnModel>();

                formImportsRawModel.Sheets.Add(excelSheetRawModel);
            }

            return formImportsRawModel;
        }

        public bool ImportVerifiedApplication(ValidatedSheetsImportModel validatedSheets, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<sheets> sheets = new List<sheets>();
            var formId = validatedSheets.FormImports.Where(p => p.SelectedFormId != null).FirstOrDefault().SelectedFormId;
            GenericFormKeySearchInputModel genericFormKeySearchInputModel = new GenericFormKeySearchInputModel()
            {
                GenericFormId = formId,
            };

            var genericFormKeys = _genericFormService.GetGenericFormKey(genericFormKeySearchInputModel, loggedInContext, validationMessages).ToList();

            foreach (var formImport in validatedSheets.FormImports.Where(p => p.SelectedFormId != null).ToList())
            {
                sheets sheet = new sheets
                {
                    sheetName = formImport.SheetName,
                    formId = formImport.SelectedFormId,
                    formHeaders = new List<keyvalues>()
                };

                var formjson = new List<string>();

                int matchedColumnsCount = formImport.ImportValidations.Where(p => p.IsItGoodToImport).ToList().Count;

                //get user details
                var user = new UserOutputModel();
               
                user = _userService.GetUserById(loggedInContext.LoggedInUserId, true, loggedInContext, validationMessages);

                

                foreach (var row in formImport.SheetData)
                {
                    keyvalues keyvalues = new keyvalues();

                    var jsonData = "{";

                    for (var i = 0; i < row.FormKeyValuePairs.Count; i++)
                    {
                        var Data = row.FormKeyValuePairs[i];

                        if (formImport.ImportValidations.FirstOrDefault(p => p.FormHeader != null && p.FormHeader != "" && p.FormHeader.ToLower() == Data.Key.ToLower()) != null && formImport.ImportValidations.FirstOrDefault(p => p.FormHeader != null && p.FormHeader != "" && p.FormHeader.ToLower() == Data.Key.ToLower()).IsItGoodToImport)
                        {
                            if (jsonData != "{")
                            {
                                jsonData = jsonData + " , ";
                            }

                            var value = string.IsNullOrEmpty(Data.Value) ? "" : Data.Value;

                            var key = formImport.ImportValidations.FirstOrDefault(p => p.FormHeader != null && p.FormHeader != "" && p.FormHeader.ToLower() == Data.Key.ToLower());

                            var genericFormKey = genericFormKeys.Count > 0 ? genericFormKeys.Where(x => x.Key == key?.FormHeader).FirstOrDefault() : null;

                            if (!string.IsNullOrWhiteSpace(genericFormKey?.Type) && genericFormKey?.Type == "datetime")
                            {
                                DateTime parsedDate;
                                CultureInfo provider = CultureInfo.InvariantCulture;
                                if(genericFormKey?.Format == "MMM-yyyy")
                                {
                                    genericFormKey.Format = "dd-MM-yyyy";
                                    DateTime dt = Convert.ToDateTime(value).AddDays(0.0);
                                    value = dt.ToString("dd-MM-yyyy");
                                }
                                if (DateTime.TryParseExact(value, genericFormKey?.Format, System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out parsedDate))
                                {
                                    Console.WriteLine("Parsed date: " + parsedDate);
                                }
                                else
                                {
                                    Console.WriteLine("Failed to parse date.");
                                }
                                
                                value = parsedDate != null ? parsedDate.ToString("yyyy-MM-ddTHH:mm:ss.fffffffK") : "";
                            }

                            jsonData = jsonData + (char)34 + key?.FormHeader + (char)34 + ":" + (char)34 + value + (char)34;

                            sheet.formHeaders.Add(new keyvalues
                            {
                                formHeader = key?.FormHeader,
                                excelHeader = key?.ExcelHeader,
                                isItGoodToImport = key?.IsItGoodToImport == null ? false : key?.IsItGoodToImport == false ? false : true
                            });
                        }
                    }

                    jsonData = jsonData + ",\"submit" + (char)34 + ":true";
                    DateTime createdDate = DateTime.Now;
                    var createdDateString = createdDate.ToString("dd MMM yyyy hh:mm tt");

                    jsonData = jsonData + ",\"Created Date" + (char)34 + ":" + (char)34 + createdDateString +(char)34 ;

                    if(user != null)
                    {
                        jsonData = jsonData + ",\"Created User" + (char)34 + ":" + (char)34 + user?.FullName + (char)34;
                        jsonData = jsonData + ",\"createdBy" + (char)34 + ":" + (char)34 + user?.Id  +(char)34 + "}";
                    }
               
                    if ((jsonData != "{,\"submit\":true") && (jsonData != "{,\"Created User\":"  + (char)34 + user?.FullName + (char)34) && (jsonData != "{,\"createdBy\":" + (char)34 + user?.Id + (char)34 + "}") && (jsonData != "{,\"Created Date\":" + (char)34 + createdDateString +(char)34))
                    {
                        formjson.Add(jsonData);
                    }
                }

                foreach (var submittedReport in formjson)
                {
                    GenericFormSubmittedUpsertInputModel genericFormSubmittedUpsertModel = new GenericFormSubmittedUpsertInputModel()
                    {
                        CustomApplicationId = formImport.ApplicationId,
                        FormJson = submittedReport,
                        FormId = formImport.SelectedFormId,
                        DataSourceId = formImport.SelectedFormId,
                        Status  = "Submitted"
                    };
                    _genericFormService.UpsertGenricFormSubmitted(genericFormSubmittedUpsertModel, loggedInContext, validationMessages);
                }


                sheets.Add(sheet);
            }

            if (!string.IsNullOrEmpty(validatedSheets.MappingName) || (validatedSheets.SelectedMappingId != null && validatedSheets.TimeStamp != null))
            {
                CustomFieldMappingInputModel fieldMappingInputModel = new CustomFieldMappingInputModel()
                {
                    MappingId = validatedSheets.SelectedMappingId,
                    MappingName = validatedSheets.MappingName,
                    MappingJson = JsonConvert.SerializeObject(sheets),
                    CustomApplicationId = validatedSheets.CustomApplicationId,
                    TimeStamp = validatedSheets.TimeStamp
                };

                _customApplicationRepository.UpsertCustomFieldMapping(fieldMappingInputModel, loggedInContext, validationMessages);
            }

            return true;
        }

        private string GetCellValue(SpreadsheetDocument document, Cell cell)
        {
            SharedStringTablePart stringTablePart = document.WorkbookPart.SharedStringTablePart;
            string value = cell.CellValue?.InnerXml;

            if(string.IsNullOrWhiteSpace(value) || string.IsNullOrEmpty(value))
            {
                return string.Empty;
            }

            if (cell.DataType != null && cell.DataType.Value == CellValues.SharedString)
            {
                return stringTablePart.SharedStringTable.ChildElements[Int32.Parse(value)].InnerText;
            }


            if (cell.StyleIndex != null)
            {
                var cellFormat = document.WorkbookPart.WorkbookStylesPart.Stylesheet.CellFormats.ChildElements[
                    int.Parse(cell.StyleIndex.InnerText)] as CellFormat;

                if (cellFormat != null && cellFormat.NumberFormatId > 13)
                { 
                    var dateFormat = GetDateTimeFormat(cellFormat.NumberFormatId);
                    if (!string.IsNullOrEmpty(dateFormat))
                    {
                        if (!string.IsNullOrEmpty(value))
                        {
                            if (double.TryParse(value, out var cellDouble))
                            {
                                var theDate = DateTime.FromOADate(cellDouble);
                                value = theDate.ToString(dateFormat);
                            }
                        }
                    }
                }
            }

            return value;
        }

        private readonly Dictionary<uint, string> DateFormatDictionary = new Dictionary<uint, string>()
        {
            [14] = "dd-MMM-yyyy",
            [15] = "d-MMM-yy",
            [16] = "d-MMM",
            [17] = "MMM-yy",
            [18] = "h:mm AM/PM",
            [19] = "h:mm:ss AM/PM",
            [20] = "h:mm",
            [21] = "h:mm:ss",
            [22] = "M/d/yy h:mm",
            [30] = "M/d/yy",
            [34] = "yyyy-MM-dd",
            [45] = "mm:ss",
            [46] = "[h]:mm:ss",
            [47] = "mmss.0",
            [51] = "MM-dd",
            [52] = "yyyy-MM-dd",
            [53] = "yyyy-MM-dd",
            [55] = "yyyy-MM-dd",
            [56] = "yyyy-MM-dd",
            [58] = "MM-dd",
            [165] = "M/d/yy",
            [166] = "dd MMMM yyyy",
            [167] = "dd/MM/yyyy",
            [168] = "dd/MM/yy",
            [169] = "d.M.yy",
            [170] = "yyyy-MM-dd",
            [171] = "dd MMMM yyyy",
            [172] = "d MMMM yyyy",
            [173] = "M/d",
            [174] = "M/d/yy",
            [175] = "MM/dd/yy",
            [176] = "d-MMM",
            [177] = "d-MMM-yy",
            [178] = "dd-MMM-yy",
            [179] = "MMM-yy",
            [180] = "MMMM-yy",
            [181] = "MMMM d, yyyy",
            [182] = "M/d/yy hh:mm t",
            [183] = "M/d/y HH:mm",
            [184] = "MMM",
            [185] = "MMM-dd",
            [186] = "M/d/yyyy",
            [187] = "d-MMM-yyyy"
        };

        private string GetDateTimeFormat(UInt32Value numberFormatId)
        {
            return DateFormatDictionary.ContainsKey(numberFormatId) ? DateFormatDictionary[numberFormatId] : string.Empty;
        }


        public List<string> GetCustomApplicationValuesByKeys(Guid customApplicationId, string key, List<ValidationMessage> validationMessages)
        {
            return _customApplicationRepository.GetCustomApplicationValuesByKeys(customApplicationId, key, validationMessages);
        }

        public Guid? GetCustomFormIdByName(string formName, Guid companyId, List<ValidationMessage> validationMessages)
        {
            return _customApplicationRepository.GetCustomFormIdByName(formName, companyId, validationMessages);
        }
        public List<UserTasksModel> GetHumanTaskList(string processDefinitionKey, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];

            List<UserTasksModel> userTasks = new List<UserTasksModel>();  
            EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel =
                new EmployeeSearchCriteriaInputModel { UserId = loggedInContext.LoggedInUserId, IsArchived = false };
            string roleName = _employeeRepository.GetAllEmployees(employeeSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault()?.RoleName;
            CamundaEngineClient camunda = new CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);
            var result = camunda.HumanTaskService.LoadTasks(new Dictionary<string, string>()
            {
                {"processDefinitionKey", processDefinitionKey}
            });
            foreach (var task in result)
            {
                var taskDetails = new UserTasksModel
                {
                    Id = task.Id,
                    Name = task.Name,
                    TaskDefinitionKey = task.TaskDefinitionKey,
                    ProcessInstanceId = task.ProcessInstanceId,
                    ProcessDefinitionId = task.ProcessDefinitionId,
                    UserRole = roleName,
                    TaskVariables = camunda.HumanTaskService.LoadVariables(task.Id)
                };

                userTasks.Add(taskDetails);
            }

            return userTasks;
        }

        public void CompleteUserTask(string taskId, bool isApproved)
        {
            var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];

            CamundaEngineClient camunda = new CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);
            camunda.HumanTaskService.Complete(taskId, new Dictionary<string, object>()
          {
              { "isApproved", isApproved}
          });

        }

        public string Deploy(string deploymentName, List<object> files, string companyId)
        {
            var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];


            using (StreamReader streamReader = new StreamReader(FormUpload.MultipartFormDataPost(camundaApiBaseUrl + "/engine-rest/engine/default/deployment/create", null, null, new Dictionary<string, object>()
            {
                {
                    "deployment-name",
                    (object) deploymentName
                },
                {
                    "deployment-source",
                    (object) "C# Process Application"
                },
                {
                    "enable-duplicate-filtering",
                    (object) "true"
                },

                {
                    "data",
                    (object) files
                }
            }).GetResponseStream() ?? throw new InvalidOperationException(), Encoding.UTF8))
            {
                return JsonConvert.DeserializeObject<Deployment>(streamReader.ReadToEnd()).Id;
            }
        }


        public Guid? UpsertObservationType(ObservationTypeModel observationTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var formIds = new List<Guid?>();

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertObservationType", "CustomApplicationService"));

            LoggingManager.Debug(observationTypeModel.ToString());

            if (!CommonValidationHelper.ValidateObservationTypeModel(observationTypeModel, loggedInContext, validationMessages))
            {
                return null;
            }

            observationTypeModel.ObservationTypeId = _customApplicationRepository.UpsertObservationType(observationTypeModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertCustomApplicationCommandId, observationTypeModel, loggedInContext);

            return observationTypeModel.ObservationTypeId;
        }

        public List<ObservationTypeModel> GetObservationType(ObservationTypeModel observationTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetObservationType", "CustomApplicationService"));

            LoggingManager.Debug(observationTypeModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetCustomApplicationCommandId, observationTypeModel, loggedInContext);

            List<ObservationTypeModel> observations = _customApplicationRepository.GetObservationType(observationTypeModel, loggedInContext, validationMessages);
            return observations;
        }

        public List<ResidentObservationApiReturnModel> GetResidentObservations(CustomFieldSearchCriteriaInputModel customFieldSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<ResidentObservationApiReturnModel> observations = new List<ResidentObservationApiReturnModel>();
            ObservationTypeModel observationTypeModel = new ObservationTypeModel()
            {
                IsArchived = false
            };

            var observationTypes = GetObservationType(observationTypeModel, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            if (observationTypes.Count > 0)
            {
                List<ValidationMessage> validations = new List<ValidationMessage>();
                CustomFieldSearchCriteriaInputModel customFieldSearchModel = customFieldSearchCriteriaModel;
                customFieldSearchModel.ReferenceId = customFieldSearchCriteriaModel.ReferenceId;
                customFieldSearchModel.ModuleTypeId = customFieldSearchCriteriaModel.ModuleTypeId;
                var customFieldData = _customFiledService.SearchCustomFields(customFieldSearchModel, loggedInContext, validations);
                if (validations.Count == 0)
                {
                    observations.AddRange(customFieldData.Where(p => p.SubmittedByUserId != null && observationTypes.Select(z => z.ObservationTypeId).ToList().Contains(p.ReferenceTypeId)).ToList().Select(p => new ResidentObservationApiReturnModel()
                    {
                        CreatedDateTime = p.CreatedDateTime,
                        FormDataJson = p.FormDataJson,
                        FormJson = p.FormJson,
                        FormKeys = p.FormKeys,
                        FormName = p.FormName,
                        ProfileImage = p.ProfileImage,
                        SubmittedByUser = p.SubmittedByUser,
                        SubmittedByUserId = p.SubmittedByUserId,
                        ObservationName = observationTypes.FirstOrDefault(q => q.ObservationTypeId == p.ReferenceTypeId)?.ObservationTypeName
                    }).ToList());
                }
            }
            return observations;
        }

        public List<FormHistoryModel> GetFormHistory(FormHistoryModel formHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormHistory", "CustomApplicationService"));

            LoggingManager.Debug(formHistoryModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetFormHistoryCommandId, formHistoryModel, loggedInContext);

            List<FormHistoryModel> customApplicationKeys = _customApplicationRepository.GetFormHistory(formHistoryModel, loggedInContext, validationMessages);

            return customApplicationKeys;
        }
        public List<UpsertDataLevelKeyConfigurationModel> GetLevels(GetLevelsKeyConfigurationModel upsertLevelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLevels", "CustomApplicationService"));

            LoggingManager.Debug(upsertLevelModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<UpsertDataLevelKeyConfigurationModel> levelsList = _dataSourceService.SearchLevelKeyConfiguration(upsertLevelModel.Id,upsertLevelModel.CustomApplicationId,upsertLevelModel.IsArchived, loggedInContext, validationMessages).GetAwaiter().GetResult();

            return levelsList;
        }
        public Guid? UpsertLevel(UpsertLevelModel upsertLevelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertLevel", "CustomApplicationService"));

            //LoggingManager.Debug(upsertLevelModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetFormHistoryCommandId, upsertLevelModel, loggedInContext);

            Guid? levelId = _dataSourceService.CreateDataLevelKeysConfiguration(upsertLevelModel, loggedInContext, validationMessages).GetAwaiter().GetResult();

            return levelId;
        }

        public List<CustomApplicationSearchOutputModel> GetCustomApplicationUnAuth(CustomApplicationSearchInputModel customApplicationSearchInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomApplication", "CustomApplicationService"));

            LoggingManager.Debug(customApplicationSearchInputModel.ToString());

            List<CustomApplicationSearchOutputModel> customApplicationForms = new List<CustomApplicationSearchOutputModel>();

            string customApplicationList = _customApplicationRepository.GetCustomApplicationUnAuth(customApplicationSearchInputModel, validationMessages);

            if (!string.IsNullOrEmpty(customApplicationList))
            {
                customApplicationForms = JsonConvert.DeserializeObject<List<CustomApplicationSearchOutputModel>>(customApplicationList);
            }
            var genericFormTypeSearchInputModel = new GetGenericFormTypesSearchCriteriaInputModel();
            List<GetGenericFormTypesOutputModel> formTypes = new List<GetGenericFormTypesOutputModel>();
            if (customApplicationSearchInputModel.IsList)
            {
                genericFormTypeSearchInputModel.IsArchived = false;
                formTypes = _genericFormMasterDataService.GetGenericFormTypesAnonymous(genericFormTypeSearchInputModel, validationMessages);
            }
            foreach (var application in customApplicationForms)
            {
                var dataSource = _dataSourceService.SearchDataSourceUnAuth(application.FormId, null, null, false, validationMessages, customApplicationSearchInputModel.CompanyId.ToString(), customApplicationSearchInputModel.IsCompanyBased).GetAwaiter().GetResult()?.FirstOrDefault();
                //if (customApplicationSearchInputModel.CustomApplicationId != null && customApplicationSearchInputModel.CustomApplicationId != Guid.Empty)
                //{
                //    if (dataSource != null)
                //    {
                //        if (dataSource.EditFormRoleIds == null || (dataSource.EditFormRoleIds != null && dataSource.EditFormRoleIds.Length == 0))
                //        {
                            application.EditForm = true;
                //        }
                //    }
                //}
                if (dataSource != null)
                {
                    if (customApplicationSearchInputModel.IsList)
                    {
                        DataSourceOutputModel dataSourceOutputModel = new DataSourceOutputModel();
                        var jsonData = JsonConvert.DeserializeObject<DataSourceOutputModel>(JsonConvert.SerializeObject(JObject.Parse(dataSource.Fields.ToString())));
                        application.FormTypeId = jsonData.FormTypeId;
                        if (application.FormTypeId != null)
                        {
                            if (formTypes != null)
                            {
                                application.FormTypeName = formTypes.Find(formType => formType.FormTypeId == application.FormTypeId).FormTypeName;
                            }
                        }
                    }
                    application.FormName = dataSource.Name;
                    application.Fields = dataSource.Fields;
                    application.FormJson = dataSource.Fields.ToString();
                    application.DataSourceId = application.FormId;
                }

                
            }

            return customApplicationForms;
        }

    }
}