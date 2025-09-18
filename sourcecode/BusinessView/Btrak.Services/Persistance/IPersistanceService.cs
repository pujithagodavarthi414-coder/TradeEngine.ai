using Btrak.Models;
using Btrak.Models.Persistance;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Persistance
{
    public interface IPersistanceService
    {
        Guid? UpdatePersistance(PersistanceApiInputModel persistanceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        PersistanceApiReturnModel GetPersistance(PersistanceApiInputModel persistanceApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
