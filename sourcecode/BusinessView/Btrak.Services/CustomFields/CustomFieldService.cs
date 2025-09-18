using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web.Configuration;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.CustomFields;
using Btrak.Models.FormDataServices;
using Btrak.Models.User;
using Btrak.Services.Audit;
using Btrak.Services.FormDataServices;
using Btrak.Services.Helpers;
using Btrak.Services.User;
using BTrak.Common;
using JsonDiffPatchDotNet;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Btrak.Services.CustomFields
{
    public class CustomFieldService : ICustomFieldService
    {
        private readonly CustomFieldRepository _customFieldFormRepository;
        private readonly IAuditService _auditService;
        private readonly IDataSourceService _dataSourceService;
        private readonly IDataSetService _dataSetService;
        private readonly IDataSourceHistoryService _dataSourceHistoryService;
        private readonly IUserService _userService;
        public CustomFieldService(CustomFieldRepository customFieldFormRepository, IAuditService auditService, IDataSourceService dataSourceService, IDataSetService dataSetService, IDataSourceHistoryService dataSourceHistoryService, IUserService userService)
        {
            _customFieldFormRepository = customFieldFormRepository;
            _auditService = auditService;
            _dataSourceService = dataSourceService;
            _dataSetService = dataSetService;
            _dataSourceHistoryService = dataSourceHistoryService;
            _userService = userService;
        }

        public CustomFieldApiReturnModel GetCustomFieldById(Guid? customFieldId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomFieldById", "CustomField Service" + "and customField id=" + customFieldId));

            LoggingManager.Debug(customFieldId?.ToString());

            if (!CustomFieldValidations.GetCustomFieldByIdValidations(customFieldId, loggedInContext, validationMessages))
                return null;

            var customFieldSearchCriteriaInputModel = new CustomFieldSearchCriteriaInputModel
            {
                CustomFieldId = customFieldId
            };

            CustomFieldApiReturnModel customFieldApiReturnModel = SearchCustomFields(customFieldSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();
            if (customFieldApiReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundCustomFieldWithTheId, customFieldId)
                });

                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetCustomFieldFormsCommandId, customFieldSearchCriteriaInputModel, loggedInContext);

            return customFieldApiReturnModel;
        }

        public List<CustomFieldApiReturnModel> SearchCustomFields(CustomFieldSearchCriteriaInputModel customFieldSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchCustomFields", "CustomField Service"));

            _auditService.SaveAudit(AppCommandConstants.GetCustomFieldFormsCommandId, customFieldSearchCriteriaModel, loggedInContext);

            List<ParamsKeyModel> paramsModel = new List<ParamsKeyModel>();
            if (customFieldSearchCriteriaModel.ModuleTypeId != null)
            {
                var moduleTypeIdModel = new ParamsKeyModel();
                moduleTypeIdModel.KeyName = "ModuleTypeId";
                moduleTypeIdModel.KeyValue = customFieldSearchCriteriaModel.ModuleTypeId.ToString();
                moduleTypeIdModel.Type = "number";
                paramsModel.Add(moduleTypeIdModel);
            }
            if (customFieldSearchCriteriaModel.ReferenceId != null)
            {
                var referenceIdModel = new ParamsKeyModel();
                referenceIdModel.KeyName = "ReferenceId";
                referenceIdModel.KeyValue = customFieldSearchCriteriaModel.ReferenceId.ToString();
                referenceIdModel.Type = "Guid";
                paramsModel.Add(referenceIdModel);
            }
            if (customFieldSearchCriteriaModel.ReferenceTypeId != null)
            {
                var referenceTypeIdModel = new ParamsKeyModel();
                referenceTypeIdModel.KeyName = "ReferenceTypeId";
                referenceTypeIdModel.KeyValue = customFieldSearchCriteriaModel.ReferenceTypeId.ToString();
                referenceTypeIdModel.Type = "Guid";
                paramsModel.Add(referenceTypeIdModel);
            }
            

            var jsonModel = JsonConvert.SerializeObject(paramsModel);
            var dataSources = _dataSourceService.SearchDataSource(customFieldSearchCriteriaModel.CustomFieldId, "CustomFields", jsonModel, false, loggedInContext, validationMessages).GetAwaiter().GetResult();
            if(dataSources.Count > 0)
            {
                List<CustomFieldApiReturnModel> customApiReturnModels = dataSources.Select(e => new CustomFieldApiReturnModel
                {
                    CustomFieldId = e.Id,
                    FormName = e.Name,
                    ReferenceId = JObject.Parse(e.Fields.ToString()).ContainsKey("ReferenceId") ? (Guid)JObject.Parse(e.Fields.ToString())["ReferenceId"] : (Guid?)null,
                    ReferenceTypeId = JObject.Parse(e.Fields.ToString()).ContainsKey("ReferenceTypeId") ? (Guid)JObject.Parse(e.Fields.ToString())["ReferenceTypeId"] : (Guid?)null,
                    ModuleTypeId = JObject.Parse(e.Fields.ToString()).ContainsKey("ModuleTypeId") ? (int)JObject.Parse(e.Fields.ToString())["ModuleTypeId"] : (int?)null,
                    FormJson = JObject.Parse(e.Fields.ToString()).ContainsKey("Components") ? JsonConvert.SerializeObject((JObject.Parse(e.Fields.ToString())["Components"])) : null,
                    CreatedDateTime = e.CreatedDateTime
                  
                }).OrderByDescending(e => e.CreatedDateTime).ToList();

                foreach(var customField in customApiReturnModels)
                {
                    List<ParamsKeyModel> paramsjsonModel = new List<ParamsKeyModel>();
                    var paramsNewModel = new ParamsKeyModel();
                    paramsNewModel.KeyName = "ReferenceId";
                    paramsNewModel.KeyValue = customFieldSearchCriteriaModel.ReferenceId.ToString();
                    paramsNewModel.Type = "Guid";
                    paramsjsonModel.Add(paramsNewModel);
                    string jsonParamModel = JsonConvert.SerializeObject(paramsjsonModel);
                    List<DataSetOutputModelForForms> dataSetOutputModelList = _dataSetService.SearchDataSetsForForms(null, null, null, jsonParamModel, false, false, null, null, false, null, null,false,0,null,null, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    if(dataSetOutputModelList.Count > 0)
                    {
                        customField.FormDataJson = JsonConvert.SerializeObject(dataSetOutputModelList[0].DataJson.FormData);
                        customField.CustomDataFormFieldId = dataSetOutputModelList[0].Id;
                    } else
                    {
                        customField.FormDataJson = null;
                        customField.CustomDataFormFieldId = null;
                    }
                }

                return customApiReturnModels;
            }
            
            else
            {
                return new List<CustomFieldApiReturnModel>();
            }
            //List<CustomFieldApiReturnModel> customApiReturnModels = _customFieldFormRepository.SearchCustomFields(customFieldSearchCriteriaModel, loggedInContext, validationMessages);

           
        }

        public Guid? UpsertCustomFieldForm(UpsertCustomFieldModel customFieldFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomFieldForm", "CustomField Service"));

            LoggingManager.Debug(customFieldFormModel.ToString());
            CustomFieldApiReturnModel customFieldApiReturnModel = new CustomFieldApiReturnModel();
            
            if (!CustomFieldValidations.ValidateUpsertCustomFieldForm(customFieldFormModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                customFieldFormModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (customFieldFormModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                customFieldFormModel.TimeZone = indianTimeDetails?.TimeZone;
            }
            DataSourceInputModel dataSourceInputModel = new DataSourceInputModel();
            dataSourceInputModel.CompanyId = loggedInContext.CompanyGuid;
            dataSourceInputModel.DataSourceType = "CustomFields";
            dataSourceInputModel.DataSourceTypeNumber = 4;
            dataSourceInputModel.Name = customFieldFormModel.FormName;
            dataSourceInputModel.Id = customFieldFormModel.CustomFieldId;
            if(dataSourceInputModel.IsArchived == null)
            {
                dataSourceInputModel.IsArchived = false;
            }
            dataSourceInputModel.IsArchived = customFieldFormModel.IsArchived;
            DataServiceConversionModel dataServiceConversionModel = JsonConvert.DeserializeObject<DataServiceConversionModel>(customFieldFormModel.FormJson);
            List<Component> cop = dataServiceConversionModel.Components;
            DataServiceConversionModel dataServiceConversionModelFinal = new DataServiceConversionModel();
            dataServiceConversionModelFinal.Components = customFieldFormModel.FormJson;
            dataServiceConversionModelFinal.ReferenceId = customFieldFormModel.ReferenceId;
            dataServiceConversionModelFinal.ReferenceTypeId = customFieldFormModel.ReferenceTypeId;
            dataServiceConversionModelFinal.ModuleTypeId = customFieldFormModel.ModuleTypeId;
            dataSourceInputModel.Fields = JsonConvert.SerializeObject(dataServiceConversionModelFinal);

            if(customFieldFormModel.CustomFieldId != null)
            {
                customFieldApiReturnModel = GetCustomFieldById(customFieldFormModel.CustomFieldId, loggedInContext, validationMessages);
            }

            Guid? customFieldId = _dataSourceService.CreateDataSource(dataSourceInputModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
            var dataSourceKeyModel = new DataSourceKeysInputModel();
            dataSourceKeyModel.DataSourceId = customFieldId;
            Guid? Id =  _dataSourceService.UpdateDataSourceKeys(dataSourceKeyModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
            foreach (var comp in cop)
            {
                var dataSourceKeyInputModel = new DataSourceKeysInputModel();
                dataSourceKeyInputModel.DataSourceId = customFieldId;
                dataSourceKeyInputModel.Key = comp.Key;
                dataSourceKeyInputModel.Label = comp.Label;
                dataSourceKeyInputModel.Type = comp.Type;
                Guid? newId =  _dataSourceService.CreateDataSourceKeys(dataSourceKeyInputModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
            }

            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                DataServiceConversionModel dataServiceConversionModel1 = JsonConvert.DeserializeObject<DataServiceConversionModel>(customFieldFormModel.FormJson);
                List<Component> cop1 = dataServiceConversionModel.Components;
                
                if (customFieldFormModel.CustomFieldId == null)
                {
                    var dataSourceHistoryInputModel = new DataSourceHistoryInputModel();
                    dataSourceHistoryInputModel.DataSourceId = customFieldId;
                    dataSourceHistoryInputModel.NewValue = customFieldFormModel.FormName;
                    dataSourceHistoryInputModel.Description = "Custom field created";
                    Guid? id = _dataSourceHistoryService.CreateDataSourceHistory(dataSourceHistoryInputModel, loggedInContext, validationMessages).GetAwaiter().GetResult(); 
                }
                else
                {
                    List<Component> cop2 = JsonConvert.DeserializeObject<List<Component>>(customFieldApiReturnModel.FormJson);
                    var firstNotSecond = cop1.Except(cop2).ToList();
                    var secondNotFirst = cop2.Except(cop1).ToList();
                    if (customFieldApiReturnModel.FormName != customFieldFormModel.FormName && customFieldFormModel.IsArchived == false)
                    {
                        var dataSourceHistoryInputModel = new DataSourceHistoryInputModel();
                        dataSourceHistoryInputModel.DataSourceId = customFieldId;
                        dataSourceHistoryInputModel.NewValue = customFieldFormModel.FormName;
                        dataSourceHistoryInputModel.OldValue = customFieldApiReturnModel.FormName;
                        dataSourceHistoryInputModel.Description = "Form name updated";
                        Guid? id = _dataSourceHistoryService.CreateDataSourceHistory(dataSourceHistoryInputModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    }
                    if ((secondNotFirst.Count != firstNotSecond.Count) && customFieldFormModel.IsArchived == false)
                    {
                        var dataSourceHistoryInputModel = new DataSourceHistoryInputModel();
                        dataSourceHistoryInputModel.DataSourceId = customFieldId;
                        dataSourceHistoryInputModel.NewValue = JsonConvert.SerializeObject(cop1);
                        dataSourceHistoryInputModel.OldValue = JsonConvert.SerializeObject(cop2);
                        dataSourceHistoryInputModel.Description = "Form json updated";
                        Guid? id = _dataSourceHistoryService.CreateDataSourceHistory(dataSourceHistoryInputModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    }
                    if (customFieldFormModel.IsArchived == true)
                    {
                        var dataSourceHistoryInputModel = new DataSourceHistoryInputModel();
                        dataSourceHistoryInputModel.DataSourceId = customFieldId;
                        dataSourceHistoryInputModel.NewValue = customFieldFormModel.FormName;
                        dataSourceHistoryInputModel.Description = "Form archived";
                        Guid? id = _dataSourceHistoryService.CreateDataSourceHistory(dataSourceHistoryInputModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                    }
                }
            });

                _auditService.SaveAudit(AppCommandConstants.UpsertCustomFieldFormsCommandId, customFieldFormModel, loggedInContext);
            return customFieldId;
        }

        public Guid? UpdateCustomFieldData(UpsertCustomFieldModel customFieldFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomFieldForm", "CustomField Service"));

            LoggingManager.Debug(customFieldFormModel.ToString());

            DataSetOutputModelForForms dataSetOutputModel = new DataSetOutputModelForForms();

            if (!CustomFieldValidations.ValidateUpdateCustomFieldForm(customFieldFormModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                customFieldFormModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (customFieldFormModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                customFieldFormModel.TimeZone = indianTimeDetails?.TimeZone;
            }

            DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();
            dataSetUpsertInputModel.DataSourceId = customFieldFormModel.CustomFieldId;
            dataSetUpsertInputModel.Id = customFieldFormModel.CustomDataFormFieldId;

            var dataSetModel = new DataSetConversionModel();
            dataSetModel.FormData = JsonConvert.DeserializeObject<Object>(customFieldFormModel.FormDataJson);
            dataSetModel.ContractType = "CustomField";
            dataSetModel.InvoiceType = "Form submission";
            dataSetModel.ReferenceId = customFieldFormModel.ReferenceId;

            dataSetUpsertInputModel.DataJson = JsonConvert.SerializeObject(dataSetModel);
            List<ParamsKeyModel> paramsModel = new List<ParamsKeyModel>();
            var referenceKeyModel = new ParamsKeyModel();
            referenceKeyModel.KeyName = "ReferenceId";
            referenceKeyModel.KeyValue = customFieldFormModel.ReferenceId.ToString();
            referenceKeyModel.Type = "Guid";
            paramsModel.Add(referenceKeyModel);
            string jsonModel = JsonConvert.SerializeObject(paramsModel);
            List<DataSetOutputModelForForms> dataSetOutputModelList = _dataSetService.SearchDataSetsForForms(dataSetUpsertInputModel.Id, null,null,jsonModel, false, false, null, null, false, null, null,false,0,null,null, loggedInContext, validationMessages).GetAwaiter().GetResult();
            if(dataSetOutputModelList.Count > 0)
            {
                dataSetOutputModel = dataSetOutputModelList[0];
            }
            
            Guid? CustomFieldId =  _dataSetService.CreateDataSet(dataSetUpsertInputModel, loggedInContext, validationMessages).GetAwaiter().GetResult();

            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                
                if (customFieldFormModel.CustomDataFormFieldId == null)
                {
                    var dataSourceHistoryInputModel = new DataSetHistoryInputModel();
                    dataSourceHistoryInputModel.DataSetId = CustomFieldId;
                    dataSourceHistoryInputModel.NewValue = customFieldFormModel.FormDataJson;
                    dataSourceHistoryInputModel.Description = "FormDataJsonInserted";
                    Guid? id = _dataSetService.CreateDataSetHistory(dataSourceHistoryInputModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                }
                else
                {
                    var dataSourceHistoryInputModel = new DataSetHistoryInputModel();
                    dataSourceHistoryInputModel.DataSetId = CustomFieldId;
                    dataSourceHistoryInputModel.NewValue = customFieldFormModel.FormDataJson;
                    dataSourceHistoryInputModel.OldValue = JsonConvert.SerializeObject(dataSetOutputModel.DataJson.FormData);
                    dataSourceHistoryInputModel.Description = "FormDataJsonUpdated";
                    Guid? id = _dataSetService.CreateDataSetHistory(dataSourceHistoryInputModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
                }
            });

            _auditService.SaveAudit(AppCommandConstants.UpsertCustomFieldFormsCommandId, customFieldFormModel, loggedInContext);
            return CustomFieldId;
        }

        public List<CustomFieldsHistoryApiReturnModel> SearchCustomFieldsHistory(CustomFieldHistorySearchCriteriaModel customFieldSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchCustomFieldsHistory", "CustomField Service"));

            _auditService.SaveAudit(AppCommandConstants.GetCustomFieldFormsCommandId, customFieldSearchCriteriaModel, loggedInContext);

            List<CustomFieldsHistoryApiReturnModel> customFieldsHistoryApiReturnModels = new List<CustomFieldsHistoryApiReturnModel>();

            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSetHistoryApi/SearchDataSetHistory?referenceId=" + customFieldSearchCriteriaModel.ReferenceId;
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response =  client.GetAsync(serviceurl).ConfigureAwait(false).GetAwaiter().GetResult();
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<DataSetHistoryInputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        if (result.Count > 0)
                        {
                            customFieldsHistoryApiReturnModels = result.Select(e => new CustomFieldsHistoryApiReturnModel
                            {
                                CustomFieldHistoryId = e.Id,
                                CustomFieldId = e.DataSourceId,
                                FieldName = e.DataSourceName,
                                OldValue = e.OldValue,
                                NewValue = e.NewValue,
                                Description = e.Description,
                                CreatedDateTime = e.CreatedDateTime,
                                CreatedByUserId = e.CreatedByUserId,
                                FormJson = JsonConvert.SerializeObject(e.DataSourceFormJson.Components)
                            }).OrderBy(x => x.CreatedDateTime).ToList();

                            foreach (var customFieldHistory in customFieldsHistoryApiReturnModels)
                            {
                                UserOutputModel userModel = _userService.GetUserById(customFieldHistory.CreatedByUserId, null, loggedInContext, validationMessages);
                                if (userModel != null)
                                {
                                    customFieldHistory.FullName = userModel.FullName;
                                    customFieldHistory.ProfileImage = userModel.ProfileImage;
                                }
                            }

                        }
                        return customFieldsHistoryApiReturnModels;

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

    }
}
