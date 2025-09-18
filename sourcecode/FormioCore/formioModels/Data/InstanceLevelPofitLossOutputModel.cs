using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    [BsonIgnoreExtraElements]
    public class InstanceLevelPofitLossOutputModel
    {
        public string VesselName { get; set; }
        public decimal? RealisedTotal { get; set; }
        public decimal? UnRealisedTotal { get; set; }
    }
    [BsonIgnoreExtraElements]
    public class InstanceLevelPAndLDashboardModel
    {
        public string UniqueId { get; set; }
        public decimal? SalesInQuantity { get; set; }
        public decimal? SalesInValue { get; set; }
        public decimal? TotalPurchaseFXInUSD { get; set; }
        public decimal? TotalPurchaseFXInINR { get; set; }
        public decimal? DutyQuantityPaid { get; set; }
        public decimal? DutyValueInINR { get; set; }
        public decimal? RefiningCostIncurred { get; set; }
    }

    [BsonIgnoreExtraElements]
    public class closingBalanceModel
    {
        public string UniqueId { get; set; }
        public string Commodity { get; set; }
        public decimal? Sales { get; set; }
        public decimal? OpeningBalance { get; set; }
        public decimal? ClosingBalance { get; set; }
        public bool IsSourceCommodity { get; set; }
    }

    [BsonIgnoreExtraElements]
    public class UnrealisedDataModel
    {
        public string UniqueId { get; set; }
        public string Commodity { get; set; }
        public string Location { get; set; }
        public decimal? RateInr { get; set; }
        public decimal? FxVaue { get; set; }
        public decimal? USDToINR { get; set; }
        public decimal? QuantityMTM { get; set; }
        public decimal? CustomsDutyInr { get; set; }
    }
}
