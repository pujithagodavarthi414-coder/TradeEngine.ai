using System;

namespace Btrak.Models.PayRoll
{
    public class FinancialYearConfigurationsSearchOutputModel
    {
        public Guid? FinancialYearConfigurationsId { get; set; }
        public int? FromMonth { get; set; }
        public int? ToMonth { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; } 
        public int? TotalCount { get; set; }
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public Guid? FinancialYearTypeId { get; set; }
        public string FinancialYearTypeName { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
    }
}
