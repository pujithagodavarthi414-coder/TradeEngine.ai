using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrDashboard
{
    public class LogTimeReportSearchInputModel : SearchCriteriaInputModelBase
    {
        public LogTimeReportSearchInputModel() : base(InputTypeGuidConstants.LogTimeReportSearchInputCommandTypeGuid)
        {
        }

        public DateTime? SelectedDate { get; set; }
        public Guid BranchId { get; set; }
        public Guid LineManagerId { get; set; }
        public Guid? EntityId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("SelectedDate = " + SelectedDate);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", LineManagerId = " + LineManagerId);
            return stringBuilder.ToString();
        }
    }
}