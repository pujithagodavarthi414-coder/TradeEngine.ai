using System;

namespace Btrak.Models.PayRoll
{
    public class TaxAllowanceSearchOutputModel
    {
        public Guid? TaxAllowanceId { get; set; }
        public string Name { get; set; }
        public Guid? TaxAllowanceTypeId { get; set; }
        public bool IsPercentage { get; set; }
        public decimal? MaxAmount { get; set; }
        public decimal? PercentageValue { get; set; }
        public Guid? ParentId { get; set; }
        public Guid? PayRollComponentId { get; set; }
        public Guid? ComponentId { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public decimal? OnlyEmployeeMaxAmount { get; set; }
        public decimal? MetroMaxPercentage { get; set; }
        public bool LowestAmountOfParentSet { get; set; }
        public string TaxAllowanceTypeName { get; set; }
        public string PayRollComponentName { get; set; }
        public string ComponentName { get; set; }
        public string ParentName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public int? Type { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public string ModifiedMaxAmount { get; set; }
        public string ModifiedOnlyEmployeeMaxAmount { get; set; }
    }
}
