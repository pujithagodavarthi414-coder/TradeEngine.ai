using Btrak.Models.Branch;
using Btrak.Models.MasterData;
using Btrak.Models.Role;
using System;
using System.Collections.Generic;

namespace Btrak.Models.LeaveManagement
{
    public class LeaveApplicabilitySearchOutputModel
    {
        public Guid? LeaveTypeId { get; set; }
        public Guid? LeaveApplicabilityId { get; set; }
        public float? MinExperienceInMonths { get; set; }
        public float? MaxExperienceInMonths { get; set; }
        public byte[] TimeStamp { get; set; }
        public float? MaxLeaves { get; set; }
        public string RoleXml { get; set; }
        public string BranchXml  { get; set; }
        public string GenderXml { get; set; }
        public string MariatalStatusXml { get; set; }
        public string EmployeeXml { get; set; }
        public List<RolesInputModel> RoleIdModels { get; set; }
        public List<BranchApiReturnModel> BranchModels { get; set; }
        public List<GendersOutputModel> GenderModels { get; set; }
        public List<MaritalStatusesOutputModel> MaritalStatusModels { get; set; }
        public List<EmployeesOutputModel> EmployeesModels { get; set; }
        public List<Guid?> RoleIds { get; set; }
        public List<Guid?> BranchIds { get; set; }
        public List<Guid?> GenderIds { get; set; }
        public List<Guid?> MaritalStatusIds { get; set; }
        public List<Guid?> EmployeeIds { get; set; }
    }

    public class EmployeesOutputModel
    {
        public Guid? EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public int? TotalCount { get; set; }
    }
}
