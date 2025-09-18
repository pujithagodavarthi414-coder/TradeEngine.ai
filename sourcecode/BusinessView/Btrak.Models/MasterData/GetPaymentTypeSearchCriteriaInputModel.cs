using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class GetPaymentTypeSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GetPaymentTypeSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetPaymentTypes)
        {
        }

        public Guid? PaymentTypeId { get; set; }
        public string PaymentTypeName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PaymentTypeId = " + PaymentTypeId);
            stringBuilder.Append(" PaymentTypeName = " + PaymentTypeName);
            stringBuilder.Append(" IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
