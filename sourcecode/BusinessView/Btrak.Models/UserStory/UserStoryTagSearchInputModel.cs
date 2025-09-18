using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class UserStoryTagSearchInputModel : InputModelBase
    {
        public UserStoryTagSearchInputModel() : base(InputTypeGuidConstants.UserStoryTagSearchInputCommandTypeGuid)
        {
        }

        public Guid? UserStoryId { get; set; }
        public string Tag { get; set; }
        public string SearchText { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryId = " + UserStoryId);
            stringBuilder.Append(", Tag = " + Tag);
            stringBuilder.Append(", SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}