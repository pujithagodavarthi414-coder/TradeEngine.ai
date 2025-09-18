using System;

namespace Btrak.Models.PayRoll
{
    public class PayRollTemplateSearchOutputModel
    {
        public Guid? PayRollTemplateId { get; set; }
        public string PayRollName { get; set; }
        public string PayRollShortName { get; set; }
        public bool? IsRepeatInfinitly { get; set; }
        public bool? IslastWorkingDay { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime? InfinitlyRunDate { get; set; }
        public Guid? FrequencyId { get; set; }
        public string PayFrequencyName { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid CurrencyId { get; set; }
        public string CurrencyName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }

    }
}
