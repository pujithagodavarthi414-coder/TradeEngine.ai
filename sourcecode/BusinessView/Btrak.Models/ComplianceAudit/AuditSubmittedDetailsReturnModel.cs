using System;
using System.Collections.Generic;

namespace Btrak.Models.ComplianceAudit
{
    public class AuditSubmittedDetailsReturnModel
    {
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public string AuditConductName { get; set; }
        public Guid? AuditConductId { get; set; }
        public string AuditName { get; set; }
        public Guid? AuditId { get; set; }
        public Guid? ProjectId { get; set; }
        public bool? IsCompleted { get; set; }
        public string SubmittedBy { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? QuestionId { get; set; }
        public string QuestionName { get; set; }
        public bool? QuestionOptionResult { get; set; }
        public List<List<AuditSubmittedDetailsReturnModel>> AuditDeatils { get; set; }
    }

    public class AuditSearchInputModel
    {
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? AuditId { get; set; }
        public Guid? ProjectId { get; set; }
    }
}
