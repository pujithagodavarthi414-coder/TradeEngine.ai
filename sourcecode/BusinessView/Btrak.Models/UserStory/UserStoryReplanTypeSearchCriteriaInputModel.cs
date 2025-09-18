using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class UserStoryReplanTypeSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public UserStoryReplanTypeSearchCriteriaInputModel() : base(InputTypeGuidConstants.UserStoryReplanTypeSearchCommandTypeGuid)
        {
        }
        public Guid? ReplanTypeId { get; set; }
        public string ReplanTypeName { get; set; }
        public Guid? OperationsPerformedBy { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ReplanTypeName = " + ReplanTypeName);
            stringBuilder.Append(", OperationsPerformedBy = " + OperationsPerformedBy);
            return stringBuilder.ToString();
        }
    }
}
