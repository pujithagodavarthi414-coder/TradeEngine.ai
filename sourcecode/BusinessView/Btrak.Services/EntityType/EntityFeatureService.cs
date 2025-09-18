using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.EntityType;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;

namespace Btrak.Services.EntityType
{
    public class EntityFeatureService : IEntityFeatureService
    {
        private readonly EntityFeatureRepository _entityFeatureRepository;
        private readonly IAuditService _auditService;
        public EntityFeatureService(EntityFeatureRepository entityFeatureRepository, IAuditService auditService)
        {
            _entityFeatureRepository = entityFeatureRepository;
            _auditService = auditService;
        }

        public List<EntityFeatureApiReturnModel> GetAllPermittedEntityFeatures(EntityFeatureSearchInputModel entityFeatureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, entityFeatureSearchInputModel, "GetAll Permitted Entity Features Service"));

            LoggingManager.Debug(entityFeatureSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAllPermittedEntityFeaturesCommandId, entityFeatureSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<EntityFeatureApiReturnModel> entityTypeFeatureApiReturnModels = _entityFeatureRepository.SearchEntityFeatures(entityFeatureSearchInputModel, loggedInContext, validationMessages).ToList();

            return entityTypeFeatureApiReturnModels;
        }
    }
}
