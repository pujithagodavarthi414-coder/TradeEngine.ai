using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Performance
{
    public class PerformanceReportModel
    {
        public Guid? EntityId { get; set; }
        public Guid? UserId { get; set; }
        public string SearchText { get; set; }

        public Guid? PerformanceId { get; set; }
        public string ConfigurationName { get; set; }
        public string PerformanceName { get; set; }
        public string Status { get; set; }
        public Guid? OfUserId { get; set; }
        public string OfUserName { get; set; }
        public string OfUserImage { get; set; }
        public Guid? SubmittedBy { get; set; }
        public string SubmittedByName { get; set; }
        public string SubmittedByProfileImage { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CreatedByUserName { get; set; }
        public string CreatedByUserImage { get; set; }
        public Guid? ClosedByUserId { get; set; }
        public string ClosedByUserName { get; set; }
        public string ClosedByUserImage { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string FormData { get; set; }
        public string FormJson { get; set; }
        public int TotalCount { get; set; }        
        public DateTime LatestModificationOn { get; set; }
    }
}
