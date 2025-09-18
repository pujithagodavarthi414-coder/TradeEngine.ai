using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class CommissionandCostOutputModel
    {
        public string Date { get; set; }
        public double? Commission { get; set; }
        public double? Demurrage { get; set; }
        public double? LegalFees { get; set; }
        public double? SurveyorFees { get; set; }
        public double? QualityRelatedCharges { get; set; }
    }
}
