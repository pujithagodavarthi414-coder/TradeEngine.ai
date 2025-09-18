
using Btrak.Models;
using Btrak.Models.ButtonType;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.ButtonType
{
    public interface IButtonTypeService
    {
        Guid? UpsertButtonType(ButtonTypeInputModel buttonTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ButtonTypeOutputModel> GetAllButtonTypes(ButtonTypeInputModel buttonTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ButtonTypeOutputModel GetButtonTypeById(Guid? buttonTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ButtonTypeByIdOutputModel GetButtonTypeDetailsById(Guid? buttonTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
