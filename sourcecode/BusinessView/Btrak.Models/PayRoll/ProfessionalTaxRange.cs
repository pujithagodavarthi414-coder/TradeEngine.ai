using System;

namespace Btrak.Models.PayRoll
{
    public class ProfessionalTaxRange
    {
        public Guid? Id { get; set; }
        public decimal? FromRange { get; set; }
        public decimal? ToRange { get; set; }
        public decimal? TaxAmount { get; set; }
        public bool IsArchived { get; set; }
        public string BranchName { get; set; }
        public Guid? BranchId { get; set; }
        public string ModifiedFromRange { get; set; }
        public string ModifiedToRange { get; set; }
        public string ModifiedTaxAmount { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
    }
}
