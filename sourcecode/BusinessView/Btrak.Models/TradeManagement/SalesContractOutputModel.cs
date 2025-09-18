using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
     public class SalesContractOutputModel
    {
        public int SI { get; set; }
        public string BuyerName { get; set; }
        public string ContractID { get; set; }
        public string Incoterm { get; set; }
        public string Commodity { get; set; }
        public string PricePerTon { get; set; }
        public string Quantity { get; set; }
        public string Value { get; set; }
        public string Contracting { get; set; }
        public string VesselLinking { get; set; }
        public string SurveyorReporting { get; set; }
        public string LCPayment { get; set; }
        public string BLShared { get; set; }
    }
}
