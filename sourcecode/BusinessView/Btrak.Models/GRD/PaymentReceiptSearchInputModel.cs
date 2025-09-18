using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GRD
{
    public class PaymentReceiptSearchInputModel : SearchCriteriaInputModelBase
    {
        public PaymentReceiptSearchInputModel() : base(InputTypeGuidConstants.PaymentReceiptSearchInputModellCommandTypeGuid)
        {
        }
		public Guid? PaymentReceiptId { get; set; }
	}
}
