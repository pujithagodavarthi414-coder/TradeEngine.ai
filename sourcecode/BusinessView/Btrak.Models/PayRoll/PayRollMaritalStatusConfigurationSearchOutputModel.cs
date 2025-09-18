using System;

namespace Btrak.Models.PayRoll
{
    public class PayRollMaritalStatusConfigurationSearchOutputModel
    {
        public Guid? PayRollMaritalStatusConfigurationId { get; set; }
        public string PayRollTemplateName { get; set; }
        public string MaritalStatusName { get; set; }
        public Guid? PayRollTemplateId { get; set; }
        public Guid? MaritalStatusId { get; set; }
        public Guid? CompanyId { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
