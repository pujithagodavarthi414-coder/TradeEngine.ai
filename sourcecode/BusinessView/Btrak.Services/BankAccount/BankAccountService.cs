using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.BankAccount;
using Btrak.Services.Audit;
using Btrak.Services.Helpers.BankName;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.BankAccount
{
    public class BankAccountService : IBankAccountService
    {
        private readonly BankAccountRepository _bankAccountRepository;
        private readonly IAuditService _auditService;

        public BankAccountService(BankAccountRepository bankAccountRepository, IAuditService auditService)
        {
            _bankAccountRepository = bankAccountRepository;
            _auditService = auditService;
        }

        public Guid? UpsertBankAccount(BankAccountInputModel bankAccountInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGRD", "grdInputModel", bankAccountInputModel, "GRD Service"));

            if (!BankAccontHelper.UpsertGRDValidation(bankAccountInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            bankAccountInputModel.Id = _bankAccountRepository.UpsertBankName(bankAccountInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug(bankAccountInputModel.Id?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertGRDCommandId, bankAccountInputModel, loggedInContext);

            return bankAccountInputModel.Id;
        }

        public List<BankAccountSearchOutputModel> GetBankAccount(BankAccountSearchInputModel bankAccountInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GeyGRD", "grdInput", bankAccountInputModel, "GRD Service"));

            _auditService.SaveAudit(AppCommandConstants.GetBankAccountCommandId, bankAccountInputModel, loggedInContext);

            List<BankAccountSearchOutputModel> bankAccountList = _bankAccountRepository.GetBankAccount(bankAccountInputModel, loggedInContext, validationMessages);

            return bankAccountList;
        }
    }
}
