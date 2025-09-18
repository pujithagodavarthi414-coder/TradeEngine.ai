using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class FormDataOutputModel
    {
        public DateTime Date { get; set; }
        //public DateTime CreatedDateTime { get; set; }
        public object incoterms1 { get; set; }
        public double? quanityNumber { get; set; }
        public double? priceAmount { get; set; }
    }

    public class FormCostsBrokerageModel
    {
        public DateTime? Date { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public double? quanityNumber { get; set; }
        public double? priceAmount { get; set; }
        public Guid? brokerId { get; set; }
        public string MonthYear { get; set; }
        public string ContractType { get; set; }
    }
}
