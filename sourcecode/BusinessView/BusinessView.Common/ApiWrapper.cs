
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Configuration;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using BTrak.Common;
//using Microsoft.AspNetCore.Http;
using System.Collections.Generic;
using System.Web.Http;
using Newtonsoft.Json.Serialization;

namespace BusinessView.Common
{
    public class ApiWrapper  //: IApiWrapper
    {
        private HttpClient _httpClient;

        private void GetConnection()
        {
            if (_httpClient == null)
            {
                //_httpClient = new HttpClient { BaseAddress = new Uri(BusinessViewApiUrls.BusinessViewApiUrl) };
            }
        }



        //#region Try Login
        //public async Task<T> PostLogin<T>(string serviceUrl, string email, string password)
        //{
        //    try
        //    {
        //        GetConnection();

        //        _httpClient.BaseAddress = new Uri(BusinessViewApiUrls.BusinessViewApiUrl);

        //        _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));//ACCEPT header

        //        HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, BusinessViewApiUrls.BusinessViewApiUrl + serviceUrl)
        //        {
        //            Content = new StringContent("grant_type=password&username=" + email + "&password=" + password,
        //                                        Encoding.UTF8,
        //                                        "application/x-www-form-urlencoded") //CONTENT-TYPE header
        //        };

        //        request.Content.Headers.ContentType = new MediaTypeHeaderValue("application/x-www-form-urlencoded");

        //        var response = await _httpClient.SendAsync(request);

        //        var stringAsync = await response.Content.ReadAsStringAsync();

        //        if (response.IsSuccessStatusCode)
        //        {
        //            var responseJson = stringAsync;

        //            return JsonConvert.DeserializeObject<T>(responseJson);
        //        }

        //        LoggingManager.Error("Received error response: " + stringAsync);

        //        return default(T);
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(exception);
        //        return default(T);

        //    }
        //}
        //#endregion

        //#region Get results from api with authorization
        //public async Task<T> GetResultsFromApiWithAuthorization<T>(string serviceUrl, ApplicationContext applicationContext)
        //{
        //    try
        //    {
        //        using (var httpClient = new HttpClient())
        //        {
        //            httpClient.BaseAddress = new Uri(BusinessViewApiUrls.BusinessViewApiUrl);

        //            httpClient.DefaultRequestHeaders.Add("Authorization", "Bearer " + applicationContext.AccessToken);

        //            httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));//ACCEPT header

        //            var stringContentInput = new StringContent(string.Empty, Encoding.UTF8, "application/json");

        //            var response = await httpClient.PostAsync(new Uri(BusinessViewApiUrls.BusinessViewApiUrl + serviceUrl), stringContentInput);

        //            var stringAsync = await response.Content.ReadAsStringAsync();

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var responseJson = stringAsync;

        //                var content = JsonConvert.DeserializeObject<T>(responseJson);

        //                return content;
        //            }

        //            LoggingManager.Error("Received error response: " + stringAsync);
        //            return default(T);
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(exception);
        //        return default(T);
        //    }
        //}

        //#endregion

        //#region Get data from server
        //public async Task<T> GetResultsFromApiWithAuthorizationUsingGet<T>(string serviceUrl, ApplicationContext applicationContext)
        //{
        //    try
        //    {
        //        using (var httpClient = new HttpClient())
        //        {
        //            httpClient.BaseAddress = new Uri(ConfigurationManager.AppSettings["WebApiUrl"]);

        //            httpClient.DefaultRequestHeaders.Add("Authorization", "Bearer " + applicationContext.AccessToken);

        //            httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

        //            var response = await httpClient.GetAsync(new Uri(BusinessViewApiUrls.BusinessViewApiUrl + serviceUrl));

        //            var stringAsync = await response.Content.ReadAsStringAsync();

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var responseJson = stringAsync;

        //                return JsonConvert.DeserializeObject<T>(responseJson);
        //            }

        //            LoggingManager.Error("Received error response: " + stringAsync);
        //            return default(T);
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(exception);
        //        return default(T);
        //    }
        //}

