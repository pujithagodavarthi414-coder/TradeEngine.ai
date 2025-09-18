using BTrak.Adapter.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Models.Integration;

namespace BTrak.Adapter
{
    public class Integration
    {
        IMyWork myWork;
        public Integration(string integrationType)
        {
            if (integrationType.Trim().ToLower() == "jira")
            {
                myWork = new JiraIntegrationService();
            }
        }

        public bool ValidateIntegrationDetails(IntegrationDetailsModel integrationDetailsModel)
        {
            return myWork.ValidateIntegrationDetails(integrationDetailsModel);
        }

        public List<MyWorkDetailsModel> GetWorkItemDetails(UserProjectIntegrationModel userProjectIntegrations)
        {
            return myWork.GetUserWorkItemsList(userProjectIntegrations);
        }

        public bool AddWorkLogTime(UserProjectIntegrationModel userProjectIntegrations, WorkLogTimeInputModel addWorkLogInputModel)
        {
            return myWork.AddWorkLogTime(userProjectIntegrations,addWorkLogInputModel);
        }
    }
}
