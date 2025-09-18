using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Goals
{
    public class ActivelyRunningTeamLeadOutputModel
    {
       
        public List<object> GoalIds { get; set; }
        public List<object> Goals { get; set; }
        public object TeamLead { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalIds);
            stringBuilder.Append("Goal = " + Goals);
            stringBuilder.Append("ProjectName = " + TeamLead);
            return stringBuilder.ToString();
        }
    }
}