using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Crm.Payment
{
    public class PaymentInputModel
    {
        public Guid? PaymentId { get; set; }
        public PaymentType PaymentType { get; set; }
        public int AmountDue { get; set; }
        public Guid? ReceiverId { get; set; }
        public int AmountPaid { get; set; }
        public string ChequeNumber { get; set; }
        public string BankName { get; set; }
        public string BenificiaryName { get; set; }
        public string PaidBy { get; set; }
    }

    public enum PaymentType
    {
        [Description("CASH")]
        Cash,
        [Description("CHEQUE")]
        Cheque,
        [Description("CREDITCARD")]
        CreditCard,
        [Description("DEBITCARD")]
        DebitCard,
        [Description("UPI")]
        UPI,
        [Description("NETBANKING")]
        NetBanking,
        [Description("OTHERS")]
        Others
    }
}
