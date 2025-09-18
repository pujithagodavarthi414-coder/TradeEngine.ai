using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Models;
using BTrak.Common;

namespace Btrak.Services.Access
{
    public interface IAccessibilityService
    {
        bool? GetIfUserAccessibleToFeature(Guid userId, Guid featureId, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
    }
}
