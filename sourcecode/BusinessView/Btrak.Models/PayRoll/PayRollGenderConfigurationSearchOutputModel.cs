using System;

namespace Btrak.Models.PayRoll
{
    public class PayRollGenderConfigurationSearchOutputModel
    {
        public Guid? PayRollGenderConfigurationId { get; set; }
        public string PayRollTemplateName { get; set; }
        public string GenderName { get; set; }
        public Guid? PayRollTemplateId { get; set; }
        public Guid? GenderId { get; set; }
        public Guid? CompanyId { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
