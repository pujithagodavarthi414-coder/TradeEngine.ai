using System;

namespace Btrak.Models.PayRoll
{
    public class PayRollComponentSearchOutputModel
    {

        public Guid? PayRollComponentId { get; set; }
        public string ComponentName { get; set; }
        public bool? IsDeduction { get; set; }
        public Guid? CompanyId { get; set; }
        public bool? IsVariablePay { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public decimal? EmployeeContributionPercentage { get; set; }
        public decimal? EmployerContributionPercentage { get; set; }
        public bool? RelatedToContributionPercentage { get; set; }
        public bool? IsVisible { get; set; }
        public bool? IsBands { get; set; }
    }
}
