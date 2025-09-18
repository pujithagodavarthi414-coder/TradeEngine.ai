using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class GetRunningTeamLeadGoalsOutputModel
    {
        public Guid GoalId { get; set; }
        public string Goal { get; set; }
        public string TeamLead { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            stringBuilder.Append("Goal = " + Goal);
            stringBuilder.Append("TeamLead = " + TeamLead);
            return stringBuilder.ToString();
        }
    }
}