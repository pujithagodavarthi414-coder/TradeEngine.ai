using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Newtonsoft.Json;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("external-api-caller")]
    public class ExternalApiCallerActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                string apiUrl = externalTask.Variables.ContainsKey("apiUrl") && externalTask.Variables["apiUrl"]?.Value != null ? Convert.ToString(externalTask.Variables["apiUrl"].Value) : string.Empty;
                string apiPath = externalTask.Variables.ContainsKey("apiPath") && externalTask.Variables["apiPath"]?.Value != null ? Convert.ToString(externalTask.Variables["apiPath"].Value) : string.Empty;
                string apiHttpType = externalTask.Variables.ContainsKey("apiHttpType") && externalTask.Variables["apiHttpType"]?.Value != null ? Convert.ToString(externalTask.Variables["apiHttpType"].Value) : "POST";
                string parametersNeedToBeOut = externalTask.Variables.ContainsKey("parametersNeedToBeOut") && externalTask.Variables["parametersNeedToBeOut"]?.Value != null ? (string)externalTask.Variables["parametersNeedToBeOut"].Value : string.Empty;
                string parametersNeedToBeSentThroughApi = externalTask.Variables.ContainsKey("parametersNeedToBeSent") && externalTask.Variables["parametersNeedToBeSent"]?.Value != null ? Convert.ToString(externalTask.Variables["parametersNeedToBeSent"].Value) : string.Empty;
                string userName = externalTask.Variables.ContainsKey("userName") && externalTask.Variables["userName"]?.Value != null ? Convert.ToString(externalTask.Variables["userName"].Value) : string.Empty;
                string password = externalTask.Variables.ContainsKey("password") && externalTask.Variables["password"]?.Value != null ? Convert.ToString(externalTask.Variables["password"].Value) : string.Empty;
                string autheticationToken = externalTask.Variables.ContainsKey("autheticationToken") && externalTask.Variables["autheticationToken"]?.Value != null ? Convert.ToString(externalTask.Variables["autheticationToken"].Value) : string.Empty;

                List<string> parametersNeedToBeOutList = new List<string>();
                if (!string.IsNullOrEmpty(parametersNeedToBeOut))
                    parametersNeedToBeOutList = parametersNeedToBeOut.Split(',').ToList();

                List<string> parametersNeedToBeSentThroughApiList = new List<string>();
                if (!string.IsNullOrEmpty(parametersNeedToBeSentThroughApi))
                    parametersNeedToBeSentThroughApiList = parametersNeedToBeSentThroughApi.Split(',').ToList();


                if (parametersNeedToBeOutList.Count > 0)
                {
                    foreach (var parameter in parametersNeedToBeOutList)
                    {
                        //Add input variables to out put
                        if (externalTask.Variables.ContainsKey(parameter) &&
                            externalTask.Variables[parameter]?.Value != null)
                        {
                            var parameterValue = Convert.ToString(externalTask.Variables[parameter]?.Value);
                            if (resultVariables.ContainsKey(parameter))
                                resultVariables[parameter] = parameterValue;
                            else
                                resultVariables.Add(parameter, parameterValue);
                        }
                    }
                }

                if (parametersNeedToBeSentThroughApiList.Count > 0)
                {
                    Dictionary<string, string> totalParametersNeedToBePass = new Dictionary<string, string>();
                    foreach (string parameter in parametersNeedToBeSentThroughApiList)
                    {
                        string parameterValue = externalTask.Variables.ContainsKey(parameter) && externalTask.Variables[parameter]?.Value != null ? Convert.ToString(externalTask.Variables[parameter].Value) : string.Empty;

                        if (!string.IsNullOrEmpty(parameterValue))
                        {
                            totalParametersNeedToBePass.Add(parameter, parameterValue);
                        }
                    }

                    HttpContent content = new FormUrlEncodedContent(totalParametersNeedToBePass);

                    using (HttpClient client = new HttpClient
                    {
                        BaseAddress = new Uri(apiUrl)
                    })
                    {

                        if (string.Equals(apiHttpType.ToUpper(), "GET"))
                        {
                            apiPath = string.Format(apiPath + "?{0}", HttpUtility.UrlEncode(string.Join("&", totalParametersNeedToBePass.Select(kvp => string.Format("{0}={1}", kvp.Key, kvp.Value)))));
                        }

                        if (!string.IsNullOrEmpty(userName) && !string.IsNullOrEmpty(password))
                        {
                            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(UTF8Encoding.UTF8.GetBytes(userName + ':' + password)));
                        }
                        else if (!string.IsNullOrEmpty(autheticationToken))
                        {
                            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", autheticationToken);
                        }

                        var result = string.Equals(apiHttpType.ToUpper(), "POST") ? client.PostAsync(apiPath, content).Result : client.GetAsync(apiPath).Result;

                        var resultFromApiRequest = result.Content.ReadAsStringAsync().Result;

                        if (parametersNeedToBeOutList.Count > 0)
                        {
                            Dictionary<string, object> stuff = JsonConvert.DeserializeObject<Dictionary<string, object>>(resultFromApiRequest);

                            foreach (var parameter in parametersNeedToBeOutList)
                            {
                                //Add input variables to out put
                                if (stuff.ContainsKey(parameter) &&
                                    stuff.FirstOrDefault(x => x.Key == parameter).Value != null)
                                {
                                    var parameterValue = Convert.ToString(stuff.FirstOrDefault(x => x.Key == parameter).Value);
                                    if (resultVariables.ContainsKey(parameter))
                                        resultVariables[parameter] = parameterValue;
                                    else
                                        resultVariables.Add(parameter, parameterValue);
                                }
                            }
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

    }
}