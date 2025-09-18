using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Net.Http;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.AdhocWork;
using Btrak.Services.Account;
using Btrak.Services.AdhocWork;
using Btrak.Services.CustomApplication;
using Btrak.Services.UserStory;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Dapper;
using Newtonsoft.Json;
using Unity;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("CreateUserStory")]
    [ExternalTaskVariableRequirements("notificationSummary", "goalName", "userStoryType", "userStoryStatus", "estimatedHours", "notificationType")]
    public class CreateUserStoryActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                string summary = (string)externalTask.Variables["notificationSummary"].Value;

                string goalName = (string)externalTask.Variables["goalName"].Value;
                string userStoryType = (string)externalTask.Variables["userStoryType"].Value;
                string userStoryStatus = (string)externalTask.Variables["userStoryStatus"].Value;
                string estimatedHours = (string)externalTask.Variables["estimatedHours"].Value;
                string notificationType = (string)externalTask.Variables["notificationType"].Value;


                //var userst = new UserStoryService();


                using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString))
                {

                    DynamicParameters parameters = new DynamicParameters();
                    parameters.Add("@GoalName", goalName);
                    parameters.Add("@UserStoryType", userStoryType);
                    parameters.Add("@UserStoryStatus", userStoryStatus);

                    //var result = conn.QueryMultiple("USP_GetGoalIds", parameters, commandType: System.Data.CommandType.StoredProcedure);
                    var result1 = conn.Query<UserstoryReferences>("USP_GetGoalIds", parameters, commandType: CommandType.StoredProcedure).FirstOrDefault();

                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryId", Guid.NewGuid());
                    vParams.Add("@GoalId", result1?.GoalId);
                    vParams.Add("@UserStoryName", summary);
                    vParams.Add("@EstimatedTime", Convert.ToInt32(estimatedHours));
                    vParams.Add("@DeadLineDate", DateTimeOffset.Now);
                    vParams.Add("@OwnerUserId", new Guid("1C90BBEB-D85D-4BFB-97F5-48626F6CEB27"));
                    vParams.Add("@DependencyUserId", null);
                    vParams.Add("@Order", null);
                    vParams.Add("@UserStoryStatusId", result1?.UserStatusId);
                    vParams.Add("@IsArchived", null);
                    vParams.Add("@ArchivedDateTime", DateTimeOffset.Now);
                    vParams.Add("@ParkedDateTime", null);
                    vParams.Add("@BugPriorityId", null);
                    vParams.Add("@UserStoryTypeId", result1?.TypeId);
                    vParams.Add("@ProjectFeatureId", null);
                    vParams.Add("@BugCausedUserId", null);
                    vParams.Add("@UserStoryPriorityId", null);
                    vParams.Add("@TestSuiteSectionId", null);
                    vParams.Add("@TestCaseId", null);
                    vParams.Add("@ReviewerUserId", null);
                    vParams.Add("@ParentUserStoryId", null);
                    vParams.Add("@Description", "User story created from the workflow");
                    vParams.Add("@TimeStamp", null, DbType.Binary);
                    vParams.Add("@IsForQa", null);
                    vParams.Add("@VersionName", null);
                    vParams.Add("@Tags", null);
                    vParams.Add("@OperationsPerformedBy", null);
                    conn.Query<Guid?>("USP_AddUserStory", vParams, commandType: CommandType.StoredProcedure);

                    DynamicParameters parameters1 = new DynamicParameters();
                    parameters1.Add("@Summary", summary);
                    parameters1.Add("@NotificationTypeName", notificationType);


                    conn.Query<UserstoryReferences>("USP_InsertNotification", parameters1, commandType: CommandType.StoredProcedure);
                }


            }
            catch (Exception ex)
            {

                Console.WriteLine(ex);
            }


        }

        [ExternalTaskTopic("Resident")]
        class ResidentAdapter : IExternalTaskAdapter
        {

            public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
            {
                // just create an id for demo purposes here


            }

        }



        [ExternalTaskTopic("CreateGoal")]
        class CreateGoalAdapter : IExternalTaskAdapter
        {

            public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
            {
                try
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateGoal", "CreateGoalAdapter"));
                    var userStoryService = Unity.UnityContainer.Resolve<UserStoryService>();
                    var adhocWorkService = Unity.UnityContainer.Resolve<AdhocWorkService>();
                    var userService = Unity.UnityContainer.Resolve<UserService>();
                    string carePlanName = (string)externalTask.Variables["carePlanName"].Value;
                    string loggedUserId = (string)externalTask.Variables["loggedUserId"].Value;
                    string companyId = (string)externalTask.Variables["companyId"].Value;
                    string adhocId = (string)externalTask.Variables["adhocId"].Value;
                
                    if (!string.IsNullOrEmpty(carePlanName))
                    {
                        var result = userStoryService.GetTemplateIdByName(carePlanName, new Guid(companyId));

                        if (result != null)
                        {
                            var userDetails = new LoggedInContext
                            {
                                LoggedInUserId = new Guid(loggedUserId),

                            };
                            Guid userStoryId = new Guid(adhocId);
                            var userStoryDetails = adhocWorkService.GetAdhocWorkByUserStoryId(userStoryId, userDetails, new List<ValidationMessage>());
                            LoggingManager.Debug(result?.ToString());
                            LoggingManager.Debug(userStoryDetails?.ToString());
                            var goalId = userStoryService.InsertGoalByTemplateId(result, false, userDetails, new List<ValidationMessage>(), userStoryDetails?.Tag);
                        }
                    }
                }
                catch (Exception e)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Execute", "CreateUserStoryActivity", e.Message), e);

                    throw;
                }


            }

        }

        [ExternalTaskTopic("CreateEnquiry")]
        [ExternalTaskVariableRequirements("clienttitle", "clientfirstname", "clientlastname", "clientemailaddress", "travellertitle", "travellerfirstname", "travellerlastname", "travelleremailaddress", "adults", "children", "remarks", "arrivalDate", "departureDate", "enquiryCountry", "enquiryCity")]
        class SendEmailWorker : IExternalTaskAdapter
        {
            public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
            {

                string clienttitle = ConfigurationManager.AppSettings["clienttitle"];
                string arrivalDate = (string)externalTask.Variables["arrivalDate"].Value;
                string departureDate = (string)externalTask.Variables["departureDate"].Value;
                string enquiryCountry = (string)externalTask.Variables["enquiryCountry"].Value;
                string enquiryCity = (string)externalTask.Variables["enquiryCity"].Value;
                string clientfirstname = (string)externalTask.Variables["clientfirstname"].Value;
                string clientlastname = (string)externalTask.Variables["clientlastname"].Value;
                string clientemailaddress = (string)externalTask.Variables["clientemailaddress"].Value;
                string travellertitle = (string)externalTask.Variables["travellertitle"].Value;
                string travellerfirstname = (string)externalTask.Variables["travellerfirstname"].Value;
                string travellerlastname = (string)externalTask.Variables["travellerlastname"].Value;
                string travelleremailaddress = (string)externalTask.Variables["country"].Value;
                string remarks = (string)externalTask.Variables["remarks"].Value;
                string adults = (string)externalTask.Variables["adults"].Value;
                string children = (string)externalTask.Variables["children"].Value;

                HttpClient client = new HttpClient();
                client.BaseAddress = new Uri("https://etrakuat.apartmentservice.com");
                var postData = new List<KeyValuePair<string, string>>();
                postData.Add(new KeyValuePair<string, string>("TermsandConditionsIn", "YES"));
                postData.Add(new KeyValuePair<string, string>("GdprIn", "YES"));
                postData.Add(new KeyValuePair<string, string>("Token", "4p4rtm3nt"));
                postData.Add(new KeyValuePair<string, string>("EtrakRef", ""));
                postData.Add(new KeyValuePair<string, string>("EnquirySource", "AIG"));
                postData.Add(new KeyValuePair<string, string>("EnquiryApartmentType", "Studio"));
                postData.Add(new KeyValuePair<string, string>("ArrivalDate", DateTime.ParseExact("12/01/2020", "dd/MM/yyyy", CultureInfo.InvariantCulture).ToString("MM/dd/yyyy", CultureInfo.InvariantCulture)));
                postData.Add(new KeyValuePair<string, string>("Nights", "3"));
                postData.Add(new KeyValuePair<string, string>("EnquiryCity", enquiryCity));
                postData.Add(new KeyValuePair<string, string>("EnquiryCountry", "1"));
                postData.Add(new KeyValuePair<string, string>("ClientTitle", clienttitle));
                postData.Add(new KeyValuePair<string, string>("ClientFirstName", clientfirstname));
                postData.Add(new KeyValuePair<string, string>("ClientLastName", clientlastname));
                postData.Add(new KeyValuePair<string, string>("ClientEmailAddress", clientemailaddress));
                postData.Add(new KeyValuePair<string, string>("TravellerTitle", travellertitle));
                postData.Add(new KeyValuePair<string, string>("TravellerFirstName", travellerfirstname));
                postData.Add(new KeyValuePair<string, string>("TravellerLastName", travellerlastname));
                postData.Add(new KeyValuePair<string, string>("TravellerEmailAddress", travelleremailaddress));
                postData.Add(new KeyValuePair<string, string>("PrimaryContactAsTraveller", "1"));
                postData.Add(new KeyValuePair<string, string>("NumberOfAdults", adults));
                postData.Add(new KeyValuePair<string, string>("NumberOfChildren", children));
                postData.Add(new KeyValuePair<string, string>("Remarks", remarks));

                HttpContent content = new FormUrlEncodedContent(postData);
                var result = client.PostAsync("/MatchFormApi/FormSubmit", content).Result;

                var stringAsync = result.Content.ReadAsStringAsync();
                var entity = JsonConvert.DeserializeObject<EnquiryEntity>(stringAsync.Result);

                if (entity.Status == "Success")
                {
                    Console.WriteLine(entity.enquiryRef);
                }
            }
        }

        public class EnquiryEntity
        {
            public string Status { get; set; }
            public int enquiryRef { get; set; }
        }


    }
}