using Btrak.Models;
using Btrak.Models.File;
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

namespace Btrak.Services.DocumentStorageServices
{
    public class DocumentStorageService : IDocumentStorageService
    {
        public async Task<List<FileApiServiceReturnModel>> SearchFiles(Guid? referenceId, Guid? referenceTypeId, string referenceTypeName, string documentUrl, string fileName,  LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {
                
                using (var client = new HttpClient())
                {
                    if(documentUrl != null)
                    {
                        client.BaseAddress = new Uri(documentUrl + "File/FileApi/SearchFile?referenceId=" + referenceId + "&referenceTypeId=" + referenceTypeId + "&referenceTypeName=" + referenceTypeName + "&fileName=" + fileName);
                    }
                    else
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["DocumentStorageApiBaseUrl"] + "File/FileApi/SearchFile?referenceId=" + referenceId + "&referenceTypeId=" + referenceTypeId + "&referenceTypeName=" + referenceTypeName + "&fileName=" + fileName);
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
                        var result = JsonConvert.DeserializeObject<List<FileApiServiceReturnModel>>(JsonConvert.SerializeObject(dataSetResponse));
                        var rdata = result.Select(e => new FileApiServiceReturnModel
                        {
                            Id = e.Id,
                            FileId = e.FileId,
                            FileName = e.FileName,
                            Description = e.Description,
                            FileExtension = e.FileExtension,
                            FilePath = e.FilePath,
                            FileSize = e.FileSize,
                            FolderId = e.FolderId,
                            StoreId = e.StoreId,
                            ReferenceId = e.ReferenceId,
                            ReferenceTypeId = e.ReferenceTypeId,
                            ReferenceTypeName = e.ReferenceTypeName,
                            IsArchived = e.IsArchived,
                            CreatedByUserId = e.CreatedByUserId,

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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFiles", " DocumentStorageService", exception.Message), exception);
                return null;
            }
        }

        public async Task<List<Guid?>> UpsertMultipleFiles(UpsertFileInputModel upsertFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {

                using (var client = new HttpClient())
                {
                    if(upsertFileInputModel.DocumentUrl != null)
                    {
                        client.BaseAddress = new Uri(upsertFileInputModel.DocumentUrl + "File/FileApi/UpsertMultipleFiles");
                    }
                    else
                    {
                        client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["DocumentStorageApiBaseUrl"] + "File/FileApi/UpsertMultipleFiles");
                    }

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(upsertFileInputModel), Encoding.UTF8, "application/json");
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<List<Guid?>>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFiles", " DocumentStorageService", exception.Message), exception);
                return null;
            }
        }

        public async Task<string> UploadLocalFileToBlob(UploadFileToBlobInputModel uploadFileToBlobModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            try
            {

                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(WebConfigurationManager.AppSettings["DocumentStorageApiBaseUrl"] + "File/FileApi/UploadLocalFileToBlob");

                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    HttpContent httpContent = new StringContent(JsonConvert.SerializeObject(uploadFileToBlobModel), Encoding.UTF8, "application/json");
                    HttpResponseMessage response = new HttpResponseMessage();
                    response = await client.PostAsync(client.BaseAddress, httpContent).ConfigureAwait(false);
                    if (response.IsSuccessStatusCode)
                    {
                        string apiResponse = response.Content.ReadAsStringAsync().Result;
                        var data = JObject.Parse(apiResponse);
                        var dataSetResponse = (bool)data["success"] ? (object)data["data"] : null;
                        var result = JsonConvert.DeserializeObject<string>(JsonConvert.SerializeObject(dataSetResponse));
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
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFiles", " DocumentStorageService", exception.Message), exception);
                return null;
            }
        }

        public Task<List<FileApiServiceReturnModel>> GetFilesByReferenceId(Guid? referenceId, Guid? referenceTypeId, string referenceTypeName, string documentUrl, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            var filesList = SearchFiles(referenceId, referenceTypeId, referenceTypeName, documentUrl,null, loggedInContext, validationmessages);
            return filesList;
        }

        public Task<List<Guid?>> CreateMultipleFiles(UpsertFileInputModel upsertFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages)
        {
            var filesList = UpsertMultipleFiles(upsertFileInputModel, loggedInContext, validationmessages);
            return filesList;
        }
    }
}
