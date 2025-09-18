using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.BillingManagement;
using Btrak.Models.CompanyStructure;
using Btrak.Models.CustomApplication;
using Btrak.Models.Employee;
using Btrak.Models.FormDataServices;
using Btrak.Models.FormTypes;
using Btrak.Models.GenericForm;
using Btrak.Models.Role;
using Btrak.Models.SystemManagement;
using Btrak.Models.TradeManagement;
using Btrak.Models.User;
using Btrak.Models.Widgets;
using Btrak.Models.WorkFlow;
using Btrak.Services.Audit;
using Btrak.Services.BillingManagement;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.FormDataServices;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.GenericForm;
using Btrak.Services.HrManagement;
using BTrak.Common;
using BusinessView.Common;
using CamundaClient;
using Hangfire;
using JsonDiffPatchDotNet;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Configuration;
using System.Xml;
using Btrak.Services.User;
using Btrak.Services.Notification;
using Btrak.Models.WorkflowManagement;
using DataSetOutputModel = Btrak.Models.DataSetOutputModel;
using System.IO;
using System.Text.RegularExpressions;
using static BTrak.Common.Enumerators;
using JsonDeserialiseData = BTrak.Common.JsonDeserialiseData;
using Microsoft.Azure.Amqp;
using Btrak.Services.PDFHTMLDesigner;
using Btrak.Services.MailTemplateActivity;
using System.Windows.Input;
using Btrak.Models.File;
using Uno.Extensions;
using System.Net;
using DocumentFormat.OpenXml.Spreadsheet;
using Btrak.Models.DailyUploadExcels;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Information;
using Amazon.Runtime.Internal.Transform;

namespace Btrak.Services.GenericForm
{
    public class GenericFormService : IGenericFormService
    {
        private readonly GenericFormRepository _genericFormRepository;
        private readonly IAuditService _auditService;
        private readonly IDataSourceService _dataSourceService;
        private readonly IDataSetService _dataSetService;
        private readonly CustomApplicationRepository _customApplicationRepository;
        private readonly UserRepository _userRepository;
        private readonly IHrManagementService _hrManagementService;
        private readonly IEmailService _emailService;
        private readonly IClientService _clientService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IUserService _userService;
        private readonly INotificationService _notificationService;
        public const string workflowsList = "Workflows";
        public const string workflowsActivity = "WorkflowActivity";
        public const string workflowsError = "workflowError";
        public const string workflowsInstance = "workflowInstance";
        public const string forms = "forms";
        private readonly IPDFHTMLDesignerService _PDFHTMLDesignerService;
        private readonly MailTemplateActivityRepository _mailTemplateRepository;
        private readonly IMailTemplateActivityService _mailTemplateService;
        private readonly ExcelToCustomApplicationRepository _dailyUploadExcelRepository;

        public GenericFormService(GenericFormRepository genericFormRepository, IHrManagementService hrManagementService, IAuditService auditService, IDataSourceService dataSourceService, IDataSetService dataSetService, CustomApplicationRepository customApplicationRepository, UserRepository userRepository,
            IEmailService emailService, IClientService clientService, ICompanyStructureService companyStructureService,
            IUserService userService, INotificationService notificationService
            , PDFHTMLDesignerService pDFHTMLDesignerService,
            MailTemplateActivityRepository mailTemplateActivityRepository
            , MailTemplateActivityService mailTemplateActivityService,
            ExcelToCustomApplicationRepository dailyUploadExcelRepository
             )
        {
            _genericFormRepository = genericFormRepository;
            _auditService = auditService;
            _dataSourceService = dataSourceService;
            _dataSetService = dataSetService;
            _customApplicationRepository = customApplicationRepository;
            _userRepository = userRepository;
            _hrManagementService = hrManagementService;
            _emailService = emailService;
            _clientService = clientService;
            _companyStructureService = companyStructureService;
            _userService = userService;
            _notificationService = notificationService;
            _PDFHTMLDesignerService = pDFHTMLDesignerService;
            _mailTemplateRepository = mailTemplateActivityRepository;
            _mailTemplateService = mailTemplateActivityService;
            _dailyUploadExcelRepository = dailyUploadExcelRepository;
        }

