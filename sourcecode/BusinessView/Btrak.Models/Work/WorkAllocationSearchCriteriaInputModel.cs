using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Work
{
    public class WorkAllocationSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public WorkAllocationSearchCriteriaInputModel() : base(InputTypeGuidConstants.WorkAllocationSearchCriteriaInputCommandTypeGuid)
        {
        }

        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? TeamLeadId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? EntityId { get; set; }
        public bool IsReportingOnly { get; set; }
        public bool IsAll { get; set; }
        public bool IsMyself { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TeamLeadId = " + TeamLeadId);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
