using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class GetRunningProjectGoalsOutputModel
    {
        public Guid GoalId { get; set; }
        public string Goal { get; set; }
        public string ProjectName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            stringBuilder.Append("Goal = " + Goal);
            stringBuilder.Append("ProjectName = " + ProjectName);
            return stringBuilder.ToString();
        }
    }
}
