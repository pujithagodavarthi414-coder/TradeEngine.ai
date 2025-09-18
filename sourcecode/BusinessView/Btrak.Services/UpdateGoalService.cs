using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web.Script.Serialization;
using BTrak.Common;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Burndown;
using Btrak.Models.Goals;
using Btrak.Models.SlackMessages;
using Btrak.Services.BurnDowns;
using Btrak.Services.Chromium;
using Btrak.Services.Dashboard;
using Btrak.Services.Helpers.Goals;
using Btrak.Models.Chat;
using Btrak.Services.PubNub;
using Newtonsoft.Json;
using Btrak.Services.Chat;

namespace Btrak.Services
{
    public class UpdateGoalService : IUpdateGoalService
    {
        private readonly GoalRepository _goalRepository;
        private readonly IChromiumService _chromiumService;
        private readonly IBurndownService _burndownService;
        private readonly MessageRepository _messageRepository;
        private readonly IProcessDashboardService _processDashboardService;
        private IPubNubService _pubNubService;
        private readonly IChatService _chatService;

        public UpdateGoalService(ProcessDashboardService processDashboardService,
                                 GoalRepository goalRepository,
                                 IChromiumService chromiumService,
                                 IBurndownService burndownService,
                                 MessageRepository messageRepository,
                                 IChatService chatService,
                                 IPubNubService pubNubService)

                                 
        {
            _processDashboardService = processDashboardService;
            _goalRepository = goalRepository;
            _chromiumService = chromiumService;
            _burndownService = burndownService;
            _messageRepository = messageRepository;
            _chatService = chatService;
            _pubNubService = pubNubService;
        }

        public GoalUpdateReturnModel UpdateGoalStatuses(Guid? goalId, Guid loggedInUserId)
        {
            LoggingManager.Debug("Entered into Process method in UpdateStatusOfGivenGoal");

            GoalUpdateReturnModel goalUpdateReturnModel = _goalRepository.GetGoalStatus(goalId, loggedInUserId);

            return goalUpdateReturnModel;
        }

        public void UpdateAllGoalStatusColor()
        {
            LoggingManager.Debug("Entered into Process method in UpdateStatusesOfAllGoals");

            var validationMessages = new List<ValidationMessage>();

            GoalSearchCriteriaInputModel goalSearchCriteriaInputModel = new GoalSearchCriteriaInputModel
            {
                GoalStatusId = new Guid("7A79AB9F-D6F0-40A0-A191-CED6C06656DE"),
                IsArchived = false,
                IsParked = false
            };

            LoggedInContext loggedInContext = new LoggedInContext
            {
                LoggedInUserId = new Guid("0B2921A9-E930-4013-9047-670B5352F308"),
                CompanyGuid = new Guid("4AFEB444-E826-4F95-AC41-2175E36A0C16")
            };

            List<GoalSpReturnModel> goals = _goalRepository.SearchGoals(goalSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            foreach (var goal in goals)
            {
                UpdateGoalStatuses(goal.GoalId, loggedInContext.LoggedInUserId);
            }
        }

        public async Task ConvertHtmlToImageAndPushMessageToSlack(string htmlInput, string fileName, string imageText, string wehookUrl)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ConvertHtmlToImageAndPushMessageToSlack", "Update goal service"));
            try
            {
                var fileurl = await _chromiumService.CaptureImage(htmlInput, fileName);

                List<MessageAttachmentsModel> messageAttachmentsModels = new List<MessageAttachmentsModel>();

                MessageAttachmentsModel messageAttachmentsModel = new MessageAttachmentsModel
                {
                    image_url = fileurl
                };
                messageAttachmentsModels.Add(messageAttachmentsModel);

                PushMessageInputModel pushMessageInputModel = new PushMessageInputModel
                {
                    text = imageText,
                    attachments = messageAttachmentsModels
                };

                string message = new JavaScriptSerializer().Serialize(pushMessageInputModel);

                LoggingManager.Debug(message);

                HttpClient client = new HttpClient();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, wehookUrl)
                {
                    Content = new StringContent(message, Encoding.UTF8, "application/json")
                };

                await client.SendAsync(request);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConvertHtmlToImageAndPushMessageToSlack", "UpdateGoalService ", exception.Message), exception);

            }
        }

