using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class ProjectMemberSpEntity
    {
        public Guid Id { get; set; }

        public Guid? UserId { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string UserName { get; set; }

        public string RoleIds { get; set; }
        public string RoleNames { get; set; }
        
        public string ProfileImage { get; set; }
    }
}
