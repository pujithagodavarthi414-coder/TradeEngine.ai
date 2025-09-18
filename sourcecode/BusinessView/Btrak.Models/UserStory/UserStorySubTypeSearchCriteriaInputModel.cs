using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class UserStorySubTypeSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public UserStorySubTypeSearchCriteriaInputModel() : base(InputTypeGuidConstants.UserStorySubTypeSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? UserStorySubTypeId { get; set; }
        public string UserStorySubTypeName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStorySubTypeId = " + UserStorySubTypeId);
            stringBuilder.Append(", UserStorySubTypeName = " + UserStorySubTypeName);
            return stringBuilder.ToString();
        }
    }
}

