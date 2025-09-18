using BTrak.Common;
using System;

namespace Btrak.Models.Projects
{
    public class CumulativeWorkReportSearchInputModel : SearchCriteriaInputModelBase
    {
        public CumulativeWorkReportSearchInputModel() : base(InputTypeGuidConstants.CumulativeWorkReportSearchInputCommandTypeGuid)
        {
        }

        public string UserId { get; set; }
        public string ProjectId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public DateTime? Date { get; set; }
    }
}
