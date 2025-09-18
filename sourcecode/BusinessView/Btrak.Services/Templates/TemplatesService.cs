using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.Templates;
using Btrak.Services.Audit;
using Btrak.Services.Helpers.Templates;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.Templates
{
   public class TemplatesService : ITemplatesService
    {
        private readonly TemplatesRepository _templateRepository;
        private readonly IAuditService _auditService;

        public TemplatesService(TemplatesRepository templateRepository,
           IAuditService auditService)
        {
            _templateRepository = templateRepository;
            _auditService = auditService;
        }

        public TemplatesApiReturnModel GetTemplateById(Guid? templateId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTemplateById", "Template Service" + "and template id=" + templateId));

            LoggingManager.Debug(templateId?.ToString());

            if (!TemplatesValidationHelper.GetTemplateByIdValidations(templateId, loggedInContext, validationMessages))
                return null;

            var templateSearchCriteriaInputModel = new TemplatesSearchCriteriaInputModel
            {
                TemplateId = templateId
            };

            TemplatesApiReturnModel templateApiReturnModel = _templateRepository.SearchTemplates(templateSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (templateApiReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundTemplateWithTheId, templateId)
                });

                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetCustomFieldFormsCommandId, templateSearchCriteriaInputModel, loggedInContext);

            return templateApiReturnModel;
        }

        public List<TemplatesApiReturnModel> SearchTemplates(TemplatesSearchCriteriaInputModel templatesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchTemplates", "Templates Service"));

            _auditService.SaveAudit(AppCommandConstants.GetCustomFieldFormsCommandId, templatesSearchCriteriaInputModel, loggedInContext);

            List<TemplatesApiReturnModel> templatesApiReturnModels = _templateRepository.SearchTemplates(templatesSearchCriteriaInputModel, loggedInContext, validationMessages);

            return templatesApiReturnModels;
        }

        public Guid? UpsertTemplate(TemplatesUpsertModel templatesUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTemplate", "Templates Service"));

            LoggingManager.Debug(templatesUpsertInputModel.ToString());

            if (!TemplatesValidationHelper.UpsertTemplateValidations(templatesUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? templateId = _templateRepository.UpsertTemplates(templatesUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertCustomFieldFormsCommandId, templatesUpsertInputModel, loggedInContext);
            return templateId;
        }

        public Guid? InsertTemplateDuplicate(TemplatesUpsertModel templatesUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertTemplateDuplicate", "Templates Service"));

            LoggingManager.Debug(templatesUpsertInputModel.ToString());

            if (!TemplatesValidationHelper.UpsertTemplateValidations(templatesUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? templateId = _templateRepository.InsertTemplateDuplicate(templatesUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertCustomFieldFormsCommandId, templatesUpsertInputModel, loggedInContext);
            return templateId;
        }

        public Guid? DeleteTemplate(TemplatesUpsertModel templatesUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteTemplate", "Templates Service"));

            LoggingManager.Debug(templatesUpsertInputModel.ToString());

            Guid? templateId = _templateRepository.DeleteTemplates(templatesUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertCustomFieldFormsCommandId, templatesUpsertInputModel, loggedInContext);
            return templateId;
        }
    }
}
