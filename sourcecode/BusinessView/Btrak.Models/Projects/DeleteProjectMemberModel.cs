using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Projects
{
    public class DeleteProjectMemberModel : InputModelBase
    {
        public DeleteProjectMemberModel() : base(InputTypeGuidConstants.DeleteProjectMember)
        {
        }
        
        public Guid? ProjectId { get; set; }
        public Guid? UserId { get; set; }
        public string TimeZone { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ProjectId = " + ProjectId);
            stringBuilder.Append(" UserId = " + UserId);
            stringBuilder.Append(" TimeZone = " + TimeZone);
            return stringBuilder.ToString();
        }
    }
}
