using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class ClientKycConfiguration : InputModelBase
    {
        public ClientKycConfiguration() : base(InputTypeGuidConstants.UpsertClientKcyInputCommandTypeGuid)
        {
        }
        public Guid? ClientKycId { get; set; }
        public Guid? ClientTypeId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? LegalEntityTypeId { get; set; }
        public string ClientKycName { get; set; }
        public string FormJson { get; set; }
        public string FormData { get; set; }
        public string SelectedRoles { get; set; }
        public string SelectedLegalEntites { get; set; }
        public Guid? OfUserId { get; set; }
        public Guid? RoleId { get; set; }
        public List<Guid> selectedLegalEntityIds { get; set; }
        public List<Guid> SelectedRoleIds { get; set; }
        public bool IsDraft { get; set; }
        public bool ConsiderRole { get; set; }
        public bool IsArchived { get; set; }
        public bool IsSubmitted { get; set; }
        public bool IsFromApp { get; set; }
        public string FormBgColor { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ConfigurationId = " + ClientKycId);
            stringBuilder.Append(", Name = " + ClientKycName);
            stringBuilder.Append(", SelectedRoles = " + SelectedRoles);
            stringBuilder.Append(", FormJson = " + FormJson);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