        //#endregion

        //#region Post data to server
        //public async Task<string> PostEntityToApi<T>(string apiUrl, T dto, ApplicationContext applicationContext)
        //{
        //    try
        //    {
        //        using (var httpClient = new HttpClient())
        //        {
        //            httpClient.BaseAddress = new Uri(BusinessViewApiUrls.BusinessViewApiUrl);

        //            httpClient.DefaultRequestHeaders.Add("Authorization", "Bearer " + applicationContext.AccessToken);

        //            httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));//ACCEPT header

        //            var serializeObject = JsonConvert.SerializeObject(dto, Formatting.None);

        //            var stringContentInput = new StringContent(serializeObject, Encoding.UTF8, "application/json");

        //            var response = await httpClient.PostAsync(new Uri(BusinessViewApiUrls.BusinessViewApiUrl + apiUrl), stringContentInput);

        //            var stringAsync = await response.Content.ReadAsStringAsync();

        //            if (response.IsSuccessStatusCode)
        //            {
        //                var responseJson = stringAsync;

        //                return responseJson;
        //            }

        //            LoggingManager.Error("Received error response: " + stringAsync);
        //            return null;
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(exception);
        //        return null;
        //    }
        //}
        //#endregion

        #region Annonymous Api Post
        public static async Task<string> AnnonymousPostentityToApi<T>(string apiUrl, string configurationUrl, T dto)
        {

            try
            {
                using (var httpReqClient = new HttpClient())
                {
                    //httpReqClient.Timeout = new TimeSpan(0, 10, 0);
                    httpReqClient.BaseAddress = new Uri(configurationUrl);

                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls12 |
                                                           SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

                    ServicePointManager.ServerCertificateValidationCallback = delegate (object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) { return true; };

                    httpReqClient.DefaultRequestHeaders.Accept.Add(
                        new MediaTypeWithQualityHeaderValue("application/json")); //ACCePT header

                    HttpContent stringContentInput = new StringContent(JsonConvert.SerializeObject(dto), Encoding.UTF8, "application/json");

                    //var response = await httpReqClient.PostAsync(new Uri(ConfigurationManager.AppSettings["AuthenticationServiceBasePath"] + apiUrl),
                    //    stringContentInput);
                    var response = await httpReqClient.PostAsync(new Uri(configurationUrl + apiUrl), stringContentInput).ConfigureAwait(false);

                    var stringAsync = await response.Content.ReadAsStringAsync();

                    if (response.IsSuccessStatusCode)
                    {
                        var responseJson = stringAsync;

                        return responseJson;
                    }
                    else if (response.ReasonPhrase == "Unauthorized")
                    {
                        return "Unauthorized";
                    }
                    else
                    {
                        LoggingManager.Error("AnnonymousPostentityToApiAwait error message - " + response.ReasonPhrase);
                        return response.ReasonPhrase;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
            }

            return null;
        }
        #endregion

        #region Annonymous Api Post
        public static async Task<string> AnnonymousPostentityToApiAwait<T>(string apiUrl, string configurationUrl, T dto)
        {

            try
            {
                using (var httpReqClient = new HttpClient())
                {
                    //httpReqClient.Timeout = new TimeSpan(0, 10, 0);
                    httpReqClient.BaseAddress = new Uri(configurationUrl);

                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls12 |
                                                           SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

                    ServicePointManager.ServerCertificateValidationCallback = delegate (object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) { return true; };

                    httpReqClient.DefaultRequestHeaders.Accept.Add(
                        new MediaTypeWithQualityHeaderValue("application/json")); //ACCePT header

                    HttpContent stringContentInput = new StringContent(JsonConvert.SerializeObject(dto), Encoding.UTF8, "application/json");

                    //var response = await httpReqClient.PostAsync(new Uri(ConfigurationManager.AppSettings["AuthenticationServiceBasePath"] + apiUrl),
                    //    stringContentInput);
                     var response = await httpReqClient.PostAsync(new Uri(configurationUrl + apiUrl), stringContentInput).ConfigureAwait(false);

                    var stringAsync = await response.Content.ReadAsStringAsync();

                    if (response.IsSuccessStatusCode)
                    {
                        var responseJson = stringAsync;

                        return responseJson;
                    }
                    else if (response.ReasonPhrase == "Unauthorized")
                    {
                        return "Unauthorized";
                    }
                    else
                    {
                        LoggingManager.Error("AnnonymousPostentityToApiAwait error message - " + response.ReasonPhrase);
                        return response.ReasonPhrase;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
            }

            return null;
        }
        #endregion

        #region Post Api
        public static async Task<string> PostentityToApi<T>(string apiUrl, string configurationUrl, T dto, string accessToken)
        {

            try
            {
                using (var httpReqClient = new HttpClient())
                {
                    //httpReqClient.Timeout = new TimeSpan(0, 10, 0);
                    httpReqClient.BaseAddress = new Uri(configurationUrl);

                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls12 |
                                                           SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

                    ServicePointManager.ServerCertificateValidationCallback = delegate (object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) { return true; };

                    httpReqClient.DefaultRequestHeaders.Add("Authorization",
                        "Bearer " + accessToken);

                    httpReqClient.DefaultRequestHeaders.Accept.Add(
                        new MediaTypeWithQualityHeaderValue("application/json")); //ACCePT header

                    HttpContent stringContentInput = new StringContent(JsonConvert.SerializeObject(dto), Encoding.UTF8, "application/json");

                    var response = await httpReqClient.PostAsync(new Uri(configurationUrl + apiUrl),stringContentInput).ConfigureAwait(false);

                    var stringAsync = await response.Content.ReadAsStringAsync();

                    if (response.IsSuccessStatusCode)
                    {
                        var responseJson = stringAsync;

                        return responseJson;
                    }
                    else if (response.ReasonPhrase == "Unauthorized")
                    {
                        return "Unauthorized";
                    }
                    else
                    {
                        LoggingManager.Error("AnnonymousPostentityToApiAwait error message - " + response.ReasonPhrase);
                        return response.ReasonPhrase;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
            }

            return null;
        }
        #endregion

        #region Put Api
        public static async Task<string> PutentityToApi<T>(string apiUrl, string configurationUrl, T dto, string accessToken)
        {

            try
            {
                using (var httpReqClient = new HttpClient())
                {
                    //httpReqClient.Timeout = new TimeSpan(0, 10, 0);
                    httpReqClient.BaseAddress = new Uri(configurationUrl);

                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls12 |
                                                           SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

                    ServicePointManager.ServerCertificateValidationCallback = delegate (object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) { return true; };

                    httpReqClient.DefaultRequestHeaders.Add("Authorization",
                        "Bearer " + accessToken);

                    httpReqClient.DefaultRequestHeaders.Accept.Add(
                        new MediaTypeWithQualityHeaderValue("application/json")); //ACCePT header

                    HttpContent stringContentInput = new StringContent(JsonConvert.SerializeObject(dto), Encoding.UTF8, "application/json");

                    var response = await httpReqClient.PutAsync(new Uri(configurationUrl + apiUrl), stringContentInput).ConfigureAwait(false);

                    var stringAsync = await response.Content.ReadAsStringAsync();

                    if (response.IsSuccessStatusCode)
                    {
                        var responseJson = stringAsync;

                        return responseJson;
                    }
                    else if (response.ReasonPhrase == "Unauthorized")
                    {
                        return "Unauthorized";
                    }
                    else
                    {
                        LoggingManager.Error("AnnonymousPostentityToApiAwait error message - " + response.ReasonPhrase);
                        return response.ReasonPhrase;
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(exception);
            }

            return null;
        }
        #endregion

        #region Try GetCallWithAuthorisation
        public static async Task<string> GetApiCallsWithAuthorisation(string serviceUrl, string configurationUrl, List<ParamsInputModel> paramsInputModels, string accessToken) //IHttpContextAccessor httpContextAccessor)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(configurationUrl);

                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls12 |
                                                               SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

                    ServicePointManager.ServerCertificateValidationCallback = delegate (object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) { return true; };

                    client.DefaultRequestHeaders.Add("Authorization",
                            "Bearer " + accessToken);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    var apiUrl = serviceUrl;
                    if (paramsInputModels.Count > 0)
                    {
                        if (paramsInputModels.Count == 1)
                        {
                            apiUrl = apiUrl + "?" + paramsInputModels[0].Key + "=" + paramsInputModels[0].Value;
                        }
                        else
                        {
                            apiUrl = apiUrl + "?" + paramsInputModels[0].Key + "=" + paramsInputModels[0].Value;
                            paramsInputModels.RemoveAt(0);
                        }
                        if (paramsInputModels.Count > 1)
                        {
                            foreach (var paramsInput in paramsInputModels)
                            {
                                apiUrl += "&" + paramsInput.Key + "=" + paramsInput.Value;
                            }
                        }
                    }
                    var response = client.GetAsync(apiUrl + "").Result;
                    var stringAsync = await response.Content.ReadAsStringAsync();



                    if (response.IsSuccessStatusCode)
                    {
                        //var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);

                        //var settings = new JsonSerializerSettings
                        //{
                        //    NullValueHandling = NullValueHandling.Ignore,
                        //    MissingMemberHandling = MissingMemberHandling.Ignore
                        //}

                        return stringAsync;
                    }
                    else if (response.ReasonPhrase == "Unauthorized")
                    {
                        return "Unauthorized";
                    }
                    else
                    {
                        LoggingManager.Error("AnnonymousPostentityToApiAwait error message - " + response.ReasonPhrase);
                        return response.ReasonPhrase;
                    }
                }
            }
            catch (Exception exception)
            {
                if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
                {
                    var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                    throw new HttpResponseException(httpInternalServerError);
                };
                LoggingManager.Error(exception);
            }
            return (null);
        }
        #endregion

        #region Try AnnonymousGetCall
        public static async Task<string> AnnonymousGetApiCalls(string serviceUrl, string configurationUrl, List<ParamsInputModel> paramsInputModels) //IHttpContextAccessor httpContextAccessor)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    client.BaseAddress = new Uri(configurationUrl);

                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls12 |
                                                               SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

                    ServicePointManager.ServerCertificateValidationCallback = delegate (object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) { return true; };

                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                    var apiUrl = serviceUrl;
                    if (paramsInputModels.Count > 0)
                    {
                        if (paramsInputModels.Count == 1)
                        {
                            apiUrl = apiUrl + "?" + paramsInputModels[0].Key + "=" + paramsInputModels[0].Value;
                        }
                        else
                        {
                            apiUrl = apiUrl + "?" + paramsInputModels[0].Key + "=" + paramsInputModels[0].Value;
                            paramsInputModels.RemoveAt(0);
                            if (paramsInputModels.Count >= 1)
                            {
                                foreach (var paramsInput in paramsInputModels)
                                {
                                    apiUrl += "&" + paramsInput.Key + "=" + paramsInput.Value;
                                }
                            }
                        }

                    }
                    var response = client.GetAsync(apiUrl+" " ).Result;
                    var stringAsync = await response.Content.ReadAsStringAsync();



                    if (response.IsSuccessStatusCode)
                    {
                        //var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);

                        //var settings = new JsonSerializerSettings
                        //{
                        //    NullValueHandling = NullValueHandling.Ignore,
                        //    MissingMemberHandling = MissingMemberHandling.Ignore
                        //}

                        return stringAsync;
                    }
                    else if (response.ReasonPhrase == "Unauthorized")
                    {
                        return "Unauthorized";
                    }
                    else
                    {
                        LoggingManager.Error("AnnonymousPostentityToApiAwait error message - " + response.ReasonPhrase);
                        return response.ReasonPhrase;
                    }
                }
            }
            catch (Exception exception)
            {
                if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
                {
                    var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                    throw new HttpResponseException(httpInternalServerError);
                };
                LoggingManager.Error(exception);
            }
            return (null);
        }
        #endregion
    }

    //public interface IApiWrapper
    //{
    //}


}