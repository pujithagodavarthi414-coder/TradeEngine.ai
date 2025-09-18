using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Widgets
{
    public class DashboardFilterModel
    {
        public Guid? ProjectId { get; set; }

        public Guid? AuditId { get; set; }

        public Guid? UserId { get; set; }

        public Guid? GoalId { get; set; }

        public Guid? DashboardId { get; set; }

        public Guid? EntityId { get; set; }

        public Guid? BranchId { get; set; }

        public Guid? DesignationId { get; set; }

        public Guid? SourceId { get; set; }

        public Guid? CandidateId { get; set; }

        public Guid? HiringStatusId { get; set; }

        public Guid? JobOpeningStatusId { get; set; }

        public Guid? EmploymentStatusId { get; set; }

        public Guid? TestSuiteId { get; set; }
        public string BusinessUnitId { get; set; }
        public bool? IsActiveEmployees { get; set; }

        public Guid? FormId { get; set; }
    }
}

