using Btrak.Models.ProfitAndLoss;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PositionTable
{
    public class SalesDashboardInputModel
    {
        public string ProductGroup { get; set; }
        public string ProductType { get; set; }
        public string ContractUniqueId { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime Todate { get; set; }
    }
    public class SalesDashboardOutputModel
    {
        public string ProductName { get; set; }
        public decimal OpeningBalance { get; set; }
        public decimal Consumption { get; set; }
        public decimal Production { get; set; }
        public decimal Sales { get; set; }
        public decimal ClosingBalance { get; set; }
        public bool IsBold { get; set; }
    }

    public class InstanceLevelSalesDashboardOutputModel
    {
        public string ProductName { get; set; }
        public string ProductValue { get; set; }
        public decimal? OpeningBalance { get; set; }
        public decimal? Consumption { get; set; }
        public decimal? Production { get; set; }
        public decimal? Sales { get; set; }
        public decimal? ClosingBalance { get; set; }
        public decimal? UnTaggedSales { get; set; }
        public bool IsBold { get; set; }
    }

    public class InstanceLevelPositionDashboardOutputModel
    {
        public List<InstanceLevelSalesDashboardOutputModel> GridData { get; set; }
        public int? TotalImportContracts { get; set; }
        public int? TotalLocalContracts { get; set; }
        public decimal? TotalSourceQuantity { get; set; }
        public decimal? TotalSalesQuantity { get; set; }
    }

    public class PositionDashboardOutputModel
    {
        public List<SalesDashboardOutputModel> GridData { get; set; }
        public string ProductGroup { get; set; }
        public string UniqueId { get; set; }
        public string SourceCommodity { get; set; }
        public decimal? TotalContractQuantity { get; set; }
        public decimal? UsedContractQuantity { get; set; }
        public decimal? OpeningBalance { get; set; }
        public decimal? Avilablebalance { get; set; }
    }
    public class FinalReliasedOutputModel
    {
        public List<RealisedProfitAndLossOutputModel> GridData { get; set; }
        public List<Options> Headers { get; set; }
    }

    public class FinalInstanceLevelProfitLossModel
    {
        public Guid? CompanyId { get; set; }
        public string VesselName { get; set; }
        public decimal? RealisedTotal { get; set; }
        public decimal? UnRealisedTotal { get; set; }
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
     public class QuantityInputModel
    {
        public string UniqueId { get; set; }
        public decimal ContractQuantity { get; set; }
    }

}
