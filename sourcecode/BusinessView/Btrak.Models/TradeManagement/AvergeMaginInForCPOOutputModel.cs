using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class AvergeMaginInForCPOOutputModel
    {
        public string Date { get; set; }

        public double? FOB { get; set; }

        public double? CFR { get; set; }
    }

    public class AvergeOutputModel
    {
        public string ContrantType { get; set; }
        public DateTime? CreateDatetime { get; set; }
        public DateTime Date { get; set; }
        public string Incoterm { get; set; }
        public double? quanityNumber { get; set; }
        public double? priceAmount { get; set; }
        public string months { get; set; }
    }
}
