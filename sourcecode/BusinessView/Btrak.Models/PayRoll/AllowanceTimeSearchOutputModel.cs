using System;

namespace Btrak.Models.PayRoll
{
    public class AllowanceTimeSearchOutputModel
    {
        public Guid Id { get; set; }
        public Guid AllowanceRateSheetForId { get; set; }
        public string RateSheetForName { get; set; }
        public Guid BranchId { get; set; }
        public string BranchName { get; set; }
        public decimal? MaxTime { get; set; }
        public decimal? MinTime { get; set; }
        public DateTime ActiveFrom { get; set; }
        public DateTime ActiveTo { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
