using BTrak.Common;
using System;

namespace Btrak.Models.Goals
{
    public class GoalCommnetsSearchInputModel :SearchCriteriaInputModelBase
    {
        public GoalCommnetsSearchInputModel() : base(InputTypeGuidConstants.GetGoalCommentsInputCommandTypeGuid)
        {
        }

        public Guid? GoalId { get; set; }
        public Guid? GoalCommentId { get; set; }
    }
}
