using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class GoalTagApiReturnModel
    {
        public Guid? GoalId { get; set; }
        public string Tag { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            stringBuilder.Append(", Tag = " + Tag);
            return stringBuilder.ToString();
        }
    }
}
