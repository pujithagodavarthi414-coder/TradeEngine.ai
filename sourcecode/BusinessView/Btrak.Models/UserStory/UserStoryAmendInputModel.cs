using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class UserStoryAmendInputModel : InputModelBase
    {
        public UserStoryAmendInputModel() : base(InputTypeGuidConstants.UserStoryAmendInputCommandTypeGuid)
        {
        }

        public List<Guid> UserStoryIds { get; set; }
        public string UserStoryIdsXml { get; set; }
        public int? AmendedDaysCount { get; set; }
        public Guid GoalId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryIds = " + UserStoryIds);
            stringBuilder.Append(", UserStoryIdsXml = " + UserStoryIdsXml);
            stringBuilder.Append(", AmendedDaysCount = " + AmendedDaysCount);
            return stringBuilder.ToString();
        }
    }
}
