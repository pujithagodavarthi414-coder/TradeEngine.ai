using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class PaymentTermSearchInputModel : SearchCriteriaInputModelBase
    {
        public PaymentTermSearchInputModel() : base(InputTypeGuidConstants.SearchPaymentMethod)
        {
        }
        public Guid? Id { get; set; }
        public Guid? UserId { get; set; }
        public Guid? PortCategoryId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" Id = " + Id);
            return stringBuilder.ToString();
        }
    }
}
