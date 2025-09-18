using Btrak.Models;
using Btrak.Models.FormDataServices;
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

namespace Btrak.Services.FormDataServices
{
    public class DataSourceHistoryService : IDataSourceHistoryService
    {
        public async Task<Guid> CreateDataSourceHistory(DataSourceHistoryInputModel dataSourceHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "";
                  
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);
                    serviceurl = "DataService/DataSourceHistoryApi/CreateDataSourceHistory";
                    
                    
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(dataSourceHistoryInputModel), Encoding.UTF8, "application/json");
                    response = await client.PostAsync(serviceurl, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JsonConvert.DeserializeObject<DataServiceOutputModel>(result).Data.ToString();
                        return new Guid(data);
                    }
                    else
                    {
                        validationMessages.Add(new ValidationMessage
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

        public async Task<List<DataSourceHistoryOutputModel>> SearchDataSourceHistory(Guid? id, Guid? dataSourceId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string serviceurl = "DataService/DataSourceHistoryApi/SearchDataSourceHistory?id=" + id + "&dataSourceId=" + dataSourceId;
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["MongoApiBaseUrl"]);

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.GetAsync(serviceurl).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string result = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(result);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var jsonData = JsonConvert.DeserializeObject<List<DataSourceHistoryOutputModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = jsonData.Select(e => new DataSourceHistoryOutputModel
                        {
                            Id = e.Id,
                            DataSourceId = e.DataSourceId,
                            DataSourceName = e.DataSourceName,
                            FieldName = e.FieldName,
                            Description = e.Description,
                            OldValue = e.OldValue,
                            NewValue = e.NewValue,
                            CreatedDateTime = e.CreatedDateTime

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
    }
}
