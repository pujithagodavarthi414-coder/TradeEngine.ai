using System.Collections.Generic;
using System.Text;
using System;

namespace Btrak.Models.Goals
{
    public class UserStoryStatusReportSearchOutputModel
    {
        public List<object> UserStoryId { get; set; }
        public List<object> UserStoryStatus { get; set; }
        public List<object> UserStoryName { get; set; }
        public List<object> UserStoryUniqueName { get; set; }
        public List<object> Date { get; set; }
        public List<object> SubSummaryValues { get; set; }
        public List<List<object>> SummaryValue { get; set; }
        public Guid? WorkFlowId { get; set; }
        public List<WorkFlowStatusModel> WorkFlowModels { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", UserStoryUniqueName = " + UserStoryUniqueName);
            stringBuilder.Append(", Dates = " + Date);
            stringBuilder.Append(", SummaryValue = " + SummaryValue);
            return stringBuilder.ToString();
        }
    }

    public class WorkFlowStatusModel
    {
        public int? value { get; set; }
        public string color { get; set; }
        public string label { get; set; }
    }
}