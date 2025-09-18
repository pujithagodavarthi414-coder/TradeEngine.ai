using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeJobInputModel : InputModelBase
    {
        public EmployeeJobInputModel() : base(InputTypeGuidConstants.EmployeeJobInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeJobDetailId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? DesignationId { get; set; }
        public Guid? EmploymentStatusId { get; set; }
        public Guid? JobCategoryId { get; set; }
        public DateTime? JoinedDate { get; set; }
        public Guid? DepartmentId { get; set; }
        public Guid? BranchId { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public bool? IsArchived { get; set; }
        public int? NoticePeriodInMonths { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmployeeJobDetailId = " + EmployeeJobDetailId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", DesignationId = " + DesignationId);
            stringBuilder.Append(", EmploymentStatusId = " + EmploymentStatusId);
            stringBuilder.Append(", JobCategoryId = " + JobCategoryId);
            stringBuilder.Append(", JoinedDate = " + JoinedDate);
            stringBuilder.Append(", DepartmentId = " + DepartmentId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(", ActiveTo = " + ActiveTo);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
