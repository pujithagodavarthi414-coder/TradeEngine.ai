using System;

namespace Btrak.Models.PayRoll
{
    public class HourlyTdsConfigurationSearchOutputModel
    {
        public Guid Id { get; set; }
        public Guid BranchId { get; set; }
        public string BranchName { get; set; }
        public decimal MaxLimit { get; set; }
        public decimal TaxPercentage { get; set; }
        public DateTime ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
    }
}
