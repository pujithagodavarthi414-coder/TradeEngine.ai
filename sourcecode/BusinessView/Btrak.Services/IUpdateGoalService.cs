using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Btrak.Models;
using Btrak.Models.Goals;
using BTrak.Common;

namespace Btrak.Services
{
    public interface IUpdateGoalService
    {
        GoalUpdateReturnModel UpdateGoalStatuses(Guid? goalId, Guid loggedInUserId);
        void UpdateAllGoalStatusColor();
        Task PullData(string sqlquery, string fileName, string textShown, string webHook);
        Task PullDataToWebHook(string sqlquery, string fileName, string textShown, string webHook, LoggedInContext loggedInContext);
        Task PostProcessDashboardToSlack(LoggedInContext loggedInContext, string webhookUrl);
        Task PostProcessDashboardToWebHook(LoggedInContext loggedInContext, string webhookUrl);
        string ConvertDataTableToProcessDashboard(LoggedInContext loggedInContext);
        string ConvertDataTableToHtml(DataTable dt);
        Task ConvertHtmlToImageAndPushMessageToSlack(string htmlInput, string fileName, string imageText, string wehookUrl);
        Task ConvertHtmlToImageAndPushMessageToWebHook(string htmlInput, string fileName, string imageText, string wehookUrl, LoggedInContext loggedInContext);
        Task ConvertHtmlToImageAndPushMessageToBtrakChat(string htmlInput, string fileName, string imageText, string pubnubChannel,Guid? channelId, LoggedInContext loggedInContext);
        Task PostLeastPerformingGoalBurndown(LoggedInContext loggedInContext, string webhookUrl);
        Task PostLeastPerformingGoalBurndownToWebHook(LoggedInContext loggedInContext, string webhookUrl);
        Task PostBurndown(string webhookUrl, int yMax, string sqlQuery);
        Task PostBurndownToWebHook(LoggedInContext loggedInContext, string webhookUrl, int yMax, string sqlQuery);
        List<string> GetGoalBurnDownChart(Guid? goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<string> GetDeveloperBurnDownChartInGoal(Guid? goalId,Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void ProduceData(string sqlquery);
        HeatMapOutputModel GetGoalHeatMap(Guid? goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        HeatMapOutputModel GetDeveloperHeatMap(Guid? goalId, Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GoalActivityApiReturnOutputModel> GetGoalAcitivity(Guid? goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        DeveloperSpentTimeReportOutputModel GetDeveloperSpentTimeReport(Guid? goalId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}