using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
    public class KPIReportOutputModel
    {
                public DateTime? From { get; set; }
                public DateTime? To { get; set; }
                public string locationKpi01 { get; set; }
                public double? targetShFs { get; set; }
                public double? numberOfIndependentShFsCertified { get; set; }
    }
}
