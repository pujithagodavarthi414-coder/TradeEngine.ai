using System.Collections.Generic;

namespace Btrak.Models.WorkFlow
{
    public class WorkFlowAndStatusModel
    {
        public List<WorkFlowApiReturnModel> WorkFlows { get; set; }

        public List<WorkFlowStatusApiReturnModel> WorkFlowStatuses { get; set; }

        public List<WorkFlowEligibleStatusTransitionApiReturnModel> WorkFlowEligibleStatusTransitionModels { get; set; }
    }
}