        public async Task ConvertHtmlToImageAndPushMessageToWebHook(string htmlInput, string fileName, string imageText, string wehookUrl, LoggedInContext loggedInContext)
        {
            try
            {
                var fileurl = await _chromiumService.CaptureImage(htmlInput, fileName);

                LoggingManager.Error(fileurl);

                List<MessageAttachmentsModel> messageAttachmentsModels = new List<MessageAttachmentsModel>();

                MessageAttachmentsModel messageAttachmentsModel = new MessageAttachmentsModel
                {
                    image_url = fileurl
                };
                messageAttachmentsModels.Add(messageAttachmentsModel);

                PushMessageInputModel pushMessageInputModel = new PushMessageInputModel
                {
                    text = imageText,
                    attachments = messageAttachmentsModels
                };

                string message = new JavaScriptSerializer().Serialize(pushMessageInputModel);

                if (wehookUrl.Contains("Webhook?webhook"))
                {

                    WebHookInputModel webHookInputModel = new WebHookInputModel
                    {
                        WebUrl = wehookUrl,
                        ReportMessage = message,
                        SenderId = loggedInContext.LoggedInUserId
                    };

                    using (var client = new HttpClient())
                    {
                        client.BaseAddress = new Uri(wehookUrl.Substring(0, wehookUrl.LastIndexOf('/') + 1));
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                        var Content = new StringContent(JsonConvert.SerializeObject(webHookInputModel), Encoding.UTF8, "application/json");
                        var result = await client.PostAsync(RouteConstants.ChannelWebHook, Content);
                        string resultContent = await result.Content.ReadAsStringAsync();
                        Console.WriteLine(resultContent);
                    }
                }
                else
                {
                    HttpClient client = new HttpClient();
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                    HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Post, wehookUrl)
                    {
                        Content = new StringContent(message, Encoding.UTF8, "application/json")
                    };

                    await client.SendAsync(request).ContinueWith(responseTask => { });
                }

                LoggingManager.Debug("Exit from PushMessageToUserWebHook");
            }
            catch(Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConvertHtmlToImageAndPushMessageToWebHook", "UpdateGoalService ", ex.Message), ex);

            }
        }
        public async Task ConvertHtmlToImageAndPushMessageToBtrakChat(string htmlInput, string fileName, string imageText, string pubnubChannel, Guid? channelId, LoggedInContext loggedInContext)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ConvertHtmlToImageAndPushMessageToSlack", "Update goal service"));
            try
            {
                var fileurl = await _chromiumService.CaptureImage(htmlInput, fileName);

                List<MessageAttachmentsModel> messageAttachmentsModels = new List<MessageAttachmentsModel>();

                MessageAttachmentsModel messageAttachmentsModel = new MessageAttachmentsModel
                {
                    image_url = fileurl
                };
                messageAttachmentsModels.Add(messageAttachmentsModel);

                PushMessageInputModel pushMessageInputModel = new PushMessageInputModel
                {
                    text = imageText,
                    attachments = messageAttachmentsModels
                };

                string message = new JavaScriptSerializer().Serialize(pushMessageInputModel);
                var channelName = pubnubChannel.Substring(0, (pubnubChannel.Length - 37));

                var newMessageId = Guid.NewGuid();

                MessageDto messageDto = new MessageDto
                {
                    Id = newMessageId,
                    ChannelName = channelName,
                    ChannelId = channelId,
                    SenderUserId = loggedInContext.LoggedInUserId,
                    ReportMessage = message,
                    MessageType = "Report",
                    UpdatedDateTime=null,
                    MessageDateTime=DateTime.Now,
                    FromUserId = loggedInContext.LoggedInUserId
                };

                _pubNubService.PublishReportsToChannel(pubnubChannel,JsonConvert.SerializeObject(messageDto), loggedInContext);

                MessageUpsertInputModel insertMessage = new MessageUpsertInputModel
                {
                    IsStarred = null,
                    SenderUserId = loggedInContext.LoggedInUserId,
                    ChannelId = channelId,
                    ChannelName = channelName,
                    ReportMessage = message,
                    MessageType = "Report",
                    Id = newMessageId
                };

                _messageRepository.MessagesInsert(insertMessage, loggedInContext, new List<ValidationMessage>());

                LoggingManager.Debug(message);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConvertHtmlToImageAndPushMessageToBtrakChat", "UpdateGoalService ", exception.Message), exception);

            }
        }
        public async Task PullData(string sqlquery, string fileName, string textShown, string webHook)
        {
            DataTable dataTable = new DataTable();
            string connString = ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString;

            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand(sqlquery, conn);
            conn.Open();

            SqlDataAdapter da = new SqlDataAdapter(cmd);

            da.Fill(dataTable);
            conn.Close();
            da.Dispose();

            string htmlInput = ConvertDataTableToHtml(dataTable);

            if (!string.IsNullOrEmpty(htmlInput))
            {
                await ConvertHtmlToImageAndPushMessageToSlack(htmlInput, fileName, textShown, webHook);
            }
        }

        public async Task PullDataToWebHook(string sqlquery, string fileName, string textShown, string webHook, LoggedInContext loggedInContext)
        {
            try
            {
                DataTable dataTable = new DataTable();
                string connString = ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString;

                SqlConnection conn = new SqlConnection(connString);
                SqlCommand cmd = new SqlCommand(sqlquery, conn);
                conn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                da.Fill(dataTable);
                conn.Close();
                da.Dispose();

                string htmlInput = ConvertDataTableToHtml(dataTable);

                if (!string.IsNullOrEmpty(htmlInput))
                {
                    await ConvertHtmlToImageAndPushMessageToWebHook(htmlInput, fileName, textShown, webHook,loggedInContext);
                }
            }
            catch(Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PullDataToWebHook", "UpdateGoalService ", ex.Message), ex);

            }
        }

        public void ProduceData(string sqlquery)
        {
            string connString = ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            using (SqlCommand cmd = new SqlCommand(sqlquery, conn))
            {
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }

        public async Task PostProcessDashboardToSlack(LoggedInContext loggedInContext, string webhookUrl)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Post process dashboard to slack", "Update goal service"));

            var htmlInput = ConvertDataTableToProcessDashboard(loggedInContext);

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Post process dashboard to slack", htmlInput));

            if (htmlInput != null)
            {
                await ConvertHtmlToImageAndPushMessageToSlack(htmlInput, "ProcessDashboard", "Live Dashboard", webhookUrl);
            }
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Post process dashboard to slack", "Update goal service"));
        }

        public async Task PostProcessDashboardToWebHook(LoggedInContext loggedInContext, string webhookUrl)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Post process dashboard to slack", "Update goal service"));

                var htmlInput = ConvertDataTableToProcessDashboard(loggedInContext);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Post process dashboard to slack", htmlInput));

                if (htmlInput != null)
                {
                    await ConvertHtmlToImageAndPushMessageToWebHook(htmlInput, "ProcessDashboard", "Live Dashboard", webhookUrl, loggedInContext);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Post process dashboard to slack", "Update goal service"));
            }
            catch(Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PostProcessDashboardToWebHook", "UpdateGoalService ", ex.Message), ex);

            }
        }

        public async Task PostLeastPerformingGoalBurndown(LoggedInContext loggedInContext, string webhookUrl)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Post least performing goal", "Update goal service"));

            var burnDownChartModels = GetProcessedBurnDownChartModel(loggedInContext);

            if (burnDownChartModels.Count > 0)
            {
                foreach (var burnDownChartModel in burnDownChartModels)
                {
                    var htmlInput = _burndownService.GetBurndownChartHtml(burnDownChartModel);

                    if (htmlInput != null)
                    {
                        await ConvertHtmlToImageAndPushMessageToSlack(htmlInput, burnDownChartModel.ContainerId, burnDownChartModel.ContainerId, webhookUrl);
                    }
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Post least performing goal", "Update goal service"));
                }
            }
        }

        public async Task PostLeastPerformingGoalBurndownToWebHook(LoggedInContext loggedInContext, string webhookUrl)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Post least performing goal", "Update goal service"));

            var burnDownChartModels = GetProcessedBurnDownChartModel(loggedInContext);

            if (burnDownChartModels.Count > 0)
            {
                foreach (var burnDownChartModel in burnDownChartModels)
                {
                    var htmlInput = _burndownService.GetBurndownChartHtml(burnDownChartModel);

                    if (htmlInput != null)
                    {
                        await ConvertHtmlToImageAndPushMessageToWebHook(htmlInput, burnDownChartModel.ContainerId, burnDownChartModel.ContainerId, webhookUrl, loggedInContext);
                    }
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Post least performing goal", "Update goal service"));
                }
            }
        }

        public string ConvertDataTableToProcessDashboard(LoggedInContext loggedInContext)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ConvertDataTableToProcessDashboard", "Update goal service"));

                var validationMessages = new List<ValidationMessage>();

                var processDashboardEntities = _processDashboardService.SearchOnboardedGoals(null, null,null,loggedInContext, validationMessages).ToList();

                LoggingManager.Debug("process dashboard count for entities : " + processDashboardEntities.Count);

                if (processDashboardEntities.Count > 0)
                {
                    var goalsByResponsiblePerson = processDashboardEntities.GroupBy(p => p.GoalResponsibleUserName, (key, g) => new { GoalResponsiblePersonName = key, Goals = g.ToList() });

                    string html = "<table class=\"table table-responsive table-bordered table-hover table-condensed bg-white-only main-dashboard-table-fixed main-dashboard-div\">";
                    html += "<tr>";
                    html += "<th style=\"width: 10% \">Goal</th>";
                    html += "<th style=\"width: 1 % \">Onboard</th>";
                    html += "<th style=\"width: 10 %\">Goal Status</th>";
                    html += "<th style=\"width: 1 % \">Milestone</th>";
                    html += "<th style=\"width: 1 % \">Delay</th>";
                    html += "<th>Members working on goal</th>";
                    html += "</tr>";
                    foreach (var goal in goalsByResponsiblePerson)
                    {
                        html += "<tr class=\"text-center teamlead-header\">";
                        html += "<td colspan=\"6\" style=\"text-align: center;\">" + goal.GoalResponsiblePersonName + "</td>";
                        html += "<td></td>";
                        html += "<td></td>";
                        html += "<td></td>";
                        html += "<td></td>";
                        html += "<td></td>";
                        html += "</tr>";
                        foreach (var goalDetail in goal.Goals)
                        {
                            html += "<tr class=\"ui-state-default\">";
                            html += "<td class=\"main-process-dashboard\" style=\"width: 10 %;text-align: left \">" + goalDetail.GoalName + "</td>";
                            html += "<td class=\"main-process-dashboard\" style=\"width: 1 %;text-align: center \">" + goalDetail.OnboardProcessedOn + "</td>";
                            if (goalDetail.Deviation > 0)
                            {
                                html += "<td class=\"main-process-dashboard\" style =\"width: 6 %;background-color: " + goalDetail.GoalStatusColor + ";text-align: center\"><b>" + goalDetail.Deviation + "</b></td>";
                            }
                            else
                            {
                                html += "<td class=\"main-process-dashboard\" style =\"width: 6 %;background-color: " + goalDetail.GoalStatusColor + ";text-align: center\"></td>";
                            }
                            html += "<td class=\"main-process-dashboard\" style=\"width: 1 %;text-align: center \">" + goalDetail.MileStoneDate + "</td>";
                            html += "<td class=\"main-process-dashboard\" style = \"width: 1 %;background-color: " + goalDetail.DelayColor + ";text-align: center\">" + goalDetail.Delay + "</td>";
                            html += "<td class=\"main-process-dashboard\" style=\"text-align: left \">";
                            if (!string.IsNullOrEmpty(goalDetail.Members))
                            {
                                string[] members = goalDetail.Members.Split(',');
                                foreach (var member in members)
                                {
                                    if (member.Contains("https:"))
                                    {
                                        html += "<img src=\"" + member + "\" alt=\"Avatar\" style=\"border-radius: 50%; height:20px;width:20px; margin-right: 3px;\">";
                                    }
                                    else
                                    {
                                        html += "<span style=\"width: 20px;height: 18px;text-transform: uppercase; color: rgb(255, 255, 255); background-color: rgb(210, 105, 30); border-radius: 50%; font-size: 13px; padding: 2px 0 0px 0; float: left; text-align: center; margin-right: 3px;\">" + member + "</span>";
                                    }
                                }
                            }

                            html += "</td>";

                            html += "</tr>";
                        }
                    }
                    html += "<tbody class=\"text-font-family\">";

                    html += "</tbody>";
                    html += "</table>";

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ConvertDataTableToProcessDashboard", "Update goal service"));

                    return html;
                }

                LoggingManager.Debug("process dashboard count returning null ");

                return null;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ConvertDataTableToProcessDashboard", "UpdateGoalService ", exception.Message), exception);

                return null;
            }
        }

        public string ConvertDataTableToHtml(DataTable dt)
        {
            if (dt.Rows.Count > 0)
            {
                string html = "<head>\r\n<style>\r\ntable, th, td {\r\n  border: 1px solid black;\r\n}\r\n</style>\r\n</head><table class=\"table table-responsive table-bordered table-hover table-condensed bg-white-only main-dashboard-table-fixed main-dashboard-div\">";

                //add header row
                html += "<tbody class=\"text-font-family\">";
                html += "<tr>";
                for (int i = 0; i < dt.Columns.Count; i++)
                    html += "<td align=\"center\">" + dt.Columns[i].ColumnName + "</td>";
                html += "</tr>";

                //add rows
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    html += "<tr>";
                    for (int j = 0; j < dt.Columns.Count; j++)
                        html += "<td align=\"center\">" + dt.Rows[i][j] + "</td>";
                    html += "</tr>";
                }

                html += "</tbody>";
                html += "</table>";
                return html;
            }

            return null;
        }

        public async Task PostBurndown(string webhookUrl, int yMax, string sqlQuery)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Post burndown", "Update goal service"));

            var burnDownDataPoints = GetProcessedDataPoints(sqlQuery);

            var htmlInput = _burndownService.GetD3BurndownChartHtml(burnDownDataPoints, yMax, null);

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Post burndown", htmlInput));

            if (htmlInput != null)
            {
                await ConvertHtmlToImageAndPushMessageToSlack(htmlInput, "Expected vs actual work burndown", "Expected vs actual work burndown", webhookUrl);
            }
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Post burndown", "Update goal service"));
        }

        public async Task PostBurndownToWebHook(LoggedInContext loggedInContext,string webhookUrl, int yMax, string sqlQuery)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Post burndown", "Update goal service"));

                var burnDownDataPoints = GetProcessedDataPoints(sqlQuery);

                var htmlInput = _burndownService.GetD3BurndownChartHtml(burnDownDataPoints, yMax, loggedInContext.CompanyGuid);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Post burndown", htmlInput));

                if (htmlInput != null)
                {
                    await ConvertHtmlToImageAndPushMessageToWebHook(htmlInput, "Expected vs actual work burndown", "Expected vs actual work burndown", webhookUrl,loggedInContext);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Post burndown", "Update goal service"));
            }
            catch(Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PostBurndownToWebHook", "UpdateGoalService ",ex.Message), ex);

            }
        }

        private List<BurndownModel> GetProcessedDataPoints(string sqlQuery)
        {
            List<BurndownModel> burnDownChartModels = new List<BurndownModel>();

            DataTable dataTable = new DataTable();
            string connString = ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString;

            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand(sqlQuery, conn);
            conn.Open();

            SqlDataAdapter da = new SqlDataAdapter(cmd);

            da.Fill(dataTable);
            conn.Close();
            da.Dispose();

            if (dataTable.Rows.Count > 0)
            {
                for (int i = 0; i < dataTable.Rows.Count; i++)
                {
                    BurndownModel burndownModel = new BurndownModel
                    {
                        date = dataTable.Rows[i][0] == DBNull.Value ? "01/01/2019" : Convert.ToDateTime(dataTable.Rows[i][0]).ToString("dd/MM/yyyy", CultureInfo.InvariantCulture),
                        expected = dataTable.Rows[i][1] == DBNull.Value ? "0" : dataTable.Rows[i][1].ToString(),
                        actual = dataTable.Rows[i][2] == DBNull.Value ? "0" : dataTable.Rows[i][2].ToString(),
                    };
                    burnDownChartModels.Add(burndownModel);
                }
            }

            return burnDownChartModels;
        }

        private List<BurnDownChartModel> GetProcessedBurnDownChartModel(LoggedInContext loggedInContext)
        {
            var validationMessages = new List<ValidationMessage>();
            List<BurnDownChartModel> burnDownChartModels = new List<BurnDownChartModel>();

            var leastPerformingGoals = _goalRepository.GetLeastPerformingGoal(loggedInContext, validationMessages);

            if (leastPerformingGoals.Count > 0)
            {
                var goals = leastPerformingGoals.Select(x => new { x.GoalId, x.GoalName }).Distinct();

                foreach (var goal in goals)
                {
                    var leastPerformingGoalDetails = leastPerformingGoals.Where(x => x.GoalId == goal.GoalId).ToList();
                    List<BurnDownDataModel> burnDownData = new List<BurnDownDataModel>();
                    foreach (var goalDetail in leastPerformingGoalDetails)
                    {
                        BurnDownDataModel burndownModel = new BurnDownDataModel
                        {
                            Date = goalDetail.AxisDates,
                            Standard = goalDetail.Standard,
                            Done = goalDetail.Done
                        };
                        burnDownData.Add(burndownModel);
                    }
                    BurnDownConfigModel configModel = new BurnDownConfigModel
                    {
                        ContainerId = "#" + goal.GoalName,
                        Width = 900,
                        Height = 500,
                        Margins = new MarginsModel
                        {
                            Top = 20,
                            Right = 70,
                            Bottom = 30,
                            Left = 50
                        },
                        DisplayColors = new BurnDownChartDisplayColorsModel
                        {
                            Standard = "#D93F8E",
                            Done = "#5AA6CB",
                            Good = "#97D17A",
                            Bad = "#FA6E69"
                        },
                        StartLabel = "OnBoarded",
                        XTitle = goal.GoalName
                    };
                    BurnDownChartModel burnDownChartModel = new BurnDownChartModel
                    {
                        BurnDownData = burnDownData,
                        ConfigModel = configModel,
                        ContainerId = goal.GoalName
                    };
                    burnDownChartModels.Add(burnDownChartModel);
                }
            }

            return burnDownChartModels;
        }

        public List<string> GetGoalBurnDownChart(Guid? goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Goal Burn Down Chart", "Update goal service"));
            
            if (!GoalServiceValidation.ValidateGoalId(goalId, loggedInContext, validationMessages))
            {
                return null;
            }

            var leastPerformingGoalDetails = _goalRepository.GetGoalBurnDownChart(goalId, loggedInContext, validationMessages);

            List<BurnDownChartModel> burnDownChartModels = BurnDownChartModel(leastPerformingGoalDetails);

            //var burnDownChartModel = GetGoalBurnDownChartModel(goalId,loggedInContext);

            List<string> htmlList = new List<string>();

            if (burnDownChartModels.Count > 0)
            {
                foreach (var burnDownChartModel in burnDownChartModels)
                {
                    var htmlInput = _burndownService.GetBurndownChartHtml(burnDownChartModel);

                    if (htmlInput != null)
                    {
                        htmlList.Add(htmlInput);
                    }
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Post least performing goal", "Update goal service"));
                }
                return htmlList;
            }
            return null;
        }

        public List<string> GetDeveloperBurnDownChartInGoal(Guid? goalId,Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Developer Burn Down Chart In Goal", "Update goal service"));

            if (!GoalServiceValidation.ValidateGoalAndDeveloperId(goalId, userId, loggedInContext, validationMessages))
            {
                return null;
            }

            var leastPerformingGoalDetails = _goalRepository.GetDeveloperBurnDownChartInGoal(goalId, userId, loggedInContext, validationMessages);

            List<BurnDownChartModel> burnDownChartModels = BurnDownChartModel(leastPerformingGoalDetails);

            List<string> htmlList = new List<string>();

            if (burnDownChartModels.Count > 0)
            {
                foreach (var burnDownChartModel in burnDownChartModels)
                {
                    var htmlInput = _burndownService.GetBurndownChartHtml(burnDownChartModel);

                    if (htmlInput != null)
                    {
                        htmlList.Add(htmlInput);
                    }
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Post least performing goal", "Update goal service"));
                }
                return htmlList;
            }
            return null;
        }

        //private BurnDownChartModel GetGoalBurnDownChartModel(Guid goalId,LoggedInContext loggedInContext)
        //{
        //    var validationMessages = new List<ValidationMessage>();
        //    BurnDownChartModel burnDownChartModels = new BurnDownChartModel();

        //    var leastPerformingGoalDetails = _goalRepository.GetLeastPerformingGoal(goalId, loggedInContext, validationMessages);

        //    return BurnDownChartModel(leastPerformingGoalDetails);
        //}

        private List<BurnDownChartModel> BurnDownChartModel(List<LeastPerformingGoalByResponsiblePerson> leastPerformingGoals)
        {
            List<BurnDownChartModel> burnDownChartModels = new List<BurnDownChartModel>();

            if (leastPerformingGoals.Count > 0)
            {
                var goals = leastPerformingGoals.Select(x => new { x.GoalId, x.GoalName }).Distinct();

                foreach (var goal in goals)
                {
                    var leastPerformingGoalDetails = leastPerformingGoals.Where(x => x.GoalId == goal.GoalId).ToList();
                    List<BurnDownDataModel> burnDownData = new List<BurnDownDataModel>();
                    foreach (var goalDetail in leastPerformingGoalDetails)
                    {
                        BurnDownDataModel burndownModel = new BurnDownDataModel
                        {
                            Date = goalDetail.AxisDates,
                            Standard = goalDetail.Standard,
                            Done = goalDetail.Done
                        };
                        burnDownData.Add(burndownModel);
                    }
                    BurnDownConfigModel configModel = new BurnDownConfigModel
                    {
                        ContainerId = "#" + goal.GoalName,
                        Width = 900,
                        Height = 500,
                        Margins = new MarginsModel
                        {
                            Top = 20,
                            Right = 70,
                            Bottom = 30,
                            Left = 50
                        },
                        DisplayColors = new BurnDownChartDisplayColorsModel
                        {
                            Standard = "#D93F8E",
                            Done = "#5AA6CB",
                            Good = "#97D17A",
                            Bad = "#FA6E69"
                        },
                        StartLabel = "OnBoarded",
                        XTitle = goal.GoalName
                    };
                    BurnDownChartModel burnDownChartModel = new BurnDownChartModel
                    {
                        BurnDownData = burnDownData,
                        ConfigModel = configModel,
                        ContainerId = goal.GoalName
                    };
                    burnDownChartModels.Add(burnDownChartModel);
                }
            }
            return burnDownChartModels;
        }

        public List<GoalActivityApiReturnOutputModel> GetGoalAcitivity(Guid? goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Goal Burn Down Chart", "Update goal service"));

            if (!GoalServiceValidation.ValidateGoalId(goalId, loggedInContext, validationMessages))
            {
                return null;
            }

            List<GoalActivityOutputModel> goalActivityOutputModels = _goalRepository.GetGoalActivity(goalId, loggedInContext, validationMessages);

            List<GoalActivityApiReturnOutputModel> goalActivityOutputModelList = new List<GoalActivityApiReturnOutputModel>();

            foreach(GoalActivityOutputModel goalActivityOutputModel in goalActivityOutputModels)
            {
                goalActivityOutputModelList.Add(ConvertToApiModel(goalActivityOutputModel));
            }

            return goalActivityOutputModelList;
        }

        public HeatMapOutputModel GetGoalHeatMap(Guid? goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Goal Burn Down Chart", "Update goal service"));

            if (!GoalServiceValidation.ValidateGoalId(goalId, loggedInContext, validationMessages))
            {
                return null;
            }

            List<HeatMapSpOutputModel> heatMapSpOutputModels = _goalRepository.GetGoalHeatMap(goalId, loggedInContext, validationMessages);

            HeatMapOutputModel heatMapApiOutputModel;

            if (heatMapSpOutputModels.Count > 0)
            {
                heatMapApiOutputModel = ConvetToApiModel(heatMapSpOutputModels);
                return heatMapApiOutputModel;
            }

            return null;
        }

        public HeatMapOutputModel GetDeveloperHeatMap(Guid? goalId, Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Developer Burn Down Chart In Goal", "Update goal service"));

            if (!GoalServiceValidation.ValidateGoalAndDeveloperId(goalId, userId, loggedInContext, validationMessages))
            {
                return null;
            }

            List<HeatMapSpOutputModel> heatMapSpOutputModels = _goalRepository.GetDeveloperHeatMap(goalId, userId, loggedInContext, validationMessages);

            HeatMapOutputModel heatMapApiOutputModel;

            if (heatMapSpOutputModels.Count > 0)
            {
                heatMapApiOutputModel = ConvetToApiModel(heatMapSpOutputModels);
                return heatMapApiOutputModel;
            }
            return null;            
        }

        private HeatMapOutputModel ConvetToApiModel(List<HeatMapSpOutputModel> heatMapSpOutputModels)
        {
            HeatMapApiOutputModel heatMapApiOutputModel = new HeatMapApiOutputModel
            {
                UserStoryId=new List<object>(),
                Date = new List<object>(),                
                UserStoryName = new List<object>(),
                SubSummaryValues=new List<object>(),
                SummaryValue=new List<List<object>>()
            };

            var heatMapValues = heatMapSpOutputModels.OrderBy(x => x.Date);
            
            DateTime? date = null;

            foreach(var heatMapValue in heatMapValues)
            {
                if (heatMapValue.Date == date)
                {                  
                }

                else if(date == null)
                {                  
                    heatMapApiOutputModel.Date.Add(heatMapValue.Date.ToString("dd-MMM-yyyy"));
                }

                else
                {  
                    heatMapApiOutputModel.Date.Add(heatMapValue.Date.ToString("dd-MMM-yyyy"));
                    heatMapApiOutputModel.SummaryValue.Add(heatMapApiOutputModel.SubSummaryValues);
                    heatMapApiOutputModel.SubSummaryValues = new List<object>();
                    heatMapApiOutputModel.UserStoryName = new List<object>();
                    heatMapApiOutputModel.UserStoryId = new List<object>();
                }
                
                heatMapApiOutputModel.UserStoryName.Add(heatMapValue.UserStoryName);
                heatMapApiOutputModel.UserStoryId.Add(heatMapValue.UserStoryId);
                heatMapApiOutputModel.SubSummaryValues.Add(heatMapValue.SummaryValue);
                date = heatMapValue.Date;
            }

            heatMapApiOutputModel.SummaryValue.Add(heatMapApiOutputModel.SubSummaryValues);

            HeatMapOutputModel heatMapOutputModel = new HeatMapOutputModel
            {
                Dates = heatMapApiOutputModel.Date,
                SummaryValue = heatMapApiOutputModel.SummaryValue,
                UserStoryId = heatMapApiOutputModel.UserStoryId,
                UserStoryName = heatMapApiOutputModel.UserStoryName
            };

            return heatMapOutputModel;
        }

        public DeveloperSpentTimeReportOutputModel GetDeveloperSpentTimeReport(Guid? goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Developer Burn Down Chart In Goal", "Update goal service"));

            if (!GoalServiceValidation.ValidateGoalId(goalId, loggedInContext, validationMessages))
            {
                return null;
            }

            List<DeveloperSpentTimeReportSpOutputModel> developerSpentTimeReportSpOutputModels = _goalRepository.GetDeveloperSpentTimeReport(goalId, loggedInContext, validationMessages);

            DeveloperSpentTimeReportOutputModel developerSpentTimeReportApiOutputModel;

            if (developerSpentTimeReportSpOutputModels.Count > 0)
            {
                developerSpentTimeReportApiOutputModel = ConvetToApiModel(developerSpentTimeReportSpOutputModels);
                return developerSpentTimeReportApiOutputModel;
            }
            return null;
            
        }

        private DeveloperSpentTimeReportOutputModel ConvetToApiModel(List<DeveloperSpentTimeReportSpOutputModel> spentTimeReportSpModels)
        {
            DeveloperSpentTimeReportOutputModel developerSpentTimeReportOutputModel =
                new DeveloperSpentTimeReportOutputModel
                {
                    SummaryValue = new List<object>(),
                    Date = new List<object>(),
                    DeveloperName = new List<object>(),
                    SpentTime = new List<object>(),
                    StatusColor = new List<object>(),
                    UserStoryId = new List<object>(),
                    UserStoryName = new List<object>(),
                    UserStoryStatus = new List<object>(),
                    TotalSpentTimeSoFar = new List<object>(),
                    UniqueName = new List<object>()
                };
            DeveloperSpentTimeReportApiOutputModel spentTimeReportApiModel = new DeveloperSpentTimeReportApiOutputModel
            {
                UserStoryId = new List<object>(),
                Date = new List<string>(),
                StatusColor = new List<List<object>>(),
                SubDates = new List<object>(),
                SubStatusColors = new List<object>(),
                SubUserStoryStatus = new List<object>(),
                UserStoryName = new List<object>(),
                UserStoryStatus = new List<List<object>>(),
                DeveloperName = new List<object>(),
                SpentTime=new List<List<object>>(),
                SubSpentTime=new List<object>(),
                SummaryValue = new List<List<object>>(),
                TotalSpentTimeSoFar = new List<List<object>>(),
                SubTotalSpentTimeSoFar = new List<object>(),
                SubSummaryValue = new List<object>(),
                UniqueName = new List<object>()
            };
            var spentTimeReportModels = spentTimeReportSpModels.OrderBy(x => x.Date);
            
            DateTime? date = null;
            foreach (var spentTimeReportModel in spentTimeReportModels)
            {
                if (spentTimeReportModel.Date == date)
                {
                }
                else if (date == null)
                {
                    spentTimeReportApiModel.Date.Add(spentTimeReportModel.Date.ToString("dd-MMM-yyyy"));
                }
                else
                {
                    spentTimeReportApiModel.Date.Add(spentTimeReportModel.Date.ToString("dd-MMM-yyyy"));
                    spentTimeReportApiModel.DeveloperName.Add(spentTimeReportModel.DeveloperName);
                    spentTimeReportApiModel.UniqueName.Add(spentTimeReportModel.UniqueName);
                    spentTimeReportApiModel.StatusColor.Add(spentTimeReportApiModel.SubStatusColors);
                    spentTimeReportApiModel.SummaryValue.Add(spentTimeReportApiModel.SubSummaryValue);
                    spentTimeReportApiModel.TotalSpentTimeSoFar.Add(spentTimeReportApiModel.SubTotalSpentTimeSoFar);
                    spentTimeReportApiModel.UserStoryStatus.Add(spentTimeReportApiModel.SubUserStoryStatus);
                    spentTimeReportApiModel.SpentTime.Add(spentTimeReportApiModel.SubSpentTime);
                    spentTimeReportApiModel.SubUserStoryStatus = new List<object>();
                    spentTimeReportApiModel.SubStatusColors = new List<object>();
                    spentTimeReportApiModel.SubSpentTime= new List<object>();
                    spentTimeReportApiModel.SubTotalSpentTimeSoFar= new List<object>();
                    spentTimeReportApiModel.SubSummaryValue= new List<object>();
                }
                spentTimeReportApiModel.UserStoryName.Add(spentTimeReportModel.UserStoryName);
                spentTimeReportApiModel.UserStoryId.Add(spentTimeReportModel.UserStoryId);
                spentTimeReportApiModel.DeveloperName.Add(spentTimeReportModel.DeveloperName);
                spentTimeReportApiModel.UniqueName.Add(spentTimeReportModel.UniqueName);
                spentTimeReportApiModel.SubSummaryValue.Add(spentTimeReportModel.SummaryValue);
                spentTimeReportApiModel.SubStatusColors.Add(spentTimeReportModel.StatusColor);
                spentTimeReportApiModel.SubUserStoryStatus.Add(spentTimeReportModel.UserStoryStatus);
                spentTimeReportApiModel.SubSpentTime.Add(spentTimeReportModel.UserStorySpentTime);
                spentTimeReportApiModel.SubTotalSpentTimeSoFar.Add(spentTimeReportModel.TotalSpentTimeSoFar);
                date = spentTimeReportModel.Date;
             }
            spentTimeReportApiModel.StatusColor.Add(spentTimeReportApiModel.SubStatusColors);
            spentTimeReportApiModel.SummaryValue.Add(spentTimeReportApiModel.SubSummaryValue);
            spentTimeReportApiModel.TotalSpentTimeSoFar.Add(spentTimeReportApiModel.SubTotalSpentTimeSoFar);
            spentTimeReportApiModel.UserStoryStatus.Add(spentTimeReportApiModel.SubUserStoryStatus);
            spentTimeReportApiModel.UserStoryStatus.Add(spentTimeReportApiModel.SubSpentTime);

            developerSpentTimeReportOutputModel.StatusColor.Add(spentTimeReportApiModel.StatusColor);
            developerSpentTimeReportOutputModel.UserStoryStatus.Add(spentTimeReportApiModel.UserStoryStatus);
            developerSpentTimeReportOutputModel.SpentTime.Add(spentTimeReportApiModel.SpentTime);
            developerSpentTimeReportOutputModel.DeveloperName.Add(spentTimeReportApiModel.DeveloperName);
            developerSpentTimeReportOutputModel.UniqueName.Add(spentTimeReportApiModel.UniqueName);
            developerSpentTimeReportOutputModel.TotalSpentTimeSoFar.Add(spentTimeReportApiModel.TotalSpentTimeSoFar);
            developerSpentTimeReportOutputModel.UserStoryId.Add(spentTimeReportApiModel.UserStoryId);
            developerSpentTimeReportOutputModel.Date.Add(spentTimeReportApiModel.Date);
            developerSpentTimeReportOutputModel.SummaryValue.Add(spentTimeReportApiModel.SummaryValue);
            developerSpentTimeReportOutputModel.UserStoryName.Add(spentTimeReportApiModel.UserStoryName);
            return developerSpentTimeReportOutputModel;
        }

        private GoalActivityApiReturnOutputModel ConvertToApiModel(GoalActivityOutputModel goalActivityOutputModel)
        {
            GoalActivityApiReturnOutputModel goalActivityApiReturnOutputModel = new GoalActivityApiReturnOutputModel
            {
                Date = goalActivityOutputModel.Date,
                UserName= goalActivityOutputModel.UserName,
                UserProfile = goalActivityOutputModel.UserProfile,
                UserStoryName = goalActivityOutputModel.UserStoryName,
                UserStoryId = goalActivityOutputModel.UserStoryId,
                History = goalActivityOutputModel.History,
                NewValue = goalActivityOutputModel.NewValue,
                OldValue = goalActivityOutputModel.OldValue,
                UserId = goalActivityOutputModel.UserId,
                UserStoryHistoryId = goalActivityOutputModel.UserStoryHistoryId,
                Description = goalActivityOutputModel.Description
            };
            return goalActivityApiReturnOutputModel;
        }
    }
}