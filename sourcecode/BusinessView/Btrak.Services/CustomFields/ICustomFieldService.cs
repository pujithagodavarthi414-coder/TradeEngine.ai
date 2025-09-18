using Btrak.Models;
using Btrak.Models.CustomFields;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.CustomFields
{
   public interface ICustomFieldService
    {
        Guid? UpsertCustomFieldForm(UpsertCustomFieldModel customFieldFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CustomFieldApiReturnModel> SearchCustomFields(CustomFieldSearchCriteriaInputModel customFieldSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CustomFieldApiReturnModel GetCustomFieldById(Guid? customFieldId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateCustomFieldData(UpsertCustomFieldModel customFieldFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CustomFieldsHistoryApiReturnModel> SearchCustomFieldsHistory(CustomFieldHistorySearchCriteriaModel customFieldSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
