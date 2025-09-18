using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.AdhocWork
{
    public class AdhocWorkSearchInputModel : SearchCriteriaInputModelBase
    {
        public AdhocWorkSearchInputModel() : base(InputTypeGuidConstants.GetAdhocWork)
        {
        }

        public Guid? TeamMemberId { get; set; }
        public string TeamMembersList { get; set; }
        public Guid? UserStoryId { get; set; }
        public string TeamMembersXml { get; set; }
        public string SearchUserstoryTag { get; set; }
        public bool? IsIncludeCompletedUserStories { get; set; }
        public bool? IsParked { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("TeamMemberId = " + TeamMemberId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId); 
            stringBuilder.Append(", SearchUserstoryTag = " + SearchUserstoryTag); 
            stringBuilder.Append(", IsIncludeCompletedUserStories = " + IsIncludeCompletedUserStories);
            stringBuilder.Append(", IsParked = " + IsParked);
            return stringBuilder.ToString();           
        }
    }
}