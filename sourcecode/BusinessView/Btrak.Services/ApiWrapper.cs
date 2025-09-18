using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.TimeZone;
using Btrak.Models.User;
using BTrak.Common;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace Btrak.Services
{
    public class ApiWrapper
    {
        #region GetAllUsers
        public static async Task<List<UserOutputModel>> GetAllUsers(string serviceUrl, string configurationUrl, Btrak.Models.User.UserSearchCriteriaInputModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                var client = new HttpClient();
                client.BaseAddress = new Uri(configurationUrl + serviceUrl + $"?isActive={model.IsActive}&sortDirectionAsc={model.SortDirectionAsc}");
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var response = client.GetAsync(client.BaseAddress).Result;
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
                    var initialLoginDetails = JsonConvert.DeserializeObject<List<UserOutputModel>>(jsonResponse);
                    return initialLoginDetails;
                }
            }
            catch (Exception exception)
            {
                if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
                {
                    return new List<UserOutputModel>();
                };
                LoggingManager.Error(exception);
                return null;
            }
            return null;
        }
        #endregion

        #region GetAllTimeZoneLists
        public static async Task<List<TimeZoneOutputModel>> GetAllTimeZoneLists(string serviceUrl, string configurationUrl, TimeZoneInputModel timeZoneInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                var client = new HttpClient();
                client.BaseAddress = new Uri(configurationUrl + serviceUrl);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", loggedInContext.authorization);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                timeZoneInputModel = timeZoneInputModel ?? new TimeZoneInputModel();
                StringContent content = new StringContent(JsonConvert.SerializeObject(timeZoneInputModel), Encoding.UTF8, "application/json");
                var response = client.PostAsync(client.BaseAddress, content).Result;
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
                    var initialLoginDetails = JsonConvert.DeserializeObject<List<TimeZoneOutputModel>>(jsonResponse);
                    return initialLoginDetails;
                }
            }
            catch (Exception exception)
            {
                if (exception.InnerException != null && !string.IsNullOrEmpty(exception.InnerException.Message) && exception.InnerException.Message.Contains("The remote name could not be resolved"))
                {
                    return new List<TimeZoneOutputModel>();
                };
                LoggingManager.Error(exception);
                return null;
            }
            return null;
        }
        #endregion
    }
}
