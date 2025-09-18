using System;
using MongoDB.Bson.Serialization.Attributes;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.ProfitAndLoss
{
    [BsonIgnoreExtraElements]
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

    public class FinalReliasedOutputModel
    {
        public List<RealisedProfitAndLossOutputModel> GridData { get; set; }
        public List<Options> Headers { get; set; }
    }
    public class FinalUnReliasedOutputModel
    {
        public List<UnRealisedProfitAndLossOutputModel> GridData { get; set; }
        public List<Options> Headers { get; set; }
    }
    public class Options
    {
        public string label { get; set; }
        public string value { get; set; }
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
    public class MTMModel
    {
        public string Id { get; set; }
        public string Commodity { get; set; }
        public decimal? RateInr { get; set; }
        public decimal? USDToINR { get; set; }
        public decimal? QuantityMTM { get; set; }
        public decimal? QuantityUSDToINR { get; set; }
    }
}
