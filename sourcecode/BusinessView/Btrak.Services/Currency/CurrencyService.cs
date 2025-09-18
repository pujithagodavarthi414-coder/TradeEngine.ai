using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Currency;
using Btrak.Services.Helpers;
using BTrak.Common;

namespace Btrak.Services.Currency
{
    public class CurrencyService : ICurrencyService
    {
        private readonly MasterTableRepository _masterTableRepository;

        public CurrencyService()
        {
            _masterTableRepository = new MasterTableRepository();
        }

        public List<CurrencyOutputModel> GetCurrencyList(CurrencySearchCriteriaInputModel currencySearchCriteriaInputModel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Currency List", "Currency Service"));

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Currency List", "Currency Service"));
            
            return _masterTableRepository.GetCurrencyList(currencySearchCriteriaInputModel, validationMessages, loggedInContext).ToList();
        }
    }
}
