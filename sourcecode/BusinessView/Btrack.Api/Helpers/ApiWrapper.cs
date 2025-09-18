using Btrak.Models;
using BTrak.Api.Models;
using BTrak.Common;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using JsonDeserialiseData = BTrak.Common.JsonDeserialiseData;

namespace BTrak.Api.Helpers
{
    public class ApiWrapper
    {
        private static HttpClient _httpClient;
        private readonly HttpContext _httpContextAccessor;

        #region Try Login
        public static async Task<BtrakJsonResult> PostLogin(string serviceUrl, string configurationUrl, Object loginModel)
        {
            try
            {

                var client = new HttpClient();
                client.BaseAddress = new Uri(configurationUrl);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                StringContent content = new StringContent(JsonConvert.SerializeObject(loginModel), Encoding.UTF8, "application/json");
                var response = client.PostAsync(serviceUrl, content).Result;
                var stringAsync = await response.Content.ReadAsStringAsync();

                if (response.IsSuccessStatusCode)
                {
                    var settings = new JsonSerializerSettings
                    {
                        ContractResolver = new CamelCasePropertyNamesContractResolver(),
                        NullValueHandling = NullValueHandling.Ignore,
                        MissingMemberHandling = MissingMemberHandling.Ignore
                    };
                    var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);
                    var jsonResponse = JsonConvert.SerializeObject(responseJson.Data, settings);
                    var initialLoginDetails = JsonConvert.DeserializeObject<LoginDetailsOutputModel>(jsonResponse);

                    return (new BtrakJsonResult { Data = initialLoginDetails, Success = true });
                }
                else if (response.StatusCode == HttpStatusCode.InternalServerError)
                {
                    if (stringAsync.Contains("IsVerifyFailed"))
                    {
                        var apiResponseMessages = new List<ApiResponseMessage>();
                        var validationMessage = new ApiResponseMessage();
                        validationMessage.Message = "IsVerifyFailed";
                        apiResponseMessages.Add(validationMessage);
                        return (new BtrakJsonResult { Data = null, Success = false, ApiResponseMessages = apiResponseMessages });
                    }
                    else if (stringAsync.Contains("TrailPeriodExpired"))
                    {
                        var apiResponseMessages = new List<ApiResponseMessage>();
                        var validationMessage = new ApiResponseMessage();
                        validationMessage.Message = "TrailPeriodExpired";
                        apiResponseMessages.Add(validationMessage);
                        return (new BtrakJsonResult { Data = null, Success = false, ApiResponseMessages = apiResponseMessages });
                    }
                    else if (stringAsync.Contains("EMPPeriodExpired"))
                    {
                        var apiResponseMessages = new List<ApiResponseMessage>();
                        var validationMessage = new ApiResponseMessage();
                        validationMessage.Message = "EMPPeriodExpired";
                        apiResponseMessages.Add(validationMessage);
                        return (new BtrakJsonResult { Data = null, Success = false, ApiResponseMessages = apiResponseMessages });
                    }
                    else
                    {
                        var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                        throw new HttpResponseException(httpInternalServerError);
                    }
                }
                else
                {
                    var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                    throw new HttpResponseException(httpInternalServerError);
                }
            }
            catch (Exception exception)
            {
                if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
                {
                    var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.Unauthorized);
                    throw new HttpResponseException(httpInternalServerError);
                };
                LoggingManager.Error(exception);
            }

