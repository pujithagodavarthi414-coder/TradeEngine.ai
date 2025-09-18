using formioCommon.Constants;
using formioModels;
using System;
using System.Collections.Generic;
using formioHelpers.Data;
using formioModels.Data;
using formioRepo.DataSource;
using MongoDB.Bson;
using formioRepo.DataSourceKeys;
using System.Linq;
using Newtonsoft.Json;
using formioRepo.DataSet;
using Newtonsoft.Json.Linq;
using Jint;
using Microsoft.CodeAnalysis.CSharp.Scripting;
using System.Data;
using Jint.Native;
using System.Collections;
using System.IO;
using System.Dynamic;
using Microsoft.AspNetCore.SignalR;
using Formio.Hubs;
using Microsoft.AspNetCore.Http;
using Microsoft.SqlServer.Server;
using System.Reflection;
using System.Runtime.ConstrainedExecution;
using Microsoft.AspNetCore.DataProtection.KeyManagement;
using Microsoft.IdentityModel.Tokens;

namespace formioServices.Data
{
    public class DataSourceService : IDataSourceService
    {
        private readonly IDataSourceRepository _dataSourceRepository;
        private readonly IDataSourceKeysRepository _dataSourceKeysRepository;
        private readonly IDataSetRepository _dataSetRepository;
        private readonly IHubContext<LookupSyncNotification, IHubClient> _hubContext;
        public DataSourceService(IDataSourceRepository dataSourceRepository, IDataSourceKeysRepository dataSourceKeysRepository, IDataSetRepository dataSetRepository,
            IHubContext<LookupSyncNotification, IHubClient> hubContext)
        {
            _dataSourceRepository = dataSourceRepository;
            _dataSourceKeysRepository = dataSourceKeysRepository;
            _dataSetRepository = dataSetRepository;
            _hubContext = hubContext;
        }
        public Guid? CreateDataSource(DataSourceFakeInputModel dataSourceFakeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSource", "DataSourceService"));
            LoggingManager.Debug(dataSourceFakeInput.ToString());

            DataSourceInputModel dataSourceInputModel = new DataSourceInputModel
            {
                Id = dataSourceFakeInput.Id,
                FormBgColor = dataSourceFakeInput.FormBgColor,
                CompanyId = dataSourceFakeInput.CompanyId,
                CreatedByUserId = dataSourceFakeInput.CreatedByUserId,
                UpdatedByUserId = dataSourceFakeInput.UpdatedByUserId,
                ArchivedByUserId = dataSourceFakeInput.ArchivedByUserId,
                CreatedDateTime = dataSourceFakeInput.CreatedDateTime,
                UpdatedDateTime = dataSourceFakeInput.UpdatedDateTime,
                ArchivedDateTime = dataSourceFakeInput.ArchivedDateTime,
                Description = dataSourceFakeInput.Description,
                Name = dataSourceFakeInput.Name,
                DataSourceType = getDataSourceType(dataSourceFakeInput.DataSourceTypeNumber),
                Tags = dataSourceFakeInput.Tags,
                Fields = dataSourceFakeInput.Fields.ToString() != "" && dataSourceFakeInput.Fields.ToString() != null ? BsonDocument.Parse(dataSourceFakeInput.Fields.ToString()) : null,
                IsArchived = dataSourceFakeInput.IsArchived,
                CompanyModuleId = dataSourceFakeInput.CompanyModuleId,
                ViewFormRoleIds = dataSourceFakeInput.ViewFormRoleIds,
                EditFormRoleIds = dataSourceFakeInput.EditFormRoleIds,
                SubmittedUserId = dataSourceFakeInput.SubmittedUserId,
                SubmittedCompanyId = dataSourceFakeInput.SubmittedCompanyId,
                SubmittedByFormDrill = dataSourceFakeInput.SubmittedByFormDrill
            };

            if (!DataSourceValidations.ValidateDataSource(dataSourceInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            var id = _dataSourceRepository.CreateDataSource(dataSourceInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug(id.ToString());
            return id;
        }
        public Guid? UpdateDataSource(DataSourceFakeInputModel dataSourceFakeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSource", "DataSourceService"));
            LoggingManager.Debug(dataSourceFakeInput.ToString());

            DataSourceInputModel dataSourceInputModel = new DataSourceInputModel
            {
                Id = dataSourceFakeInput.Id,
                FormBgColor = dataSourceFakeInput.FormBgColor,
                CompanyId = dataSourceFakeInput.CompanyId,
                CreatedByUserId = dataSourceFakeInput.CreatedByUserId,
                UpdatedByUserId = dataSourceFakeInput.UpdatedByUserId,
                ArchivedByUserId = dataSourceFakeInput.ArchivedByUserId,
                CreatedDateTime = dataSourceFakeInput.CreatedDateTime,
                UpdatedDateTime = dataSourceFakeInput.UpdatedDateTime,
                ArchivedDateTime = dataSourceFakeInput.ArchivedDateTime,
                Description = dataSourceFakeInput.Description,
                Name = dataSourceFakeInput.Name,
                DataSourceType = getDataSourceType(dataSourceFakeInput.DataSourceTypeNumber),
                Tags = dataSourceFakeInput.Tags,
                Fields = dataSourceFakeInput.Fields.ToString() != "" && dataSourceFakeInput.Fields.ToString() != null ? BsonDocument.Parse(dataSourceFakeInput.Fields.ToString()) : null,
                IsArchived = dataSourceFakeInput.IsArchived,
                CompanyModuleId = dataSourceFakeInput.CompanyModuleId,
                ViewFormRoleIds = dataSourceFakeInput.ViewFormRoleIds,
                EditFormRoleIds = dataSourceFakeInput.EditFormRoleIds
            };

            if (!DataSourceValidations.ValidateUpdateDataSource(dataSourceInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            dataSourceInputModel.Id = _dataSourceRepository.UpdateDataSource(dataSourceInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug(dataSourceInputModel.Id.ToString());
            return dataSourceInputModel.Id;
        }
       public List<DataSourceOutputModel> SearchDataSource(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSource", "DataSourceService"));
            if (!DataSourceValidations.ValidateSearchDataSources(dataSourceSearchCriteriaInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            return _dataSourceRepository.SearchDataSource(dataSourceSearchCriteriaInputModel, loggedInContext, validationMessages);
        }

        public List<DataSourceOutputModel> SearchDataSourceUnAuth(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSource", "DataSourceService"));
            if (!DataSourceValidations.ValidateSearchDataSourcesUnAuth(dataSourceSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }
            return _dataSourceRepository.SearchDataSourceUnAuth(dataSourceSearchCriteriaInputModel, validationMessages);
        }

        public List<DataSourceOutputModel> SearchDataSourceForJob(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceForJob", "DataSourceService"));

            return _dataSourceRepository.SearchDataSourceForJob(dataSourceSearchCriteriaInputModel, validationMessages);
        }
        public string getDataSourceType(int number)
        {
            switch (number)
            {
                case 1:
                    return "Forms";
                    break;
                case 2:
                    return "ContractTemplate";
                    break;
                case 3:
                    return "TradeTemplate";
                    break;
                case 4:
                    return "CustomFields";
                case 5:
                    return "Workflows";
                case 6:
                    return "WorkflowActivity";
                case 7:
                    return "WorkflowsJob";
                default:
                    return "Forms";
                    break;
            }
        }
        public List<SearchDataSourceOutputModel> SearchAllDataSources(SearchDataSourceInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSource", "DataSourceService"));

            return _dataSourceRepository.SearchAllDataSources(inputModel, loggedInContext, validationMessages);
        }

        public List<GetDataSourcesByIdOutputModel> GetDataSourcesById(GetDataSourcesByIdInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSourcesById", "DataSourceService"));

            return _dataSourceRepository.GetDataSourcesById(inputModel, loggedInContext, validationMessages);
        }
        public string GenericQueryApi(string inputQuery, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenericQueryApi", "DataSourceService"));

            return _dataSourceRepository.GenericQueryApi(inputQuery, loggedInContext, validationMessages);
        }
        public GetFormFieldValuesOutputModel GetFormFieldValues(GetFormFieldValuesInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormFieldValues", "DataSourceService"));

            return _dataSourceRepository.GetFormFieldValues(inputModel, loggedInContext, validationMessages);
        }
        public string GetFormRecordValues(GetFormRecordValuesInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormRecordValues", "DataSourceService"));

            return _dataSourceRepository.GetFormRecordValues(inputModel, loggedInContext, validationMessages);
        }

        public string BackgroundLookupLink(Guid customApplicationId, Guid formId, string companyIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool isNotificationNeeded = true)
        {
            try
            {
                //var dataSource = GetDataSourcesById(new GetDataSourcesByIdInputModel { FormIds = formId.ToString(), IsArchived = false }, loggedInContext, validationMessages);
                var ds = _dataSourceKeysRepository.SearchDataSourceKeys(new DataSourceKeysSearchInputModel { DataSourceId = formId, IsOnlyForKeys = true }, loggedInContext, validationMessages);
                var lookupfields = ds.FindAll(x => x.Type == "mylookup").ToList();
                var calculateFields = ds.FindAll(x => x.CalculateValue != null && !string.IsNullOrEmpty(x.CalculateValue)).ToList();
                List<ParamsJsonModel> paramsJsons1 = new List<ParamsJsonModel>();

                paramsJsons1.Add(new ParamsJsonModel()
                {
                    KeyName = "FormDataLookUpFilter"
                });
                var dataSets = _dataSetRepository.SearchDataSets(new DataSetSearchCriteriaInputModel { DataSourceId = formId, IsArchived = false, DataJsonInputs = paramsJsons1 }, loggedInContext, validationMessages)?.ToList();
                //dataSets = new List<DataSetOutputModel> { dataSets[dataSets.Count - 1] };
                var formName = dataSets != null && dataSets.Count > 0 ? dataSets[0].DataSourceName : null;
                //foreach (var lookupfield in lookupfields)
                //{
                //    var lookupformId = lookupfield.FormName;
                //    var lookupfieldName = lookupfield.FieldName;
                //    //var ds1 = _dataSourceKeysRepository.SearchDataSourceKeys(new DataSourceKeysSearchInputModel { DataSourceId = Guid.Parse(lookupfield.FormName), IsOnlyForKeys = true }, loggedInContext, validationMessages);
                //    var formsModel = JsonConvert.DeserializeObject<List<FormsMiniModel>>(JsonConvert.SerializeObject(lookupfield.RelatedFieldsfinalData));
                //    formsModel.ForEach(x => x.FormId = Guid.Parse(lookupformId));
                //    var formsModel1 = JsonConvert.DeserializeObject<List<FormsMiniModelForUpdate>>(JsonConvert.SerializeObject(formsModel));
                //    foreach (var dataSet in dataSets)
                //    {
                //        var lookupvalue = ((IDictionary<string, object>)((IDictionary<string, object>)dataSet.DataJson)["FormData"])[lookupfield.Key]?.ToString();
                //        var values = _dataSourceRepository.GetFormRecordValues(new GetFormRecordValuesInputModel { KeyName = lookupfieldName, KeyValue = lookupvalue, FormsModel = formsModel }
                //            , loggedInContext, validationMessages);
                //        var b = JObject.Parse(values)[lookupfield.SelectedFormName];
                //        foreach (var fv in formsModel1.Select((value, i) => new { i, value }))
                //        {
                //            var type = ((JValue)b[0][fv.value.KeyName + "-Type"]).Value;
                //            //var val = ((JValue)b[0][fv.value.KeyName]).Value;
                //            if (type.ToString() == "textfield") 
                //            {
                //                fv.value.keyValue = b[0][fv.value.KeyName].Value<string>();
                //            }
                //            else if(type.ToString() == "number")
                //            {
                //                fv.value.keyValue = b[0][fv.value.KeyName].Value<int?>();
                //            }
                //            else if (type.ToString() == "date")
                //            {
                //                fv.value.keyValue = b[0][fv.value.KeyName].Value<DateTime?>();
                //            }
                //            else
                //            {
                //                fv.value.keyValue = b[0][fv.value.KeyName].Value<string>();
                //            }
                //        }
                //        var ud = _dataSetRepository.UpdateDataSetByJob((Guid)dataSet.Id, lookupfield.Key + lookupvalue + "lookupchilddata", formsModel1, loggedInContext, validationMessages)?.ToList().FirstOrDefault();
                //        var a = JsonConvert.DeserializeObject<dynamic>(JsonConvert.SerializeObject(ud));
                //        var c = a["DataJson"]["FormData"];
                //        dynamic d = ud.DataJson;
                //        var a1 = ((dynamic)d).FormData;
                //        var a2 = a1.GetType();
                //        foreach (var cv in calculateFields)
                //        {
                //            //var path = cv.Path.Split(".").ToArray();
                //            //foreach (var p in path.Select((value, i) => new { i, value}))
                //            //{
                //            //    if (p.i == path.Length - 1) 
                //            //    {

                //            //    }
                //            //    else
                //            //    {

                //            //    }
                //            //}
                //            //var result = CSharpScript.EvaluateAsync(str).Result;
                //            //var eng2 = new Engine().SetValue("data", c).Execute($"value = {a1} + 10").GetValue("value");
                //            var eng3 = new Engine().SetValue("data", a1).Execute($"{cv.CalculateValue}").GetValue("value").ToObject();
                //            //var eng4 = new Engine()
                //                    //.Execute("function add(data, cv) { return eval(cv.CalculateValue) }");

                //            //var ans = eng4.Invoke("add", c, cv);
                //            _dataSetRepository.UpdateDataSetByKey((Guid)dataSet.Id, cv.Path, eng3, loggedInContext);

                //        }
                //    }
                //}

                foreach (var dataSet in dataSets)
                {
                    foreach (var lookupfield in lookupfields)
                    {
                        var lookupformId = lookupfield.FormName;
                        var lookupfieldName = lookupfield.FieldName;
                        var path = lookupfield.Path.Split('.');
                        var innerKey = path != null && path.Length > 1 ? true : false;
                        var lookupvalue = string.Empty;
                        try
                        {
                            if (innerKey == false)
                            {
                                lookupvalue = ((IDictionary<string, object>)((IDictionary<string, object>)dataSet.DataJson)["FormData"]).ContainsKey(lookupfield.Key) ? ((IDictionary<string, object>)((IDictionary<string, object>)dataSet.DataJson)["FormData"])[lookupfield.Key].ToString() : null;
                                if (lookupvalue != null && lookupfieldName != null && lookupformId != null)
                                {
                                    //var ds1 = _dataSourceKeysRepository.SearchDataSourceKeys(new DataSourceKeysSearchInputModel { DataSourceId = Guid.Parse(lookupfield.FormName), IsOnlyForKeys = true }, loggedInContext, validationMessages);
                                    var formsModel = JsonConvert.DeserializeObject<List<FormsMiniModel>>(JsonConvert.SerializeObject(lookupfield.RelatedFieldsfinalData));
                                    formsModel.ForEach(x => x.FormId = Guid.Parse(lookupformId));
                                    var formsModel1 = JsonConvert.DeserializeObject<List<FormsMiniModelForUpdate>>(JsonConvert.SerializeObject(formsModel));
                                    var values = _dataSourceRepository.GetFormRecordValues(new GetFormRecordValuesInputModel { KeyName = lookupfieldName, KeyValue = lookupvalue, FormsModel = formsModel, CompanyIds = companyIds }
                                        , loggedInContext, validationMessages);
                                    if (string.IsNullOrEmpty(values))
                                    {
                                        continue;
                                    }
                                    var b = JObject.Parse(values)[lookupfield.SelectedFormName];
                                    if (b == null)
                                    {
                                        continue;
                                    }
                                    foreach (var fv in formsModel1.Select((value, i) => new { i, value }))
                                    {
                                        var type = ((JValue)b[0][fv.value.KeyName + "-Type"]).Value;
                                        //var val = ((JValue)b[0][fv.value.KeyName]).Value;
                                        if (type != null)
                                        {
                                            if (type.ToString() == "textfield")
                                            {
                                                fv.value.keyValue = b[0][fv.value.KeyName].Value<string>();
                                            }
                                            else if (type.ToString() == "number")
                                            {

                                                fv.value.keyValue = (b[0][fv.value.KeyName].Value<string>() != null && b[0][fv.value.KeyName].Value<string>().Contains(".")) ? b[0][fv.value.KeyName].Value<Double?>() : b[0][fv.value.KeyName].Value<int?>();

                                            }
                                            else if (type.ToString() == "date" || type.ToString() == "datetime")
                                            {
                                                var vall = b[0][fv.value.KeyName].Value<dynamic>();
                                                var vallType = vall.GetType();
                                                var dy = vall.ToObject<dynamic?>();
                                                var dyt = dy.GetType();
                                                //var dt = vall.ToObject<DateTime?>();
                                                //var dtt = dt.GetType();
                                                if (dy != null && dyt.Name == "DateTime")
                                                {
                                                    //fv.value.keyValue = b[0][fv.value.KeyName].Value<DateTime?>();
                                                    fv.value.keyValue = dy;
                                                }
                                                else
                                                {
                                                    fv.value.keyValue = dy;
                                                }
                                            }
                                            else
                                            {
                                                fv.value.keyValue = b[0][fv.value.KeyName].Value<string>();
                                            }
                                        }

                                    }
                                    var ud = _dataSetRepository.UpdateDataSetByJob((Guid)dataSet.Id, lookupfield.Key + lookupvalue + "lookupchilddata", formsModel1, loggedInContext, validationMessages);
                                }
                            }
                            else
                            {
                                var datagrids = new List<string>();
                                foreach (var lv in path.Select((value, i) => new { i, value }))
                                {
                                    if (lv.i == path.Length - 1)
                                    {
                                        lookupvalue = ((IDictionary<string, object>)((IDictionary<string, object>)dataSet.DataJson)["FormData"]).ContainsKey(lookupfield.Key) ? ((IDictionary<string, object>)((IDictionary<string, object>)dataSet.DataJson)["FormData"])[lookupfield.Key].ToString() : null;
                                        if (lookupvalue != null && lookupfieldName != null && lookupformId != null)
                                        {
                                            //var ds1 = _dataSourceKeysRepository.SearchDataSourceKeys(new DataSourceKeysSearchInputModel { DataSourceId = Guid.Parse(lookupfield.FormName), IsOnlyForKeys = true }, loggedInContext, validationMessages);
                                            var formsModel = JsonConvert.DeserializeObject<List<FormsMiniModel>>(JsonConvert.SerializeObject(lookupfield.RelatedFieldsfinalData));
                                            formsModel.ForEach(x => x.FormId = Guid.Parse(lookupformId));
                                            var formsModel1 = JsonConvert.DeserializeObject<List<FormsMiniModelForUpdate>>(JsonConvert.SerializeObject(formsModel));
                                            var values = _dataSourceRepository.GetFormRecordValues(new GetFormRecordValuesInputModel { KeyName = lookupfieldName, KeyValue = lookupvalue, FormsModel = formsModel, CompanyIds = companyIds }
                                                , loggedInContext, validationMessages);
                                            if (string.IsNullOrEmpty(values))
                                            {
                                                continue;
                                            }
                                            var b = JObject.Parse(values)[lookupfield.SelectedFormName];
                                            if (b == null)
                                            {
                                                continue;
                                            }
                                            foreach (var fv in formsModel1.Select((value, i) => new { i, value }))
                                            {
                                                var type = ((JValue)b[0][fv.value.KeyName + "-Type"]).Value;
                                                //var val = ((JValue)b[0][fv.value.KeyName]).Value;
                                                if (type != null)
                                                {
                                                    if (type.ToString() == "textfield")
                                                    {
                                                        fv.value.keyValue = b[0][fv.value.KeyName].Value<string>();
                                                    }
                                                    else if (type.ToString() == "number")
                                                    {
                                                        fv.value.keyValue = (b[0][fv.value.KeyName].Value<string>() != null && b[0][fv.value.KeyName].Value<string>().Contains(".")) ? b[0][fv.value.KeyName].Value<Double?>() : b[0][fv.value.KeyName].Value<int?>();
                                                    }
                                                    else if (type.ToString() == "date" || type.ToString() == "datetime")
                                                    {
                                                        var vall = b[0][fv.value.KeyName].Value<dynamic>();
                                                        var vallType = vall.GetType();
                                                        var dy = vall.ToObject<dynamic?>();
                                                        var dyt = dy.GetType();
                                                        //var dt = vall.ToObject<DateTime?>();
                                                        //var dtt = dt.GetType();
                                                        if (dy != null && dyt.Name == "DateTime")
                                                        {
                                                            //fv.value.keyValue = b[0][fv.value.KeyName].Value<DateTime?>();
                                                            fv.value.keyValue = dy;
                                                        }
                                                        else
                                                        {
                                                            fv.value.keyValue = dy;
                                                        }
                                                    }
                                                    else
                                                    {
                                                        fv.value.keyValue = b[0][fv.value.KeyName].Value<string>();
                                                    }
                                                }

                                            }
                                            var ud = _dataSetRepository.UpdateDataSetByJob((Guid)dataSet.Id, lookupfield.Key + lookupvalue + "lookupchilddata", formsModel1, loggedInContext, validationMessages);
                                        }
                                    }
                                    else
                                    {
                                        var dj = JsonConvert.SerializeObject(dataSet.DataJson);
                                        var jsonObj = JObject.Parse(dj);
                                        var key = $"FormData.{lv.value}";
                                        var v1 = jsonObj.SelectToken($"{key}").ToObject<dynamic>();
                                        var v1ty = v1.GetType();
                                        if (v1ty.Name == "JArray")
                                        {
                                            datagrids.Add(lv.value);
                                            LoopDataGrid(path.ToList().GetRange(lv.i + 1, path.ToList().Count - 1), lv.i, v1, datagrids, dataSet, lookupfield, lookupfieldName, lookupformId, companyIds, loggedInContext, validationMessages);
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        catch (Exception exception)
                        {
                            LoggingManager.Error("syncing the data Failed with exception :- " + exception);

                            if (isNotificationNeeded)
                            {
                                var notification1 = _dataSourceRepository.UpsertNotification(new NotificationModel
                                {
                                    Id = Guid.NewGuid(),
                                    NotificationType = "Lookup Sync",
                                    Summary = $"There is an error while syncing the form: {formId}, DataSetId: ${dataSet.Id}, lookupKey: {lookupfield.Path}  Error: {exception.Message}",
                                    CreatedDateTime = DateTime.UtcNow,
                                    IsArchived = false,
                                    CreatedByUserId = loggedInContext.LoggedInUserId,
                                    NotifyToUserId = loggedInContext.LoggedInUserId,
                                    ReadTime = null,
                                    InActiveDateTime = null,
                                    UpdatedByUserId = null,
                                    UpdatedDateTime = null
                                }, loggedInContext, validationMessages);

                                if (notification1 != null)
                                {
                                    var con = UserHandler.GetConnections(loggedInContext.FullName);
                                    if (con.Count() > 0)
                                    {
                                        foreach (var cn in con)
                                        {
                                            _hubContext.Clients.Client(cn).BroadCastNotification(notification1);
                                        }
                                    }
                                }
                            }

                            return null;
                        }
                    }
                    var ud1 = _dataSetRepository.SearchDataSets(new DataSetSearchCriteriaInputModel { DataSourceId = formId, IsArchived = false, DataJsonInputs = paramsJsons1, Id = dataSet.Id }, loggedInContext, validationMessages)?.ToList().FirstOrDefault();
                    var a = JsonConvert.DeserializeObject<dynamic>(JsonConvert.SerializeObject(ud1));
                    var c = a["DataJson"]["FormData"];
                    dynamic d = ud1.DataJson;
                    var a1 = ((dynamic)d).FormData;
                    var a2 = a1.GetType();
                    foreach (var cv in calculateFields)
                    {
                        try
                        {
                            //var path = cv.Path.Split(".").ToArray();
                            //foreach (var p in path.Select((value, i) => new { i, value}))
                            //{
                            //    if (p.i == path.Length - 1) 
                            //    {

                            //    }
                            //    else
                            //    {

                            //    }
                            //}
                            //var result = CSharpScript.EvaluateAsync(str).Result;
                            //var eng2 = new Engine().SetValue("data", c).Execute($"value = {a1} + 10").GetValue("value");
                            var path = cv.Path.Split('.');
                            var innerKey = path != null && path.Length > 1 ? true : false;
                            if (innerKey == false)
                            {
                                var eng3 = new Engine().SetValue("data", a1).Execute($"{cv.CalculateValue}").GetValue("value").ToObject();
                                var val = (eng3 != null && (eng3.GetType().Name == "String" && !string.IsNullOrEmpty(eng3)) || ((eng3.GetType().Name == "Int32" ||
                                    eng3.GetType().Name == "Double") && !Double.IsNaN(eng3) && !Double.IsInfinity(eng3))) ? eng3 : null;
                                //var eng4 = new Engine()
                                //.Execute("function add(data, cv) { return eval(cv.CalculateValue) }");

                                //var ans = eng4.Invoke("add", c, cv);
                                _dataSetRepository.UpdateDataSetByKey((Guid)dataSet.Id, cv.Path, val, loggedInContext);
                            }
                            else
                            {
                                var datagrids = new List<string>();
                                foreach (var lv in path.Select((value, i) => new { i, value }))
                                {
                                    if (lv.i == path.Length - 1)
                                    {

                                    }
                                    else
                                    {
                                        var dj = JsonConvert.SerializeObject(d);
                                        var jsonObj = JObject.Parse(dj);
                                        var key = $"FormData.{lv.value}";
                                        var v1 = jsonObj.SelectToken($"{key}").ToObject<dynamic>();
                                        var v1ty = v1.GetType();
                                        if (v1ty.Name == "JArray")
                                        {
                                            datagrids.Add(lv.value);
                                            LoopDataGrid(path.ToList().GetRange(lv.i + 1, path.ToList().Count - 1), lv.i, v1, datagrids, ud1, null, null, null, companyIds, loggedInContext, validationMessages, true, cv, a1);
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            continue;
                        }
                    }


                }
                //var con = UserHandler.GetConnections(loggedInContext.FullName);
                //if(con.Count() > 0)
                //{
                //    var notification = _dataSourceRepository.UpsertNotification(new NotificationModel {  
                //        Id = Guid.NewGuid(), NotificationType = "Lookup Sync", Summary = "Syncing of form " + formName + " is completed", CreatedDateTime = DateTime.UtcNow, IsArchived = false,
                //        CreatedByUserId = loggedInContext.LoggedInUserId, ReadTime = null, InActiveDateTime = null, UpdatedByUserId = null, UpdatedDateTime = null
                //    }, loggedInContext, validationMessages);
                //    if(notification != null)
                //    {
                //        foreach (var c in con)
                //        {
                //            _hubContext.Clients.Client(c).BroadCastNotification(notification);
                //        }
                //    }
                //}
                if (isNotificationNeeded)
                {
                    var notification = _dataSourceRepository.UpsertNotification(new NotificationModel
                    {
                        Id = Guid.NewGuid(),
                        NotificationType = "Lookup Sync",
                        Summary = "Syncing of form " + formName + " is completed",
                        CreatedDateTime = DateTime.UtcNow,
                        IsArchived = false,
                        CreatedByUserId = loggedInContext.LoggedInUserId,
                        NotifyToUserId = loggedInContext.LoggedInUserId,
                        ReadTime = null,
                        InActiveDateTime = null,
                        UpdatedByUserId = null,
                        UpdatedDateTime = null
                    }, loggedInContext, validationMessages);
                    if (notification != null)
                    {
                        var con = UserHandler.GetConnections(loggedInContext.FullName);
                        if (con.Count() > 0)
                        {
                            foreach (var c in con)
                            {
                                _hubContext.Clients.Client(c).BroadCastNotification(notification);
                            }
                        }
                    }
                }
                return formName;
            }
            catch (Exception exception)
            {
                LoggingManager.Error("syncing the data Failed with exception :- " + exception);

                if (isNotificationNeeded)
                {
                    var notification = _dataSourceRepository.UpsertNotification(new NotificationModel
                    {
                        Id = Guid.NewGuid(),
                        NotificationType = "Lookup Sync",
                        Summary = "There is an error while syncing the form " + formId + ". Error: " + exception.Message,
                        CreatedDateTime = DateTime.UtcNow,
                        IsArchived = false,
                        CreatedByUserId = loggedInContext.LoggedInUserId,
                        NotifyToUserId = loggedInContext.LoggedInUserId,
                        ReadTime = null,
                        InActiveDateTime = null,
                        UpdatedByUserId = null,
                        UpdatedDateTime = null
                    }, loggedInContext, validationMessages);
                    if (notification != null)
                    {
                        var con = UserHandler.GetConnections(loggedInContext.FullName);
                        if (con.Count() > 0)
                        {
                            foreach (var c in con)
                            {
                                _hubContext.Clients.Client(c).BroadCastNotification(notification);
                            }
                        }
                    }
                }
                return null;
            }
        }
        private void LoopDataGrid(List<string> path, int i, dynamic vty, List<string> datagrids, DataSetOutputModel dataSet, DataSourceKeysOutputModel lookupfield, string lookupfieldName, string lookupformId, string companyIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool? fromCal = false, DataSourceKeysOutputModel cv = null, dynamic a1 = null)
        {
            try
            {
                var index = 0;
                foreach (var vt in vty)
                {
                    foreach (var lv in path.Select((value, i) => new { i, value }))
                    {
                        if (lv.i == path.Count - 1)
                        {
                            if (fromCal == false)
                            {
                                var lookupvalue = vt.SelectToken($"{lookupfield.Key}").ToObject<dynamic>();
                                if (lookupvalue != null && lookupfieldName != null && lookupformId != null)
                                {
                                    //var ds1 = _dataSourceKeysRepository.SearchDataSourceKeys(new DataSourceKeysSearchInputModel { DataSourceId = Guid.Parse(lookupfield.FormName), IsOnlyForKeys = true }, loggedInContext, validationMessages);
                                    var formsModel = JsonConvert.DeserializeObject<List<FormsMiniModel>>(JsonConvert.SerializeObject(lookupfield.RelatedFieldsfinalData));
                                    formsModel.ForEach(x => x.FormId = Guid.Parse(lookupformId));
                                    var formsModel1 = JsonConvert.DeserializeObject<List<FormsMiniModelForUpdate>>(JsonConvert.SerializeObject(formsModel));
                                    var values = _dataSourceRepository.GetFormRecordValues(new GetFormRecordValuesInputModel { KeyName = lookupfieldName, KeyValue = lookupvalue, FormsModel = formsModel, CompanyIds = companyIds }
                                        , loggedInContext, validationMessages);
                                    if (string.IsNullOrEmpty(values))
                                    {
                                        continue;
                                    }
                                    var b = JObject.Parse(values)[lookupfield.SelectedFormName];
                                    if (b == null)
                                    {
                                        continue;
                                    }
                                    foreach (var fv in formsModel1.Select((value, i) => new { i, value }))
                                    {
                                        var type = ((JValue)b[0][fv.value.KeyName + "-Type"]).Value;
                                        //var val = ((JValue)b[0][fv.value.KeyName]).Value;
                                        if (type != null)
                                        {
                                            if (type.ToString() == "textfield")
                                            {
                                                fv.value.keyValue = b[0][fv.value.KeyName].Value<string>();
                                            }
                                            else if (type.ToString() == "number")
                                            {
                                                fv.value.keyValue = (b[0][fv.value.KeyName].Value<string>() != null && b[0][fv.value.KeyName].Value<string>().Contains(".")) ? b[0][fv.value.KeyName].Value<Double?>() : b[0][fv.value.KeyName].Value<int?>();
                                            }
                                            else if (type.ToString() == "date" && type.ToString() == "datetime")
                                            {
                                                var vall = b[0][fv.value.KeyName].Value<dynamic>();
                                                var vallType = vall.GetType();
                                                var dy = vall.ToObject<dynamic?>();
                                                var dyt = dy.GetType();
                                                //var dt = vall.ToObject<DateTime?>();
                                                //var dtt = dt.GetType();
                                                if (dy != null && dyt.Name == "DateTime")
                                                {
                                                    //fv.value.keyValue = b[0][fv.value.KeyName].Value<DateTime?>();
                                                    fv.value.keyValue = dy;
                                                }
                                                else
                                                {
                                                    fv.value.keyValue = dy;
                                                }
                                            }
                                            else
                                            {
                                                fv.value.keyValue = b[0][fv.value.KeyName].Value<string>();
                                            }
                                        }
                                    }
                                    var ud = _dataSetRepository.UpdateDataSetByJob((Guid)dataSet.Id, lookupfield.Key + lookupvalue + "lookupchilddata", formsModel1, loggedInContext, validationMessages);
                                }
                            }
                            else
                            {
                                var v = JsonConvert.SerializeObject(vt);
                                var row = JsonConvert.DeserializeObject<ExpandoObject>(v);
                                dynamic eng3 = new Engine().SetValue("data", a1).SetValue("row", row).Execute($"{cv.CalculateValue}").GetValue("value").ToObject();
                                var val = (eng3 != null && (eng3.GetType().Name == "String" && !string.IsNullOrEmpty(eng3)) || ((eng3.GetType().Name == "Int32" ||
                                    eng3.GetType().Name == "Double") && !Double.IsNaN(eng3) && !Double.IsInfinity(eng3))) ? eng3 : null;
                                //var eng4 = new Engine()
                                //.Execute("function add(data, cv) { return eval(cv.CalculateValue) }");

                                //var ans = eng4.Invoke("add", c, cv);
                                var li = cv.Path.LastIndexOf(".");
                                var newpath = cv.Path.Insert(li + 1, index.ToString() + ".");
                                _dataSetRepository.UpdateDataSetByKey((Guid)dataSet.Id, newpath, val, loggedInContext);
                            }
                        }
                        else
                        {
                            var dj = JsonConvert.SerializeObject(dataSet.DataJson);
                            var jsonObj = JObject.Parse(dj);
                            var key = $"FormData.{lv.value}";
                            var v1 = jsonObj.SelectToken($"{key}").ToObject<dynamic>();
                            var v1ty = v1.GetType();
                            if (v1ty.Name == "JArray")
                            {
                                datagrids.Add(lv.value);
                                LoopDataGrid(path.ToList().GetRange(lv.i, path.ToList().Count), lv.i, v1ty, datagrids, dataSet, lookupfield, lookupfieldName, lookupfieldName, companyIds, loggedInContext, validationMessages, fromCal, cv, a1);
                            }
                        }
                    }
                    index++;
                }

            }
            catch (Exception ex)
            {

            }
        }

        public void UpdateLookupChildDataWithNewVar(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                var datasources = SearchAllDataSources(new SearchDataSourceInputModel(), loggedInContext, validationMessages);
                foreach (var datasource in datasources)
                {
                    var ds = _dataSourceKeysRepository.SearchDataSourceKeys(new DataSourceKeysSearchInputModel { DataSourceId = datasource.Id, IsOnlyForKeys = true }, loggedInContext, validationMessages);
                    var lookupfields = ds.FindAll(x => x.Type == "mylookup").ToList();
                    if (lookupfields != null && lookupfields.Count > 0)
                    {
                        List<ParamsJsonModel> paramsJsons1 = new List<ParamsJsonModel>();
                        paramsJsons1.Add(new ParamsJsonModel()
                        {
                            KeyName = "FormDataLookUpFilter"
                        });
                        var dataSets = _dataSetRepository.SearchDataSets(new DataSetSearchCriteriaInputModel { DataSourceId = datasource.Id, IsArchived = false, DataJsonInputs = paramsJsons1 }, loggedInContext, validationMessages)?.ToList();
                        if (dataSets == null)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateLookupChildDataWithNewVar", "DataSourceService", datasource.Id));
                            continue;
                        }
                        var formName = dataSets != null && dataSets.Count > 0 ? dataSets[0].DataSourceName : null;
                        foreach (var dataSet in dataSets)
                        {
                            var obj = ((dynamic)dataSet.DataJson).FormData;
                            var objt = obj.GetType();
                            foreach (var lookupfield in lookupfields)
                            {
                                if (lookupfield.FormName == null || lookupfield.FieldName == null || lookupfield.Path == null)
                                {
                                    continue;
                                }
                                var lookupformId = lookupfield.FormName;
                                var lookupfieldName = lookupfield.FieldName;
                                var path = lookupfield.Path.Split('.');
                                var innerKey = path != null && path.Length > 1 ? true : false;
                                var lookupvalue = string.Empty;
                                IDictionary<string, dynamic> newpath = FindPathsToKey(obj, lookupfield.Key);
                                if (newpath != null && newpath.Count > 0)
                                {
                                    foreach (var p in newpath)
                                    {
                                        if (!p.Key.Contains("lookupchilddata"))
                                        {
                                            var value = newpath[p.Key];
                                            //var lookupchilddata = newpath[$"{p.Key}{value}lookupchilddata"];
                                            var keys = p.Key?.Split('.');
                                            var lookupchilddata = (obj as IDictionary<string, dynamic>)[$"{keys[keys.Length - 1]}{value}lookupchilddata"];
                                            var val = new { value = value, lookupchilddata = lookupchilddata };
                                            ((dynamic)dataSet.DataJson).FormData = setValueFromObject(obj, p.Key, val);
                                            obj = JsonConvert.DeserializeObject<ExpandoObject>(JsonConvert.SerializeObject(((dynamic)dataSet.DataJson).FormData));
                                            objt = obj.GetType();
                                        }
                                    }
                                }
                            }
                            DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();

                            dataSetUpsertInputModel.Id = dataSet.Id;
                            dataSetUpsertInputModel.DataSourceId = dataSet.DataSourceId;
                            //dataSetUpsertInputModel.UpdatedByUserId = dataSet.UpdatedByUserId;
                            //dataSetUpsertInputModel.UpdatedDateTime = dataSet.UpdatedDateTime;
                            dataSetUpsertInputModel.IsArchived = dataSet.IsArchived;
                            var dataJson = JsonConvert.SerializeObject(dataSet.DataJson);
                            if (!string.IsNullOrEmpty(dataJson))
                            {
                                dataSetUpsertInputModel.DataJson = BsonDocument.Parse(dataJson);
                            }
                            var dataSetId = _dataSetRepository.UpdateDataSet(dataSetUpsertInputModel, loggedInContext, validationMessages);
                        }
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        private IDictionary<string, dynamic> FindPathsToKey(dynamic obj, string key, string pathToKey = null)
        {
            try
            {
                IDictionary<string, dynamic> results = new Dictionary<string, dynamic>();
                results = findKey(obj, key, results, pathToKey);
                return results;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        private IDictionary<string, dynamic> findKey(dynamic obj, string key, IDictionary<string, dynamic> results, string pathToKey = null)
        {
            try
            {
                var oldPath = $"{(pathToKey != null ? pathToKey + "." : "")}";
                var expandoDict = obj as IDictionary<string, object>;
                var dj = JsonConvert.SerializeObject(obj);
                var jsonObj = JObject.Parse(dj);
                //if (obj.GetProperty(key) != null)
                if (expandoDict.ContainsKey(key))
                {
                    //results.Add($"{oldPath}{key}", getValueFromObject(obj, $"{oldPath}{key}"));
                    //expandoDict[$"{oldPath}{key}"]
                    results.Add($"{oldPath}{key}", jsonObj.SelectToken($"{key}").ToObject<dynamic>());
                }
                var objType = obj.GetType();
                if (obj != null && !(obj is Array) && !(obj is JArray))
                {
                    // var props = ((dynamic)obj).GetDynamicMemberNames();
                    //foreach (PropertyInfo prop in obj.GetType().GetProperties())
                    foreach (KeyValuePair<string, dynamic> prop in obj)
                    {
                        //var k = obj.GetProperty(prop.Key);
                        var k = expandoDict.ContainsKey(prop.Key) ? prop.Key : null;
                        if (k != null && !k.Contains("lookupchilddata"))
                        {
                            dynamic val = expandoDict[k];
                            var valType = val.GetType();
                            //if (prop.GetValue(obj, null) is Array || prop.GetValue(obj, null) is JArray)
                            if (val is Array || val is JArray || valType.Name.Contains("List"))
                            {
                                var valc = val.Count;
                                for (int j = 0; j < val.Count; j++)
                                {
                                    //findKey(obj[k][j], key, results, $"{oldPath}{k}[{j}]");
                                    findKey(((dynamic)expandoDict[k])[j], key, results, $"{oldPath}{k}[{j}]");
                                }
                            }

                            //if (obj[k] != null && !(obj[k] is Array) && !(obj[k] is JArray))

                            if (expandoDict[k] != null && !(expandoDict[k] is Array) && !(expandoDict[k] is JArray) && expandoDict[k].GetType().Name == "ExpandoObject")
                            {
                                findKey(expandoDict[k], key, results, $"{oldPath}{k}");
                            }
                            continue;
                        }
                    }
                }
                return results;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public dynamic getValueFromObject(dynamic obj, string path)
        {
            Type type = obj.GetType();
            PropertyInfo prop = null;

            string[] parts = path.Split('.');
            dynamic value = obj;
            var expandoDict = obj as IDictionary<string, object>;
            foreach (string part in parts)
            {
                prop = type.GetProperty(part);
                var x = prop.GetValue(value, null);

                if (x is Array || x is JArray)
                {
                    value = (x as IList)[0];
                    type = value.GetType();
                    continue;
                }
                else
                    type = prop.GetType();

                value = prop.GetValue(value, null);
            }
            return value;
        }

        public dynamic setValueFromObject(dynamic obj, string path, dynamic value1)
        {
            Type type = obj.GetType();
            PropertyInfo prop = null;

            string[] parts = path.Split('.');
            dynamic value = obj;
            var dj = JsonConvert.SerializeObject(obj);
            var jsonObj = JObject.Parse(dj);

            //var dj = JsonConvert.SerializeObject(obj);
            //var jsonObj = JObject.Parse(dj);
            //jsonObj.Add(path + "lookup", JObject.FromObject(new { value = value1.value, lookupchilddata = value1.lookupchilddata }));

            //foreach (var part in parts.Select((value, i) => new { i, value }))
            //{
            //    var v1 = jsonObj.SelectToken($"{part.value}").ToObject<dynamic>();
            //    //obj.Add(part + "lookup", value1);
            //    var v1ty = v1.GetType();
            //    if (v1ty.Name == "JArray")
            //    {
            //    }
            //    prop = type.GetProperty(part.value);
            //    var x = prop.GetValue(value, null);

            //    if (x is Array || x is JArray)
            //    {
            //        value = (x as IList)[0];
            //        type = value.GetType();
            //        continue;
            //    }
            //    else
            //        type = prop.GetType();

            //    value = prop.GetValue(value, null);
            //}
            var actualKey = parts.Last();
            foreach (var part in parts)
            {
                if (part == actualKey)
                {
                    if (jsonObj.ContainsKey(actualKey + "lookup"))
                    {
                        jsonObj.Remove(actualKey + "lookup");
                    }
                    jsonObj.Add(actualKey + "lookup", JObject.FromObject(new { value = value1.value, lookupchilddata = value1.lookupchilddata }));
                    return jsonObj;
                }
                else
                {
                    if (part.Contains("[") && part.Contains("]"))
                    {
                        int pFrom = part.IndexOf("[") + "[".Length;
                        int pTo = part.LastIndexOf("]");
                        string key = part.Substring(0, pFrom - 1);
                        string result = part.Substring(pFrom, pTo - pFrom);
                        var indexNumber = int.Parse(result);
                        jsonObj[key][indexNumber] = SetValueFromObjects(jsonObj.SelectToken($"{part}").ToObject<dynamic>(), parts.Skip(parts.ToList().FindIndex(x => x == part) + 1).ToList(), value1, actualKey);
                        return jsonObj;
                    }
                    else
                    {
                        jsonObj[part] = SetValueFromObjects(jsonObj.SelectToken($"{part}").ToObject<dynamic>(), parts.Skip(parts.ToList().FindIndex(x => x == part) + 1).ToList(), value1, actualKey);
                        return jsonObj;
                    }
                }
            }
            //if (parts.Length > 1) 
            //{
            //    var strj = string.Join(".", parts.SkipLast(1));
            //    var v1 = jsonObj.SelectToken($"{strj}").ToObject<dynamic>();
            //    v1.Add(parts.TakeLast(1).First() + "lookup", JObject.FromObject(new { value = value1.value, lookupchilddata = value1.lookupchilddata }));

            //} 
            //else 
            //{
            //    foreach(var part in parts)
            //    {
            //        //var v1 = jsonObj.SelectToken($"{part}").ToObject<dynamic>();
            //        //var v1Type = v1.GetType();
            //        if(part.Contains("[") && part.Contains("]"))
            //        {
            //            int pFrom = part.IndexOf("[") + "[".Length;
            //            int pTo = part.LastIndexOf("]");

            //            string result = part.Substring(pFrom, pTo - pFrom);
            //            var indexNumber = int.Parse(result);

            //        }

            //    }
            //    jsonObj.Add(path + "lookup", JObject.FromObject(new { value = value1.value, lookupchilddata = value1.lookupchilddata }));
            //}

            //foreach(var part in parts)
            //{
            //    if(part == actualKey) 
            //    {
            //        return jsonObj.Add(path + "lookup", JObject.FromObject(new { value = value1.value, lookupchilddata = value1.lookupchilddata }));
            //    } 
            //    else
            //    {
            //        setValueFromObject(obj, part, value1);
            //    }
            //}
            //return value;
            return jsonObj;
        }

        private dynamic SetValueFromObjects(dynamic jsonObj, List<string> parts, dynamic value1, string actualKey)
        {
            try
            {
                foreach (var part in parts)
                {
                    if (part == actualKey)
                    {
                        if (jsonObj.ContainsKey(actualKey + "lookup"))
                        {
                            jsonObj.Remove(actualKey + "lookup");
                        }
                        jsonObj.Add(actualKey + "lookup", JObject.FromObject(new { value = value1.value, lookupchilddata = value1.lookupchilddata }));
                        return jsonObj;
                    }
                    else
                    {
                        if (part.Contains("[") && part.Contains("]"))
                        {
                            int pFrom = part.IndexOf("[") + "[".Length;
                            int pTo = part.LastIndexOf("]");
                            string key = part.Substring(0, pFrom - 1);
                            string result = part.Substring(pFrom, pTo - pFrom);
                            var indexNumber = int.Parse(result);
                            jsonObj[key][indexNumber] = SetValueFromObjects(jsonObj.SelectToken($"{part}").ToObject<dynamic>(), parts.Skip(parts.ToList().FindIndex(x => x == part) + 1).ToList(), value1, actualKey);
                            return jsonObj;
                        }
                        else
                        {
                            jsonObj[part] = SetValueFromObjects(jsonObj.SelectToken($"{part}").ToObject<dynamic>(), parts.Skip(parts.ToList().FindIndex(x => x == part) + 1).ToList(), value1, actualKey);
                            return jsonObj;
                        }
                    }
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public List<NotificationModel> GetNotifications(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return _dataSourceRepository.GetNotifications(loggedInContext, validationMessages);
        }

        public List<Guid?> UpsertReadNewNotifications(NotificationReadModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return _dataSourceRepository.UpsertReadNewNotifications(model, loggedInContext, validationMessages);
        }
    }
}
