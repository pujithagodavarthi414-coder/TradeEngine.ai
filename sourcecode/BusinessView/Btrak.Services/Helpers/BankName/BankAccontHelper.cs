using Btrak.Models;
using Btrak.Models.BankAccount;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Helpers.BankName
{
    public class BankAccontHelper
    {
        public static bool UpsertGRDValidation(BankAccountInputModel bankAccountInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGRDValidation", "bankAccountInputModel", bankAccountInputModel, "Bank Accont Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(bankAccountInputModel.BankAccountName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyName)
                });
            }
            return validationMessages.Count <= 0;
        }
    }
}
