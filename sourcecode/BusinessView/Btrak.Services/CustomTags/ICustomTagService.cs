using Btrak.Models;
using Btrak.Models.CustomTags;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.CustomTags
{
    public interface ICustomTagService
    {
        Guid? UpsertCustomTags(CustomTagsInputModel customTagsInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTags(CustomTagsInputModel customTagsInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CustomTagsInputModel> GetCustomTags(CustomTagsSearchCriteriaModel customTagsSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
