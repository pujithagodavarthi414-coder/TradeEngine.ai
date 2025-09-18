using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class UserStoryDetailsSearchInputModel : SearchCriteriaInputModelBase
    {
        public UserStoryDetailsSearchInputModel() : base(InputTypeGuidConstants.UserStoryDetailsSearchInputCommandTypeGuid)
        {
        }

        public Guid? UserStoryId { get; set; }
        public string UserStoryUniqueName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryUniqueName = " + UserStoryUniqueName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
