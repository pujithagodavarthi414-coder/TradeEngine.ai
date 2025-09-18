using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.CustomTags;
using Btrak.Services.Audit;
using Btrak.Services.Helpers.CustomTags;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.CustomTags
{
    public class CustomTagService : ICustomTagService
    {
        private readonly CustomTagRepository _customTagsRepository;
        private readonly IAuditService _auditService;

        public CustomTagService(CustomTagRepository customTagRepository, IAuditService auditService)
        {
            _customTagsRepository = customTagRepository;
            _auditService = auditService;
        }

        public Guid? UpsertCustomTags(CustomTagsInputModel customTagsInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomTags", "CustomTagService"));

            LoggingManager.Debug(customTagsInput.ToString());

            if (!CustomTagsValidations.ValidateUpsertCustomFieldForm(customTagsInput, loggedInContext, validationMessages))
            {
                return null;
            }

            if (customTagsInput.TagsList.ToList().Count > 0)
            {
                customTagsInput.TagsXml = Utilities.ConvertIntoListXml(customTagsInput.TagsList.ToList());
            }

            Guid? customTagId = _customTagsRepository.UpsertCustomTags(customTagsInput, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertCustomTagsCommandId, customTagsInput, loggedInContext);
            return customTagId;
        }

        public List<CustomTagsInputModel> GetCustomTags(CustomTagsSearchCriteriaModel customTagsSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCustomTags", "CustomTags Service"));

            _auditService.SaveAudit(AppCommandConstants.GetCustomTagsCommandId, customTagsSearchCriteriaModel, loggedInContext);

            return _customTagsRepository.GetCustomTags(customTagsSearchCriteriaModel, loggedInContext, validationMessages);
        }

        public Guid? UpsertTags(CustomTagsInputModel customTagsInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCustomTags", "CustomTagService"));

            LoggingManager.Debug(customTagsInput.ToString());
            if (!CustomTagsValidations.ValidateUpsertTagFieldForm(customTagsInput, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? tagId = _customTagsRepository.UpsertTags(customTagsInput, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertCustomTagsCommandId, customTagsInput, loggedInContext);
            return tagId;
        }
    }
}
