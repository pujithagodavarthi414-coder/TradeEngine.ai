using System;
using System.Collections.Generic;


namespace Btrak.Models.ComplianceAudit
{
    public class AuditCategoryApiReturnModel
    {
        public AuditCategoryApiReturnModel()
        {
            SubAuditCategories = new List<AuditCategoryApiReturnModel>();
        }
        public Guid? AuditCategoryId { get; set; }
        public Guid? AuditComplianceId { get; set; }
        public string AuditCategoryName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public string ParentAuditCategoryName { get; set; }
        public string CreatedByUserName { get; set; }
        public Guid? ParentAuditCategoryId { get; set; }
        public int? CategoryLevel { get; set; }
        public List<AuditCategoryApiReturnModel> SubAuditCategories { get; set; }
        public List<AuditQuestionsApiReturnModel> Questions { get; set; }
        public string AuditCategoryDescription { get; set; }
        public int QuestionsCount { get; set; }
        public int AnsweredCount { get; set; }
        public int UnAnsweredCount { get; set; }
        public int ValidAnswersCount { get; set; }
        public int InValidAnswersCount { get; set; }
        public int ConductQuestionsCount { get; set; }
        public float ConductScore { get; set; }
        public Guid? AuditVersionId { get; set; }
        public int? Order { get; set; }
        public Guid? AuditConductCategoryId { get; set; }
    }
}
