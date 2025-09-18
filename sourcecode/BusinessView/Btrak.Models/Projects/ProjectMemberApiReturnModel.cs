using System;
using System.Collections.Generic;
using Btrak.Models.Role;

namespace Btrak.Models.Projects
{
    public class ProjectMemberApiReturnModel
    {
        public Guid? Id { get; set; }

        public Guid? GoalId { get; set; }

        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }

        public UserMiniModel ProjectMember { get; set; }
        public byte[] Timestamp { get; set; }
        public string RoleIds { get; set; }
        public string RoleNames { get; set; }

        public int TotalCount { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public string[] AllRoleIds { get; set; }
        public string[] AllRoleNames { get; set; }
        public List<RoleModelBase> Roles { get; set; }
    }
}
