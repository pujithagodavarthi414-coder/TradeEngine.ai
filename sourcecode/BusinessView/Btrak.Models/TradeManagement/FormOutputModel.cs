using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class FormOutputModel
    {
        public double? quanityNumber { get; set; }
        public double? priceAmount { get; set; }
        public double? quantity { get; set; }
        public double? total { get; set; }
        public double? brokerPercentage { get; set; }
        public string commodityName { get; set; }
        public string quantityMeasurementUnit { get; set; }
        public string ContractNumber { get; set; }
        public object incoterms1 { get; set; }
        public Guid? priceCurrency { get; set; }
        


    }
}
