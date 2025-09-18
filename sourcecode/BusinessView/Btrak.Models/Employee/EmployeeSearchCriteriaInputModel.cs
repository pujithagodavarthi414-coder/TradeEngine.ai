using System;
using BTrak.Common;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeSearchCriteriaInputModel() : base(InputTypeGuidConstants.EmployeeSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeId { get; set; }
        public Guid? UserId { get; set; }
        public string EmailSearchText { get; set; }
        public Guid? DepartmentId { get; set; }
        public Guid? DesignationId { get; set; }
        public Guid? EmploymentStatusId { get; set; }
        public bool? IsTerminated { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? LineManagerId { get; set; }
        public Guid? EntityId { get; set; }
        public bool? IsReportTo { get; set; }
        public Guid? PayRollTemplateId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", EmailSearchText = " + EmailSearchText);
            stringBuilder.Append(", DepartmentId = " + DepartmentId);
            stringBuilder.Append(", DesignationId = " + DesignationId);
            stringBuilder.Append(", LineManagerId = " + LineManagerId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", EmploymentStatusId = " + EmploymentStatusId);
            stringBuilder.Append(", IsTerminated = " + IsTerminated);
            stringBuilder.Append(", EntityId = " + EntityId);
            stringBuilder.Append(", IsReportTo = " + IsReportTo);
            stringBuilder.Append(", PayRollTemplateId = " + PayRollTemplateId);
            return stringBuilder.ToString();
        }
    }
}