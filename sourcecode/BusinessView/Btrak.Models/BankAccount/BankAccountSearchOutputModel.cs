using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BankAccount
{
    public class BankAccountSearchOutputModel
    {
        public Guid Id { get; set; }
        public string BankAccountName { get; set; }
        public string Beneficiaire { get; set; }
        public string Banque { get; set; }
        public string Iban { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
