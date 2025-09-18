using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BankAccount
{
    public class BankAccountSearchInputModel : SearchCriteriaInputModelBase
    {
        public BankAccountSearchInputModel() : base(InputTypeGuidConstants.BankAccountSearchInputCommandTypeGuid)
        {

        }

        public Guid? Id { get; set; }
    }
}
