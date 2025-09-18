using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.BillingManagement
{
   public class PurchaseConfigInputModel
    {
        public Guid? PurchaseId { get; set; }
        public string PurchaseName { get; set; }
        public string FormJson { get; set; }
        public string FormData { get; set; }
        public string SelectedRoles { get; set; }
        public Guid? OfUserId { get; set; }
        public List<Guid> SelectedRoleIds { get; set; }
        public bool IsDraft { get; set; }
        public bool ConsiderRole { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ConfigurationId = " + PurchaseId);
            stringBuilder.Append(", Name = " + PurchaseName);
            stringBuilder.Append(", SelectedRoles = " + SelectedRoles);
            stringBuilder.Append(", FormJson = " + FormJson);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
