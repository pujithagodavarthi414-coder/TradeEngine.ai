using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class GetSalesOutputModel
    {
        public string Date { get; set; }
        public DateTime? OrderDate { get; set; }
        public string Broker_Sale { get; set; }
        public string Direct_Sale { get; set; }
    }
}
