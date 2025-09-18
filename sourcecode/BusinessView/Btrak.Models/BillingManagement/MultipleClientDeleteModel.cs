using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class MultipleClientDeleteModel : InputModelBase
    {
        public MultipleClientDeleteModel() : base(InputTypeGuidConstants.MultipleClientDeleteCommandTypeGuid)
        {
        }

        public List<Guid> ClientId { get; set; }
        public string ClientIdXml { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ClientIdXml" + ClientIdXml);
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("IsArchived" + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