        public async Task<GenericFormApiReturnModel> UpsertGenericForms(GenericFormUpsertInputModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGenericForms", "GenericForm Api"));

            LoggingManager.Debug(genericFormModel.ToString());

            if (!GenericFormValidations.ValidateUpsertGenericForms(genericFormModel, loggedInContext, validationMessages))
            {
                return null;
            }



            //DataServiceConversionModel dataServiceConversionModel = JsonConvert.DeserializeObject<DataServiceConversionModel>(genericFormModel.FormJson);
            //List<Component> cop = ConvertToMetaJsonModel(dataServiceConversionModel.Components);
            //List<Component> cop = dataServiceConversionModel.Components;

            DataServiceConversionModel dataServiceConversionModelFinal = new DataServiceConversionModel();
            dataServiceConversionModelFinal.Components = genericFormModel.FormJson;
            dataServiceConversionModelFinal.FormTypeId = genericFormModel.FormTypeId;
            dataServiceConversionModelFinal.IsAbleToLogin = genericFormModel.IsAbleToLogin;
            dataServiceConversionModelFinal.AllowAnnonymous = genericFormModel.AllowAnnonymous;
            DataSourceInputModel dataSourceInputModel = new DataSourceInputModel();
            dataSourceInputModel.Fields = JsonConvert.SerializeObject(dataServiceConversionModelFinal);
            dataSourceInputModel.CompanyId = loggedInContext.CompanyGuid;
            dataSourceInputModel.DataSourceType = "Forms";
            dataSourceInputModel.DataSourceTypeNumber = 1;
            dataSourceInputModel.Name = genericFormModel.FormName;
            dataSourceInputModel.Id = genericFormModel.DataSourceId;
            dataSourceInputModel.IsArchived = genericFormModel.IsArchived;
            dataSourceInputModel.CompanyModuleId = genericFormModel.CompanyModuleId;
            dataSourceInputModel.FormBgColor = genericFormModel.FormBgColor;
            dataSourceInputModel.ViewFormRoleIds = genericFormModel.ViewFormRoleIds;
            dataSourceInputModel.EditFormRoleIds = genericFormModel.EditFormRoleIds;
            genericFormModel.DataSourceId = await _dataSourceService.CreateDataSource(dataSourceInputModel, loggedInContext, validationMessages);

            var dataSourceKeyModel = new DataSourceKeysInputModel();
            dataSourceKeyModel.DataSourceId = genericFormModel.DataSourceId;
            Guid? Id = await _dataSourceService.UpdateDataSourceKeys(dataSourceKeyModel, loggedInContext, validationMessages);
            if (genericFormModel.FormKeys != null)
            {
                var formKeys = JsonConvert.DeserializeObject<List<DataSourceKeysInputModel>>(genericFormModel.FormKeys);
                foreach (var comp in formKeys)
                {
                    var dataSourceKeyInputModel = new DataSourceKeysInputModel();
                    dataSourceKeyInputModel.DataSourceId = genericFormModel.DataSourceId;
                    dataSourceKeyInputModel.Key = comp.Key;
                    dataSourceKeyInputModel.Label = comp.Label;
                    dataSourceKeyInputModel.DecimalLimit = comp?.DecimalLimit;
                    dataSourceKeyInputModel.RequireDecimal = comp?.RequireDecimal;
                    dataSourceKeyInputModel.Delimiter = comp?.Delimiter;
                    dataSourceKeyInputModel.Type = comp.Type;
                    dataSourceKeyInputModel.Title = comp.Title;
                    dataSourceKeyInputModel.UserView = comp.UserView == null ? comp.UserView : comp.UserView;
                    dataSourceKeyInputModel.UserEdit = comp.UserEdit == null ? comp.UserEdit : comp.UserEdit;
                    dataSourceKeyInputModel.RoleView = comp.RoleView == null ? comp.RoleView : comp.RoleView;
                    dataSourceKeyInputModel.RoleEdit = comp.RoleEdit == null ? comp.RoleEdit : comp.RoleEdit;
                    dataSourceKeyInputModel.RelatedFieldsLabel = comp.RelatedFieldsLabel == null ? comp.RelatedFieldsLabel : comp.RelatedFieldsLabel;
                    dataSourceKeyInputModel.RelatedFormsFields = comp.RelatedFormsFields == null ? comp.RelatedFormsFields : comp.RelatedFormsFields;
                    dataSourceKeyInputModel.FormName = comp.FormName;
                    dataSourceKeyInputModel.Relatedfield = comp.Relatedfield == null ? comp.Relatedfield : comp.Relatedfield;
                    dataSourceKeyInputModel.RelatedFieldsfinalData = comp.RelatedFieldsfinalData == null ? comp.RelatedFieldsfinalData : comp.RelatedFieldsfinalData;
                    dataSourceKeyInputModel.ConcateFormFields = comp.ConcateFormFields == null ? comp.ConcateFormFields : comp.ConcateFormFields;
                    dataSourceKeyInputModel.DateTimeForLinkedFields = comp.DateTimeForLinkedFields == null ? comp.DateTimeForLinkedFields : comp.DateTimeForLinkedFields;
                    dataSourceKeyInputModel.ConcatSplitKey = comp.ConcatSplitKey == null ? comp.ConcatSplitKey : comp.ConcatSplitKey;
                    dataSourceKeyInputModel.FieldName = comp.FieldName;
                    dataSourceKeyInputModel.SelectedFormName = comp.SelectedFormName;
                    dataSourceKeyInputModel.Format = comp?.Format;
                    dataSourceKeyInputModel.Path = comp?.Path;
                    dataSourceKeyInputModel.IsAddOptionRequired = comp.IsAddOptionRequired;
                    dataSourceKeyInputModel.IsMultiSelectOptionRequired = comp.IsMultiSelectOptionRequired;
                    dataSourceKeyInputModel.CalculateFieldName = comp.CalculateFieldName;
                    dataSourceKeyInputModel.Operator = comp.Operator;
                    dataSourceKeyInputModel.selectedForm = comp.selectedForm;
                    dataSourceKeyInputModel.dataSrc = comp.dataSrc;
                    dataSourceKeyInputModel.customAppName = comp.customAppName;
                    dataSourceKeyInputModel.formName = comp.formName;
                    dataSourceKeyInputModel.fieldName = comp.fieldName;
                    dataSourceKeyInputModel.ValueSelection = comp?.ValueSelection;
                    dataSourceKeyInputModel.CalculateValue = comp?.CalculateValue;
                    dataSourceKeyInputModel.Unique = comp?.Unique;
                    dataSourceKeyInputModel.Properties = comp?.Properties;
                    Guid? newId = await _dataSourceService.CreateDataSourceKeys(dataSourceKeyInputModel, loggedInContext, validationMessages);
                }
            }
            _auditService.SaveAudit(AppCommandConstants.UpsertGenericFormsCommandId, genericFormModel, loggedInContext);

            GenericFormApiReturnModel genericFormApiReturnModel = ConvertToApiReturnModel(genericFormModel);

            LoggingManager.Debug(genericFormApiReturnModel.ToString());

            return genericFormApiReturnModel;
        }
        public void UpdateProcessInstanceStatus()
        {
            LoggingManager.Debug("Entered into Process method in UpdateProcessInstanceStatus");
            var validationMessages = new List<ValidationMessage>();

            //Get workflow datasource id
            Guid? dataSourceId = Guid.Empty;

            var dataSources = SearchDataSourceForJob(null, workflowsInstance, false, validationMessages).GetAwaiter().GetResult();

            if (dataSources != null && dataSources.Count > 0)
            {
                dataSourceId = dataSources[0].Id;
                var processInstance = SearchDataSetsForJob(null, dataSourceId, null, false, validationMessages).GetAwaiter().GetResult();

                if (processInstance.Count > 0)
                {
                    var activeProcessInstance = processInstance.Where(x => x.IsArchived == false).ToList();

                    foreach (var instance in activeProcessInstance)
                    {
                        var dataJson = JObject.Parse(instance.DataJson.ToString());
                        var instanceId = (Guid?)dataJson["ProcessInstanceId"];
                        var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];
                        CamundaEngineClient camunda = new CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);
                        var url = camundaApiBaseUrl + "/engine-rest/process-instance/" + instanceId;

                        RestClient client = new RestClient(url);
                        RestRequest request = new RestRequest();

                        // Use the Method property to set the HTTP method
                        request.Method = Method.GET;
                        var responseString = client.Execute(request);
                        dynamic res = JsonConvert.DeserializeObject(responseString.Content);
                        if (res?.id != instanceId)
                        {
                            WorkflowDataSetModel workflowDataSetModel = new WorkflowDataSetModel();
                            workflowDataSetModel.Id = instance.Id;
                            workflowDataSetModel.DataSourceId = instance.DataSourceId;
                            workflowDataSetModel.IsArchived = true;
                            workflowDataSetModel.DataJson = instance.DataJson.ToString();
                            Guid? submissionId1 = UpdateDataSetJob(workflowDataSetModel, validationMessages).GetAwaiter().GetResult();
                        }
                    }
                }
            }
        }
        public Guid? UpdateWorkflow(WorkflowModel workflowModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateWorkflow", "GenericForm Api"));
            WorkflowDataSetModel workflowDataSetModel = new WorkflowDataSetModel();
            workflowDataSetModel.Id = workflowModel.Id;
            workflowDataSetModel.DataSourceId = workflowModel.DataSourceId;
            workflowDataSetModel.IsArchived = workflowModel.IsArchived;
            workflowDataSetModel.DataJson = workflowModel.DataJson;
            Guid? submissionId1 = UpdateDataSet(workflowDataSetModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
            List<ParamsKeyModel> paramsModel = new List<ParamsKeyModel>();
            paramsModel.Add(new ParamsKeyModel()
            {
                KeyName = "WorkflowId",
                KeyValue = workflowModel.Id.ToString(),
                Type = "string"
            });
            var dataJsonModel = JsonConvert.SerializeObject(paramsModel);
            var records = _dataSetService.SearchDataSets(null, null, null, dataJsonModel, false, false, 1, 20, loggedInContext, validationMessages, null, null, null, null, null, null, null, null).GetAwaiter().GetResult();
            if (records != null)
            {
                if (workflowModel.IsArchived == true)
                {
                    var jobId = records.Select(x => x.Id).FirstOrDefault();
                    RecurringJob.RemoveIfExists(jobId.ToString());
                }
                else
                {
                    WorkflowDataSetModel workflowDataSetModelJob = new WorkflowDataSetModel();
                    workflowDataSetModelJob.Id = records[0].Id;
                    workflowDataSetModelJob.DataSourceId = records[0].DataSourceId;
                    workflowDataSetModelJob.DataJson = JsonConvert.SerializeObject(records[0].DataJson);
                    workflowDataSetModelJob.IsArchived = false;
                    Guid? jobDataSetId = records[0].Id;
                    int? offsetMinutes = Convert.ToInt32(records[0].DataJson.OffsetMinutes);
                    TimeSpan offset = TimeSpan.FromMinutes(Convert.ToInt32(offsetMinutes));
                    var timeZones = TimeZoneInfo.GetSystemTimeZones();
                    var timeZoneDetails = timeZones.FirstOrDefault(x => x.BaseUtcOffset == offset);

                    GenericFormSubmittedUpsertInputModel genericFormSubmittedUpsertInputModel = new GenericFormSubmittedUpsertInputModel();
                    WorkflowCronExpressionInputModel workflowCronExpressionInputModel = new WorkflowCronExpressionInputModel();

                    workflowCronExpressionInputModel.CronExpression = records[0].DataJson.CronExpression;
                    workflowCronExpressionInputModel.WorkflowId = workflowModel.Id;
                    workflowCronExpressionInputModel.WorkflowXml = workflowModel.Xml != null ? workflowModel.Xml : null;
                    workflowCronExpressionInputModel.CronRadio = "Yes";
                    workflowCronExpressionInputModel.WorkflowName = workflowModel.WorkflowName;
                    workflowCronExpressionInputModel.FormId = records[0].DataJson.FormTypeId;
                    workflowCronExpressionInputModel.DataJson = workflowDataSetModel.DataJson;
                    workflowCronExpressionInputModel.OffsetMinutes = Convert.ToInt32(records[0].DataJson.OffsetMinutes);

                    RecurringJob.AddOrUpdate(jobDataSetId.ToString(), () => PostMethod(genericFormSubmittedUpsertInputModel, workflowCronExpressionInputModel, loggedInContext, validationMessages),
                    records[0].DataJson.CronExpression, TimeZoneInfo.FindSystemTimeZoneById(timeZoneDetails?.StandardName));
                }

            }
            return submissionId1;
        }

        public Guid? UpsertWorkflow(WorkflowModel workflowModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGenericForms", "GenericForm Api"));
            //Get workflow datasource id
            Guid? datasourceId = Guid.Empty;

            var dataSources = SearchDataSource(null, null, "Workflows", false, null,false, loggedInContext, validationMessages).GetAwaiter().GetResult();

            ///var ds = JsonConvert.SerializeObject(dataSources);

            if (dataSources != null && dataSources.Count > 0)
            {
                foreach (var s in dataSources)
                {
                    datasourceId = s.Id;
                }
            }
            else
            {
                //insert datasource for workflow
                WorkflowDataSourceModel workflowDataSourceModel = new WorkflowDataSourceModel();
                workflowDataSourceModel.Description = "Description";
                workflowDataSourceModel.Name = "Workflows";
                workflowDataSourceModel.CompanyId = loggedInContext.CompanyGuid;
                workflowDataSourceModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                workflowDataSourceModel.IsArchived = false;
                workflowDataSourceModel.Fields = string.Empty;
                workflowDataSourceModel.DataSourceType = "Workflows";
                workflowDataSourceModel.DataSourceTypeNumber = 5;

                datasourceId = CreateDataSource(workflowDataSourceModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
            }

            //insert dataset for workflow
            WorkflowDataSetModel workflowDataSetModel = new WorkflowDataSetModel();
            workflowDataSetModel.Id = workflowModel.Id;
            workflowDataSetModel.DataSourceId = datasourceId; //new Guid("23538dc5-9111-41ff-ae74-6d19d658961d");
            workflowDataSetModel.IsArchived = workflowModel.IsArchived ?? false;
            workflowDataSetModel.DataJson = JsonConvert.SerializeObject(workflowModel);
            var submissionId1 = (workflowModel.Id == null || workflowModel.Id == Guid.Empty) ? CreateDataSet(workflowDataSetModel, loggedInContext, validationMessages).GetAwaiter().GetResult() :
                            UpdateDataSet(workflowDataSetModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
            if (workflowModel.SelectedTab == null)
            {
                workflowModel.SelectedTab = 0;
            }
            var jobject = JObject.Parse(workflowDataSetModel.DataJson);
            //job config
            if (jobject.ContainsKey("CronExpression") && workflowModel.SelectedTab == 1)
            {
                CreateWorkflowJob(jobject, submissionId1, workflowDataSetModel, loggedInContext, validationMessages);
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertGenericFormsCommandId, workflowModel, loggedInContext);

            if (submissionId1 != null && submissionId1 != Guid.Empty)
            {
                DeployWorkFlowDetails(new WorkFlowTriggerModel()
                {
                    IsArchived = false,
                    WorkFlowTypeId = workflowModel.WorkflowTypeId,
                    WorkflowName = workflowModel.WorkflowName,
                    WorkflowXml = workflowModel.Xml
                }, loggedInContext);
            }

            return submissionId1;
        }


        public async Task<Guid?> CreateDataSource(WorkflowDataSourceModel workflowDataSourceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    if (workflowDataSourceModel.Id != null && workflowDataSourceModel.Id != Guid.Empty)
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSourceApi/UpdateDataSource");
                    }
                    else
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSourceApi/CreateDataSource");
                    }

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(workflowDataSourceModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<WorkflowDataSourceModel>(result).Data;
                        return data;
                    }
                    else
                    {
                        return null;
                    }
                }

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSource", "DataSourceService", exception.Message), exception);
                return Guid.Empty;
            }
        }

        public void CreateWorkflowJob(JObject jobject, Guid? workflowId, WorkflowDataSetModel workflowDataSetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            WorkflowCronExpressionInputModel workflowCronExpressionInputModel = new WorkflowCronExpressionInputModel();

            workflowCronExpressionInputModel.CronExpression = jobject["CronExpression"].ToString();
            workflowCronExpressionInputModel.WorkflowId = workflowId;
            workflowCronExpressionInputModel.WorkflowXml = jobject.ContainsKey("Xml") ? jobject["Xml"].ToString() : null;
            workflowCronExpressionInputModel.CronRadio = jobject.ContainsKey("CronRadio") ? jobject["CronRadio"].ToString() : null;
            workflowCronExpressionInputModel.WorkflowName = jobject.ContainsKey("WorkflowName") ? jobject["WorkflowName"].ToString() : null;
            workflowCronExpressionInputModel.FormId = jobject.ContainsKey("FormTypeId") && jobject["FormTypeId"] != null && !string.IsNullOrEmpty(jobject["FormTypeId"].ToString()) ? (Guid)jobject["FormTypeId"] : Guid.Empty;
            workflowCronExpressionInputModel.DataJson = workflowDataSetModel.DataJson;
            workflowCronExpressionInputModel.OffsetMinutes = Convert.ToInt32(jobject["OffsetMinutes"]);
            GenericFormSubmittedUpsertInputModel genericFormSubmittedUpsertInputModel = new GenericFormSubmittedUpsertInputModel();
            Guid? jobId = Guid.Empty;
            if (workflowCronExpressionInputModel.CronRadio == "Yes")
            {
                workflowCronExpressionInputModel.Timezone = jobject.ContainsKey("Timezone") ? jobject["Timezone"].ToString() : "";
                //Get workflow datasource id
                Guid? jobdatasourceId = Guid.Empty;
                var dataSources = SearchDataSource(null, null, "WorkflowsJob", false, null,false, loggedInContext, validationMessages).GetAwaiter().GetResult();
                if (dataSources != null && dataSources.Count > 0)
                {
                    foreach (var s in dataSources)
                    {
                        jobdatasourceId = s.Id;
                    }
                }
                else
                {
                    WorkflowDataSourceModel workflowDataSourceModel = new WorkflowDataSourceModel();
                    workflowDataSourceModel.Description = "WorkflowsJob";
                    workflowDataSourceModel.Name = "WorkflowsJob";
                    workflowDataSourceModel.CompanyId = loggedInContext.CompanyGuid;
                    workflowDataSourceModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                    workflowDataSourceModel.IsArchived = false;
                    workflowDataSourceModel.Fields = string.Empty;
                    workflowDataSourceModel.DataSourceType = "WorkflowsJob";
                    workflowDataSourceModel.DataSourceTypeNumber = 7;
                    jobdatasourceId = CreateDataSource(workflowDataSourceModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                }

                var totalJobs = SearchDataSets(null, jobdatasourceId, null, false, null, null, null, loggedInContext, validationMessages).GetAwaiter().GetResult();

                DataSetOutputModelForWorkflows job = totalJobs.FirstOrDefault(x => x.IsArchived == false && x.DataJson.WorkflowId == workflowCronExpressionInputModel.WorkflowId);

                // insert job record
                WorkflowDataSetModel workflowDataSetModelJob = new WorkflowDataSetModel();
                if (job != null)
                    workflowDataSetModelJob.Id = job.Id;
                workflowDataSetModelJob.DataSourceId = jobdatasourceId;

                WorkflowCronExpressionInputModel workflowCronExpressionInputModel1 = new WorkflowCronExpressionInputModel();
                workflowCronExpressionInputModel1.CronExpression = jobject["CronExpression"].ToString();
                workflowCronExpressionInputModel1.WorkflowId = workflowId;
                workflowCronExpressionInputModel1.WorkflowName = jobject.ContainsKey("WorkflowName") ? jobject["WorkflowName"].ToString() : null;
                workflowCronExpressionInputModel1.FormId = jobject.ContainsKey("FormTypeId") ? (Guid)jobject["FormTypeId"] : Guid.Empty;
                workflowCronExpressionInputModel1.Timezone = jobject["Timezone"].ToString();
                workflowCronExpressionInputModel1.OffsetMinutes = Convert.ToInt32(jobject["OffsetMinutes"]);
                workflowDataSetModelJob.DataJson = JsonConvert.SerializeObject(workflowCronExpressionInputModel1);
                workflowDataSetModel.IsArchived = workflowDataSetModel.IsArchived;
                if (workflowDataSetModelJob.Id != null && workflowDataSetModelJob.Id != Guid.Empty)
                {
                    jobId = UpdateDataSet(workflowDataSetModelJob, loggedInContext, validationMessages).GetAwaiter().GetResult();
                }
                else
                {

                    jobId = CreateDataSet(workflowDataSetModelJob, loggedInContext, validationMessages).GetAwaiter().GetResult();
                }


                var timeZone = TimeZoneInfo.Utc;
                if (workflowCronExpressionInputModel.IsArchived == true)
                {
                    RecurringJob.RemoveIfExists(jobId.ToString());
                }
                else
                {
                    if (!string.IsNullOrEmpty(workflowCronExpressionInputModel.Timezone))
                    {
                        TimeSpan offset = TimeSpan.FromMinutes(workflowCronExpressionInputModel.OffsetMinutes);
                        var timeZones = TimeZoneInfo.GetSystemTimeZones();
                        var timeZoneDetails = timeZones.FirstOrDefault(x => x.BaseUtcOffset == offset);
                        RecurringJob.AddOrUpdate(jobId.ToString(), () => PostMethod(genericFormSubmittedUpsertInputModel, workflowCronExpressionInputModel, loggedInContext, validationMessages),
                        workflowCronExpressionInputModel.CronExpression, TimeZoneInfo.FindSystemTimeZoneById(timeZoneDetails?.StandardName));
                    }
                    else
                        RecurringJob.AddOrUpdate(jobId.ToString(), () => PostMethod(genericFormSubmittedUpsertInputModel, workflowCronExpressionInputModel, loggedInContext, validationMessages),
                        workflowCronExpressionInputModel.CronExpression);
                }


            }
        }

        public async Task<Guid?> UpdateDataSet(WorkflowDataSetModel workflowDataSetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {

                    if (workflowDataSetModel.Id != null && workflowDataSetModel.Id != Guid.Empty)
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/UpdateDataSet");
                    }


                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(workflowDataSetModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(result);
                        Guid? workflowId = (Guid?)data["data"];
                        return (bool)data["success"] ? (Guid?)data["data"] : null;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", " DataSetService", exception.Message), exception);
                return Guid.Empty;
            }
        }

        public async Task<Guid?> UpdateDataSetJob(WorkflowDataSetModel workflowDataSetModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {

                    if (workflowDataSetModel.Id != null && workflowDataSetModel.Id != Guid.Empty)
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/UpdateDataSetJob");
                    }


                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "");
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(workflowDataSetModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(result);
                        return (bool)data["success"] ? (Guid?)data["data"] : null;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", " DataSetService", exception.Message), exception);
                return Guid.Empty;
            }
        }
        public async Task<Guid?> CreateDataSet(WorkflowDataSetModel workflowDataSetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {

                    if (workflowDataSetModel.Id != null && workflowDataSetModel.Id != Guid.Empty)
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/UpdateDataSet");
                    }
                    else
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/CreateDataSet");
                    }

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(workflowDataSetModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(result);
                        Guid? workflowId = (Guid?)data["data"];
                        return (bool)data["success"] ? (Guid?)data["data"] : null;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", " DataSetService", exception.Message), exception);
                return Guid.Empty;
            }
        }


        public async Task<List<WorkflowDataSourceModel>> SearchDataSource(Guid? id, Guid? companyModuleId, string searchText, bool? isArchived, string formIds, LoggedInContext loggedInContext, LoggedInContext loggedInContext1, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "/DataService/DataSourceApi/SearchDataSource?id=" + id + "&companyModuleId=" + companyModuleId + "&searchText=" + searchText + "&isArchived=" + isArchived);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<WorkflowDataSourceModelFake>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = result.Select(e => new WorkflowDataSourceModel
                        {
                            Id = e.Id,
                            Key = e.Key,
                            Name = e.Name,
                            FormTypeId = e.FormTypeId,
                            Description = e.Description,
                            DataSourceType = e.DataSourceType,
                            Tags = e.Tags,
                            Fields = e.Fields.ToString(),
                            IsArchived = e.IsArchived,
                            CompanyModuleId = e.CompanyModuleId

                        }).ToList();
                        return rdata;

                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSourceService", exception.Message), exception);
                return null;
            }
        }


        public async Task<List<WorkflowDataSourceModel>> SearchDataSourceForJob(Guid? id, string searchText, bool? isArchived, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "/DataService/DataSourceApi/SearchDataSourceForJob?id=" + id + "&searchText=" + searchText + "&isArchived=" + isArchived);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "");
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<WorkflowDataSourceModelFake>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = result.Select(e => new WorkflowDataSourceModel
                        {
                            Id = e.Id,
                            Key = e.Key,
                            Name = e.Name,
                            FormTypeId = e.FormTypeId,
                            Description = e.Description,
                            DataSourceType = e.DataSourceType,
                            Tags = e.Tags,
                            Fields = e.Fields.ToString(),
                            IsArchived = e.IsArchived
                        }).ToList();
                        return rdata;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSourceService", exception.Message), exception);
                return null;
            }
        }
        public void PostMethod(GenericFormSubmittedUpsertInputModel genericFormSubmittedUpsertInputModel, WorkflowCronExpressionInputModel cronExpressionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            WorkFlowTriggerModel workFlowTriggerModel = new WorkFlowTriggerModel();
            workFlowTriggerModel.IsArchived = false;
            workFlowTriggerModel.WorkFlowTypeId = cronExpressionInputModel.WorkflowTypeId;
            workFlowTriggerModel.WorkflowName = cronExpressionInputModel.WorkflowName;
            workFlowTriggerModel.WorkflowXml = cronExpressionInputModel.WorkflowXml;
            workFlowTriggerModel.FormId = cronExpressionInputModel.FormId;
            workFlowTriggerModel.DataJson = cronExpressionInputModel.DataJson;
            StartWorkflowProcessInstanceXml(genericFormSubmittedUpsertInputModel, workFlowTriggerModel.FormId, workFlowTriggerModel, loggedInContext, validationMessages);
        }

        public async Task<List<Models.DataSetOutputModelForWorkflows>> SearchDataSets(Guid? id, Guid? dataSourceId, string searchText, bool? isArchived, string dataSourceIds, string dataJsonValues, string dataSetIds, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    var baseUrl = WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/SearchDataSet";
                    client.BaseAddress = new Uri(baseUrl);
                    var apiPath = baseUrl + "?id=" + id + "&dataSourceId=" + dataSourceId + "&searchText=" + searchText + "&isArchived=" + isArchived + "&dataSourceIds=" + dataSourceIds + "&paramsJsonModel=" + dataJsonValues + "&dataSetIds=" + dataSetIds;
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    var response = await client.GetAsync(apiPath).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        if ((bool)data["success"])
                        {
                            var apiData = data["data"].ToString();

                            var re = JsonConvert.DeserializeObject<List<Models.DataSetOutputModelForWorkflows>>(apiData);

                            return re;
                        }
                        else
                        {
                            return null;
                        }
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }
        public async Task<List<Models.DataSetOutputModelForWorkflows>> SearchDataSetsUnAuth(Guid? id, Guid? dataSourceId, string searchText, bool? isArchived, string dataSourceIds, string dataJsonValues, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    var baseUrl = WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/SearchDataSetUnAuth";
                    client.BaseAddress = new Uri(baseUrl);
                    var apiPath = baseUrl + "?id=" + id + "&dataSourceId=" + dataSourceId + "&searchText=" + searchText + "&isArchived=" + isArchived + "&dataSourceIds=" + dataSourceIds + "&paramsJsonModel=" + dataJsonValues;
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    var response = await client.GetAsync(apiPath).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        if ((bool)data["success"])
                        {
                            var apiData = data["data"].ToString();

                            var re = JsonConvert.DeserializeObject<List<Models.DataSetOutputModelForWorkflows>>(apiData);

                            return re;
                        }
                        else
                        {
                            return null;
                        }
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<List<Models.DataSetOutputModel>> SearchDataSetsForJob(Guid? id, Guid? dataSourceId, string searchText, bool? isArchived, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    var baseUrl = WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "/DataService/DataSetApi/SearchDataSetsForJob";
                    client.BaseAddress = new Uri(baseUrl);
                    var apiPath = baseUrl + "?id=" + id + "&dataSourceId=" + dataSourceId + "&searchText=" + searchText + "&isArchived=" + isArchived;
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "");
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    var response = await client.GetAsync(apiPath).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        if ((bool)data["success"])
                        {
                            var apiData = data["data"].ToString();

                            var re = JsonConvert.DeserializeObject<List<Models.DataSetOutputModel>>(apiData);

                            return re;
                        }
                        else
                        {
                            return null;
                        }
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public List<GenericFormApiReturnModel> GetForms(FormWorkflowModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenericForms", "GenericForm Api"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetGenericFormsCommandId, genericFormModel, loggedInContext);

            List<GenericFormApiReturnModel> genericForms = _genericFormRepository.GetForms(genericFormModel, loggedInContext, validationMessages);

            return genericForms;

        }

        private List<Component> ConvertToMetaJsonModel(List<Component> component)
        {
            if (component != null)
            {
                return component.Where(x => true).Select(componentDetails => new Component
                {
                    Label = componentDetails.Label,
                    Key = componentDetails.Key,
                    Type = componentDetails.Type,
                    DataType = componentDetails.Type,
                    DefaultValue = componentDetails.DefaultValue,
                    Description = componentDetails.Description,
                    Columns = ConvertToMetaJsonModel(componentDetails.Columns),
                    Rows = ConvertToMetaJsonRowModel(componentDetails.Rows),
                    Components = ConvertToMetaJsonModel(componentDetails.Components),
                }).ToList();
            }
            else
            {
                return null;
            }
        }
        private List<List<Component>> ConvertToMetaJsonRowModel(object component)
        {
            if (component != null)
            {
                List<List<Component>> comp = new List<List<Component>>();
                if (component is int || component is byte || component is short || component is ushort || component is uint
                || component is long || component is ulong || component is float || component is double || component is decimal)
                {
                }
                else
                {
                    comp = JsonConvert.DeserializeObject<List<List<Component>>>(JsonConvert.SerializeObject(component));
                    foreach (var x in comp[0])
                    {
                        x.Columns = ConvertToMetaJsonModel(x.Columns);
                        x.Rows = ConvertToMetaJsonRowModel(x.Rows);
                        x.Components = ConvertToMetaJsonModel(x.Components);
                    }
                }
                return comp;
            }
            else
            {
                return null;
            }
        }
        public List<GenericFormApiReturnModel> GetGenericForms(GenericFormSearchCriteriaInputModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenericForms", "GenericForm Api"));

            LoggingManager.Debug(genericFormModel.ToString());
            LoggingManager.Debug(loggedInContext.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(genericFormModel.FormIds))
            {
                string[] formIds = genericFormModel.FormIds.Split(new[] { ',' });

                List<Guid> allFormIds = formIds.Select(Guid.Parse).ToList();

                genericFormModel.FormIdsXml = Utilities.ConvertIntoListXml(allFormIds.ToList());
                genericFormModel.FormIdsList = allFormIds;
            }

            if (genericFormModel.Id == Guid.Empty)
            {
                genericFormModel.Id = null;
            }

            if (genericFormModel.FormTypeId == Guid.Empty)
            {
                genericFormModel.FormTypeId = null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetGenericFormsCommandId, genericFormModel, loggedInContext);

            string filterText = filterText = genericFormModel.IsIncludeTemplateForms == true && genericFormModel.IsIncludeTemplateForms != null ? null : "Forms";

            var dataSources = SearchDataSource(genericFormModel.Id, genericFormModel.CompanyModuleId, filterText, genericFormModel.IsArchived, genericFormModel.FormIds, genericFormModel.IsIncludedAllForms,loggedInContext, validationMessages, genericFormModel.CompaniesList).GetAwaiter().GetResult();
            // List<GenericFormApiReturnModel> formsList = _genericFormRepository.Get(genericFormModel, loggedInContext, validationMessages);
            if (dataSources != null)
            {
                List<GenericFormApiReturnModel> forms = dataSources.Where(z => (z.DataSourceType == "Forms" || z.DataSourceType == "TradeTemplate" || z.DataSourceType == "ContractTemplate" || genericFormModel.IsIncludeTemplateForms == false || genericFormModel.IsIncludeTemplateForms == null))?.Select(e => new GenericFormApiReturnModel
                {
                    FormName = e.Name,
                    Id = (Guid)e.Id,
                    DataSourceId = (Guid)e.Id,
                    FormJson = e.Fields.ToString(),
                    CompanyModuleId = e.CompanyModuleId,
                    CreatedDateTime = e.CreatedDateTime,
                    Fields = e.FieldObject,
                    FormBgColor = e.FormBgColor == null ? "" : e.FormBgColor.ToString(),
                    ViewFormRoleIds = e.ViewFormRoleIds,
                    EditFormRoleIds = e.EditFormRoleIds
                }).ToList();

                return forms;
            }
            else
            {
                return new List<GenericFormApiReturnModel>();
            }
        }
        public List<GenericFormApiReturnModel> GetGenericFormsUnAuth(GenericFormSearchCriteriaInputModel genericFormModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenericFormsUnAuth", "GenericForm Api"));

            LoggingManager.Debug(genericFormModel.ToString());

            if (!string.IsNullOrEmpty(genericFormModel.FormIds))
            {
                string[] formIds = genericFormModel.FormIds.Split(new[] { ',' });

                List<Guid> allFormIds = formIds.Select(Guid.Parse).ToList();

                genericFormModel.FormIdsXml = Utilities.ConvertIntoListXml(allFormIds.ToList());
                genericFormModel.FormIdsList = allFormIds;
            }

            if (genericFormModel.Id == Guid.Empty)
            {
                genericFormModel.Id = null;
            }

            if (genericFormModel.FormTypeId == Guid.Empty)
            {
                genericFormModel.FormTypeId = null;
            }

            //_auditService.SaveAudit(AppCommandConstants.GetGenericFormsCommandId, genericFormModel, loggedInContext);

            string filterText = filterText = genericFormModel.IsIncludeTemplateForms == true && genericFormModel.IsIncludeTemplateForms != null ? null : "Forms";

            var dataSources = SearchDataSourceUnAuth(genericFormModel.Id, genericFormModel.CompanyModuleId, filterText, genericFormModel.IsArchived, genericFormModel.FormIds, validationMessages, genericFormModel.CompaniesList).GetAwaiter().GetResult();
            // List<GenericFormApiReturnModel> formsList = _genericFormRepository.Get(genericFormModel, loggedInContext, validationMessages);
            if (dataSources != null)
            {
                List<GenericFormApiReturnModel> forms = dataSources.Where(z => (z.DataSourceType == "Forms" || z.DataSourceType == "TradeTemplate" || z.DataSourceType == "ContractTemplate" || genericFormModel.IsIncludeTemplateForms == false || genericFormModel.IsIncludeTemplateForms == null))?.Select(e => new GenericFormApiReturnModel
                {
                    FormName = e.Name,
                    Id = (Guid)e.Id,
                    DataSourceId = (Guid)e.Id,
                    FormJson = e.Fields.ToString(),
                    CompanyModuleId = e.CompanyModuleId,
                    CreatedDateTime = e.CreatedDateTime,
                    Fields = e.FieldObject,
                    FormBgColor = e.FormBgColor == null ? "" : e.FormBgColor.ToString(),
                    ViewFormRoleIds = e.ViewFormRoleIds,
                    EditFormRoleIds = e.EditFormRoleIds
                }).ToList();

                return forms;
            }
            else
            {
                return new List<GenericFormApiReturnModel>();
            }
        }

        public List<GenericFormApiReturnModel> GetGenericFormsByTypeId(Guid formTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenericFormsByTypeId", "GenericForm Api"));

            LoggingManager.Debug(formTypeId.ToString());

            if (!GenericFormValidations.ValidateGenericFormsByTypeId(formTypeId, loggedInContext, validationMessages))
            {
                return null;
            }

            List<GenericFormApiReturnModel> forms = _genericFormRepository.GetGenericFormsByTypeId(formTypeId, loggedInContext, validationMessages);
            return forms;
        }

        public FormFieldValuesOuputModel GetFormFieldValuesDummy(GenericFormSubmittedSearchInputModel searchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormFieldValues", "GenericForm Api"));

            if (searchInputModel.FormId == null || searchInputModel.FormId == Guid.Empty)
            {
                var dataSources = SearchDataSource(null, null, null, false, null, false, loggedInContext, validationMessages, searchInputModel.CompanyIds).GetAwaiter().GetResult().ToList();

                searchInputModel.FormId = dataSources?.Where(t => t.Name == searchInputModel.FormName)?.FirstOrDefault()?.Id;
            }

            var dataSets = new List<Models.DataSetOutputModel>();
            var splits = searchInputModel.Key.Split('.');
            var isInnerQuery = false;
            if (splits != null && splits.Length > 1)
            {
                isInnerQuery = true;
            }

            DataSourceKeysOutputModel dataSourcekeys = new DataSourceKeysOutputModel();

            if (searchInputModel.FormId != null && searchInputModel.Key != null)
            {
                dataSourcekeys = _dataSourceService.SearchDataSourceKeys(null, searchInputModel.FormId, null, null, null, null, loggedInContext, validationMessages).GetAwaiter().GetResult()?.Where(t => t.Path == searchInputModel.Key)?.FirstOrDefault();
            }

            List<ParamsJsonModel> paramsJsons1 = new List<ParamsJsonModel>();

            paramsJsons1.Add(new ParamsJsonModel()
            {
                KeyName = "FormDataLookUpFilter"
            });

            string paramsJsonModel1 = JsonConvert.SerializeObject(paramsJsons1);

            dataSets = _dataSetService.SearchDataSets(null, searchInputModel.FormId, null, paramsJsonModel1, false, false, null, null, loggedInContext, validationMessages, isInnerQuery, true, searchInputModel.Key, null, null, null, searchInputModel.CompanyIds).GetAwaiter().GetResult();

            List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "ContractType",
                KeyValue = "ExecutionSteps",
                Type = "string"
            });

            paramsJsons.Add(new ParamsJsonModel()
            {
                KeyName = "TemplateId",
                KeyValue = searchInputModel.FormId.ToString(),
                Type = "guid"
            });


            string paramsJsonModel = JsonConvert.SerializeObject(paramsJsons);

            var dataSetsTemplates = _dataSetService.SearchDataSets(null, null, null, paramsJsonModel, false, false, null, null, loggedInContext, validationMessages, isInnerQuery, true, searchInputModel.Key, null, null, null, searchInputModel.CompanyIds).GetAwaiter().GetResult();

            if (dataSetsTemplates != null && dataSetsTemplates?.Count > 0)
            {
                dataSets.AddRange(dataSetsTemplates);
            }

            List<string> keyValues = new List<string>();

            foreach (var data in dataSets)
            {
                Dictionary<string, string> keyValueTest = new Dictionary<string, string>();
                if (isInnerQuery != true && data.DataJson.FormData != null)
                {
                    JObject data2 = (JObject)(data.DataJson.FormData);

                    //if (splits != null && splits.Length > 0)
                    //{
                    //    var panel = (object)data2[splits[0]]?.ToList();
                    //    var b = JsonConvert.DeserializeObject<object>(JsonConvert.SerializeObject(panel))?.ToString();
                    //    var c = JsonConvert.DeserializeObject(b);                        
                    //    var e = ((JArray)c).Select(x => (string)x[splits[1]]).ToList();
                    //    keyValues.AddRange(e);
                    //} 
                    //else {
                    foreach (KeyValuePair<string, JToken> keyValuePair in data2)
                    {
                        keyValueTest.Add(keyValuePair.Key, keyValuePair.Value.ToString());
                    }

                    string value = keyValueTest?.Where(t => t.Key.ToLower() == searchInputModel.Key.ToLower())?.FirstOrDefault().Value;

                    if (value != null && value != string.Empty)
                    {
                        keyValues.Add(value);
                    }
                    //}
                    // }
                }
                else if (isInnerQuery == true && data.DataJsonForFields != null)
                {
                    JObject data2 = (JObject)(data.DataJsonForFields);
                    foreach (KeyValuePair<string, JToken> keyValuePair in data2)
                    {
                        keyValueTest.Add(keyValuePair.Key, keyValuePair.Value.ToString());
                    }

                    string value = keyValueTest?.Where(t => t.Key.ToLower() == searchInputModel.Key.Split('.').LastOrDefault()?.ToLower())?.FirstOrDefault().Value;

                    if (value != null && value != string.Empty)
                    {
                        JArray a = (JArray)JsonConvert.DeserializeObject(value);
                        foreach (var i in a)
                        {
                            var typ = i.GetType();
                            if (typ.Name == "JArray")
                            {
                                addIntoKeyValues(i, keyValues);
                            }
                            else
                            {
                                keyValues.Add(i.ToString());
                            }
                        }
                    }
                }
                // var data1 = JsonConvert.DeserializeObject<Dictionary<string, string>>(JsonConvert.SerializeObject(data.DataJson.FormData)).ToList();

                //keyValues.AddRange(data1.Where(t => t.Key == searchInputModel.Key).Select(t => t.Value));
            }

            FormFieldValuesOuputModel formFieldValuesOuputModel = new FormFieldValuesOuputModel();

            if (dataSourcekeys != null)
            {
                formFieldValuesOuputModel.Key = dataSourcekeys.Key;
                formFieldValuesOuputModel.Type = dataSourcekeys.Type;
                formFieldValuesOuputModel.DecimalLimit = dataSourcekeys.DecimalLimit;
                formFieldValuesOuputModel.RequireDecimal = dataSourcekeys.RequireDecimal;
                formFieldValuesOuputModel.Format = dataSourcekeys.Format;
                formFieldValuesOuputModel.Delimiter = dataSourcekeys.Delimiter;
            }
            if (searchInputModel.FilterFieldsBasedOnForm == true && !string.IsNullOrEmpty(searchInputModel.FilterFormName))
            {
                formFieldValuesOuputModel.FieldValues = keyValues.Distinct().Where(x => x.ToLower().Contains(searchInputModel.FilterFormName.ToLower())).ToList();
            }
            else
            {
                formFieldValuesOuputModel.FieldValues = keyValues.Distinct().ToList();
            }

            return formFieldValuesOuputModel;
        }

        public FormFieldValuesOuputModel GetFormFieldValues(GenericFormSubmittedSearchInputModel searchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormFieldValues", "GenericForm Api"));

            FormFieldValuesOuputModel formFieldValuesOuputModel = new FormFieldValuesOuputModel();
            GetFormFieldValuesInputModel inputModel = new GetFormFieldValuesInputModel
            {
                Key = searchInputModel.Key,
                FormId = searchInputModel.FormId,
                CompanyIds = searchInputModel.CompanyIds,
                FilterFieldsBasedOnForm = searchInputModel.FilterFieldsBasedOnForm,
                FilterFormName = searchInputModel.FilterFormName,
                IsPagingRequired = searchInputModel.IsPagingRequired,
                PageNumber = searchInputModel.PageNumber,
                PageSize = searchInputModel.PageSize,
                FilterValue = searchInputModel.FilterValue,
                Value = searchInputModel.Value
            };

            formFieldValuesOuputModel = _dataSetService.GetFormFieldValues(inputModel, loggedInContext, validationMessages).GetAwaiter().GetResult();

            return formFieldValuesOuputModel;
        }

        private void addIntoKeyValues(dynamic it, dynamic keyValues)
        {
            foreach (var i in it)
            {
                var typ = i.GetType();
                if (typ.Name == "JArray")
                {
                    addIntoKeyValues(i, keyValues);
                }
                else
                {
                    keyValues.Add(i.ToString());
                }
            }
        }

        public List<GenericFormApiReturnModel> GetFormsWithField(GetFormsWithFieldInputModel getFormRecord, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormsWithField", "GenericForm Api"));

            List<GenericFormApiReturnModel> genericFormApiReturns = new List<GenericFormApiReturnModel>();

            //var dataSources = SearchDataSource(null, null, null, false, null, loggedInContext, validationMessages).GetAwaiter().GetResult().ToList();

            //if (getFormRecord.FormId == null && getFormRecord.FormName != null)
            //{
            //    getFormRecord.FormId = dataSources?.Where(t => t.Name == getFormRecord.FormName)?.FirstOrDefault()?.Id;
            //}

            //List<DataSourceKeysOutputModel> dataSourcekeys = _dataSourceService.SearchDataSourceKeys(null, null, null, loggedInContext, validationMessages).GetAwaiter().GetResult();

            //var keysList = from msg in dataSources where dataSourcekeys.Any(x => x.DataSourceId == msg.Id) select msg;

            //var data = keysList.ToList();

            //genericFormApiReturns = data.Select(e => new GenericFormApiReturnModel
            //{
            //    Id = (Guid)e.Id,
            //    FormName = e.Name
            //}).ToList();

            List<SearchAllDataSourcesOutpuutModel> dataSourcesOutpuut = _dataSourceService.SearchAllDataSources(getFormRecord, loggedInContext, validationMessages).GetAwaiter().GetResult();

            genericFormApiReturns = dataSourcesOutpuut.Select(e => new GenericFormApiReturnModel
            {
                Id = (Guid)e.Id,
                FormName = e.Name
            }).ToList();

            return genericFormApiReturns;
        }

        public dynamic GetFormRecordValuesDummy(GetFormRecordValuesInputModel getFormRecordValues, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormRecordValues", "GenericForm Api"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            if (getFormRecordValues.FormsModel != null)
            {
                getFormRecordValues.FieldsXML = Utilities.GetXmlFromObject(getFormRecordValues.FormsModel);
            }

            foreach (var model in getFormRecordValues.FormsModel)
            {
                model.FormName = model.FormName.Replace("'", "");
            }

            //string values = _genericFormRepository.GetFormRecordValues(getFormRecordValues, loggedInContext, validationMessages);
            GenericFormSubmittedSearchInputModel genericFormKeySearchInputModel = new GenericFormSubmittedSearchInputModel();

            List<FormsMiniModel> formsMinis = new List<FormsMiniModel>();

            var formNames = getFormRecordValues.FormsModel?.Select(t => t.FormId)?.Distinct()?.ToList();
            string names = null;

            if (formNames != null)
            {
                names = string.Join(",", formNames);
            }

            var dataSources = SearchDataSource(null, null, null, false, names, false,loggedInContext, validationMessages, getFormRecordValues.CompanyIds).GetAwaiter().GetResult().ToList();

            var forms = from msg in getFormRecordValues.FormsModel where dataSources.Any(x => x.Id == msg.FormId) select msg;
            var formsList = forms.Select(t => new { t.FormName, t.FormId }).Distinct();

            List<ParamsJsonModel> paramsJsons1 = new List<ParamsJsonModel>();

            paramsJsons1.Add(new ParamsJsonModel()
            {
                KeyName = "FormDataLookUpFilter"
            });

            string paramsJsonModel1 = JsonConvert.SerializeObject(paramsJsons1);

            List<FormsMiniModel> formsMiniModels = new List<FormsMiniModel>();
            var dataSets = new List<DataSetOutputModel>();
            var isInnerQuery = false;
            var splits = getFormRecordValues.KeyName.Split('.');
            if (splits != null && splits.Length > 1)
            {
                isInnerQuery = true;
            }
            if (isInnerQuery == true)
            {
                string paths = String.Join(",", getFormRecordValues.FormsModel.Select(t => t.Path));
                genericFormKeySearchInputModel.FormId = dataSources.Where(t => t.Id == formsList?.FirstOrDefault()?.FormId)?.FirstOrDefault()?.Id;
                List<DataSourceKeysOutputModel> dataSourcekeys = _dataSourceService.SearchDataSourceKeys(null, genericFormKeySearchInputModel.FormId, null, null, null, null, loggedInContext, validationMessages).GetAwaiter().GetResult();
                dataSets = _dataSetService.SearchDataSets(null, genericFormKeySearchInputModel.FormId, null, paramsJsonModel1, false, false, null, null, loggedInContext, validationMessages, isInnerQuery, null, getFormRecordValues.KeyName, getFormRecordValues.KeyValue, true, paths, getFormRecordValues.CompanyIds).GetAwaiter().GetResult();
                if (dataSets != null && dataSets.Count > 0)
                {
                    Dictionary<string, string> keyValueTest = new Dictionary<string, string>();
                    foreach (var data in dataSets)
                    {
                        if (data.DataJsonForFields != null)
                        {
                            JObject data2 = (JObject)(data.DataJsonForFields);
                            foreach (KeyValuePair<string, JToken> keyValuePair in data2)
                            {
                                keyValueTest.Add(keyValuePair.Key, keyValuePair.Value.ToString());
                            }
                            var ar = new Dictionary<string, object>();
                            foreach (var form in getFormRecordValues.FormsModel)
                            {
                                string value = keyValueTest?.Where(t => t.Key.ToLower() == form.KeyName?.ToLower())?.FirstOrDefault().Value;
                                var type = dataSourcekeys?.Where(t => (t.DataSourceId == form.FormId && form.KeyName == t.Key))?.FirstOrDefault()?.Type;
                                var format = dataSourcekeys?.Where(t => (t.DataSourceId == form.FormId && form.KeyName == t.Key))?.FirstOrDefault()?.Format;
                                var decimalLimit = dataSourcekeys?.Where(t => (t.DataSourceId == form.FormId && form.KeyName == t.Key))?.FirstOrDefault()?.DecimalLimit;
                                var requireDecimal = dataSourcekeys?.Where(t => (t.DataSourceId == form.FormId && form.KeyName == t.Key))?.FirstOrDefault()?.RequireDecimal;
                                var delimiter = dataSourcekeys?.Where(t => (t.DataSourceId == form.FormId && form.KeyName == t.Key))?.FirstOrDefault()?.Delimiter;
                                ar.Add(form.KeyName, value);
                                ar.Add(form.KeyName + "-Type", type);
                                ar.Add(form.KeyName + "-Format", format);
                                ar.Add(form.KeyName + "-DecimalLimit", decimalLimit);
                                ar.Add(form.KeyName + "-RequireDecimal", requireDecimal);
                                ar.Add(form.KeyName + "-Delimiter", delimiter);
                            }
                            var a = JsonConvert.DeserializeObject(JsonConvert.SerializeObject(ar));
                            var formDict = new Dictionary<object, Array>();
                            formDict.Add(formsList?.FirstOrDefault()?.FormName, new[] { a });
                            var b = JsonConvert.DeserializeObject(JsonConvert.SerializeObject(formDict));
                            var obj = new[] { b };
                            return obj;
                        }
                    }
                }
                return null;

            }
            else
            {
                foreach (var formName in formsList)
                {
                    genericFormKeySearchInputModel.FormId = dataSources.Where(t => t.Id == formName.FormId).FirstOrDefault()?.Id;

                    dataSets = _dataSetService.SearchDataSets(null, genericFormKeySearchInputModel.FormId, null, paramsJsonModel1, false, false, genericFormKeySearchInputModel.PageNumber, genericFormKeySearchInputModel.PageSize, loggedInContext, validationMessages, null, null, null, null, null, null, getFormRecordValues.CompanyIds).GetAwaiter().GetResult();

                    List<ParamsJsonModel> paramsJsons = new List<ParamsJsonModel>();

                    paramsJsons.Add(new ParamsJsonModel()
                    {
                        KeyName = "ContractType",
                        KeyValue = "ExecutionSteps",
                        Type = "string"
                    });

                    paramsJsons.Add(new ParamsJsonModel()
                    {
                        KeyName = "TemplateId",
                        KeyValue = genericFormKeySearchInputModel.FormId.ToString(),
                        Type = "guid"
                    });

                    string paramsJsonModel = JsonConvert.SerializeObject(paramsJsons);

                    var templateDataSets = _dataSetService.SearchDataSets(null, null, null, paramsJsonModel, false, false, genericFormKeySearchInputModel.PageNumber, genericFormKeySearchInputModel.PageSize, loggedInContext, validationMessages, null, null, null, null, null, null, getFormRecordValues.CompanyIds).GetAwaiter().GetResult();

                    if (templateDataSets != null && templateDataSets?.Count > 0)
                    {
                        dataSets.AddRange(templateDataSets);
                    }

                    List<GenericFormSubmittedSearchOutputModel> genericFormSubmitted = new List<GenericFormSubmittedSearchOutputModel>();

                    List<DataSourceKeysOutputModel> dataSourcekeys = _dataSourceService.SearchDataSourceKeys(null, genericFormKeySearchInputModel.FormId, null, null, null, null, loggedInContext, validationMessages).GetAwaiter().GetResult();

                    //Parallel.ForEach(getFormRecordValues.FormsModel.Where(t => t.FormId == genericFormKeySearchInputModel.FormId).ToList(), (record, state, index) =>
                    //{
                    //    record.KeyType = dataSourcekeys?.Where(t => (t.DataSourceId == record.FormId && record.KeyName == t.Key))?.FirstOrDefault()?.Type;
                    //    var recordFormat = dataSourcekeys?.Where(t => (t.DataSourceId == record.FormId && record.KeyName == t.Key))?.FirstOrDefault()?.Format;
                    //    formsMiniModels.Add(record);
                    //    formsMiniModels[(int)index].Format = recordFormat;
                    //    formsMiniModels[(int)index].DecimalLimit = dataSourcekeys?.Where(t => (t.DataSourceId == record.FormId && record.KeyName == t.Key))?.FirstOrDefault()?.DecimalLimit;
                    //    formsMiniModels[(int)index].RequireDecimal = dataSourcekeys?.Where(t => (t.DataSourceId == record.FormId && record.KeyName == t.Key))?.FirstOrDefault()?.RequireDecimal;
                    //    formsMiniModels[(int)index].Delimiter = dataSourcekeys?.Where(t => (t.DataSourceId == record.FormId && record.KeyName == t.Key))?.FirstOrDefault()?.Delimiter;
                    //});

                    foreach (var (record, index) in getFormRecordValues.FormsModel.Where(t => t.FormId == genericFormKeySearchInputModel.FormId).ToList().Select((value, i) => (value, i)))
                    {
                        record.KeyType = dataSourcekeys?.Where(t => (t.DataSourceId == record.FormId && record.KeyName == t.Key))?.FirstOrDefault()?.Type;
                        var recordFormat = dataSourcekeys?.Where(t => (t.DataSourceId == record.FormId && record.KeyName == t.Key))?.FirstOrDefault()?.Format;
                        formsMiniModels.Add(record);
                        formsMiniModels[(int)index].Format = recordFormat;
                        formsMiniModels[(int)index].DecimalLimit = dataSourcekeys?.Where(t => (t.DataSourceId == record.FormId && record.KeyName == t.Key))?.FirstOrDefault()?.DecimalLimit;
                        formsMiniModels[(int)index].RequireDecimal = dataSourcekeys?.Where(t => (t.DataSourceId == record.FormId && record.KeyName == t.Key))?.FirstOrDefault()?.RequireDecimal;
                        formsMiniModels[(int)index].Delimiter = dataSourcekeys?.Where(t => (t.DataSourceId == record.FormId && record.KeyName == t.Key))?.FirstOrDefault()?.Delimiter;
                    }

                    if (dataSets != null)
                    {
                        formsMinis = dataSets?.Where(t => (t?.DataJson?.FormData != null && t.DataJson.ContractType != null && t.DataJson.ContractType.ToLower() != "rfq"))?.Select(e => new FormsMiniModel
                        {
                            FormName = formName.FormName,
                            Jsons = JsonConvert.SerializeObject(((JObject)(e.DataJson.FormData))),
                            CreatedAt = e.CreatedDateTime
                        }).ToList();

                        var formsMiniForPrograms = dataSets?.Where(t => (t?.DataJson?.FormData != null && t.DataJson.ContractType == null) && t.DataJson.FormData.GetType().Name == "String")?.Select(e => new FormsMiniModel
                        {
                            FormName = formName.FormName,
                            Jsons = e.DataJson.FormData.ToString(),
                            CreatedAt = e.CreatedDateTime
                        }).ToList();

                        var formsMiniForProgramsList = dataSets?.Where(t => (t?.DataJson?.FormData != null && t.DataJson.ContractType == null) && t.DataJson.FormData.GetType().Name != "String")?.Select(e => new FormsMiniModel
                        {
                            FormName = formName.FormName,
                            Jsons = JsonConvert.SerializeObject(((e.DataJson.FormData))),
                            CreatedAt = e.CreatedDateTime
                        }).ToList();


                        if (formsMiniForPrograms.Count > 0)
                        {
                            formsMinis.AddRange(formsMiniForPrograms);
                        }
                        if (formsMiniForProgramsList.Count > 0)
                        {
                            formsMinis.AddRange(formsMiniForProgramsList);
                        }

                    }
                }

                getFormRecordValues.FieldsXML = Utilities.GetXmlFromObject(formsMiniModels);
                getFormRecordValues.FormsXML = Utilities.GetXmlFromObject(formsMinis);

                dynamic result = _genericFormRepository.GetFormRecordValues(getFormRecordValues, loggedInContext, validationMessages);

                var json = JsonConvert.DeserializeObject<dynamic>(result?.ToString());

                return json;
            }
            return null;
        }

        public dynamic GetFormRecordValues(GetFormRecordValuesInputModel getFormRecordValues, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var dataSets = _dataSetService.GetFormRecordValues(getFormRecordValues, loggedInContext, validationMessages).GetAwaiter().GetResult();
            var finalResult = new[] { dataSets };
            return finalResult;
        }

        public List<FormTypeApiReturnModel> GetFormTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormTypes", "GenericForm Api"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<FormTypeApiReturnModel> formTypes = _genericFormRepository.GetFormTypes(loggedInContext, validationMessages);
            return formTypes;
        }



        private GenericFormApiReturnModel ConvertToApiReturnModel(GenericFormUpsertInputModel genericFormUpsertInputModel)
        {
            GenericFormApiReturnModel genericFormApiReturnModel = new GenericFormApiReturnModel();

            //genericFormApiReturnModel.InjectFrom<NullableInjection>(genericFormUpsertInputModel);

            return genericFormApiReturnModel;
        }

        public Guid? UpsertGenericFormKey(GenericFormKeyUpsertInputModel genericFormKeyUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGenericForms", "GenericForm Api"));

            genericFormKeyUpsertInputModel.GenericFormKeyId = _genericFormRepository.UpsertGenericFormKey(genericFormKeyUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertGenericFormsCommandId, genericFormKeyUpsertInputModel, loggedInContext);

            return genericFormKeyUpsertInputModel.GenericFormKeyId;
        }

        public Guid? UpsertFormWorkflow(FormWorkflowInputModel formWorkflowInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGenericForms", "GenericForm Api"));

            formWorkflowInputModel.GenericFormKeyId = _genericFormRepository.UpsertFormWorkflow(formWorkflowInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertGenericFormsCommandId, formWorkflowInputModel, loggedInContext);

            return formWorkflowInputModel.GenericFormKeyId;
        }

        public List<GenericFormKeySearchOutputModel> GetGenericFormKey(GenericFormKeySearchInputModel genericFormKeySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenericFormKey", "GenericForm Api"));
            List<GenericFormKeySearchOutputModel> genericFormKeys = new List<GenericFormKeySearchOutputModel>();
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            var formSearchInputModel = new GenericFormSearchCriteriaInputModel();
            formSearchInputModel.Id = genericFormKeySearchInputModel.GenericFormId;
            List<DataSourceKeysOutputModel> dataSourcekeys = _dataSourceService.SearchDataSourceKeys(null, genericFormKeySearchInputModel.GenericFormId, null, null, null, true, loggedInContext, validationMessages).GetAwaiter().GetResult();
            if (dataSourcekeys.Count > 0)
            {
                genericFormKeys = dataSourcekeys.Select(e => new GenericFormKeySearchOutputModel
                {
                    GenericFormId = e.GenericFormId,
                    GenericFormKeyId = e.Id,
                    Key = e.Key,
                    Label = e.Label,
                    Type = e.Type,
                    DecimalLimit = e?.DecimalLimit,
                    IsArchived = e.IsArchived,
                    Format = e.Format,
                    Delimiter = e?.Delimiter,
                    RequireDecimal = e?.RequireDecimal
                }).ToList();

            }
            return genericFormKeys;

        }
        public List<GenericFormKeySearchOutputModel> GetEmployeeGenericFormKey(GenericFormKeySearchInputModel genericFormKeySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeGenericFormKey", "GenericForm Api"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<GenericFormKeySearchOutputModel> genericFormKeys = _genericFormRepository.GetEmployeeGenericFormKey(genericFormKeySearchInputModel, loggedInContext, validationMessages);
            return genericFormKeys;
        }

        public List<GenericFormSubmittedSearchOutputModel> GetGenericFormSubmitted(GenericFormSubmittedSearchInputModel genericFormKeySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenericFormKey", "GenericForm Api"));
            LoggingManager.Debug(genericFormKeySearchInputModel.ToString());
            List<GenericFormSubmittedSearchOutputModel> genericFormSubmitted = new List<GenericFormSubmittedSearchOutputModel>();


            string customApplicationId = null;
            List<ParamsKeyModel> paramsModel = new List<ParamsKeyModel>();
            List<RecordLevelPermissionInputModel> filterModel = new List<RecordLevelPermissionInputModel>();

            if (genericFormKeySearchInputModel.DateFrom != null)
            {

                paramsModel.Add(new ParamsKeyModel()
                {
                    KeyName = "DateFrom",
                    KeyValue = genericFormKeySearchInputModel.DateFrom,
                    Type = "DateTime"
                });
            }

            if (genericFormKeySearchInputModel.DateTo != null)
            {
                paramsModel.Add(new ParamsKeyModel()
                {
                    KeyName = "DateTo",
                    KeyValue = genericFormKeySearchInputModel.DateTo,
                    Type = "DateTime"
                });
            }
            //paramsModel = genericFormKeySearchInputModel?.ParamsKeyModel == null ? new List<ParamsKeyModel>() : genericFormKeySearchInputModel?.ParamsKeyModel;
            if (genericFormKeySearchInputModel.CustomApplicationId != null)
            {
                customApplicationId = genericFormKeySearchInputModel.CustomApplicationId.ToString();
                var applicationModel = new ParamsKeyModel();
                // var dateFromModel = new ParamsKeyModel();
                // var dateToModel = new ParamsKeyModel();

                applicationModel.KeyName = "CustomApplicationId";
                applicationModel.KeyValue = customApplicationId;
                applicationModel.Type = "Guid";

                //dateFromModel.KeyName = "DateFrom";
                //dateFromModel.KeyValue = genericFormKeySearchInputModel.DateFrom.ToString();
                //dateFromModel.Type = "DateTime";

                //dateToModel.KeyName = "DateTo";
                //dateToModel.KeyValue = genericFormKeySearchInputModel.DateTo.ToString();
                //dateToModel.Type = "DateTime";

                paramsModel.Add(applicationModel);
            }
            string roles = null;

            if (genericFormKeySearchInputModel.ConditionalEnum == 2 || genericFormKeySearchInputModel.ConditionalEnum == 3)
            {
                try
                {
                    var customApplicationForms = new List<RecordLevelPermissionInputModel>();
                    roles = genericFormKeySearchInputModel.RoleIds.ToLower();

                    if (genericFormKeySearchInputModel.ConditionalEnum == 3)
                    {
                        if (!string.IsNullOrEmpty(genericFormKeySearchInputModel.ConditionsJson))
                        {
                            customApplicationForms = JsonConvert.DeserializeObject<List<RecordLevelPermissionInputModel>>(genericFormKeySearchInputModel.ConditionsJson);
                        }

                        filterModel = customApplicationForms;

                        if (filterModel == null || filterModel.Count == 0)
                        {
                            return new List<GenericFormSubmittedSearchOutputModel>();
                        }
                    }
                }
                catch (Exception e)
                {
                    LoggingManager.Error("Getting exception while fetching user roles with exception : " + e);
                }
            }
            string jsonModel = JsonConvert.SerializeObject(paramsModel);
            string FileldsJson = JsonConvert.SerializeObject(genericFormKeySearchInputModel.Filters);
            string recordFilterJson = JsonConvert.SerializeObject(filterModel);
            var dataSets = _dataSetService.SearchDataSetsForForms(genericFormKeySearchInputModel.GenericFormSubmittedId, genericFormKeySearchInputModel.FormId, null, jsonModel, genericFormKeySearchInputModel.IsArchived, genericFormKeySearchInputModel.IsPagingRequired, genericFormKeySearchInputModel.PageNumber, genericFormKeySearchInputModel.PageSize, genericFormKeySearchInputModel.AdvancedFilter, FileldsJson, genericFormKeySearchInputModel.KeyFilterJson, genericFormKeySearchInputModel.IsRecordLevelPermissionEnabled, genericFormKeySearchInputModel.ConditionalEnum ?? 1, roles, recordFilterJson, loggedInContext, validationMessages).GetAwaiter().GetResult();

            if (dataSets != null)
            {
                genericFormSubmitted = dataSets.Select(e => new GenericFormSubmittedSearchOutputModel
                {
                    GenericFormSubmittedId = e.Id,
                    FormId = e.DataSourceId,
                    FormJson = JsonConvert.SerializeObject(e.DataJson.FormData),
                    FormSrc = JsonConvert.SerializeObject(e.DataSourceFormJson),
                    FormName = e.DataSourceName,
                    CreatedByUserId = e.CreatedByUserId,
                    CreatedDateTime = e.CreatedDateTime,
                    CustomApplicationId = e.DataJson.CustomApplicationId,
                    DataSetId = e.Id,
                    DataJson = JsonConvert.SerializeObject(e.DataJson),
                    UniqueNumber = e.DataJson.UniqueNumber,
                    IsPdfGenerated = e.IsPdfGenerated,
                    TotalCount = e.TotalCount,
                    IsApproved = e.IsApproved,
                    DataSourceId = e.DataSourceId,
                    Status = string.IsNullOrEmpty(e.DataJson.Status) ? e.DataJson.Status : e.DataJson.Status.First().ToString().ToUpper() + e.DataJson.Status.Substring(1),
                    Stage = string.IsNullOrEmpty(e.DataJson.Stage) ? e.DataJson.Stage : e.DataJson.Stage.First().ToString().ToUpper() + e.DataJson.Stage.Substring(1)
                }).ToList();

            }

            return genericFormSubmitted;
        }

        public List<GenericFormSubmittedSearchOutputModel> GetGenericFormSubmittedUnAuth(GenericFormSubmittedSearchInputModel genericFormKeySearchInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenericFormSubmittedUnAuth", "GenericForm Api"));
            LoggingManager.Debug(genericFormKeySearchInputModel.ToString());
            List<GenericFormSubmittedSearchOutputModel> genericFormSubmitted = new List<GenericFormSubmittedSearchOutputModel>();


            string customApplicationId = null;
            List<ParamsKeyModel> paramsModel = new List<ParamsKeyModel>();

            if (genericFormKeySearchInputModel.DateFrom != null)
            {

                paramsModel.Add(new ParamsKeyModel()
                {
                    KeyName = "DateFrom",
                    KeyValue = genericFormKeySearchInputModel.DateFrom,
                    Type = "DateTime"
                });
            }

            if (genericFormKeySearchInputModel.DateTo != null)
            {
                paramsModel.Add(new ParamsKeyModel()
                {
                    KeyName = "DateTo",
                    KeyValue = genericFormKeySearchInputModel.DateTo,
                    Type = "DateTime"
                });
            }
            if (genericFormKeySearchInputModel.CustomApplicationId != null)
            {
                customApplicationId = genericFormKeySearchInputModel.CustomApplicationId.ToString();
                var applicationModel = new ParamsKeyModel();


                applicationModel.KeyName = "CustomApplicationId";
                applicationModel.KeyValue = customApplicationId;
                applicationModel.Type = "Guid";

                paramsModel.Add(applicationModel);
            }
            string jsonModel = JsonConvert.SerializeObject(paramsModel);
            string FileldsJson = JsonConvert.SerializeObject(genericFormKeySearchInputModel.Filters);
            var dataSets = _dataSetService.SearchDataSetsForFormsUnAuth(genericFormKeySearchInputModel.GenericFormSubmittedId, genericFormKeySearchInputModel.FormId, null, jsonModel,
                false, genericFormKeySearchInputModel.IsPagingRequired, genericFormKeySearchInputModel.PageNumber, genericFormKeySearchInputModel.PageSize,
                genericFormKeySearchInputModel.AdvancedFilter, FileldsJson, genericFormKeySearchInputModel.KeyFilterJson, validationMessages).GetAwaiter().GetResult();

            if (dataSets != null)
            {
                genericFormSubmitted = dataSets.Select(e => new GenericFormSubmittedSearchOutputModel
                {
                    GenericFormSubmittedId = e.Id,
                    FormId = e.DataSourceId,
                    FormJson = JsonConvert.SerializeObject(e.DataJson.FormData),
                    FormSrc = JsonConvert.SerializeObject(e.DataSourceFormJson),
                    FormName = e.DataSourceName,
                    CreatedByUserId = e.CreatedByUserId,
                    CreatedDateTime = e.CreatedDateTime,
                    CustomApplicationId = e.DataJson.CustomApplicationId,
                    DataSetId = e.Id,
                    DataJson = JsonConvert.SerializeObject(e.DataJson),
                    UniqueNumber = e.DataJson.UniqueNumber,
                    IsPdfGenerated = e.IsPdfGenerated,
                    TotalCount = e.TotalCount,
                    IsApproved = e.IsApproved,
                    Status = string.IsNullOrEmpty(e.DataJson.Status) ? e.DataJson.Status : e.DataJson.Status.First().ToString().ToUpper() + e.DataJson.Status.Substring(1)
                }).ToList();

            }

            return genericFormSubmitted;
        }

        public List<GenericFormSubmittedSearchOutputModel> GetGenericFormSubmittedDataByKeyName(GenericFormSubmittedSearchInputModel genericFormKeySearchInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenericFormKey", "GenericForm Api"));

            List<GenericFormSubmittedSearchOutputModel> genericFormSubmitted = _genericFormRepository.GetGenericFormSubmittedDataByKeyName(genericFormKeySearchInputModel, validationMessages);

            return genericFormSubmitted;
        }

        public string ProcessCustomApplicationWorkflow(Dictionary<string, object> inputProperties, string customApplicationName, string customApplicationWorkflowName, string customApplicationWorkflowTrigger, LoggedInContext loggedInContext)
        {
            List<CustomApplicationWorkflowSearchOutputModel> customApplicationModels = _customApplicationRepository.GetCustomApplicationWorkflowByCustomApplicationNameAndWorkflowName(
                new CustomApplicationWorkflowUpsertInputModel()
                { CustomApplicationName = customApplicationName, WorkflowName = customApplicationWorkflowName, WorkflowTrigger = customApplicationWorkflowTrigger }, loggedInContext,
                new List<ValidationMessage>());

            if (customApplicationModels != null && customApplicationModels.Count > 0)
            {
                try
                {
                    foreach (CustomApplicationWorkflowSearchOutputModel customApplicationModel in customApplicationModels)
                    {
                        try
                        {
                            LoggingManager.Info("workflow process custom application for workflow name" + customApplicationModel.WorkflowName);

                            XmlDocument document = new XmlDocument();

                            document.LoadXml(customApplicationModel.WorkflowXml);

                            var xmlAttributeCollection = document.GetElementsByTagName("bpmn:definitions")[0]?.ChildNodes[0]?.Attributes;

                            if (xmlAttributeCollection != null)
                            {
                                var workflowName = document.GetElementsByTagName("bpmn:definitions")[0]?.ChildNodes[0]?.Attributes["id"]?.InnerText.Trim();
                                var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];

                                CamundaEngineClient camunda = new CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);

                                var processInstanceId = camunda.BpmnWorkflowService.StartProcessInstance(workflowName, inputProperties);

                                LoggingManager.Info("workflow triggered processed id is" + processInstanceId);
                            }
                        }
                        catch (Exception exception)
                        {

                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ProcessCustomApplicationWorkflow", "GenericFormService ", exception.Message), exception);

                        }
                    }
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ProcessCustomApplicationWorkflow", "GenericFormService ", exception.Message), exception);

                }
            }

            return null;
        }

        public async Task<Guid?> UpsertGenricFormSubmitted(GenericFormSubmittedUpsertInputModel genericformSubmittedUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormTypes", "GenericFormSubmitted Api"));
                //var formId = genericformSubmittedUpsertInputModel.GenericFormSubmittedId;
                if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
                {
                    return null;
                }

                string originalJson = string.Empty;
                List<HistoryOutputModel> historyList = new List<HistoryOutputModel>();
                string historyXml;

                DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();
                dataSetUpsertInputModel.IsArchived = genericformSubmittedUpsertInputModel.IsArchived;
                var dataSetModel = new DataSetConversionModel();
                dataSetModel.CustomApplicationId = genericformSubmittedUpsertInputModel.CustomApplicationId;
                dataSetModel.ContractType = "Form";
                dataSetModel.InvoiceType = "CustomApplication";
                if (genericformSubmittedUpsertInputModel.Status != null)
                {
                    if (genericformSubmittedUpsertInputModel.IsApproved ?? false)
                        dataSetModel.Status = "Approved";
                    else
                        dataSetModel.Status = genericformSubmittedUpsertInputModel.Status;
                }
                else
                {
                    dataSetModel.Status = "Draft";

                }

                dataSetModel.Stage = genericformSubmittedUpsertInputModel.Stage;

                if (genericformSubmittedUpsertInputModel.StagesScenarios != null &&
                    genericformSubmittedUpsertInputModel.StagesScenarios.Count > 0)
                {
                    var stagesData = genericformSubmittedUpsertInputModel.StagesScenarios;
                    string fieldName = stagesData.FirstOrDefault().FieldName;
                    string originalFieldValue = GetValueByKey(genericformSubmittedUpsertInputModel.FormJson, fieldName);

                    foreach (var stage in stagesData)
                    {
                        if (stage.FieldValue == originalFieldValue)
                            dataSetModel.Stage = stage.Stage;
                    }
                }
                dataSetModel.FormData = JsonConvert.DeserializeObject<Object>(genericformSubmittedUpsertInputModel.FormJson);

                dataSetModel.UniqueNumber = genericformSubmittedUpsertInputModel.UniqueNumber;
                dataSetModel.IsApproved = genericformSubmittedUpsertInputModel.IsApproved;
                dataSetUpsertInputModel.DataJson = JsonConvert.SerializeObject(dataSetModel);
                dataSetUpsertInputModel.CompanyId = loggedInContext.CompanyGuid;
                dataSetUpsertInputModel.DataSourceId = genericformSubmittedUpsertInputModel.DataSourceId != null ? genericformSubmittedUpsertInputModel.DataSourceId : genericformSubmittedUpsertInputModel.FormId;
                dataSetUpsertInputModel.Id = genericformSubmittedUpsertInputModel.GenericFormSubmittedId;
                dataSetUpsertInputModel.IsNewRecord = genericformSubmittedUpsertInputModel.IsNewRecord;
                dataSetUpsertInputModel.SubmittedUserId = genericformSubmittedUpsertInputModel.SubmittedUserId;
                dataSetUpsertInputModel.SubmittedCompanyId = genericformSubmittedUpsertInputModel.SubmittedCompanyId;
                dataSetUpsertInputModel.SubmittedByFormDrill = genericformSubmittedUpsertInputModel.SubmittedByFormDrill;
                dataSetUpsertInputModel.RecordAccessibleUsers = genericformSubmittedUpsertInputModel.RecordAccessibleUsers;
                if (dataSetUpsertInputModel.Id != null && dataSetUpsertInputModel.IsNewRecord == false)
                {
                    var searchModel = new GenericFormSubmittedSearchInputModel();
                    searchModel.GenericFormSubmittedId = dataSetUpsertInputModel.Id;
                    var formDetails = GetGenericFormSubmitted(searchModel, loggedInContext, validationMessages).FirstOrDefault();
                    if (formDetails != null)
                    {
                        originalJson = formDetails.FormJson;
                        genericformSubmittedUpsertInputModel.OldFormJson = originalJson;
                    }

                }
                genericformSubmittedUpsertInputModel.GenericFormSubmittedId = await _dataSetService.CreateDataSetGeneriForm(dataSetUpsertInputModel, loggedInContext, validationMessages);
                var submissionId = genericformSubmittedUpsertInputModel.DataSetId;
                if (genericformSubmittedUpsertInputModel.FormJson != null && genericformSubmittedUpsertInputModel.IsAbleToLogin == true)
                {
                    var userData = JsonConvert.DeserializeObject<UserInputModel>(genericformSubmittedUpsertInputModel.FormJson);
                    var password = userData.Password == null ? userData.Password2 : userData.Password;
                    userData.Password = userData.Password == null ? userData.Password2 : userData.Password;
                    userData.Email = userData.Email == null ? userData.Email2 : userData.Email;
                    userData.MobileNo = userData.MobileNo == null ? userData.PhoneNumber2 : userData.MobileNo;
                    userData.SurName = userData.SurName == null ? userData.LastName : userData.SurName;
                    userData.Password = Utilities.GetSaltedPassword(userData.Password);
                    userData.ReferenceId = submissionId;
                    userData.IsActive = genericformSubmittedUpsertInputModel.IsArchived == null ? true : !(genericformSubmittedUpsertInputModel.IsArchived.Value);

                    _userRepository.UpsertUserDetails(userData, loggedInContext, validationMessages);

                    if (validationMessages.Count == 0 && genericformSubmittedUpsertInputModel.GenericFormSubmittedId == null)
                    {
                        UserRegistrationDetailsModel userRegistrationDetails = new UserRegistrationDetailsModel()
                        {
                            UserName = userData.Email,
                            FirstName = userData.FirstName,
                            SurName = userData.SurName,
                            RoleIds = userData.Role,
                            Password = userData.Password ?? userData.Password2
                        };

                        BackgroundJob.Enqueue(() => _hrManagementService.SendUserRegistrationMail(userRegistrationDetails, loggedInContext, validationMessages));
                    }
                }
                //To call the workflows of the form

                try
                {
                    LoggingManager.Info("Workflow call started...");
                    //Get workflow datasource id

                    Guid? workflowId = Guid.Empty;
                    Guid? dataSourceId = genericformSubmittedUpsertInputModel.DataSourceId;
                    var dataSources = SearchDataSource(null, null, workflowsList, false, null, false, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    if (dataSources != null && dataSources.Count > 0)
                    {
                        dataSources = dataSources.Where(x => x.DataSourceType == "Workflows").ToList();
                        workflowId = dataSources[0].Id;
                        var workflows = SearchDataSets(null, workflowId, null, false, null, null, null, loggedInContext, validationMessages).GetAwaiter().GetResult();
                        var flows = workflows.Where(x => x.DataJson.FormTypeId == dataSourceId).ToList();

                        if (flows.Count > 0)
                        {
                            //For create or edit
                            string actions = string.Empty;
                            string action = string.Empty;
                            if (genericformSubmittedUpsertInputModel.IsNewRecord == false)
                            {
                                var newFormJson = JObject.Parse(genericformSubmittedUpsertInputModel.FormJson);
                                var oldFormJson = JObject.Parse(genericformSubmittedUpsertInputModel.OldFormJson);
                                if (genericformSubmittedUpsertInputModel.IsApproved == true)
                                {
                                    action = "Approve";
                                }
                                else if (genericformSubmittedUpsertInputModel.IsApproved == false)
                                {
                                    action = "Reject";
                                }
                                else
                                {
                                    action = "Edit";
                                    actions = "Create or Edit";
                                }
                            }
                            if (genericformSubmittedUpsertInputModel.IsNewRecord == true)
                            {
                                action = "Create";
                                actions = "Create or Edit";
                            }
                            if (genericformSubmittedUpsertInputModel.IsArchived == true)
                            {
                                action = "Delete";
                            }
                            //Field update
                            //select field update flows

                            var fieldflows = workflows.Where(x => x.DataJson.FormTypeId == dataSourceId && x.DataJson.Action == "Field Update").ToList();
                            if (fieldflows.Count > 0 && genericformSubmittedUpsertInputModel.IsNewRecord == false)
                            {
                                var newFormJson = JObject.Parse(genericformSubmittedUpsertInputModel.FormJson);
                                var oldFormJson = JObject.Parse(genericformSubmittedUpsertInputModel.OldFormJson);
                                List<string> fieldChanges = new List<string>();

                                foreach (var n in newFormJson)
                                {
                                    foreach (var o in oldFormJson)
                                    {
                                        if (n.Key == o.Key)
                                        {
                                            bool blChange = String.Equals(n.Value, o.Value);
                                            if (!blChange)
                                            {
                                                fieldChanges.Add(n.Key);
                                            }
                                        }
                                    }

                                }
                                foreach (var flow in fieldflows)
                                {
                                    WorkFlowTriggerModel workFlowTriggerModel = new WorkFlowTriggerModel();
                                    List<string> vsFields = flow.DataJson.FieldNames.ToList();
                                    bool blexWorkflow = false;

                                    foreach (var fd in fieldChanges)
                                    {
                                        foreach (var f in vsFields)
                                            if (fd.Equals(f))
                                                blexWorkflow = true;

                                    }
                                    //if any of the field updated then workflow wil executes
                                    if (blexWorkflow)
                                    {
                                        List<FieldUpdateModel> fieldUpdateModel = JsonConvert.DeserializeObject<List<FieldUpdateModel>>(flow.DataJson.WorkflowItems);
                                        fieldUpdateModel = fieldUpdateModel.Where(x => x.InputParamSteps != null && x.InputParamSteps.Count > 0 && x.Type == 2).ToList();
                                        List<FieldUpdateModel> fieldUpdateModelList = new List<FieldUpdateModel>();
                                        foreach (var model in fieldUpdateModel)
                                        {
                                            var paramsModel = model.InputParamSteps;
                                            foreach (var param in paramsModel)
                                            {
                                                var updateModel = new FieldUpdateModel();
                                                updateModel.FormId = model.FormId;
                                                updateModel.SyncForm = model.SyncForm;
                                                updateModel.DataSetId = model.DataSetId;
                                                updateModel.FormName = model.FormName;
                                                updateModel.FieldName = param.FieldName;
                                                updateModel.FieldValue = param.FieldValue;
                                                fieldUpdateModelList.Add(updateModel);
                                            }
                                        }

                                        workFlowTriggerModel.IsArchived = false;
                                        workFlowTriggerModel.WorkFlowTypeId = flow.DataJson.WorkflowTypeId;
                                        workFlowTriggerModel.WorkflowName = flow.DataJson.WorkflowName;
                                        workFlowTriggerModel.WorkflowXml = flow.DataJson.Xml;
                                        workFlowTriggerModel.FieldUniqueId = flow.DataJson.FieldUniqueId;
                                        workFlowTriggerModel.FieldUpdateModel = fieldUpdateModelList;
                                        workFlowTriggerModel.NotificationMessage = genericformSubmittedUpsertInputModel.NotificationMessage;
                                        genericformSubmittedUpsertInputModel.GenericFormSubmittedId = submissionId;
                                        TaskWrapper.ExecuteFunctionInNewThread(() => StartWorkflowProcessInstanceXml(genericformSubmittedUpsertInputModel, workflowId, workFlowTriggerModel, loggedInContext, validationMessages));
                                    }
                                }
                            }

                            var wflows = workflows.Where(x => x.DataJson.FormTypeId == dataSourceId && (x.DataJson.Action == action || x.DataJson.Action == actions)).ToList();
                            if (wflows.Count > 0)
                            {
                                foreach (var flow in wflows)
                                {
                                    FormDataModel jsonObject = JsonConvert.DeserializeObject<FormDataModel>(genericformSubmittedUpsertInputModel.FormJson);
                                    WorkFlowTriggerModel workFlowTriggerModel = new WorkFlowTriggerModel();
                                    List<WorkflowItem> workflowItems = JsonConvert.DeserializeObject<List<WorkflowItem>>(flow.DataJson.WorkflowItems);
                                    workFlowTriggerModel.IsArchived = false;
                                    workFlowTriggerModel.WorkFlowTypeId = flow.DataJson.WorkflowTypeId;
                                    workFlowTriggerModel.WorkflowName = flow.DataJson.WorkflowName;
                                    workFlowTriggerModel.WorkflowXml = flow.DataJson.Xml;
                                    workFlowTriggerModel.FromData = workflowItems;
                                    workFlowTriggerModel.NotificationMessage = genericformSubmittedUpsertInputModel.NotificationMessage;
                                    //workFlowTriggerModel.To = workflowItems.FirstOrDefault(x => x.Type == 1)?.To;
                                    //workFlowTriggerModel.Bcc = workflowItems.FirstOrDefault(x => x.Type == 1)?.Bcc;
                                    //workFlowTriggerModel.Cc = workflowItems.FirstOrDefault(x => x.Type == 1)?.Cc;
                                    //workFlowTriggerModel.Subject = workflowItems.FirstOrDefault(x => x.Type == 1)?.Subject;
                                    // workFlowTriggerModel.Message = workflowItems.FirstOrDefault(x => x.Type == 1)?.Message;
                                    workFlowTriggerModel.JsonObject = JsonConvert.SerializeObject(jsonObject);
                                    genericformSubmittedUpsertInputModel.GenericFormSubmittedId = submissionId;
                                    TaskWrapper.ExecuteFunctionInNewThread(() => StartWorkflowProcessInstanceXml(genericformSubmittedUpsertInputModel, workflowId, workFlowTriggerModel, loggedInContext, validationMessages));
                                }
                            }
                        }
                    }
                    LoggingManager.Info("Workflow call Ended...");
                }
                catch (Exception ex)
                {
                    LoggingManager.Error("Error throws from workflow call in getgenericformsubmitted" + ex);
                }

                if (originalJson != null && !string.IsNullOrEmpty(originalJson))
                {
                    var jdp = new JsonDiffPatch();
                    JToken diffJsonResult = jdp.Diff(JObject.Parse(originalJson), JObject.Parse(genericformSubmittedUpsertInputModel.FormJson));

                    if (diffJsonResult != null)
                    {
                        foreach (var record in diffJsonResult.Children())
                        {
                            HistoryOutputModel historyRecord = new HistoryOutputModel
                            {
                                Field = record.Path,
                                OldValue = record.First.First.ToString(),
                                NewValue = record.First.Last.ToString()
                            };
                            if(historyRecord.OldValue == historyRecord.NewValue)
                            {
                                historyRecord.OldValue = "same";
                            }
                            if(historyRecord.Field != "['Updated Date']" && historyRecord.Field != "['Updated User']" && historyRecord.Field != "updatedBy" && historyRecord.Field != "createdBy" &&  historyRecord.Field != "['Created Date']" && historyRecord.Field != "['Created User']" && !string.IsNullOrEmpty(historyRecord.OldValue) && !string.IsNullOrEmpty(historyRecord.NewValue))
                            {
                                if(historyRecord.OldValue == "same")
                                {
                                    historyRecord.OldValue = string.Empty;
                                }
                                var dataSetHistoryModel = new DataSetHistoryInputModel();
                                dataSetHistoryModel.DataSetId = submissionId;
                                dataSetHistoryModel.Field = historyRecord.Field;
                                dataSetHistoryModel.OldValue = historyRecord.OldValue ;
                                dataSetHistoryModel.NewValue = historyRecord.NewValue;
                                dataSetHistoryModel.DataSourceId = genericformSubmittedUpsertInputModel.DataSourceId;
                                TaskWrapper.ExecuteFunctionInNewThread(() => _dataSetService.CreateDataSetHistory(dataSetHistoryModel, loggedInContext, validationMessages));
                            }
                        }
                    }
                }
                else
                {
                    HistoryOutputModel historyRecord = new HistoryOutputModel
                    {
                        Field = "",
                        OldValue = string.Empty,
                        NewValue = "",
                        Description = "New record has created"
                    };
                    var dataSetHistoryModel = new DataSetHistoryInputModel();
                    dataSetHistoryModel.DataSetId = submissionId;
                    dataSetHistoryModel.Field = historyRecord.Field;
                    dataSetHistoryModel.OldValue = historyRecord.OldValue;
                    dataSetHistoryModel.NewValue = historyRecord.NewValue;
                    dataSetHistoryModel.Description = historyRecord.Description;
                    dataSetHistoryModel.DataSourceId = genericformSubmittedUpsertInputModel.DataSourceId;
                    TaskWrapper.ExecuteFunctionInNewThread(() => _dataSetService.CreateDataSetHistory(dataSetHistoryModel, loggedInContext, validationMessages));
                    
                }

                TaskWrapper.ExecuteFunctionInNewThread(() =>
                {
                    List<DataSourceKeysConfigurationOutputModel> dataSourceKeysOutputModel = _dataSourceService.SearchDataSourceKeysConfiguration(null, null, null, genericformSubmittedUpsertInputModel.CustomApplicationId, null, loggedInContext, validationMessages).GetAwaiter().GetResult().dataSourceKeys.ToList();
                    var filteredTagDataSourcekeyOutputModel = dataSourceKeysOutputModel.Where(x => x.DataSourceId == genericformSubmittedUpsertInputModel.FormId && x.IsTag == true).ToList();
                    JObject formfield = (JObject)JsonConvert.DeserializeObject(genericformSubmittedUpsertInputModel.FormJson);
                    Dictionary<string, string> keyValueMap = new Dictionary<string, string>();

                    foreach (KeyValuePair<string, JToken> keyValuePair in formfield)
                    {
                        keyValueMap.Add(keyValuePair.Key, keyValuePair.Value.ToString());
                    }
                    foreach (var tagModel in filteredTagDataSourcekeyOutputModel)
                    {
                        string keyName = "";
                        foreach (var keyValue in keyValueMap)
                        {

                            if (keyValue.Key == tagModel.Key)
                            {
                                keyName = keyValue.Value;
                            }
                        }
                        var tagCreationModel = new CustomApplicationTagInputModel();
                        tagCreationModel.CustomApplicationId = genericformSubmittedUpsertInputModel.CustomApplicationId;
                        tagCreationModel.GenericFormSubmittedId = genericformSubmittedUpsertInputModel.GenericFormSubmittedId;
                        tagCreationModel.GenericFormKeyId = tagModel.DataSourceKeyId;
                        tagCreationModel.KeyValue = keyName;
                        tagCreationModel.IsTag = true;
                        Guid? Id = _genericFormRepository.UpsertCustomApplicationTag(tagCreationModel, loggedInContext, validationMessages);
                    }

                    var filteredTrendDataSourcekeyOutputModel = dataSourceKeysOutputModel.Where(x => x.DataSourceId == genericformSubmittedUpsertInputModel.FormId && x.IsTrendsEnable == true).ToList();
                    foreach (var tagModel in filteredTrendDataSourcekeyOutputModel)
                    {
                        string keyName = "";
                        foreach (var keyValue in keyValueMap)
                        {

                            if (keyValue.Key == tagModel.Key)
                            {
                                keyName = keyValue.Value;
                            }
                        }
                        var tagCreationModel = new CustomApplicationTagInputModel();
                        tagCreationModel.CustomApplicationId = genericformSubmittedUpsertInputModel.CustomApplicationId;
                        tagCreationModel.GenericFormSubmittedId = genericformSubmittedUpsertInputModel.GenericFormSubmittedId;
                        tagCreationModel.GenericFormKeyId = tagModel.DataSourceKeyId;
                        tagCreationModel.KeyValue = keyName;
                        tagCreationModel.IsTag = false;
                        Guid? Id = _genericFormRepository.UpsertCustomApplicationTag(tagCreationModel, loggedInContext, validationMessages);
                    }
                });

                return genericformSubmittedUpsertInputModel.GenericFormSubmittedId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGenricFormSubmitted", "DataSourceService", exception.Message), exception);
                return null;
            }
        }

        static string GetValueByKey(string jsonData, string key)
        {
            // Parse the JSON data
            JObject jsonObject = JObject.Parse(jsonData);

            // Extract keys and their values
            foreach (KeyValuePair<string, JToken> keyValuePair in jsonObject)
            {
                // Check if the current key matches the searched key
                if (keyValuePair.Key.Equals(key, StringComparison.OrdinalIgnoreCase))
                {
                    return keyValuePair.Value.ToString();
                }

                // If the value is a nested JSON object, search within it recursively
                if (keyValuePair.Value is JObject nestedObject)
                {
                    string result = GetValueByKey(nestedObject.ToString(), key);
                    if (!string.IsNullOrEmpty(result))
                    {
                        return result;
                    }
                }
            }

            // Return a message if the key is not found
            return null;
        }

        public void RunWorkFlows(RunWorkFlowsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info("Workflow call started...");
                //Get workflow datasource id

                var searchModel = new GenericFormSubmittedSearchInputModel();
                searchModel.GenericFormSubmittedId = inputModel.GenericFormSubmittedId;
                var formDetails = GetGenericFormSubmitted(searchModel, loggedInContext, validationMessages).FirstOrDefault();
                if (formDetails != null && formDetails.DataSourceId != null)
                {
                    Guid? workflowId = Guid.Empty;
                    Guid? dataSourceId = formDetails.DataSourceId;
                    var dataSources = SearchDataSource(null, null, workflowsList, false, null, false, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    if (dataSources != null && dataSources.Count > 0)
                    {
                        dataSources = dataSources.Where(x => x.DataSourceType == "Workflows").ToList();
                        workflowId = dataSources[0].Id;
                        var workflows = SearchDataSets(null, workflowId, null, false, null, null, null, loggedInContext, validationMessages).GetAwaiter().GetResult();
                        var flows = workflows.Where(x => x.DataJson.FormTypeId == dataSourceId).ToList();

                        if (flows.Count > 0)
                        {
                            var wflows = workflows.Where(x => x.DataJson.FormTypeId == dataSourceId && (x.DataJson.Action == inputModel.Action)).ToList();
                            if (wflows.Count > 0)
                            {
                                foreach (var flow in wflows)
                                {
                                    WorkFlowTriggerModel workFlowTriggerModel = new WorkFlowTriggerModel();
                                    List<WorkflowItem> workflowItems = JsonConvert.DeserializeObject<List<WorkflowItem>>(flow.DataJson.WorkflowItems);
                                    workFlowTriggerModel.IsArchived = false;
                                    workFlowTriggerModel.WorkFlowTypeId = flow.DataJson.WorkflowTypeId;
                                    workFlowTriggerModel.WorkflowName = flow.DataJson.WorkflowName;
                                    workFlowTriggerModel.WorkflowXml = flow.DataJson.Xml;
                                    workFlowTriggerModel.FromData = workflowItems;
                                    TaskWrapper.ExecuteFunctionInNewThread(() => StartWorkflowProcessInstanceXml(new GenericFormSubmittedUpsertInputModel(), workflowId, workFlowTriggerModel, loggedInContext, validationMessages));
                                }
                            }
                        }
                    }
                }
                else
                {
                    LoggingManager.Error("Getting datasourceId as null unable to proceed");
                }

                LoggingManager.Info("Workflow call Ended...");
            }
            catch (Exception ex)
            {
                LoggingManager.Error("Error throws from workflow call in getgenericformsubmitted" + ex);
            }
        }

        public async Task UpsertGenericFormSubmittedFromExcel(GenericFormSubmittedFromExcelInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGenericFormSubmittedFromExcel", "UpsertGenericFormService"));

            var sqlInputModel = new DailyUploadExcelsInputModel
            {
                ExcelSheetName = inputModel?.ExcelSheetName,
                IsUploaded = true,
                IsHavingErrors = false,
                NeedManualCorrection = false,
                ErrorText = string.Empty
            };

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                LoggingManager.Error("Not a valid user in UpsertGenericFormSubmittedFromExcel");
                sqlInputModel.IsHavingErrors = true;
                sqlInputModel.NeedManualCorrection = true;
                sqlInputModel.ErrorText = "Not a valid user";
                _dailyUploadExcelRepository.UpsertExcelToCustomApplicationDetails(sqlInputModel, true, loggedInContext, validationMessages);
                return;
            }

            if (inputModel != null && inputModel.FormJson != null && inputModel.FormJson.Count > 0)
            {
                var errorRowNumbers = new List<int>();
                int rowIndex = 0;
                var errorText = string.Empty;

                foreach (var data in inputModel.FormJson)
                {
                    rowIndex++;
                    var id = Guid.NewGuid();

                    try
                    {
                        var dataSetUpsertInputModel = new DataSetUpsertInputModel
                        {
                            IsArchived = false,
                            CompanyId = loggedInContext.CompanyGuid,
                            DataSourceId = inputModel.DataSourceId ?? inputModel.FormId,
                            Id = id,
                            IsNewRecord = true,
                            DataJson = JsonConvert.SerializeObject(new DataSetConversionModel
                            {
                                CustomApplicationId = inputModel.CustomApplicationId,
                                ContractType = "Form",
                                InvoiceType = "CustomApplication",
                                FormData = JsonConvert.DeserializeObject<object>(data)
                            })
                        };
                        inputModel.GenericFormSubmittedId = await _dataSetService.CreateDataSetGeneriForm(dataSetUpsertInputModel, loggedInContext, validationMessages);
                        var submissionId = id;

                        //History Saving Start
                        var jdp = new JsonDiffPatch();
                        JToken diffJsonResult = jdp.Diff(JObject.Parse("{}"), JObject.Parse(data));
                        LoggingManager.Info("Saving history for excel uploaded form records");
                        if (diffJsonResult != null)
                        {
                            foreach (var record in diffJsonResult.Children())
                            {
                                HistoryOutputModel historyRecord = new HistoryOutputModel
                                {
                                    Field = record.Path,
                                    OldValue = string.Empty,
                                    NewValue = record.First.Last.ToString()
                                };
                                var dataSetHistoryModel = new DataSetHistoryInputModel();
                                dataSetHistoryModel.DataSetId = submissionId;
                                dataSetHistoryModel.Field = historyRecord.Field;
                                dataSetHistoryModel.OldValue = historyRecord.OldValue;
                                dataSetHistoryModel.NewValue = historyRecord.NewValue;

                                TaskWrapper.ExecuteFunctionInNewThread(() => _dataSetService.CreateDataSetHistory(dataSetHistoryModel, loggedInContext, validationMessages));
                            }
                        }
                        //History Saving End
                    }
                    catch (Exception exception)
                    {
                        errorRowNumbers.Add(rowIndex);
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGenricFormSubmitted", "DataSourceService", exception.Message), exception);
                    }
                }
                if (errorRowNumbers.Count > 0)
                {
                    sqlInputModel.IsHavingErrors = true;
                    sqlInputModel.ErrorText = $"Rows with errors: {string.Join(",", errorRowNumbers)}";
                    LoggingManager.Error(sqlInputModel.ErrorText);
                }

                // API call for saving data into SQL Table
                _dailyUploadExcelRepository.UpsertExcelToCustomApplicationDetails(sqlInputModel, true, loggedInContext , validationMessages);
            }
        }

        public async Task<Guid?> UpsertGenricFormSubmittedUnAuth(GenericFormSubmittedUpsertInputModel genericformSubmittedUpsertInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGenricFormSubmittedUnAuth", "GenericFormSubmitted Api"));
                var formId = genericformSubmittedUpsertInputModel.GenericFormSubmittedId;

                string originalJson = string.Empty;
                List<HistoryOutputModel> historyList = new List<HistoryOutputModel>();
                string historyXml;

                DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();
                dataSetUpsertInputModel.IsArchived = genericformSubmittedUpsertInputModel.IsArchived;
                var dataSetModel = new DataSetConversionModel();
                dataSetModel.CustomApplicationId = genericformSubmittedUpsertInputModel.CustomApplicationId;
                dataSetModel.ContractType = "Form";
                dataSetModel.InvoiceType = "CustomApplication";
                if (genericformSubmittedUpsertInputModel.Status != null)
                {
                    if (genericformSubmittedUpsertInputModel.IsApproved ?? false)
                        dataSetModel.Status = "Approved";
                    else
                        dataSetModel.Status = genericformSubmittedUpsertInputModel.Status;
                }
                else
                {
                    dataSetModel.Status = "Draft";

                }

                dataSetModel.FormData = JsonConvert.DeserializeObject<Object>(genericformSubmittedUpsertInputModel.FormJson);

                dataSetModel.UniqueNumber = genericformSubmittedUpsertInputModel.UniqueNumber;
                dataSetModel.IsApproved = genericformSubmittedUpsertInputModel.IsApproved;
                dataSetUpsertInputModel.DataJson = JsonConvert.SerializeObject(dataSetModel);
                //dataSetUpsertInputModel.CompanyId = loggedInContext.CompanyGuid;
                dataSetUpsertInputModel.DataSourceId = genericformSubmittedUpsertInputModel.DataSourceId != null ? genericformSubmittedUpsertInputModel.DataSourceId : genericformSubmittedUpsertInputModel.FormId;
                dataSetUpsertInputModel.Id = genericformSubmittedUpsertInputModel.GenericFormSubmittedId;
                dataSetUpsertInputModel.IsNewRecord = genericformSubmittedUpsertInputModel.IsNewRecord;
                dataSetUpsertInputModel.SubmittedUserId = genericformSubmittedUpsertInputModel.SubmittedUserId;
                dataSetUpsertInputModel.SubmittedCompanyId = genericformSubmittedUpsertInputModel.SubmittedCompanyId;
                dataSetUpsertInputModel.SubmittedByFormDrill = genericformSubmittedUpsertInputModel.SubmittedByFormDrill;
                if (dataSetUpsertInputModel.Id != null && dataSetUpsertInputModel.IsNewRecord == false)
                {
                    var searchModel = new GenericFormSubmittedSearchInputModel();
                    searchModel.GenericFormSubmittedId = dataSetUpsertInputModel.Id;
                    var formDetails = GetGenericFormSubmittedUnAuth(searchModel, validationMessages).FirstOrDefault();
                    if (formDetails != null)
                    {
                        originalJson = formDetails.FormJson;
                        genericformSubmittedUpsertInputModel.OldFormJson = originalJson;
                    }

                }
                genericformSubmittedUpsertInputModel.GenericFormSubmittedId = await _dataSetService.CreateDataSetGeneriFormUnAuth(dataSetUpsertInputModel, validationMessages);
                var submissionId = genericformSubmittedUpsertInputModel.DataSetId;
                //if (genericformSubmittedUpsertInputModel.FormJson != null && genericformSubmittedUpsertInputModel.IsAbleToLogin == true)
                //{
                //    var userData = JsonConvert.DeserializeObject<UserInputModel>(genericformSubmittedUpsertInputModel.FormJson);
                //    var password = userData.Password == null ? userData.Password2 : userData.Password;
                //    userData.Password = userData.Password == null ? userData.Password2 : userData.Password;
                //    userData.Email = userData.Email == null ? userData.Email2 : userData.Email;
                //    userData.MobileNo = userData.MobileNo == null ? userData.PhoneNumber2 : userData.MobileNo;
                //    userData.SurName = userData.SurName == null ? userData.LastName : userData.SurName;
                //    userData.Password = Utilities.GetSaltedPassword(userData.Password);
                //    userData.ReferenceId = submissionId;
                //    userData.IsActive = genericformSubmittedUpsertInputModel.IsArchived == null ? true : !(genericformSubmittedUpsertInputModel.IsArchived.Value);

                //    _userRepository.UpsertUserDetails(userData, loggedInContext, validationMessages);

                //    if (validationMessages.Count == 0 && genericformSubmittedUpsertInputModel.GenericFormSubmittedId == null)
                //    {
                //        UserRegistrationDetailsModel userRegistrationDetails = new UserRegistrationDetailsModel()
                //        {
                //            UserName = userData.Email,
                //            FirstName = userData.FirstName,
                //            SurName = userData.SurName,
                //            RoleIds = userData.Role,
                //            Password = userData.Password ?? userData.Password2
                //        };

                //        BackgroundJob.Enqueue(() => _hrManagementService.SendUserRegistrationMail(userRegistrationDetails, loggedInContext, validationMessages));
                //    }
                //}
                //To call the workflows of the form

                //try
                //{
                //    LoggingManager.Info("Workflow call started...");
                //    //Get workflow datasource id

                //    Guid? workflowId = Guid.Empty;
                //    Guid? dataSourceId = genericformSubmittedUpsertInputModel.DataSourceId;
                //    var dataSources = SearchDataSourceUnAuth(null, null, workflowsList, false,null, validationMessages).GetAwaiter().GetResult();
                //    if (dataSources != null && dataSources.Count > 0)
                //    {
                //        workflowId = dataSources[0].Id;
                //        var workflows = SearchDataSetsUnAuth(null, workflowId, null, false,null,null, validationMessages).GetAwaiter().GetResult();
                //        var flows = workflows.Where(x => x.DataJson.FormTypeId == dataSourceId).ToList();

                //        if (flows.Count > 0)
                //        {
                //            //For create or edit
                //            string actions = string.Empty;
                //            string action = string.Empty;
                //            if (genericformSubmittedUpsertInputModel.IsNewRecord == false)
                //            {
                //                var newFormJson = JObject.Parse(genericformSubmittedUpsertInputModel.FormJson);
                //                var oldFormJson = JObject.Parse(genericformSubmittedUpsertInputModel.OldFormJson);
                //                if (oldFormJson.ContainsKey("IsApprove") &&
                //                    newFormJson.ContainsKey("IsApprove") &&
                //                    (string)newFormJson["IsApprove"] != (string)oldFormJson["IsApprove"] &&
                //                    (string)newFormJson["IsApprove"] == "Approve")
                //                {
                //                    action = "Approve";
                //                }
                //                else if (oldFormJson.ContainsKey("IsApprove") &&
                //                    newFormJson.ContainsKey("IsApprove") &&
                //                    (string)newFormJson["IsApprove"] != (string)oldFormJson["IsApprove"] &&
                //                    (string)newFormJson["IsApprove"] == "Reject")
                //                {
                //                    action = "Reject";
                //                }
                //                else
                //                {
                //                    action = "Edit";
                //                    actions = "Create or Edit";
                //                }
                //            }
                //            if (genericformSubmittedUpsertInputModel.IsNewRecord == true)
                //            {
                //                action = "Create";
                //                actions = "Create or Edit";
                //            }
                //            if (genericformSubmittedUpsertInputModel.IsArchived == true)
                //            {
                //                action = "Delete";
                //            }
                //            //Field update
                //            //select field update flows

                //            var fieldflows = workflows.Where(x => x.DataJson.FormTypeId == dataSourceId && x.DataJson.Action == "Field Update").ToList();
                //            if (fieldflows.Count > 0 && genericformSubmittedUpsertInputModel.IsNewRecord == false)
                //            {
                //                var newFormJson = JObject.Parse(genericformSubmittedUpsertInputModel.FormJson);
                //                var oldFormJson = JObject.Parse(genericformSubmittedUpsertInputModel.OldFormJson);
                //                List<string> fieldChanges = new List<string>();

                //                foreach (var n in newFormJson)
                //                {
                //                    foreach (var o in oldFormJson)
                //                    {
                //                        if (n.Key == o.Key)
                //                        {
                //                            bool blChange = String.Equals(n.Value, o.Value);
                //                            if (!blChange)
                //                            {
                //                                fieldChanges.Add(n.Key);
                //                            }
                //                        }
                //                    }

                //                }
                //                foreach (var flow in fieldflows)
                //                {
                //                    WorkFlowTriggerModel workFlowTriggerModel = new WorkFlowTriggerModel();
                //                    List<string> vsFields = flow.DataJson.FieldNames.ToList();
                //                    bool blexWorkflow = false;

                //                    foreach (var fd in fieldChanges)
                //                    {
                //                        foreach (var f in vsFields)
                //                            if (fd.Equals(f))
                //                                blexWorkflow = true;

                //                    }
                //                    //if any of the field updated then workflow wil executes
                //                    if (blexWorkflow)
                //                    {
                //                        List<FieldUpdateModel> fieldUpdateModel = JsonConvert.DeserializeObject<List<FieldUpdateModel>>(flow.DataJson.WorkflowItems);
                //                        fieldUpdateModel = fieldUpdateModel.Where(x => x.InputParamSteps != null && x.InputParamSteps.Count > 0 && x.Type == 2).ToList();
                //                        List<FieldUpdateModel> fieldUpdateModelList = new List<FieldUpdateModel>();
                //                        foreach(var model in fieldUpdateModel)
                //                        {
                //                            var paramsModel = model.InputParamSteps;
                //                            foreach(var param in paramsModel)
                //                            {
                //                                var updateModel = new FieldUpdateModel();
                //                                updateModel.FormId     = model.FormId;
                //                                updateModel.SyncForm   = model.SyncForm;
                //                                updateModel.DataSetId  = model.DataSetId;
                //                                updateModel.FormName   = model.FormName;
                //                                updateModel.FieldName  = param.FieldName;
                //                                updateModel.FieldValue = param.FieldValue;
                //                                fieldUpdateModelList.Add(updateModel);
                //                            }
                //                        }

                //                        workFlowTriggerModel.IsArchived = false;
                //                        workFlowTriggerModel.WorkFlowTypeId = flow.DataJson.WorkflowTypeId;
                //                        workFlowTriggerModel.WorkflowName = flow.DataJson.WorkflowName;
                //                        workFlowTriggerModel.WorkflowXml = flow.DataJson.Xml;
                //                        workFlowTriggerModel.FieldUniqueId = flow.DataJson.FieldUniqueId;
                //                        workFlowTriggerModel.FieldUpdateModel = fieldUpdateModelList;
                //                        genericformSubmittedUpsertInputModel.GenericFormSubmittedId = submissionId;
                //                        TaskWrapper.ExecuteFunctionInNewThread(() => StartWorkflowProcessInstanceXml(genericformSubmittedUpsertInputModel, workflowId, workFlowTriggerModel, loggedInContext, validationMessages));
                //                    }
                //                }
                //            }

                //            var wflows = workflows.Where(x => x.DataJson.FormTypeId == dataSourceId && (x.DataJson.Action == action || x.DataJson.Action == actions)).ToList();
                //            if (wflows.Count > 0)
                //            {
                //                foreach (var flow in wflows)
                //                {
                //                    FormDataModel jsonObject = JsonConvert.DeserializeObject<FormDataModel>(genericformSubmittedUpsertInputModel.FormJson);
                //                    WorkFlowTriggerModel workFlowTriggerModel = new WorkFlowTriggerModel();
                //                    List<WorkflowItem> workflowItems = JsonConvert.DeserializeObject<List<WorkflowItem>>(flow.DataJson.WorkflowItems);
                //                    workFlowTriggerModel.IsArchived = false;
                //                    workFlowTriggerModel.WorkFlowTypeId = flow.DataJson.WorkflowTypeId;
                //                    workFlowTriggerModel.WorkflowName = flow.DataJson.WorkflowName;
                //                    workFlowTriggerModel.WorkflowXml = flow.DataJson.Xml;
                //                    workFlowTriggerModel.FromData = workflowItems;
                //                    //workFlowTriggerModel.To = workflowItems.FirstOrDefault(x => x.Type == 1)?.To;
                //                    //workFlowTriggerModel.Bcc = workflowItems.FirstOrDefault(x => x.Type == 1)?.Bcc;
                //                    //workFlowTriggerModel.Cc = workflowItems.FirstOrDefault(x => x.Type == 1)?.Cc;
                //                    //workFlowTriggerModel.Subject = workflowItems.FirstOrDefault(x => x.Type == 1)?.Subject;
                //                    // workFlowTriggerModel.Message = workflowItems.FirstOrDefault(x => x.Type == 1)?.Message;
                //                    workFlowTriggerModel.JsonObject = JsonConvert.SerializeObject(jsonObject);
                //                    genericformSubmittedUpsertInputModel.GenericFormSubmittedId = submissionId;
                //                    TaskWrapper.ExecuteFunctionInNewThread(() => StartWorkflowProcessInstanceXml(genericformSubmittedUpsertInputModel, workflowId, workFlowTriggerModel, loggedInContext, validationMessages));
                //                }
                //            }
                //        }
                //    }
                //    LoggingManager.Info("Workflow call Ended...");
                //}
                //catch (Exception ex)
                //{
                //    LoggingManager.Error("Error throws from workflow call in getgenericformsubmitted" + ex);
                //}

                //if (originalJson != null && !string.IsNullOrEmpty(originalJson))
                //{
                //    var jdp = new JsonDiffPatch();
                //    JToken diffJsonResult = jdp.Diff(JObject.Parse(originalJson), JObject.Parse(genericformSubmittedUpsertInputModel.FormJson));

                //    if (diffJsonResult != null)
                //    {
                //        foreach (var record in diffJsonResult.Children())
                //        {
                //            HistoryOutputModel historyRecord = new HistoryOutputModel
                //            {
                //                Field = record.Path,
                //                OldValue = record.First.First.ToString(),
                //                NewValue = record.First.Last.ToString()
                //            };
                //            var dataSetHistoryModel = new DataSetHistoryInputModel();
                //            dataSetHistoryModel.DataSetId = submissionId;
                //            dataSetHistoryModel.Field = historyRecord.Field;
                //            dataSetHistoryModel.OldValue = historyRecord.OldValue;
                //            dataSetHistoryModel.NewValue = historyRecord.NewValue;

                //            TaskWrapper.ExecuteFunctionInNewThread(() => _dataSetService.CreateDataSetHistory(dataSetHistoryModel, loggedInContext, validationMessages));
                //        }
                //    }
                //}
                //else
                //{
                //    var jdp = new JsonDiffPatch();
                //    JToken diffJsonResult = jdp.Diff(JObject.Parse("{}"), JObject.Parse(genericformSubmittedUpsertInputModel.FormJson));

                //    if (diffJsonResult != null)
                //    {
                //        foreach (var record in diffJsonResult.Children())
                //        {
                //            HistoryOutputModel historyRecord = new HistoryOutputModel
                //            {
                //                Field = record.Path,
                //                OldValue = string.Empty,
                //                NewValue = record.First.Last.ToString()
                //            };
                //            var dataSetHistoryModel = new DataSetHistoryInputModel();
                //            dataSetHistoryModel.DataSetId = submissionId;
                //            dataSetHistoryModel.Field = historyRecord.Field;
                //            dataSetHistoryModel.OldValue = historyRecord.OldValue;
                //            dataSetHistoryModel.NewValue = historyRecord.NewValue;

                //            TaskWrapper.ExecuteFunctionInNewThread(() => _dataSetService.CreateDataSetHistory(dataSetHistoryModel, loggedInContext, validationMessages));
                //        }
                //    }
                //}

                //TaskWrapper.ExecuteFunctionInNewThread(() =>
                //{
                //    List<DataSourceKeysConfigurationOutputModel> dataSourceKeysOutputModel = _dataSourceService.SearchDataSourceKeysConfiguration(null, null, null, genericformSubmittedUpsertInputModel.CustomApplicationId, null, loggedInContext, validationMessages).GetAwaiter().GetResult().dataSourceKeys.ToList();
                //    var filteredTagDataSourcekeyOutputModel = dataSourceKeysOutputModel.Where(x => x.DataSourceId == genericformSubmittedUpsertInputModel.FormId && x.IsTag == true).ToList();
                //    JObject formfield = (JObject)JsonConvert.DeserializeObject(genericformSubmittedUpsertInputModel.FormJson);
                //    Dictionary<string, string> keyValueMap = new Dictionary<string, string>();

                //    foreach (KeyValuePair<string, JToken> keyValuePair in formfield)
                //    {
                //        keyValueMap.Add(keyValuePair.Key, keyValuePair.Value.ToString());
                //    }
                //    foreach (var tagModel in filteredTagDataSourcekeyOutputModel)
                //    {
                //        string keyName = "";
                //        foreach (var keyValue in keyValueMap)
                //        {

                //            if (keyValue.Key == tagModel.Key)
                //            {
                //                keyName = keyValue.Value;
                //            }
                //        }
                //        var tagCreationModel = new CustomApplicationTagInputModel();
                //        tagCreationModel.CustomApplicationId = genericformSubmittedUpsertInputModel.CustomApplicationId;
                //        tagCreationModel.GenericFormSubmittedId = genericformSubmittedUpsertInputModel.GenericFormSubmittedId;
                //        tagCreationModel.GenericFormKeyId = tagModel.DataSourceKeyId;
                //        tagCreationModel.KeyValue = keyName;
                //        tagCreationModel.IsTag = true;
                //        Guid? Id = _genericFormRepository.UpsertCustomApplicationTag(tagCreationModel, loggedInContext, validationMessages);
                //    }

                //    var filteredTrendDataSourcekeyOutputModel = dataSourceKeysOutputModel.Where(x => x.DataSourceId == genericformSubmittedUpsertInputModel.FormId && x.IsTrendsEnable == true).ToList();
                //    foreach (var tagModel in filteredTrendDataSourcekeyOutputModel)
                //    {
                //        string keyName = "";
                //        foreach (var keyValue in keyValueMap)
                //        {

                //            if (keyValue.Key == tagModel.Key)
                //            {
                //                keyName = keyValue.Value;
                //            }
                //        }
                //        var tagCreationModel = new CustomApplicationTagInputModel();
                //        tagCreationModel.CustomApplicationId = genericformSubmittedUpsertInputModel.CustomApplicationId;
                //        tagCreationModel.GenericFormSubmittedId = genericformSubmittedUpsertInputModel.GenericFormSubmittedId;
                //        tagCreationModel.GenericFormKeyId = tagModel.DataSourceKeyId;
                //        tagCreationModel.KeyValue = keyName;
                //        tagCreationModel.IsTag = false;
                //        Guid? Id = _genericFormRepository.UpsertCustomApplicationTag(tagCreationModel, loggedInContext, validationMessages);
                //    }
                //});

                return genericformSubmittedUpsertInputModel.GenericFormSubmittedId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGenricFormSubmittedUnAuth", "DataSourceService", exception.Message), exception);
                return null;
            }
        }


        public string UpsertPublicGenericFormSubmitted(GenericFormSubmittedUpsertInputModel genericformSubmittedUpsertInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPublicGenericFormSubmitted", "GenericForm Service"));
            DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();
            dataSetUpsertInputModel.IsArchived = genericformSubmittedUpsertInputModel.IsArchived;
            var dataSetModel = new DataSetConversionModel();
            dataSetModel.CustomApplicationId = genericformSubmittedUpsertInputModel.CustomApplicationId;
            dataSetModel.FormData = JsonConvert.DeserializeObject<Object>(genericformSubmittedUpsertInputModel.FormJson);
            if (genericformSubmittedUpsertInputModel.UniqueNumber == null)
            {
                int? dataSetCount = _dataSetService.GetPublicDataSetsCountBasedOnTodaysCount(validationMessages).GetAwaiter().GetResult();
                string todayDate = DateTime.Now.ToString("ddMyyyy");
                string UniqueNumber = todayDate + (dataSetCount + 1);
                genericformSubmittedUpsertInputModel.UniqueNumber = UniqueNumber;

            }
            dataSetModel.UniqueNumber = genericformSubmittedUpsertInputModel.UniqueNumber;
            dataSetUpsertInputModel.DataJson = JsonConvert.SerializeObject(dataSetModel);
            dataSetUpsertInputModel.DataSourceId = genericformSubmittedUpsertInputModel.DataSourceId;
            dataSetUpsertInputModel.Id = genericformSubmittedUpsertInputModel.GenericFormSubmittedId;
            genericformSubmittedUpsertInputModel.GenericFormSubmittedId = _dataSetService.CreatePublicDataSet(dataSetUpsertInputModel, validationMessages).GetAwaiter().GetResult();

            return genericformSubmittedUpsertInputModel.UniqueNumber;
        }

        private void StartWorkflowProcessInstance(
            GenericFormSubmittedUpsertInputModel genericformSubmittedUpsertInputModel, LoggedInContext loggedInContext,
            CustomApplicationWorkflowSearchOutputModel workflowModel, Guid? formId)
        {
            XmlDocument document = new XmlDocument();

            document.LoadXml(workflowModel.WorkflowXml);

            XmlAttributeCollection xmlAttributeCollection = document.GetElementsByTagName("bpmn:definitions")[0]?.ChildNodes[0]?.Attributes;

            if (xmlAttributeCollection != null)
            {
                var workflowName = xmlAttributeCollection["id"]?.InnerText.Trim();
                var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];


                CamundaEngineClient camundaEngineClient = new CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);
                var parametersNeedToSendToAWorkflow = new Dictionary<string, object>
                {
                    {"customApplicationId", genericformSubmittedUpsertInputModel.CustomApplicationId},
                    {"submittedFormId", genericformSubmittedUpsertInputModel.GenericFormSubmittedId},
                    {"loggedUserId", loggedInContext.LoggedInUserId},
                    {"companyId", loggedInContext.CompanyGuid},
                    {"authorization", loggedInContext.authorization},
                    {"appUrl", ConfigurationManager.AppSettings["SiteUrl"]},
                    {"formJson", genericformSubmittedUpsertInputModel.FormJson}
                };

                var json = JToken.Parse(genericformSubmittedUpsertInputModel.FormJson);
                // var fieldsCollector = new JsonFieldsCollector(json);
                //  var fields = fieldsCollector.GetAllFields();

                //foreach (var field in fields)
                //{
                //    parametersNeedToSendToAWorkflow.Add(field.Key, field.Value);
                //}

                var processInstanceId = camundaEngineClient.BpmnWorkflowService.StartProcessInstance(workflowName, parametersNeedToSendToAWorkflow);

                var corpSiteApi = camundaApiBaseUrl + "/engine-rest/engine/default/process-instance/" + processInstanceId + "/activity-instances";
                RestClient client = new RestClient(corpSiteApi);
                RestRequest request = new RestRequest();

                // Use the Method property to set the HTTP method
                request.Method = Method.GET;

                client.Execute(request);
            }
        }

        public List<GetCustomeApplicationTagOutputModel> GetCustomApplicationTag(GetCustomApplicationTagInpuModel getCustomApplicationTagInpuModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get CustomApplication Tags ", "GenericForm Api"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _genericFormRepository.GetCustomApplicationTag(getCustomApplicationTagInpuModel, loggedInContext, validationMessages);
        }

        public List<ExcelSheetDetailsOutputModel> GetExcelSheetDetailsForProcessing(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetExcelSheetDetailsForProcessing", "GenericForm Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _genericFormRepository.GetExcelSheetDetailsForProcessing(loggedInContext, validationMessages);
        }

        public List<FilterKeyValuePair> GetCustomApplicationTagKeys(GetCustomApplicationTagInpuModel getCustomApplicationTagInpuModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get CustomApplication Tag Keys", "GenericForm Api"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<FilterKeyValuePair> customApplicationTags = _genericFormRepository.GetCustomApplicationTagKeys(getCustomApplicationTagInpuModel, loggedInContext, validationMessages);

            return customApplicationTags;
        }

        public List<GetTrendsOutputModel> GetTrends(GetTrendsInputModel getTrendsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Trends ", "GenericForm Api"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<GetTrendsOutputModel> trendsList = _genericFormRepository.GetTrends(getTrendsInputModel, loggedInContext, validationMessages);
            foreach (var trend in trendsList)
            {
                List<ParamsInputModel> paramsModel = new List<ParamsInputModel>();
                var referenceModel = new ParamsInputModel();
                referenceModel.Key = "id";
                referenceModel.Value = trend.GenericFormSubmittedId;
                referenceModel.Type = "Guid?";
                paramsModel.Add(referenceModel);

                var referenceIdModel = new ParamsInputModel();
                referenceIdModel.Key = "keyId";
                referenceIdModel.Value = trend.GenericFormKeyId;
                referenceIdModel.Type = "Guid?";
                paramsModel.Add(referenceIdModel);

                var result = ApiWrapper.GetApiCallsWithAuthorisation(RouteConstants.GetDataSetByDataSourceId, ConfigurationManager.AppSettings["MongoApiBaseUrl"], paramsModel, loggedInContext.AccessToken).Result;
                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
                if (responseJson.Success)
                {
                    var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                    var usersList = JsonConvert.DeserializeObject<DataSetKeyOutputModel>(jsonResponse);
                    if (usersList != null)
                    {
                        trend.FormName = usersList.DataSourceName;
                        trend.Key = usersList.Key;

                    }
                    //List<UserOutputModel> userOutputModel = _userRepository.GetAllUsers(userSearchCriteriaInputModel, loggedInContext, validationMessages);

                    //return userOutputModel;
                }
                else
                {
                    if (responseJson?.ApiResponseMessages.Count > 0)
                    {
                        var validationMessage = new ValidationMessage()
                        {
                            ValidationMessaage = responseJson.ApiResponseMessages[0].Message,
                            ValidationMessageType = MessageTypeEnum.Error,
                            Field = responseJson.ApiResponseMessages[0].FieldName
                        };
                        validationMessages.Add(validationMessage);
                    }
                    return new List<GetTrendsOutputModel>();
                }
            }

            return trendsList;
        }
        public List<UserListApiOutputModel> GetUsersBasedonRole(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormsWithField", "GenericForm Api"));

            List<UserListApiOutputModel> values = _genericFormRepository.GetUsersBasedonRole(searchText, loggedInContext, validationMessages);

            return values;
        }

        public async Task<List<DataSourceOutputModel>> SearchDataSource(Guid? id, Guid? companyModuleId, string searchText, bool? isArchived, string formIds,bool? isIncludedAllForms, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages, string validCompanies = null)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSourceApi/SearchDataSource?id=" + id + "&companyModuleId=" + companyModuleId + "&formIds=" + formIds + "&searchText=" + searchText + "&isArchived=" + isArchived + "&validCompanies=" + validCompanies + "&isIncludedAllForms=" + isIncludedAllForms);
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    var response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<DataSourceOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = result.Select(e => new DataSourceOutputModel
                        {
                            Id = e.Id,
                            Key = e.Key,
                            Name = e.Name,
                            FormTypeId = e.FormTypeId,
                            Description = e.Description,
                            DataSourceType = e.DataSourceType,
                            Tags = e.Tags,
                            Fields = JsonConvert.SerializeObject(e.Fields),
                            IsArchived = e.IsArchived,
                            CompanyModuleId = e.CompanyModuleId,
                            CreatedDateTime = e.CreatedDateTime,
                            FieldObject = e.Fields,
                            FormBgColor = e.FormBgColor,
                            ViewFormRoleIds = e.ViewFormRoleIds,
                            EditFormRoleIds = e.EditFormRoleIds

                        }).OrderByDescending(e => e.CreatedDateTime).ToList();
                        return rdata;

                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSourceService", exception.Message), exception);
                return null;
            }
        }
        public async Task<List<DataSourceOutputModel>> SearchDataSourceUnAuth(Guid? id, Guid? companyModuleId, string searchText, bool? isArchived, string formIds, List<ValidationMessage> validationmessages, string validCompanies = null)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSourceApi/SearchDataSourceUnAuth?id=" + id + "&companyModuleId=" + companyModuleId + "&formIds=" + formIds + "&searchText=" + searchText + "&isArchived=" + isArchived + "&validCompanies=" + validCompanies);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    var response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<DataSourceOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = result.Select(e => new DataSourceOutputModel
                        {
                            Id = e.Id,
                            Key = e.Key,
                            Name = e.Name,
                            FormTypeId = e.FormTypeId,
                            Description = e.Description,
                            DataSourceType = e.DataSourceType,
                            Tags = e.Tags,
                            Fields = JsonConvert.SerializeObject(e.Fields),
                            IsArchived = e.IsArchived,
                            CompanyModuleId = e.CompanyModuleId,
                            CreatedDateTime = e.CreatedDateTime,
                            FieldObject = e.Fields,
                            FormBgColor = e.FormBgColor,
                            ViewFormRoleIds = e.ViewFormRoleIds,
                            EditFormRoleIds = e.EditFormRoleIds

                        }).OrderByDescending(e => e.CreatedDateTime).ToList();
                        return rdata;

                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSourceService", exception.Message), exception);
                return null;
            }
        }
        public List<RolesOutputModel> GetRoles(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRoles", "GenericForm Api"));

            _auditService.SaveAudit(AppCommandConstants.GetAllUsersCommandId, searchText, loggedInContext);


            RolesSearchCriteriaInputModel roleSearchCriteriaInputModel = new RolesSearchCriteriaInputModel()
            {
                RoleId = null,
                RoleName = null,
                SearchText = null,
                PageSize = 0,
                PageNumber = 0,
                IsArchived = false,
                CompanyId = loggedInContext.CompanyGuid
            };
            List<ParamsInputModel> inputParams = new List<ParamsInputModel>();
            var paramsModel = new ParamsInputModel();
            paramsModel.Type = "bool?";
            paramsModel.Key = "IsArchived";
            paramsModel.Value = false;
            inputParams.Add(paramsModel);
            var paramsModel1 = new ParamsInputModel();
            paramsModel1.Type = "int";
            paramsModel1.Key = "PageSize";
            paramsModel1.Value = 1000;
            inputParams.Add(paramsModel1);
            var paramsModel2 = new ParamsInputModel();
            paramsModel2.Type = "int";
            paramsModel2.Key = "PageNumber";
            paramsModel2.Value = 1;
            inputParams.Add(paramsModel2);

            var result = ApiWrapper.GetApiCallsWithAuthorisation(RouteConstants.ASGetAllRolesIds, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], inputParams, loggedInContext.AccessToken).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            if (responseJson.Success)
            {
                var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                var usersList = JsonConvert.DeserializeObject<List<RolesOutputModel>>(jsonResponse);
                return usersList;

            }
            else
            {
                if (responseJson?.ApiResponseMessages.Count > 0)
                {
                    var validationMessage = new ValidationMessage()
                    {
                        ValidationMessaage = responseJson.ApiResponseMessages[0].Message,
                        ValidationMessageType = MessageTypeEnum.Error,
                        Field = responseJson.ApiResponseMessages[0].FieldName
                    };
                    validationMessages.Add(validationMessage);
                }
                return new List<RolesOutputModel>();
            }
            return new List<RolesOutputModel>();
        }

        public Guid? ShareGenericFormSubmitted(GenericFormSubmittedSearchInputModel genericFormKeySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenericFormKey", "GenericForm Api"));

            List<GenericFormSubmittedSearchOutputModel> genericFormSubmitted = new List<GenericFormSubmittedSearchOutputModel>();

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            string customApplicationId = null;
            List<ParamsKeyModel> paramsModel = new List<ParamsKeyModel>();

            CustomApplicationSearchInputModel customApplicationSearchInputModel = new CustomApplicationSearchInputModel();
            customApplicationSearchInputModel.FormId = genericFormKeySearchInputModel.FormId;
            customApplicationSearchInputModel.CustomApplicationId = genericFormKeySearchInputModel.CustomApplicationId;

            string list = _customApplicationRepository.GetCustomApplication(customApplicationSearchInputModel, loggedInContext, validationMessages);
            CustomApplicationSearchOutputModel customApplicationSearchOutputModel = new CustomApplicationSearchOutputModel();

            if (!string.IsNullOrEmpty(list))
            {
                customApplicationSearchOutputModel = JsonConvert.DeserializeObject<List<CustomApplicationSearchOutputModel>>(list)?.FirstOrDefault();
            }

            paramsModel = genericFormKeySearchInputModel?.ParamsKeyModel == null ? new List<ParamsKeyModel>() : genericFormKeySearchInputModel?.ParamsKeyModel;

            if (genericFormKeySearchInputModel.CustomApplicationId != null)
            {
                customApplicationId = genericFormKeySearchInputModel.CustomApplicationId.ToString();
                var applicationModel = new ParamsKeyModel();
                applicationModel.KeyName = "CustomApplicationId";
                applicationModel.KeyValue = customApplicationId;
                applicationModel.Type = "Guid";
                paramsModel.Add(applicationModel);
            }

            paramsModel.Add(new ParamsKeyModel
            {
                KeyName = "Status",
                KeyValue = "submitted",
                Type = "string"
            });

            string jsonModel = JsonConvert.SerializeObject(paramsModel);

            List<Guid> users = new List<Guid>();

            if (genericFormKeySearchInputModel?.UserIds?.Count() > 0)
            {
                users = genericFormKeySearchInputModel?.UserIds;
            }

            var dataSets = _dataSetService.SearchDataSetsForForms(genericFormKeySearchInputModel.GenericFormSubmittedId, genericFormKeySearchInputModel.FormId, null, jsonModel, false, genericFormKeySearchInputModel.IsPagingRequired, genericFormKeySearchInputModel.PageNumber, genericFormKeySearchInputModel.PageSize, false, null, null, false, 0, null, null, loggedInContext, validationMessages).GetAwaiter().GetResult();

            Btrak.Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel = new Models.User.UserSearchCriteriaInputModel();

            //userSearchCriteriaInputModel.UserIdsXML = Utilities.ConvertIntoListXml(users);

            List<UserOutputModel> userOutputModels = _userService.GetAllUsers(userSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (users != null && users.Count > 0)
            {
                var userList = userOutputModels.Where(x => users.Contains(Guid.Parse(x.UserId.ToString()))).ToList();
                CompanyThemeModel companyTheme = _companyStructureService.GetCompanyTheme(loggedInContext?.LoggedInUserId);

                var CompanyLogo = companyTheme?.CompanyMainLogo != null ? companyTheme.CompanyMainLogo : "http://todaywalkins.com/Comp_images/Snovasys.png";

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidatorProgramLevelAccessTemplate", "Trading Service"));
                {
                    var toEmails = userList.Select(t => t.Email).ToArray();
                    var mobileNo = userList.Select(t => t.CountryCode + t.MobileNo).ToArray();
                    var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];
                    var RouteAddress = siteDomain + "forms/application-form/" + genericFormKeySearchInputModel.CustomApplicationId + "/" + customApplicationSearchOutputModel.CustomApplicationName.Replace(" ", "%20");
                    var messageBody = $"You have been provided access to details of .Click here to view" + RouteAddress;

                    genericFormKeySearchInputModel.Subject = genericFormKeySearchInputModel.Subject.Replace("##CustomApplication##", customApplicationSearchOutputModel.CustomApplicationName ?? "").Replace("##FormName##", dataSets?.FirstOrDefault()?.DataSourceName ?? "").Replace("##Count##", dataSets?.Count.ToString() ?? "0");
                    genericFormKeySearchInputModel.Message = genericFormKeySearchInputModel.Message
                           .Replace("##Count##", dataSets?.Count.ToString() ?? "0")
                           .Replace("##CustomApplication##", customApplicationSearchOutputModel.CustomApplicationName ?? "")
                           .Replace("##FormName##", dataSets?.FirstOrDefault()?.DataSourceName ?? "")
                           .Replace("##siteUrl##", RouteAddress)
                           .Replace("##CompanyLogo##", CompanyLogo);
                    genericFormKeySearchInputModel.Message = Regex.Replace(genericFormKeySearchInputModel.Message, "(?<=<a\\s+href=\")[^\"]+", RouteAddress);

                    var subject = genericFormKeySearchInputModel.Subject;
                    var html = genericFormKeySearchInputModel.Message;

                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = toEmails,
                        HtmlContent = html,
                        Subject = subject,
                        MailAttachments = null,
                        IsPdf = true
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                }

            }
            return Guid.Empty;
        }

        public string BackgroundLookupLink(Guid customApplicationId, Guid formId, string companyIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                Task.Run(() => BackgroundLookupLinkPrivate(customApplicationId, formId, companyIds, loggedInContext, validationMessages));
                return "Syncing of form is progressing, please check after some time!".ToString();
            }
            catch (Exception e)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "BackgroundLookupLink", "DataSourceService", e.Message), e);
                return e.Message;
            }
        }

        private void BackgroundLookupLinkPrivate(Guid customApplicationId, Guid formId, string companyIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSourceApi/BackgroundLookupLink");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(new { CustomApplicationId = customApplicationId, FormId = formId, CompanyIds = companyIds }), Encoding.UTF8, "application/json");
                var response = client.PostAsync(client.BaseAddress, httpContent).GetAwaiter().GetResult();
                if (response.IsSuccessStatusCode)
                {
                    string apiResponse = response.Content.ReadAsStringAsync().Result;
                    //_notificationService.SendNotification(
                    //       new GenericActivityNotification(
                    //        "The syncing of form " + apiResponse + " is completed",
                    //        loggedInContext.LoggedInUserId,
                    //        loggedInContext.LoggedInUserId
                    //        ), loggedInContext, loggedInContext.LoggedInUserId);

                }
                else
                {
                    //_notificationService.SendNotification(
                    //        new GenericActivityNotification(
                    //         "The syncing of form has errors, please contact administrator",
                    //         loggedInContext.LoggedInUserId,
                    //         loggedInContext.LoggedInUserId
                    //         ), loggedInContext, loggedInContext.LoggedInUserId);
                }
            }
        }

        public async Task<List<string>> UniqueValidation(UniqueValidateModel uvModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSourceApi/GetUniqueValidation");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(uvModel), Encoding.UTF8, "application/json");
                    var response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        string data = JsonConvert.DeserializeObject<Models.FormDataServices.DataServiceOutputModel>(apiResponse).Data.ToString();
                        return JsonConvert.DeserializeObject<List<string>>(data).ToList();

                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSourceService", exception.Message), exception);
                return null;
            }
        }

        public void UpdateLookupChildDataWithNewVar()
        {
            try
            {
                LoggingManager.Info("UpdateLookupChildDataWithNewVar DataSourceService Starting exec");
                Task.Run(() =>
                {
                    using (var client = new HttpClient())
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSourceApi/UpdateLookupChildDataWithNewVar");
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        var response = client.GetAsync(client.BaseAddress).GetAwaiter().GetResult();
                        if (response.IsSuccessStatusCode)
                        {
                            string apiResponse = response.Content.ReadAsStringAsync().Result;
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateLookupChildDataWithNewVar", "DataSourceService", "Success response"));
                        }
                        else
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateLookupChildDataWithNewVar", "DataSourceService", "Error response"));
                        }
                    }
                });
            }
            catch (Exception e)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateLookupChildDataWithNewVar", "DataSourceService", e.Message), e);
            }
        }

        public object GetMongoCollections(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            //var collectionDetails = _dataSetService.GetCollections(loggedInContext, validationMessages).Result;
            //return collectionDetails.Data;
            return null;
        }

        private void DeployWorkFlowDetails(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext)
        {
            try
            {
                XmlDocument document = new XmlDocument();

                if (workFlowTriggerModel.WorkflowXml != null)
                {
                    document.LoadXml(workFlowTriggerModel.WorkflowXml);

                    var workflowName = document.GetElementsByTagName("bpmn:definitions")[0]?.ChildNodes[0]
                        ?.Attributes["id"]?.InnerText.Trim();

                    List<object> files = new List<object>();

                    byte[] array = Encoding.ASCII.GetBytes(workFlowTriggerModel.WorkflowXml);

                    CamundaClient.Dto.FileParameter filePraParameter =
                        new CamundaClient.Dto.FileParameter(array, workflowName + ".bpmn");

                    files.Add((object)filePraParameter);

                    var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];

                    using (StreamReader streamReader = new StreamReader(CamundaClient.Requests.FormUpload.MultipartFormDataPost(camundaApiBaseUrl + "/engine-rest/engine/default/deployment/create", null, null, new Dictionary<string, object>()
                    {
                        {
                            "deployment-name",
                            (object) workflowName
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
                        // List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                        //StartWorkflowProcessInstance(workFlowTriggerModel, loggedInContext, validationMessages);
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeployWorkFlowDetails", "AutomatedWorkflowmanagementServices ", exception.Message), exception);

            }
        }


        public void StartWorkflowProcessInstanceXml(GenericFormSubmittedUpsertInputModel genericFormSubmittedUpsertInputModel, Guid? dataSourceId, WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string addonToMails = null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "StartWorkflowProcessInstanceXml", "GenericForm Service"));

                XmlDocument document = new XmlDocument();

                document.LoadXml(workFlowTriggerModel.WorkflowXml);

                XmlAttributeCollection xmlAttributeCollection = document.GetElementsByTagName("bpmn:definitions")[0]?.ChildNodes[0]?.Attributes;

                var userSearchCriteriaModel = new Btrak.Models.User.UserSearchCriteriaInputModel();
                userSearchCriteriaModel.IsActive = true;
                var usersList = _userService.GetAllUsers(userSearchCriteriaModel, loggedInContext, validationMessages);


                if (xmlAttributeCollection != null)
                {
                    var workflowName = xmlAttributeCollection["id"]?.InnerText.Trim();
                    var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];
                    var mongoBaseURL = WebConfigurationManager.AppSettings["MongoApiBaseUrl"];
                    var sqlConectionString = ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString;
                    var documentBaseURL = WebConfigurationManager.AppSettings["DocumentStorageApiBaseUrl"];
                    var siteDomain = WebConfigurationManager.AppSettings["SiteUrl"];

                    string fieldUpdateModelJson = JsonConvert.SerializeObject(workFlowTriggerModel.FieldUpdateModel);
                    string FromDataJson = "";
                    string formEditLink = siteDomain + "forms/submit-form/" + genericFormSubmittedUpsertInputModel?.DataSourceId.ToString().ToLower()
                                            + "/" + genericFormSubmittedUpsertInputModel?.CustomApplicationId.ToString().ToLower()
                                            + "/" + genericFormSubmittedUpsertInputModel?.DataSetId.ToString().ToLower();
                    LoggingManager.Info(string.Format("sqlConectionString " + sqlConectionString));

                    if (workFlowTriggerModel.FromData != null)
                    {
                        FromDataJson = JsonConvert.SerializeObject(workFlowTriggerModel.FromData.Where(x => x.DataSourceId != null && x.CustomApplicationId != null).Select(x => new { x.Name, x.DataSourceId, x.CustomApplicationId, x.DataJsonKeys, x.IsFileUpload, x.FileUploadKey }));
                    }

                    //Replace conditional expression
                    XmlNodeList xmlCondition = document.GetElementsByTagName("bpmn:conditionExpression");
                    string str = string.Empty;
                    string fieldName = string.Empty;
                    string fieldVal = string.Empty;
                    Dictionary<string, object> param = new Dictionary<string, object>();
                    if (xmlCondition.Count > 0)
                    {
                        var formobj = JObject.Parse(genericFormSubmittedUpsertInputModel.FormJson);
                        foreach (dynamic x in xmlCondition)
                        {
                            var temp = x;
                            str = temp.InnerText;
                            Regex regexObj = new Regex("__.+?__");
                            fieldName = regexObj.Match(str).ToString().Replace("_", "");
                            fieldVal = formobj.ContainsKey(fieldName) ? formobj[fieldName].ToString() : null;

                            if (!param.ContainsKey(regexObj.Match(str).ToString()))
                                param.Add("__" + fieldName + "__", fieldVal);
                        }

                    }


                    CamundaClient.CamundaEngineClient camundaEngineClient = new CamundaClient.CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);
                    string toEmails = null;
                    string bccEmails = null;
                    string ccEmails = null;
                    //var mailModel = workFlowTriggerModel.FromData.Where(x => x.Type == 1).FirstOrDefault();
                    var emailsList = new List<string>();
                    string emailString = null;
                    string notifyToUsersjson = null;
                    if (workFlowTriggerModel.FromData != null && workFlowTriggerModel.FromData.Where(x => x.Type == 21).ToList().Count > 0)
                    {
                        List<UserOutputModel> userModels = new List<UserOutputModel>();

                        notifyToUsersjson = workFlowTriggerModel.FromData.Where(x => x.Type == 21).Select(x => x.NotifyToUsersJson).FirstOrDefault();
                        if (string.IsNullOrEmpty(notifyToUsersjson)) 
                        { 
                            var usersString = workFlowTriggerModel.FromData.Where(x => x.Type == 21).Select(x => x.ToUsersString).FirstOrDefault();
                            var userStringArray = usersString.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                            foreach(var user in userStringArray)
                            {
                                var userDetails = usersList.Where(x => x.Email == user).FirstOrDefault();
                                var newModel = new UserOutputModel();
                                newModel.Email = userDetails.Email;
                                newModel.FullName = userDetails.FullName;
                                newModel.UserId = userDetails.UserId;
                                userModels.Add(newModel);
                            }
                            notifyToUsersjson = JsonConvert.SerializeObject(userModels);
                        }
                    }

                    var parametersNeedToSendToAWorkflow = new Dictionary<string, object>
                    {
                        {"referenceId", workFlowTriggerModel.ReferenceId},
                        {"referenceTypeId", workFlowTriggerModel.ReferenceTypeId},
                        {"loggedUserId", loggedInContext.LoggedInUserId},
                        {"companyId", loggedInContext.CompanyGuid},
                        {"authorization", loggedInContext.authorization},
                        {"mongoBaseURL", mongoBaseURL},
                        {"sqlConectionString",sqlConectionString },
                        {"documentBaseURL", documentBaseURL},
                        {"answer",  workFlowTriggerModel.Answer},
                        {"name",  workFlowTriggerModel.Name},
                        {"dataSourceId", genericFormSubmittedUpsertInputModel?.DataSourceId},
                        {"submittedFromId", genericFormSubmittedUpsertInputModel?.DataSourceId},
                        {"fromDataJson", FromDataJson},
                        {"dataSetId", genericFormSubmittedUpsertInputModel?.DataSetId},
                        {"fileIds",  workFlowTriggerModel.FileIds},
                        {"fieldUpdateModelJson", fieldUpdateModelJson},
                        {"fieldUniqueId" , workFlowTriggerModel.FieldUniqueId },
                        {"jsonObject" , workFlowTriggerModel.JsonObject },
                        {"formEditLink", formEditLink },
                        {"addonToMails", addonToMails },
                        {"isForAuditRecurringMail",  workFlowTriggerModel.IsForAuditRecurringMail == true ? "true" : null},
                        {"navigationUrl",  workFlowTriggerModel.NavigationUrl},
                        {"notifyToUsersJson",  notifyToUsersjson},
                        {"usersJson",  notifyToUsersjson},
                        {"workflowMessage",  genericFormSubmittedUpsertInputModel?.WorkflowMessage},
                        {"workflowSubject",  genericFormSubmittedUpsertInputModel?.WorkflowSubject},
                        {"notificationMessage", workFlowTriggerModel.NotificationMessage }

                    };
                    // Adding conditional params
                    if (param.Count > 0)
                    {
                        foreach (var v in param)
                            parametersNeedToSendToAWorkflow.Add(v.Key, v.Value);
                    }
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Camunda started the workflow " + workflowName, "GenericForm Service"));

                    var processInstanceId = camundaEngineClient.BpmnWorkflowService.StartProcessInstance(workflowName, parametersNeedToSendToAWorkflow);

                    Models.WorkFlow.FormWorkflowInstanceModel workflowModel = new Models.WorkFlow.FormWorkflowInstanceModel();
                    workflowModel.FormSubmittedId = genericFormSubmittedUpsertInputModel?.GenericFormSubmittedId;
                    workflowModel.ProcessInstanceId = processInstanceId;


                    //insert dataset for workflow
                    Guid? datasourceId = Guid.Empty;
                    var dataSources = SearchDataSource(null, null, workflowsInstance, false, null, false, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    if (dataSources != null && dataSources.Count > 0)
                    {
                        foreach (var s in dataSources)
                        {
                            datasourceId = s.Id;
                        }
                    }
                    else
                    {
                        //insert datasource for workflow
                        WorkflowDataSourceModel workflowDataSourceModel = new WorkflowDataSourceModel();
                        workflowDataSourceModel.Description = workflowsInstance;
                        workflowDataSourceModel.Name = workflowsInstance;
                        workflowDataSourceModel.CompanyId = loggedInContext.CompanyGuid;
                        workflowDataSourceModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                        workflowDataSourceModel.DataSourceType = workflowsInstance;
                        workflowDataSourceModel.IsArchived = false;
                        workflowDataSourceModel.Fields = string.Empty;
                        datasourceId = CreateDataSource(workflowDataSourceModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    }

                    WorkflowDataSetModel workflowDataSetModel = new WorkflowDataSetModel();
                    workflowDataSetModel.DataSourceId = Guid.NewGuid(); //datasourceId;
                    workflowDataSetModel.DataJson = JsonConvert.SerializeObject(workflowModel);
                    var submissionId1 = CreateDataSet(workflowDataSetModel, loggedInContext, validationMessages).GetAwaiter().GetResult();

                    if (submissionId1 != null && submissionId1 != Guid.Empty)
                    {
                        var corpSiteApi = camundaApiBaseUrl + "/engine-rest/engine/default/process-instance/" + processInstanceId + "/activity-instances";
                        HttpClient httpClient = new HttpClient();
                        httpClient.GetAsync(corpSiteApi).ConfigureAwait(false);

                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "StartWorkflowProcessInstanceXml", "GenericForm Service"));

            }
            catch (Exception ex)
            {
                LoggingManager.Error("Camunda return error " + ex);
            }
        }

        public List<FormFieldModel> GetFormsFields(FormWorkflowModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenericForms", "GenericForm Api"));

            LoggingManager.Debug(genericFormModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<FormFieldModel> formFields = new List<FormFieldModel>();

            //List<Guid> allFormIds = new List<Guid>();

            //if (!string.IsNullOrEmpty(genericFormModel.FormIds))
            //{
            //    string[] formIds = genericFormModel.FormIds.Split(new[] { ',' });

            //    allFormIds = formIds.Select(Guid.Parse).ToList();

            //    genericFormModel.FormIdsXml = Utilities.ConvertIntoListXml(allFormIds.ToList());
            //}
            //else
            //{
            //    allFormIds.Add((Guid)genericFormModel.Id);
            //}

            //_auditService.SaveAudit(AppCommandConstants.GetGenericFormsCommandId, genericFormModel, loggedInContext);

            //List<DataSourceKeysOutputModel> dataSourcekeys = _dataSourceService.SearchDataSourceKeys(null, genericFormModel.Id , null, loggedInContext, validationMessages).GetAwaiter().GetResult();

            //var dataSources = SearchDataSource(genericFormModel.Id, null, null, genericFormModel.IsArchived, null, loggedInContext, validationMessages, genericFormModel.CompanyIds).GetAwaiter().GetResult();

            ////List<FormFieldModel> genericForms = _genericFormRepository.GetFormsFields(genericFormModel, loggedInContext, validationMessages);

            //var keysList = from dsk in dataSourcekeys where allFormIds.Any(x => x == dsk.DataSourceId) select dsk;

            //var keysListWithForms = from dsk in dataSourcekeys where dataSources.Any(x => x.Id == dsk.DataSourceId) select dsk;

            //foreach (Guid guid in allFormIds)
            //{
            //    var data = dataSources?.Where(t => t.Id == guid).FirstOrDefault();

            //    if (data != null)
            //    {
            //        Parallel.ForEach(keysListWithForms?.Where(t => t.DataSourceId == guid), keys => {

            //            formFields.Add(new FormFieldModel
            //            {
            //                GenericFormId = data.Id,
            //                FormName = data.Name,
            //                Id = keys.Id,
            //                GenericFormKeyId = keys.Id,
            //                Key = keys.Key,
            //                Label = keys.Label,
            //                DataType = keys.Type,
            //                Path = keys.Path
            //            });
            //        });
            //    }

            //}

            if (genericFormModel != null && genericFormModel.Id != null)
            {
                if (!string.IsNullOrWhiteSpace(genericFormModel.FormIds))
                    genericFormModel.FormIds = genericFormModel.FormIds + "," + genericFormModel.Id.ToString();
                else
                    genericFormModel.FormIds = genericFormModel.Id.ToString();
            }

            GetDataSourcesByIdInputModel inputModel = new GetDataSourcesByIdInputModel
            {
                CompanyIds = genericFormModel.CompanyIds,
                FormIds = genericFormModel.FormIds
            };

            List<GetDataSourcesByIdOutputModel> dataSourcesOutpuut = _dataSourceService.GetDataSourcesById(inputModel, loggedInContext, validationMessages).GetAwaiter().GetResult();

            Parallel.ForEach(dataSourcesOutpuut, dataSource =>
            {
                Parallel.ForEach(dataSource.KeySet, keys =>
                {
                    formFields.Add(new FormFieldModel
                    {
                        GenericFormId = dataSource.Id,
                        FormName = dataSource.Name,
                        Id = keys.Id,
                        GenericFormKeyId = keys.Id,
                        Key = keys.Key,
                        Label = keys.Label,
                        DataType = keys.Type,
                        Path = keys.Path
                    });
                });
            });

            return formFields;
        }



        public void StartWorkflowProcessInstance(GenericFormSubmittedUpsertInputModel genericFormSubmittedUpsertInputModel, WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            Guid? formTypeId = workFlowTriggerModel.FormId;
            List<GenericFormSubmittedUpsertInputModel> genericFormSubmittedUpsertInputModelList = new List<GenericFormSubmittedUpsertInputModel>();
            //Get form records datasource id
            Guid? datasourceId = Guid.Empty;
            XmlDocument document = new XmlDocument();
            document.LoadXml(workFlowTriggerModel.WorkflowXml);
            XmlAttributeCollection xmlAttributeCollection = document.GetElementsByTagName("bpmn:definitions")[0]?.ChildNodes[0]?.Attributes;

            if (xmlAttributeCollection != null)
            {
                var workflowName = xmlAttributeCollection["id"]?.InnerText.Trim();
                var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];

                CamundaClient.CamundaEngineClient camundaEngineClient = new CamundaClient.CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);
                var parametersNeedToSendToAWorkflow = new Dictionary<string, object>
                {

                    {"referenceId", workFlowTriggerModel.ReferenceId},
                    {"referenceTypeId", workFlowTriggerModel.ReferenceTypeId},
                    {"loggedUserId", loggedInContext.LoggedInUserId},
                    {"companyId", loggedInContext.CompanyGuid},
                    {"answer",  workFlowTriggerModel.Answer},
                    {"name",  workFlowTriggerModel.Name},
                    { "dataSourceId", genericFormSubmittedUpsertInputModel.DataSourceId},
                    { "dataSetId", genericFormSubmittedUpsertInputModel.DataSetId},
                    {"fileIds",  workFlowTriggerModel.FileIds},
                    {"isForAuditRecurringMail",  workFlowTriggerModel.IsForAuditRecurringMail == true ? "true" : null}
                };

                if (formTypeId != null)
                {

                    Guid? wfidatasourceId = Guid.Empty;
                    var dataSources1 = SearchDataSource(null, null, workflowsInstance, false, null,false, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    if (dataSources1 != null && dataSources1.Count > 0)
                    {
                        foreach (var s in dataSources1)
                        {
                            wfidatasourceId = s.Id;
                        }
                    }
                    else
                    {
                        //insert datasource for workflow
                        WorkflowDataSourceModel workflowDataSourceModel = new WorkflowDataSourceModel();
                        workflowDataSourceModel.Description = workflowsInstance;
                        workflowDataSourceModel.Name = workflowsInstance;
                        workflowDataSourceModel.CompanyId = loggedInContext.CompanyGuid;
                        workflowDataSourceModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                        workflowDataSourceModel.DataSourceType = workflowsInstance;
                        workflowDataSourceModel.IsArchived = false;
                        workflowDataSourceModel.Fields = string.Empty;
                        datasourceId = CreateDataSource(workflowDataSourceModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    }

                    Models.WorkFlow.FormWorkflowInstanceModel workflowModel = new Models.WorkFlow.FormWorkflowInstanceModel();

                    var dataSources = SearchDataSource(formTypeId, null, "", false, null,false, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    Guid? datasourceId1 = Guid.Empty;
                    if (dataSources != null && dataSources.Count > 0)
                    {
                        datasourceId1 = dataSources[0].Id;

                        var data = SearchDataSets(null, datasourceId1, "", false, null, null, null, loggedInContext, validationMessages).GetAwaiter().GetResult();

                        var returnData = data.Select(d => new
                        {
                            Id = d.Id,
                            DataSourceId = d.DataSourceId,
                            IsArchived = d.IsArchived,
                            Name = d.Name,
                            FormJson = d.DataJson,
                            FormTypeId = JObject.Parse(d.DataJson.ToString()).ContainsKey("FormTypeId") ? (Guid)JObject.Parse(d.DataJson.ToString())["FormTypeId"] : (Guid?)null,
                        });

                        //loopall the submitted records

                        foreach (var item in returnData)
                        {
                            var isContinue = false;
                            var flowobj = JObject.Parse(workFlowTriggerModel.DataJson.ToString());
                            var cs = JArray.Parse((string)flowobj["CriterialSteps"]).ToList();
                            if (cs.Count() > 0)
                            {
                                var formData = JObject.Parse(item.FormJson.ToString());
                                var formFields = GetFormsFields(new FormfieldWorkFlowModel { Id = item.FormTypeId }, loggedInContext, validationMessages);
                                var conds = new List<bool>();
                                foreach (var c in cs)
                                {
                                    var cName = (string)c["criteriaName"];
                                    var cCondition = (CriteriaType)((int)c["criteriaCondition"]);
                                    var cValue = c["criteriaValue"];
                                    var formKeyAndDataType = formFields.Where(x => x.Key == cName)?.Select(x => new { key = x.Key, dataType = x.Type })?.FirstOrDefault();
                                    var key = formKeyAndDataType.key;
                                    var dataType = formKeyAndDataType.dataType;
                                    var fieldToTest = formData[key].ToString();
                                    switch (cCondition)
                                    {
                                        case CriteriaType.Is:
                                            conds.Add(fieldToTest.Equals($"{cValue.ToString()}"));
                                            break;
                                        case CriteriaType.IsNot:
                                            conds.Add(!fieldToTest.Equals($"{cValue.ToString()}"));
                                            break;
                                        case CriteriaType.IsEmpty:
                                            conds.Add(string.IsNullOrEmpty($"{fieldToTest.ToString()}"));
                                            break;
                                        case CriteriaType.IsNotEmpty:
                                            conds.Add(!string.IsNullOrEmpty($"{fieldToTest.ToString()}"));
                                            break;
                                        case CriteriaType.StartsWith:
                                            var cond = fieldToTest.StartsWith($"{cValue.ToString()}");
                                            conds.Add(cond);
                                            break;
                                        case CriteriaType.EndsWith:
                                            conds.Add(fieldToTest.EndsWith($"{cValue.ToString()}"));
                                            break;
                                        case CriteriaType.Contains:
                                            conds.Add(fieldToTest.Contains($"{cValue.ToString()}"));
                                            break;
                                        case CriteriaType.NotContains:
                                            conds.Add(!fieldToTest.Contains($"{cValue.ToString()}"));
                                            break;
                                    }
                                }
                                if (conds.Contains(false))
                                    isContinue = true;
                                else
                                    isContinue = false;
                            }
                            if (isContinue == true)
                                continue;
                            //Replace conditional expression
                            XmlNodeList xmlCondition = document.GetElementsByTagName("bpmn:conditionExpression");
                            string str = string.Empty;
                            string fieldName = string.Empty;
                            string fieldVal = string.Empty;
                            Dictionary<string, object> param = new Dictionary<string, object>();
                            if (xmlCondition.Count > 0)
                            {
                                var formobj = JObject.Parse(item.FormJson.ToString());
                                foreach (dynamic x in xmlCondition)
                                {
                                    var temp = x;
                                    str = temp.InnerText;
                                    Regex regexObj = new Regex("__.+?__");
                                    fieldName = regexObj.Match(str).ToString().Replace("_", "");
                                    fieldVal = formobj.ContainsKey(fieldName) ? formobj[fieldName].ToString() : null;

                                    if (!param.ContainsKey(regexObj.Match(str).ToString()))
                                        param.Add("__" + fieldName + "__", fieldVal);
                                }

                            }
                            // Adding conditional params
                            if (param.Count > 0)
                            {
                                foreach (var v in param)
                                    parametersNeedToSendToAWorkflow.Add(v.Key, v.Value);
                            }

                            var processInstanceId = camundaEngineClient.BpmnWorkflowService.StartProcessInstance(workflowName, parametersNeedToSendToAWorkflow);
                            //Remove conditions
                            // Adding conditional params
                            if (param.Count > 0)
                            {
                                foreach (var v in param)
                                    parametersNeedToSendToAWorkflow.Remove(v.Key);
                            }
                            workflowModel.FormSubmittedId = item.Id;
                            workflowModel.ProcessInstanceId = processInstanceId;

                            //insert dataset for workflow
                            WorkflowDataSetModel workflowDataSetModel = new WorkflowDataSetModel();
                            workflowDataSetModel.DataSourceId = datasourceId;
                            workflowDataSetModel.DataJson = JsonConvert.SerializeObject(workflowModel);
                            var submissionId1 = CreateDataSet(workflowDataSetModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                            if (submissionId1 != null && submissionId1 != Guid.Empty)
                            {
                                var corpSiteApi = camundaApiBaseUrl + "/engine-rest/engine/default/process-instance/" + processInstanceId + "/activity-instances";
                                RestClient client = new RestClient(corpSiteApi);
                                RestRequest request = new RestRequest();

                                // Use the Method property to set the HTTP method
                                request.Method = Method.GET;

                                client.Execute(request);
                            }
                        }
                    }
                }


            }
        }

        public Guid? UpsertActivity(ActivityModel activitymodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertActivity", "GenericForm Service"));

            LoggingManager.Debug(activitymodel?.ToString());
            if (activitymodel.ActivityName == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessaage = "Activity name cannot be null or empty",
                    ValidationMessageType = MessageTypeEnum.Error
                });
                return null;
            }


            //Get workflow datasource id
            Guid? datasourceId = Guid.Empty;

            var dataSources = SearchDataSource(null, null, workflowsActivity, false, null, false,loggedInContext, validationMessages).GetAwaiter().GetResult();

            if (dataSources != null && dataSources.Count > 0)
            {
                foreach (var s in dataSources)
                {
                    datasourceId = s.Id;
                }
            }
            else
            {
                //insert datasource for workflow
                WorkflowDataSourceModel workflowDataSourceModel = new WorkflowDataSourceModel();
                workflowDataSourceModel.Description = workflowsActivity;
                workflowDataSourceModel.Name = workflowsActivity;
                workflowDataSourceModel.CompanyId = loggedInContext.CompanyGuid;
                workflowDataSourceModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                workflowDataSourceModel.DataSourceType = workflowsActivity;
                workflowDataSourceModel.DataSourceTypeNumber = 6;
                workflowDataSourceModel.IsArchived = false;
                workflowDataSourceModel.Fields = string.Empty;
                datasourceId = CreateDataSource(workflowDataSourceModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
            }

            //insert dataset for workflow
            WorkflowDataSetModel workflowDataSetModel = new WorkflowDataSetModel();
            workflowDataSetModel.Id = activitymodel.Id;
            workflowDataSetModel.DataSourceId = datasourceId;
            workflowDataSetModel.IsArchived = activitymodel.IsArchive ?? false;
            workflowDataSetModel.DataJson = JsonConvert.SerializeObject(activitymodel);
            var submissionId1 = (activitymodel.Id == null || activitymodel.Id == Guid.Empty) ? CreateDataSet(workflowDataSetModel, loggedInContext, validationMessages).GetAwaiter().GetResult() :
                            UpdateDataSet(workflowDataSetModel, loggedInContext, validationMessages).GetAwaiter().GetResult();

            _auditService.SaveAudit(AppCommandConstants.UpsertGenericFormsCommandId, activitymodel, loggedInContext);
            LoggingManager.Debug(submissionId1?.ToString());

            return submissionId1;
        }

        public List<ActivityOutputModel> GetActivity(ActivityModel activitymodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActivity", "GenericForm Service"));

            //Get workflow datasource id
            Guid? datasourceId = Guid.Empty;

            var dataSources = SearchDataSource(null, null, workflowsActivity, false, null,false, loggedInContext, validationMessages).GetAwaiter().GetResult();

            if (dataSources != null && dataSources.Count > 0)
            {
                datasourceId = dataSources[0].Id;

                var data = SearchDataSets(activitymodel.Id, datasourceId, null, activitymodel.IsArchive, null, null, null, loggedInContext, validationMessages).GetAwaiter().GetResult();

                var returnData = data.Select(d => new ActivityOutputModel
                {
                    Id = d.Id,
                    DataSourceId = d.DataSourceId,
                    IsArchived = d.IsArchived,
                    Name = d.Name,
                    DataJson = d.DataJson,
                    ActivityName = d.DataJson.ActivityName,
                    Description = d.DataJson.Description,
                    Inputs = d.DataJson.Inputs
                }).ToList();

                return returnData;
            }
            else
            {
                return null;
            }
        }


        public Guid? UpsertError(ErrorModel errormodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertError", "GenericForm Service"));

            LoggingManager.Debug(errormodel?.ToString());
            if (errormodel.ErrorMessage == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessaage = "Error name cannot be null or empty",
                    ValidationMessageType = MessageTypeEnum.Error
                });
                return null;
            }


            //Get workflow datasource id
            Guid? datasourceId = Guid.Empty;

            var dataSources = SearchDataSource(null, null, workflowsError, false, null,false, loggedInContext, validationMessages).GetAwaiter().GetResult();

            if (dataSources != null && dataSources.Count > 0)
            {
                foreach (var s in dataSources)
                {
                    datasourceId = s.Id;
                }
            }
            else
            {
                //insert datasource for workflow
                WorkflowDataSourceModel workflowDataSourceModel = new WorkflowDataSourceModel();
                workflowDataSourceModel.Description = workflowsError;
                workflowDataSourceModel.Name = workflowsError;
                workflowDataSourceModel.CompanyId = loggedInContext.CompanyGuid;
                workflowDataSourceModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                workflowDataSourceModel.DataSourceType = workflowsError;
                workflowDataSourceModel.IsArchived = false;
                workflowDataSourceModel.Fields = string.Empty;
                datasourceId = CreateDataSource(workflowDataSourceModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
            }

            //insert dataset for workflow
            WorkflowDataSetModel workflowDataSetModel = new WorkflowDataSetModel();
            workflowDataSetModel.Id = errormodel.Id;
            workflowDataSetModel.DataSourceId = datasourceId;
            workflowDataSetModel.IsArchived = errormodel.IsArchive ?? false;
            workflowDataSetModel.DataJson = JsonConvert.SerializeObject(errormodel);
            var submissionId1 = (errormodel.Id == null || errormodel.Id == Guid.Empty) ? CreateDataSet(workflowDataSetModel, loggedInContext, validationMessages).GetAwaiter().GetResult() :
                            UpdateDataSet(workflowDataSetModel, loggedInContext, validationMessages).GetAwaiter().GetResult();

            _auditService.SaveAudit(AppCommandConstants.UpsertGenericFormsCommandId, errormodel, loggedInContext);
            LoggingManager.Debug(submissionId1?.ToString());

            return submissionId1;
        }

        public List<ErrorOutputModel> GetError(ErrorModel errormodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetError", "GenericForm Service"));

            //Get workflow datasource id
            Guid? datasourceId = Guid.Empty;

            var dataSources = SearchDataSource(null, null, workflowsError, false, null,false, loggedInContext, validationMessages).GetAwaiter().GetResult();

            if (dataSources != null && dataSources.Count > 0)
            {
                datasourceId = dataSources[0].Id;

                var data = SearchDataSets(errormodel.Id, datasourceId, null, errormodel.IsArchive, null, null, null, loggedInContext, validationMessages).GetAwaiter().GetResult();

                var returnData = data.Select(d => new ErrorOutputModel
                {

                    Id = d.Id,
                    DataSourceId = d.DataSourceId,
                    IsArchived = d.IsArchived,
                    Name = d.Name,
                    DataJson = d.DataJson,
                    Description = d.DataJson.Description,
                    ErrorCode = d.DataJson.ErrorCode,
                    ErrorMessage = d.DataJson.ErrorMessage,
                }).ToList();


                return returnData;
            }
            else
            {
                return null;
            }
        }

        public List<WorkflowOutputModel> GetWorkflows(WorkflowModel workflowModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWorkflows", "GenericForm Service"));

            //Get workflow datasource id
            Guid? datasourceId = Guid.Empty;

            var dataSourceType = "Workflows";

            var dataSources = SearchDataSourceForWorkflows(null, null, null, false, dataSourceType, loggedInContext, validationMessages).GetAwaiter().GetResult();

            if (dataSources != null && dataSources.Count > 0)
            {
                var dataSourceIds = dataSources.Select(x => x.Id).ToList();
                dataSourceIds = dataSourceIds.Distinct().ToList();
                var dataSourceIdString = String.Join(",", dataSourceIds);

                List<ParamsKeyModel> paramsModel = new List<ParamsKeyModel>();
                string dataJsonValues;
                if (!string.IsNullOrEmpty(workflowModel.FormIds))
                {
                    paramsModel.Add(new ParamsKeyModel
                    {
                        KeyName = "FormTypeId",
                        KeyValue = workflowModel.FormIds,
                        Type = "ListFilter"
                    });
                    dataJsonValues = JsonConvert.SerializeObject(paramsModel);
                }
                else
                {
                    dataJsonValues = null;
                }



                var data = SearchDataSets(workflowModel.Id, null, null, workflowModel.IsArchived, dataSourceIdString, dataJsonValues, workflowModel.DataSetIds, loggedInContext, validationMessages).GetAwaiter().GetResult();

                List<WorkflowOutputModel> returnData = data.Select(d => new WorkflowOutputModel
                {
                    Id = d.Id,
                    DataSourceId = d.DataSourceId,
                    IsArchived = d.IsArchived,
                    Name = d.Name,
                    DataJson = d.DataJson,
                    CompanyModuleId = d.DataJson.CompanyModuleId,
                    FormTypeId = d.DataJson.FormTypeId,
                    WorkflowName = d.DataJson.WorkflowName,
                    FormName = d.DataJson.FormName,
                    Description = d.DataJson.Description
                }).ToList();

                if (workflowModel.CompanyModuleId != null)
                {
                    returnData = returnData.Where(x => x.CompanyModuleId == workflowModel.CompanyModuleId).ToList();
                }
                if (workflowModel.FormTypeId != null)
                {
                    returnData = returnData.Where(x => x.FormTypeId == workflowModel.FormTypeId).ToList();
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWorkflows", "GenericForm Service"));


                return returnData;
            }
            else
            {
                return null;
            }
        }

        public async Task<List<DataSetOutputModel>> SearchDataSets(Guid? dataSourceId, bool? isArchived, LoggedInContext loggedInContext)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + $"/DataService/DataSetApi/SearchDataSet?dataSourceId={dataSourceId}&isArchived={isArchived}");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                HttpResponseMessage response = new HttpResponseMessage();
                response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                if (response.IsSuccessStatusCode)
                {
                    string result = response.Content.ReadAsStringAsync().Result;
                    var data = JObject.Parse(result);
                    return (bool)data["success"] ? data["data"].ToObject<List<DataSetOutputModel>>() : null;
                }
                else
                {
                    return null;
                }
            }
        }

        public List<WorkflowOutputModel> GetWorkflowById(Guid? id, Guid? dataSourceId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            //Get workflow datasource id
            Guid? datasourceId = Guid.Empty;

            var data = SearchDataSetById(id, dataSourceId, loggedInContext).GetAwaiter().GetResult();

            List<WorkflowOutputModel> returnData = data.Select(d => new WorkflowOutputModel
            {
                Id = d.Id,
                DataSourceId = d.DataSourceId,
                IsArchived = d.IsArchived,
                Name = d.Name,
                DataJson = d.DataJson,
                CompanyModuleId = d.DataJson.CompanyModuleId,
                FormTypeId = d.DataJson.FormTypeId,
                WorkflowName = d.DataJson.WorkflowName,
                FormName = d.DataJson.FormName,
                Description = d.DataJson.Description,
                WorkflowObject = d.DataJson
            }).ToList();

            return returnData;


        }

        public async Task<List<DataSetOutputModelForWorkflows>> SearchDataSetById(Guid? id, Guid? dataSourceId, LoggedInContext loggedInContext)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/SearchDataSet?id=" + id + "&dataSourceId=" + dataSourceId + "&searchText=" + null + "&paramsJsonModel=" + null + "&isArchived=" + false + "&isPagingRequired=" + false + "&pageNumber=" + 1 + "&pageSize=" + 10 + "&isInnerQuery=" + false + "&forFormFieldValue=" + null + "&keyName=" + null + "&keyValue=" + null + "&forRecordValue=" + false + "&paths=" + null + "&companyIds=" + null);
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                HttpResponseMessage response = new HttpResponseMessage();
                response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                if (response.IsSuccessStatusCode)
                {
                    string result = response.Content.ReadAsStringAsync().Result;
                    var data = JObject.Parse(result);
                    return (bool)data["success"] ? data["data"].ToObject<List<DataSetOutputModelForWorkflows>>() : null;
                }
                else
                {
                    return null;
                }
            }
        }

        public dynamic GetProcessInstanceByFormSubmittedId(Guid? id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            Guid? dataSourceId = Guid.Empty;
            var dataSources = SearchDataSource(null, null, workflowsInstance, false, null,false, loggedInContext, validationMessages).GetAwaiter().GetResult();
            if (dataSources != null && dataSources.Count > 0)
            {
                dataSourceId = dataSources[0].Id;
                var instances = SearchDataSets(null, dataSourceId, null, false, null, null, null, loggedInContext, validationMessages).GetAwaiter().GetResult();
                List<DataSetOutputModelForWorkflows> flows = instances.Where(x =>
                {
                    var jobject = JObject.Parse(x.DataJson.ToString());
                    if (x.IsArchived == false && (jobject.ContainsKey("FormSubmittedId") && (Guid)jobject["FormSubmittedId"] == id)) return true;
                    return false;
                }).ToList();

                //if flows exists
                if (flows.Count > 0)
                {
                    foreach (var instance in flows)
                    {
                        var dataJson = JObject.Parse(instance.DataJson.ToString());
                        var instanceId = (Guid?)dataJson["ProcessInstanceId"];
                        var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];
                        var url = camundaApiBaseUrl + "/engine-rest/process-instance/" + instanceId;
                        RestClient client = new RestClient(url);
                        RestRequest request = new RestRequest();

                        // Use the Method property to set the HTTP method
                        request.Method = Method.GET;

                        var responseString = client.Execute(request);
                        dynamic res = JsonConvert.DeserializeObject(responseString.Content);
                        if (res?.id != instanceId)
                        {
                            WorkflowDataSetModel workflowDataSetModel = new WorkflowDataSetModel();
                            workflowDataSetModel.Id = instance.Id;
                            workflowDataSetModel.DataSourceId = instance.DataSourceId;
                            workflowDataSetModel.IsArchived = true;
                            workflowDataSetModel.DataJson = instance.DataJson.ToString();
                            Guid? submissionId1 = UpdateDataSet(workflowDataSetModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                        }
                    }
                }
            }
            return null;
        }

        public List<GenericFormApiReturnModel> GetDataServiceGenericForms(GenericFormSearchCriteriaInputModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var dataSources = SearchDataSource(null, genericFormModel.CompanyModuleId, "Forms", false, null,false, loggedInContext, validationMessages).GetAwaiter().GetResult();
            List<GenericFormApiReturnModel> forms = dataSources.Select(e => new GenericFormApiReturnModel
            {
                FormName = e.Name,
                Id = (Guid)e.Id,
                Type = e.Type
            }).ToList();

            return forms;
        }


        public List<Models.FormDataServices.DataSourceKeysOutputModel> GetDataServiceFormsFields(FormWorkflowModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataServiceFormsFields", "GenericForm Api"));

            LoggingManager.Debug(genericFormModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<Models.FormDataServices.DataSourceKeysOutputModel> dataSources = _dataSourceService.SearchDataSourceKeys(null, genericFormModel.Id, null, null, null, false, loggedInContext, validationMessages).GetAwaiter().GetResult();
            //List<FormFieldModel> forms = new List<FormFieldModel>();
            //if (dataSources.Count > 0)
            //{
            //    var fields = JObject.Parse(dataSources[0].Fields);
            //    var components = JArray.Parse(fields["Components"].ToString()).ToList();
            //    foreach (var f in components)
            //    {
            //        var form = new FormFieldModel()
            //        {
            //            GenericFormId = genericFormModel.Id,
            //            Key = (string)f["Key"],
            //            DataType = (string)f["DataType"],
            //            Label = (string)f["Label"]
            //        };
            //        forms.Add(form);

            //    }
            //}
            return dataSources;
        }
        public dynamic Check(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];
            CamundaEngineClient camunda = new CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);
            var workFlowTaskId = "9978cbc2-6eb1-11ec-8672-f8bc12924d1e"; //"28bddfb9-6eb9-11ec-8672-f8bc12924d1e";
            var tasks = camunda.HumanTaskService.LoadTasks(new Dictionary<string, string> {
                    { "processInstanceId", workFlowTaskId.ToString() }
                       });
            var a = camunda.RepositoryService.LoadProcessDefinitions(true);
            var b = camunda.BpmnWorkflowService.LoadProcessInstances(new Dictionary<string, string> {
                    { "processInstanceId", workFlowTaskId.ToString() }
                       });
            var corpSiteApi = camundaApiBaseUrl + "/engine-rest/engine/default/process-instance/" + workFlowTaskId + "/activity-instances";
            RestClient client = new RestClient(corpSiteApi);
            RestRequest request = new RestRequest();

            // Use the Method property to set the HTTP method
            request.Method = Method.GET;
            client.Execute(request);
            var url = camundaApiBaseUrl + "/engine-rest/task?processInstanceId=" + workFlowTaskId;
            client = new RestClient(url);
            client.Execute(request);
            var url2 = camundaApiBaseUrl + "/engine-rest/process-instance?processInstanceId=" + workFlowTaskId;
            client = new RestClient(url2);
            client.Execute(request);
            if (tasks.Any())
            {
                Dictionary<string, object> varibales = camunda.HumanTaskService.LoadVariables(tasks.First().Id);
                //if (varibales.ContainsKey("statusChangedTobe"))
                //    varibales["statusChangedTobe"] = "APPROVED";
                //else
                //    varibales.Add("statusChangedTobe", "APPROVED");
                //camunda.HumanTaskService.Complete(tasks.First().Id, varibales);
            }
            return null;
        }


        public void TriggerUserTask(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string instanceId = null)
        {
            var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];

            CamundaEngineClient camunda = new CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);
            var tasks = camunda.HumanTaskService.LoadTasks(new Dictionary<string, string> {
                    { "processInstanceId", instanceId.ToString() } });

            if (tasks.Any())
            {
                string taskType = tasks.First().Name;
                Dictionary<string, object> varibales = camunda.HumanTaskService.LoadVariables(tasks.First().Id);
                camunda.HumanTaskService.Complete(tasks.First().Id, varibales);
            }
        }

        public async Task TriggerEvent(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string instanceId = null)
        {
            var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];

            CamundaEngineClient camunda = new CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);
            var tasks = camunda.HumanTaskService.LoadTasks(new Dictionary<string, string> {
                    { "processInstanceId", instanceId.ToString() } });

            if (tasks.Any())
            {
                string taskType = tasks.First().Name;
                if (WorkflowEnum.TryParse(taskType, out WorkflowEnum myEnum))
                {
                    //if usertask related to events
                    Dictionary<string, object> varibales = camunda.HumanTaskService.LoadVariables(tasks.First().Id);
                    camunda.HumanTaskService.Complete(tasks.First().Id, varibales);
                    // Update process varibles to process instance
                    Dictionary<string, object> pv = new Dictionary<string, object>();
                    foreach (var kv in varibales)
                    {
                        JObject obj = (JObject)JToken.FromObject(kv);
                        var key = obj["Key"].ToString();
                        var a = new { value = obj["Value"] };
                        pv.Add(key, a);
                    }
                    dynamic reqData = null;
                    if (instanceId != null)
                    {
                        reqData = new { modifications = pv };
                    }

                    var corpSiteApi = camundaApiBaseUrl + "/engine-rest/process-instance/" + instanceId + "/variables";
                    RestClient client = new RestClient(corpSiteApi);
                    RestRequest request = new RestRequest();

                    // Use the Method property to set the HTTP method
                    request.Method = Method.POST;

                    string requestJson = JsonConvert.SerializeObject(reqData);
                    string datareq = requestJson;
                    var output = await client.ExecuteAsync(request.AddJsonBody(datareq)).ConfigureAwait(false);
                    if (output.IsSuccessful == true && output.ResponseStatus.ToString() == "Completed")
                    {
                        //trigger based on event
                        var eventType = (EventType)((int)myEnum);
                        switch (eventType)
                        {
                            case EventType.Message:
                                TriggerMessageEvent(varibales["messageName"].ToString(), pv, loggedInContext, validationMessages, instanceId);
                                break;
                            case EventType.Signal:
                                TriggerSignalEvent(varibales["name"].ToString(), pv, loggedInContext, validationMessages, instanceId);
                                break;

                        }
                    }

                }
            }
        }

        public void TriggerMessageEvent(string messageName, Dictionary<string, object> pv, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string instanceId = null)
        {
            try
            {
                var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];
                var corpSiteApi = camundaApiBaseUrl + "/engine-rest/message";
                RestClient client = new RestClient(corpSiteApi);
                RestRequest request = new RestRequest();

                // Use the Method property to set the HTTP method
                request.Method = Method.POST;

                dynamic reqData = null;
                if (instanceId != null)
                {
                    reqData = new { processInstanceId = instanceId, messageName = messageName };
                }

                string requestJson = JsonConvert.SerializeObject(reqData);
                string datareq = requestJson;

                client.Execute(request.AddJsonBody(datareq));
            }
            catch (Exception e)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "TriggerMessageEvent", "GenericFormService", e.Message), e);
            }
        }


        public void TriggerSignalEvent(string messageName, Dictionary<string, object> pv, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string instanceId = null)
        {
            try
            {
                var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];
                var corpSiteApi = camundaApiBaseUrl + "/engine-rest/signal";
                RestClient client = new RestClient(corpSiteApi);
                RestRequest request = new RestRequest();

                // Use the Method property to set the HTTP method
                request.Method = Method.POST;

                dynamic reqData = null;
                if (instanceId != null)
                {
                    reqData = new { processInstanceId = instanceId, name = messageName };
                }

                string requestJson = JsonConvert.SerializeObject(reqData);
                string datareq = requestJson;
                client.Execute(request.AddJsonBody(datareq));
            }
            catch (Exception e)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "TriggerSignalEvent", "GenericFormService", e.Message), e);
            }
        }

        public async Task<List<WorkflowDataSourceModel>> SearchDataSourceForWorkflows(Guid? id, Guid? companyModuleId, string searchText, bool? isArchived, string dataSourceType, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSourceApi/SearchDataSource?id=" + id + "&companyModuleId=" + companyModuleId + "&searchText=" + searchText + "&isArchived=" + isArchived + "&dataSourceType=" + dataSourceType);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<WorkflowDataSourceModelFake>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = result.Select(e => new WorkflowDataSourceModel
                        {
                            Id = e.Id,
                            Key = e.Key,
                            Name = e.Name,
                            FormTypeId = e.FormTypeId,
                            Description = e.Description,
                            DataSourceType = e.DataSourceType,
                            Tags = e.Tags,
                            Fields = e.Fields.ToString(),
                            IsArchived = e.IsArchived,
                            CompanyModuleId = e.CompanyModuleId

                        }).ToList();
                        return rdata;

                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSourceService", exception.Message), exception);
                return null;
            }
        }

        public List<DataSourceKeysOutputModel> GetFormsFieldsByDataSource(FormWorkflowModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public List<FormFieldModel> GetFormsFields(FormfieldWorkFlowModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenericForms", "GenericForm Api"));

            LoggingManager.Debug(genericFormModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<Guid> allFormIds = new List<Guid>();

            if (!string.IsNullOrEmpty(genericFormModel.FormIds))
            {
                string[] formIds = genericFormModel.FormIds.Split(new[] { ',' });

                allFormIds = formIds.Select(Guid.Parse).ToList();
            }
            else
            {
                allFormIds.Add((Guid)genericFormModel.Id);
            }

            string formIdString = genericFormModel.FormIds;
            if (!string.IsNullOrEmpty(formIdString))
            {
                formIdString = formIdString + "," + genericFormModel.Id.ToString();
            }
            else
            {
                formIdString = genericFormModel.Id.ToString();
            }


            _auditService.SaveAudit(AppCommandConstants.GetGenericFormsCommandId, genericFormModel, loggedInContext);

            List<DataSourceKeysOutputModel> dataSourcekeys = _dataSourceService.SearchDataSourceKeys(null, null, null, null, null, false, loggedInContext, validationMessages, formIdString).GetAwaiter().GetResult();

            //List<FormFieldModel> genericForms = _genericFormRepository.GetFormsFields(genericFormModel, loggedInContext, validationMessages);

            var keysList = from dsk in dataSourcekeys where allFormIds.Any(x => x == dsk.DataSourceId) select dsk;

            List<FormFieldModel> formFields = new List<FormFieldModel>();

            foreach (Guid guid in allFormIds)
            {

                    Parallel.ForEach(dataSourcekeys?.Where(t => t.DataSourceId == guid), keys =>
                    {

                        formFields.Add(new FormFieldModel
                        {
                            GenericFormId = keys.DataSourceId,
                            FormName = keys.FormName,
                            Id = keys.Id,
                            GenericFormKeyId = keys.Id,
                            Key = keys.Key,
                            Label = keys.Label,
                            DataType = keys.Type,
                            Type = keys.Type,
                            Path = keys.Path
                        });
                    });

            }

            return formFields;

        }

        public void MailWorkFlowTrigger(MailWorkFlowTriggerInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info("MailWorkFlowTrigger Started ...");

                if (inputModel != null && !String.IsNullOrWhiteSpace(inputModel.WorkflowIds))
                {
                    List<Guid> workflowIds = inputModel.WorkflowIds.Split(',')
                                               .Select(Guid.Parse)
                                               .ToList();
                    foreach (Guid workflowId in workflowIds)
                    {
                        WorkflowModel workflowModel = new WorkflowModel();
                        workflowModel.Id = workflowId;
                        WorkflowOutputModel workflow = GetWorkflows(workflowModel, loggedInContext, validationMessages).FirstOrDefault();
                        if (workflow != null)
                        {
                            WorkFlowTriggerModel workFlowTriggerModel = new WorkFlowTriggerModel
                            {
                                WorkflowName = workflow.WorkflowName,
                                WorkflowXml = workflow.DataJson.Xml

                            };

                            GenericFormSubmittedUpsertInputModel genericForm = new GenericFormSubmittedUpsertInputModel
                            {
                                CustomApplicationId = inputModel.CustomApplicationId,
                                DataSetId = inputModel.SubmittedId,
                                DataSourceId = inputModel.FormId
                            };
                            StartWorkflowProcessInstanceXml(genericForm, null, workFlowTriggerModel, loggedInContext, validationMessages, inputModel.Tomails);
                        }
                    }

                    LoggingManager.Info("MailWorkFlowTrigger Ended ...");
                }
                LoggingManager.Info("MailWorkFlowTrigger has concluded execution due to empty workflow IDs.");
            }
            catch (Exception e)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "MailWorkFlowTrigger", "GenericFormService", e.Message), e);
            }
        }

        public void SendGeneratedReporttoMail(SendGeneratedReporttoMailInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendGeneratedReporttoMail", "GenericForm Api"));

            var sfdtFiles = inputModel.FileModel.Where(x => x.IsSfdtFile).ToList();
            List<FileConvertionOutputModel> result = _PDFHTMLDesignerService.FileConvertion(sfdtFiles, loggedInContext, validationMessages).GetAwaiter().GetResult();
            var sqlConectionString = ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString;
            SmtpDetailsModel smtpDetails = _mailTemplateRepository.SearchSmtpCredentials(sqlConectionString, loggedInContext, new List<ValidationMessage>(), null);
            List<StreamWithType> MailAttachmentsWithFileType = new List<StreamWithType>();

            if (result != null & result.Count > 0)
            {
                foreach (FileConvertionOutputModel file in result)
                {
                    Stream streamDocument = null;
                    try
                    {
                        // Open the file using a FileStream
                        using (FileStream fileStream = new FileStream(file.FilePath, FileMode.Open, FileAccess.Read))
                        {
                            // Create a MemoryStream to store the file data
                            MemoryStream memoryStream = new MemoryStream();
                            // Copy the data from the FileStream to the MemoryStream
                            fileStream.CopyTo(memoryStream);
                            // Set the position of the MemoryStream back to the beginning
                            memoryStream.Position = 0;
                            // Assign the MemoryStream to the streamDocument variable
                            streamDocument = memoryStream;
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("An error occurred while opening a file : " + ex.Message);
                    }

                    StreamWithType filedata = new StreamWithType
                    {
                        FileStream = streamDocument,
                        FileName = file.FileName,
                        FileType = file.FileType,
                        IsPdf = file.FileType == ".pdf",
                        IsDocx = file.FileType == ".docx" || file.FileType == ".doc"
                    };
                    System.IO.File.Delete(file.FilePath);
                    MailAttachmentsWithFileType.Add(filedata);
                }
            }

            var uploadedFiles = inputModel.FileModel.Where(x => !x.IsSfdtFile).ToList();

            if (uploadedFiles != null && uploadedFiles.Count > 0)
            {
                foreach (FileConvertionInputModel file in uploadedFiles)
                {
                    if (file.FilePath != null)
                    {
                        Stream streamDocument = null;

                        using (var client = new WebClient())
                        {
                            var content = client.DownloadData(file.FilePath);
                            streamDocument = new MemoryStream(content);
                        }

                        // Create a StreamWithType object and add it to the list of mail attachments
                        StreamWithType filedata = new StreamWithType
                        {
                            FileStream = streamDocument,
                            FileName = file.FileName,
                            FileType = file.FileExtension,
                            IsPdf = file.FileExtension == ".pdf",
                            IsDocx = file.FileExtension == ".docx" || file.FileExtension == ".doc",
                            IsTxt = file.FileExtension == ".txt",
                            IsPng = file.FileExtension == ".png",
                            IsJpeg = file.FileExtension == ".jpeg",
                            IsJpg = file.FileExtension == ".jpg",
                            IsExcel = file.FileExtension == ".xlsx" || file.FileExtension == ".csv"
                                       || file.FileExtension == ".xls",
                        };

                        // Add the file data to the list of mail attachments
                        MailAttachmentsWithFileType.Add(filedata);
                    }
                }
            }

            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpServer = smtpDetails?.SmtpServer,
                SmtpServerPort = smtpDetails?.SmtpServerPort,
                SmtpMail = smtpDetails?.SmtpMail,
                SmtpPassword = smtpDetails?.SmtpPassword,
                ToAddresses = inputModel.ToAddresses,
                HtmlContent = inputModel.Message,
                Subject = inputModel.Subject,
                CCMails = inputModel.CCMails,
                BCCMails = inputModel.BCCMails,
                MailAttachmentsWithFileType = MailAttachmentsWithFileType.Count > 0 ? MailAttachmentsWithFileType : null,
                IsPdf = null
            };
            _mailTemplateService.SendMail(sqlConectionString, loggedInContext, emailModel);
        }

        public List<GetAllFilesOfFormSubmittedOutputModel> GetAllFilesOfFormSubmitted(GetAllFilesOfFormSubmittedInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<GetAllFilesOfFormSubmittedOutputModel> result = new List<GetAllFilesOfFormSubmittedOutputModel>();

            GetPdfGeneratorFiles(inputModel.GenericFormSubmittedId, loggedInContext, result).GetAwaiter().GetResult();
            GetUploadedFiles(inputModel.GenericFormSubmittedId, loggedInContext, result).GetAwaiter().GetResult();
            return result;
        }

        private async Task GetPdfGeneratorFiles(Guid genericFormSubmittedId, LoggedInContext loggedInContext, List<GetAllFilesOfFormSubmittedOutputModel> result)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/GetGeneratedInvoices?GenericFormSubmittedId=" + genericFormSubmittedId);
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                HttpResponseMessage response = new HttpResponseMessage();
                response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                if (response.IsSuccessStatusCode)
                {
                    string apiResponse = response.Content.ReadAsStringAsync().Result;
                    var data = JObject.Parse(apiResponse);
                    var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                    var generatedInvoices = JsonConvert.DeserializeObject<List<GenerateCompleteTemplatesOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                    Parallel.ForEach(generatedInvoices, file =>
                    {
                        result.Add(new GetAllFilesOfFormSubmittedOutputModel
                        {
                            FileId = file._id,
                            FileName = file.InvoiceDowloadId,
                            SfdtTemplate = file.SfdtTemplatesToDownload
                        });
                    });
                }
            }
        }

        private async Task GetUploadedFiles(Guid genericFormSubmittedId, LoggedInContext loggedInContext, List<GetAllFilesOfFormSubmittedOutputModel> result)
        {

            Guid? referenceId = new Guid("fd45f921-48f0-4b0b-b76e-cd2a92880437");
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["DocumentStorageApiBaseUrl"] + "File/FileApi/SearchFile?referenceId=" + referenceId + "&referenceTypeId=" + genericFormSubmittedId + "&referenceTypeName=&fileName=");
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                HttpResponseMessage response = new HttpResponseMessage();
                response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                if (response.IsSuccessStatusCode)
                {
                    string apiResponse = response.Content.ReadAsStringAsync().Result;
                    var data = JObject.Parse(apiResponse);
                    var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                    var fileData = JsonConvert.DeserializeObject<List<FileApiServiceReturnModel>>(JsonConvert.SerializeObject(dataSetResponse));

                    Parallel.ForEach(fileData, file =>
                    {
                        result.Add(new GetAllFilesOfFormSubmittedOutputModel
                        {
                            FileId = file.Id,
                            FileName = file.FileName,
                            FileExtension = file.FileExtension,
                            FilePath = file.FilePath,
                        });
                    });
                }
            }
        }

        public void ShareDashBoardAsPDF(ShareDashBoardAsPDFInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info("ShareDashBoardAsPDF Started ...");
                var sqlConectionString = ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString;
                SmtpDetailsModel smtpDetails = _mailTemplateRepository.SearchSmtpCredentials(sqlConectionString, loggedInContext, new List<ValidationMessage>(), null);
                List<StreamWithType> MailAttachmentsWithFileType = new List<StreamWithType>();

                string filepath = _PDFHTMLDesignerService.ByteArrayToPDFConvertion(inputModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                StreamWithType filedata = new StreamWithType();
                if (inputModel != null && inputModel.ToAddresses != null && inputModel.ToAddresses.Count() > 0 && !string.IsNullOrEmpty(filepath))
                {
                    Stream streamDocument = null;
                    try
                    {
                       
                        // Open the file using a FileStream
                        using (FileStream fileStream = new FileStream(filepath, FileMode.Open, FileAccess.Read))
                        {
                            // Create a MemoryStream to store the file data
                            MemoryStream memoryStream = new MemoryStream();
                            // Copy the data from the FileStream to the MemoryStream
                            fileStream.CopyTo(memoryStream);
                            // Set the position of the MemoryStream back to the beginning
                            memoryStream.Position = 0;
                            // Assign the MemoryStream to the streamDocument variable
                            streamDocument = memoryStream;
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("An error occurred while opening a file : " + ex.Message);
                    }

                    FileInfo fileInfo = new FileInfo(filepath);
                    if (fileInfo.Exists)
                    {
                        fileInfo.Delete();
                        LoggingManager.Info($"File in tha path {filepath} deleted successfully.");
                    }

                    filedata.FileStream = streamDocument;
                    filedata.FileName = inputModel.DashboardName;
                    filedata.FileType = ".pdf";
                    filedata.IsPdf = true;
                    // Add the file data to the list of mail attachments
                    MailAttachmentsWithFileType.Add(filedata);
                }

                
                

                if (string.IsNullOrEmpty(inputModel.Message))
                {
                    inputModel.Message = "Message";
                }

                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = inputModel.ToAddresses,
                    HtmlContent = inputModel.Message,
                    Subject = inputModel.Subject,
                    CCMails = inputModel.CCMails,
                    BCCMails = inputModel.BCCMails,
                    MailAttachmentsWithFileType = MailAttachmentsWithFileType.Count > 0 ? MailAttachmentsWithFileType : null,
                    IsPdf = null
                };
                _mailTemplateService.SendMail(sqlConectionString, loggedInContext, emailModel);

                

                LoggingManager.Info("ShareDashBoardAsPDF Ended ...");

            }
            catch (Exception e)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ShareDashBoardAsPDF", "GenericFormService", e.Message), e);
            }
        }

        public List<GenericFormHistoryOutputModel> SearchGenericFormHistory(Guid? referenceId, int? pageNo, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var details = _dataSetService.SearchGenericFormHistory(referenceId, pageNo,pageSize, loggedInContext, validationMessages);
            return details;
        }
    }
}
