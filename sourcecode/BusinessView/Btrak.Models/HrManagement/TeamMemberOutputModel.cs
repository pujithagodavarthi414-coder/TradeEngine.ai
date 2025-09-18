using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
             
    public class TeamMemberOutputModel
    {
        public Guid? TeamMemberId { get; set; }
        public string TeamMemberName { get; set; }
        public string EmailId { get; set; }
        public string ProfileImage { get; set; }
        public Guid? BranchId { get; set; }
        public string RoleIds { get; set; }
        public bool? IsActive { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TeamMemberId = " + TeamMemberId);
            stringBuilder.Append(", TeamMemberName = " + TeamMemberName);
            stringBuilder.Append(", EmailId = " + EmailId);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            return stringBuilder.ToString();
        }
    }
}
