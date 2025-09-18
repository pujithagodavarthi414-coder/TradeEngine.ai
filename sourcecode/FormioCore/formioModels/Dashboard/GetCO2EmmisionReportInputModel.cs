using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Dashboard
{
    public class GetCO2EmmisionReportInputModel
    {
        public DateTime? FromDate { get; set; }
        public DateTime? Todate { get; set; }
    }
    public class GetCO2EmmisionReportOutputModel
    {
        public string Source { get; set; }
        public decimal TotalCO2Emission { get; set; }
    }
}
