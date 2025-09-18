using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ProfitAndLoss
{
    public class RealisedProfitAndLossOutputModel
    {
        public string Name { get; set; }
        public decimal? SalesInQuantity { get; set; }
        public decimal? SalesInValue { get; set; }
        public decimal? TotalPurchaseFXInUSD { get; set; }
        public decimal? TotalPurchaseFXInINR { get; set; }
        public decimal? DutyQuantityPaid { get; set; }
        public decimal? DutyValueInINR { get; set; }
        public decimal? RefiningCostIncurred { get; set; }
       
    }
    public class UnRealisedProfitAndLossOutputModel
    {
        public string Name { get; set; }
        public decimal? ClosingBalance { get; set; }
        public decimal? MTMValue { get; set; }
        public decimal? PurchaseFXValueInUSD { get; set; }
        public decimal? PurchaseMTMRate { get; set; }
        public decimal? PurchaseValueInINR { get; set; }
        public decimal? QuantityUnpaid { get; set; }
        public decimal? QuantityDutyMTM { get; set; }
        public decimal? QuantityUnPaidValueInINR { get; set; }
        public decimal? RefiningCostPending { get; set; }
    }
}
