using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Performance
{
    public class PerformanceOutputModel
    {
        public Guid? PerformanceId { get; set; }

        public Guid? ConfigurationId { get; set; }
        public string ConfigurationName { get; set; }
        public Guid? AssignedById { get; set; }
        public string AssignedByUser { get; set; }
        public string AssignedByImage { get; set; }
        public DateTime AssignedOn { get; set; }
        public int TotalNumber { get; set; }

        public string FormJson { get; set; }
        public string FormData { get; set; }
        public bool IsDraft { get; set; }
        public bool IsSubmitted { get; set; }

        public Guid? SubmittedBy { get; set; }
        public string SubmittedByUser { get; set; }
        public DateTime? SubmittedOn { get; set; }

        public bool IsApproved { get; set; }
        public Guid? ApprovedBy { get; set; }
        public string ApprovedByUser { get; set; }
        public DateTime? ApprovedOn { get; set; }
    }
}
