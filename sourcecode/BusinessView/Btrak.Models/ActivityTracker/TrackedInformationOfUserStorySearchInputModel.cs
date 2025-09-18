using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.ActivityTracker
{
    public class TrackedInformationOfUserStorySearchInputModel : SearchCriteriaInputModelBase
    {
        public TrackedInformationOfUserStorySearchInputModel() : base(InputTypeGuidConstants.TrackedInformationOfUserStorySearchInputCommandTypeGuid)
        {

        }

        public Guid UserId { get; set; }
        public DateTime DateFrom { get; set; }
        public DateTime DateTo { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId" + UserId);
            stringBuilder.Append(",DateFrom" + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            return stringBuilder.ToString();
        }
    }
}
