using Btrak.Models;
using Btrak.Models.CustomApplication;
using Btrak.Models.FormDataServices;
using Btrak.Models.GenericForm;
using BTrak.Common;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web.Configuration;
using JsonDeserialiseData = BTrak.Common.JsonDeserialiseData;

namespace Btrak.Services.FormDataServices
{
    public class DataSourceService : IDataSourceService
    {
        public async Task<Guid?> CreateDataSource(DataSourceInputModel dataSourceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "";
                    if (dataSourceInputModel.Id != null && dataSourceInputModel.Id != Guid.Empty)
                    {
                        serviceurl = "DataService/DataSourceApi/UpdateDataSource";
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);
                    }
                    else
                    {
                        serviceurl = "DataService/DataSourceApi/CreateDataSource";
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);
                       
                    }

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSourceInputModel), Encoding.UTF8, "application/json");
                    var response = client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false).GetAwaiter().GetResult();
                    var stringAsync = await response.Content.ReadAsStringAsync();
                    var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);
                    if (responseJson.Success)
                    {
                        if (responseJson.Data != null)
                        {
                            var response1 = new Guid(responseJson.Data.ToString());
                            return response1;
                        }
                        else
                        {
                            return null;
                        }
                    }


                    else
                    {
                        foreach (var message in responseJson.ApiResponseMessages)
                        {
                            if (!string.IsNullOrEmpty(dataSourceInputModel.DataSourceType))
                            {
                                message.Message = message.Message.Replace("Data source", dataSourceInputModel.DataSourceType);
                            }
                            validationmessages.Add(new ValidationMessage
                            {
                                ValidationMessageType = MessageTypeEnum.Error,
                                ValidationMessaage = message.Message
                            });
                        }
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
        
        public async Task<Guid> CreateDataSourceKeys(DataSourceKeysInputModel dataSourceKeysInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "";
                    serviceurl = "DataService/DataSourceKeysApi/CreateDataSourceKeys";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);
                  

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSourceKeysInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
                        return new Guid(data);
                    }
                    else
                    {
                        validationmessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });

                        return Guid.Empty;
                    }
                }

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSource", "DataSourceService", exception.Message), exception);
                return Guid.Empty;
            }
        }
        public async Task<Guid> CreateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSourceKeysInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "";
                    serviceurl = "DataService/DataSourceKeysApi/CreateDataSourceKeysConfiguration";

                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);
                   

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSourceKeysInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
                        return new Guid(data);
                    }
                    else
                    {
                        validationmessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });

                        return Guid.Empty;
                    }
                }

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSource", "DataSourceService", exception.Message), exception);
                return Guid.Empty;
            }
        }

        public async Task<Guid> ArchiveDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSourceKeysInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "";
                    serviceurl = "DataService/DataSourceKeysApi/ArchiveDataSourceKeysConfiguration";

                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);
                    

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSourceKeysInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
                        return new Guid(data);
                    }
                    else
                    {
                        validationmessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });

                        return Guid.Empty;
                    }
                }

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSource", "DataSourceService", exception.Message), exception);
                return Guid.Empty;
            }
        }

        public async Task<List<DataSourceOutputModel>> SearchDataSource(Guid? id, string searchText, string paramsJsonModel, bool? isArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages, string validCompanies = null, bool isCompanyBased = false)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/SearchDataSource?id=" + id + "&searchText=" + searchText + "&paramsJsonModel=" + paramsJsonModel + "&isArchived=" + isArchived + "&validCompanies=" + validCompanies + "&isCompanyBased=" + isCompanyBased;
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(result);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var jsonData = JsonConvert.DeserializeObject<List<DataSourceOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = jsonData.Select(e => new DataSourceOutputModel
                        {
                            Id = e.Id,
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
                            DataSetFormJson = e.DataSetFormJson,
                            DataSetId = e.DataSetId,
                            ViewFormRoleIds = e.ViewFormRoleIds,
                            EditFormRoleIds = e.EditFormRoleIds
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
        public async Task<List<DataSourceOutputModel>> SearchDataSourceUnAuth(Guid? id, string searchText, string paramsJsonModel, bool? isArchived, List<ValidationMessage> validationmessages, string validCompanies = null, bool isCompanyBased = false)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/SearchDataSourceUnAuth?id=" + id + "&searchText=" + searchText + "&paramsJsonModel=" + paramsJsonModel + "&isArchived=" + isArchived + "&validCompanies=" + validCompanies + "&isCompanyBased=" + isCompanyBased;
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);

                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(result);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var jsonData = JsonConvert.DeserializeObject<List<DataSourceOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = jsonData.Select(e => new DataSourceOutputModel
                        {
                            Id = e.Id,
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
                            DataSetFormJson = e.DataSetFormJson,
                            DataSetId = e.DataSetId,
                            ViewFormRoleIds = e.ViewFormRoleIds,
                            EditFormRoleIds = e.EditFormRoleIds
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
        public async Task<List<DataSourceKeysOutputModel>> SearchDataSourceKeys(Guid? id, Guid? dataSourceId, string type, string mongoUrl, string searchText, bool? isOnlyForKeys, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages, string formIdsString = "")
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceKeysApi/SearchDataSourceKeys?Id=" + id + "&dataSourceId=" + dataSourceId + "&formIdsString=" + formIdsString + "&searchText=" + searchText + "&isOnlyForKeys=" + isOnlyForKeys + "&type=" + type;
                    if(mongoUrl != null)
                    {
                        client.BaseAddress = new Uri(mongoUrl + serviceurl) ;
                    }
                    else
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);
                    }
                     
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<DataSourceKeysOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = result.Select(e => new DataSourceKeysOutputModel
                        {
                            Id = e.Id,
                            Key = e.Key,
                            Label = e.Label,
                            DataSourceId = e.DataSourceId,
                            GenericFormId = e.GenericFormId,
                            Type = e.Type,
                            DecimalLimit = e?.DecimalLimit,
                            IsArchived = e.IsArchived,
                            FormName = e.FormName,
                            Fields = e.Fields,
                            Format = e.Format,
                            Delimiter = e?.Delimiter,
                            RequireDecimal = e?.RequireDecimal,
                            Path = e?.Path,
                            Properties = e?.Properties,
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


        public async Task<List<DataSourceKeysOutputModel>> SearchDataSourceKeysAnonymous(Guid? id, Guid? dataSourceId, string searchText, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceKeysApi/SearchDataSourceKeysAnonymous?Id=" + id + "&dataSourceId=" + dataSourceId + "&searchText=" + searchText;
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);

                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<DataSourceKeysOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = result.Select(e => new DataSourceKeysOutputModel
                        {
                            Id = e.Id,
                            Key = e.Key,
                            Label = e.Label,
                            DataSourceId = e.DataSourceId,
                            GenericFormId = e.GenericFormId,
                            Type = e.Type,
                            DecimalLimit = e?.DecimalLimit,
                            IsArchived = e.IsArchived,
                            FormName = e.FormName,
                            Fields = e.Fields,
                            Delimiter = e?.Delimiter,
                            RequireDecimal = e?.RequireDecimal
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

        public async Task<DataSourceKeysConfiguration> SearchDataSourceKeysConfiguration(Guid? id, Guid? dataSourceId, Guid? dataSourceKeyId, Guid? customApplicationId, bool? isOnlyForKeys, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceKeysApi/SearchDataSourceKeysConfiguration?Id=" + id + "&dataSourceId=" + dataSourceId + "&dataSourceKeyId=" + dataSourceKeyId + "&customApplicationId=" + customApplicationId + "&isOnlyForKeys=" + isOnlyForKeys;
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<DataSourceKeysConfiguration>(JsonConvert.SerializeObject(dataSetResponse));
                        //var rdata = result.Select(e => new DataSourceKeysConfigurationOutputModel
                        //{
                        //    Id = e.Id,
                        //    CustomApplicationId = e.CustomApplicationId,
                        //    DataSourceKeyId = e.DataSourceKeyId,
                        //    IsTag = e.IsTag,
                        //    IsDefault = e.IsDefault,
                        //    IsTrendsEnable = e.IsTrendsEnable,
                        //    IsPrivate = e.IsPrivate,
                        //    Key = e.Key,
                        //    Label = e.Label,
                        //    FormName = e.FormName,
                        //    Fields = e.Fields,
                        //    DataSourceId = e.DataSourceId

                        //}).ToList();
                        return result;
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

        public async Task<DataSourceKeysConfiguration> SearchDataSourceKeysConfigurationAnonymous(Guid? id, Guid? dataSourceId, Guid? dataSourceKeyId, Guid? customApplicationId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceKeysApi/SearchDataSourceKeysConfigurationAnonymous?Id=" + id + "&dataSourceId=" + dataSourceId + "&dataSourceKeyId=" + dataSourceKeyId + "&customApplicationId=" + customApplicationId;
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);

                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<DataSourceKeysConfiguration>(JsonConvert.SerializeObject(dataSetResponse));
                        //var rdata = result.Select(e => new DataSourceKeysConfigurationOutputModel
                        //{
                        //    Id = e.Id,
                        //    CustomApplicationId = e.CustomApplicationId,
                        //    DataSourceKeyId = e.DataSourceKeyId,
                        //    IsTag = e.IsTag,
                        //    IsDefault = e.IsDefault,
                        //    IsTrendsEnable = e.IsTrendsEnable,
                        //    IsPrivate = e.IsPrivate,
                        //    Key = e.Key,
                        //    Label = e.Label,
                        //    FormName = e.FormName,
                        //    Fields = e.Fields,
                        //    DataSourceId = e.DataSourceId

                        //}).ToList();
                        return result;
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
        public async Task<Guid> UpdateDataSourceKeys(DataSourceKeysInputModel dataSourceKeysInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "";
                    serviceurl = "DataService/DataSourceKeysApi/UpdateDataSourceKeys";

                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);
                  

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSourceKeysInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
                        return new Guid(data);
                    }
                    else
                    {
                        validationmessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });

                        return Guid.Empty;
                    }
                }

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSource", "DataSourceService", exception.Message), exception);
                return Guid.Empty;
            }
        }
        public async Task<Guid> UpdateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSourceKeysInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "";

                    serviceurl = "DataService/DataSourceKeysApi/UpdateDataSourceKeysConfiguration";

                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);
                    

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSourceKeysInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
                        return new Guid(data);
                    }
                    else
                    {
                        validationmessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });

                        return Guid.Empty;
                    }
                }

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSource", "DataSourceService", exception.Message), exception);
                return Guid.Empty;
            }
        }
        public async Task<Guid?> CreateDataLevelKeysConfiguration(UpsertLevelModel upsertLevelModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "";
                    serviceurl = "DataService/DataLevelKeyConfiguration/CreateLevelKeyConfiguration";

                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);
                    
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(upsertLevelModel), Encoding.UTF8, "application/json");
                    var response = client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false).GetAwaiter().GetResult();
                    var stringAsync = await response.Content.ReadAsStringAsync();
                    var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);
                    if (responseJson.Success)
                    {
                        if (responseJson.Data != null)
                        {
                            var response1 = new Guid(responseJson.Data.ToString());
                            return response1;
                        }
                        else
                        {
                            return null;
                        }
                    }


                    else
                    {
                        foreach (var message in responseJson.ApiResponseMessages)
                        {
                            if (!string.IsNullOrEmpty(upsertLevelModel.Level))
                            {
                                message.Message = message.Message.Replace("Level", upsertLevelModel.Level);
                            }
                            validationmessages.Add(new ValidationMessage
                            {
                                ValidationMessageType = MessageTypeEnum.Error,
                                ValidationMessaage = message.Message
                            });
                        }
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

        public async Task<List<SearchAllDataSourcesOutpuutModel>> SearchAllDataSources(GetFormsWithFieldInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/SearchAllDataSources";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(inputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<SearchAllDataSourcesOutpuutModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        return result;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAllDataSources", "DataSourceService", exception.Message), exception);
                return null;
            }
        }

        public async Task<List<GetDataSourcesByIdOutputModel>> GetDataSourcesById(GetDataSourcesByIdInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/GetDataSourcesById";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(inputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<GetDataSourcesByIdOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        return result;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAllDataSources", "DataSourceService", exception.Message), exception);
                return null;
            }
        }

        public async Task<string> GenericQueryApi(string inputQuery, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/GenericQueryApi";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(inputQuery), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        //var result = JsonConvert.DeserializeObject<List<GetDataSourcesByIdOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        return JsonConvert.SerializeObject(dataSetResponse);
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAllDataSources", "DataSourceService", exception.Message), exception);
                return null;
            }
        }
        public async Task<List<UpsertDataLevelKeyConfigurationModel>> SearchLevelKeyConfiguration(Guid? id, Guid? customApplicationId, bool? isArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataLevelKeyConfiguration/SearchLevelKeyConfiguration?id=" + id + "&customApplicationId=" + customApplicationId + "&isArchived=" + isArchived;
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + serviceurl);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(result);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var jsonData = JsonConvert.DeserializeObject<List<UpsertDataLevelKeyConfigurationModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = jsonData;
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

        public Task<List<DataSourceKeysOutputModel>> GetDataSourceKeys(Guid? id, Guid? dataSourceId, string type, string mongoUrl, string searchText, bool? isOnlyForKeys, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string formIdsString = "")
        {
            var dataSourceKeys = SearchDataSourceKeys(id, dataSourceId, type, mongoUrl, searchText, isOnlyForKeys, loggedInContext, validationMessages);
            return dataSourceKeys;
        }
    }
}
