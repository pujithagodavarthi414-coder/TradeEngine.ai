using BTrak.Common;
using System;

namespace Btrak.Models.Projects
{
    public class ResourceUsageReportSearchInputModel : SearchCriteriaInputModelBase
    {
        public ResourceUsageReportSearchInputModel() : base(InputTypeGuidConstants.ResourceUsageReportSearchInputCommandTypeGuid)
        {
        }

        public string UserIds { get; set; }
        public string ProjectIds { get; set; }
        public string GoalIds { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool? isChartData { get; set; }
    }
}
