using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class UserStoryTagUpsertInputModel : InputModelBase
    {
        public UserStoryTagUpsertInputModel() : base(InputTypeGuidConstants.UserStoryTagUpsertInputCommandTypeGuid)
        {
        }

        public Guid? UserStoryId { get; set; }
        public string Tags { get; set; }
        public string TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryId = " + UserStoryId);
            stringBuilder.Append(", Tags = " + Tags);
            return stringBuilder.ToString();
        }
    }
}
