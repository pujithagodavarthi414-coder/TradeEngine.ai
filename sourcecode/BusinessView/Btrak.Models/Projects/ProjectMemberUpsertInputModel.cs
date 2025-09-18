using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Projects
{
    public class ProjectMemberUpsertInputModel : SearchCriteriaInputModelBase
    {
        public ProjectMemberUpsertInputModel() : base(InputTypeGuidConstants.ProjectMemberUpsertInputCommandTypeGuid)
        {
        }

        public List<Guid> RoleIds { get; set; }
        public string RoleXml { get; set; }

        public List<Guid> UserIds { get; set; }
        public string UserXml { get; set; }
        public string TimeZone { get; set; }

        public Guid? ProjectId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? ProjectMemberId { get; set; }
        public Guid? RoleId { get; set; }
        public List<Guid> ProjectMemberIds { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("RoleIds = " + RoleIds);
            stringBuilder.Append(", RoleXml = " + RoleXml);
            stringBuilder.Append(", UserIds = " + UserIds);
            stringBuilder.Append(", UserXml = " + UserXml);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", GoalId = " + GoalId);
            return stringBuilder.ToString();
        }
    }
}
