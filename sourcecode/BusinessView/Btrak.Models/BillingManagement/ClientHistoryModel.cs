using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class ClientHistoryModel : InputModelBase
    {

        public ClientHistoryModel() : base(InputTypeGuidConstants.ClientHistoryCommandTypeGuid)
        {
        }

        public Guid? ClientHistoryId { get; set; }
        public Guid? ClientId { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string FieldName { get; set; }
        public string Description { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ClientHistoryId" + ClientHistoryId);
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("OldValue" + OldValue);
            stringBuilder.Append("NewValue" + NewValue);
            stringBuilder.Append("FieldName" + FieldName);
            stringBuilder.Append("Description" + Description);
            stringBuilder.Append("CreatedByUserId" + CreatedByUserId);
            stringBuilder.Append("CreatedDateTime" + CreatedDateTime);
            return base.ToString();
        }

    }
}