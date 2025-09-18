using Btrak.Models;
using Btrak.Services.Helpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Services.Helpers.HRManagementValidationHelpers;
using Btrak.Services.Audit;

namespace Btrak.Services.Intro
{
    public class IntroService : IIntroService
    {
        private readonly IntroRepository _introRepository;
        private readonly IAuditService _auditService;

        public IntroService()
        {
        }

        public IntroService(IntroRepository introRepository, IAuditService auditService)
        {

            _introRepository = new IntroRepository();
            _auditService = auditService;

        }
      
        public List<IntroOutputModel> GetIntro(IntroOutputModel intromodel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Getintro ", "Intro Service"));

           /* if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, intromodel, validationMessages))
            {
                return null;
            }*/

            //_auditService.SaveAudit(AppCommandConstants.GetCurrenciesId, intromodel, loggedInContext);

            LoggingManager.Debug(intromodel?.ToString());

            List<IntroOutputModel> introList = _introRepository.GetIntro(intromodel, validationMessages, loggedInContext).ToList();



            return introList;
        }
        public Guid? UpsertIntro(IntroOutputModel intromodel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertIntro", "intromodel", intromodel, "Intro Service"));
           /* if (!HrManagementValidationsHelper.UpsertCurrencyValidation(intromodel, loggedInContext,
                validationMessages))
            {
                return null;
            }*/

            intromodel.IntroId = _introRepository.UpsertIntro(intromodel, loggedInContext, validationMessages);
            LoggingManager.Debug("Intro with the id " + intromodel.IntroId);
            _auditService.SaveAudit(AppCommandConstants.UpsertIntroCommandId, intromodel, loggedInContext);
            return intromodel.IntroId;
        }

       
    }
}
