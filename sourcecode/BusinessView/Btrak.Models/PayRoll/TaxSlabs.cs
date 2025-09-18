using System;
using System.Collections.Generic;

namespace Btrak.Models.PayRoll
{
   public class TaxSlabs
    {
        public Guid? TaxSlabId { get; set; }
        public string Name { get; set; }
        public decimal? FromRange { get; set; }
        public decimal? ToRange { get; set; }
        public decimal? TaxPercentage { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public int? MinAge { get; set; }
        public int? MaxAge { get; set; }
        public bool? ForMale { get; set; }
        public bool? ForFemale { get; set; }
        public bool? Handicapped { get; set; }
        public Guid? PayrollTemplateId { get; set; }
        public int? Order { get; set; }
        public bool IsArchived { get; set; }
        public Guid? ParentId { get; set; }
        public string ParentName { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public List<Guid> PayRollTemplateIds { get; set; }
        public string PayRollTempalteXml { get; set; }
        public string TemplateNames { get; set; }
        public string TemplateIds { get; set; }
        public bool IsFlatRate { get; set; }
        public string ModifiedFromRange { get; set; }
        public string ModifiedToRange { get; set; }
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public byte[] TimeStamp { get; set; }
        public string TaxCalculationTypeName { get; set; }
        public Guid? TaxCalculationTypeId { get; set; }
    }
}
