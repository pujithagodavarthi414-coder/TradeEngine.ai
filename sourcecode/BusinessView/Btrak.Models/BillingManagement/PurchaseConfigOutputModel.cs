using System;
using System.Collections.Generic;

namespace Btrak.Models.BillingManagement
{
    public class PurchaseConfigOutputModel
    {
        public Guid? PurchaseId { get; set; }
        public Guid? TemplateId { get; set; }
        public string PurchaseName { get; set; }
        public Guid? FormId { get; set; }
        public string FormName { get; set; }
        public Guid? ClientTypeId { get; set; }
        public string SelectedRoles { get; set; }
        public List<Guid> SelectedRoleIds { get; set; }
        public string RoleNames { get; set; }
        public string FormJson { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool IsArchived { get; set; }
        public bool IsDraft { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedByImage { get; set; }
        public DateTime CreatedDatetime { get; set; }
        public int TotalCount { get; set; }
    }
}
