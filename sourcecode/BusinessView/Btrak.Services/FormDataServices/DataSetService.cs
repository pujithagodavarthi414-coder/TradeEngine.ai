using Btrak.Models;
using Btrak.Models.CustomApplication;
using Btrak.Models.CustomFields;
using Btrak.Models.FormDataServices;
using Btrak.Models.GenericForm;
using Btrak.Models.Notification;
using Btrak.Models.PositionTable;
using Btrak.Models.TradeManagement;
using Btrak.Models.User;
using Btrak.Models.Widgets;
using BTrak.Common;
using IO.ClickSend.Client;
using Nest;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web.Configuration;
using Windows.ApplicationModel.Store;


namespace Btrak.Services.FormDataServices
{
    public class DataSetService : IDataSetService
    {
        public DataSetService()
        {

        }
        public virtual async Task<Guid> CreateDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {

                    if (dataSetUpsertInputModel.Id != null && dataSetUpsertInputModel.Id != Guid.Empty)
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
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSetUpsertInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        string data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", " DataSetService", exception.Message), exception);
                return Guid.Empty;
            }
        }

        public async Task<Guid> CreateDataSetGeneriForm(DataSetUpsertInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {

                    if (dataSetUpsertInputModel.Id != null && dataSetUpsertInputModel.Id != Guid.Empty && dataSetUpsertInputModel.IsNewRecord != true)
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
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSetUpsertInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        string data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", " DataSetService", exception.Message), exception);
                return Guid.Empty;
            }
        }
        public async Task<Guid> CreateDataSetGeneriFormUnAuth(DataSetUpsertInputModel dataSetUpsertInputModel, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {

                    if (dataSetUpsertInputModel.Id != null && dataSetUpsertInputModel.Id != Guid.Empty && dataSetUpsertInputModel.IsNewRecord != true)
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/UpdateDataSetUnAuth");
                    }
                    else
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/CreateDataSetUnAuth");
                    }

                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSetUpsertInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        string data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", " DataSetService", exception.Message), exception);
                return Guid.Empty;
            }
        }

        public async Task<Guid> CreateExecutionDataSet(DataSetUpsertInputModel purchaseExecutionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {

                    if (purchaseExecutionModel.Id != null && purchaseExecutionModel.Id != Guid.Empty)
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
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(purchaseExecutionModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        string data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateExecutionDataSet", " DataSetService", exception.Message), exception);
                return Guid.Empty;
            }
        }

        public async Task<Guid> CreateUserDataSetRelation<T>(T inputModel, string referenceText, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {

                    if (referenceText == "CreateUserDataSetRelation" || referenceText == null)
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/CreateUserDataSetRelation");
                    }
                    else if (referenceText == "UpdateDataSet")
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/UpdateDataSet");
                    }
                    else if (referenceText == "CreateDataSet")
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/CreateDataSet");
                    }

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(inputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        string data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateUserDataSetRelation", " DataSetService", exception.Message), exception);
                return Guid.Empty;
            }
        }
        public virtual async Task<Guid> UpdateDataSetJson(UpdateDataSetJsonModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/UpdateDataSetJson");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSetUpsertInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        string data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", " DataSetService", exception.Message), exception);
                return Guid.Empty;
            }
        }

        public async Task<string> CreateMultipleDataSet(List<DataSetUpsertInputModel> dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {

                    //if (dataSetUpsertInputModel.Id != null && dataSetUpsertInputModel.Id != Guid.Empty)
                    //{
                    //    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/UpdateDataSet");
                    //}
                    //else
                    //{
                    var address = ConfigurationManager.AppSettings["MongoApiBaseUrl"];
                    client.BaseAddress = new Uri(address + "DataService/DataSetApi/CreateMultipleDataSet");
                    //}

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSetUpsertInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        //var data = JsonConvert.DeserializeObject<List<RFQReferenceOutputModel>>(result);
                        return result;
                    }
                    else
                    {
                        validationmessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });
                        return response.ReasonPhrase; // new List<RFQReferenceOutputModel>();
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", " DataSetService", exception.Message), exception);
                //return new List<RFQReferenceOutputModel>();
                return (null);
            }
        }

        public async Task<string> CreateMultipleDataSetSteps(List<DataSetUpsertInputModel> dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    var address = ConfigurationManager.AppSettings["MongoApiBaseUrl"];
                    client.BaseAddress = new Uri(address + "DataService/DataSetApi/CreateMultipleDataSetSteps");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSetUpsertInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        return result;
                    }
                    else
                    {
                        validationmessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });
                        return response.ReasonPhrase; // new List<RFQReferenceOutputModel>();
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateMultipleDataSetSteps", " DataSetService", exception.Message), exception);
                return (null);
            }
        }

        public async Task<Guid> CreatePublicDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {

                    if (dataSetUpsertInputModel.Id != null && dataSetUpsertInputModel.Id != Guid.Empty)
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/UpdatePublicDataSet");
                    }
                    else
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/CreatePublicDataSet");
                    }


                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSetUpsertInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        string data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", " DataSetService", exception.Message), exception);
                return Guid.Empty;
            }
        }

        public async Task<object> GetDataSetById(Guid? id, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/GetDataSetById?Id=" + id);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data;
                        return data;
                    }
                    else
                    {
                        return response;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetById", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public virtual async Task<List<DataSetOutputModel>> SearchDataSets(Guid? id, Guid? dataSourceId, string searchText, string dataJsonValues, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages, bool? isInnerQuery, bool? forFormFieldValue, string keyName, string keyValue, bool? forRecordValue, string paths = null, string companyIds = null, string mongoUrl = null)
        {
            try
            {
                if (isPagingRequired == null)
                {
                    isPagingRequired = false;
                }
                if (pageNumber == null)
                {
                    pageNumber = 0;
                }
                if (pageSize == null)
                {
                    pageSize = 0;

                }
                using (var client = new HttpClient())
                {
                    if(string.IsNullOrEmpty(mongoUrl))
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/SearchDataSet?id=" + id + "&dataSourceId=" + dataSourceId + "&searchText=" + searchText + "&paramsJsonModel=" + dataJsonValues + "&isArchived=" + isArchived + "&isPagingRequired=" + isPagingRequired + "&pageNumber=" + pageNumber + "&pageSize=" + pageSize + "&isInnerQuery=" + isInnerQuery + "&forFormFieldValue=" + forFormFieldValue + "&keyName=" + keyName + "&keyValue=" + keyValue + "&forRecordValue=" + forRecordValue + "&paths=" + paths + "&companyIds=" + companyIds);
                    }
                    else
                    {
                        client.BaseAddress = new Uri(mongoUrl + "DataService/DataSetApi/SearchDataSet?id=" + id + "&dataSourceId=" + dataSourceId + "&searchText=" + searchText + "&paramsJsonModel=" + dataJsonValues + "&isArchived=" + isArchived + "&isPagingRequired=" + isPagingRequired + "&pageNumber=" + pageNumber + "&pageSize=" + pageSize + "&isInnerQuery=" + isInnerQuery + "&forFormFieldValue=" + forFormFieldValue + "&keyName=" + keyName + "&keyValue=" + keyValue + "&forRecordValue=" + forRecordValue + "&paths=" + paths + "&companyIds=" + companyIds);

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
                        var result = JsonConvert.DeserializeObject<List<DataSetOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = result.Select(e => new DataSetOutputModel
                        {
                            Id = e.Id,
                            DataSourceId = e.DataSourceId,
                            DataJson = e.DataJson,
                            DataJsonForFields = e.DataJsonForFields,
                            DataSourceFormJson = e.DataSourceFormJson,
                            DataSourceName = e.DataSourceName,
                            ContractData = e.ContractData,
                            TotalCount = e.TotalCount,
                            CreatedDateTime = e.CreatedDateTime,
                            UpdatedDateTime = e.UpdatedDateTime,
                            CreatedByUserId = e.CreatedByUserId,
                            UpdatedByUserId = e.UpdatedByUserId,
                            PurchaseContracts = e.PurchaseContracts,
                            SalesContracts = e.SalesContracts,
                            VesselContractId = e.VesselContractId

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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public virtual async Task<List<DataSetLivesOutputModel>> SearchLivesDataSets(Guid? id, Guid? dataSourceId, string searchText, string dataJsonValues, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                if (isPagingRequired == null)
                {
                    isPagingRequired = false;
                }
                if (pageNumber == null)
                {
                    pageNumber = 0;
                }
                if (pageSize == null)
                {
                    pageSize = 0;
                }
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/SearchDataSet?id=" + id + "&dataSourceId=" + dataSourceId + "&searchText=" + searchText + "&paramsJsonModel=" + dataJsonValues + "&isArchived=" + isArchived + "&isPagingRequired=" + isPagingRequired + "&pageNumber=" + pageNumber + "&pageSize=" + pageSize);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<DataSetLivesOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = result.Select(e => new DataSetLivesOutputModel
                        {
                            Id = e.Id,
                            DataSourceId = e.DataSourceId,
                            DataJson = e.DataJson,
                            DataSourceFormJson = e.DataSourceFormJson,
                            DataSourceName = e.DataSourceName,
                            TotalCount = e.TotalCount,
                            CreatedDateTime = e.CreatedDateTime,
                            UpdatedDateTime = e.UpdatedDateTime,
                            CreatedByUserId = e.CreatedByUserId,
                            UpdatedByUserId = e.UpdatedByUserId

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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchLivesDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public dynamic SearchDynamicDataSets(Guid? id, Guid? dataSourceId, string searchText, string dataJsonValues, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                if (isPagingRequired == null)
                {
                    isPagingRequired = false;
                }
                if (pageNumber == null)
                {
                    pageNumber = 0;
                }
                if (pageSize == null)
                {
                    pageSize = 0;
                }
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/SearchDataSet?id=" + id + "&dataSourceId=" + dataSourceId + "&searchText=" + searchText + "&paramsJsonModel=" + dataJsonValues + "&isArchived=" + isArchived + "&isPagingRequired=" + isPagingRequired + "&pageNumber=" + pageNumber + "&pageSize=" + pageSize);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = client.GetAsync(client.BaseAddress).ConfigureAwait(false).GetAwaiter().GetResult();
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;

                        return dataSetResponse;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchLivesDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }
        public dynamic SearchDynamicDataSetsWithReference(Guid? id, Guid? dataSourceId, string searchText, string dataJsonValues, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, string referenceText, Guid? referenceId, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                if (isPagingRequired == null)
                {
                    isPagingRequired = false;
                }
                if (pageNumber == null)
                {
                    pageNumber = 0;
                }
                if (pageSize == null)
                {
                    pageSize = 0;
                }
                using (var client = new HttpClient())
                {

                    if (referenceText == null)
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/SearchDataSet?id=" + id + "&dataSourceId=" + dataSourceId + "&searchText=" + searchText + "&paramsJsonModel=" + dataJsonValues + "&isArchived=" + isArchived + "&isPagingRequired=" + isPagingRequired + "&pageNumber=" + pageNumber + "&pageSize=" + pageSize);
                    }
                    if (referenceText == "ProgramUniqueId")
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/GetDataSetLatestProgramId?countryId=" + referenceId);
                    }

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = client.GetAsync(client.BaseAddress).ConfigureAwait(false).GetAwaiter().GetResult();
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;

                        return dataSetResponse;
                    }
                    else
                    {
                        return null;
                    }

                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchLivesDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public dynamic DeleteDynamicDataSets(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/DeleteDatasetById?id=" + id);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = client.GetAsync(client.BaseAddress).ConfigureAwait(false).GetAwaiter().GetResult();
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;

                        return dataSetResponse;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteLivesDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<List<DataSetOutputModelForForms>> SearchDataSetsForForms(Guid? id, Guid? dataSourceId, string searchText, string dataJsonValues, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, bool advancedFilter, string fieldsJson, string keyFilterJson,bool isRecordLevelPermissionEnabled, int ConditionalEnum, string RoleIds, string recordFilterJson, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                if (isPagingRequired == null)
                {
                    isPagingRequired = false;
                }
                if (pageNumber == null)
                {
                    pageNumber = 0;
                }
                if (pageSize == null)
                {
                    pageSize = 0;
                }
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/SearchDataSetForForms?id=" + id + "&dataSourceId=" + dataSourceId + "&searchText=" + searchText + "&paramsJsonModel=" + dataJsonValues + "&isArchived=" + isArchived + "&isPagingRequired=" + isPagingRequired + "&pageNumber=" + pageNumber + "&pageSize=" + pageSize + "&advancedFilter=" + advancedFilter + "&fieldsJson=" + fieldsJson + "&keyFilterJson=" + keyFilterJson + "&isRecordLevelPermissionEnabled=" + isRecordLevelPermissionEnabled + "&ConditionalEnum=" + ConditionalEnum + "&RoleIds=" + RoleIds + "&recordFilterJson=" + recordFilterJson);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<DataSetOutputModelForForms>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = result.Select(e => new DataSetOutputModelForForms
                        {
                            Id = e.Id,
                            DataSourceId = e.DataSourceId,
                            DataJson = e.DataJson,
                            DataSourceFormJson = e.DataSourceFormJson,
                            DataSourceName = e.DataSourceName,
                            TotalCount = e.TotalCount,
                            CreatedDateTime = e.CreatedDateTime,
                            CreatedByUserId = e.CreatedByUserId,
                            UpdatedByUserId = e.UpdatedByUserId,
                            IsPdfGenerated = e.IsPdfGenerated,
                            IsApproved = e.DataJson.IsApproved

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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<List<DataSetOutputModelForForms>> SearchDataSetsForFormsUnAuth(Guid? id, Guid? dataSourceId, string searchText, string dataJsonValues, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, bool advancedFilter, string fieldsJson, string keyFilterJson,  List<ValidationMessage> validationmessages)
        {
            try
            {
                if (isPagingRequired == null)
                {
                    isPagingRequired = false;
                }
                if (pageNumber == null)
                {
                    pageNumber = 0;
                }
                if (pageSize == null)
                {
                    pageSize = 0;
                }
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/SearchDataSetForFormsUnAuth?id=" + id + "&dataSourceId=" + dataSourceId + "&searchText=" + searchText + "&paramsJsonModel=" + dataJsonValues + "&isArchived=" + isArchived + "&isPagingRequired=" + isPagingRequired + "&pageNumber=" + pageNumber + "&pageSize=" + pageSize + "&advancedFilter=" + advancedFilter + "&fieldsJson=" + fieldsJson + "&keyFilterJson=" + keyFilterJson);

                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<DataSetOutputModelForForms>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = result.Select(e => new DataSetOutputModelForForms
                        {
                            Id = e.Id,
                            DataSourceId = e.DataSourceId,
                            DataJson = e.DataJson,
                            DataSourceFormJson = e.DataSourceFormJson,
                            DataSourceName = e.DataSourceName,
                            TotalCount = e.TotalCount,
                            CreatedDateTime = e.CreatedDateTime,
                            CreatedByUserId = e.CreatedByUserId,
                            UpdatedByUserId = e.UpdatedByUserId,
                            IsPdfGenerated = e.IsPdfGenerated,
                            IsApproved = e.DataJson.IsApproved

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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<List<ExecutionStepsDataSetOutputModel>> SearchExecutionStepsDataSets(Guid? id, Guid? dataSourceId, string searchText, string dataJsonValues, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                if (isPagingRequired == null)
                {
                    isPagingRequired = false;
                }
                if (pageNumber == null)
                {
                    pageNumber = 0;
                }
                if (pageSize == null)
                {
                    pageSize = 0;
                }
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/SearchDataSet?id=" + id + "&dataSourceId=" + dataSourceId + "&searchText=" + searchText + "&paramsJsonModel=" + dataJsonValues + "&isArchived=" + isArchived + "&isPagingRequired=" + isPagingRequired + "&pageNumber=" + pageNumber + "&pageSize=" + pageSize);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<ExecutionStepsDataSetOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));

                        var rdata = result?.Select(e => new ExecutionStepsDataSetOutputModel
                        {
                            Id = e.Id,
                            DataSourceId = e.DataSourceId,
                            DataJson = e.DataJson,
                            DataSourceFormJson = e.DataSourceFormJson,
                            DataSourceName = e.DataSourceName,
                            TotalCount = e.TotalCount,
                            CreatedDateTime = e.CreatedDateTime,
                            CreatedByUserId = e.CreatedByUserId,
                            UpdatedByUserId = e.UpdatedByUserId
                        })?.ToList();

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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchExecutionStepsDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<int?> GetDataSetsCountBasedOnTodaysCount(LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/GetDataSetCountBasedOnTodaysCount");

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<int?>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = Convert.ToInt32(result);
                        return rdata;
                    }
                    else
                    {
                        return 0;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", " DataSetService", exception.Message), exception);
                return 0;
            }
        }

        public async Task<int?> GetPublicDataSetsCountBasedOnTodaysCount(List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/GetPublicDataSetCountBasedOnTodaysCount");
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<int?>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = Convert.ToInt32(result);
                        return rdata;
                    }
                    else
                    {
                        return 0;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", " DataSetService", exception.Message), exception);
                return 0;
            }
        }

        public async Task<Guid> CreateDataSetHistory(DataSetHistoryInputModel dataSetHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {

                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetHistoryApi/CreateDataSetHistory");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSetHistoryInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        string data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", " DataSetService", exception.Message), exception);
                return Guid.Empty;
            }
        }

        public object DeleteDatasetById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/DeleteDatasetById?id=" + id);
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = client.GetAsync(client.BaseAddress).ConfigureAwait(false).GetAwaiter().GetResult();
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var dataSetResponse = apiResponse; return dataSetResponse;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchLivesDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<bool?> DeleteMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/DeleteMultipleDatasets");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(inputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        return true;
                    }
                    else
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteMultipleDatasets", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<bool?> UnArchiveMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/UnArchiveMultipleDataSets");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(inputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        return true;
                    }
                    else
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UnArchiveMultipleDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }
        public async Task<FormFieldValuesOuputModel> GetFormFieldValues(GetFormFieldValuesInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/GetFormFieldValues";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(inputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<FormFieldValuesOuputModel>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormFieldValues", "DataSetService", exception.Message), exception);
                return null;
            }
        }
        public async Task<dynamic> GetFormRecordValues(GetFormRecordValuesInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/GetFormRecordValues";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(inputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var data1 = JsonConvert.DeserializeObject<dynamic>(dataSetResponse.ToString());
                        var result = JsonConvert.DeserializeObject<dynamic>(JsonConvert.SerializeObject(dataSetResponse));
                        return data1;
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormRecordValues", "DataSetService", exception.Message), exception);
                return null;
            }
        }
        public async Task<PositionDashboardOutputModel> GetPositionTable(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/GetDashboard";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(new { ProductType = productType, ContractUniqueId = ContractUniqueId, FromDate = fromDate, Todate = ToDate }), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<PositionDashboardOutputModel>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormFieldValues", "DataSetService", exception.Message), exception);
                return new PositionDashboardOutputModel();
            }
        }

        public async Task<InstanceLevelPositionDashboardOutputModel> GetInstanceLevelDashboardPositionTable(string productType, string companyName, DateTime? fromDate, DateTime? ToDate, bool? isConsolidated, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/GetInstanceLevelDashboard";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(new { ProductType = productType, FromDate = fromDate, Todate = ToDate, CompanyName = companyName, IsConsolidated = isConsolidated }), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<InstanceLevelPositionDashboardOutputModel>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormFieldValues", "DataSetService", exception.Message), exception);
                return new InstanceLevelPositionDashboardOutputModel();
            }
        }
        public async Task<InstanceLevelPositionDashboardOutputModel> GetInstanceLevelProfitAndLossDashboardPositionTable(string productType, string companyName, DateTime? fromDate, DateTime? ToDate, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/GetInstanceLevelProfitAndLossDashboard";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(new { ProductType = productType, FromDate = fromDate, Todate = ToDate, CompanyName = companyName }), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<InstanceLevelPositionDashboardOutputModel>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormFieldValues", "DataSetService", exception.Message), exception);
                return new InstanceLevelPositionDashboardOutputModel();
            }
        }

        public async Task<VesselDashboardModel> GetVesselDashboard(string productType, string companyName, DateTime? fromDate, DateTime? ToDate, bool? isConsolidated, string contractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/GetVesselDashboard";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(new { ProductType = productType, FromDate = fromDate, Todate = ToDate, CompanyName = companyName, IsConsolidated = isConsolidated, ContractUniqueId = contractUniqueId }), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<VesselDashboardModel>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormFieldValues", "DataSetService", exception.Message), exception);
                return new VesselDashboardModel();
            }
        }

        public async Task<List<PositionData>> GetPositionsDashboard(DateTime? fromDate, DateTime? ToDate, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/GetPositionsDashboard";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(new { FromDate = fromDate, Todate = ToDate }), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<PositionData>>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPositionsDashboard", "DataSetService", exception.Message), exception);
                return new List<PositionData>();
            }
        }

        public async Task<Guid?> UpdateUserContractQuantity(QuantityInputModel quantityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSourceKeysApi/CreateOrUpdateQunatityDetails");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(quantityInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        string data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", " DataSetService", exception.Message), exception);
                return Guid.Empty;
            }
        }
        public async Task<FinalReliasedOutputModel> GetRealisedProfitAndLoss(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/GetRealisedPandLDashboard";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(new { ProductType = productType, ContractUniqueId = ContractUniqueId, FromDate = fromDate, Todate = ToDate }), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<FinalReliasedOutputModel>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRealisedPandLDashboard", "DataSetService", exception.Message), exception);
                return new FinalReliasedOutputModel();
            }
        }
        public async Task<FinalUnReliasedOutputModel> GetUnRealisedProfitAndLoss(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/GetUnRealisedPandLDashboard";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(new { ProductType = productType, ContractUniqueId = ContractUniqueId, FromDate = fromDate, Todate = ToDate }), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<FinalUnReliasedOutputModel>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUnRealisedPandLDashboard", "DataSetService", exception.Message), exception);
                return new FinalUnReliasedOutputModel();
            }
        }
        public async Task<List<FinalInstanceLevelProfitLossModel>> GetInstanceLevelProfitAndLossDashboard(string productType, string companyName, DateTime? fromDate, DateTime? ToDate, bool? isConsolidated, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/GetInstanceLevelPandLDashboard";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(new { ProductType = productType, CompanyName = companyName, FromDate = fromDate, Todate = ToDate, IsConsolidated = isConsolidated }), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<FinalInstanceLevelProfitLossModel>>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUnRealisedPandLDashboard", "DataSetService", exception.Message), exception);
                return new List<FinalInstanceLevelProfitLossModel>();
            }
        }
        public virtual async Task<List<WebPageViewerModel>> GetWebPageView(string path, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/PdfDesignerApi/GetWebPageView?path=" + path);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<WebPageViewerModel>>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", " DataSetService", exception.Message), exception);
                return null;
            }
        }
        public async Task<WebPageViewerModel> SaveWebPageView(WebPageViewerModel webPageViewerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/PdfDesignerApi/SaveWebPageView";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(webPageViewerModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<WebPageViewerModel>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUnRealisedPandLDashboard", "DataSetService", exception.Message), exception);
                return new WebPageViewerModel();
            }
        }

        public async Task<DataServiceOutputModel> GetMongoQueryDetails(string mongoQuery, bool? isHeaderDetails, string collectionName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    var inputModel = new
                    {
                        MongoQuery = mongoQuery,
                        IsQueryHeaders = isHeaderDetails,
                        CollectionName = collectionName,
                    };

                    string serviceurl = "DataService/DataSetApi/GetQueryData";
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(inputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var result = JsonConvert.DeserializeObject<DataServiceOutputModel>(apiResponse);
                        return result;
                    }
                    else
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });
                        return null;
                    }

                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<DataServiceOutputModel> GetCollections(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {

                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/GetCollections");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = client.GetAsync(client.BaseAddress).ConfigureAwait(false).GetAwaiter().GetResult();
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var result = JsonConvert.DeserializeObject<DataServiceOutputModel>(apiResponse);
                        return result;
                    }
                    else
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });
                        return null;
                    }

                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public async Task<List<string>> GetMongoCollections(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/GetCollections");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(client.BaseAddress).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<string>>(JsonConvert.SerializeObject(dataSetResponse));
                        return result;
                    }
                    else
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMongoCollections", " DataSetService", exception.Message), exception);
                return null;
            }
        }
        public async void UpdateYTDPandLHistory()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceApi/UpdateYTDPandLHistory";
                    DateTime? fromDate = null;
                    DateTime? toDate = null;
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(new { FromDate = fromDate, Todate = toDate }), Encoding.UTF8, "application/json");
                    await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateYTDPandLHistory", "DataSetService", exception.Message), exception);
            }
        }

        public async Task<List<GetCO2EmmisionReportOutputModel>> GetCO2EmmisionReport(GetCO2EmmisionReportInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"] + "DataService/DataSetApi/GetCO2EmmisionReport");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(inputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var dataList = JObject.Parse(result);
                        var dataSetResponse = (bool)dataList["success"] ? (object)dataList["data"] : null;
                        List<GetCO2EmmisionReportOutputModel> data = JsonConvert.DeserializeObject<List<GetCO2EmmisionReportOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        return data;
                    }
                    else
                    {
                        validationmessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = response.ToString()
                        });
                        return new List<GetCO2EmmisionReportOutputModel>();
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCO2EmmisionReport", " DataSetService", exception.Message), exception);
                return new List<GetCO2EmmisionReportOutputModel>();
            }
        }

        public async void FieldUpdateWorkFlow(FieldUpdateWorkFlowModel dataModel, LoggedInContext loggedInContext)
        {
            try
            {
                LoggingManager.Info("DataService call started: " + DateTime.Now.ToString());
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(dataModel.MongoBaseURL + "DataService/DataSetApi/FieldUpdateWorkFlow");

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        LoggingManager.Info("From SyncSubmittedData : data updated Successfully");
                    }
                    else
                    {
                        LoggingManager.Info("From SyncSubmittedData : data update failed getting error form external API call");
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SyncSubmittedData", "DataSetService", exception.Message), exception);
            }
        }

        public async Task<Guid?> UpdateDataSetWorkflow(UpdateDataSetWorkflowModel updateDataSetWorkflowModel, LoggedInContext loggedInContext)
        {
            try
            {
                LoggingManager.Info("UpdateDataSetWorkflow call started: " + DateTime.Now.ToString());
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(updateDataSetWorkflowModel.MongoBaseURL + "DataService/DataSetApi/UpdateDataSetWorkFlow");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(updateDataSetWorkflowModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        LoggingManager.Info("UpdateDataSetWorkflow : record created Successfully");

                        string result = response.Content.ReadAsStringAsync().Result;
                        string data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
                        var dataSetId = new Guid(data);
                        return dataSetId;
                    }
                    else
                    {
                        LoggingManager.Info("UpdateDataSetWorkflow : record creation failed getting error form external API call");
                        return null;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSetWorkflow", " DataSetService", exception.Message), exception);
                return null;
            }
        }

        public async void NotificationAlertWorkFlow(NotificationAlertModel dataModel,string mongoBaseURL, LoggedInContext loggedInContext)
        {
            try
            {
                LoggingManager.Info("NotificationAlertWorkFlow call started: " + DateTime.Now.ToString());
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(mongoBaseURL + "DataService/NotificationApi/NotificationAlertWorkFlow");

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        LoggingManager.Info("From NotificationAlertWorkFlow : Notification sent successfully");
                    }
                    else
                    {
                        LoggingManager.Info("From NotificationAlertWorkFlow : Sending notification failed getting error form external API call");
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "NotificationAlertWorkFlow", "DataSetService", exception.Message), exception);
            }
        }

        public List<GenericFormHistoryOutputModel> SearchGenericFormHistory(Guid? referenceId,int? pageNo, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchCustomFieldsHistory", "CustomField Service"));

            var historyOutputModel = new List<GenericFormHistoryOutputModel>();
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSetHistoryApi/SearchDataSetHistory?dataSetId=" + referenceId+ "&pageNo=" + pageNo+ "&pageSize=" + pageSize;
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = client.GetAsync(serviceurl).ConfigureAwait(false).GetAwaiter().GetResult();
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<DataSetHistoryInputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        if (result.Count > 0)
                        {
                            historyOutputModel = result.Select(e => new GenericFormHistoryOutputModel
                            {
                                Id = e.Id,
                                DataSetId = e.DataSetId,
                                DataSourceName = e.DataSourceName,
                                DataSourceId = e.DataSourceId,
                                Field = e.Field,
                                OldValue = e.OldValue,
                                NewValue = e.NewValue,
                                Description = e.Description,
                                CreatedDateTime = e.CreatedDateTime,
                                CreatedByUserId = e.CreatedByUserId,
                                Label = e.Label,
                                Type = e.Type,
                                Format = e.Format,
                                TotalCount = e.TotalCount
                            }).ToList();

                           

                        }
                        return historyOutputModel;

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
