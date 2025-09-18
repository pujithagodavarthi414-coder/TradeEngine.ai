using Btrak.Models.GenericForm;
using Btrak.Models.Projects;
using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class WorkspaceFilterInputModel
    {
        public ProjectSearchCriteriaInputModel SearchCriteriaInputModel { get; set; }
        public DynamicDashboardFilterModel DashboardFilterModel { get; set; }
        public GetCustomApplicationTagInpuModel GetCustomApplicationTagInpuModel { get; set; }
    }
}
