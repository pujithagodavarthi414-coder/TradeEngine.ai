using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class GoalTagSearchInputModel : InputModelBase
    {
        public GoalTagSearchInputModel() : base(InputTypeGuidConstants.GoalTagSearchInputCommandTypeGuid)
        {
        }

        public Guid? GoalId { get; set; }
        public string Tag { get; set; }
        public string SearchText { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            stringBuilder.Append(", Tag = " + Tag);
            stringBuilder.Append(", SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}