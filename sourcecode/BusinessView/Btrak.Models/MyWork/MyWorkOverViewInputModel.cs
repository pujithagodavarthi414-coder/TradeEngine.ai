using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MyWork
{
    public class MyWorkOverViewInputModel : SearchCriteriaInputModelBase
    {
        public MyWorkOverViewInputModel() : base(InputTypeGuidConstants.GetMyWorkOverViewDetails)
        {
        }
        public string TeamMemberId { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public string TeamMembersXml { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" TeamMemberId = " + TeamMemberId);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            return stringBuilder.ToString();
        }

    }
}