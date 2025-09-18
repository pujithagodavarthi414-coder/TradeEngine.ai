using BTrak.Common;
using System;

namespace Btrak.Models.HrDashboard
{
    public class EmployeeAttendanceSearchInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeAttendanceSearchInputModel() : base(InputTypeGuidConstants.EmployeeAttendanceSearchCriteriaInputCommandTypeGuid)
        {
        }

        public DateTime? Date { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? TeamLeadId { get; set; }
        public Guid? DepartmentId { get; set; }
        public Guid? DesignationId { get; set; }
        public Guid? EntityId { get; set; }
    }
}