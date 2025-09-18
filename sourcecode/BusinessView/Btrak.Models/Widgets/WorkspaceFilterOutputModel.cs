using Btrak.Models.Branch;
using Btrak.Models.ComplianceAudit;
using Btrak.Models.GenericForm;
using Btrak.Models.HrManagement;
using Btrak.Models.MasterData;
using Btrak.Models.ProductivityDashboard;
using Btrak.Models.Projects;
using Btrak.Models.Role;
using Btrak.Models.TestRail;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class WorkspaceFilterOutputModel
    {
        public IList<TestRailProjectApiReturnModel> ProjectsList { get; set; }
        public List<FilterKeyValuePair> CustomApplicationTagKeys { get; set; }
        public List<TeamMemberOutputModel> UsersList { get; set; }
        public List<FilterKeyValuePair> WorkspaceFilters { get; set; }
        public List<EntityDropDownOutputModel> EntityList { get; set; }
        public List<BranchApiReturnModel> BranchList { get; set; }
        public List<DesignationApiReturnModel> DesignationList { get; set; }
        public List<RolesOutputModel> RolesList { get; set; }
        public List<DepartmentApiReturnModel> DepartmentList { get; set; }
        public List<AuditComplianceApiReturnModel> AuditList { get; set; }
        public List<BusinessUnitDropDownModel> BusinessUnitsList { get; set; }
    }
}