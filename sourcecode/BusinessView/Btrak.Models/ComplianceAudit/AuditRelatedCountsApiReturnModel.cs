using System;

namespace Btrak.Models.ComplianceAudit
{
    public class AuditRelatedCountsApiReturnModel
    {
        public int ActiveAuditsCount { get; set; }
        public int ArchivedAuditsCount { get; set; }
        public int ActiveAuditConductsCount { get; set; }
        public int ArchivedAuditConductsCount { get; set; }
        public int ActiveAuditReportsCount { get; set; }
        public int ArchivedAuditReportsCount { get; set; }
        public int ActionsCount { get; set; }
        public int ActiveAuditFoldersCount { get; set; }
        public int ArchivedAuditFoldersCount { get; set; }
        public Guid? ProjectId { get; set; }
    }
}
