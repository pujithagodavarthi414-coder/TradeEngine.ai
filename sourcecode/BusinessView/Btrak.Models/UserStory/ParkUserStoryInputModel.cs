using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class ParkUserStoryInputModel : InputModelBase
    {
        public ParkUserStoryInputModel() : base(InputTypeGuidConstants.ArchieveUserStoryInputCommandTypeGuid)
        {
        }

        public Guid? UserStoryId { get; set; }
        public bool IsParked { get; set; }
        public bool? IsFromSprint { get; set; }
        public string TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryId = " + UserStoryId);
            stringBuilder.Append(", IsParked = " + IsParked);
            stringBuilder.Append(", TimeZone = " + TimeZone);
            return stringBuilder.ToString();
        }
    }
}
