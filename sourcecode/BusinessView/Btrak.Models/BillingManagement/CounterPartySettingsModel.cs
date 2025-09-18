using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class CounterPartySettingsModel
    {
        public Guid? CounterPartySettingsId { get; set; }
        public string Key { get; set; }
        public string Value { get; set; }
        public string SearchText { get; set; }
        public string Description { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsVisible { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CounterPartySettingsId" + CounterPartySettingsId);
            stringBuilder.Append(", Key" + Key);
            stringBuilder.Append(", Value" + Value);
            stringBuilder.Append(", Description" + Description);
            stringBuilder.Append(", IsArchived" + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
