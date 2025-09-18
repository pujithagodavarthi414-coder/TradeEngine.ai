using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Services.Audit;
using Btrak.Services.Helpers.AccessibilityValidationHelpers;
using BTrak.Common;

namespace Btrak.Services.Access
{
    public class AccessibilityService : IAccessibilityService
    {
        private readonly RoleFeatureRepository _roleFeatureRepository;
        private readonly IAuditService _auditService;
        public AccessibilityService(RoleFeatureRepository roleFeatureRepository, IAuditService auditService)
        {
            _auditService = auditService;
            _roleFeatureRepository = roleFeatureRepository;
        }

        public bool? GetIfUserAccessibleToFeature(Guid userId, Guid featureId, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,
                "GetIfUserAccessibleToFeature",
                "Accessibility Service"));
            validationMessages =
                AccessibilityValidationHelper.IfUserAccessibleToFeatureCheckValidation(userId, featureId, loggedInContext, validationMessages);
            if (validationMessages.Count > 0)
            {
                return null;
            }
            bool? isAccessible = _roleFeatureRepository.GetIfUserCanHaveAccess(userId, featureId, loggedInContext,validationMessages);
            _auditService.SaveAudit(AppCommandConstants.IsUserAccessibleToFeatureCommandId, "GetIfUserAccessibleToFeature", loggedInContext);
            return isAccessible;
        }
    }
}
