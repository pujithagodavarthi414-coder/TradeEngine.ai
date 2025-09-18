using System;

namespace Btrak.Models.Projects
{
    public class ProjectMemberSpReturnModel
    {
        public Guid? GoalId { get; set; }

        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }

        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string ProfileImage { get; set; }

        public string RoleIds { get; set; }
        public string RoleNames { get; set; }
        public byte[] Timestamp { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public int TotalCount { get; set; }
    }
}
