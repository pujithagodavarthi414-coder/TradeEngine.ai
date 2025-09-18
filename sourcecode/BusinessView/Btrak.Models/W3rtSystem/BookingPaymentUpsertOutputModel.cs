using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.W3rtSystem
{
    public class BookingPaymentUpsertOutputModel
    {
        public Guid? BookingId { get; set; }
        public Guid? BookingPaymentId { get; set; }
        public string CardHolderName { get; set; }
        public string CardHolderBillingAddress { get; set; }
        public Int32 CardNumber { get; set; }
        public Guid? CardTypeId { get; set; }
        public string CardExpiryDate { get; set; }
        public string CardSecurityCode { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BookingId" + BookingId);
            stringBuilder.Append("BookingPaymentId" + BookingPaymentId);
            stringBuilder.Append("CardHolderName" + CardHolderName);
            stringBuilder.Append("CardNumber" + CardNumber);
            stringBuilder.Append("CardHolderBillingAddress" + CardHolderBillingAddress);
            stringBuilder.Append("CardExpiryDate" + CardExpiryDate);
            stringBuilder.Append("CardSecurityCode" + CardSecurityCode);
            stringBuilder.Append("CardTypeId" + CardTypeId);
            stringBuilder.Append("CardSecurityCode" + CardSecurityCode);
            return base.ToString();
        }
    }
}
