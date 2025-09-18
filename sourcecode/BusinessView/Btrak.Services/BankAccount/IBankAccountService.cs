using Btrak.Models;
using Btrak.Models.BankAccount;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.BankAccount
{
    public interface IBankAccountService
    {

        Guid? UpsertBankAccount(BankAccountInputModel grdInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<BankAccountSearchOutputModel> GetBankAccount(BankAccountSearchInputModel grdInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
