using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class PaymentTermInputModel : InputModelBase
    {
        public PaymentTermInputModel() : base(InputTypeGuidConstants.PaymentMethodInputCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public string Name { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? PortCategoryId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" Id = " + Id);
            stringBuilder.Append(", Name = " + Name);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
