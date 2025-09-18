using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class CostsotherthanCommodityBrokerageOutputModel
    {
        public string Date { get; set; }
        public double Demurrage { get; set; }
        public double LegalFees { get; set; }
        public double SurveyorFees { get; set; }
        public double QualityRelatedCharges { get; set; }
    }
}
