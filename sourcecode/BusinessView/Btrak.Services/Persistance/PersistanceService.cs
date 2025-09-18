using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.Persistance;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Persistance;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services
{
    public class PersistanceService : IPersistanceService
    {
        private readonly PersistanceRepository _persistanceRepository = new PersistanceRepository();

        private readonly AuditService _auditService = new AuditService();

        public Guid? UpdatePersistance(PersistanceApiInputModel persistanceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdatePersistance", "PersistanceApiInputModel", persistanceApiInputModel, "Persistance Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? persistanceId = _persistanceRepository.UpdatePersistance(persistanceApiInputModel, loggedInContext, validationMessages);

            if (persistanceId != Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Persistance audit saving", "Persistance Service"));

                _auditService.SaveAudit(AppConstants.Widgets, persistanceApiInputModel, loggedInContext);

                return persistanceId;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Update Persistance", "Persistance Service"));
            return null;
        }

        public PersistanceApiReturnModel GetPersistance(PersistanceApiInputModel persistanceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPersistance", "PersistanceApiInputModel", persistanceApiInputModel, "Persistance Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _persistanceRepository.GetPersistance(persistanceApiInputModel, loggedInContext, validationMessages);
        }
    }
}
