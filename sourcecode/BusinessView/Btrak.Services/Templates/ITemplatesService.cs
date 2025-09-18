using Btrak.Models;
using Btrak.Models.Templates;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Templates
{
    public interface ITemplatesService
    {
        Guid? UpsertTemplate(TemplatesUpsertModel templatesUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? InsertTemplateDuplicate(TemplatesUpsertModel templatesUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TemplatesApiReturnModel> SearchTemplates(TemplatesSearchCriteriaInputModel templatesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TemplatesApiReturnModel GetTemplateById(Guid? TemplateId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteTemplate(TemplatesUpsertModel templatesUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
