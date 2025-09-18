using BusinessView.Api.Models;
using BusinessView.Models;
using BusinessView.Services;
using BusinessView.Services.Interfaces;
using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using System.Linq;
using System.Web.Http;

namespace BusinessView.Api.Controllers.Api
{
    public class ProcessDashboardApiController : ApiController
    {
        private readonly IDashboardService _dashboardService;

        public ProcessDashboardApiController()
        {
            _dashboardService = new DashboardService();
        }

        [HttpPost]
        public string SnapshotProcessDashboard()
        {
            var userId = User.Identity.GetUserId<int>();

            var maxDashboardId = _dashboardService.GetMaxDashboardId();

            var results = _dashboardService.ProcessDashboard(null, userId);

            var distinctTeamLead = results.OrderBy(x => x.TeamLead).Select(x => x.TeamLead).Distinct().ToList();

            foreach (var teamLead in distinctTeamLead)
            {
                foreach (var result in results.Where(x => x.TeamLead.ToLower() == teamLead.ToLower()))
                {
                    var goal = new GoalsViewModel()
                    {
                        ProjectId = result.ProjectId,
                        GoalId = result.GoalId,
                        Goal = result.Goal,
                        TeamLeadId = result.TeamLadId,
                        TeamLead = teamLead,
                        OnboardDate = result.OnBoardProcessDate?.ToString("dd-MMM-yyyy"),
                        GoalStatusColor = result.GoalStatusColor,
                        MileStone = result.MileStone?.ToString("dd-MMM-yyyy"),
                        Delay = result.Delay,
                        DelayColor = result.DelayColor,
                        MaxDashboardId = maxDashboardId + 1
                    };

                    _dashboardService.AddOrUpdate(goal);
                }
            }

            var processdashboard = new BusinessViewJsonResult
            {
                Success = true
            };

            return JsonConvert.SerializeObject(processdashboard);
        }
    }
}
