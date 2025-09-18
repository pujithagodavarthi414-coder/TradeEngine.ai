using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.LeaveManagement
{
    public class LeaveApplicabilityUpsertInputModel : InputModelBase
    {
        public LeaveApplicabilityUpsertInputModel() : base(InputTypeGuidConstants.LeaveApplicabiltyInputCommandTypeGuid)
        {
        }

        public Guid? LeaveApplicabilityId { get; set; }
        public Guid? LeaveTypeId { get; set; }
        public List<Guid?> RoleId { get; set; }
        public Guid? EmployeeTypeId { get; set; }
        public List<Guid?> GenderId { get; set; }
        public List<Guid?> MaritalStatusId { get; set; }
        public List<Guid?> BranchId { get; set; }
        public List<Guid?> EmployeeId { get; set; }
        public Guid? DepartmentId { get; set; }
        public float? MinExperienceInMonths { get; set; }
        public float? MaxExperienceInMonths { get; set; }
        public int? MaxLeaves { get; set; }
        public bool? IsArchived { get; set; }
        public string RoleIdXml { get; set; }
        public string BranchIdXml { get; set; }
        public string GenderIdXml { get; set; }
        public string MaritalStatusIdXml { get; set; }
        public string EmployeeIdXml { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", LeaveApplicabiltyId = " + LeaveApplicabilityId);
            stringBuilder.Append(", LeaveTypeId = " + LeaveTypeId);
            stringBuilder.Append(", RoleId = " + RoleId);
            stringBuilder.Append(", EmployeetypeId = " + EmployeeTypeId);
            stringBuilder.Append(", GenderId = " + GenderId);
            stringBuilder.Append(", MaritalStatusId = " + MaritalStatusId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", MinExperienceInMonths = " + MinExperienceInMonths);
            stringBuilder.Append(", MaxExperienceInMonths = " + MaxExperienceInMonths);
            stringBuilder.Append(", MaxLeaves = " + MaxLeaves);
            stringBuilder.Append(", DepartmentId = " + DepartmentId);
            stringBuilder.Append(", RoleIdXml = " + RoleIdXml);
            stringBuilder.Append(", BranchIdXml = " + BranchIdXml);
            stringBuilder.Append(", GenderIdXml = " + GenderIdXml);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeIdXml = " + EmployeeIdXml);
            stringBuilder.Append(", MaritalStatusIdXml = " + MaritalStatusIdXml);
            return stringBuilder.ToString();
        }

    }
}