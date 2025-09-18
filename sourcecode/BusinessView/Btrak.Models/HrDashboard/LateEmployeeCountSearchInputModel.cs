using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrDashboard
{
    public class LateEmployeeCountSearchInputModel : SearchCriteriaInputModelBase
    {
        public LateEmployeeCountSearchInputModel() : base(InputTypeGuidConstants.LateEmployeeCountSearchInputCommandTypeGuid)
        {
        }

        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? TeamLeadId { get; set; }
        public Guid? DepartmentId { get; set; }
        public Guid? DesignationId { get; set; }
        public Guid? EntityId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", TeamLeadId = " + TeamLeadId);
            stringBuilder.Append(", DepartmentId = " + DepartmentId);
            stringBuilder.Append(", DesignationId = " + DesignationId);
            return stringBuilder.ToString();
        }
    }
}