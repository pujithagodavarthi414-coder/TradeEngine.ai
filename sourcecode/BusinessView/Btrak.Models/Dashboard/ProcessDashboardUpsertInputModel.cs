using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Dashboard
{
    public class ProcessDashboardUpsertInputModel : InputModelBase
    {
        public ProcessDashboardUpsertInputModel() : base(InputTypeGuidConstants.ProcessDashboardUpsertInputCommandTypeGuid)
        {
        }

        public Guid? ProcessDashboardId { get; set; }
        public Guid? GoalId { get; set; }
        public DateTime? MileStone { get; set; }
        public int? Delay { get; set; }
        public string GoalStatusColor { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProcessDashboardId = " + ProcessDashboardId);
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", MileStone = " + MileStone);
            stringBuilder.Append(", Delay = " + Delay);
            stringBuilder.Append(", GoalStatusColor = " + GoalStatusColor);
            return stringBuilder.ToString();
        }
    }
}
