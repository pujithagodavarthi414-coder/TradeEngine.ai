using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BankAccount
{
    public class BankAccountInputModel : InputModelBase
    {
        public BankAccountInputModel() : base(InputTypeGuidConstants.BankAccountInputCommandTypeGuid)
        {

        }

        public Guid? Id { get; set; }
        public string BankAccountName { get; set; }
        public string Beneficiaire { get; set; }
        public string Banque { get; set; }
        public string Iban { get; set; }
        public bool? IsArchived { get; set; }
    }
}
