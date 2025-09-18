using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrDashboard
{
    public class HrDashboardSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public HrDashboardSearchCriteriaInputModel() : base(InputTypeGuidConstants.HrDashboardSearchCriteriaInputCommandTypeGuid)
        {
        }

        public string Type { get; set; }
        public DateTime? Date { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool IsMorningLateEmployee { get; set; }
        public bool IsLunchBreakLongTake { get; set; }
        public bool IsMoreSpentTime { get; set; }
        public bool IsMorningAndAfterNoonLate { get; set; }
        public string Order { get; set; }
        public Guid BranchId { get; set; }
        public Guid TeamLeadId { get; set; }
        public Guid? EntityId { get; set; }
        public string WorkingStatus { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Type = " + Type);
            stringBuilder.Append(", IsMorningLateEmployee = " + IsMorningLateEmployee);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", IsLunchBreakLongTake = " + IsLunchBreakLongTake);
            stringBuilder.Append(", IsMoreSpentTime = " + IsMoreSpentTime);
            stringBuilder.Append(", IsMorningAndAfterNoonLate = " + IsMorningAndAfterNoonLate);
            stringBuilder.Append(", Order = " + Order);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", TeamLeadId = " + TeamLeadId);
            stringBuilder.Append(", WorkingStatus = " + WorkingStatus);
            return stringBuilder.ToString();
        }
    }
}
