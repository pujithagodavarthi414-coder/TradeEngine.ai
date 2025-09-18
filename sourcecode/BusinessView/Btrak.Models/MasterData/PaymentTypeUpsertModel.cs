using BTrak.Common;
using System;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class PaymentTypeUpsertModel: InputModelBase
    { 
        public PaymentTypeUpsertModel(): base(InputTypeGuidConstants.PaymentUpsertInputCommandTypeGuid)
        {
        }

        public Guid? PaymentTypeId { get; set; }
        [StringLength(50)]
        public string PaymentTypeName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PaymentTypeId= " + PaymentTypeId);
            stringBuilder.Append(", PaymentTypeName= " + PaymentTypeName);
            stringBuilder.Append(", IsArchived= " + IsArchived);
            stringBuilder.Append(", TimeStamp= " + TimeStamp);
            return stringBuilder.ToString();
        }

    }
}