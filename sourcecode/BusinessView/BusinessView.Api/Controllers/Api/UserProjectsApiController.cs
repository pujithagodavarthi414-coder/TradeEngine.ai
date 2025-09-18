
using BusinessView.DAL;
using BusinessView.Models;
using System.Web.Http;

namespace BusinessView.Api.Controllers.Api
{
    public class UserProjectsApiController : ApiController
    {
        [HttpPost]
        public void DeleteGoalAccess(GoalMembersModel model)
        {
            using (var entities = new BViewEntities())
            {
                entities.USP_RemoveGoalAccess(model.UserId, model.ProjectId, model.GoalId);
            }
        }

        [HttpPost]
        public void UpdateGoalAccess(GoalMembersModel model)
        {
            using (var entities = new BViewEntities())
            {
                entities.USP_UpdateGoalMembers(model.ProjectId, model.GoalId, model.UserId,model.UpdatedUserId);
            }
        }
    }
}
