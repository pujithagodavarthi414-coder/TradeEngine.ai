using formioModels.ProfitAndLoss;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    [BsonIgnoreExtraElements]
    public class DashboardInputModel
    {
        public string ProductType { get; set; }
        public string CompanyName { get; set; }
        public string ContractUniqueId { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? Todate { get; set; }
        public bool? IsConsolidated { get; set; }
    }
    public class DashboardOutputModel
    {
        public string ProductName { get; set; }
        public decimal? OpeningBalance { get; set; }
        public decimal? Consumption { get; set; }
        public decimal? Production { get; set; }
        public decimal? Sales { get; set; }
        public decimal? ClosingBalance { get; set; }
        public bool IsBold { get; set; }
    }

    public class InstanceLevelDashboardOutputModel
    {
        public string ProductName { get; set; }
        public decimal? OpeningBalance { get; set; }
        public decimal? Consumption { get; set; }
        public decimal? Production { get; set; }
        public decimal? Sales { get; set; }
        public decimal? UnTaggedSales { get; set; }
        public decimal? ClosingBalance { get; set; }
        public bool IsBold { get; set; }
    }
    public class PositionDashboardOutputModel
    {
        public List<DashboardOutputModel> GridData { get; set; }
        public string ProductGroup { get; set; }
        public string UniqueId { get; set; }
        public string SourceCommodity { get; set; }
        public decimal? TotalContractQuantity { get; set; }
        public decimal? UsedContractQuantity { get; set; }
        public decimal? OpeningBalance { get; set; }
        public decimal? Avilablebalance { get; set; }
    }
    public class InstanceLevelPositionDashboardOutputModel
    {
        public List<InstanceLevelDashboardOutputModel> GridData { get; set; }
        public int? TotalImportContracts { get; set; }
        public int? TotalLocalContracts { get; set; }
        public decimal? TotalSourceQuantity { get; set; }
        public decimal? TotalSalesQuantity { get; set; }
    }
    public class FinalOutputModel
    {
        public object MyArray { get; set; }
    }
    public class FinalOutputModel1
    {
        public List<DashboardOutputModel> MyArray { get; set; }
    }
    public class FinalRealisedModel
    {
        public List<RealisedProfitAndLossOutputModel> MyArray { get; set; }
    }
    public class ProductListModel
    {
        public string ProductName { get; set; }
        public string ProductValue { get; set; }
        public bool IsBold { get; set; }
        public bool? IsRegularSales { get; set; }
    }
    public class InstanceLevelDashboardModel
    {
        public string Commodity { get; set; }
        public string SalesType { get; set; }
        public string UniqueId { get; set; }
        public decimal? Quantity { get; set; }
        public decimal? Salesvalue { get; set; }
        public decimal? OpeningBalance { get; set; }
    }
}
