using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Currency;
using BTrak.Common;

namespace Btrak.Services.Currency
{
    public interface ICurrencyService
    {
        List<CurrencyOutputModel> GetCurrencyList(CurrencySearchCriteriaInputModel currencySearchCriteriaInputModel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext);
    }
}
