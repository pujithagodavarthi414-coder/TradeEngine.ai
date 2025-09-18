using DocumentStorageService.Models;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;

namespace DocumentStorageService.Common
{
   public class ApiWrapper
    {
        private static HttpClient _httpClient;
        private readonly IHttpContextAccessor _httpContextAccessor;

        #region Try GetCallWithAuthorisation
        public static async Task<string> GetApiCallsWithAuthorisation(string serviceUrl, string configurationUrl, List<ParamsInputModel> paramsInputModels, IHttpContextAccessor httpContextAccessor)
        {
            try
            {

                var client = new HttpClient();
                client.BaseAddress = new Uri(configurationUrl);
                var accessToken = httpContextAccessor.HttpContext.Request.Headers["Authorization"];
                client.DefaultRequestHeaders.Add("Authorization", $" {accessToken}");
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var apiUrl = serviceUrl;
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
                var response = client.GetAsync(apiUrl + "").Result;
                var stringAsync = await response.Content.ReadAsStringAsync();

                if (response.IsSuccessStatusCode)
                {
                    var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(stringAsync);

                    var settings = new JsonSerializerSettings
                    {
                        NullValueHandling = NullValueHandling.Ignore,
                        MissingMemberHandling = MissingMemberHandling.Ignore
                    };

                    return stringAsync;
                }
                else
                {
                    return default;
                }
            }
            catch (Exception exception)
            {
                if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
                {
                    var httpInternalServerError = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                    throw new HttpResponseException(httpInternalServerError);
                };
                
            }

            return (null);
        }
        #endregion
    }
}
