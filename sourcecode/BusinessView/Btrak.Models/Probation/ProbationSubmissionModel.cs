using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Probation
{
    public class ProbationSubmissionModel
    {
        public Guid? ProbationId { get; set; }
        public Guid? ConfigurationId { get; set; }
        public bool IsOpen { get; set; }
        public bool IsShare { get; set; }
        public bool IsArchived { get; set; }
        public string PdfUrl { get; set; }
        public Guid? OfUserId { get; set; }

        public Guid? ProbationDetailsId { get; set; }
        public string FormData { get; set; }
        public int SubmissionFrom { get; set; }
        public Guid? SubmittedBy { get; set; }
        public bool? IsCompleted { get; set; }

        public int PageSize { get; set; } = 1000;
        public int PageNumber { get; set; } = 1;
        public string SortBy { get; set; }
        public string SearchText { get; set; }
        public string OfUserName { get; set; }
        public bool SortDirectionAsc { get; set; }
        public Guid? EmployeeId { get; set; }

        public string SortDirection => SortDirectionAsc ? "ASC" : "DESC";
    }
}
