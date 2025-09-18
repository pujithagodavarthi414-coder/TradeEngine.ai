using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.TimeZone;
using Btrak.Services.Helpers.TimeZoneValidationHelpers;
using BTrak.Common;
using BusinessView.Common;
using Newtonsoft.Json.Serialization;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http.Headers;
using System.Net.Http;
using System.Threading.Tasks;
using System.Text;
using JsonDeserialiseData = Btrak.Models.JsonDeserialiseData;

namespace Btrak.Services.TimeZone
{
    public class TimeZoneService : ITimeZoneService
    {

        private readonly TimeZoneRepository _timeZoneRepository;

        public TimeZoneService(TimeZoneRepository timeZoneRepository)
        {
            _timeZoneRepository = timeZoneRepository;
        }

        public Guid? UpsertTimeZone(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeZone", "timeZoneInputModel", timeZoneInputModel, "TimeZone Service"));

            if (!TimeZoneValidationsHelper.UpsertTimeZoneValidation(timeZoneInputModel, validationMessages))
            {
                return null;
            }

            timeZoneInputModel.TimeZoneId = _timeZoneRepository.UpsertTimeZone(timeZoneInputModel, validationMessages, loggedInContext);
            LoggingManager.Debug("TimeZone with the id :" + timeZoneInputModel.TimeZoneId);

            return timeZoneInputModel.TimeZoneId;
        }

        public List<TimeZoneOutputModel> GetAllTimeZones(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllTimeZones", "timeZoneInputModel", timeZoneInputModel, "TimeZone Service"));

            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<TimeZoneOutputModel> timeZoneModels = _timeZoneRepository.GetAllTimeZones(timeZoneInputModel, validationMessages);
            return timeZoneModels;
        }

        public List<TimeZoneOutputModel> GetAllTimeZoneLists(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllTimeZones", "timeZoneInputModel", timeZoneInputModel, "TimeZone Service"));

            if (validationMessages.Count > 0)
            {
                return null;
            }
            var configurationUrl = ConfigurationManager.AppSettings["AuthenticationServiceBasePath"];
            List<TimeZoneOutputModel> timeZoneModels = GetAllTimeZoneLists(RouteConstants.GetAllTimeZonesFromAuthService, configurationUrl, timeZoneInputModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
            return timeZoneModels;

        }

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


        public TimeZoneOutputModel GetTimeZoneById(Guid? timeZoneId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTimeZoneById", "timeZoneId", timeZoneId, "TimeZone Service"));
            if (!TimeZoneValidationsHelper.GetTimeZoneByIdValidation(timeZoneId, validationMessages))
            {
                return null;
            }

            var timeZoneInputModel = new TimeZoneInputModel { TimeZoneId = timeZoneId };

            return _timeZoneRepository.GetAllTimeZones(timeZoneInputModel, validationMessages).FirstOrDefault();
        }
    }
}
