using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class ClientKycConfigurationOutputModel
    {
        public Guid? ClientKycId { get; set; }
        public string ClientKycName { get; set; }
        public string ClientTypeName { get; set; }
        public string LegalEntityName { get; set; }
        public Guid? ClientTypeId { get; set; }
        public Guid? LegalEntityTypeId { get; set; }
        public string SelectedRoles { get; set; }
        public string SelectedLegalEntities { get; set; }
        public List<Guid> SelectedRoleIds { get; set; }
        public List<Guid> SelectedLegalEntityIds { get; set; }
        public string RoleNames { get; set; }
        public string LegalEntityNames { get; set; }
        public string FormJson { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool IsArchived { get; set; }
        public bool IsDraft { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedByImage { get; set; }
        public string FormBgColor { get; set; }
        public DateTime CreatedDatetime { get; set; }
        public int TotalCount { get; set; }
    }
}
