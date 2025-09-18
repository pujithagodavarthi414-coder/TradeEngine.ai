using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class CommodityBrokerCostOutputModel
    {
        public string Date { get; set; }
        public double? Commission { get; set; }

    }
    public class BrokerFormOutputModel
    {
        public double? quanityNumber { get; set; }
        public double? priceAmount { get; set; }
        public double? brokerPercentage { get; set; }
        public string commodityName { get; set; }
        public string ContractNumber { get; set; }
        public DateTime? CreateDatetime { get; set; }
        public DateTime _Datetime { get; set; }
        public string month { get; set; }
        public string ContractType { get; set; }
    }
}
