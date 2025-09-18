using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Probation
{
    public class ProbationSubmissionOutputModel
    {
        public Guid? ProbationId { get; set; }
        public Guid? ConfigurationId { get; set; }
        public string ConfigurationName { get; set; }
        public bool IsOpen { get; set; }
        public bool IsShare { get; set; }
        public bool IsArchived { get; set; }
        public bool IsCompleted { get; set; }
        public string PdfUrl { get; set; }
        public Guid? OfUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime SubmittedOn { get; set; }
        public Guid? ProbationDetailsId { get; set; }
        public string FormData { get; set; }
        public string FormJson { get; set; }
        public int SubmissionFrom { get; set; }
        public int TotalCount { get; set; }
        public Guid? SubmittedBy { get; set; }
        public string SubmittedByName { get; set; }
        public string SubmittedByProfileImage { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CreatedByUserName { get; set; }
        public string CreatedByUserImage { get; set; }
        public Guid? ClosedByUserId { get; set; }
        public string ClosedByUserName { get; set; }
        public string ClosedByUserImage { get; set; }
        public string OfUserName { get; set; }
        public DateTime LatestModificationOn { get; set; }
        public Guid? EmployeeId { get; set; }

    }
}
