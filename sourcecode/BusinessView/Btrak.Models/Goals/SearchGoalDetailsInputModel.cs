using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class SearchGoalDetailsInputModel : SearchCriteriaInputModelBase
    {
        public SearchGoalDetailsInputModel() : base(InputTypeGuidConstants.GoalReplanUpsertInputCommandTypeGuid)
        {
        }

        public Guid? GoalId { get; set; }
        public bool IsArchived { get; set; }
        public string GoalUniqueNumber { get; set; }
        public string GoalUniqueName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", GoalUniqueNumber = " + GoalUniqueNumber);
            stringBuilder.Append(", GoalUniqueName = " + GoalUniqueName);
            return stringBuilder.ToString();
        }
    }
}
