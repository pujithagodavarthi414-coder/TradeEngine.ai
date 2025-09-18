using System;
using BTrak.Adapter.Interfaces;
using Btrak.Models.Integration;
using System.Net.Http;
using System.Net.Http.Headers;
using Newtonsoft.Json;
using BTrak.Adapter.Models;
using System.Collections.Generic;
using BTrak.Adapter.Common;
using System.Text;

namespace BTrak.Adapter
{
    public class JiraIntegrationService : ModelsConverter, IMyWork
    {
        public bool ValidateIntegrationDetails(IntegrationDetailsModel integrationDetailsModel)
        {
            using (var client = new HttpClient())
            {
                string accessToken = Convert.ToBase64String(Encoding.UTF8.GetBytes(string.Format("{0}:{1}", integrationDetailsModel.UserName, integrationDetailsModel.Password)));

                client.BaseAddress = new Uri(integrationDetailsModel.IntegrationUrl);
                client.DefaultRequestHeaders.Add("Authorization", "Basic " + accessToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Get, string.Format(IntegrationApiUrls.validateUser, integrationDetailsModel.IntegrationUrl));

                var response = client.SendAsync(request).GetAwaiter().GetResult();

                return (bool)(response?.IsSuccessStatusCode);
            }
        }

        public List<MyWorkDetailsModel> GetUserWorkItemsList(UserProjectIntegrationModel userProjectIntegration)
        {
            using (var client = new HttpClient())
            {
                string accessToken = Convert.ToBase64String(Encoding.UTF8.GetBytes(string.Format("{0}:{1}", userProjectIntegration.UserName, userProjectIntegration.Password)));

                client.BaseAddress = new Uri(userProjectIntegration.IntegrationUrl);
                client.DefaultRequestHeaders.Add("Authorization", "Basic " + accessToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                
                string query = "assignee=currentUser()";
                HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Get, string.Format(IntegrationApiUrls.JiraJqlSearch,userProjectIntegration.IntegrationUrl, query));

                var response = client.SendAsync(request).GetAwaiter().GetResult();

                if (response.IsSuccessStatusCode)
                {
                    var data = response.Content.ReadAsStringAsync().GetAwaiter().GetResult();

                    var jiraIssues = JsonConvert.DeserializeObject<JiraIssuesJqlSearchOutputModel>(data, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore });

                    if (jiraIssues.issues != null && jiraIssues.issues.Count > 0)
                    {
                        return ConvertJiraIssuesToMyWorkDetails(jiraIssues.issues);
                    }
                }

                return null;
            }
        }

        public bool AddWorkLogTime(UserProjectIntegrationModel userProjectIntegration,WorkLogTimeInputModel addWorkLogInputModel)
        {
            using (var client = new HttpClient())
            {
                string accessToken = Convert.ToBase64String(Encoding.UTF8.GetBytes(string.Format("{0}:{1}", userProjectIntegration.UserName, userProjectIntegration.Password)));

                client.BaseAddress = new Uri(userProjectIntegration.IntegrationUrl);
                client.DefaultRequestHeaders.Add("Authorization", "Basic " + accessToken);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, string.Format(IntegrationApiUrls.JiraAddWorkLog, userProjectIntegration.IntegrationUrl, addWorkLogInputModel.WorkItemId))
                {
                    Content = new StringContent(JsonConvert.SerializeObject(new JiraWorkLogInputModel { timeSpentSeconds = addWorkLogInputModel.SpentTimeSeconds }, Formatting.None), Encoding.UTF8, "application/json")
                };

                var response = client.SendAsync(request).GetAwaiter().GetResult();

                if (response.IsSuccessStatusCode)
                {
                    return true;
                }

                return false;
            }
        }
    }
}
