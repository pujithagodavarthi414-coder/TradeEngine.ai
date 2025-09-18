using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
   public class PayRollRunTemplate
    {
        public string TraceAccountNumber { get; set; }
        public DateTime DateOfTransaction { get; set; }
        public string FileReference { get; set; }
        public string TransactionType { get; set; }
        public string DebitAccountNumber { get; set; }
        public string DebitAccountIfsc { get; set; }
        public string BeneficiaryAccountNumber { get; set; }
        public string BeneficiaryName { get; set; }
        public DateTime? RunDate { get; set; }
        public decimal Amount { get; set; }
        public string RemarksForClient { get; set; }
        public string RemarksForBeneficiary { get; set; }
        public Guid? PayrollRunEmployeeId { get; set; }
        public bool? IsProcessedToPay { get; set; }
        public string BankName { get; set; }
        public Guid? BankId { get; set; }
        public DateTime? ChequeDate { get; set; }
        public string AlphaCode { get; set; }
        public string Cheque { get; set; }
        public string ChequeNo { get; set; }
    }
}
