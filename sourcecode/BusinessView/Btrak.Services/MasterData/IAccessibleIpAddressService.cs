using Btrak.Models;
using Btrak.Models.MasterData;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.MasterData
{
    public interface IAccessibleIpAddressService
    {
        Guid? UpsertAccessibleIpAddresses(AccessibleIpAddressUpsertModel accessibleIpAddressUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
