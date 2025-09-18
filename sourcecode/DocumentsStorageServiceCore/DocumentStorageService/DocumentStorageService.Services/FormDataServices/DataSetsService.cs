using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using DocumentStorageService.Models.FormDataServices;
using DocumentStorageService.Services.Helpers;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Services.FormDataServices
{
    public class DataSetsService : IDataSetsService
    {
        IConfiguration _iconfiguration;
        public DataSetsService(IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
        }
        public void SaveCreateFileHistory(UpsertFileInputModel fileUpsertInputModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var accessToken = loggedInContext.Authorization;
            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                foreach (var file in fileUpsertInputModels.FilesList)
                {
                    List<ValidationMessage> validations = new List<ValidationMessage>();

                    FileValidations.ValidateUpsertFile(file, loggedInContext, validations);

                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                    }
                    else
                    {
                        var dataSetHistoryModel = new DataSetHistoryInputModel();
                        dataSetHistoryModel = new DataSetHistoryInputModel();
                        dataSetHistoryModel.DataSetId = fileUpsertInputModels.ReferenceTypeId;
                        dataSetHistoryModel.Field = fileUpsertInputModels.ReferenceTypeName;
                        dataSetHistoryModel.OldValue = "-";
                        dataSetHistoryModel.NewValue = file.FileName + " ( Uploaded )";

                        CreateDataSetHistory(dataSetHistoryModel, accessToken, validationMessages).GetAwaiter().GetResult();
                    }
                }
            });
        }

        public void SaveDeleteFileHistory(FileApiReturnModel file, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var accessToken = loggedInContext.Authorization;
            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                var dataSetHistoryModel = new DataSetHistoryInputModel();
                dataSetHistoryModel = new DataSetHistoryInputModel();
                dataSetHistoryModel.DataSetId = file.ReferenceTypeId;
                dataSetHistoryModel.Field = file.ReferenceTypeName;
                dataSetHistoryModel.OldValue = file.FileName + " ( Uploaded )";
                dataSetHistoryModel.NewValue = file.FileName + " ( Removed )";
                CreateDataSetHistory(dataSetHistoryModel, accessToken, validationMessages).GetAwaiter().GetResult();
            });
        }

        public async Task<Guid> CreateDataSetHistory(DataSetHistoryInputModel dataSetHistoryInputModel, string accessToken, List<ValidationMessage> validationmessages)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(_iconfiguration["MongoApiBaseUrl"] + "DataService/DataSetHistoryApi/CreateDataSetHistory");
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
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
    }
}
