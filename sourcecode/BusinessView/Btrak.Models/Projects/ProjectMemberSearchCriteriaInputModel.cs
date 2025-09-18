using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Projects
{
    public class ProjectMemberSearchCriteriaInputModel: SearchCriteriaInputModelBase
    {
        public ProjectMemberSearchCriteriaInputModel() : base(InputTypeGuidConstants.ProjectMemberSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? ProjectMemberId { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? RoleId { get; set; }
        public List<Guid> ProjectMemberIds { get; set; }
        public string ProjectMemberIdsXML { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("RoleId = " + RoleId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            return stringBuilder.ToString();
        }
    }
}
