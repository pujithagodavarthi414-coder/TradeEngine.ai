using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.LeaveManagement
{
    public class LeaveOverViewReportGetInputModel : SearchCriteriaInputModelBase
    {
        public LeaveOverViewReportGetInputModel() : base(InputTypeGuidConstants.LeaveOverViewReportInputCommandTypeGuid)
        {
        }

        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? LeaveApplicationId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", BranchId = " + BranchId);
            return stringBuilder.ToString();
        }
    }
}
