using System;

namespace Btrak.Models.PayRoll
{
    public class RateTagAllowanceTimeSearchOutputModel
    {
        public Guid Id { get; set; }
        public Guid AllowanceRateTagForId { get; set; }
        public string RateTagForId { get; set; }
        public string RateTagForName { get; set; }
        public Guid BranchId { get; set; }
        public string BranchName { get; set; }
        public decimal? MaxTime { get; set; }
        public decimal? MinTime { get; set; }
        public DateTime ActiveFrom { get; set; }
        public DateTime ActiveTo { get; set; }
        public bool IsBankHoliday { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