            return (null);
        }
        #endregion

        //    #region Try Getcallswithoutauthorisation
        //    public static async Task<string> GetApiCallsWithoutAuthorisation(string serviceUrl, string configurationUrl, List<ParamsInputModel> paramsInputModels)
        //    {
        //        try
        //        {

        //            var client = new HttpClient();
        //            client.BaseAddress = new Uri(configurationUrl);
        //            client.DefaultRequestHeaders.Accept.Clear();
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            var apiUrl = serviceUrl;
        //            if (paramsInputModels.Count == 1)
        //            {
        //                apiUrl = apiUrl + "?" + paramsInputModels[0].Key + "=" + paramsInputModels[0].Value;
        //            }
        //            else
        //            {
        //                apiUrl = apiUrl + "?" + paramsInputModels[0].Key + "=" + paramsInputModels[0].Value;
        //                paramsInputModels.RemoveAt(0);
        //            }
        //            if (paramsInputModels.Count > 1)
        //            {
        //                foreach (var paramsInput in paramsInputModels)
        //                {
        //                    apiUrl += "&" + paramsInput.Key + "=" + paramsInput.Value;
        //                }
        //            }

        //            var response = client.GetAsync(apiUrl + "").Result;
        //            var stringAsync = await response.Content.ReadAsStringAsync();

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);

        //                var settings = new JsonSerializerSettings
        //                {
        //                    NullValueHandling = NullValueHandling.Ignore,
        //                    MissingMemberHandling = MissingMemberHandling.Ignore
        //                };

        //                return stringAsync;
        //            }
        //            else
        //            {
        //                return default;
        //            }
        //        }
        //        catch (Exception exception)
        //        {
        //            if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
        //            {
        //                var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.InternalServerError);
        //                throw new HttpResponseException(httpInternalServerError);
        //            };
        //            LoggingManager.Error(exception);
        //        }

        //        return (null);
        //    }
        //    #endregion
        //    #region Try PostCallwithoutauthorisation
        //    public static async Task<string> PostApiCallsWithoutAuthorisation(string serviceUrl, string configurationUrl, Object inputModel)
        //    {
        //        try
        //        {

        //            var client = new HttpClient();
        //            client.BaseAddress = new Uri(configurationUrl);
        //            client.DefaultRequestHeaders.Accept.Clear();
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            StringContent content = new StringContent(JsonConvert.SerializeObject(inputModel), Encoding.UTF8, "application/json");
        //            var response = client.PostAsync(serviceUrl, content).Result;
        //            var stringAsync = await response.Content.ReadAsStringAsync();

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);

        //                var settings = new JsonSerializerSettings
        //                {
        //                    NullValueHandling = NullValueHandling.Ignore,
        //                    MissingMemberHandling = MissingMemberHandling.Ignore
        //                };

        //                return stringAsync;
        //            }
        //            else
        //            {
        //                return default;
        //            }
        //        }
        //        catch (Exception exception)
        //        {
        //            if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
        //            {
        //                var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.InternalServerError);
        //                throw new HttpResponseException(httpInternalServerError);
        //            };
        //            LoggingManager.Error(exception);
        //        }

        //        return (null);
        //    }
        //    #endregion

        //    #region Try PostCallWithAuthorisation
        //    public static async Task<string> PostApiCallsWithAuthorisation(string serviceUrl, string configurationUrl, Object inputModel, HttpContext httpContextAccessor)
        //    {
        //        try
        //        {

        //            var client = new HttpClient();
        //            client.BaseAddress = new Uri(configurationUrl);
        //            var accessToken = httpContextAccessor.HttpContext.Request.Headers["Authorization"];
        //            client.DefaultRequestHeaders.Add("Authorization", $" {accessToken}");
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            StringContent content = new StringContent(JsonConvert.SerializeObject(inputModel), Encoding.UTF8, "application/json");
        //            var response = client.PostAsync(serviceUrl, content).Result;
        //            var stringAsync = await response.Content.ReadAsStringAsync();

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);

        //                var settings = new JsonSerializerSettings
        //                {
        //                    NullValueHandling = NullValueHandling.Ignore,
        //                    MissingMemberHandling = MissingMemberHandling.Ignore
        //                };

        //                return stringAsync;
        //            }
        //            else
        //            {
        //                return default;
        //            }
        //        }
        //        catch (Exception exception)
        //        {
        //            if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
        //            {
        //                var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.InternalServerError);
        //                throw new HttpResponseException(httpInternalServerError);
        //            };
        //            LoggingManager.Error(exception);
        //        }

        //        return (null);
        //    }
        //    #endregion

        //    #region Try PutCallWithAuthorisation
        //    public static async Task<string> PutApiCallsWithAuthorisation(string serviceUrl, string configurationUrl, Object inputModel, HttpContext httpContextAccessor)
        //    {
        //        try
        //        {

        //            var client = new HttpClient();
        //            client.BaseAddress = new Uri(configurationUrl);
        //            var accessToken = httpContextAccessor.HttpContext.Request.Headers["Authorization"];
        //            client.DefaultRequestHeaders.Add("Authorization", $" {accessToken}");
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            StringContent content = new StringContent(JsonConvert.SerializeObject(inputModel), Encoding.UTF8, "application/json");
        //            var response = client.PutAsync(serviceUrl, content).Result;
        //            var stringAsync = await response.Content.ReadAsStringAsync();

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);

        //                var settings = new JsonSerializerSettings
        //                {
        //                    NullValueHandling = NullValueHandling.Ignore,
        //                    MissingMemberHandling = MissingMemberHandling.Ignore
        //                };

        //                return stringAsync;
        //            }
        //            else
        //            {
        //                return default;
        //            }
        //        }
        //        catch (Exception exception)
        //        {
        //            if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
        //            {
        //                var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.InternalServerError);
        //                throw new HttpResponseException(httpInternalServerError);
        //            };
        //            LoggingManager.Error(exception);
        //        }

        //        return (null);
        //    }
        //    #endregion

        //    #region Try GetCallWithAuthorisation
        //    public static async Task<string> GetApiCallsWithAuthorisation(string serviceUrl, string configurationUrl, List<ParamsInputModel> paramsInputModels, HttpContext httpContextAccessor)
        //    {
        //        try
        //        {

        //            var client = new HttpClient();
        //            client.BaseAddress = new Uri(configurationUrl);
        //            var accessToken = httpContextAccessor.HttpContext.Request.Headers["Authorization"];
        //            client.DefaultRequestHeaders.Add("Authorization", $" {accessToken}");
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            var apiUrl = serviceUrl;
        //            if (paramsInputModels.Count == 1)
        //            {
        //                apiUrl = apiUrl + "?" + paramsInputModels[0].Key + "=" + paramsInputModels[0].Value;
        //            }
        //            else
        //            {
        //                apiUrl = apiUrl + "?" + paramsInputModels[0].Key + "=" + paramsInputModels[0].Value;
        //                paramsInputModels.RemoveAt(0);
        //            }
        //            if (paramsInputModels.Count > 1)
        //            {
        //                foreach (var paramsInput in paramsInputModels)
        //                {
        //                    apiUrl += "&" + paramsInput.Key + "=" + paramsInput.Value;
        //                }
        //            }
        //            var response = client.GetAsync(apiUrl + "").Result;
        //            var stringAsync = await response.Content.ReadAsStringAsync();

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);

        //                var settings = new JsonSerializerSettings
        //                {
        //                    NullValueHandling = NullValueHandling.Ignore,
        //                    MissingMemberHandling = MissingMemberHandling.Ignore
        //                };

        //                return stringAsync;
        //            }
        //            else
        //            {
        //                return default;
        //            }
        //        }
        //        catch (Exception exception)
        //        {
        //            if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
        //            {
        //                var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.InternalServerError);
        //                throw new HttpResponseException(httpInternalServerError);
        //            };
        //            LoggingManager.Error(exception);
        //        }

        //        return (null);
        //    }
        //    #endregion

        //    #region Try DeleteCallWithAuthorisation
        //    public static async Task<string> ArchiveApiCallsWithAuthorisation(string serviceUrl, string configurationUrl, BaseInputModel inputModel, HttpContext httpContextAccessor)
        //    {
        //        try
        //        {

        //            var client = new HttpClient();
        //            client.BaseAddress = new Uri(configurationUrl);
        //            var accessToken = httpContextAccessor.HttpContext.Request.Headers["Authorization"];
        //            client.DefaultRequestHeaders.Add("Authorization", $" {accessToken}");
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            var content = JsonConvert.SerializeObject(inputModel.Value);
        //            var response = client.DeleteAsync(serviceUrl + "?" + inputModel.Key + "=" + content + "").Result;
        //            var stringAsync = await response.Content.ReadAsStringAsync();

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);

        //                var settings = new JsonSerializerSettings
        //                {
        //                    NullValueHandling = NullValueHandling.Ignore,
        //                    MissingMemberHandling = MissingMemberHandling.Ignore
        //                };

        //                return stringAsync;
        //            }
        //            else
        //            {
        //                return default;
        //            }
        //        }
        //        catch (Exception exception)
        //        {
        //            if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
        //            {
        //                var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.InternalServerError);
        //                throw new HttpResponseException(httpInternalServerError);
        //            };
        //            LoggingManager.Error(exception);
        //        }

        //        return (null);
        //    }
        //    #endregion

        //    #region TryFileUploadCallWithAuthorisation
        //    public static async Task<string> FileUpload(string serviceUrl, string configurationUrl, IFormFile file, int id, int moduleTypeId, string fileName, string contentType, Guid? parentDocumentId, HttpContext httpContextAccessor)
        //    {
        //        try
        //        {

        //            var client = new HttpClient();
        //            client.BaseAddress = new Uri(configurationUrl);
        //            var accessToken = httpContextAccessor.HttpContext.Request.Headers["Authorization"];
        //            client.DefaultRequestHeaders.Add("Authorization", $" {accessToken}");
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            byte[] data = null;
        //            using (var br = new BinaryReader(file.OpenReadStream()))
        //            {
        //                data = br.ReadBytes((int)file.OpenReadStream().Length);
        //            }
        //            ByteArrayContent bytes = new ByteArrayContent(data);
        //            MultipartFormDataContent multiContent = new MultipartFormDataContent();
        //            multiContent.Add(bytes, "file", file.FileName);
        //            var response = client.PostAsync(serviceUrl + "?id=" + id + "&fileName=" + fileName + "&moduleTypeId=" + moduleTypeId + "&contentType=" + contentType + "&parentDocumentId=" + parentDocumentId + "", multiContent).Result;
        //            var stringAsync = await response.Content.ReadAsStringAsync();

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);

        //                var settings = new JsonSerializerSettings
        //                {
        //                    NullValueHandling = NullValueHandling.Ignore,
        //                    MissingMemberHandling = MissingMemberHandling.Ignore
        //                };

        //                return stringAsync;
        //            }
        //            else
        //            {
        //                return default;
        //            }
        //        }
        //        catch (Exception exception)
        //        {
        //            if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
        //            {
        //                var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.InternalServerError);
        //                throw new HttpResponseException(httpInternalServerError);
        //            };
        //            LoggingManager.Error(exception);
        //        }

        //        return (null);
        //    }
        //    #endregion

        //    #region TryFileUploadPathCallWithAuthorisation
        //    public static async Task<string> FileUploadPath(string serviceUrl, string configurationUrl, string ids, int moduleTypeId, string fileName, string contentType, Guid? parentDocumentId, HttpContext httpContextAccessor)
        //    {
        //        try
        //        {

        //            var client = new HttpClient();
        //            client.BaseAddress = new Uri(configurationUrl);
        //            var accessToken = httpContextAccessor.HttpContext.Request.Headers["Authorization"];
        //            client.DefaultRequestHeaders.Add("Authorization", $" {accessToken}");
        //            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        //            var inputModel = new Object();
        //            StringContent content = new StringContent(JsonConvert.SerializeObject(inputModel), Encoding.UTF8, "application/json"); ;
        //            var response = client.PostAsync(serviceUrl + "?fileName=" + fileName + "&moduleTypeId=" + moduleTypeId + "&list=" + ids + "&contentType=" + contentType + "&parentDocumentId=" + parentDocumentId + "", content).Result;
        //            var stringAsync = await response.Content.ReadAsStringAsync();

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);

        //                var settings = new JsonSerializerSettings
        //                {
        //                    NullValueHandling = NullValueHandling.Ignore,
        //                    MissingMemberHandling = MissingMemberHandling.Ignore
        //                };

        //                return stringAsync;
        //            }
        //            else
        //            {
        //                return default;
        //            }
        //        }
        //        catch (Exception exception)
        //        {
        //            if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
        //            {
        //                var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.InternalServerError);
        //                throw new HttpResponseException(httpInternalServerError);
        //            };
        //            LoggingManager.Error(exception);
        //        }

        //        return (null);
        //    }
        //    #endregion
        //}
    }



}