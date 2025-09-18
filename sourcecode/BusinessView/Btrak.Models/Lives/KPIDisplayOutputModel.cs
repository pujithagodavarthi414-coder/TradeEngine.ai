using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Lives
{
    public class KPIDisplayOutputModel : SearchCriteriaInputModelBase
    {
        public KPIDisplayOutputModel() : base(InputTypeGuidConstants.ContractModelInputCommandTypeGuid)
        {
        }
    }

    public class KPIDisplayModel
    {
        public string Heading { get; set; }
        public string Subheading { get; set; }
        public string Location { get; set; }
        public double? TotalSHFPhase1 { get; set; }
        public double? SHFCertified { get; set; }
    }

    public class LivesDashboardAPIInputModel
    {
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string ReportType { get; set; }
    }

    public class TemplateModel
    {
        public string locationKpi01 { get; set; }
        public DateTime? from { get; set; }
        public DateTime? to { get; set; }
        public double? numberOfIndependentShFsCertified { get; set; }
        public double? targetShFs { get; set; }
    }
}