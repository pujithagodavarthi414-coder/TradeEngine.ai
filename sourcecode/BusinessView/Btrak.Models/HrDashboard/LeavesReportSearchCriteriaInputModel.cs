using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrDashboard
{
    public class LeavesReportSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public LeavesReportSearchCriteriaInputModel() : base(InputTypeGuidConstants.LeavesReportSearchCriteriaInputCommandTypeGuid)
        {
        }

        public int? Year { get; set; }
        public Guid BranchId { get; set; }
        public Guid? EntityId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Year = " + Year);
            stringBuilder.Append(", BranchId = " + BranchId);
            return stringBuilder.ToString();
        }
    }
}
