using System;
using BTrak.Common;

namespace Btrak.Services.WorkFlowLibrary.ProjectManagement
{
    public interface IProjectManagementWorkFlowService
    {
        void StartWorkItemAssignedWorkFlow(Guid userStoryId,LoggedInContext loggedInContext);
    }
}