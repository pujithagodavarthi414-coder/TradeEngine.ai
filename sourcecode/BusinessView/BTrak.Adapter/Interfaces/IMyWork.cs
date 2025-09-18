using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Models.Integration;

namespace BTrak.Adapter.Interfaces
{
    public interface IMyWork
    {
        bool ValidateIntegrationDetails(IntegrationDetailsModel integrationDetailsModel);

        List<MyWorkDetailsModel> GetUserWorkItemsList(UserProjectIntegrationModel userProjectIntegrations);

        bool AddWorkLogTime(UserProjectIntegrationModel userProjectIntegrations,WorkLogTimeInputModel addWorkLogInputModel);
    }
}
