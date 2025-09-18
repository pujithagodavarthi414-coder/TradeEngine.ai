using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Dashboard
{
    public class VesselDashboardInputModel
    {
        public string ProductType { get; set; }
        public string CompanyName { get; set; }
        public string ContractUniqueId { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? Todate { get; set; }
        public bool? IsConsolidated { get; set; }
    }
    public class PositionsDashboardInputModel
    {
        public DateTime? FromDate { get; set; }
        public DateTime? Todate { get; set; }
    }
}
