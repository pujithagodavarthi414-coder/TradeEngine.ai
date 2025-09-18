using System;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class UserStoryTagApiReturnModel
    {
        public Guid? UserStoryId { get; set; }
        public string Tag { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryId = " + UserStoryId);
            stringBuilder.Append(", Tag = " + Tag);
            return stringBuilder.ToString();
        }
    }
}