using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.TestRail
{
    public class ReportSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public ReportSearchCriteriaInputModel() : base(InputTypeGuidConstants.ReportSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? ProjectId { get; set; }
        public Guid? MilestoneId { get; set; }
        public Guid? ReportId { get; set; }
        public bool IsForPdf { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("MilestoneId = " + MilestoneId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", ReportId = " + ReportId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", IsForPdf = " + IsForPdf);
            return stringBuilder.ToString();
        }
    }
}
