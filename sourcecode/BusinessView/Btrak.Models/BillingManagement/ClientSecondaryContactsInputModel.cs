using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class ClientSecondaryContactsInputModel : InputModelBase
    {
        public ClientSecondaryContactsInputModel() : base(InputTypeGuidConstants.ClientSecondaryContactsInputCommandTypeGuid)
        {
        }

        public Guid? ClientSecondaryContactId { get; set; }
        public Guid? ClientId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ClientSecondaryContactId" + ClientSecondaryContactId);
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("IsArchived" + IsArchived);
            return base.ToString();
        }
    }
}
