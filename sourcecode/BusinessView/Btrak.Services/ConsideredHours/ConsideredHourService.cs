using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.ConsiderHour;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Services.Helpers.ConsiderHour;

namespace Btrak.Services.ConsideredHours
{
    public class ConsideredHourService : IConsideredHourService
    {
        private readonly ConsiderHourRepository _considerHourRepository;
        private readonly IAuditService _auditService;

        public ConsideredHourService(ConsiderHourRepository considerHourRepository, IAuditService auditService)
        {
            _considerHourRepository = considerHourRepository;
            _auditService = auditService;
        }

        public Guid? UpsertConsideredHours(ConsiderHourUpsertInputModel considerHourUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            considerHourUpsertInputModel.ConsiderHourName = considerHourUpsertInputModel.ConsiderHourName?.Trim();

            LoggingManager.Debug(considerHourUpsertInputModel.ToString());

            if (!ConsiderHourValidations.ValidateUpsertConsiderHour(considerHourUpsertInputModel,loggedInContext, validationMessages))
            {
                return null;
            }

            considerHourUpsertInputModel.ConsiderHourId = _considerHourRepository.UpsertConsideredHours(considerHourUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertConsideredHoursCommandId, considerHourUpsertInputModel, loggedInContext);

            LoggingManager.Debug(considerHourUpsertInputModel.ConsiderHourId?.ToString());

            return considerHourUpsertInputModel.ConsiderHourId;
        }

        public List<ConsiderHourApiReturnModel> GetAllConsideredHours(ConsiderHourInputModel considerHourInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllConsideredHours", "ConsideredHour Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetAllConsideredHoursCommandId, considerHourInputModel, loggedInContext);

            List<ConsiderHourApiReturnModel> considerHourReturnModels = _considerHourRepository.GetAllConsideredHours(considerHourInputModel, loggedInContext, validationMessages).ToList();
            
            return considerHourReturnModels;
        }

        public ConsiderHourApiReturnModel GetConsideredHoursById(Guid? consideredHourId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetConsideredHoursById", "ConsideredHour Service"));

            if (!ConsiderHourValidations.ValidateConsiderHourById(consideredHourId, loggedInContext, validationMessages))
            {
                return null;
            }

            var considerHourInputModel = new ConsiderHourInputModel
            {
                ConsiderHourId = consideredHourId
            };

            ConsiderHourApiReturnModel considerHourReturnModels = _considerHourRepository.GetAllConsideredHours(considerHourInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!ConsiderHourValidations.ValidateConsiderHourFoundWithId(consideredHourId, validationMessages, considerHourReturnModels))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetConsideredHoursByIdCommandId, considerHourInputModel, loggedInContext);

            return considerHourReturnModels;
        }
    }
}
