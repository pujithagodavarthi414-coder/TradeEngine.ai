using System;
using BTrak.Common;
using System.Text;
using System.Collections.Generic;

namespace Btrak.Models.ComplianceAudit
{
    public class AuditReportApiReturnModel : InputModelBase
    {
        public AuditReportApiReturnModel() : base(InputTypeGuidConstants.AuditCategoryInputModelCommandTypeGuid)
        {
        }

        public Guid? AuditReportId { get; set; }
        public Guid? ConductId { get; set; }
        public Guid? AuditRatingId { get; set; }
        public string AuditRatingName { get; set; }
        public string AuditReportName { get; set; }
        public string AuditReportDescription { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? ProjectId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        
        public bool? IsArchived { get; set; }
        public string CreatedByUserName { get; set; }
        public string CreatedByProfileImage { get; set; }
        public int QuestionsCount { get; set; }
        public int AnsweredCount { get; set; }
        public int UnAnsweredCount { get; set; }
        public float ConductScore { get; set; }
        public bool IsFromTags { get; set; }
    }
}
