using BTrak.Common;
using System;

namespace Btrak.Models.Performance
{
    public class PerformanceModel : InputModelBase
    {
        public PerformanceModel() : base(InputTypeGuidConstants.PerformanceCommandId)
        {
        }
        public Guid? PerformanceId { get; set; }
        public Guid? ConfigurationId { get; set; }
        public string FormData { get; set; }
        public bool IsDraft { get; set; }
        public bool WaitingForApproval { get; set; }
        public bool IsSubmitted { get; set; }
        public Guid? SubmittedBy { get; set; }
        public bool IsApproved { get; set; }
        public Guid? ApprovedBy { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public bool IncludeApproved { get; set; }
    }
}
