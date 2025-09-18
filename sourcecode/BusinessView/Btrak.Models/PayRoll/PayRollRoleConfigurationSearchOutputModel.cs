using System;

namespace Btrak.Models.PayRoll
{
    public class PayRollRoleConfigurationSearchOutputModel
    {
        public Guid? PayRollRoleConfigurationId { get; set; }
        public string PayRollTemplateName { get; set; }
        public string RoleName { get; set; }
        public Guid? PayRollTemplateId { get; set; }
        public Guid? RoleId { get; set; }
        public Guid? CompanyId { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
