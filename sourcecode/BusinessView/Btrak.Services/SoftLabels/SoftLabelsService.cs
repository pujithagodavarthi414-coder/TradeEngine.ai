using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.SoftLabels;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.SoftLabelsValidationHelpers;
using BTrak.Common;

namespace Btrak.Services.SoftLabels
{
    public class SoftLabelsService : ISoftLabelsService
    {
        private readonly SoftLabelsRepository _softLabelsRepository;
        private readonly IAuditService _auditService;

        public SoftLabelsService(SoftLabelsRepository softLabelsRepository, IAuditService auditService)
        {
            _softLabelsRepository = softLabelsRepository;
            _auditService = auditService;
        }

        public Guid? UpsertSoftLabels(SoftLabelsInputMethod softLabelsInputMethod, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertSoftLabels", "softLabelsInputMethod", softLabelsInputMethod, "Soft Labels Service"));
            if (!SoftLabelsValidationHelper.UpsertSoftLabelsValidation(softLabelsInputMethod, loggedInContext,
                validationMessages))
            {
                return null;
            }

            softLabelsInputMethod.SoftLabelId = _softLabelsRepository.UpsertSoftLabels(softLabelsInputMethod, loggedInContext, validationMessages);
            LoggingManager.Debug("Soft Label with the id " + softLabelsInputMethod.SoftLabelId);
            _auditService.SaveAudit(AppCommandConstants.UpsertSoftLabelsCommandId, softLabelsInputMethod, loggedInContext);
            return softLabelsInputMethod.SoftLabelId;
        }

        public List<SoftLabelsOutputMethod> GetSoftLabels(SoftLabelsSearchCriteriaInputModel softLabelsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetSoftLabels", "softLabelsSearchCriteriaInputModel", softLabelsSearchCriteriaInputModel, "Soft Labels Service"));
            _auditService.SaveAudit(AppCommandConstants.GetSoftLabelsCommandId, softLabelsSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                softLabelsSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Soft Label list ");
            List<SoftLabelsOutputMethod> softLabelList = _softLabelsRepository.GetSoftLabels(softLabelsSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return softLabelList;
        }
    }
}
