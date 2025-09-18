using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Features;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;

namespace Btrak.Services.Features
{
    public class FeatureService : IFeatureService
    {
        private readonly FeatureRepository _featureRepository;
        private readonly IAuditService _auditService;
        private readonly MenuItemRepository _menuItemRepository;

        public FeatureService(FeatureRepository featureRepository, IAuditService auditService, MenuItemRepository menuItemRepository)
        {
            _featureRepository = featureRepository;
            _auditService = auditService;
            _menuItemRepository = menuItemRepository;
        }

        public List<FeatureApiReturnModel> GetAllFeatures(FeatureInputModel featureInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllFeatures", "Feature Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAllFeaturesCommandId, featureInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<FeatureApiReturnModel> featuresList = _featureRepository.GetAllFeatures(featureInputModel, loggedInContext,validationMessages).ToList();

            return featuresList;
        }

        public List<UserPermittedFeatureApiRetrnModel> GetAllUserPermittedFeatures(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllUserPermittedFeatures", "Feature Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<UserPermittedFeatureApiRetrnModel> permittedFeaturesList = _featureRepository.GetAllUserPermittedFeatures(loggedInContext,validationMessages).ToList();

            return permittedFeaturesList;
        }

        public List<AppMenuItemApiReturnModel> GetAllApplicableMenuItems(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllApplicableMenuItems", "Feature Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<AppMenuItemApiReturnModel> allApplicableMenuItems = _menuItemRepository.GetAllApplicableMenuItems(loggedInContext, validationMessages).ToList();

            return allApplicableMenuItems;
        }
    }
}
